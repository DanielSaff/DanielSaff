function [data] = load_activity_data(no_load_both,full_load_both)


activites= ["Inactive" "Stand" "Walk" "Stairs"]; %%must be equal to definitions in dir

for I= 1:length(activites)

    dir_sit = fullfile('/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/data/pilot_data',activites(I));
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
        
        pressure_right=pressure(pressure(:,2 )==1 , : );
        pressure_left=pressure(pressure(:,2 )==2 , : );
        
        for i=1:length(full_load_both)
            id = num2str(i);
            pilot = 'Pilot';
            string_2_search = [pilot id];
                
            if contains(thisfilename,string_2_search)
                
                for j=1:length(pressure_right)
                    no_offset=sum(pressure_right(j,4:15))-no_load_both(i);
                    if no_offset<0
                        no_offset=0;
                    end
                    percentage_bw=no_offset*100/(full_load_both(i)-no_load_both(i));
                    if percentage_bw<0
                        percentage_bw=0;
                    end 
                    pressure_right(j,16)=percentage_bw;
                    
                 
                end 
                
                 for j=1:length(pressure_left)
                    no_offset=sum(pressure_left(j,4:15))-no_load_both(i);
                    if no_offset<0
                        no_offset=0;
                    end
                        
                    percentage_bw=no_offset*100/(full_load_both(i)-no_load_both(i));
                    if percentage_bw<0
                        percentage_bw=0;
                    end 
                    
                    pressure_left(j,16)=percentage_bw;
                end 
                
            end     
            
        end 
        
        %%separate left and right insole
       
        data.(activites(I)){K}{1}{1}=accel(accel(:,2 )==1 , : ); 
        data.(activites(I)){K}{1}{2}=accel(accel(:,2 )==2 , : );
        
       
        data.(activites(I)){K}{2}{1}=pressure_right;
        data.(activites(I)){K}{2}{2}=pressure_left;
        clear pressure_right pressure_left
        
     

    end

end 

cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/matlab_functions';

end 