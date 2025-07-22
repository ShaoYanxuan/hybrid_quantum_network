
function out = tomo_matrix_timetags(foldername, trics_root_folder, tricsfolder_arr,  timetag_files, timetag_root, ChRaman, ChAPD1, ChAPD2, ChCycle, threshold, seq_cycles, Nbases, real_cycl_start1, gate_start, gate_stop, gate_number)
%% This file mainly goes through the timetag files, looking for photon clicks 
%and corresponding cycle number. Passing an array (good_counts) of
%that information, it then calls a function that correlates the photon clicks 
%to the ion state. Finally it adds and sorts the correlations this function
%returns in a meaningful way...

fsep = filesep;

%% Loop through all 3 ion bases

gate_stop
gate_number
Number_of_measurements = length(tricsfolder_arr);
m=1;

for nfile = 1:Number_of_measurements
    %% initialize some parameters
    k1 = 1;
    k2 = 1;
    loop_n = 0;
    cycl_num = 0;
    if length(real_cycl_start1) == 1
        real_cycl_start(nfile) = real_cycl_start1;
    else 
        real_cycl_start = real_cycl_start1;
    end
    clear Counts1
    clear good_counts1
    clear Counts2
    clear good_counts2
    %loop_index = zeros(100*Number_of_files*100, 100);  %not used normaly, usec
    
    %% loading timetags as TAGS array. First column count-times in ps, second channel number. 
    tricsfolder = tricsfolder_arr{nfile}
    filename = strcat(timetag_root, timetag_files{nfile})
    delimiter = '\t';
    startRow = 2;
    formatSpec = '%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    TAGS = [dataArray{1:end-1}];
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;

    for i = 1:length(TAGS)
        
        %% searching for loops starts, cycle starts and detector's counts. Would be better to use find() function
        if TAGS(i, 2) == ChRaman         %loop start
            loop_n = loop_n+1;

%             if(cycl_num>0)
%                loop_index(cycl_num, loop_n) = i;
%             end;
        end;
        if TAGS(i, 2) == ChCycle           %cycle start
            cycl_num =cycl_num+1;
            cycle_index(cycl_num) = i;
            if(cycl_num>1)
%                 if(loop_n <= 1 ) && 0
%                     cycl_num = cycl_num-1;
%                 else
                    nloops{nfile}(cycl_num-1) = loop_n;
                    stop(cycl_num-1) = i-1;
%                 end
            end;
            loop_n = 0;

        end;
        %% detector clicks go to Count array
        if (i>1)&&(TAGS(i, 2) == ChAPD1)          % here we search for counts of APD1
            Counts1(k1, 1) = i;                   % remember the index in original array
            Counts1(k1, 2) = TAGS(i,1)/1e6;       % and time in us
            Counts1(k1,4) = cycl_num;             % and cylce number
            Counts1(k1,5) = loop_n;               % and loop number
            k1 = k1+1;
        end
        if (i>1)&&(TAGS(i, 2) == ChAPD2)          % here we search for counts of APD2
            Counts2(k2, 1) = i;           
            Counts2(k2, 2) = TAGS(i,1)/1e6;   
            Counts2(k2,4) = cycl_num;     
            Counts2(k2,5) = loop_n;           
            k2 = k2+1;
        end
    end;
    %figure
    %plot(nloops{nfile},'o-')
    N_events = k1-1 + k2-1;
    
    test = zeros(N_events,1);
    test = test -1;
    j = 1;
    w_it = 0;
    w_it2 = 0;
    it = 0;

    %% Now we check the time of APD1 clicks wrt Raman-pulse time and put those counts into good_counts1
%     try
    for k = 1:size(Counts1,1)       
        if(TAGS(Counts1(k,1)-1,2) == ChRaman) %previous event should be channel of Raman pulse
            dt(k) = -1*(TAGS(Counts1(k,1)-1,1)/1e6 -Counts1(k,2));
            if dt(k) < 1000 && dt(k) > 0 && Counts1(k, 4) >= real_cycl_start(nfile) %0<dt(k)<1000
                Counts1(k,3) = TAGS(Counts1(k,1)-1,1)/1e6; %timetag of gate here now
                if( dt(k)> gate_start && dt(k)< gate_stop)
                    it = it+1;
                    good_counts1(it,:)= Counts1(k, :);
                    % check if the next event after click is starting the new cycle.  
                    if(TAGS(good_counts1(it,1) +1, 2)~= ChCycle) %For conditional logic must not have Raman events between count and next ChCycle-click. 
                        w_it = w_it+1;
                        warning1(w_it) = it;
                    end
                end;
                %test(k) = Count(k,3)-TAGS(loop_index(Count(k,4), Count(k,5)), 1)/1e6;
            else
                Counts1(k,3) = Counts1(k,2)- 1543; %these are not actually counts during experiment, but before or after, left in timetagger. Dump at end of array.
            end
        else
            Counts1(k,3) = Counts1(k,2)-0;
            strange1(j,1) = Counts1(k,1)-1; %index of click that wasn't Raman before photon click
            strange1(j,2) = TAGS(Counts1(k,1)-1,2); %corresponding Ch
            strange1(j,3) = TAGS(Counts1(k,1)-1,1); %corresponding ttag
            j = j+1;
        end
    end
%     end
    
    j = 1;
    it = 0;

    %% Now repeat for APD2 if exists
    try
    for k = 1:size(Counts2,1)       
        if(TAGS(Counts2(k,1)-1,2) == ChRaman)               
            dt(k) = -1*(TAGS(Counts2(k,1)-1,1)/1e6 -Counts2(k,2));
            if dt(k) < 1000 && dt(k) > 0 &&  Counts2(k, 4) >= real_cycl_start(nfile) %0<dt(k)<1000
                Counts2(k,3) = TAGS(Counts2(k,1)-1,1)/1e6;     
                if( dt(k)> gate_start && dt(k)< gate_stop)
                    it = it+1;
                    good_counts2(it,:)= Counts2(k, :);
                    if( TAGS(good_counts2(it,1) +1, 2)~= ChCycle)   
                        w_it2 = w_it2+1;
                        warning2(w_it2) = it;
                    end
                end;
                %test(k) = Count(k,3)-TAGS(loop_index(Count(k,4), Count(k,5)), 1)/1e6;
            else
                Counts2(k,3) = Counts2(k,2)- 1543;          
            end
        else
            Counts2(k,3) = Counts2(k,2)-0;
            strange2(j,1) = Counts2(k,1)-1; 
            strange2(j,2) = TAGS(Counts2(k,1)-1,2); 
            strange2(j,3) = TAGS(Counts2(k,1)-1,1); 
            j = j+1;
        end
    end
    end
    
    %% Plotting
%     try
%         figure(100+nfile)
%         hist(Counts1(:,2)-Counts1(:,3), 2*1543) %histogram of clicks
%         figure(200+nfile)
%         hist(TAGS(good_counts1(:,1)+1, 2)) %plotting of channel number of events after photon click. Should be ChCycle. Can sometimes be photon. Must not be ChRaman for conditional measurement. Basically same as warning.            
%     end
%     try
%         figure(110+nfile)
%         hist(Counts2(:,2)-Counts2(:,3), 2*1543)
%         figure(210+nfile)          
%         hist(TAGS(good_counts2(:,1)+1, 2) )
%     end
%     
    %% correcting cycle number for dummy cycles in the beginning (see plot(nloops)) and putting into cell array
%     try
        good_counts1(:,4) = good_counts1(:,4) - real_cycl_start(nfile) +1; 
        good_counts{1} = good_counts1;
        Counts{1} = Counts1;
        Strange{1} = strange1;
%     end
    try
        good_counts2(:,4) = good_counts2(:,4) - real_cycl_start(nfile) +1;
        good_counts{2} = good_counts2;
        Counts{2} = Counts2;
        Strange{2} = strange2;
    end
    Allgoodcounts{nfile} = good_counts;
    Allcounts{nfile} = Counts;
    Allstrange{nfile} = Strange;
    
   
    %% getting correlations
    [bright_and_photon1, dark_and_photon1, resu1, bright_and_photon2, dark_and_photon2, resu2, bright, pmt_hist_sum{nfile}, attempts{nfile}, nextfile] = collect_correlations_timetags(trics_root_folder, tricsfolder, threshold, seq_cycles, good_counts, Nbases); % going into TRICS PMT file. See in the end.
    filestart = real_cycl_start(nfile);
    for ii = 1:length(attempts{nfile})-1
        attemptsbases{nfile}(ii) =  sum(nloops{nfile}(filestart:(filestart + attempts{nfile}(ii)-1)));
        filestart = filestart + attempts{nfile}(ii);
    end
    attemptsbases{nfile}(length(attempts{nfile})) =  sum(nloops{nfile}(filestart : min(length(nloops{nfile}) , (filestart + attempts{nfile}(ii)-1))));   
    Allclicks{nfile} = sum(bright_and_photon1+dark_and_photon1+bright_and_photon2+dark_and_photon2)

    %% some tests useful for checking the gate for triggering state detection. Needs to be adjusted
    
%     test = TAGS(Count(:,1)+1, 2);
%      exited = find(nloops < 40);
%      search1 = find(nloops(exited)>2);
%      exit = exited(search1);
%      figure(300+nfile)
%      plot(TAGS(cycle_index(exit+1)-1, 2));
%     cyc = find(TAGS(:,2) == 7);
%     events = find(TAGS(cyc-1,2)==4);
%     photons = cyc(events(:))-1;
%     search = find(TAGS(photons-1,2)==0);
%     real_photons = photons(search);

    %% generating tomo matrix. This section still needs adjustments
    %% if no APD2    
    if resu2 == -2 
        WARNING(nfile) = w_it;   % must not be big. If big, use the tests before, probably conditional (hardware) gate is wrong.
        M_viktors1(:,2*(nfile-1)+1) = bright_and_photon1 % shaping to 6x6 for Viktor's analysis
        M_viktors1(:,2*(nfile-1)+2) = dark_and_photon1
        
        corrMat1{nfile}(:,1) = dark_and_photon1';
        corrMat1{nfile}(:,2) = bright_and_photon1';
        length(corrMat1{nfile})
        if Nbases == 12 && length(attempts{nfile}) == 12
            corrMat11(1:6,1) = (corrMat1{nfile}(1:6,1)+corrMat1{nfile}(7:12,1));
            corrMat11(1:6,2) = (corrMat1{nfile}(1:6,2)+corrMat1{nfile}(7:12,2));
            corrMat11
            corrMat1{nfile} = corrMat11;
            
            attemptsbases1 = attemptsbases{nfile}(1:6)+attemptsbases{nfile}(7:12);
            attemptsbases{nfile} = attemptsbases1;
        end
        
        corrMat(:,1) = corrMat1{nfile}(1:2:end,1);
        corrMat(:,2) = corrMat1{nfile}(1:2:end,2);
        corrMat(:,3) = corrMat1{nfile}(2:2:end,1);
        corrMat(:,4) = corrMat1{nfile}(2:2:end,2);
        
        
        corrMatSimplified = corrMat;
        probMatNorm = zeros(3,4);
        for jj = 1:3
            probMatNorm(jj,:) = corrMat(jj,:)/sum(corrMat(jj,:));
        end
        probMatNorm;
        
    end
    
    %% if APD 1&2
    if resu2 ~= -2 
        if Nbases == 12 && length(attempts{nfile}) == 12
            for jj = 1:6
                corrMat(jj,:) = [...
                    dark_and_photon1(jj)+dark_and_photon1(jj+6),...
                    bright_and_photon1(jj)+bright_and_photon1(jj+6),...
                    dark_and_photon2(jj)+dark_and_photon2(jj+6),...
                    bright_and_photon2(jj)+bright_and_photon2(jj+6)...
                    ];
            end   
            attemptsbases1 = attemptsbases{nfile}(1:6)+attemptsbases{nfile}(7:12);
            attemptsbases{nfile} = attemptsbases1
        elseif Nbases == 6 && length(attempts{nfile}) == 6
            corrMat = [...
                    dark_and_photon1',...
                    bright_and_photon1',...
                    dark_and_photon2',...
                    bright_and_photon2'...
                    ];
                M_viktors1(:,2*(nfile-1)+1) = bright_and_photon1; % shaping to 6x6 for Viktor's analysis
                M_viktors1(:,2*(nfile-1)+2) = dark_and_photon1;
        end
   
        corrMat;
        probMat = zeros(6,4);
%         for jj = 1:6  %was before  Oct, 19 2020
%             probMat(jj,:) = corrMat(jj,:)/sum(corrMat(jj,:));
%         end
        probMat = corrMat; %  Oct, 19 2020
        probMatNorm=zeros(3,4);
        kk = 1;
        for jj = 1:2:6
            probMatNorm(kk,:) = (probMat(jj,:)+probMat(jj+1,[3 4 1 2]))/2;
            probMatNorm(kk,:) = probMatNorm(kk,:)/sum(probMatNorm(kk,:));   % normalization as for Oct 19, 2020
            corrMatSimplified(kk,:) = (corrMat(jj,:)+corrMat(jj+1,[3 4 1 2]));
            
            tomo_matrix_attempts(kk,:) = [...
            attemptsbases{nfile}(jj), attemptsbases{nfile}(jj),...
            attemptsbases{nfile}(jj+1), attemptsbases{nfile}(jj+1)...
            ];
        
            kk = kk+1;
        end        
    end
    
    %% tomo matrix
    kk = 1;
    for jj = 1:2:6
        tomo_matrix_attempts(kk,:) = [...
            attemptsbases{nfile}(jj), attemptsbases{nfile}(jj),...
            attemptsbases{nfile}(jj+1), attemptsbases{nfile}(jj+1)...
            ];
        kk = kk+1;
    end
    if nfile==1;
        tomo_matrix1 = probMatNorm;
        tomo_matrix1_counts = corrMatSimplified;%gives the actual counts to get tomo_matrix1
        tomo_matrix_attempts1 = tomo_matrix_attempts;
    else 
        tomo_matrix1 = cat(1,tomo_matrix1,probMatNorm);
        tomo_matrix1_counts = cat(1,tomo_matrix1_counts,corrMatSimplified);
        tomo_matrix_attempts1 = cat(1,tomo_matrix_attempts1,tomo_matrix_attempts);
    end
end

%% Final results

%       %% reordering of tomo_matrix for density matrix reconstruction with Linears' code
%         if 1 % change the order of qubits: the linears order is SS, SD, DS, DD !?
%             exchange = zeros(9,4);
%             exchange(:,3) = tomo_matrix1(:,3);
%             exchange(:,2) = tomo_matrix1(:,2);
%             tomo_matrix1(:,2) = exchange(:,3);
%             tomo_matrix1(:,3) = exchange(:,2);
%         end
% 
%         if 1 % swap the fibers (the APD's)
%             exchange = zeros(9,4);
%             exchange(:,3) = tomo_matrix1(:,4);
%             exchange(:,4) = tomo_matrix1(:,3);
%             exchange(:,2) = tomo_matrix1(:,1);
%             exchange(:,1) = tomo_matrix1(:,2);
%             tomo_matrix1 = exchange;
%         end

    tomo_matrix1_counts
    out.tomo_matrix1{gate_number} = tomo_matrix1;
    out.tomo_matrix1_counts{gate_number} = tomo_matrix1_counts;
    out.tomo_matrix_attempts1 = {tomo_matrix_attempts1};
    out.Allclicks{gate_number} = Allclicks;
    out.attemptsbases = attemptsbases;
%     out.attempts = attempts;
    out.pmt_hist_sum = pmt_hist_sum;
    out.Allgoodcounts{gate_number} = Allgoodcounts;
    out.Allcounts = Allcounts;
    %out.Allstrange = Allstrange;
    out.gatestart{gate_number} = gate_start;
    out.gatestop{gate_number} = gate_stop;
    %out.M_viktors{gate_number} =  M_viktors1;
%     out.nloops = nloops;
