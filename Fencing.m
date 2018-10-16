function [VariableNormal] = Fencing(Variable)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

EffectHigh = prctile(Variable, 75);
EffectLow = prctile(Variable, 25);
EffectIQR = EffectHigh - EffectLow;

% Creates/Inserts Column w/ Effect "Normal" using Fencing Approach
for i = 1:size(Variable,1)
    if Variable(i) > median(Variable)+1.5*EffectIQR; % Effects deemed "small" have circle size = 1 in subsequent forest plot.
        VariableNormal(i) = median(Variable)+1.5*EffectIQR;
    elseif Variable(i) < median(Variable)-1.5*EffectIQR; % Effects deemed "large" have circle size = 3 in subsequent forest plot.
        VariableNormal(i) = median(Variable)-1.5*EffectIQR;
    else
        VariableNormal(i) = Variable(i); % Effects deemed "medium" have circle size = 2 in subsequent forest plot.
    end;
end;


end

