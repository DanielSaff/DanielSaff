function [Accel_data_insterted] = insert_missing_datapoints(Accel_data)
        


        clearvars -except Accel_data
        i=1;
        
        while i<length(Accel_data)

             timestamp_diff=diff(Accel_data(:,3));

                   if timestamp_diff(i)>19.4 && timestamp_diff(i)<22

                        for c=4:6
                            x=Accel_data(i:i+1,3);
                            y=Accel_data(i:i+1,c);
                            xq= round(Accel_data(i,3) + ((Accel_data(i+1,3) - Accel_data(i,3))/2));
                            insert_accel(1,c)=interp1(x,y,xq); %%linear interpolation
                            insert_accel(1,3)=xq;   
                            insert_accel(1,7)=Accel_data(i,7);
                        end 
                            %%insert data
                            intermediate_accel_start(:,:)=Accel_data(1:i,:);
                            intermediate_accel_end(:,:)=Accel_data(i+1:end,:);
                            intermediate_accel= [intermediate_accel_start ; insert_accel ; intermediate_accel_end];

                            Accel_data=intermediate_accel;
                            
                            
                            [Accel_data] = insert_missing_datapoints(Accel_data);
                            

                   end
                 
             i=i+1; 
             
             
        end
         
        Accel_data_insterted=Accel_data; 
end

