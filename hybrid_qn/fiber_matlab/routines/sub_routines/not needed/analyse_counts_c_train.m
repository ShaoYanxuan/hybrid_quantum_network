function Channeldata = analyse_counts_c_train(TAGS, CH,  hist_length, gates )
N =length(TAGS) ;
attempts = 0;
k = 1;
i = 1;
max_gate = length(gates(:,1));
cond_counts= zeros(length(gates(:,1)),1);
while i <= N
    if TAGS(i, 2) == 0 %Raman trigger
        attempts = attempts+1;
        gate_ind = 1; 
        trigger_time = TAGS(i, 1);
        for j = 1:N-i
            tdiff = TAGS(i+j, 1)-trigger_time;
            if(tdiff> hist_length )
                break;
            end
            if TAGS(i+j, 2) == CH
                timediff_arr(k) = tdiff;
                time_arr(k) = TAGS(i+j, 1);

                if(gate_ind)
                   % gate_ind
                    if(tdiff > gates(gate_ind,1) && tdiff < gates(gate_ind,2) )
                        %tdiff_arr(, gate_ind) = tdiff
                        cond_counts(gate_ind) = cond_counts(gate_ind)+1;
                        gate_ind = gate_ind +1;
                        if(gate_ind>max_gate)
                            gate_ind = 0;
                        end
                    else
                        if gate_ind > 1
                            gate_ind = 0;
                        else
                            gate_ind = 1;
                        end
                    end
                end
                k = k+1;
            end;
        
        end;
        i = i+j-1;
    end;
    i = i+1;    
end;
Channeldata.length = k-1;
i = N;
while i >=2
    if TAGS(i, 2) == 0 %Raman trigger
        trigger_time = TAGS(i, 1);
        for j = i-1:-1:1
            tdiff = TAGS(j, 1)-trigger_time;
            if(tdiff< -1*hist_length )
                break;
            end
            if TAGS(j, 2) == CH
                timediff_arr(k) = tdiff;
                time_arr(k) = TAGS(j, 1);
                k = k+1;
            end;
        
        end;
        i = j;
    end;
    i = i-1;
    
end;
Channeldata.attempts = attempts;
Channeldata.time_diff = timediff_arr;
Channeldata.times = time_arr;
Channeldata.cond_counts = cond_counts;
Channeldata.efficiency = Channeldata.length/Channeldata.attempts;