function rhomc = MC_victors_cond_v2(exp_coinc, exp_A, exp_attemptsB,exp_attemptsA, samples, iterations, ps)
rhomc = zeros(4, 4, samples);
%unify notations with main reconstruction script.
Kc = exp_attemptsB;
Ka = exp_attemptsA;

zers = find(~exp_coinc);
exp_coinc(zers) = 1;
for mki = 1:samples   %monte-carlo simulations iterations
    if ~mod(mki, samples/10)
        MK_iteration = mki
    end
    Nc = poissrnd1(exp_coinc);
    Na = poissrnd1(exp_A);
        
    
    prob = Nc.*Na./Kc./Ka;
    
    probt = prob;
    probt(isnan(prob)) = 0;
    pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
    prob = prob./pup;
    
      prob(isnan(prob)) = 0; %REMOVE THIS LINE WHEN DATA SET HAS MISSING PROJECTIONS
    
    probs=reshape(prob',1,length(prob(:,1))*length(prob(1,:)));
    measured = find(~isnan(probs));
    data = probs(measured);
    
    rhomc(:,:, mki)=iterfun_data_projectors_tweaked_V(data,2, iterations,ps);
    
    FF=isnan(rhomc(:,:, mki));
    if max(max(FF))>0
        rhomc(:,:, mki)=zeros(4,4);
        warning = mki
    end
end;
