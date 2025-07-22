function Channeldata = analyse_counts_c(TAGS, CH,  gate_length )
N =length(TAGS) ;
attempts = 0;
k = 1;
i = 1;
while i <= N
    if TAGS(i, 2) == 0 %Raman trigger
        attempts = attempts+1;
        trigger_time = TAGS(i, 1);
        for j = 1:N-i
            tdiff = TAGS(i+j, 1)-trigger_time;
            if(tdiff> gate_length )
                break;
            end
            if TAGS(i+j, 2) == CH
                timediff_arr(k) = tdiff;
                time_arr(k) = TAGS(i+j, 1);
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
            if(tdiff< -1*gate_length )
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

Channeldata.efficiency = Channeldata.length/Channeldata.attempts;