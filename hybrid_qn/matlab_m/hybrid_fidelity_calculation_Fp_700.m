% clear all
% 
% % Alice_bob_path = readmatrix('alice_bob_path.csv');
Alice_station_path_450 = readmatrix('../MEO/alice_station_path_700.csv');
Bob_station_path_450 = readmatrix('../MEO/bob_station_path_450.csv');

purified_F_099 = readmatrix('../purified_F_final_099.csv');
purified_F_fiber = readmatrix('../purified_F_final_Fp_0.9.csv');
% purified_F_fiber = readmatrix('../purified_F_final.csv');
purified_F_satellite = readmatrix('../purified_F_final_087.csv');

satellite_time = 1./readmatrix('../MEO/sat_rate_450.csv'); 
% satellite_time = 1./readmatrix('../GEO/sat_rate_240.csv');

F0 = 0.99; Fswap = 0.99; %Fphoton = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;
hybrid_450_fidelity = [];


for i = 101:2000
    T = satellite_time(i);
    alice_station_path = Alice_station_path_450(i,:);
    alice_station_path = alice_station_path(~isnan(alice_station_path));
    bob_station_path = Bob_station_path_450(i,:);
    bob_station_path = bob_station_path(~isnan(bob_station_path));

    alice_station_fidelity = fiber_fidelity(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099);
    bob_station_fidelity = fiber_fidelity(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099);
    if alice_station_fidelity>0 && bob_station_fidelity>0
        fidelity = swapping_path([alice_station_fidelity, 0.87, bob_station_fidelity], Fswap);
    else
        fidelity = 0;
    end
    hybrid_450_fidelity(end+1) = fidelity;
    disp([i,fidelity, alice_station_fidelity, bob_station_fidelity])

end

writematrix(hybrid_450_fidelity, '../Fp_0.9/hybrid_fidelity_450.csv')





