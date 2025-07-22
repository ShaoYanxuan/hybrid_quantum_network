clear all
% 
% % Alice_bob_path = readmatrix('alice_bob_path.csv');
% Alice_station_path = readmatrix('../MEO/alice_station_path_240.csv');
% Bob_station_path = readmatrix('../MEO/bob_station_path_240.csv');
Alice_station_path = readmatrix('../dephasing/Alice_station_final_path_240.csv'); 
Bob_station_path = readmatrix('../dephasing/Bob_station_final_path_240.csv'); 

purified_F_099 = readmatrix('../purified_F_final_099.csv');
purified_F_fiber = readmatrix('../purified_F_final.csv');
purified_F_satellite = readmatrix('../purified_F_final_087.csv');

satellite_time = 1./readmatrix('../MEO/sat_rate_240.csv'); 

F0 = 0.99; Fswap = 0.99; %Fphoton = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5; tau_de = 1; 

standardbell;standardpolns;
hybrid_fidelity = [];


for i = 1:1000
    T = satellite_time(i);
    alice_station_path = Alice_station_path(i,:);
    if all(alice_station_path==0)
        alice_fidelity = 0; 
    else
        alice_station_path = alice_station_path(1:find(alice_station_path, 1, 'last'));
        alice_fidelity = fiber_fidelity_dephasing_given_final_path(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099,tau_de);
    end

    bob_station_path = Bob_station_path(i,:);
    if all(bob_station_path==0)
        bob_fidelity = 0; 
    else
        bob_station_path = bob_station_path(1:find(bob_station_path, 1, 'last'));
        bob_fidelity = fiber_fidelity_dephasing_given_final_path(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099,tau_de);
    end

    if alice_fidelity>0 && bob_fidelity>0
        fidelity = swapping_path([alice_fidelity, 0.87, bob_fidelity], Fswap);
    else
        fidelity = 0;
    end
    hybrid_fidelity(end+1) = fidelity;
    disp([i,fidelity, alice_fidelity, bob_fidelity])

end

% writematrix(hybrid_fidelity,    % '../Fp_0.9/hybrid_fidelity_700.csv')





