function out = timetags_cam_2ion_2phot_memory_conditional(timetag_root_folder, trics_root_folder, trics_folder_arr,  timetag_files,timetag_bases,  ChRaman, ChRaman2, CH1, CH2, ChCycle, threshold, doppler_threshold, seq_cycles,  gate_start, gate_stop, gate2_shift, gate_number, nloops_param, loop_sel, point_sel)
% if length(real_cycl_start1) == 1
%     real_cycl_start(nfile) = real_cycl_start1;
% else 
%     real_cycl_start = real_cycl_start1;
% end
if length(point_sel ==2)
    no_selection = 0
else
    no_selection = 1
    point_sel = [1e8, -1e8];
end
Number_of_measurements = length(trics_folder_arr);
gate_start2 = gate_start+gate2_shift;
gate_stop2 = gate_stop+gate2_shift;
corrMat_raw = zeros(Number_of_measurements,4);
corrMat_raw2 = zeros(Number_of_measurements,4);
tomo_matrix_attempts1 = zeros(9,16);

good_triggering_counts1 = [];
good_triggering_counts2 = [];
time_phot1 = [];
time_phot2 = [];
WP_phot1 = [];
WP_phot2 = [];
test_nontriger_phot1 = [];
test_nontriger_phot2 = [];
nontr1 = [];
nontr2 = [];

count_loop = zeros(max(sum(nloops_param), 2*max(loop_sel)),1); %sum(nloops_param), 1
count_loop2 = zeros(max(sum(nloops_param),2*max(loop_sel)), 1);
count_mem_loop = zeros(max(sum(nloops_param),2*max(loop_sel)), 1);
count_mem_loop2 = zeros(max(sum(nloops_param),2*max(loop_sel)), 1);
count_pair = zeros(max(sum(nloops_param),2*max(loop_sel)),max(sum(nloops_param),2*max(loop_sel))); %sum(nloops_param), sum(nloops_param)

state_raw = zeros(9, 16);
state_norm = zeros(9, 16) ;%(length(timetag_bases), 16);
state_norm = state_norm./state_norm;
tomo_matrix_attempts1 = state_norm;
tomo_matrix_attempts2 = state_norm;
photon_first = state_norm;
state = state_norm;
ion_state_aver = zeros(Number_of_measurements, 4);
phot_state_aver = zeros(Number_of_measurements, 4);

for nfile = 1:Number_of_measurements
  if(1)
   % try
    ii = 0;
    clear clean_timetag
    clean_timetag(1,:) = [0, 0];
    state_in_file = zeros(1, 16);  %if we don't change ion bases measurements
    %% load
    nfile
    %timetags
    clearvars TAGS tags_filename delimiter startRow formatSpec fileID dataArray ans;
    tags_filename = strcat(timetag_root_folder, timetag_files{nfile})
    delimiter = '\t';
    startRow = 2;
    formatSpec = '%f%f%[^\n\r]';
    fileID = fopen(tags_filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    TAGS = [dataArray{1:end-1}];
    TAGS(:,1) = TAGS(:,1)/1e6;  % to us from ps
    
    %PMT and cam 
    clearvars ion_filename delimiter startRow formatSpec fileID PMTdataArray dataArray ans;
    ion_filename = strcat(trics_root_folder, trics_folder_arr{nfile})
    delimiter = '\t';
    startRow = 2;
    formatSpec = '%s%s%f%s%s%s';
    for it = 1:seq_cycles
        formatSpec = strcat(formatSpec, '%f');
    end
    formatSpec = strcat(formatSpec, '%[^\n\r]');
    %fileID = fopen([ion_filename filesep 'PMT1_2.txt'],'r');% to get melting by trics
    fileID = fopen([ion_filename filesep 'PMT1_1.txt'],'r'); % to get melting from Doppler PMT
    PMTdataArray =  textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    
    formatSpec = '%*s%*s%*s';
    for it = 1:seq_cycles
        formatSpec = strcat(formatSpec, '%f');
    end
    formatSpec = strcat(formatSpec, '%[^\n\r]');
    fileID = fopen([ion_filename filesep 'camera_ion1.txt'],'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    CAM_data1 = [dataArray{1:end-1}];
    clearvars dataArray
    
    fileID = fopen([ion_filename filesep 'camera_ion2.txt'],'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    CAM_data2 = [dataArray{1:end-1}];
    clearvars dataArray
    
    k = 0;
    k2 = 0;
    cycl_num = 0;
    loop_n = 0;
    loop2_n = 0;
    attempt(nfile) = 0;
    attempt2(nfile) = 0;
    ion_basis = -1;
    trigger_time = 0;
    triggering_count1 = -1;
    triggering_count2 = -1;
    phot2 = [0 0]; phot1 = phot2;
    pairs = 0;
    valid_points =(cycl_num+1 < point_sel(2)*seq_cycles && cycl_num+1 >= point_sel(1)*seq_cycles) || no_selection; %used for selection part of the data only
    row_in_matrix =mod(timetag_bases(nfile,1)-1,3)*3+1+mod(timetag_bases(nfile,2)-1,3);
    %%phot 
    pho1 = [1 0];
    if(timetag_bases(nfile, 1) > 3)  %VH /HV swap
        pho1 = ~pho1;
    end
     pho2 = [1 0];
    if(timetag_bases(nfile, 2) > 3)  %VH /HV swap
        pho2 = ~pho2;
    end
    photon_positions = find(kron([1,1,1,1],kron(pho1,pho2)));
    if (~ ( state_norm(row_in_matrix, photon_positions(1)) >= 0))
        state_norm(row_in_matrix, photon_positions) = 0;
        state(row_in_matrix, photon_positions) = 0;
        tomo_matrix_attempts1(row_in_matrix,photon_positions) = 0;
        tomo_matrix_attempts2(row_in_matrix,photon_positions) = 0;
        photon_first(row_in_matrix,photon_positions) = 0;
    end;
   
    %% main loop for this file
    for i = 1:length(TAGS)
        if TAGS(i, 2) == ChRaman   && valid_points       %loop start
            loop_n = loop_n+1;
            phot1 = [0 0];
           
            trigger_time = TAGS(i, 1);
            attempt(nfile) = attempt(nfile)+1;
            triggering_count1 = -1;
             
            if(ion_basis >= 0 && ~click2)
                tomo_matrix_attempts1(row_in_matrix,photon_positions) = tomo_matrix_attempts1(row_in_matrix,photon_positions)+1;
             %   ii = ii+1;
              %  clean_timetag(ii,:) = TAGS(i,:);
            end
            nontr1 = time_phot1;
        end
        if TAGS(i, 2) == ChRaman2 && valid_points      
            loop2_n = loop2_n+1;
            phot2 = [0 0];
            trigger_time2 = TAGS(i, 1);
            attempt2(nfile) = attempt2(nfile)+1;
            triggering_count2 = -1;
            if(ion_basis >= 0 && click1)
                tomo_matrix_attempts2(row_in_matrix,photon_positions) = tomo_matrix_attempts2(row_in_matrix,photon_positions)+1; % was +2 before Feb. 18th 2021
            end
            nontr2 = time_phot2;
        end
        if TAGS(i, 2) == ChCycle           %cycle start
            cycl_num =cycl_num+1;  
            if  (cycl_num < point_sel(2)*seq_cycles && cycl_num >= 1+(point_sel(1)-1)*seq_cycles) || no_selection %selecting meas points. Not needed
                valid_points = 1;
            else
                valid_points = 0;                
                continue
            end;
                 if(cycl_num>1 && no_selection)||(cycl_num>(point_sel(1)-1)*seq_cycles +1) % +20*seq_cycles
                   phot = kron(phot1, phot2);
                   phot_state_aver(nfile, :) = phot_state_aver(nfile, :)+phot;
                   Delt = abs(loop_n-loop2_n);
                   ion_state = define_2ion_state(CAM_data1, CAM_data2, cycl_num-1, seq_cycles, threshold);
                   if (max(phot)>0    && ~isempty(find(loop_sel == (loop2_n - loop_n) ))  ) %&&  cycl_num < 20*seq_cycles &&  cycl_num >= 20*seq_cycles && mod(fix((Delt-1)/5),2) == 0   %&& loop2_n < loop_n %&& (isempty(find(loop_sel == loop_n-loop2_n)) && isempty(find(loop_sel == loop2_n-loop_n)) 
                      if(sum(phot))>1
                          oups 
                      end
                       %% pair detefcted!:
                      pairs = pairs+1; 
                      count_pair(loop_n, loop2_n)= count_pair(loop_n, loop2_n)+1; %pairs vs loops number
                    
%                       if ~isempty(find(loop_sel2 == loop_n-loop2_n))
%                       && max(ion_state)>0 %loop_sel-1 %odd spin-echo
%                       corrections
%                           %phot = kron(~phot1, phot2); %try correct odd spinechos
%                           ion_state = (kron([ 1 0; 0 1],[0 1; 1 0])*ion_state')'; %n1
%                            %ion_state = (kron([0 1; 1 0], [ 1 0; 0 1])*ion_state')';%n2
%                       end
%                       if  ~isempty(find(loop_sel2 == loop2_n-loop_n))   && max(ion_state)>0
%                           ion_state = (kron([0 1; 1 0], [ 1 0; 0 1])*ion_state')';
%                             %ion_state = (kron([ 1 0; 0 1],[0 1; 1 0])*ion_state')';
%                       end
                      ion_state_aver(nfile, :) = ion_state_aver(nfile, :)+ion_state;
                      state_in_file = state_in_file + kron(ion_state, phot);
                     
                   end
             
                   photon_first(row_in_matrix,:) = photon_first(row_in_matrix,:)+click1*kron(ion_state,kron(pho1,pho2)); 
                   %% 
                   nloops{nfile}(cycl_num-1) = loop_n;
                   nloops2{nfile}(cycl_num-1) = loop2_n;
                   if(loop_n <nloops_param(1) && loop2_n > loop_n) %|| (loop_n <nloops_param(2)+loop2_n && loop2_n < loop_n)    % triggering happened
                       if(triggering_count1 >=0 )
                            good_triggering_counts1(end+1) = triggering_count1; 
                       end
                   end
                  % if(loop2_n <nloops_param(1) && loop_n >= loop2_n) || (loop2_n <nloops_param(2)+loop_n && loop_n < loop2_n))    % triggering happened
                  if(loop2_n -loop_n < nloops_param(2)) 
                        if(triggering_count2 >=0 )
                            good_triggering_counts2(end+1) = triggering_count2; 
                        end
                  end

                  %wp for loop 1, 2, separately:
                  if(loop2_n > loop_n)
                      WP_phot1 = [WP_phot1, time_phot1];
                      WP_phot2 = [WP_phot2, time_phot2];
                  end
                  test_nontriger_phot1 = [test_nontriger_phot1, nontr1];
                  test_nontriger_phot2 = [test_nontriger_phot2, nontr2];
                  nontr1 = [];
                  nontr2 = [];
                      
                end;
            loop_n = 0;
            loop2_n = 0;
            ion_basis = define_ion_basis(PMTdataArray, cycl_num, seq_cycles, doppler_threshold);
            if(ion_basis >= 0)
%                 ii = ii+1;
%                 clean_timetag(ii,:) = TAGS(i,:);
            end
           % abs_basis = ion_basis*3+1+mod(timetag_bases(nfile)-1,3); % 
            click1 = 0;
            click2  = 0;
            time_phot1 = [];
            time_phot2 = [];
        end
        if TAGS(i, 2) == CH1 && valid_points     
            if(ion_basis >= 0)  % check for melting and being first 
                ii = ii+1;
                clean_timetag(ii,:) = TAGS(i,:);
                tdiff = TAGS(i, 1)-trigger_time;
                k = k+1;
                Counts1(k,nfile) = tdiff;
                time_phot1(end+1) = tdiff;
                triggering_count1 = tdiff;
                if( tdiff> gate_start && tdiff < gate_stop )  % CLICK!
                    
                    count_loop(loop_n) = count_loop(loop_n)+1; % checking counts vs loop number
                    if(loop_n >= loop2_n)
                        count_mem_loop(loop_n-loop2_n+1) = count_mem_loop(loop_n-loop2_n+1)+1;  % checking_eff vs mem loops
                    end
                    if ~click2
                        click1 = 1;

                        phot1 = [1 0];
                        if(timetag_bases(nfile, 1) > 3)  %VH /HV swap
                            phot1 = ~phot1;
                        end
                    end
                end
%                  if( tdiff> gate_start2 && tdiff < gate_stop2 )  % wrong CLICK!
%                     phot2 = [1 0];
%                 end 
            end
            
        end
        if TAGS(i, 2) == CH2 && valid_points     
            if (ion_basis >= 0)  % check for melting 
                ii = ii+1;
                clean_timetag(ii,:) = TAGS(i,:);
                tdiff2 = TAGS(i, 1)-trigger_time2;
                k2 = k2+1;
                Counts2(k2, nfile) = tdiff2;
                time_phot2(end+1) = tdiff2;
                triggering_count2 = tdiff2;
                
%                 if( tdiff> gate_start && tdiff < gate_stop )  % wrong CLICK!
%                     triggering_count2 = tdiff;
%                     phot1 = [0 1];
% %                     if(mod(timetag_bases(nfile),2) == 0)  %VH /HV swap
% %                         phot1 = ~phot1;
% %                     end
%                 end
                if( tdiff2> gate_start2 && tdiff2 < gate_stop2 )  % CLICK!
                    click2 = 1;
                    
                    count_loop2(loop2_n) = count_loop2(loop2_n)+1; % checking counts vs loop number
                    if(loop2_n >= loop_n)
                        count_mem_loop2(loop2_n-loop_n+1) = count_mem_loop2(loop2_n-loop_n+1)+1;  % checking_eff vs mem loops
                    end
                    phot2 = [1 0];
                    if(timetag_bases(nfile, 2) > 3)  %VH /HV swap
                        phot2 = ~phot2;
                    end
                end
            end
        end
    

    end
    pairs
    clean_timetag(:,1) = clean_timetag(:,1)*1e6;
   % save([timetag_root_folder 'clean_tags_' timetag_files{nfile} ],'clean_timetag', '-ascii', '-double' )
    state_raw(nfile,:) = state_in_file;
    state(row_in_matrix, :) = state(row_in_matrix, :)+state_in_file;
    state_norm(row_in_matrix, :) = state_norm(row_in_matrix, :)+state_in_file/attempt(nfile);
    out.ncycles{gate_number}(nfile) = cycl_num;
%     catch
%         'warning'
%         timetag_files{nfile}
%     end
  end
end



'out of the loop'
ion_state_aver
phot_state_aver
round(state)



%% phot-phot correction/normalisation
for i = 1:length(timetag_bases)
%     correction = sqrt ( phot_state_aver(i, 4)/phot_state_aver(i, 1));
%     phot_state_aver_corr(i, 1) = phot_state_aver(i, 1);
%     phot_state_aver_corr(i, 2) = phot_state_aver(i, 2)/correction;
%     phot_state_aver_corr(i, 3) = phot_state_aver(i, 3)/correction;
%     phot_state_aver_corr(i, 4) = phot_state_aver(i, 4)/correction^2;
%     state_norm(i, 1:4:end) = state(i, 1:4:end);
%     state_norm(i, 2:4:end) = state(i, 2:4:end)/correction;
%     state_norm(i, 3:4:end) = state(i, 3:4:end)/correction;
%     state_norm(i, 4:4:end) = state(i, 4:4:end)/correction^2;
%     state_norm(i,:) = state_norm(i,:)/sum(state_norm(i,:));
    %state_norm(i,:) = state(i,:)/attempt(i);
%     for j = 0:3
%         local_norm = sum(state_norm(i,j*4+1:j*4+4));
%         parity(i, j+1) =  (state_norm(i,j*4+1)+state_norm(i,j*4+4)-state_norm(i,j*4+2)-state_norm(i,j*4+3))/local_norm;
%     end

end

%phot_state_aver_corr

%out.tomo_matrix1_counts{gate_number} = corrMat_raw;
corrMat_raw(:, 1:2) = corrMat_raw(:, 1:2)+corrMat_raw2(:, 3:4);  % adding counts from complementary photon bases
corrMat_raw(:, 3:4) = corrMat_raw(:, 3:4)+corrMat_raw2(:, 1:2);
% for j = 1:9
%     tomo_matrix1(j,:) = corrMat_raw(j,:)/sum(corrMat_raw(j,:));
% end


out.state{gate_number} = state;
out.photon_first{gate_number} = photon_first;
out.state_norm{gate_number} = state_norm;
out.state_raw{gate_number} = state_raw;

out.tomo_matrix1_counts{gate_number} = corrMat_raw; %has contributions from all photonic bases
out.tomo_matrix1_counts2{gate_number} = corrMat_raw2; %has contributions only from bases 3,4,5 (V, A, L)
out.tomo_matrix_attempts1{gate_number} = tomo_matrix_attempts1;
out.tomo_matrix_attempts2{gate_number} = tomo_matrix_attempts2;
%out.Allclicks{gate_number} = Allclicks;
out.attemptsbases{gate_number} = attempt;
%     out.attempts = attempts;
%out.pmt_hist_sum = pmt_hist_sum;
%out.Allgoodcounts{gate_number} = Allgoodcounts;
%out.Allcounts = Allcounts;
%out.Allstrange = Allstrange;
out.nloops{gate_number} = nloops;
out.nloops2{gate_number} = nloops2;
out.Counts1{gate_number} = Counts1;
out.Counts2{gate_number} = Counts2;
out.WP_phot_loop1{gate_number} = WP_phot1;
out.WP_phot_loop2{gate_number} = WP_phot2;
out.test_nontriger_phot1{gate_number} = test_nontriger_phot1;
out.test_nontriger_phot2{gate_number} = test_nontriger_phot2;

out.count_loop{gate_number} = count_loop;
out.count_loop2{gate_number} = count_loop2;
out.count_mem_loop{gate_number} = count_mem_loop;
out.count_mem_loop2{gate_number} = count_mem_loop2;
out.count_pair{gate_number} = count_pair;

out.good_triggering_counts1{gate_number} =  good_triggering_counts1;
out.good_triggering_counts2{gate_number} =  good_triggering_counts2;
out.gatestart{gate_number} = gate_start;
out.gatestop{gate_number} = gate_stop;
out.clean_tags{gate_number} = clean_timetag;