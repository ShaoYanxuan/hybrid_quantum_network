% Given "path" between Alice and Bob in the network 
% and the total time "T" needed for one entanglement distribution via satellite, 
% find the "optimal fidelity" via fiber with the optimal placement of repeaters ("optimal path") 

function [optimal_fidelity, optimal_path] = fiber_fidelity_saving_path(path, T, Fswap, purified_F_final, purified_F_final_099)

standardbell;standardpolns;

% parameters used
gamma = 0.0173; c = 2e5; tau = 175e-6; P0 = 0.21;

% add possible intermediate repeaters to long edges
while max(path)>61.7
    [a,b] = max(path);
    path = [path(1:b-1),a/8,a/8,a/8,a/8,a/8,a/8,a/8,a/8,path(b+1:end)];
end

if length(path)==0
    optimal_fidelity = 1; optimal_path = [];
end

% the case when no repeaters are in between 
if length(path)==1
    eta_t = 10^(-gamma*path(1));
    Tj = (2*path(1)/c+tau)/(P0*eta_t)/10;       %10 quantum memories either way at trapped-ion repeaters
    if 1<floor(T/Tj)
        optimal_path = path; 
        if floor(T/Tj)<2001
            optimal_fidelity = purified_F_final_099(floor(T/Tj));
        else
            optimal_fidelity = purified_F_final_099(end);
        end
    else
        optimal_fidelity = 0; optimal_path = [];
    end
end


if length(path)>1 
    if  mod(length(path),2)==1    % length of path needs to be an even number
        neighbor_length = path(1:end-1)+path(2:end);
        [x,i]=min(neighbor_length);
        path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
    end

    % if path length too large, combine short edges (and remain the length an even number)
    while length(path)>60
        for j=1:2
            neighbor_length = path(1:end-1)+path(2:end);
            [x,i]=min(neighbor_length);
            path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
        end
    end
    
    % calculate the end-to-end fidelity while reducing the number of
    % repeaters to find the optimal fidelity
    optimal_fidelity = 0; optimal_path = [];

    % reduce the number of repeaters until path length is 2
    for iter=1:length(path)/2-1
        % remove one photon repeater and one ion repeater
        for j=1:2
            neighbor_length = path(1:end-1)+path(2:end);
            [x,i]=min(neighbor_length);
            path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
        end
        % calculate the entanglement distribution time for neighboring ion repeaters
        Tj_effective = [];
        nu = log2(length(path)/2);
        for i=1:length(path)/2
            lj = max(path(2*i-1),path(2*i)); 
            eta_t = 10^(-gamma*lj);
            Tj_effective(end+1) = (lj/c+tau)/(P0^2*eta_t^2)*3^nu/2^(nu-1)/10; 
        end
        % purify_t = T/(3/2)^nu; %3^nu*2^(nu-1);
        
        % calculate the end-to-end fidelity
        if T>max(Tj_effective) 
            % && floor(purify_t/min(Tj_effective))<=1300
            path_fidelity = [];
            for i=1:length(Tj_effective)
                if floor(T/Tj_effective(i))<=1300
                    path_fidelity(end+1) = purified_F_final(floor(T/Tj_effective(i)));
                else
                    path_fidelity(end+1) = 1;
                end
            end
            final_fidelity = swapping_path(path_fidelity, Fswap); 
            if final_fidelity>optimal_fidelity
                optimal_fidelity = final_fidelity; optimal_path = path;
            end
        end
    end

    % calculate the end-to-end fidelity with no repeaters
    eta_t = 10^(-gamma*sum(path));
    Tj = (2*sum(path)/c+tau)/(P0*eta_t)/10;
    if 1<floor(T/Tj) && floor(T/Tj)<=2000
        final_fidelity = purified_F_final_099(floor(T/Tj));
        if final_fidelity>optimal_fidelity
            optimal_fidelity = final_fidelity; 
            optimal_path = [sum(path)];
        end
    end


end
