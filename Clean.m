function [] = Clean(Data)

% Here, we're cleaning data. Following code takes imported data and ...
    ... cleans / computes new variables.

% Input Arguments...
    ... "Data" = Meta data.
  
% Ouput Arguments...
    ... CleanData = Clean data.

% Example:
    .... [CleanData] = Clean(Data); % Must have "Data" table variable w/ meta data.
  
end

% Create/Insert Column w/ Effect Made "Normal" via Fencing
EffectHigh = prctile(Data.Effect, 75);
EffectLow = prctile(Data.Effect, 25);
EffectIQR = EffectHigh - EffectLow;

for i = 1:size(Data.Effect,1)
    if Data.Effect(i) > median(Data.Effect)+1.5*EffectIQR; % Effects deemed "small" have circle size = 1 in subsequent forest plot.
        Data.EffectNormal(i) = median(Data.Effect)+1.5*EffectIQR;
    elseif Data.Effect(i) < median(Data.Effect)-1.5*EffectIQR; % Effects deemed "large" have circle size = 3 in subsequent forest plot.
        Data.EffectNormal(i) = median(Data.Effect)-1.5*EffectIQR;
    else
        Data.EffectNormal(i) = Data.Effect(i); % Effects deemed "medium" have circle size = 2 in subsequent forest plot.
    end;
end;

SexHigh = prctile(Data.Sex, 75);
SexLow = prctile(Data.Sex, 25);
SexIQR = SexHigh - SexLow;

for i = 1:size(Data.Sex,1)
    if Data.Sex(i) > median(Data.Sex)+1.5*SexIQR; % Sexs deemed "small" have circle size = 1 in subsequent forest plot.
        Data.SexNormal(i) = median(Data.Sex)+1.5*SexIQR;
    elseif Data.Sex(i) < median(Data.Sex)-1.5*SexIQR; % Sexs deemed "large" have circle size = 3 in subsequent forest plot.
        Data.SexNormal(i) = median(Data.Sex)-1.5*SexIQR;
    else
        Data.SexNormal(i) = Data.Sex(i); % Sexs deemed "medium" have circle size = 2 in subsequent forest plot.
    end;
end;