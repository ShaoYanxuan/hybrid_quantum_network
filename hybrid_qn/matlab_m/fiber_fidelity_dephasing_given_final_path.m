% Given a path with the optimal placement of repeaters 
function fidelity_dephasing = fiber_fidelity_dephasing_given_final_path(path, T, Fswap, purified_F_final, purified_F_final_099,tau_de)

standardbell;standardpolns;

% parameters used
gamma = 0.0173; c = 2e5; tau = 175e-6; P0 = 0.21;
F0 = 0.99; Fphoton = 0.99; V = 2*Fphoton-1; F0 = 1/2*(1+V*(1-2*F0)^2);

if length(path)==1      % when there are no repeaters at all
    l = path(1); eta_t = 10^(-gamma*l); effective_t = (2*l/c+tau)/(P0*eta_t)/10; 
    fidelity_dephasing = purification_dephasing(0.99,effective_t,T,tau_de);

elseif length(path)==2      % when there is one photon repeater
    l = max(path(1),path(2)); eta_t = 10^(-gamma*l); effective_t = (2*l/c+tau)/(P0^2*eta_t^2/2)/10; 
    fidelity_dephasing = purification_dephasing(F0,effective_t,T,tau_de);

else      % when there are both photon and trapped ion repeaters
    nu = log2(length(path)/2);     % nesting level
    path_fidelity = []; % Tj_list = [];
    for i=1:length(path)/2
        lj = max(path(2*i-1),path(2*i)); 
        eta_t = 10^(-gamma*lj);
        effective_t = (2*lj/c+tau)/(P0^2*eta_t^2)/10 * 3^nu/2^(nu-1); 
        path_fidelity(end+1) = purification_dephasing(F0,effective_t,T,tau_de);
    end
    
    fidelity_dephasing = swapping_path(path_fidelity, Fswap);

end


