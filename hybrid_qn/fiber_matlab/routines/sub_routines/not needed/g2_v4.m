function [N1, N2, N12, gg, delays] = g2_v4(TAGS, maxdelay, gate, dt, CH1, CH2)
N =length(TAGS) ;
Coinc = analyse_coincidendes(TAGS, maxdelay, gate, CH1, CH2);
Ch1_only = analyse_counts(TAGS, CH1,   maxdelay);
Ch2_only = analyse_counts(TAGS, CH2,   maxdelay);
delay_arr = [-maxdelay:dt:maxdelay];

figure(1000);
ch1 = histogram(Ch1_only.time_diff, delay_arr);
%ch1 = special_vk_hist(Ch1_only.time_diff, window, delay_arr);
ch1_hist = ch1.BinCounts;
figure(100);
% plot(delay_arr(1:length(ch1.BinCounts)), ch1.BinCounts/Ch2_only.attempts)
% hold on
% title('Ch 1 hist')

figure(1000);
ch2 = histogram(Ch2_only.time_diff, delay_arr);
%ch2 = special_vk_hist(Ch2_only.time_diff, window, delay_arr);
ch2_hist = ch2.BinCounts;
% figure(101)
% plot(delay_arr(1:length(ch2.BinCounts)), ch2.BinCounts/Ch2_only.attempts)
% title('Ch 2 hist')

figure(1000);
C = histogram(Coinc.eventdiff, delay_arr);
%C = special_vk_hist(Coinc.eventdiff, window, delay_arr);
coinc_hist = C.BinCounts;
figure(102);
% plot(delay_arr(1:length(C.BinCounts)), C.BinCounts/Coinc.attempts, 'linewidth', 2)
% hold on
% title('Coinc  hist')

zer = 0;
for i = 1:(length(delay_arr)-1)
    if(delay_arr(i) <= 0 && delay_arr(i+1)> 0)
        zer = i
    end;
    if(delay_arr(i) <= gate(1) && delay_arr(i+1)> gate(1))
        gate_start_bin = i-zer
    end;
    if(delay_arr(i) <= gate(2) && delay_arr(i+1)> gate(2))
   %aaa if(delay_arr(i) <= gate(1)+window && delay_arr(i+1)>gate(1)+window)
        gate_stop_bin = i-zer
    end;
    
end;
gate_length = gate_stop_bin-gate_start_bin

% figure(201)
% plot(delay_arr(1:length(C.BinCounts)), Coinc.attempts*C.BinCounts./ch2.BinCounts(1:length(C.BinCounts))./ch1.BinCounts(1:length(C.BinCounts)))

for i = 1:(length(delay_arr)-gate_stop_bin-1)
    N1(i) = sum(ch1_hist(gate_start_bin+zer:gate_stop_bin+zer))/Coinc.attempts/gate_length;  %!!!!!!!
    N2(i) = sum(ch2_hist(gate_start_bin+zer:gate_stop_bin+zer))/Coinc.attempts/gate_length;
    N12(i) = sum(coinc_hist(i:i+gate_length))/Coinc.attempts/gate_length;
    % N2(i) = sum(ch2_hist(gate_start_bin+i:gate_stop_bin+i))/Coinc.attempts/gate_length;
   % %N2 = sum(ch2_hist(i:i+gate_length));
  % % N12= sum(coinc_hist(i:i+gate_length));
    %N12(i) = coinc_hist(i)/Coinc.attempts/gate_length;
    
%     N2(i) = ch2_hist(gate_start_bin+i)/Coinc.attempts;
%     N1(i) = ch1_hist(gate_start_bin+zer)/Coinc.attempts;
%     if( N2(i)> trash*dt*1e-6*10 && N2(i)*N1(i)/(dt*1e-6*10 )^2 > trash^2) %N2(i) > 0.2*N1(i)
%         N12(i) = coinc_hist(i)/Coinc.attempts;
%     else
%         N12(i) = 0;
%         N2(i) = -1;
%         N1(i) = 1;
%     end;
%     if(N2(i)) == 0
%         N2(i) = -1;
%     end;
    gg(i) = N12(i)/N1(i)/N2(i)/gate_length;
    delays(i) = delay_arr(i);
end;
N12 = N12*gate_length;
% N1(i)
% figure(202)
% plot(delays, N2, 'linewidth', 2)
% title('N2 ')
% hold on


% figure(204)
% plot(delays, N2.*N1, 'linewidth', 2)
% hold on
% plot(delays, N12, 'linewidth', 2)
% hold on
% plot(delays, N2.*N2, 'linewidth', 2)
% title('N2*N1, N12, N2*N2 ')

i
