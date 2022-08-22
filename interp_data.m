function [data] = interp_data(data)

activities= ["Inactive" "Stand" "Walk" "Stairs" "Validation"];

for I=1:length(activities) %%activities 

    for K= 1:length(data.(activities(I))) %% recordings
       
       for J= 1:2  %% left or right insole 
       clear Accel_data    
       Accel_data=data.(activities(I)){K}{1}{J}(:,:);
        
       
       [Accel_data_insterted] = insert_missing_datapoints(Accel_data);   
   
       data.(activities(I)){K}{1}{J}=Accel_data_insterted; 
       clear Accel_data Accel_data_insterted
       end 
       
       for J= 1:2  %% left or right insole 
       clear Pressure_data    
       Pressure_data=data.(activities(I)){K}{2}{J}(:,:);
        
       
       [Pressure_data_insterted] = insert_missing_datapoints_pressure(Pressure_data);   
   
       data.(activities(I)){K}{2}{J}=Pressure_data_insterted; 
       clear Pressure_data Pressure_data_insterted
             
       end
      
    end 
     
 end

end 
             
  