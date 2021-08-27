function [Features] = calculate_features(data, window_size)

feature_count=1; 


activites= ["Inactive" "Stand" "Walk" "Stairs"];

for I=1:length(activites) %%for activity 

    for K= 1:length(data.(activites(I))) %for recording 

      %%find start and end point of activity
      start_time(1)=data.(activites(I)){K}{1}{1}(1,3); 
      start_time(2)=data.(activites(I)){K}{1}{2}(1,3); 
      start_time(3)=data.(activites(I)){K}{2}{1}(1,3);
      start_time(4)=data.(activites(I)){K}{2}{2}(1,3);
      
      end_time(1)=data.(activites(I)){K}{1}{1}(end,3);
      end_time(2)=data.(activites(I)){K}{1}{2}(end,3);
      end_time(3)=data.(activites(I)){K}{2}{1}(end,3);
      end_time(4)=data.(activites(I)){K}{2}{2}(end,3);
        
      start_time=max(start_time);
      end_time=min(end_time);
      
      %%set timewindows for initial window
      time_window_start=start_time;
      %%set end of recording
      time_window_end=time_window_start+window_size*1000;
      
      while time_window_end<end_time
          
          time_window_end=time_window_start+window_size*1000;
          
          
          %%accel values within timewindow
          Accel_right=data.(activites(I)){K}{1}{1}(data.(activites(I)){K}{1}{1}(:,3)>time_window_start  & data.(activites(I)){K}{1}{1}(:,3)< time_window_end,:);
          Accel_left=data.(activites(I)){K}{1}{2}(data.(activites(I)){K}{1}{2}(:,3)>time_window_start  & data.(activites(I)){K}{1}{2}(:,3)< time_window_end,:);
          
          %%pressure values within timewindow 
          Pressure_right=data.(activites(I)){K}{2}{1}(data.(activites(I)){K}{2}{1}(:,3)>time_window_start  & data.(activites(I)){K}{2}{1}(:,3)< time_window_end,:);
          Pressure_left=data.(activites(I)){K}{2}{2}(data.(activites(I)){K}{2}{2}(:,3)>time_window_start  & data.(activites(I)){K}{2}{2}(:,3)< time_window_end,:);
          
          %%calc Features here:
          entries_to_expect= window_size*80;
         
          if length(Accel_left)>entries_to_expect &&  length(Accel_right)>entries_to_expect && length(Pressure_left)> entries_to_expect && length(Pressure_right)>entries_to_expect
         
            %% Max Values Accel x,y,z right
            Features.Max_Accel_Right_x(feature_count,1)=max(Accel_right(:,4));
            Features.Max_Accel_Right_y(feature_count,1)=max(Accel_right(:,5));
            Features.Max_Accel_Right_z(feature_count,1)=max(Accel_right(:,6));
          
            %% Max Values Accel x,y,z left
            Features.Max_Accel_Left_x(feature_count,1)=max(Accel_left(:,4));
            Features.Max_Accel_Left_y(feature_count,1)=max(Accel_left(:,5));
            Features.Max_Accel_Left_z(feature_count,1)=max(Accel_left(:,6));
          
          
            %% Min Values Accel x,y,z right
            Features.Min_Accel_Right_x(feature_count,1)=min(Accel_right(:,4));
            Features.Min_Accel_Right_y(feature_count,1)=min(Accel_right(:,5));
            Features.Min_Accel_Right_z(feature_count,1)=min(Accel_right(:,6));
          
            %% Min Values Accel x,y,z left
            Features.Min_Accel_Left_x(feature_count,1)=min(Accel_left(:,4));
            Features.Min_Accel_Left_y(feature_count,1)=min(Accel_left(:,5));
            Features.Min_Accel_Left_z(feature_count,1)=min(Accel_left(:,6));
          
          
            %% Std Values Accel x, y, z, right
            Features.Std_Accel_Right_x(feature_count,1)=std(Accel_right(:,4));
            Features.Std_Accel_Right_y(feature_count,1)=std(Accel_right(:,5));
            Features.Std_Accel_Right_z(feature_count,1)=std(Accel_right(:,6));
          
          
            %% Std Values Accel x, y, z, left
            Features.Std_Accel_Left_x(feature_count,1)=std(Accel_left(:,4));
            Features.Std_Accel_Left_y(feature_count,1)=std(Accel_left(:,5));
            Features.Std_Accel_Left_z(feature_count,1)=std(Accel_left(:,6));
            
            %% Mean Values Accel x,y,z right
            Features.Mean_Accel_Right_x(feature_count,1)=mean(Accel_right(:,4));
            Features.Mean_Accel_Right_y(feature_count,1)=mean(Accel_right(:,5));
            Features.Mean_Accel_Right_z(feature_count,1)=mean(Accel_right(:,6));
            
            
            %% Mean Values Accel x,y,z left
            Features.Mean_Accel_Left_x(feature_count,1)=mean(Accel_left(:,4));
            Features.Mean_Accel_Left_y(feature_count,1)=mean(Accel_left(:,5));
            Features.Mean_Accel_Left_z(feature_count,1)=mean(Accel_left(:,6));
            
            %%Median Values Accel x,y,z right
            Features.Median_Accel_Right_x(feature_count,1)=median(Accel_right(:,4));
            Features.Median_Accel_Right_y(feature_count,1)=median(Accel_right(:,5));
            Features.Median_Accel_Right_z(feature_count,1)=median(Accel_right(:,6));
            
            %%Median Values Accel x,y,z left
            Features.Median_Accel_Left_x(feature_count,1)=median(Accel_left(:,4));
            Features.Median_Accel_Left_y(feature_count,1)=median(Accel_left(:,5));
            Features.Median_Accel_Left_z(feature_count,1)=median(Accel_left(:,6));
            
          
            %%resulting accel 
            for J=1:length(Accel_right)
                resulting_right(J)=sqrt(Accel_right(J,4)^2+Accel_right(J,5)^2+Accel_right(J,6)^2);
            end 
          
            for J=1:length(Accel_left)
                resulting_left(J)=sqrt(Accel_left(J,4)^2+Accel_left(J,5)^2+Accel_left(J,6)^2);
            end 
          
            %%%fft analysis 
           
            fft_accel_right=fft(resulting_right);
          
            fft_accel_right=fft_accel_right/length(fft_accel_right);

            nyquist=length(resulting_right)/2+1;
          
            fft_accel_right=fft_accel_right(1:round(nyquist));
          
            Features.fft_right_1(feature_count,1)=abs(fft_accel_right(1));
            Features.fft_right_2(feature_count,1)=abs(fft_accel_right(2));
            Features.fft_right_3(feature_count,1)=abs(fft_accel_right(3));
            Features.fft_right_4(feature_count,1)=abs(fft_accel_right(4));
            Features.fft_right_5(feature_count,1)=abs(fft_accel_right(5));
  
            %% Mean Mean Accel (left and right)
            Features.Mean_Mean_Accel_Left_right(feature_count,1)=(mean(resulting_right)+mean(resulting_left))/2;
            Features.Mean_Std_Accel_Left_right(feature_count,1)=(std(resulting_right)+std(resulting_left))/2;
          
            clear resulting_right resulting_left
          
            %% Mean Mean Pressure (left and right)
              
        
            sum_right=Pressure_right(:,16);
            sum_left=Pressure_left(:,16);
            
          
          
           
            Features.Mean_Mean_Pressure_Left_right(feature_count,1)=(mean(sum_right)+mean(sum_left))/2;
            Features.Mean_Std_Pressure_Left_right(feature_count,1)=(std(sum_right)+std(sum_left))/2;
          
            clear sum_right sum_left
          
            %% Set Class of Activity
            Features.Class(feature_count,1)=I;
          
            feature_count=feature_count+1;
          
          end 
          
          %% Set new Timewindow
          time_window_start=time_window_end;
          time_window_end=time_window_start+window_size*1000;
          
          
          
      end 
      

    end
end


end

