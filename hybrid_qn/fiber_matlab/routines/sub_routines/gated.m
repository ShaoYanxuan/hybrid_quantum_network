function new_tags = gated(TAGS, CH,  gate)
%throws away all events of channel = CH which are not withinin the gate
N =length(TAGS) ;
k = 0;
CH0 = 0; % Trigger channel 
trigger_time = 0;
new_tags = zeros(N, 2);
new_tags(:, 2) = new_tags(:, 2)-1; % set to non-existing channel;
new_tags(:, 1) = new_tags(:, 1)+TAGS(N,1); % set the time of events to the last time of original array, as it will fill the dummy end of new_tags arrray
for i = 1:N
    if(TAGS(i,2) ~= CH)
        k = k+1;
        new_tags(k,:) = TAGS(i,:);
        if(TAGS(i,2) == CH0)
            trigger_time = TAGS(i, 1);
        end;
    else
        tdiff = TAGS(i, 1)-trigger_time;
        if(tdiff >= gate(1) && tdiff < gate(2))
            k = k+1;
            new_tags(k,:) = TAGS(i,:);
        end
    end;
end;




