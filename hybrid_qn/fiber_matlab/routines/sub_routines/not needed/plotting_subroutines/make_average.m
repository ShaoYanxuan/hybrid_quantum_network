function y = make_average(data, N)
if(N == 1)
    y = data;
else
    L = length(data(:,1));
    for i = 1:fix((L-N)/N)
        y(i,1) = data((i-1)*N+fix(N/2),1);
        y(i,2) = sum(data((i-1)*N+1:i*N,2)); % /N;  no dividing by N for distributions
    end
    
end;