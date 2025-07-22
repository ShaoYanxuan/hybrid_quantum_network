% clear all

Alice_station_path_240 = readmatrix('../MEO/alice_station_path_240.csv');
Bob_station_path_240 = readmatrix('../MEO/bob_station_path_240.csv');

purified_F_099 = readmatrix('../purified_F_final_099.csv');
purified_F_fiber = readmatrix('../purified_F_final.csv');
purified_F_satellite = readmatrix('../purified_F_final_087.csv');

% satellite_time = 1./readmatrix('../MEO/sat_rate_240.csv');
satellite_time = 1./readmatrix('../aR/aR_1_rate_240.csv'); aR = 1; 

F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;
% hybrid_240_time = []; hybrid_240_final_fidelity = [];
aR_1_hybrid_time = []; aR_1_hybrid_final_fidelity = []; 

for i = 1:100
    T0 = satellite_time(i); T = satellite_time(i);
    alice_station_path = Alice_station_path_240(i,:);
    alice_station_path = alice_station_path(~isnan(alice_station_path));
    bob_station_path = Bob_station_path_240(i,:);
    bob_station_path = bob_station_path(~isnan(bob_station_path));

    alice_station_fidelity = fiber_fidelity(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099);
    bob_station_fidelity = fiber_fidelity(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099);
    if alice_station_fidelity>0 && bob_station_fidelity>0
        fidelity = swapping_path([alice_station_fidelity, purified_F_satellite(floor(T/T0))], Fswap);
    else
        fidelity = 0;
    end

    while fidelity<0.84
        T = T*2; 
        alice_station_fidelity = fiber_fidelity(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099);
        bob_station_fidelity = fiber_fidelity(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099);
        if alice_station_fidelity>0 && bob_station_fidelity>0
            fidelity = swapping_path([alice_station_fidelity, purified_F_satellite(floor(T/T0))], Fswap);
        else
            fidelity = 0;
        end
        if T > 1e10
            break
        end
    end

    T1 = T;
    while fidelity<0.865
        T = T+T1/10;
        alice_station_fidelity = fiber_fidelity(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099);
        bob_station_fidelity = fiber_fidelity(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099);
        if alice_station_fidelity>0 && bob_station_fidelity>0
            fidelity = swapping_path([alice_station_fidelity, purified_F_satellite(floor(T/T0))], Fswap);
        else
            fidelity = 0;
        end
        if T > 1e10
            break
        end
    end

    T1 = T;
    while fidelity<0.87
        T = T+T1/50;
        alice_station_fidelity = fiber_fidelity(alice_station_path, T, Fswap, purified_F_fiber, purified_F_099);
        bob_station_fidelity = fiber_fidelity(bob_station_path, T, Fswap, purified_F_fiber, purified_F_099);
        if alice_station_fidelity>0 && bob_station_fidelity>0
            fidelity = swapping_path([alice_station_fidelity, purified_F_satellite(floor(T/T0))], Fswap);
        else
            fidelity = 0;
        end
        if T > 1e10
            break
        end
    end
    disp([i, fidelity]);
    % hybrid_240_time(end+1) = T; hybrid_240_final_fidelity(end+1) = fidelity;
    aR_1_hybrid_time(end+1) = T; aR_1_hybrid_final_fidelity(end+1) = fidelity; 

end

% writematrix(hybrid_240_time, '../MEO/hybrid_240_time.csv');
% writematrix(hybrid_240_final_fidelity, '../MEO/hybrid_240_final_fidelity.csv');





