function state = define_2ion_state(CAM_data1, CAM_data2, cycl_num, seq_cycles, threshold)
i =  fix((cycl_num-1)/seq_cycles)+1;  % meas point;
j = mod(cycl_num-1, seq_cycles)+1;
if( i > length(CAM_data1(:,1)) )
    state1 = [0, 0];
else
    if CAM_data1(i, j) >= threshold   % bright
        state1 = [0, 1];
    else
        state1 = [1, 0];
    end
    if CAM_data2(i, j) >= threshold   % bright
        state2 = [0, 1];
    else
        state2 = [1, 0];
    end
end
state = kron(state2, state1);
