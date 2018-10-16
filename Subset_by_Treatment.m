function [Data_Cannabis, Data_Placebo] = Subset_by_Treatment(Data, Treatment)

% Here, we're subsetting study-level meta data by 'Treatment.' Note, data...
    ... must contain 'Treatment' variable (ie, Cannabinoid/Placebo).

% Input Arguments...
    ... 'Data' = Table variable containing study-level meta data.
    ... 'Treatment' = Treatment to use subsetting meta data, where...
         ... '1' = Cannabinoid, '2' = Placebo, and '3' = both.
         
% Ouput Arguments...
    ... Data_Cannabinoid = .
    ... Data_Placebo = Data from Condition 2.
    
% Example...
    ... [Data_Cannabis, Data_Placebo] = Subset_by_Treatment(Data, 3);

if Treatment == 1;
Data_Cannabis = Data (Data.Treatment_Binary == 1, :);
    else if Treatment == 2;
    Data_Placebo = Data (Data.Treatment_Binary == 0, :);
        else Treatment == 3;
        Data_Cannabis = Data (Data.Treatment_Binary == 1, :);
        Data_Placebo = Data (Data.Treatment_Binary == 0, :);
            end;     
end;