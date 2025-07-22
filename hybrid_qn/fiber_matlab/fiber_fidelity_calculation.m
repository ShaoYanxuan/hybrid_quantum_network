% clear all

Alice_bob_path = readmatrix('../alice_bob_path.csv');
purified_F_099 = readmatrix('../purified_F_final_099.csv');
purified_F_fiber = readmatrix('../purified_F_final.csv');
% purified_F_fiber = readmatrix('../purified_F_final_Fp_0.9.csv');


F0 = 0.99; Fswap = 0.99; % Fphoton=0.9
% V = 2*Fphoton-1;
% F0 = 1/2*(1+V*(1-2*F0)^2);
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;

% Alice_bob_sat_time = 1./readmatrix('../alice_bob_sat_rate.csv');
Alice_bob_sat_time = 1./readmatrix('../sat_rate_upper.csv');
% Alice_bob_sat_time = 1./readmatrix('../GEO/sat_rate.csv');

fiber_fidelity = []; % fiber_path = zeros(10000,60); 
% fiber_fidelity_GEO = [];

for i=1:10000
    alice_bob_path = Alice_bob_path(i,:);
    alice_bob_path = alice_bob_path(~isnan(alice_bob_path));
    % AB_fiber_fidelity(end+1) = fiber_fidelity(alice_bob_path, Alice_bob_sat_time(i), Fswap, purified_F_fiber, purified_F_099);
    [optimal_fidelity, optimal_path] = fiber_fidelity_saving_path(alice_bob_path, Alice_bob_sat_time(i), Fswap, purified_F_fiber, purified_F_099);
    fiber_fidelity(end+1) = optimal_fidelity; 
    disp([i,optimal_fidelity])
    % fiber_path(i,:) = [optimal_path, zeros(1,60-length(optimal_path))];
end

% writematrix(fiber_fidelity, '../Fp_0.9/fiber_fidelity.csv')