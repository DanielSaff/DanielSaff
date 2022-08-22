function [no_load_both] = determine_no_load(dinfo_activity_no_load,dir_no_load,K)

        thisfilename = fullfile(dir_no_load, dinfo_activity_no_load(K).name);  %directory of activity folder 
        %%load accel files
        cd (thisfilename);
        
        %%load pressure files 
        listing=dir('*pressure.csv*');
        pressure=readmatrix(listing.name);

        %%separate left and right insole
        pressure_data_right=pressure(pressure(:,2 )==1 , : );
        pressure_data_left=pressure(pressure(:,2 )==2 , : );
        
        %%build presure sum for right insole
        for i=4:15
        all_sensors_right(i-3)=mean(pressure_data_right(:,i)); 
        end 
        
        %%build pressure sum for left insole 
        for i=4:15
        all_sensors_left(i-3)=mean(pressure_data_left(:,i)); 
        end 
        
        %%calculate combined mean value 
        no_load_both(1,:)=all_sensors_right;
        no_load_both(2,:)=all_sensors_left;
end

