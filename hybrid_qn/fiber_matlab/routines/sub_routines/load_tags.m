function tags = load_tags(filename)
delimiter = '\t';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
tags = [dataArray{1:end-1}];
tags(:,1) = tags(:,1)/1e6;
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
