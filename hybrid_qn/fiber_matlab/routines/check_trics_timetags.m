function y = check_trics_timetags(timetag_root_folder, trics_root_folder, trics_folder_arr,  timetag_files,timetag_bases,  ChRaman, CH1, CH2, ChCycle, threshold, doppler_threshold, seq_cycles,  gate_start, gate_stop, delay_to_second, gate_number, cut_factor)
seq_start = 0;   
Number_of_measurements = length(trics_folder_arr);

good_triggering_counts1 = [];
good_triggering_counts2 = [];

gate_start2 = gate_start+delay_to_second;
gate_stop2 = gate_stop+delay_to_second;



for nfile = 1:Number_of_measurements
    ii = 0;
   
    nfile
    %% timetags
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
    
    %%PMT and cam 
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
    
    loop_start{nfile} = zeros(round(length(TAGS)/cut_factor),1);
    cycle_start{nfile} = [];
    npoint_start{nfile} = [];
    trics_point_start{nfile} = [];
    k = 0;
    k2 = 0;
    k_l = 0;
    cycl_num = 0;
    loop_n = 0;
    attempt(nfile) = 0;
    ion_basis = -1;
    trigger_time = 0;
    triggering_count1 = -1;
    triggering_count2 = -1;
    phot2 = [0 0]; phot1 = phot2;
    pairs = 0;
    
   
   
    %% main loop for this file
    for i = 1:round(length(TAGS)/cut_factor)
        if TAGS(i, 2) == ChRaman         %loop start
            loop_n = loop_n+1;
            k_l = k_l+1;
            loop_start{nfile}(k_l) = TAGS(i, 1);
            
            attempt(nfile) = attempt(nfile)+1;
            
            if(ion_basis >= 0)
                tomo_matrix_attempts1(row_in_matrix,photon_positions) = tomo_matrix_attempts1(row_in_matrix,photon_positions)+1;
             %   ii = ii+1;
              %  clean_timetag(ii,:) = TAGS(i,:);
            end
        end
        if TAGS(i, 2) == ChCycle           %cycle start
            cycl_num =cycl_num+1;
            if (cycl_num >seq_start)
                cycle_start{nfile}(end+1) = TAGS(i, 1);
                if(mod(cycl_num-seq_start, seq_cycles) == 1)
                    npoint_start{nfile}(end+1) = TAGS(i, 1);
                    trics_point_start{nfile}(end+1,:) = define_trics_times(PMTdataArray, cycl_num-seq_start, seq_cycles);

                end;

                loop_n = 0;
            end          
           
        end
    end
        
        
    
    y.ncycles{gate_number}(nfile) = cycl_num;
    
end



'out of the loop'
%y.nloops= nloops;
y.attemptsbases = attempt;
y.loop_start = loop_start;
y.cycle_start = cycle_start;
y.npoint_start = npoint_start;
y.trics_point_start = trics_point_start;



end