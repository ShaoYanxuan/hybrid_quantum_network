% clear all
% F0 = 0.962; Fphoton = 0.692; Fswap = 0.952;
% OUTC = 1;

F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;
V = 2*Fphoton-1;
F0 = 1/2*(1+V*(1-2*F0)^2); % == (F0^2+(1-F0)^2)*(1+V)/2+2*F0*(1-F0)*(1-V)/2

% purified_F_final = readmatrix('./purified_F_final.csv');

% purify_swap = zeros(20,20); 
% swap_purify = zeros(20,20); 
% for purify_n=21:40
%     for swap_n=1:40
%         F_purify = purification_average(F0,purify_n);
%         purify_swap_40(purify_n, swap_n) = swapping_path(ones(1,swap_n)*F_purify, Fswap);
%         F_swap = swapping_path(ones(1,swap_n)*F0, Fswap);
%         swap_purify_40(purify_n, swap_n) = purification_average(F_swap,purify_n);
%     end
% end


%% purify initial ion-ion entanglement, find the average final entanglement fidelity
% with 1-100 ion-ion entanglement
% purified_F_final = [F0];
for n=901:1000
    purified_F_final(end+1) = purification_average(F0,n); 
end


%% For one pair of Alice and Bob, find the distance between neighboring ion repeaters and the entanglement fidelity after purification given time T, and the fidelity after swapping
% Tj_list = [];
% for i=1:length(path_length)/2
%     lj = max(path_length(2*i-1),path_length(2*i)); 
%     eta_t = 10^(-gamma*lj);
%     Tj_list(end+1) = (lj/c+T0)/(P0^2*eta_t^2)*3/2;
% end

% totalT = []; 
% for T=1:20
%     path_fidelity = []; 
%     for i=1:length(Tj_list)
%         path_fidelity(end+1) = purified_F_final(floor(T/Tj_list(i))); 
%     end
% 
%     rho_ii = path_fidelity(1)*phipm+(1-path_fidelity(1))*phimm;
%     for i=2:length(path_fidelity)
%         F = path_fidelity(i);
%         rho_ii1 = F*phipm+(1-F)*phimm;
%         rho_ii = estimate_swapped_fidelity(rho_ii,rho_ii1,Fswap, 'depolarize');
%     end
%     U = find_opt_U(rho_ii, phipm);
%     Fidelity = mixedfid(U*rho_ii*U', phipm);
%     final_Fidelity = Fidelity; i=1; 
%     while final_Fidelity<0.86
%         i = i+1;
%         purified_Fidelity = [];
%         for iter=1:1000
%             purified_Fidelity(end+1)=purification(Fidelity,i);
%         end
%         final_Fidelity = mean(purified_Fidelity);
%     end
%     totalT(end+1) = T*(i+1);
% end
% disp(totalT)



%% purify first, then swap 
% purify_swap_num = [1];
% for repeater_num=2:20
%     for i=purify_swap_num(end):length(purified_F_final)
%         F0 = purified_F_final(i);
%         rho_ii0 = F0*phipm+(1-F0)*phimm; rho_ii = F0*phipm+(1-F0)*phimm;
%         for j=1:repeater_num
%             rho_ii = estimate_swapped_fidelity(rho_ii,rho_ii0, Fswap,'depolarize');
%             U = find_opt_U(rho_ii, phipm);
%         end
%         Fidelity = mixedfid(U*rho_ii*U', phipm);
%         if Fidelity>=0.86
%             purify_swap_num(end+1)=i;
%             break
%         end
%     end
% end


%% swap the initial ion-ion entanglements chain and then purify
% swap_purify_num = [1];
% for repeater_num=2:13
%     for n=swap_purify_num(end):200
%     % n = ent_num_needed(repeater_num);
%         F0 = 1/2*(1+V*(1-2*0.99)^2);
%         rho_ii0 = F0*phipm+(1-F0)*phimm; rho_ii=F0*phipm+(1-F0)*phimm;
%         for j=1:repeater_num
%             % t = estimate_swapped_fidelity(rho_ii,rho_ii0, Fswap,'depolarize');
%             % rho_ii = t{OUTC};  %1 swap 2 segments
%             rho_ii = estimate_swapped_fidelity(rho_ii,rho_ii0, Fswap,'depolarize');
%             U = find_opt_U(rho_ii, phipm);
%         end
%         Fidelity = mixedfid(U*rho_ii*U', phipm);
%         purified_F_list = [];
%         for j=1:10000
%             purified_F_list(end+1)=purification(Fidelity,n-1);
%         end
%         if mean(purified_F_list)>0.86
%             swap_purify_num(end+1)=n;
%             break
%         end
%     end
% end

%% purify, swap, then purify again
% purify_swap_purify_num = [4];
% for repeater_num=2:20
%     F0 = purified_F_final(4);
%     rho_ii0 = F0*phipm+(1-F0)*phimm; rho_ii = F0*phipm+(1-F0)*phimm;
%     for j=1:repeater_num
%         rho_ii = estimate_swapped_fidelity(rho_ii,rho_ii0, Fswap,'depolarize');
%     end
%     U = find_opt_U(rho_ii, phipm);
%     Fidelity = mixedfid(U*rho_ii*U', phipm);
%     for n=purify_swap_purify_num(end)/4:100
%         purified_F_list = [];
%         for j=1:10000
%             purified_F_list(end+1)=purification(Fidelity,n);
%         end
%         if mean(purified_F_list)>0.86
%             purify_swap_purify_num(end+1)=4*n;
%             break
%         end
%     end
% end



%% entanglement swapping of a chain of entanglements of different fidelity

% entanglement_chain = {rho_ii3,rho_ii3,rho_ii3,rho_ii3,rho_ii3,rho_ii3,rho_ii3};
% for i=1:6
%     t = estimate_swapped_fidelity(entanglement_chain{1}, entanglement_chain{2}, Fswap,'depolarize');
%     rho_ii = t{OUTC};  %1 swap 2 segments
%     U = find_opt_U(rho_ii, phipm);
%     entanglement_chain = entanglement_chain(3:end);
%     entanglement_chain{end+1}=rho_ii;
% end
% Fidelity = mixedfid(U*rho_ii*U', phipm)


% 
% t = estimate_swapped_fidelity(rho_ii, rho_ii, Fswap,'depolarize');
% rho_ii = t{OUTC};  %1 swap 2 segments
% disp(rho_ii)
% U = find_opt_U(rho_ii, phipm);
% Fidelity = mixedfid(U*rho_ii*U', phipm)

% % do entanglement swapping as nesting levels
% % fidelity_list = [];
% % for A=0.5:0.01:1
% rho_ii = A*phipm+(1-A)*(phimm);
% U = find_opt_U(rho_ii, phipm);
% Fidelity = mixedfid(U*rho_ii*U', phipm)
% 
% for i=1:3
% t = estimate_swapped_fidelity(rho_ii, rho_ii, Fswap,'depolarize');
% rho_ii = t{OUTC};  %1 swap 2 segments
% U = find_opt_U(rho_ii, phipm);
% Fidelity = mixedfid(U*rho_ii*U', phipm)
% % fidelity_list(end+1) = mixedfid(U*rho_ii1*U', phipm)
% end

% % do entanglement swapping for cases with 1-25 repeaters without purification
% fidelity_list = []; 
% for n=1:25
% rho_ii0 = F0*phipm+(1-F0)*(phimm);
% rho_ii = F0*phipm+(1-F0)*(phimm);
% for i=1:n
% t = estimate_swapped_fidelity(rho_ii0, rho_ii, Fswap,'depolarize');
% rho_ii = t{OUTC};  %1 swap 2 segments
% U = find_opt_U(rho_ii, phipm);
% % fidelity_list(end+1) = mixedfid(U*rho_ii1*U', phipm)
% end
% Fidelity = mixedfid(U*rho_ii*U', phipm);
% fidelity_list(end+1) = Fidelity;
% end




