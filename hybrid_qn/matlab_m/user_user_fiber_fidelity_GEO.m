Alice_bob_path = readmatrix('./satellite_fiber_GEO/alice_bob_path.csv'); 
Station_t = 1./readmatrix('./satellite_fiber_GEO/sat_rate.csv');


% Alice_bob_path = readmatrix('./satellite_fiber_MEO/alice_bob_fiber_path_700.csv');
% Station_t = 1./readmatrix('./satellite_fiber_MEO/alice_bob_satellite_time_700.csv');

% Alice_bob_path = readmatrix('satellite_fiber_MEO/450/alice_bob_fiber_path_450.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/450/alice_bob_satellite_time_450.csv');

% Alice_bob_path = readmatrix('satellite_fiber_MEO/240/alice_bob_fiber_path_240.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/240/alice_bob_satellite_time_240.csv');

purified_F_final = readmatrix('./purified_F_final.csv');

F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
% fiber_length = []; fiber_only_fidelity = []; 
geo_distance = readmatrix('./satellite_fiber_GEO/geo_distance.csv');
fiber_only_fidelity1 = readmatrix('./satellite_fiber_GEO/fiber_fidelity.csv');
fiber_only_fidelity = []; 

for i=1:size(Alice_bob_path,1)
% for i=1:100
    if geo_distance(i)<300 && fiber_only_fidelity1(i)==0
        path = Alice_bob_path(i,:);
        path = path(~isnan(path));
        fidelity = fiber_fidelity(path, Station_t(i), Fswap, purified_F_final); 
        fiber_only_fidelity(end+1) = fidelity; 
        % fiber_length(end+1) = sum(path);
        disp(fidelity); 
    else
        fiber_only_fidelity(end+1) = fiber_only_fidelity1(i);
    end
end

% writematrix(fiber_only_fidelity, './station_fiber/alice_bob_fiber_fidelity_700.csv')

