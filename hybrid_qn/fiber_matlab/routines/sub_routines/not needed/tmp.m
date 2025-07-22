
k = 0;
tdiff = zeros(n,1);
trigger_time = zeros(n,1);
it = zeros(n,1);
for i = 1:n-2;
     if TAGSt(i, 2) == 0 %Raman trigger
         k = k+1;
         trigger_time(k) = TAGSt(i, 1);
        it(k) = i;
        if(k>2)
            tdiff(k) = trigger_time(k,1)-trigger_time(k-1,1);
        end
     end
     
end;