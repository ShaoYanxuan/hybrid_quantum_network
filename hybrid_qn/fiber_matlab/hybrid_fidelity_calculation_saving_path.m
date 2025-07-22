% clear all
% 
% % Alice_bob_path = readmatrix('alice_bob_path.csv');
Alice_station_path = readmatrix('../MEO/alice_station_path_240.csv');
Bob_station_path = readmatrix('../MEO/bob_station_path_240.csv');

purified_F_099 = readmatrix('../purified_F_final_099.csv');
purified_F_fiber = readmatrix('../purified_F_final.csv');
% purified_F_fiber = readmatrix('../purified_F_final_Fp_0.9.csv');
purified_F_satellite = readmatrix('../purified_F_final_087.csv');

satellite_time = 1./readmatrix('../MEO/sat_rate_240.csv'); 
% satellite_time = 1./readmatrix('../GEO/sat_rate_240.csv');

F0 = 0.99; Fswap = 0.99; %Fphoton = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;
% hybrid_fidelity = []; Alice_path = zeros(2000,60); Bob_path = zeros(2000,60); 

for i = 215:1000
    T = satellite_time(i);
    alice_station_path = Alice_station_path(i,:);
    alice_station_path = alice_station_path(~isnan(alice_station_path));
    bob_station_path = Bob_station_path(i,:);
    bob_station_path = bob_station_path(~isnan(bob_station_path));

    [alice_fidelity, alice_path] = fiber_fidelity_saving_path(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099);
    [bob_fidelity, bob_path] = fiber_fidelity_saving_path(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099);
    
    if alice_station_fidelity>0 && bob_station_fidelity>0
        fidelity = swapping_path([alice_fidelity, 0.87, bob_fidelity], Fswap);
        Alice_path(i,:) = [alice_path, zeros(1,60-length(alice_path))];
        Bob_path(i,:) = [bob_path, zeros(1,60-length(bob_path))];
    else
        fidelity = 0;
    end
    hybrid_fidelity(end+1) = fidelity;
    disp([i,fidelity, alice_fidelity, bob_fidelity])

end

% writematrix(Alice_path, '../dephasing/Alice_station_final_path_240.csv');
% writematrix(Bob_path, '../dephasing/Bob_station_final_path_240.csv')


