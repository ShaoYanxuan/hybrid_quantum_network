% Alice_bob_path = readmatrix('./direct_fibers/alice_bob_path.csv');
% Station_t = 1./readmatrix('./direct_fibers/alice_bob_satellite_rate.csv');

% Alice_bob_path = readmatrix('./satellite_fiber_MEO/alice_bob_fiber_path_700.csv');
% Station_t = 1./readmatrix('./satellite_fiber_MEO/alice_bob_satellite_time_700.csv');

% Alice_bob_path = readmatrix('satellite_fiber_MEO/450/alice_bob_fiber_path_450.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/450/alice_bob_satellite_time_450.csv');

Alice_bob_path = readmatrix('/alice_bob_path.csv');
Station_t = readmatrix('./satellite_fiber_MEO/240/alice_bob_satellite_time_240.csv');

purified_F_final = readmatrix('./purified_F_final_09.csv');

F0 = 0.99; Fphoton = 0.9; Fswap = 0.99;

% fiber_length_700 = []; fiber_only_fidelity_700_09 = [];

% fiber_length_450 = []; fiber_only_fidelity_450_09 = []; 

% fiber_length_240 = []; fiber_only_fidelity_240_09 = []; 

for i=101:size(Alice_bob_path,1)
% for i=1:100
    path = Alice_bob_path(i,:);
    path = path(~isnan(path));
    fidelity = fiber_fidelity(path, Station_t(i), Fswap, purified_F_final); 
    fiber_only_fidelity_240_09(end+1) = fidelity; 
    fiber_length_240(end+1) = sum(path);
    disp(fidelity); 
end

% writematrix(fiber_only_fidelity, './station_fiber/alice_bob_fiber_fidelity_700.csv')

