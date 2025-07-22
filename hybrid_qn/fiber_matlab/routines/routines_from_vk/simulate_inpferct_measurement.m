function result  = simulate_inpferct_measurement(rho_in, error_P, N)
prob_mat = zeros(9,4);
for i = 1:N
XXn = XX;
YYn = YY;
ZZn = ZZ;
P = rand(1);
if(1-error_P<P)
    XXn = ZZ;
end;
if(1-error_P/2<P)
    XXn = YY;
end;
P = rand(1);
if(1-error_P<P)
    YYn = ZZ;
end;
if(1-error_P/2<P)
    YYn = XX;
end;
P = rand(1);
if(1-error_P<P)
    ZZn = XX;
end;
if(1-error_P/2<P)
    ZZn = YY;
end;
sing_obs={YYn,ZZ;...%0  %now make 2 qubit projectors, reflecting measurements made

    YYn,XX;...%1
    YYn,YY;...%2
    ZZn,ZZ;...%3
    ZZn,XX;...%4
    ZZn,YY;...%5
    XXn,ZZ;...%6
    XXn,XX;...%7
    XXn,YY;...%8
    };
ps=create_2ion_projectors(sing_obs,[1 2]);
cprb=zeros(9,5);
%simulated_data = zeros(9,4);
cprb(:,1)=0:8;
%------------------------
for ii=1:36;

    AA(ii)=trace(ps(:,:,ii)*rho_in);       %recover prob matrix for a given density matrix
    
end

probs_fromRho=reshape(real(AA),4,9);
prob_mat = prob_mat+probs_fromRho';
end;
prob_mat = probs_from_counts_9x4(prob_mat);
cprb(:,2:5) = prob_mat;
result=iterfun_data_projectors_tweaked(cprb,2,100,ps);
    