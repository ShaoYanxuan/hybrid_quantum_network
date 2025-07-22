function rhomc = MC_victors_cond(exp_coinc, exp_A, exp_attemptsB,exp_attemptsA, samples, iterations, ps)
rhomc = zeros(4, 4, samples);





for mki = 1:samples   %monte-carlo simulations iterations
    MK_iteration = mki
    pseudo_coinc = poissrnd1(exp_coinc);
    pseudo_A = exp_A; %poissrnd1(exp_A);
        
    
    probA = pseudo_A./exp_attemptsA;
    probBA =  pseudo_coinc./exp_attemptsB;
    prob = probBA.*probA;
    
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
