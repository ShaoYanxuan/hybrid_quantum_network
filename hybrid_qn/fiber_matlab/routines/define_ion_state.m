function state = define_ion_state(CAM_data, cycl_num, seq_cycles, threshold)
i =  fix((cycl_num-1)/seq_cycles)+1;  % meas point;
j = mod(cycl_num-1, seq_cycles)+1;
if( i > length(CAM_data(:,1)) )
    state = [0, 0];
else
    if CAM_data(i, j) >= threshold   % bright
        state = [0, 1];
    else
        state = [1, 0];
    end
end
