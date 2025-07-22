% Alice_station_path = readmatrix('./satellite_fiber_MEO/alice_station_fiber_700.csv');
% Bob_station_path = readmatrix('./satellite_fiber_MEO/bob_station_fiber_700.csv');
% Station_t = 1./readmatrix('./satellite_fiber_MEO/alice_bob_satellite_time_700.csv');

% Alice_station_path = readmatrix('./satellite_fiber_MEO/450/alice_station_fiber_450.csv');
% Bob_station_path = readmatrix('./satellite_fiber_MEO/450/bob_station_fiber_450.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/450/alice_bob_satellite_time_450.csv');

% Alice_station_path = readmatrix('./satellite_fiber_MEO/240/alice_station_fiber_240.csv');
% Bob_station_path = readmatrix('./satellite_fiber_MEO/240/bob_station_fiber_240.csv');
% Station_t = readmatrix('./satellite_fiber_MEO/240/alice_bob_satellite_time_240.csv');

Alice_bob_path = readmatrix('./satellite_fiber_GEO/alice_bob_path.csv'); 
Station_t = 1./readmatrix('./satellite_fiber_MEO_aR/sat_rate.csv');

purified_F_fiber = readmatrix('./purified_F_final.csv');
% purified_F_satellite = readmatrix('./purified_F_final_869.csv');
F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;

% fiber_satellite_time_700_09 = [];
fiber_time = [];
% fiber_time = readmatrix('./satellite_fiber_GEO/fiber_time1.csv');

% for i=length(fiber_satellite_fidelity_700)+1:size(Alice_station_path,1)
% for i = 178:200
% for i = 748:size(Alice_bob_path,1)
    % disp(i);
    % alice_station_path = Alice_station_path(i,:);
    % alice_station_path = alice_station_path(~isnan(alice_station_path));
    % bob_station_path = Bob_station_path(i,:);
    % bob_station_path = bob_station_path(~isnan(bob_station_path));
for i = 2
    % disp(i);
    path = Alice_bob_path(i,:);
    path = path(~isnan(path));
    station_t = Station_t(i);
    fidelity = fiber_fidelity(path,station_t,Fswap, purified_F_fiber);
    disp(fidelity);
    disp(sum(path));

    T = 1; 
    if fidelity>0.87
        while fidelity>0.9
            T = T/2;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp(fidelity);
        end
        T1 = T; 
        while fidelity>0.88
            T = T-T1/20;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp(fidelity);
        end
        while fidelity>0.875
            T = T-T1/50;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp(fidelity);
        end
        while fidelity>0.87
            T = T-T1/100;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp(fidelity);
        end
        T = T+T1/100;
        fiber_time(end+1) = station_t*T;
    
    else
        % fiber_time(end+1) = fiber_time1(i);
        % % alice_fidelity = fiber_fidelity(alice_station_path, station_t*T, Fswap, purified_F_fiber); 
        % % bob_fidelity = fiber_fidelity(bob_station_path, station_t*T, Fswap, purified_F_fiber);
        % % fidelity =  swapping_path([alice_fidelity, purified_F_satellite(T), bob_fidelity], Fswap);

        T = 1;
        % fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp(fidelity);
        while fidelity<0.83 && fidelity>0
            T = T*2; 
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp([T,fidelity]);
        end
        T1 = T;
        while fidelity<0.86 && fidelity>0
            T = T+T1/10;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp([T,fidelity]);
        end
        T1=T;
        while fidelity<0.865 && fidelity>0
            T = T+T1/30;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp([T,fidelity]);
        end
        T1 = T;
        while fidelity<0.87 && fidelity>0
            T = T+T1/100;
            fidelity = fiber_fidelity(path, station_t*T, Fswap, purified_F_fiber);disp([T,fidelity]);
        end

        if fidelity>0
            fiber_time(end+1) = station_t*T;
        else
            fiber_time(end+1) = 0; 
        end
    end
    % disp(station_t*T);
end

writematrix(fiber_time, './satellite_fiber_GEO/fiber_time3.csv');

% writematrix(fiber_satellite_fidelity, './station_fiber/alice_bob_satellite_fidelity_700.csv')
% writematrix(fiber_satellite_fidelity, './satellite_fiber_MEO/alice_bob_satellite_fidelity_700.csv')