function out = tomo_matrix_timetags_cam_manual_memory(timetag_root_folder, trics_root_folder, trics_folder_arr,  timetag_files,timetag_bases,  ChRaman,ChRaman2, CH1, CH2, ChCycle, threshold, doppler_threshold, seq_cycles,  gate_start, gate_stop, gate_number, ion, loop_sel)
% if length(real_cycl_start1) == 1
%     real_cycl_start(nfile) = real_cycl_start1;
% else 
%     real_cycl_start = real_cycl_start1;
% end
loop_corr_sel = [8:13, 20:25, 32:37, 44:49,56:61]-1;


Number_of_measurements = length(trics_folder_arr);
nloops_param = 27;
corrMat_raw = zeros(9,4);
corrMat_raw2 = zeros(9,4);
tomo_matrix_attempts1 = zeros(9,4);
ii = 0;
good_triggering_counts1 = [];
good_triggering_counts2 = [];

Counts1 = [];
Counts2 = [];

clean_timetag(1,:) = [0, 0];
for nfile = 1:Number_of_measurements
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
    fileID = fopen([ion_filename filesep 'PMT1_2.txt'],'r');
    PMTdataArray =  textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    
    formatSpec = '%*s%*s%*s';
    for it = 1:seq_cycles
        formatSpec = strcat(formatSpec, '%f');
    end
    formatSpec = strcat(formatSpec, '%[^\n\r]');
    fileID = fopen([ion_filename filesep 'camera_ion' int2str(ion) '.txt'],'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    CAM_data = [dataArray{1:end-1}];
    
    k = 0;
    k2 = 0;
    cycl_num = 0;
    loop_n = 0;
    loop2_n = 0;
    attempt(nfile) = 0;
    ion_basis = -1;
    trigger_time = 0;
    triggering_count1 = -1;
    triggering_count2 = -1;
    corr_loop = zeros(1,4);
    corr_loop2 =  zeros(1,4);
    %% main loop for this file
    for i = 1:length(TAGS)
        if TAGS(i, 2) == ChRaman         %loop start
            loop_n = loop_n+1;
            trigger_time = TAGS(i, 1);
            attempt(nfile) = attempt(nfile)+1;
            triggering_count1 = -1;
             triggering_count2 = -1;
            if(ion_basis >= 0)
                tomo_matrix_attempts1(abs_basis,:) = tomo_matrix_attempts1(abs_basis,:)+1;
                ii = ii+1;
               % clean_timetag(ii,:) = TAGS(i,:);
            end
        end
         if TAGS(i, 2) == ChRaman2
             loop2_n = loop2_n+1;
         end
        if TAGS(i, 2) == ChCycle           %cycle start
            cycl_num =cycl_num+1;
                 if(cycl_num>1)
                     if(abs_basis>0 && ~isempty(find(loop_sel == (loop_n - loop2_n) ))    )%  && loop_n<loop2_n  && ~isempty(find(loop_sel == abs(loop2_n - loop_n) ))  )%&& && loop_n<=loop2_n && loop_n<loop2_n  &&   abs(loop2_n - loop_n)>11 && loop_n<loop2_n) %21&&   abs(loop2_n - loop_n)< 30) %&& loop2_n> loop_n % && (loop_n < loop2_n) )%%(loop2_n == loop_n) )%&& loop_n<6 )% && (loop_n < loop2_n) &&(loop2_n - loop_n < 6) )(abs(loop2_n - loop_n) < 1000)
%                     
%                          if  ~isempty(find(loop_corr_sel == (loop2_n - loop_n) ))  && ion_basis ~= 1  % odd echo correction (y-correction)
%                              corr_loop = (kron(eye(2),[0 1; 1 0])*corr_loop')';
%                              corr_loop2 = (kron(eye(2),[0 1; 1 0])*corr_loop2')';
%                           
%                          end
                         
                         corrMat_raw(abs_basis,:) = corrMat_raw(abs_basis,:)+corr_loop; 
                         corrMat_raw2(abs_basis,:) = corrMat_raw2(abs_basis,:)+corr_loop2;
                     end
                     corr_loop = zeros(1,4);corr_loop2 = zeros(1,4);
                       nloops{nfile}(cycl_num-1) = loop_n;
                       if(loop_n <nloops_param)    % triggering happened
                           if(triggering_count1 >=0 )
                                good_triggering_counts1(end+1) = triggering_count1; 
                           end
                            if(triggering_count2 >=0 )
                                good_triggering_counts2(end+1) = triggering_count2; 
                            end
                       end
                end;
            loop_n = 0;
            loop2_n = 0;
            ion_basis = define_ion_basis(PMTdataArray, cycl_num, seq_cycles, doppler_threshold);
            if(ion_basis < 0)
                melte = 1;
            end
            abs_basis = ion_basis*3+1+mod(timetag_bases(nfile)-1,3); % 
           
        end
        if TAGS(i, 2) == CH1 
            if(ion_basis >= 0)  % check for melting 
                ii = ii+1;
                %clean_timetag(ii,:) = TAGS(i,:);
                tdiff = TAGS(i, 1)-trigger_time;
                k = k+1;
                Counts1(k,nfile) = tdiff;
                if( tdiff> gate_start && tdiff < gate_stop )  % CLICK!
                    triggering_count1 = tdiff;
                    ion_state = define_ion_state(CAM_data, cycl_num, seq_cycles, threshold);  % retuns [1 0] if dark [0 1] if bright
                     
                    if(timetag_bases(nfile)<=3) % H D R
                        %corrMat_raw(abs_basis, 1:2) = corrMat_raw(abs_basis, 1:2)+ ion_state; 
                        corr_loop(1:2) = corr_loop(1:2)+ion_state;
                    else  % V A L
                        %corrMat_raw2(abs_basis, 1:2) = corrMat_raw2(abs_basis, 1:2)+ ion_state; 
                        corr_loop2(1:2) = corr_loop2(1:2)+ion_state;
                    end
                end
            end
            
        end
        if TAGS(i, 2) == CH2 %&& loop_n <21
            triggering_count2 = TAGS(i, 1)-trigger_time;;
            if(ion_basis >= 0)  % check for melting 
                ii = ii+1;
               % clean_timetag(ii,:) = TAGS(i,:);
                tdiff = TAGS(i, 1)-trigger_time;
                k2 = k2+1;
                Counts2(k2, nfile) = tdiff;
                
                if( tdiff> gate_start && tdiff < gate_stop )  % CLICK!
                    
                    ion_state = define_ion_state(CAM_data, cycl_num, seq_cycles, threshold);  % retuns [1 0] if dark [0 1] if bright
                      
                    if(timetag_bases(nfile)<=3) % H D R
                        %corrMat_raw(abs_basis, 3:4) = corrMat_raw(abs_basis, 3:4)+ ion_state; 
                        corr_loop(3:4) = corr_loop(3:4)+ion_state;
                    else  % V A L
                        %corrMat_raw2(abs_basis, 3:4) = corrMat_raw2(abs_basis, 3:4)+ ion_state;
                        corr_loop2(3:4) = corr_loop2(3:4)+ion_state;
                    end
                end
            end
        end


    end
    
end
'out of the loop'

out.tomo_matrix1_counts1{gate_number} = corrMat_raw;
%% try independent normalizations
tomo_matrix1 = zeros(9,4);
S1 = sum(corrMat_raw,2);
S2 = sum(corrMat_raw2,2);
corrMat= corrMat_raw./S1;
corrMat2= corrMat_raw2./S2;
corrMat(isnan(corrMat)) = 0;
corrMat2(isnan(corrMat2)) = 0;
 tomo_matrix1(:, 1:2) = corrMat(:, 1:2)+corrMat2(:, 3:4);
  tomo_matrix1(:, 3:4) = corrMat(:, 3:4)+corrMat2(:, 1:2);
  %%
corrMat_raw(:, 1:2) = corrMat_raw(:, 1:2)+corrMat_raw2(:, 3:4);  % adding counts from complementary photon bases
corrMat_raw(:, 3:4) = corrMat_raw(:, 3:4)+corrMat_raw2(:, 1:2);
tomo_matrix1 =tomo_matrix1./sum(tomo_matrix1,2); % Ben's normalisation

% for j = 1:9
%     tomo_matrix1(j,:) = corrMat_raw(j,:)/sum(corrMat_raw(j,:));
% end

out.tomo_matrix1{gate_number} = tomo_matrix1;
out.tomo_matrix1_counts{gate_number} = corrMat_raw; %has contributions from all photonic bases
out.tomo_matrix1_counts2{gate_number} = corrMat_raw2; %has contributions only from bases 3,4,5 (V, A, L)
out.tomo_matrix_attempts1{gate_number} = tomo_matrix_attempts1;
%out.Allclicks{gate_number} = Allclicks;
out.attemptsbases{gate_number} = attempt;
%     out.attempts = attempts;
%out.pmt_hist_sum = pmt_hist_sum;
%out.Allgoodcounts{gate_number} = Allgoodcounts;
%out.Allcounts = Allcounts;
%out.Allstrange = Allstrange;
out.nloops{gate_number} = nloops;
out.Counts1{gate_number} = Counts1;
out.Counts2{gate_number} = Counts2;
out.good_triggering_counts1{gate_number} =  good_triggering_counts1;
out.good_triggering_counts2{gate_number} =  good_triggering_counts2;
out.gatestart{gate_number} = gate_start;
out.gatestop{gate_number} = gate_stop;
%out.clean_tags{gate_number} = clean_timetag;