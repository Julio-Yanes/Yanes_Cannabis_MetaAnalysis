function Data = Import(filename, startRow, endRow)

%  % Here, we're lodaing meta data. Following code takes .csv data and ...
    ... reads into MATLAB.

% Input Arguments...
    ... "filename" = Meta data. % Mandatory
    ... "startrow" = Optional
    ... "endrow" = Optional
  
% Ouput Arguments...
    ... Data = Table variable w/ data.

% Example:
    .... Data = Import(file); % Must have "file" variable w/ file to be analyzed.

% Auto-generated by MATLAB on 2018/10/07 12:30:07

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]);
rawStringColumns = string(raw(:, 2));


%% Create output variable
Data = table;
Data.k = cell2mat(rawNumericColumns(:, 1));
Data.Author = rawStringColumns(:, 1);
Data.Year = cell2mat(rawNumericColumns(:, 2));
Data.N = cell2mat(rawNumericColumns(:, 3));
Data.NFemale = cell2mat(rawNumericColumns(:, 4));
Data.PercentFemale = cell2mat(rawNumericColumns(:, 5));
Data.NMale = cell2mat(rawNumericColumns(:, 6));
Data.PercentMale = cell2mat(rawNumericColumns(:, 7));
Data.Age = cell2mat(rawNumericColumns(:, 8));
Data.Design = cell2mat(rawNumericColumns(:, 9));
Data.Treatment = cell2mat(rawNumericColumns(:, 10));
Data.Treatment_Collapsed = cell2mat(rawNumericColumns(:, 11));
Data.Treatment_Cannabinoid = cell2mat(rawNumericColumns(:, 12));
Data.Treatment_Synthetic = cell2mat(rawNumericColumns(:, 13));
Data.Treatment_Binary = cell2mat(rawNumericColumns(:, 14));
Data.Diagnosis = cell2mat(rawNumericColumns(:, 15));
Data.Pre = cell2mat(rawNumericColumns(:, 16));
Data.Pre_StanDev = cell2mat(rawNumericColumns(:, 17));
Data.Post = cell2mat(rawNumericColumns(:, 18));
Data.Post_StanDev = cell2mat(rawNumericColumns(:, 19));

