function optimal_T = path_optimal(path, minimumT, Fswap, purified_F_final)

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

optimal_T_list = [];
% for iter=1:length(path)/2-2
% min_totalT = 10e100; min_t_path_length = [];
for iter=1:length(path)/2-2
    for j=1:2
        neighbor_length = path(1:end-1)+path(2:end);
        [x,i]=min(neighbor_length);
        path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
    end
    Tj_list = [];       % average time for one entanglement for each segment
    for i=1:length(path)/2
        lj = max(path(2*i-1),path(2*i)); 
        eta_t = 10^(-gamma*lj);
        Tj_list(end+1) = (lj/c+T0)/(P0^2*eta_t^2)*3/2/10;    % average time cut if there are 10 trapped-ions at each node for each way
    end

    nu = log2(length(path)/2+1);
    purify_t0 = minimumT/3^(nu-1)*2^(nu-2);
    totalT = [10e100,10e100]; totalt = 10e100; purify_t = purify_t0; deltat = 0;
    while totalt<=totalT(end-1) && purify_t/min(Tj_list)<1000
        purify_t = purify_t0*(1+0.1*deltat);
        if purify_t>max(Tj_list)        % at least one entanglement can be established at all segments
            path_fidelity = [];
            for i=1:length(Tj_list)
                path_fidelity(end+1) = purified_F_final(floor(purify_t/Tj_list(i)));
            end
            final_fidelity = swapping_path(path_fidelity, Fswap); 
            fidelity = final_fidelity; i = 1;
            while final_fidelity<0.86
                i = i+1; 
                final_fidelity = purification_average(final_fidelity,i);
            end
            totalt = purify_t*i*3^(nu-1)/2^(nu-2);
            totalT(end+1) = totalt;
            % if totalt<min_totalT
            %     min_totalT = totalt;
            %     min_t_path_length = path;
            % end
        end
        deltat = deltat+1;
    end
    totalT = totalT(3:end);
    if length(totalT)>0
        optimal_T_list(end+1) = min(totalT);
    end
end

optimal_T = min(optimal_T_list);
