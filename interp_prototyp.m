function [data] = interp_data(data)
clear

load('inter_test.mat')

data_right=acceleration_interp_test(acceleration_interp_test(:,2 )==1 , : ); 
%data_left=acceleration_interp_test(acceleration_interp_test(:,2 )==2 , : );
timestamp_diff=diff(data_right(:,3));

i=1;

while i<length(data_right)

    
    timestamp_diff=diff(data_right(:,3));
    
    if timestamp_diff(i)>19.4 && timestamp_diff(i)<21.5
        
        clf 
        x=data_right(i-10:i+10,3);
        y=data_right(i-10:i+10,4);
        xq= round(data_right(i,3)+ ((data_right(i+1,3)-data_right(i,3))/2));
        insert=interp1(x,y,xq);
       
        %%insert data
        intermediate(1:i,:)=data_right(1:i,:);
        intermediate(i+1,:)=zeros; 
        intermediate(i+1,4)=insert;
        intermediate(i+1,3)=xq; 
        intermediate(i+2:length(data_right)+1,:)=(data_right(i+1:end,:));
        
        data_right=intermediate; 
 
        
    end
    i=i+1; 
end

clf;
timestamp_diff2=diff(data_right(:,3));

histogram(timestamp_diff2)


end

