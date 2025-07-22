function [gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(delay_arr, gate)
% gate(1) = -2, gate(2) = 30
if(delay_arr(1) > gate(1) )
        gate_start_bin = 1;
end
zer = 0;
for i = 1:(length(delay_arr)-1)
    if(delay_arr(i) <= 0 && delay_arr(i+1)> 0)
        zer = i;
    end;
    if(delay_arr(i) <= gate(1) && delay_arr(i+1)> gate(1))
        gate_start_bin = i;
    end;
   if(delay_arr(i) <= gate(2) && delay_arr(i+1)> gate(2))
         gate_stop_bin = i;
    end;
    
end;
gate_length = gate_stop_bin-gate_start_bin;