function optimal_fidelity = fiber_fidelity(path, T, Fswap, purified_F_final)

standardbell;standardpolns;

gamma = 0.0173; c = 2e5; T0 = 175e-6; P0 = 0.21;
if mod(length(path),2)==1
    neighbor_length = path(1:end-1)+path(2:end);
    [x,i]=min(neighbor_length);
    path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
end

while length(path)>42
    for j=1:2
        neighbor_length = path(1:end-1)+path(2:end);
        [x,i]=min(neighbor_length);
        path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
    end
end

fidelity_list = []; 
for iter=1:length(path)/2-2
    for j=1:2
        neighbor_length = path(1:end-1)+path(2:end);
        [x,i]=min(neighbor_length);
        path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
    end
    Tj_list = [];
    for i=1:length(path)/2
        lj = max(path(2*i-1),path(2*i)); 
        eta_t = 10^(-gamma*lj);
        Tj_list(end+1) = (lj/c+T0)/(P0^2*eta_t^2)*3/2;
    end
    nu = log2(length(path)/2+1);
    purify_t = T/3^(nu-1)*2^(nu-2);
    path_fidelity = [];
    if purify_t>max(Tj_list)
        for i=1:length(Tj_list)
            path_fidelity(end+1) = purified_F_final(floor(purify_t/Tj_list(i)));
        end
        fidelity_list(end+1) = swapping_path(path_fidelity, Fswap);
    end

end

optimal_fidelity = max(fidelity_list);
