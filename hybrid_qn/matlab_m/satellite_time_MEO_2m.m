% Alice_bob_path = readmatrix('./satellite_fiber_GEO/alice_bob_path.csv');
Alice_station_path = readmatrix('./satellite_fiber_MEO_aR/alice_station_path_240.csv');
Bob_station_path = readmatrix('./satellite_fiber_MEO_aR/bob_station_path_240.csv');
Station_t = 1./readmatrix('./satellite_fiber_MEO_aR/sat_rate_2m.csv');

purified_F_fiber = readmatrix('./purified_F_final.csv');
purified_F_satellite = readmatrix('./purified_F_final_087.csv');
purified_F_099 = readmatrix('./purified_F_final_099.csv');
F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;

satellite_time = []; satellite_fidelity = []; 

for i = 1:1000
    T = 1; 
    alice_station_path = Alice_station_path(i,:);
    alice_station_path = alice_station_path(~isnan(alice_station_path));
    bob_station_path = Bob_station_path(i,:);
    bob_station_path = bob_station_path(~isnan(bob_station_path));
    station_t = Station_t(i);
    if isempty(alice_station_path) == 1
        alice_fidelity = 1;
    else
        alice_fidelity = fiber_fidelity(alice_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099); 
    end
    if isempty(bob_station_path) == 1
        bob_fidelity = 1;
    else
        bob_fidelity = fiber_fidelity(bob_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099);
    end
    disp([alice_fidelity,bob_fidelity])

    if alice_fidelity>0 && bob_fidelity>0 && T<2001
        fidelity =  swapping_path([alice_fidelity, purified_F_satellite(T), bob_fidelity], Fswap);
    else
        fidelity = 0;
    end
    disp(fidelity);

    while fidelity<0.83
        T = T*2; 
        if isempty(alice_station_path) == 1
            alice_fidelity = 1;
        else
            alice_fidelity = fiber_fidelity(alice_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099); 
        end
        if isempty(bob_station_path) == 1
            bob_fidelity = 1;
        else
            bob_fidelity = fiber_fidelity(bob_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099);
        end
        if alice_fidelity>0 && bob_fidelity>0 && T<2001
            fidelity =  swapping_path([alice_fidelity, purified_F_satellite(floor(T)), bob_fidelity], Fswap);
        else
            fidelity = 0;
        end
        disp([T,fidelity]);
        if T>1000 && fidelity==0
            break
        end
        if fidelity>0.875
            T = T/2;
            break
        end
    end
    T1 = T;
    while fidelity<0.86 
        T = T+T1/10;
        if isempty(alice_station_path) == 1
            alice_fidelity = 1;
        else
            alice_fidelity = fiber_fidelity(alice_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099); 
        end
        if isempty(bob_station_path) == 1
            bob_fidelity = 1;
        else
            bob_fidelity = fiber_fidelity(bob_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099);
        end

        if alice_fidelity>0 && bob_fidelity>0 && T<2001
            fidelity =  swapping_path([alice_fidelity, purified_F_satellite(floor(T)), bob_fidelity], Fswap);
        else
            fidelity = 0;
        end
        disp([T,fidelity]);
        if T>1000 && fidelity==0
            break
        end
    end
    T1=T;
    while fidelity<0.865 
        T = T+T1/30;
        if isempty(alice_station_path) == 1
            alice_fidelity = 1;
        else
            alice_fidelity = fiber_fidelity(alice_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099); 
        end
        if isempty(bob_station_path) == 1
            bob_fidelity = 1;
        else
            bob_fidelity = fiber_fidelity(bob_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099);
        end

        if alice_fidelity>0 && bob_fidelity>0 && T<2001
            fidelity =  swapping_path([alice_fidelity, purified_F_satellite(floor(T)), bob_fidelity], Fswap);
        else
            fidelity = 0;
        end
        disp([T,fidelity]);
        if T>1000 && fidelity==0
            break
        end
    end
    T1 = T;
    while fidelity<0.87 
        T = T+T1/100;
        if isempty(alice_station_path) == 1
            alice_fidelity = 1;
        else
            alice_fidelity = fiber_fidelity(alice_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099); 
        end
        if isempty(bob_station_path) == 1
            bob_fidelity = 1;
        else
            bob_fidelity = fiber_fidelity(bob_station_path, station_t*T, Fswap, purified_F_fiber, purified_F_099);
        end
        
        if alice_fidelity>0 && bob_fidelity>0 && T<2001
            fidelity =  swapping_path([alice_fidelity, purified_F_satellite(floor(T)), bob_fidelity], Fswap);
        else
            fidelity = 0;
        end
        disp([T,fidelity]);
        if T>1000 && fidelity==0
            break
        end
    end
    if fidelity == 0
        satellite_time(end+1) = 0; satellite_fidelity(end+1)=0;
    else
        satellite_time(end+1) = station_t*T; satellite_fidelity(end+1)=fidelity; 
    end

end

writematrix(satellite_time, './satellite_fiber_MEO_aR/satellite_time_2m_1.csv');
writematrix(satellite_fidelity, './satellite_fiber_MEO_aR/satellite_fidelity_2m_1.csv');

% writematrix(fiber_time, './satellite_fiber_GEO_aR/fiber_time3.csv');

% writematrix(fiber_satellite_fidelity, './station_fiber/alice_bob_satellite_fidelity_700.csv')
% writematrix(fiber_satellite_fidelity, './satellite_fiber_MEO/alice_bob_satellite_fidelity_700.csv')