function [Features_IMU] = calculate_features_IMU(data, window_size)

feature_count=1; 


activites= ["Inactive" "Stand" "Walk" "Stairs" "Validation"];

for I=1:length(activites) %%for activity 

    for K= 1:length(data.(activites(I))) %for recording 
     
      
      %%set timewindows for initial window
      time_window_start=data.(activites(I)){K}{3}{1}(1,2);
      end_time=data.(activites(I)){K}{3}{1}(end,2);
      %%set end of recording
      time_window_end=time_window_start+1000*window_size;
      
      while time_window_end<end_time
          
          time_window_end=time_window_start+1000*window_size;
          
          %% values within timewindow
          IMU_right=data.(activites(I)){K}{3}{1}(data.(activites(I)){K}{3}{1}(:,2)>time_window_start  & data.(activites(I)){K}{3}{1}(:,2)< time_window_end,:);
          IMU_left=data.(activites(I)){K}{3}{2}(data.(activites(I)){K}{3}{2}(:,2)>time_window_start  & data.(activites(I)){K}{3}{2}(:,2)< time_window_end,:);
          
%           x=[1:100]
%           IMU_righ_inter = interp1(IMU_right(:,6),x)
%           IMU_left_inter = interp1(IMU_left(:,6),x)
%           
%           plot(IMU_right(:,6))
%           hold on 
%           plot(IMU_righ_inter)

          %%resulting accel 
            for J=1:length(IMU_right)
                resulting_right(J)=sqrt(IMU_right(J,6)^2+IMU_right(J,7)^2+IMU_right(J,8)^2);
            end 
          
            for J=1:length(IMU_left)
                resulting_left(J)=sqrt(IMU_left(J,6)^2+IMU_left(J,7)^2+IMU_left(J,8)^2);
            end   
         
          %% Max Values Accel x,y,z right
            Features_IMU.Max_Accel_Right_x(feature_count,1)=max(IMU_right(:,6));
            Features_IMU.Max_Accel_Right_y(feature_count,1)=max(IMU_right(:,7));
            Features_IMU.Max_Accel_Right_z(feature_count,1)=max(IMU_right(:,8));
          
          %% Max Values Accel x,y,z left
            Features_IMU.Max_Accel_Left_x(feature_count,1)=max(IMU_left(:,6));
            Features_IMU.Max_Accel_Left_y(feature_count,1)=max(IMU_left(:,7));
            Features_IMU.Max_Accel_Left_z(feature_count,1)=max(IMU_left(:,8));
            
          %% Max Values Accel x,y,z res left & right
            Features_IMU.Max_resulting_right(feature_count,1)=max(resulting_right);
            Features_IMU.Max_resulting_left(feature_count,1)=max(resulting_left);  
          
          %% Min Values Accel x,y,z right
            Features_IMU.Min_Accel_Right_x(feature_count,1)=min(IMU_right(:,6));
            Features_IMU.Min_Accel_Right_y(feature_count,1)=min(IMU_right(:,7));
            Features_IMU.Min_Accel_Right_z(feature_count,1)=min(IMU_right(:,8));
          
          %% Min Values Accel x,y,z left
            Features_IMU.Min_Accel_Left_x(feature_count,1)=min(IMU_left(:,6));
            Features_IMU.Min_Accel_Left_y(feature_count,1)=min(IMU_left(:,7));
            Features_IMU.Min_Accel_Left_z(feature_count,1)=min(IMU_left(:,8));
            
          %% Min Values Accel x,y,z res left & right
            Features_IMU.Min_resulting_right(feature_count,1)=min(resulting_right);
            Features_IMU.Min_resulting_left(feature_count,1)=min(resulting_left); 
          
          
          %% Std Values Accel x, y, z, right
            Features_IMU.Std_Accel_Right_x(feature_count,1)=std(IMU_right(:,6));
            Features_IMU.Std_Accel_Right_y(feature_count,1)=std(IMU_right(:,7));
            Features_IMU.Std_Accel_Right_z(feature_count,1)=std(IMU_right(:,8));
          
          %% Std Values Accel x, y, z, left
            Features_IMU.Std_Accel_Left_x(feature_count,1)=std(IMU_left(:,6));
            Features_IMU.Std_Accel_Left_y(feature_count,1)=std(IMU_left(:,7));
            Features_IMU.Std_Accel_Left_z(feature_count,1)=std(IMU_left(:,8));
            
          %% Std Values Accel x,y,z res left & right
            Features_IMU.Std_resulting_right(feature_count,1)=std(resulting_right);
            Features_IMU.Std_resulting_left(feature_count,1)=std(resulting_left); 
            
          %% Mean Values Accel x,y,z right
            Features_IMU.Mean_Accel_Right_x(feature_count,1)=mean(IMU_right(:,6));
            Features_IMU.Mean_Accel_Right_y(feature_count,1)=mean(IMU_right(:,7));
            Features_IMU.Mean_Accel_Right_z(feature_count,1)=mean(IMU_right(:,8));
            
          %% Mean Values Accel x,y,z left
            Features_IMU.Mean_Accel_Left_x(feature_count,1)=mean(IMU_left(:,6));
            Features_IMU.Mean_Accel_Left_y(feature_count,1)=mean(IMU_left(:,7));
            Features_IMU.Mean_Accel_Left_z(feature_count,1)=mean(IMU_left(:,8));
            
          %% Mean Values Accel x,y,z res left & right
            Features_IMU.Mean_resulting_right(feature_count,1)=mean(resulting_right);
            Features_IMU.Mean_resulting_left(feature_count,1)=mean(resulting_left); 
            
          %%Median Values Accel x,y,z right
            Features_IMU.Median_Accel_Right_x(feature_count,1)=median(IMU_right(:,6));
            Features_IMU.Median_Accel_Right_y(feature_count,1)=median(IMU_right(:,7));
            Features_IMU.Median_Accel_Right_z(feature_count,1)=median(IMU_right(:,8));
            
          %%Median Values Accel x,y,z left
            Features_IMU.Median_Accel_Left_x(feature_count,1)=median(IMU_left(:,6));
            Features_IMU.Median_Accel_Left_y(feature_count,1)=median(IMU_left(:,7));
            Features_IMU.Median_Accel_Left_z(feature_count,1)=median(IMU_left(:,8));
            
          %% Median Values Accel x,y,z res left & right
            Features_IMU.Median_resulting_right(feature_count,1)=median(resulting_right);
            Features_IMU.Median_resulting_left(feature_count,1)=median(resulting_left); 
            
            Features_IMU.Mean_Mean_Accel_Left_right(feature_count,1)=(mean(resulting_right)+mean(resulting_left))/2;
            Features_IMU.Mean_Std_Accel_Left_right(feature_count,1)=(std(resulting_right)+std(resulting_left))/2;
         
          
            clear resulting_right resulting_left
            
           
          
            %% Set Class of Activity
            Features_IMU.Class(feature_count,1)=I;
            
            %% Set Group
            Features_IMU.Patient_group(feature_count,1)=IMU_left(1,13);
          
            feature_count=feature_count+1;
          
          
          
          %% Set new Timewindow
          time_window_start=time_window_end;
          time_window_end=time_window_start+1000*window_size;
          
          
          
      end 
      

    end
end


end

