 function [L, Rate] = secret_key_with_decoherence_function(Params)
%% exp params
g = Params.g; %0.019%g = 0.02; % 0.2 dB/km 
P0 = Params.P0; %(0.93*0.78*0.9*0.5*0.9*0.87)

MemSteps =Params.MemSteps; %200;

F0 = Params.F0;%0.98; % ion-phot fidepity
T = Params.T%2; %Gaussian model characteristic time in sec
%was: Decoherence as ~exp(K/T), number of steps/ T

do_ion_ion =Params.do_ion_ion;%0
frac_method = Params.frac_method; %6; % use 4 or 6 for SKR (BB84, 6-state), 0 for the distilled fraction


%% sim params
Lmax = Params.Lmax; %400; %in km
LengthSteps = Params.LengthSteps; %5;
C = 2.997e5/1.4682; % in km/s


%% go

standardbell;standardpolns;
Mix = 1/4*(phipm+psipm+phimm+psimm);
Al = (F0-1/4)/(1-1/4);
rho_iph = Al*phipm+(1-Al)*Mix;
sec_frac = zeros(LengthSteps, MemSteps);
if do_ion_ion
  P0 = P0^2*0.5 % for matter - matter: 2 photons and 1/2 Bell measurement
  rho_t = estimate_swapped_fidelity(rho_iph, rho_iph, Params.Fswap, 'dephase'); %matter-matter state from 2 ion-photon states
  rho_iph = rho_t{1};
end
%we will need to compensa for MS gate returning not exacty phi minus
t = estimate_swapped_fidelity(rho_iph, rho_iph, Params.Fswap,'depolarize');
rho_base{1} = phipm; rho_base{3} = phimm; rho_base{2} = psipm; rho_base{4} = psimm;
if ~exist('Ucorr') % to save time
    %Ucorr1 = find_opt_U4(rho_t, rho_base);
    Ucorr = find_opt_U4(t, rho_base);
end
if ~isfield(Params,'Tdetection')
    Params.Tdetection = 0;
end
df = Distilled_Fraction(Ucorr*t{3}*Ucorr',frac_method);
rho_step = zeros(4,4,MemSteps);
sec_frac_step = zeros(MemSteps,1);
sec_frac_step1 = zeros(MemSteps,1);
sec_frac_step_secret = zeros(MemSteps,1);
swpped_fid_step = zeros(MemSteps,1);
tangle_step =  zeros(MemSteps,1);
fid_iph = zeros(MemSteps,1);

%% loop over  length
for i = 1:LengthSteps  
    L(i) = Lmax*i/LengthSteps;
    Psm = P0*10^(-g*L(i)/2); % succ prob 
    sprintf('L = %d, Ps = %.3f', L(i), Psm)
    t = L(i)/C+Params.Photon_gen_time ; %attempt time
    Threshold_Step = MemSteps;
    
    %subloop over memory steps
    for K = 1: MemSteps 
        %rho_iph_decoh = gauss_decoh(rho_iph,t*K,T,0.5,1); %was before
        rho_iph_decoh = gauss_decoh_simple(rho_iph,t*K,T); %decoherence
        rho_t = estimate_swapped_fidelity(rho_iph_decoh, rho_iph, Params.Fswap,'depolarize');
        rho_step(:, :, K) = Ucorr*rho_t{3}*Ucorr';% Taking phi minus, because of secret_Fraction def. better to average?
        checktrace(rho_step(:, :, K));
        sec_frac_step_secret(K) = Secret_Fraction(rho_step(:, :, K), '6');
        swpped_fid_step(K) = mixedfid(rho_step(:, :, K), phimm);
        %%tangle_step(K) = tangle(rho_step(:, :, K));
        %%sec_frac_step1(K) = Distilled_Fraction(rho_step(:, :, K), 1);
        %sec_frac_step(K) = Distilled_Fraction(rho_step(:, :, K),frac_method);
        %fid_iph(K) = mixedfid(rho_iph_decoh, phipm);
        
        if sec_frac_step_secret(K) < Params.threshold_fraction  % abbort attempts when SKF is below threshold
            Threshold_Step = K
            fid_iph = mixedfid(rho_iph_decoh, phipm)
            mixedfid(rho_step(:, :, K), phimm)
            break;
                   
        end
    end


    
    %getting the raw rate for that dostance
    %R_direct_maxt(i)= 2*log2((1+10^(-g*L(i)))/(1-10^(-g*L(i)))) *C/(2*L(i));
    R_direct_maxt(i)= 2*-log2(1-10^(-g*L(i))) *C/(2*L(i));
    [Step_mem(i), testsum(i)] = Rate_limited_mem(Psm, Threshold_Step, Params.Reps);
    
    rho = zeros(4,4);
    norm = 0;
    
    %waited averaging of the state within attempts up to threshold
    for K = 1: Threshold_Step % mixing with weight  ~ probs
        rho = rho + (1-Psm)^(K-1)*Psm*rho_step(:, :, K);
        norm = norm + (1-Psm)^(K-1)*Psm;
        %sec_frac(i, K) = Secret_Fraction(rho/norm);
        sec_frac(i, K) = Distilled_Fraction(rho/norm,frac_method); %this is secret fraction in the cumulative state
    end
    rho = rho/norm;
  
    R_step_mem(i) = Step_mem(i)/ (L(i)/C+Params.Photon_gen_time );
    R_step_mem(i) = 1/(1/R_step_mem(i)+Params.Tdetection)*Distilled_Fraction(rho,frac_method);
    R_direct(i) = 2*P0*10^(-g*L(i)) / (2*L(i)/C+0 )*df;
    %R_direct_maxt(end)/R_direct(end)* P0*df/2/sqrt(2)  % == 1
    checktrace(rho); 
    
    figure(111)
    hold on
    % here we plot fidelity and secret fraction in the particulat mem. step, NOT cumulative
    pl = plot(1:K, swpped_fid_step(1:K), '-', 'DisplayName', 'Swapped state fidelity in the step');
    plot(1:K, sec_frac_step_secret(1:K), ':', 'Color', pl.Color, 'DisplayName', 'Secret key fraction in the step') 
end;

set(groot,'defaultLineLineWidth',2.0)
figure()
hold on
plot(L, (R_direct_maxt), 'LineWidth', 2, 'LineStyle', '-' , 'DisplayName','Theoretical max TGW')
plot(L, (R_direct), 'LineWidth', 2, 'LineStyle', '-.' , 'DisplayName','Expected direct')

plot(L, (R_step_mem), 'LineWidth', 2,  'LineStyle', '--', ... 
    'DisplayName', sprintf('Theory memory< %d steps decoh ~exp(-K/%d). P_0= %.3f', MemSteps,T, P0))
set(gca, 'YScale', 'log')
legend('show', 'Location', 'NorthEast')
grid on
%xlim([0,225])
%ylim([-1,5])
xlabel(['Total distance with ' num2str(10*g) ' dB/km att (km)'])
ylabel('Rate (s^{-1})')
title(['Secret key rate'])

% figure()
% sec_frac(1,1) = 0;
% sec_frac(end,end) = 1;
% surface(real(sec_frac))
% shading flat


%plot(1:K, sec_frac_step_secret, '-', 'DisplayName', 'Secret key fraction in the step')
%plot(1:K, sec_frac_step, '-', 'DisplayName', 'Distillable states')
%plot(1:K, sec_frac_step1, '-', 'DisplayName', 'Distillable states by paper')
%plot(1:K, tangle_step, '-', 'DisplayName', 'Tangle')

figure(111)
%plot(1:K, fid_iph, '-', 'DisplayName', 'Ion-photon fidelity in memory')
xlabel('Step number')
legend('show')
grid minor
ylim([0,1])

Rate = R_step_mem;
