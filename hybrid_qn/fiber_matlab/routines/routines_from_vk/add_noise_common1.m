function rho = add_noise(dens_Mat,count_exp, attempts, dark_per_gate)
%Input: state to be exposed to the noise, Matrix of experimantal counts (to
%extract SNR), number of raman pulses per 1 WP setting, noise per one rman
%pulse
%example: add_noise_common(BELL, data, 400000, 2*16e-6)
%%-------------------copy paste from reconstruction

cprb=zeros(9,5);
cprb(:,1)=0:8;
cprb(:,2:5)=count_exp;


%now make 2 qubit projectors, reflecting measurements made

sing_obs={YY,ZZ;...%0
    YY,XX;...%1
    YY,YY;...%2
    ZZ,ZZ;...%3
    ZZ,XX;...%4
    ZZ,YY;...%5
    XX,ZZ;...%6
    XX,XX;...%7
    XX,YY;...%8
    };
ps=create_2ion_projectors(sing_obs,[1 2]);
cprb=zeros(9,5);
 simulated_data = zeros(9,4);
cprb(:,1)=0:8;
%------------------------
for ii=1:36;

    AA(ii)=trace(ps(:,:,ii)*dens_Mat);       %recover prob matrix for a given density matrix
    
end

probs_fromRho=reshape(real(AA),4,9);
simulated_prob=probs_fromRho';

dark = dark_per_gate*attempts/2;
Intens = sum(count_exp-dark,2);

for i = 1:length(Intens)  %should be 9 raws
    simulated_data(i, :) = simulated_prob(i, :)*Intens(i) + dark;
    new_intens = sum(simulated_data(i, :))
    noised_prob(i, :) = simulated_data(i, :)/new_intens;
end
cprb(:,2:5)=noised_prob;
rho =iterfun_data_projectors_tweaked(cprb,2,100,ps);
