%% Code- Cannabinoid Administration Reduces Pain.

% The following codes are associated with...
    ... Yanes, J.A., McKinnell Z.E., Reid, M.A., Busler, J.N.,...
    ... Michel, J.S., Pangelinan, M.M., Sutherland, M.T., Younger, J.W...
    ... Gonzalez, R., and Robinson, J.L. Cannabinoid Administration...
    ... Reduces Pain. In Submission.
    
% The following codes load data associated with the above mentioned...
    ... manuscript, run analyses, and prepare tables/figures.
        
% Catgorical data within the dataset were coded as follows...
    ... Design (0 = crossover, 1 = parallel).
    ... Treatment (0 = placebo, 1 = THC, 2 = THC/CBD extract [Sativex],...
        ... 3 = THC/CBD, 4 = Nabilone, 5 = Dronabinol, 6 = CT3, 7 = CBD).
    ... Treatment Collapsed (0 = placebo, 1 = cannabis [whole-plant,...
        ... extract], 2 = synthetic cannabinoid).
    ... Treatment Binary (0 = placebo, 1 = cannabinoid).
    ... Diagonsis (1 = abdominal pain, 2 = arthritis, 3 = cancer,...
        ... 4 = chronic pain, 5 = diabetes, 6 = fibromyalgia, 7 = HIV,...
        ... 8 = headache, 9 = "various", 10 = multiple sclerosis,...
        ... 11 = neuropathic pain, 12 = post-operative pain). 
    
%% Data- Loading Data

% Here, we're loading meta data (e.g., authors, effect sizes, confidence intervals, etc.).

[file, path] = uigetfile('*.csv', 'select *.csv data'); % Opens window; navigate/select data.
[filepath, name, ext] = fileparts(file); % Creates variables w/ data.
cd(path) % Changes directory w/ path.
Data = Import(file); % Funtion to import data.
Data = sortrows(Data,'Author','descend'); % Sorts data via 'Author' column.



%% K-Level Estimates- Raw Mean Gain Scores, Effect Size Estimates, and Confidence Intervals.

% Here, we're computing k-level estimates, including raw mean gain ...
    ... scores, pooled standevs, stanerrs, confidence intervals, ...
    ... and weight. Also, we're using weight to compute weighted effects ...
    ... and intervals.

Data.Difference = Data.Post-Data.Pre; % Computes raw mean differences.
Data.PooledStanDev = sqrt(((Data.Pre_StanDev.*Data.Pre_StanDev)+(Data.Post_StanDev.*Data.Post_StanDev))/2); % Computes pooled stan. devs.
Data.Effect = round(Data.Difference./Data.PooledStanDev, 2); % Computes effect estimates.
Data.StanErr = sqrt((2.*(1-0.93)./Data.N)+(Data.Effect.*Data.Effect)./(2.*Data.N)); % comment out why 0.93 was selected
Data.Var = (sqrt(Data.N).*Data.StanErr).^2;
Data.Weight = 1./(Data.StanErr.*Data.StanErr);
Data.WeightedEffect = Data.Effect.*Data.Weight;
Data.CILower = round(Data.Effect-(1.96.*Data.StanErr), 2);
Data.CIUpper = round(Data.Effect+(1.96.*Data.StanErr), 2);
Data.WeightedCILower = Data.CILower.*Data.Weight;
Data.WeightedCIUpper = Data.CIUpper.*Data.Weight;



%% Subset Data by Treatment (ie, Cannabinoid/Placebo).

% Here, we're using the "Subset_by_Treatment" function to create ...
    ... two subset variables (ie, study-level meta data from cannabinoid ...
    ... treatments and study-level meta data from placebo treatments).
    
% Here, "3" indicates "1" and "2", or Cannabis and Placebo, respectively.
    
[Data_Users, Data_Non-Users] = Subset_by_Treatment(Data, 3);



%% Sub-Group Analysis-  Pooling Estimates, Intervals, Cochran's Q, ISquared
    
% This code computes inverse-variance weighted pooled effect size ...
    ... estimates and associated confidence intervals for cannabis ...
    ... contrasts and placebo contrasts.
    
PooledEffect_Cannabis = round((sum(Data_Cannabis.WeightedEffect)./sum(Data_Cannabis.Weight)), 2);
PooledInterval_Cannabis = round([(sum(Data_Cannabis.WeightedCILower)./sum(Data_Cannabis.Weight)),(sum(Data_Cannabis.WeightedCIUpper)./sum(Data_Cannabis.Weight))], 2);

PooledEffect_Placebo = round((sum(Data_Placebo.WeightedEffect)./sum(Data_Placebo.Weight)), 2);
PooledInterval_Placebo = round([(sum(Data_Placebo.WeightedCILower)./sum(Data_Placebo.Weight)),(sum(Data_Placebo.WeightedCIUpper)./sum(Data_Placebo.Weight))], 2);

% Here, we're examining potential homogeneity within the sub-groups...
    ... (i.e., cannabinoid administration effect size estimates and...
    ... and placebo administration effect size esimtates separately).
    
Data_Cannabis.Deviation = (Data_Cannabis.Effect-PooledEffect_Cannabis).^2; % Computes deviation per effect size estimate.
Data_Cannabis.WeightedDeviation = (Data_Cannabis.Deviation.*Data_Cannabis.Weight); % Computes weighted deviation per effect size estimate.
CochranQ_Cannabis = sum(Data_Cannabis.WeightedDeviation); % Computes Cochran's Q: Sums standardized squared deviations per effect size estimate.
ChiCrit_Cannabis = chi2inv(0.95,size(Data_Cannabis.N,1)-1); % Computes Chi^2 critical value, given p and DF.
ISquared_Cannabis = (CochranQ_Cannabis-(size(Data_Cannabis.N,1)-1))/CochranQ_Cannabis; % Computes I^2 statistic, given CochransQ and DF.
   
Data_Placebo.Deviation = (Data_Placebo.Effect-PooledEffect_Placebo).^2; % Computes deviation per effect size estimate.
Data_Placebo.WeightedDeviation = (Data_Placebo.Deviation.*Data_Placebo.Weight); % Computes weighted deviation per effect size estimate.
CochranQ_Placebo = sum(Data_Placebo.WeightedDeviation); % Computes Cochran's Q: Sums standardized squared deviations per effect size estimate.
ChiCrit_Placebo = chi2inv(0.95,size(Data_Placebo.N,1)-1); % Computes Chi^2 critical value, given p and DF.
ISquared_Placebo = (CochranQ_Placebo-(size(Data_Placebo.N,1)-1))/CochranQ_Placebo; % Computes I^2 statistic, given CochransQ and DF.


%% Pooling Estimates- Pooled Effect Size Estimates, Confidence Intervals, and Statistical Tests.

PooledEffect_Cannabis = round((sum(Data_Cannabis.WeightedEffect)./sum(Data_Cannabis.Weight)), 2);
PooledInterval_Cannabis = round([(sum(Data_Cannabis.WeightedCILower)./sum(Data_Cannabis.Weight)),(sum(Data_Cannabis.WeightedCIUpper)./sum(Data_Cannabis.Weight))], 2);

PooledEffect_Placebo = round((sum(Data_Placebo.WeightedEffect)./sum(Data_Placebo.Weight)), 2);
PooledInterval_Placebo = round([(sum(Data_Placebo.WeightedCILower)./sum(Data_Placebo.Weight)),(sum(Data_Placebo.WeightedCIUpper)./sum(Data_Placebo.Weight))], 2);

% This code runs an independent samples t-test to compare the pooled ...
    ... effect size estimates.

[h,p,ci,stats] = ttest2(Data_Cannabis.Effect, Data_Placebo.Effect);


%% Plotting- Forest Plot, Cannabis

Data_Cannabis.CISize = (Data_Cannabis.CIUpper-Data_Cannabis.CILower)/2; % Creates "CI_Size" column within Data.

% Create/Insert Column w/ Effect Interpretations (e.g., "large" effect).
for i = 1:size(Data_Cannabis.Effect,1)
    if Data_Cannabis.Effect(i) > -0.4; % Effects deemed "small" have circle size = 1 in subsequent forest plot.
        Data_Cannabis.EffectInterpret(i) = 100; 
    elseif Data_Cannabis.Effect(i) <= -0.8 % Effects deemed "large" have circle size = 3 in subsequent forest plot.
        Data_Cannabis.EffectInterpret(i) = 300;
    else
        Data_Cannabis.EffectInterpret(i) = 200; % Effects deemed "medium" have circle size = 2 in subsequent forest plot.
    end;
end;

for i = 1:size(Data_Cannabis.Effect,1)
    if Data_Cannabis.Effect(i)-Data_Cannabis.CISize(i) < -2; % Cuts errorbars to -2 when error bar beyond -2.
        Data_Cannabis.CINeg(i)=abs(-2-Data_Cannabis.Effect(i));
    else
        Data_Cannabis.CINeg(i)=Data_Cannabis.CISize(i); % Otherwise, leaves errorbars alone.
    end;
end;

% Creating Forest Plot Figure w/ Cannabis Subset.
figure(2);  
for i = 1:size(Data_Cannabis.Effect,1);
errorbar(Data_Cannabis.Effect(i), i*2, Data_Cannabis.CINeg(i), Data_Cannabis.CISize(i),'horizontal','k', 'LineWidth',2); hold on;
scatter(Data_Cannabis.Effect(i), i*2, Data_Cannabis.EffectInterpret(i),'k','LineWidth',2, 'MarkerFaceColor', 'g');
text(-3.1, i*2, char(Data_Cannabis.Author(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.775, i*2, num2str(Data_Cannabis.Year(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.6, i*2, num2str(Data_Cannabis.N(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.49, i*2, num2str(Data_Cannabis.Effect(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.3585, i*2, '(', 'FontSize', 16,'FontName', 'Arial');
text(-2.34, i*2, num2str(Data_Cannabis.CILower(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.22, i*2, ',', 'FontSize', 16,'FontName', 'Arial');
text(-2.195, i*2, num2str(Data_Cannabis.CIUpper(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.09, i*2, ')', 'FontSize', 16,'FontName', 'Arial');
text(-3.1, 80, 'Author', 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.775, 80, 'Year', 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.59, 80, 'N', 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.47, 80, 'ES', 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.31, 80, '(95% CI)', 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
end;
axis([-3.15 0.05 -5 82.5])
plot(zeros(11,1),-10:10:90, 'k--', 'LineWidth',0.2);
yticks([])
xlabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16, 'LineWidth', 2, 'XTick', [-2:1:0], 'XTickLabel', {'-2', '-1', '0'});

plot(zeros(11,1),-10:10:90, 'k--', 'LineWidth',0.2);
yticks([])
xlabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16, 'LineWidth', 2, 'XTick', [-2:1:0], 'XTickLabel', {'-2', '-1', '0'});

% Including Average Treatment Effect in Forest Plot Figure.
errorbar(PooledEffect_Cannabis, -1, (PooledEffect_Cannabis(1)-PooledInterval_Cannabis(1)), (PooledEffect_Cannabis(1)-PooledInterval_Cannabis(1)),'horizontal','k', 'LineWidth',2); hold on;
scatter(PooledEffect_Cannabis, -1, 450,'kd','LineWidth',2, 'MarkerFaceColor', 'g');
text(-2.935, -1, '\bf Pooled Estimates', 'FontSize', 16,'FontName', 'Arial');
text(-2.49, -1, num2str(PooledEffect_Cannabis), 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.3585, -1, '(', 'FontSize', 16,'FontName', 'Arial');
text(-2.335, -1, num2str(PooledInterval_Cannabis(1)), 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.22, -1, ',', 'FontSize', 16,'FontName', 'Arial');
text(-2.19, -1, num2str(PooledInterval_Cannabis(2)), 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.09, -1, ')', 'FontSize', 16,'FontName', 'Arial');

% Creates a legend for the scaling
figure();
scatter(0, 0.5, 50, 'k', 'LineWidth',2); hold on;
scatter(0, 1, 100, 'k', 'LineWidth',2);
scatter(0, 1.5, 150, 'k', 'LineWidth',2);
text(0.1, 0.5, '<0.4', 'FontSize', 16,'FontName', 'Arial');
text(0.1, 1, '>=-0.4 to <0.8', 'FontSize', 16,'FontName', 'Arial');
text(0.1, 1.5, '>=0.8', 'FontSize', 16,'FontName', 'Arial');
axis([-0.2 1 0 2])



%% Plot- Forest Plot, Placebo

Data_Placebo.CISize = (Data_Placebo.CIUpper-Data_Placebo.CILower)/2; % Creates "CI_Size" column within Data.

% Create/Insert Column w/ Effect Interpretations (e.g., "large" effect).
for i = 1:size(Data_Placebo.Effect,1)
    if Data_Placebo.Effect(i) > -0.4; % Effects deemed "small" have circle size = 1 in subsequent forest plot.
        Data_Placebo.EffectInterpret(i) = 100; 
    elseif Data_Placebo.Effect(i) <= -0.8 % Effects deemed "large" have circle size = 3 in subsequent forest plot.
        Data_Placebo.EffectInterpret(i) = 300;
    else
        Data_Placebo.EffectInterpret(i) = 200; % Effects deemed "medium" have circle size = 2 in subsequent forest plot.
    end;
end;

for i = 1:size(Data_Placebo.Effect,1)
    if Data_Placebo.Effect(i)-Data_Placebo.CISize(i) < -2; % Cuts errorbars to -2 when error bar beyond -2.
        Data_Placebo.CINeg(i)=abs(-2-Data_Placebo.Effect(i));3
    else
        Data_Placebo.CINeg(i)=Data_Placebo.CISize(i); % Otherwise, leaves errorbars alone.
    end;
end;

% Creating Forest Plot Figure w/ Placebo Subset.
figure(3);  
for i = 1:size(Data_Placebo.Effect,1);
errorbar(Data_Placebo.Effect(i), i*2, Data_Placebo.CINeg(i), Data_Placebo.CISize(i),'horizontal','k', 'LineWidth',2); hold on;
scatter(Data_Placebo.Effect(i), i*2, Data_Placebo.EffectInterpret(i),'k','LineWidth',2, 'MarkerFaceColor', 'w');
text(-3.1, i*2, char(Data_Placebo.Author(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.775, i*2, num2str(Data_Placebo.Year(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.6, i*2, num2str(Data_Placebo.N(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.49, i*2, num2str(Data_Placebo.Effect(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.3585, i*2, '(', 'FontSize', 16,'FontName', 'Arial');
text(-2.34, i*2, num2str(Data_Placebo.CILower(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.22, i*2, ',', 'FontSize', 16,'FontName', 'Arial');
text(-2.195, i*2, num2str(Data_Placebo.CIUpper(i)), 'FontSize', 16,'FontName', 'Arial');
text(-2.09, i*2, ')', 'FontSize', 16,'FontName', 'Arial');
text(-3.1, 54, 'Author', 'FontSize', 16,'FontName', 'Arial','FontWeight', 'bold');
text(-2.775, 54, 'Year', 'FontSize', 16,'FontName', 'Arial','FontWeight', 'bold');
text(-2.59, 54, 'N', 'FontSize', 16,'FontName', 'Arial','FontWeight', 'bold');
text(-2.47, 54, 'ES', 'FontSize', 16,'FontName', 'Arial','FontWeight', 'bold');
text(-2.31, 54, '(95% CI)', 'FontSize', 16,'FontName', 'Arial','FontWeight', 'bold');
end;
axis([-3.15 0.05 -5 56.5])
plot(zeros(11,1),-10:10:90, 'k--', 'LineWidth',0.2);
yticks([])
xlabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16, 'LineWidth', 2, 'XTick', [-2:1:0], 'XTickLabel', {'-2', '-1', '0'});

plot(zeros(11,1),-10:10:90, 'k--', 'LineWidth',0.2);
yticks([])
xlabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16, 'LineWidth', 2, 'XTick', [-2:1:0], 'XTickLabel', {'-2', '-1', '0'});

% Including Average Treatment Effect in Forest Plot Figure.
errorbar(PooledEffect_Placebo, -1, (PooledEffect_Placebo(1)-PooledInterval_Placebo(1)), (PooledEffect_Placebo(1)-PooledInterval_Placebo(1)),'horizontal','k', 'LineWidth',2); hold on;
scatter(PooledEffect_Placebo, -1, 450,'kd','LineWidth',2, 'MarkerFaceColor',[1 1 1]);
text(-2.935, -1, '\bf Pooled Estimates', 'FontSize', 16,'FontName', 'Arial');
text(-2.49, -1, num2str(PooledEffect_Placebo), 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.3585, -1, '(', 'FontSize', 16,'FontName', 'Arial');
text(-2.335, -1, num2str(PooledInterval_Placebo(1)), 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.22, -1, ',', 'FontSize', 16,'FontName', 'Arial');
text(-2.19, -1, num2str(PooledInterval_Placebo(2)), 'FontSize', 16,'FontName', 'Arial', 'FontWeight', 'bold');
text(-2.09, -1, ')', 'FontSize', 16,'FontName', 'Arial');

% Creates a legend for the scaling
figure();
scatter(0, 0.5, 50, 'k', 'LineWidth',2); hold on;
scatter(0, 1, 100, 'k', 'LineWidth',2);
scatter(0, 1.5, 150, 'k', 'LineWidth',2);
text(0.1, 0.5, '<0.4', 'FontSize', 16,'FontName', 'Arial');
text(0.1, 1, '>=-0.4 to <0.8', 'FontSize', 16,'FontName', 'Arial');
text(0.1, 1.5, '>=0.8', 'FontSize', 16,'FontName', 'Arial');
axis([-0.2 1 0 2]);



%% Cleaning Data- Outliers

% Here, we're cleaning data for regression analyses. Varibles being ...
    ... considered here are: 'Treatment_Binary' (binary, IV), 'PercentFemale' ...
    ... (continous, IV), 'Design' (binary, IV), 'Population' ...
    ... (categorical, IV), and 'Effect' (continuous, DV). 
    
% Creates/Inserts Column w/ Effect "Normal" continuous IV using Fencing Approach.
EffectNormal = Fencing(Data.Effect);
Data.EffectNormal=EffectNormal';
clear *Normal;

% Creates/Inserts Column w/ N "Normal" continuous IV using Fencing Approach.
NNormal = Fencing(Data.N);
Data.NNormal = NNormal';
clear *Normal;

% Creates/Inserts Column w/ NFemale "Normal" continuous IV using Fencing Approach.
NFemaleNormal = Fencing(Data.NFemale);
Data.NFemaleNormal = NFemaleNormal';
clear *Normal;

% Creates/Inserts Column w/ PercentFemale "Normal" continuous IV using Fencing Approach.
PercentFemaleNormal = Fencing(Data.PercentFemale);
Data.PercentFemaleNormal = PercentFemaleNormal';
clear *Normal;

% Creates/Inserts Column w/ NMale "Normal" continuous IV using Fencing Approach.
NMaleNormal = Fencing(Data.NMale);
Data.NMaleNormal = NMaleNormal';
clear *Normal;

% Creates/Inserts Column w/ PercentMale "Normal" continuous IV using Fencing Approach.
PercentMaleNormal = Fencing(Data.PercentMale);
Data.PercentMaleNormal = PercentMaleNormal';
clear *Normal;

% Creates/Inserts Column w/ Age "Normal" continuous IV using Fencing Approach.
AgeNormal = Fencing(Data.Age);
Data.AgeNormal = AgeNormal';
clear *Normal;



%% Regression- Exploratory Mixed-Effects Mulitple Linear. 

% Assuming there are no outliers, run the fitlm code as follows.
mdl = fitlm(Data, 'EffectNormal~ 1 + Treatment_Cannabinoid + Treatment_Synthetic + NNormal + PercentFemaleNormal + AgeNormal + Design + Diagnosis') % Runs multiple linear regression.
anova(mdl) % Outputs traditional ANOVA table with SS, MS, F, p-values.

% Checks data for outliers remaining from fencing approach.
residual_outliers_mdl = find(mdl.Diagnostics.CooksDistance>4/size(Data.k,1)); % 0.0615 = 4/65 studies

% Assuming there are outliers, re-run the fitlm code as follows.
mdl2 = fitlm(Data, 'EffectNormal~ 1 + Treatment_Cannabinoid + Treatment_Synthetic + NNormal + PercentFemaleNormal + AgeNormal + Design + Diagnosis','Exclude',residual_outliers_mdl) % Re-runs multiple linear regression w/ outliers omitted;
anova(mdl2) % Outputs traditional ANOVA table with SS, MS, F, p-values.

%% Plot- Scatter Plots
   
% Here, we plot relationships between effect estimates and: treatment,...
    ... sample size, sample sex composition, and diagnosis.

Data = sortrows(Data,'Treatment_Collapsed','ascend'); % Sorts data via 'Treatment_Binary' column.

X1 = Data.Treatment_Collapsed; % Creates column variable w/ Treatment.
X2 = Data.N; % Creates column variable w/ N Female.
X3 = Data.PercentFemale; % Creates column variable w/ Percent Female.
X4 = Data.Diagnosis; % Crates colums variable w/ Diagonsis.
Y = Data.Effect; % Creates column variable w/ Effect.

X1zeroline = zeros(31,1);
X1line = -0.5:0.1:2.5;
X1p1 = -0.22927;
X1p2 = -0.59026;
Y1line = X1p1*X1line+X1p2;

figure(4);
subplot(1,2,1);
plot(X1(1:26),Y(1:26), 'ko', 'MarkerFaceColor', 'w', 'LineWidth',2,'MarkerSize',14); hold on;
plot(X1(27:54),Y(27:54),'ko', 'MarkerFaceColor', 'g','LineWidth',2,'MarkerSize',14); hold on;
plot(X1(55:65),Y(55:65),'ko', 'MarkerFaceColor', 'g','LineWidth',2,'MarkerSize',14); hold on;
plot(X1line, Y1line, 'k-', 'LineWidth',2);
plot(X1line, X1zeroline, 'k--', 'LineWidth',2');
axis([ -0.5 2.5 -2 0.25]);
xlabel('Administration');
ylabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16, 'LineWidth', 2, 'xTick',[0 1 2], 'xTickLabel',{'Placebo', 'Cannabinoid', 'Synthetic'});

X2zeroline = zeros(1,1671);
X2line = -2:0.1:165;
X2p1 = 0.0016122;
X2p2 = -0.83051;
Y2line = X2p1*X2line+X2p2;

subplot(1,2,2);
plot(X2(1:26),Y(1:26), 'ko', 'MarkerFaceColor', 'w', 'LineWidth',2,'MarkerSize',14); hold on;
plot(X2(27:65),Y(27:65),'ko', 'MarkerFaceColor', 'g','LineWidth',2,'MarkerSize',14); hold on;
plot(X2line, X2zeroline, 'k--', 'LineWidth',2');
plot(X2line, Y2line, 'k-', 'LineWidth',2);
axis([ -0.15 165 -2 0.25]);
xlabel('Sample Size');
ylabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16,  'LineWidth', 2);

X3zeroline = zeros(1,1671);
X3line = -2:0.1:165;
X3p3 = -0.27531;
X3p2 = -0.62464;
Y3line = X3p3*X3line+X3p2;

figure(5)
plot(X3(1:27),Y(1:27), 'ko', 'MarkerFaceColor', 'w', 'LineWidth',2,'MarkerSize',14); hold on;
plot(X3(28:65),Y(28:65),'ko', 'MarkerFaceColor', 'g','LineWidth',2,'MarkerSize',14); hold on;
plot(X3line, X3zeroline, 'k--', 'LineWidth',2')
plot(X3line, Y3line, 'k-', 'LineWidth',2);
axis([-0.15 1.14 -2 0.25]);
xlabel('Sample Sex Composition');
ylabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16,  'LineWidth', 2);

X4zeroline = zeros(1,151);
X4line = -2:0.1:13;
X4p1 = 0.0099467;
X4p2 = -0.84129;
Y2line = X4p1*X4line+X4p2;

figure(6);
plot(X4(1:27),Y(1:27), 'ko', 'MarkerFaceColor', 'w', 'LineWidth',2,'MarkerSize',14); hold on;
plot(X4(28:65),Y(28:65),'ko', 'MarkerFaceColor', 'g','LineWidth',2,'MarkerSize',14); hold on;
plot(X4line, X4zeroline, 'k--', 'LineWidth',2')
axis([0.25 12.25 -2 0.25]);
xlabel('Pain Population');
ylabel(sprintf('Effect Estimate (Cohen''s d )'));
set(gca, 'FontName', 'Arial','FontSize', 16,  'LineWidth', 2, 'XTick',...
    [1 2 3 4 5 6 7 8 9 10 11 12],'XTickLabel',...
    {'ABD','ART','CAN','CHR','DIA','FIB','HIV','HEA','VAR','MSC','NEU','POP'});

clear X* Y*


