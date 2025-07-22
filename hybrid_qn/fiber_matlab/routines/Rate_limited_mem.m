function [Rate, testsum] =  Rate_limited_mem(Ps, MemLim, Reps_param)
if nargin <3
    Reps_param = 8000;
end
Fact = 1;
MemLim = MemLim*Fact;
 N =MemLim;
Reps =Reps_param;

res_B = 0;
P_sum = 0;  
res2 = 0;
res0 = 0;
testsum = 0;
Tav = 0;
Pr  =zeros(N,1); % h
%% second formula
for k = 1:N
    inner_sum = 0;
    for n = max(1, k-MemLim/Fact):k-1
        inner_sum = inner_sum+(1-Ps)^(n-1);
    end
   % inner_sum = (1-(1-Ps)^(k-1))/Ps;
    Pr(k) = 2 *Ps*(1-Ps)^(k-1)*(Ps*inner_sum   + 0.5*Ps*(1-Ps)^(k-1) ); % prob succeeding in k steps?
    
    %P_sum = P_sum+2 *Ps*(1-Ps)^(k-1)*(Ps*inner_sum   + 0.5*Ps*(1-Ps)^(k-1) );
    
    % res2(i) = res2(i)+k*Ps^2*( 2*(1-Ps)^(k-1)*inner_sum   + (1-Ps)^(k-1) );
    %res2(i) = res2(i)+Ps*k*(1-Ps)^(k-1)*(2+Ps-2*(1-Ps)^(k-1)); Ok
    %res2(i) = res2(i)+Ps*k*(1-Ps)^(k-1)*(2+Ps) -2*Ps*k*(1-Ps)^(2*k-2); Ok
end
P_sum = sum(Pr); % total prob succ (in first memstep*Fact steps)
for i = 1:Reps
    K = MemLim*(i-1)+1:MemLim*i;
    Tav = Tav + sum(K'.*Pr)*(1-P_sum)^(i-1);
    testsum = testsum + P_sum*(1-P_sum)^(i-1);
end

%%
% res2(i) = (2+Ps)/Ps-2/(Ps*(2-Ps)^2);  %Ok!!
%res2(i) = (Ps^3-2*Ps^2-4*Ps+6)/( Ps*(2-Ps)^2  );   % this is current version (before 2021_02 15)

%testsum
Rate= 1./Tav;  %checking original eqs, agrees with Bechers formula 2021 02 15
%R_becher(i) = Ps*(2-Ps)/(3-2*Ps);


