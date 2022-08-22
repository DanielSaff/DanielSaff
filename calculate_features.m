function [Features] = calculate_features(data, window_size)

feature_count=1; 
loss=0;

activites= ["Inactive" "Stand" "Walk" "Stairs" "Validation"];

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
          entries_to_expect= window_size*75;
         
          if length(Accel_left)>entries_to_expect &&  length(Accel_right)>entries_to_expect && length(Pressure_left)> entries_to_expect && length(Pressure_right)>entries_to_expect
            
              
            %%resulting accel 
            for J=1:length(Accel_right)
                resulting_right(J)=sqrt(Accel_right(J,4)^2+Accel_right(J,5)^2+Accel_right(J,6)^2);
            end 
          
            for J=1:length(Accel_left)
                resulting_left(J)=sqrt(Accel_left(J,4)^2+Accel_left(J,5)^2+Accel_left(J,6)^2);
            end   
            
           
            %% Mean Mean Pressure (left and right)
            sum_right=Pressure_right(:,16);
            sum_left=Pressure_left(:,16);
            
            %toes, midfoot, heel right
            for J=1:length(Pressure_right)
                
                toes_right(J)=mean(Pressure_right(J,[4,15]));
                midfoot_right(J)=mean(Pressure_right(J,[5,6,7,8,9,10,12]));
                heel_right(J)=mean(Pressure_right(J,[11,13,14]));
                
            end 
            
            %toes, midfoot, heel left
            for J=1:length(Pressure_left)
                
                toes_left(J)=mean(Pressure_left(J,[4,15]));
                midfoot_left(J)=mean(Pressure_left(J,[5,6,7,8,9,10,12]));
                heel_left(J)=mean(Pressure_left(J,[11,13,14]));
                
            end 
            
              %% Forefoot Backfoot ratio right
            
            for J=1:length(Pressure_right)
                
                forefoot_right=sum(Pressure_right(J,[4,5,7,8,9,12,15]));
                backfoot_right=sum(Pressure_right(J,[6,10,11,13,14]));
                
                Fore_Back_Ratio_Right(J)=(1-(forefoot_right/backfoot_right))*100;
            end 
            
           
            
            
            
            %% Forefoot Backfoot ratio left
             for J=1:length(Pressure_left)
                
                forefoot_left=sum(Pressure_left(J,[4,5,7,8,9,12,15]));
                backfoot_left=sum(Pressure_left(J,[6,10,11,13,14]));
                
                Fore_Back_Ratio_Left(J)=(1-(forefoot_left/backfoot_left))*100;
            end 
            
            
              
            %% Max Values Accel x,y,z right
            Features.Max_Accel_Right_x(feature_count,1)=max(Accel_right(:,4));
            Features.Max_Accel_Right_y(feature_count,1)=max(Accel_right(:,5));
            Features.Max_Accel_Right_z(feature_count,1)=max(Accel_right(:,6));
          
            %% Max Values Accel x,y,z left
            Features.Max_Accel_Left_x(feature_count,1)=max(Accel_left(:,4));
            Features.Max_Accel_Left_y(feature_count,1)=max(Accel_left(:,5));
            Features.Max_Accel_Left_z(feature_count,1)=max(Accel_left(:,6));
            
            %% Max Values Accel x,y,z res left & right
            Features.Max_resulting_right(feature_count,1)=max(resulting_right(:,1));
            Features.Max_resulting_left(feature_count,1)=max(resulting_left(:,1));
           
            %% Max Values sum Pressure left & right
            Features.Max_pressure_right(feature_count,1)=max(sum_right(:,1));
            Features.Max_pressure_left(feature_count,1)=max(sum_left(:,1));
            
            %% Max Values toes, midfoot, heel
            Features.Max_pressure_toes_right(feature_count,1)=max(toes_right);
            Features.Max_pressure_midfoot_right(feature_count,1)=max(midfoot_right);
            Features.Max_pressure_heel_right(feature_count,1)=max(midfoot_right);
            
            Features.Max_pressure_toes_left(feature_count,1)=max(toes_left);
            Features.Max_pressure_midfoot_left(feature_count,1)=max(midfoot_left);
            Features.Max_pressure_heel_left(feature_count,1)=max(heel_left);
           
            %% Max forefoot Backfoot
            
            Features.Max_Fore_Back_Ratio_right(feature_count,1)=max(Fore_Back_Ratio_Right);
            Features.Max_Fore_Back_Ratio_left(feature_count,1)=max(Fore_Back_Ratio_Left);
        
          
            %% Min Values Accel x,y,z right
            Features.Min_Accel_Right_x(feature_count,1)=min(Accel_right(:,4));
            Features.Min_Accel_Right_y(feature_count,1)=min(Accel_right(:,5));
            Features.Min_Accel_Right_z(feature_count,1)=min(Accel_right(:,6));
          
            %% Min Values Accel x,y,z left
            Features.Min_Accel_Left_x(feature_count,1)=min(Accel_left(:,4));
            Features.Min_Accel_Left_y(feature_count,1)=min(Accel_left(:,5));
            Features.Min_Accel_Left_z(feature_count,1)=min(Accel_left(:,6));
            
            %% Min Values Accel x,y,z res left & right
            Features.Min_resulting_right(feature_count,1)=min(resulting_right(:,1));
            Features.Min_resulting_left(feature_count,1)=min(resulting_left(:,1));
          
            %% Min Values sum Pressure left & right
            Features.Min_pressure_right(feature_count,1)=min(sum_right(:,1));
            Features.Min_pressure_left(feature_count,1)=min(sum_left(:,1));
            
            %% Min Values toes, midfoot, heel
            Features.Min_pressure_toes_right(feature_count,1)=min(toes_right);
            Features.Min_pressure_midfoot_right(feature_count,1)=min(midfoot_right);
            Features.Min_pressure_heel_right(feature_count,1)=min(midfoot_right);
            
            Features.Min_pressure_toes_left(feature_count,1)=min(toes_left);
            Features.Min_pressure_midfoot_left(feature_count,1)=min(midfoot_left);
            Features.Min_pressure_heel_left(feature_count,1)=min(heel_left);
            
            %% Min forefoot Backfoot
            
            Features.Min_Fore_Back_Ratio_right(feature_count,1)=min(Fore_Back_Ratio_Right);
            Features.Min_Fore_Back_Ratio_left(feature_count,1)=min(Fore_Back_Ratio_Left);
            
            %% Std Values Accel x, y, z, right
            Features.Std_Accel_Right_x(feature_count,1)=std(Accel_right(:,4));
            Features.Std_Accel_Right_y(feature_count,1)=std(Accel_right(:,5));
            Features.Std_Accel_Right_z(feature_count,1)=std(Accel_right(:,6));
          
            %% Std Values Accel x, y, z, left
            Features.Std_Accel_Left_x(feature_count,1)=std(Accel_left(:,4));
            Features.Std_Accel_Left_y(feature_count,1)=std(Accel_left(:,5));
            Features.Std_Accel_Left_z(feature_count,1)=std(Accel_left(:,6));
            
            %% Std Values Accel x,y,z res left & right
            Features.Std_resulting_right(feature_count,1)=std(resulting_right(:,1));
            Features.Std_resulting_left(feature_count,1)=std(resulting_left(:,1));
            
            %% Std Values sum Pressure left & right
            Features.Std_pressure_right(feature_count,1)=std(sum_right(:,1));
            Features.Std_pressure_left(feature_count,1)=std(sum_left(:,1));
            
            %% Std Values toes, midfoot, heel
            Features.Std_pressure_toes_right(feature_count,1)=std(toes_right);
            Features.Std_pressure_midfoot_right(feature_count,1)=std(midfoot_right);
            Features.Std_pressure_heel_right(feature_count,1)=std(midfoot_right);
            
            Features.Std_pressure_toes_left(feature_count,1)=std(toes_left);
            Features.Std_pressure_midfoot_left(feature_count,1)=std(midfoot_left);
            Features.Std_pressure_heel_left(feature_count,1)=std(heel_left);
            
            
            %% Std forefoot Backfoot
            
            Features.Std_Fore_Back_Ratio_right(feature_count,1)=std(Fore_Back_Ratio_Right);
            Features.Std_Fore_Back_Ratio_left(feature_count,1)=std(Fore_Back_Ratio_Left);
            
            %% Mean Values Accel x,y,z right
            Features.Mean_Accel_Right_x(feature_count,1)=mean(Accel_right(:,4));
            Features.Mean_Accel_Right_y(feature_count,1)=mean(Accel_right(:,5));
            Features.Mean_Accel_Right_z(feature_count,1)=mean(Accel_right(:,6));
            
            %% Mean Values Accel x,y,z left
            Features.Mean_Accel_Left_x(feature_count,1)=mean(Accel_left(:,4));
            Features.Mean_Accel_Left_y(feature_count,1)=mean(Accel_left(:,5));
            Features.Mean_Accel_Left_z(feature_count,1)=mean(Accel_left(:,6));
            
            %% Mean Values Accel x,y,z res left & right
            Features.Mean_resulting_right(feature_count,1)=mean(resulting_right(:,1));
            Features.Mean_resulting_left(feature_count,1)=mean(resulting_left(:,1));
            
            %% Mean Values sum Pressure left & right
            Features.Mean_pressure_right(feature_count,1)=mean(sum_right(:,1));
            Features.Mean_pressure_left(feature_count,1)=mean(sum_left(:,1));
            
            %% Mean Values toes, midfoot, heel
            Features.Mean_pressure_toes_right(feature_count,1)=mean(toes_right);
            Features.Mean_pressure_midfoot_right(feature_count,1)=mean(midfoot_right);
            Features.Mean_pressure_heel_right(feature_count,1)=mean(midfoot_right);
            
            Features.Mean_pressure_toes_left(feature_count,1)=mean(toes_left);
            Features.Mean_pressure_midfoot_left(feature_count,1)=mean(midfoot_left);
            Features.Mean_pressure_heel_left(feature_count,1)=mean(heel_left);
            
            %% Std forefoot Backfoot
            
            Features.Mean_Fore_Back_Ratio_right(feature_count,1)=mean(Fore_Back_Ratio_Right);
            Features.Mean_Fore_Back_Ratio_left(feature_count,1)=mean(Fore_Back_Ratio_Left);
            
            %%Median Values Accel x,y,z right
            Features.Median_Accel_Right_x(feature_count,1)=median(Accel_right(:,4));
            Features.Median_Accel_Right_y(feature_count,1)=median(Accel_right(:,5));
            Features.Median_Accel_Right_z(feature_count,1)=median(Accel_right(:,6));
            
            %%Median Values Accel x,y,z left
            Features.Median_Accel_Left_x(feature_count,1)=median(Accel_left(:,4));
            Features.Median_Accel_Left_y(feature_count,1)=median(Accel_left(:,5));
            Features.Median_Accel_Left_z(feature_count,1)=median(Accel_left(:,6));
            
            %% Median Values Accel x,y,z res left & right
            Features.Median_resulting_right(feature_count,1)=median(resulting_right(:,1));
            Features.Median_resulting_left(feature_count,1)=median(resulting_left(:,1));
            
            %% Median Values sum Pressure left & right
            Features.Median_pressure_right(feature_count,1)=median(sum_right(:,1));
            Features.Median_pressure_left(feature_count,1)=median(sum_left(:,1));
            
            %% Median Values toes, midfoot, heel
            Features.Median_pressure_toes_right(feature_count,1)=median(toes_right);
            Features.Median_pressure_midfoot_right(feature_count,1)=median(midfoot_right);
            Features.Median_pressure_heel_right(feature_count,1)=median(midfoot_right);
            
            Features.Median_pressure_toes_left(feature_count,1)=median(toes_left);
            Features.Median_pressure_midfoot_left(feature_count,1)=median(midfoot_left);
            Features.Median_pressure_heel_left(feature_count,1)=median(heel_left);
            
            %% Std forefoot Backfoot
            
            Features.Median_Fore_Back_Ratio_right(feature_count,1)=median(Fore_Back_Ratio_Right);
            Features.Median_Fore_Back_Ratio_left(feature_count,1)=median(Fore_Back_Ratio_Left);
            
            %% Mean Mean Accel (left and right)
            Features.Mean_Mean_Accel_Left_right(feature_count,1)=(mean(resulting_right)+mean(resulting_left))/2;
            Features.Mean_Std_Accel_Left_right(feature_count,1)=(std(resulting_right)+std(resulting_left))/2;
            
            clear resulting_right resulting_left


           
            %% Mean Mean Pressure (left and right)

            
            Features.Mean_Mean_Pressure_Left_right(feature_count,1)=(mean(sum_right)+mean(sum_left))/2;
            Features.Mean_Std_Pressure_Left_right(feature_count,1)=(std(sum_right)+std(sum_left))/2;
          
            clear sum_right sum_left
            
            
          
            
            %% Set Class of Activity
            Features.Class(feature_count,1)=I;
            
            %% Set Group
            Features.Patient_group(feature_count,1)=Accel_left(1,7);
            
          
            feature_count=feature_count+1;
          else  
            loss=loss+1
          end 
          
          %% Set new Timewindow
          time_window_start=time_window_end;
          time_window_end=time_window_start+window_size*1000;
          
          
          
      end 
      

    end
end


end

