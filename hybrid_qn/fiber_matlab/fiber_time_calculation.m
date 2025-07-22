clear all
OUTC = 1;

Alice_bob_path = readmatrix('../alice_bob_path.csv');
purified_F_099 = readmatrix('./purified_F_final_099.csv');
purified_F_fiber = readmatrix('./purified_F_final.csv');
% 
% F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
% T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;
% 
% standardbell;standardpolns;
% V = 2*Fphoton-1;
% F0 = 1/2*(1+V*(1-2*F0)^2); % == (F0^2+(1-F0)^2)*(1+V)/2+2*F0*(1-F0)*(1-V)/2

fiber_time = []; fiber_final_fidelity = []; path_total_length = [];

for i = 1:1000
    disp(i)
    T = 1e-3; 
    alice_bob_path = Alice_bob_path(i,:);
    alice_bob_path = alice_bob_path(~isnan(alice_bob_path));
    path_total_length(end+1) = sum(alice_bob_path);
    fidelity = fiber_fidelity(alice_bob_path, T, Fswap, purified_F_fiber, purified_F_099); 

    while fidelity<0.84
        T = T*2; 
        fidelity = fiber_fidelity(alice_bob_path, T, Fswap, purified_F_fiber, purified_F_099); 
        if T > 1e6
            break
        end
    end

    T1 = T;
    while fidelity<0.865
        T = T+T1/10;
        fidelity = fiber_fidelity(alice_bob_path, T, Fswap, purified_F_fiber, purified_F_099); 
        if T > 1e6
            break
        end
    end
    
    T1 = T;
    while fidelity<0.87
        T = T+T1/50;
        fidelity = fiber_fidelity(alice_bob_path, T, Fswap, purified_F_fiber, purified_F_099); 
        if T > 1e6
            break
        end
    end
    disp(T);
    fiber_time(end+1) = T; fiber_final_fidelity(end+1) = fidelity; 

end

% writematrix(1./fiber_time, '../alice_bob_fiber_rate.csv')