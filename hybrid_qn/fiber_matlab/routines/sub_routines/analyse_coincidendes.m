function Coinc = analyse_coincidendes(TAGSn, maxdelay, gate, CH1, CH2)
TAGS = TAGSn;% gated(TAGSn, CH2, gate);
N =length(TAGS) ;
attempts = 0;
kk = 1;
bound = 0;
event = 0;
CH_R = 0;
eventdiff_arr(1)= -1*maxdelay;
for i = 1:N
    if(i>=event)
        if(bound>0) 
            if(TAGS(N, 1)-TAGS(i, 1)<maxdelay+gate(2) )  %cant have +maxdelay anymore
                break
            end
            if TAGS(i, 2) == CH_R %Raman trigger
                attempts = attempts+1;
                trigger_time = TAGS(i, 1);
                for j = 1:N-i
                    tdiff = TAGS(i+j, 1)-trigger_time;
                    if(tdiff> gate(2) )
                        break;
                    end
                    if TAGS(i+j, 2) == CH1 && tdiff > gate(1)
                       %---------go search another channel now-----------
                        event = i+j;
                        eventtime = TAGS(event, 1);
                        for k = 1:(N-event)
                            eventdiff = TAGS(event+k, 1)-eventtime;
                            if(eventdiff> maxdelay )
                                break;
                            end
                            if TAGS(event+k, 2) == CH2
                                eventdiff_arr(kk) = eventdiff;
                               % time_arr(kk) = TAGS(i+j, 1);
                                kk = kk+1;
                            end;
                        end;
                        for k = 1:(event-1);
                            eventdiff = TAGS(event-k, 1)-eventtime;
                            if(abs(eventdiff)> maxdelay )
                                break;
                            end
                            if TAGS(event-k, 2) == CH2
                                eventdiff_arr(kk) = eventdiff;
                               % time_arr(kk) = TAGS(i+j, 1);
                                kk = kk+1;
                            end;
                        end;

                       %--------------------
                    end;

                end;

            end;
        else
            if TAGS(i, 1)> maxdelay  %we can have -maxdelay only now
                bound = i;
            end
        end;
    end;
end;
Coinc.eventdiff = eventdiff_arr;
Coinc.attempts = attempts;
Coinc.number = kk-1;
Coinc.prob = Coinc.number/Coinc.attempts;
