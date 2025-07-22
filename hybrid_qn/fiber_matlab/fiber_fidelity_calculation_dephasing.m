% % clear all
% 
standardbell;standardpolns;

% Alice_bob_path = readmatrix('../alice_bob_path.csv');
purified_F_099 = readmatrix('./purified_F_final_099.csv');
purified_F_fiber = readmatrix('./purified_F_final.csv');
Alice_bob_path = readmatrix('../alice_bob_fiber_path_length.csv');

F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5; tau_de = 1; 

Alice_bob_sat_time = 1./readmatrix('../alice_bob_sat_rate.csv');

% AB_fiber_fidelity_dephasing_5 = []; 
for i=1:10
    % disp(i);
    alice_bob_path = Alice_bob_path(i,:);
    if all(alice_bob_path==0)
        dephasing_fidelity = 0;
    else
        alice_bob_path = alice_bob_path(1:find(alice_bob_path,1,'last'));
        T = Alice_bob_sat_time(i);
        dephasing_fidelity = fiber_fidelity_dephasing_given_final_path(alice_bob_path, T, Fswap, purified_F_fiber, purified_F_099,tau_de);
        
    % disp([i,dephasing_fidelity]); 
    end
    disp([i,dephasing_fidelity])
    % AB_fiber_fidelity_dephasing_5_test(end+1) = dephasing_fidelity; 
end
% disp(AB_fiber_fidelity_dephasing_5_test);

% writematrix(AB_fiber_fidelity_dephasing, '../alice_bob_fiber_fidelity_dephasing.csv')
% writematrix(AB_fiber_path, '../alice_bob_fiber_path_length.csv')