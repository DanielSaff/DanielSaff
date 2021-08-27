function  [full_load_both] = determine_full_load(dinfo_activity_full_load,dir_full_load,K)


        thisfilename = fullfile(dir_full_load, dinfo_activity_full_load(K).name);  %directory of activity folder 
        %%load accel files
        cd (thisfilename);
        
        %%load pressure files 
        listing=dir('*pressure.csv*');
        pressure=readmatrix(listing.name);

        %%separate left and right insole
        pressure_data_right=pressure(pressure(:,2 )==1 , : );
        pressure_data_left=pressure(pressure(:,2 )==2 , : );
        
        %%build presure sum for right insole
        for i=1:length(pressure_data_right)
        all_sensors_right(i)=sum(pressure_data_right(i,4:15)); 
        end 
        
        %%build pressure sum for left insole 
        for i=1:length(pressure_data_left)
        all_sensors_left(i)=sum(pressure_data_left(i,4:15)); 
        end 
        
        %%calculate mean value of right insole  
        full_load_right=mean(all_sensors_right(:));
        
        %%calculate mean value of left insole  
        full_load_left=mean(all_sensors_left(:)); 
        
        %%calculate combined mean value 
        full_load_both=(full_load_right+full_load_left)/2;
        
end

