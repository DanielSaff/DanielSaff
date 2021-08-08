function [data] = load_activity_data()


activites= ["Sit" "Stand" "Walk" "Stairs" "Bike" "Wheelchair" "Assessment"];

for I= 1:length(activites)

    dir_sit = fullfile('/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /2. Semester/DS/MUB2/Datensatz',activites(I));
    dinfo_activity = dir(dir_sit);
    dinfo_activity = dinfo_activity(4:end,:); %delete useless information in dinfo_activity


    for K = 1 : length(dinfo_activity)
        thisfilename = fullfile(dir_sit, dinfo_activity(K).name);  %directory of activity folder 

        cd (thisfilename);
        listing=dir('*accel*');
        accel=readmatrix(listing.name);

        listing=dir('*sensor*');
        pressure=readmatrix(listing.name);


        data.(activites(I)){K}{1}{1}=accel(accel(:,2 )==1 , : );
        data.(activites(I)){K}{1}{2}=accel(accel(:,2 )==2 , : );

        data.(activites(I)){K}{2}{1}=pressure(pressure(:,2 )==1 , : );
        data.(activites(I)){K}{2}{2}=pressure(pressure(:,2 )==2 , : );

    end

end 

cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /2. Semester/DS/MUB2/Matlab_func';

end 