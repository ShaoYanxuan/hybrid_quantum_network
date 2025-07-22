fsep = filesep;
%% Victor's laptop:

datt = '2021_03_05';
% , 200 loops auto
timetag_files = {'220852', '221001', '221113', '221233', '221347', '221504',...
    '222617', '222730', '222842', '222954', '223106', '223221'};
for iii = 1:length( timetag_files)
    timetag_files{iii}= [datt '_' timetag_files{iii} '.txt'];
end
server_path =[fsep fsep 'zidshare.uibk.ac.at' fsep 'qos' fsep 'qfc']
timetag_root = [server_path fsep 'measurements' fsep 'QFC' fsep datt fsep];

Total_attempts = 0;
MaxFile = length(timetag_files) ; 

dt =1   ;        % time step for the wavepackets and integrated curves.
binwidths = [1];
histlength = 4000;   % length of the histograms in us %trigger each loop  %histlength = 20000; %triger each cycle
gate = [-10 0];  % gate for the photons that are overlapped - blue lines on plot;        %gate = [3231 3269]  %triiger each cycle     
gate_disting_ = {125+132+[0,0+60],250+125+132+[0,0+60]};%  gate {1st,2nd}files         % gate for the first of reference photon (long path)  - red lines on plots
TriggerCH = 3;
det_CH = {6,2}; % clicks channels  
delay_disting =60;                                      % additional delay between 1st(long) and 2nd(short) ref. photons 
w = 30; 

;                                       %length in us of the window used to estimate the noise floor (green lines on plot)
noise_del = 120;                                          % ROI for noise counts wrt gate
         % number of Monte Carlo realizations. Need to have poissrnd function to make it working. see poissrnd1.m 
subtract_noise =1;      % 1 = do noise  subtraction 
    

for nfile = 1:MaxFile           %loops for several files
     nfile;
     %----------------------analysis params----------------------------
    
    maxdel = 2*histlength;
    bin_arr = -histlength:dt:histlength;
    gate_disting = gate_disting_{nfile};
    noise_window = gate_disting(2)-gate_disting(1); 
    CH = det_CH{nfile};
  
    
    [gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(bin_arr, gate); %search gate inicies-------
    timetag_file = timetag_files{nfile};                                                 %load files
    filename = strcat(timetag_root, timetag_file)
    
    %ON!! then back off to avoid reloading
    TAGS_HOM{nfile} = (load_tags(filename)); uncomment_previous_line =1;             %!!!!!!!!UNCOMMENT IT
    uncomment_previous_line;
    
    gate_len_us = gate(2)-gate(1);
    
    
    channeldata1_converted = analyse_counts(TAGS_HOM{nfile}, 2,   histlength,TriggerCH ); %2
    channeldata2_converted = analyse_counts(TAGS_HOM{nfile}, 6, histlength,TriggerCH );  %6
    attempts(nfile) = channeldata1_converted.attempts;
    
    It = 1;
    figure(It+100*nfile)
    ch1 = histogram(channeldata1_converted.time_diff, bin_arr);
    hold on
    figure(It+101*nfile)
    ch1 = histogram(channeldata2_converted.time_diff, bin_arr);
    hold on
    xlabel('Time delay, us')
    ylabel('Counts per per bin')
    title(sprintf('CH %d first run %.1f us bin, %.1e raman pulses file %d',CH, dt,channeldata1_converted.attempts, nfile ))
    xlim([0 histlength])
    grid on
    draw_gate(gate, It+100*nfile, 'blue') 
    draw_gate(gate_disting, It+100*nfile, 'red') 
    draw_gate(gate_disting+delay_disting, It+100*nfile, 'red') 
    [Counts1, attempts1, nois_counts1, eff_long(It, nfile), noise_prob_long(It, nfile)] =efficiency_from_hystogram4(ch1.BinCounts, It+100*nfile, channeldata1_converted.attempts, gate_disting, bin_arr, noise_del, noise_window,   subtract_noise);
    [Counts2, attempts2,  nois_counts2, eff_short(It, nfile), noise_prob_short(It, nfile)] =efficiency_from_hystogram4(ch1.BinCounts, It+100*nfile,channeldata1_converted.attempts, gate_disting+delay_disting, bin_arr, noise_del, noise_window,   subtract_noise);
    Counts(nfile) = Counts1+Counts2;
    Noise_counts(nfile) = nois_counts1+nois_counts2;
    Attempts(nfile) = attempts1;
    T_tot(nfile)= (TAGS_HOM{nfile}(end,1)-TAGS_HOM{nfile}(1,1))/1e6;  % total time in sec
    %pure attempts time:
    if(Calculate_Pure)
        A = find(TAGS_HOM{nfile}(:, 2) == 0);
        test = TAGS_HOM{nfile}( A(:),1);
        test2 = test(2:end); test2(end+1)=test2(end);
        Period = median(test2-test); 
        T(nfile) = Period*length(A)/1e6;  % get total time as number of attempts* duration of one , in seconds 
    else
        T(nfile) = T_tot(nfile);
    end
    fprintf('Time = %f s ; raw rate =  %f +- %f photons/s \n',  T_tot(nfile), Counts(nfile)/ T_tot(nfile), sqrt(Counts(nfile))/ T_tot(nfile))
    close( figure(It+100*nfile))
end;