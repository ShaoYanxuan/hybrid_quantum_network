function data_out = add_distinguishability_coinc(data_in, data2_in, d )
N = length(data_in(:,1));
N2 = length(data2_in(:,1));
k = 1;
data_out = zeros(N,1);
for i = 1:N
    if(k <= N2)   % matching the ranges
        if(data_in(i,1) == data2_in(k,1))
            ratio_in = data_in(i,2)/data2_in(k,2);
            ratio_out = ratio_in+d*(1-ratio_in);
            data_out(i) = ratio_out.*data2_in(k,2);
            k = k+1;
        else
            if(i > 1)
               data_out(i) = data_out(i-1); 
            end
        end;
    end;
end;