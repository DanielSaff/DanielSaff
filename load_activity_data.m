function [data] = load_activity_data(no_load_both,full_load_both)


activites= ["Inactive" "Stand" "Walk" "Stairs" "Validation"]; %%must be equal to definitions in dir

for I= 1:length(activites)

    dir_sit = fullfile('/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/data/patient_data_v2.0',activites(I));
    dinfo_activity = dir(dir_sit);
    
    dinfo_activity=dinfo_activity(~ismember({dinfo_activity.name},{'.','..','.DS_Store'})); %delete useless information in dinfo_activity

    for K = 1 : length(dinfo_activity)
        thisfilename = fullfile(dir_sit, dinfo_activity(K).name);  %directory of activity folder 
        %%load accel files
        cd (thisfilename);
        listing=dir('*acceleration.csv*');
        accel=readmatrix(listing.name);
        %%load pressure files 
        listing=dir('*pressure.csv*');
        pressure=readmatrix(listing.name);
        %%load XSens Dot right
        listing=dir('*DOT_1*');
        IMU_right=readmatrix(listing.name);
        %%load XSens Dot left
        listing=dir('*DOT_2*');
        IMU_left=readmatrix(listing.name);
        
        %%extract time out of filename
        str =listing.name
        
        year= extractBetween(str,25,28);
        year=str2num(cell2mat(year));
        
        month= extractBetween(str,29,30);
        month=str2num(cell2mat(month));
        
        day= extractBetween(str,31,32);
        day=str2num(cell2mat(day));
        
        %%correct time shift
        hour= extractBetween(str,34,35);
        if month==3 
            hour=str2num(cell2mat(hour))-1;
        elseif month==4
            hour=str2num(cell2mat(hour))-2;
        end 
        
        minute =  extractBetween(str,36,37);
        minute=str2num(cell2mat(minute));
        
        second= extractBetween(str,38,39);
        second=str2num(cell2mat(second));
        
        %create data vector
         
        DateVector = [year,month,day,hour,minute,second];
        
        
        test=datestr(DateVector);
        test2=datetime(test);
        
        UNIX_timestamp=posixtime(test2);
        UNIX_timestamp_DOTS=(UNIX_timestamp*1000);
        
        
        pressure_right=pressure(pressure(:,2 )==1 , : );
        pressure_left=pressure(pressure(:,2 )==2 , : );
        
        
        
        
       for i=1:length(full_load_both) %for patient
            id = num2str(i+1);
            patient = 'Patient';
            string_2_search = [patient id];
                
            if contains(thisfilename,string_2_search)
                
                %set patient id for k-fold validation
                accel(:,7)=i;
                pressure_right(:,17)=i;
                pressure_left(:,17)=i;
                
                IMU_left(:,13)=i;
                IMU_right(:,13)=i;
                
                %%normalize data right
                for j=1:length(pressure_right) %for sampling
                    
                    for k=4:15 %for sensor
                        pressure_right(j,k)=pressure_right(j,k)-no_load_both{i}(1,k-3); %%minus no load right
                    
                        if pressure_right(j,k)<0
                            pressure_right(j,k)=0;
                        end
                    
                    
                        pressure_right(j,k)=pressure_right(j,k)*100/(full_load_both{i}(1,k-3)-no_load_both{i}(1,k-3)); %after no load in percentage to full load
                        
         
                    end
                    
                    pressure_right(j,16)=mean(pressure_right(j,4:15));
                 
                end 
                
                
                %%normlaize data left
                for j=1:length(pressure_left) %for sampling
                    
                    for k=4:15 %for sensor
                        pressure_left(j,k)=pressure_left(j,k)-no_load_both{i}(2,k-3); %%minus no load left
                    
                        if pressure_left(j,k)<0
                            pressure_left(j,k)=0;
                        end
                    
                    
                        pressure_left(j,k)=pressure_left(j,k)*100/(full_load_both{i}(2,k-3)-no_load_both{i}(2,k-3)); %after no load in percentage to full load
                        
         
                    end
                    
                    pressure_left(j,16)=mean(pressure_left(j,4:15));
                 
                end 
                
            end     
            
       end 

        
        
       %%separate left and right insole
       accel_right=accel(accel(:,2 )==1 , : );
       accel_left=accel(accel(:,2)==2,:);
       
       
       %%use ginput to remove data which is not in the correct activity
        %%class
        
            cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/matlab_functions';
            [beginning, ending, IMU_left, IMU_right] = remove_wrong_activity_data_test(accel_right,accel_left,IMU_right, IMU_left, I,UNIX_timestamp_DOTS);   
            
            if (beginning < 100 || isempty(beginning))
          
            else
                
            accel=accel(accel(:,3) > beginning & accel(:,3) < ending, :); 
            
            end
            
            
            if (beginning <100 || isempty(beginning))
            
            IMU_left(:,3)=IMU_left(1,3); %%edge case for a single sample -> leads to exclusion of this data
            IMU_right(:,3)=IMU_right(1,3); %%edge case for a single sample -> leads to exclusion of this data
                
            else
                
            IMU_left=IMU_left(IMU_left(:,2) > beginning & IMU_left(:,2) < ending, :); 
            IMU_right=IMU_right(IMU_right(:,2) > beginning & IMU_right(:,2) < ending, :); 
            
            end 
            
        
        %safe accel data in struct
        data.(activites(I)){K}{1}{1}=accel(accel(:,2 )==1 , : );
        data.(activites(I)){K}{1}{2}=accel(accel(:,2)==2,:);
        
        %safe pressure data in struct
        data.(activites(I)){K}{2}{1}=pressure_right;
        data.(activites(I)){K}{2}{2}=pressure_left;
        
        %safe IMU data in struct
        data.(activites(I)){K}{3}{1}=IMU_right;
        data.(activites(I)){K}{3}{2}=IMU_left;
        
        clear pressure_right pressure_left IMU_right IMU_left
        
     

    end

end 

cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/matlab_functions';

end