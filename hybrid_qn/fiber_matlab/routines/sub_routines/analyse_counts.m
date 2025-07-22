function Channeldata = analyse_counts(TAGS, CH,  gate_length, CH_R  )
if nargin<4
  CH_R = 3;
end

N =length(TAGS) ;
attempts = 0;
k = 1;

for i = 1:N
    if TAGS(i, 2) == CH_R %Raman trigger
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
    end;
    
end;
Channeldata.length = k-1;
for i = N:-1:2
    if TAGS(i, 2) == CH_R %Raman trigger
        trigger_time = TAGS(i, 1);
        for j = i-1:-1:1
            tdiff = TAGS(j, 1)-trigger_time;
            if(tdiff>0)
                'warning'
               tdiff
            end
            if(tdiff< -1*gate_length )
                break;
            end
            if TAGS(j, 2) == CH
                timediff_arr(k) = tdiff;
                time_arr(k) = TAGS(j, 1);
                k = k+1;
            end;
        
        end;
    end;
    
end;
Channeldata.attempts = attempts;
Channeldata.time_diff = timediff_arr;
Channeldata.times = time_arr;

Channeldata.efficiency = Channeldata.length/Channeldata.attempts;