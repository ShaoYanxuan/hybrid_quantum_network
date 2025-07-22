function [counts, noisecounts] = efficiency_from_hystogram(input, attempts, gate, delay_arr, noise_delay,noise_window)
% for i = 1:(length(delay_arr)-1)
%     if(delay_arr(i) <= 0 && delay_arr(i+1)> 0)
%         zer = i;
%     end;
%     if(delay_arr(i) <= gate(1) && delay_arr(i+1)> gate(1))
%         gate_start_bin = i;
%     end;
%    if(delay_arr(i) <= gate(2) && delay_arr(i+1)> gate(2))
%          gate_stop_bin = i;
%     end;
%     
% end;
%gate_length = gate_stop_bin-gate_start_bin;
[gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(delay_arr, gate);
binsize = (gate(2)-gate(1))/gate_length;
noise_bins = round(noise_window/binsize);
delay = round(noise_delay/binsize);
counts = sum(input(gate_start_bin:gate_stop_bin));
noisecounts = sum(input(gate_stop_bin+delay:gate_stop_bin+delay+noise_bins));
eff = (counts-noisecounts)/attempts;
noise_prob = (noisecounts)/attempts/noise_bins*gate_length;