% Alice_station_path = readmatrix('./satellite_fiber_MEO/alice_station_fiber_700.csv');
% Bob_station_path = readmatrix('./satellite_fiber_MEO/bob_station_fiber_700.csv');
% Station_t = 1./readmatrix('./satellite_fiber_MEO/alice_bob_satellite_time_700.csv');

% Alice_station_path = readmatrix('./satellite_fiber_MEO/450/alice_station_fiber_450.csv');
% Bob_station_path = readmatrix('./satellite_fiber_MEO/450/bob_station_fiber_450.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/450/alice_bob_satellite_time_450.csv');

% Alice_station_path = readmatrix('./satellite_fiber_MEO/240/alice_station_fiber_240.csv');
% Bob_station_path = readmatrix('./satellite_fiber_MEO/240/bob_station_fiber_240.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/240/alice_bob_satellite_time_240.csv');

Alice_station_path = readmatrix('./satellite_fiber_GEO/alice_station_path.csv');
Bob_station_path = readmatrix('./satellite_fiber_GEO/bob_station_path.csv');
Station_t = 1./readmatrix('./satellite_fiber_GEO/hybrid_sat_rate.csv');

purified_F_final = readmatrix('./purified_F_final.csv');
F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;

% fiber_satellite_fidelity_700_09 = [];
% fiber_satellite_fidelity_450_09 = [];
% fiber_satellite_fidelity_240_09 = []; 

hybrid_satellite_fidelity = []; 

% for i=length(fiber_satellite_fidelity_700)+1:size(Alice_station_path,1)
for i=1:size(Alice_station_path,1)
% for i=1:100
    disp(i);
    alice_station_path = Alice_station_path(i,:);
    alice_station_path = alice_station_path(~isnan(alice_station_path));
    bob_station_path = Bob_station_path(i,:);
    bob_station_path = bob_station_path(~isnan(bob_station_path));
    station_t = Station_t(i);

    alice_fidelity = fiber_fidelity(alice_station_path, station_t, Fswap, purified_F_final); 
    bob_fidelity = fiber_fidelity(bob_station_path, station_t, Fswap, purified_F_final); 
    disp([alice_fidelity, bob_fidelity]);
    if alice_fidelity>0 && bob_fidelity>0
        fidelity =  swapping_path([alice_fidelity, 0.869, bob_fidelity], Fswap);
        hybrid_satellite_fidelity(end+1) = fidelity; 
    else
        hybrid_satellite_fidelity(end+1) = 0;
    end
    disp(fidelity);
end

% writematrix(hybrid_satellite_fidelity, './satellite_fiber_GEO/satellite_fidelity_700.csv')

% writematrix(fiber_satellite_fidelity, './station_fiber/alice_bob_satellite_fidelity_700.csv')
% writematrix(fiber_satellite_fidelity, './satellite_fiber_MEO/alice_bob_satellite_fidelity_700.csv')