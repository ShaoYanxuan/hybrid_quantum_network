%% Function to correlate photon clicks from time-tag file with ion state


function [base_bright, base_dark, result, base_bright2, base_dark2, result2, bright_events, pmt_hist_sum, attempts, nextfile] = collect_correlations_timetags(root_folder, start_folders,threshold,  ncycles, Timetag, number_of_trics_folders_per_timetagfile)
fsep = filesep;

    %% initial stuff
    ttt = dir(root_folder);
    NN = number_of_trics_folders_per_timetagfile;
    bright_events = zeros(1, NN);
    folder_index = find(strcmp({ttt.name}, start_folders)==1);

    sizeTT=size(Timetag);
    
    %% for APD1
    abs_cycl_num = 0;
    result = zeros(length(Timetag{1}(:, 4)),2);
    result = result-1;
    it_phot = 1;
    base_bright = zeros(1, NN);
    base_dark = zeros(1, NN);
    
    %% for APD1
    abs_cycl_num2 = 0;
    if sizeTT(2) == 2
        result2 = zeros(length(Timetag{2}(:, 4)),2);
    else
        result2 = -1;
    end   
    result2 = result2-1;
    it_phot2 = 1;
    base_bright2 = zeros(1, NN);
    base_dark2 = zeros(1, NN);

    %% loop through polarization bases
    for nfile = 1:NN
        folder_name = strcat(root_folder, ttt(folder_index+nfile-1).name);
      
        %% PMT
        filename = [folder_name fsep 'PMT1_2.txt']
        delimiter = '\t';
        startRow = 2;
        formatSpec = '%*s%*s%*s%*s%*s%*s';
        for it = 1:ncycles
            formatSpec = strcat(formatSpec, '%f');
        end
        formatSpec = strcat(formatSpec, '%[^\n\r]');

        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        fclose(fileID);
        PMTs = [dataArray{1:end-1}];
%         figure(100)
%         hist(PMTs(1,:), 40);

        %% collect coincidences
        scanpoints = length(PMTs(:,1));
        cycles = (length(PMTs(1, :)));
        nextfile{nfile} = abs_cycl_num; %cycle number of next file
        for j = 1:scanpoints
            for ii = 1:cycles
                if(PMTs(j, ii)> threshold)
                    bright_events(nfile) = bright_events(nfile)+1;
                 end;
                %% for APD1
                if(it_phot <= length(Timetag{1}(:,4)))
                    if(abs_cycl_num)>Timetag{1}(it_phot, 4) %comparing of number of cycle in the pmt file with the number of cycle where we have APD click (Timetag(it_phot, 4))
                        it_phot = it_phot+1;                
                    else
                    abs_cycl_num = abs_cycl_num+1; %here we count numer of cycles through the whole measurement to be compared with number of cycle in the timetags file
                        if(Timetag{1}(it_phot, 4) == abs_cycl_num)
                            if(PMTs(j, ii)> threshold)
                                result(it_phot, 1) = 1;
                                base_bright(nfile) = base_bright(nfile)+1;
                            else
                                result(it_phot, 1) = 0;
                                base_dark(nfile) = base_dark(nfile)+1;
                            end
                            result(it_phot, 2) = PMTs(j, ii);
                            it_phot = it_phot +1;
                        end;
                    end
                end
                %% for APD2
                if sizeTT(2) == 2
                if(it_phot2 <= length(Timetag{2}(:,4)))
                    if(abs_cycl_num2)>Timetag{2}(it_phot2, 4)
                        it_phot2 = it_phot2+1;                
                    else
                    abs_cycl_num2 = abs_cycl_num2+1;
                        if(Timetag{2}(it_phot2, 4) == abs_cycl_num2)
                            if(PMTs(j, ii)> threshold)
                                result2(it_phot2, 1) = 1;
                                base_bright2(nfile) = base_bright2(nfile)+1;
                            else
                                result2(it_phot2, 1) = 0;
                                base_dark2(nfile) = base_dark2(nfile)+1;
                            end
                            result2(it_phot2, 2) = PMTs(j, ii);
                            it_phot2 = it_phot2 +1;
                        end;
                    end
                end
                end
                
            end;
            %% generate histogram
            [N,edges] = histcounts(PMTs(j,:), 'BinMethod','integer');
            pmt_hist(j,1:length(N)) = N;
%             hist1 = histogram(PMTs(j,:), 'BinMethod','integer');
%             pmt_hist(j,1:hist1.NumBins) = hist1.Values;

        end;
        %% final stuff
        pmt_hist_sum(nfile,:)=sum(pmt_hist(:,1:50)); %sum of histograms for all polarisation bases
        attempts(nfile) = cycles*scanpoints; %also nice to count attemts again
        
    end      
end
