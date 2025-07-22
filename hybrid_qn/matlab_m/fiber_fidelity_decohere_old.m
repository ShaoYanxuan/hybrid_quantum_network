standardbell;standardpolns;

% parameters used
gamma = 0.0173; c = 2e5; T0 = 175e-6; P0 = 0.21; tau = 10;

% add possible intermediate repeaters to long edges
% while max(path)>61.7
%     [a,b] = max(path);
%     path = [path(1:b-1),a/8,a/8,a/8,a/8,a/8,a/8,a/8,a/8,path(b+1:end)];
% end


%----------------------------------------------------------------------

% % decoherence from waiting
F0 = 0.99; Fswap = 0.99;
rho_ii0 = F0*phipm+(1-F0)*phimm;
rho_ii0 = estimate_swapped_fidelity(rho_ii0,rho_ii0,Fswap, 'depolarize');
U = find_opt_U(rho_ii0,phipm);
F0 = mixedfid(U*rho_ii0*U', phipm);
% decohere_fidelity = []; 
% for t=0.01:0.01:10
%     p = (1-exp(-t^2/tau^2))/2; 
%     rho_ii = p*rho_ii0+(1-p)*UZ*rho_ii0*UZ';
%     U = find_opt_U(rho_ii, phipm);
%     swapped_F = mixedfid(U*rho_ii*U', phipm);
%     decohere_fidelity(end+1) = swapped_F;
% end

%----------------------------------------------------------------------

D = 100;
% no repeaters
finalF = F0;
eta_t = 10^(-gamma*D);
Tj = (2*D/c+T0)/(P0*eta_t)/10;
F_list = []; 
for iter=1:100
    for j=1:100
        if finalF>0
            finalF = decohere(finalF, Tj, tau);
            purify = purification_2_1(finalF,F0);
            if rand<purify(2)
                finalF = purify(1);
            else
                finalF = 0;
            end
        else
            finalF = F0;
        end
    end
    if finalF==0
        finalF = F0;
    end
    F_list(end+1) = finalF;
end



% % the case when no repeaters are in between
% if length(path)==1
%     eta_t = 10^(-gamma*path(1));
%     Tj = (2*path(1)/c+T0)/(P0*eta_t)/10;
%     if 1<floor(T/Tj)
%         if floor(T/Tj)<2001
%             optimal_fidelity = purified_F_final_099(floor(T/Tj));
%         else
%             optimal_fidelity = purified_F_final_099(end);
%         end
%     else
%         optimal_fidelity = 0;
%     end
% end
% 
% 
% if length(path)>1 
%     % length of path needs to be an even number
%     if  mod(length(path),2)==1
%         neighbor_length = path(1:end-1)+path(2:end);
%         [x,i]=min(neighbor_length);
%         path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
%     end
% 
%     % if path length too large, combine short edges (and remain the length an even number)
%     while length(path)>52
%         for j=1:2
%             neighbor_length = path(1:end-1)+path(2:end);
%             [x,i]=min(neighbor_length);
%             path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
%         end
%     end
% 
%     % calculate the end-to-end fidelity while reducing the number of repeaters
%     fidelity_list = []; path_length = [];
% 
%     % reduce the number of repeaters until path length is 2
%     for iter=1:length(path)/2-1
%         % remove one photon repeater and one ion repeater
%         for j=1:2
%             neighbor_length = path(1:end-1)+path(2:end);
%             [x,i]=min(neighbor_length);
%             path = [path(1:i-1),path(i)+path(i+1),path(i+2:end)];
%         end
%         % calculate the entanglement distribution time for neighboring ion repeaters
%         Tj_list = [];
%         for i=1:length(path)/2
%             lj = max(path(2*i-1),path(2*i)); 
%             eta_t = 10^(-gamma*lj);
%             Tj_list(end+1) = (lj/c+T0)/(P0^2*eta_t^2)/10;  % 10 ion repeaters each way
%         end
%         nu = log2(length(path)/2);
%         purify_t = T/3^nu*2^(nu-1);
% 
%         % calculate the end-to-end fidelity
%         if purify_t>max(Tj_list) && floor(purify_t/min(Tj_list))<=1300
%             path_fidelity = [];
%             for i=1:length(Tj_list)
%                 path_fidelity(end+1) = purified_F_final(floor(purify_t/Tj_list(i)));
%             end
%             final_fidelity = swapping_path(path_fidelity, Fswap); 
%             fidelity_list(end+1) = final_fidelity; path_length(end+1)=length(path);
%         end
%     end
% 
%     % calculate the end-to-end fidelity with no repeaters
%     eta_t = 10^(-gamma*sum(path));
%     Tj = (2*sum(path)/c+T0)/(P0*eta_t)/10;
%     if 1<floor(T/Tj)
%         if floor(T/Tj)<2001
%             optimal_fidelity = purified_F_final_099(floor(T/Tj));
%         else
%             optimal_fidelity = purified_F_final_099(end);
%         end
%     else
%         optimal_fidelity = 0;
%     end
% 
%     if isempty(fidelity_list)
%         optimal_fidelity = 0;
%     else
%         optimal_fidelity = max(fidelity_list);
%     end
% 
% end
