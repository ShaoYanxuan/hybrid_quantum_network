function [ g2, delays] = g2_v3(TAGS, maxdelay, window, dt, CH1, CH2)
N =length(TAGS) ;
%Coinc = analyse_coincidendes(TAGS, maxdelay, gate, CH1, CH2);
Ch1_only = analyse_counts(TAGS, CH1,   maxdelay);
Ch2_only = analyse_counts(TAGS, CH2,   maxdelay);
bin_arr = [0:dt:window];
delay_arr = [-maxdelay:dt:maxdelay];

figure(1000);
ch1 = histogram(Ch1_only.time_diff, bin_arr);
%ch1 = special_vk_hist(Ch1_only.time_diff, window, delay_arr);
ch1_hist = ch1.BinCounts;
figure(100);
% plot(delay_arr(1:length(ch1.BinCounts)), ch1.BinCounts/Ch2_only.attempts)
% hold on
% title('Ch 1 hist')

figure(1000);
ch2 = histogram(Ch2_only.time_diff, bin_arr);
%ch2 = special_vk_hist(Ch2_only.time_diff, window, delay_arr);
ch2_hist = ch2.BinCounts;
% figure(101)
% plot(delay_arr(1:length(ch2.BinCounts)), ch2.BinCounts/Ch2_only.attempts)
% title('Ch 2 hist')

figure(1000);
%C = histogram(Coinc.eventdiff, delay_arr);
%C = special_vk_hist(Coinc.eventdiff, window, delay_arr);
%coinc_hist = C.BinCounts;
%figure(102);
% plot(delay_arr(1:length(C.BinCounts)), C.BinCounts/Coinc.attempts, 'linewidth', 2)
% hold on
% title('Coinc  hist')

%[gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(bin_arr, gate); %search gate inicies-------

% figure(201)
% plot(delay_arr(1:length(C.BinCounts)), Coinc.attempts*C.BinCounts./ch2.BinCounts(1:length(C.BinCounts))./ch1.BinCounts(1:length(C.BinCounts)))
delays = delay_arr(1:length(delay_arr)-1);
g2 = delays./delays-1;
for i = round(maxdelay/dt)+1:(length(bin_arr)-round(maxdelay/dt)-1)
    gate = [bin_arr(i), bin_arr(i)+dt]
    Coinc = analyse_coincidendes(TAGS, maxdelay, gate, CH1, CH2);
    hist_coinc = histogram(Coinc.eventdiff, delay_arr);
    g2 = g2+hist_coinc.BinCounts/ch1_hist(i)/ch2_hist(i)*Coinc.attempts;
      
    
end;
delays = delay_arr(1:length(delay_arr)-1);
g2 = g2/i;
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
