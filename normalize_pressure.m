function [no_load_both,full_load_both] = normalize_pressure()

    %load no load and full directory
    dir_no_load = fullfile('/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/data/patient_data_v2.0/Inactive');
    dir_full_load = fullfile('/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/data/patient_data_v2.0/Stand');
    dinfo_activity_no_load = dir(dir_no_load);
    dinfo_activity_full_load = dir(dir_full_load);
    
    dinfo_activity_no_load=dinfo_activity_no_load(~ismember({dinfo_activity_no_load.name},{'.','..','.DS_Store'})); %delete useless information in dinfo_activity
    dinfo_activity_no_load=dinfo_activity_no_load(length(dinfo_activity_no_load)/2+1:end,:);
    
    dinfo_activity_full_load=dinfo_activity_full_load(~ismember({dinfo_activity_full_load.name},{'.','..','.DS_Store'})); %delete useless information in dinfo_activity
    dinfo_activity_full_load=dinfo_activity_full_load(1:length(dinfo_activity_full_load)/2,:);
    
  for K = 1 : length(dinfo_activity_no_load) %call dertermine_no_load function for all data sets
        
      [no_load_both{K}] = determine_no_load(dinfo_activity_no_load,dir_no_load,K)
      
      cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/matlab_functions'; 
  end
  
  for K = 1 : length(dinfo_activity_no_load) %call dertermine_no_load function for all data sets
        
      [full_load_both{K}] = determine_full_load(dinfo_activity_full_load,dir_full_load,K)
      
      cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/matlab_functions'; 
  end


cd '/Users/danielsaffertmuller/Documents/Gesundheits- und Rehabilitationstechnik /Masterarbeit/Cereneo/dataprocessing/matlab_functions';

end

