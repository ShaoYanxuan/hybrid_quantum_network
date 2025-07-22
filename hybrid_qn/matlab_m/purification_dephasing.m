% Given the length of optical fiber and time, with 10 memories each
% way, this function gives the fidelity after 
function purified_F = purification_dephasing(F0,efficient_t,T,tau_de)

gamma = 0.0173; c = 2e5; tau = 175e-6; P0 = 0.21;

% eta_t = 10^(-gamma*l);
% t = (2*l/c+tau)/(P0*eta_t)/10;      %10 quantum memories each direction 
% disp([t,T,floor(T/t)]);
if floor(T/efficient_t)<3
    purified_F = dephasing(F0,T,tau_de);
else
    % t: [F0];
    % 2t: [dephasing(F0,t,tau_de), F0];
    % 3t: [dephasing(F0,2*t,tau_de), dephasing(F0,t,tau_de), F0]
    %     [purification_2_1(dephasing(F0,2*t,tau_de), dephasing(F0,t,tau_de)), F0]
    % 4t: [dephasing(purification_2_1(dephasing(F0,2*t,tau_de), dephasing(F0,t,tau_de)), t,tau_de), dephasing(F0,t,tau_de),F0]

    % purified_F_list = [];
    end_to_end_F = [dephasing(F0,efficient_t,tau_de), F0];
    for i=1:floor(T/efficient_t)-2
        end_to_end_F = arrayfun(@(x) dephasing(x,efficient_t,tau_de), end_to_end_F);       % dephasing of each entanglement
        end_to_end_F(end+1) = F0;       % receiving a new entanglement 
        end_to_end_F = sort(end_to_end_F,'descend');
        if length(end_to_end_F)>2
            purify_result = purification_2_1(end_to_end_F(end-1),end_to_end_F(end));
            purify_F = purify_result(1); purify_prob = purify_result(2);
            end_to_end_F(end) = []; end_to_end_F(end) = [];
            if rand()<purify_prob
                end_to_end_F(end+1) = purify_F;
            end
        end
    end
    end_to_end_F = arrayfun(@(x) dephasing(x,efficient_t,tau_de), end_to_end_F);
    purified_F = dephasing(max(end_to_end_F),rem(T,efficient_t),tau_de);
    % purified_F = max(end_to_end_F);

    % purified_F = max(end_to_end_F); 
    % purified_F_list(end+1) = max(end_to_end_F);
    % purified_F = mean(purified_F_list);
end



% F_list = F*ones(1,n);
% while length(F_list)>1
%     F_list = sort(F_list);
%     F1 = F_list(1);
%     F2 = F_list(2);
%     result = purification_2_1(F1,F2);
%     F_list = F_list(3:end);
%     F = result(1); prob = result(2);
%     if rand()<prob
%         F_list(end+1) = F;
%     end
% end
% 
% if length(F_list)>0
%     purified_F = F_list(1);
% else
%     purified_F = F;
% end