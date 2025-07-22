function tags_f = load_tags_special(filename, begin, ends)
delimiter = '\t';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
tags = [dataArray{1:end-1}];
tags(:,1) = tags(:,1)/1e6;
tags_f = tags(begin:ends, :);
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
