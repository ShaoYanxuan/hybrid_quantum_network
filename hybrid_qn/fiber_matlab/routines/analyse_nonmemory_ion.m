function Rho_Nonmem  = analyse_nonmemory_ion()
if ~exist('QOS_path')
    
    fsep = filesep;
    QOS_path = '\\zidshare.uibk.ac.at\qos';
    folder = [QOS_path fsep 'qfc' fsep 'analysis' fsep '2021_03_05_ViK' fsep 'ion-photon' fsep 'res' fsep ];
end
%ion_2_nonmem_l_140to140_reconstructed
prefix = 'ion_2_nonmem_l_';
postfix = '_reconstructed';
memsteps = [  195 , 100,  140, 1, -10];
standardbell

summed_counts = zeros(210, 1);
summed_attempts = zeros(210, 1);

f_fidhist = figure();
hold on
for i = 1:length(memsteps)
    if memsteps( i) <0 % summed data of nonmemory measurements
        file = [folder 'ion_2_nonmem_av_l_1to200_reconstructed.mat']
    else
        file = [folder prefix num2str(memsteps(i)) 'to' num2str(memsteps(i)) postfix]
    end
   % eff(i) = efficiency(file);
    load(file) % this is reconstruct
    counts(i) = sum((sum(out.tomo_matrix1_counts{1}))); % total counts
    rhoML{i} = out.rhoML{1};
    fidopt(i) = out.fidopt;
    fidstd(i) = out.fidoptSTD;
    rhoMC{i} = out.rhoMC{1};
    count_loop{i} =  out.count_loop{1};  % how many counts in each loop
    attempts(i) = 0;
    for j = 1:length(out.attemptsbases{1})
        attempts(i) =attempts(i)+ sum(out.nloops{1}{j}-out.nloops2{1}{j});
    end;
    if memsteps(i) > 0
        ln = length(find(count_loop{i}));
        summed_counts(1:ln-1) = summed_counts(1:ln-1) + count_loop{i}(2:ln);  %loop1 was not used in this exp
        summed_attempts(1:ln-1) = summed_attempts(1:ln-1) + attempts(i)/(ln-1);
    end
    
    U{i} = out.optU{1};
    rhoML{i} = out.rhoML{1};
%     if(memsteps(i) ==1) % let's get a wavepacket here
%         Rho_Nonmem.f_wavepacket_nonmem = figure();
%         Rho_Nonmem.h_wavepacket_nonmem = histogram( reshape(out.Counts2{1}, [], 1), [1:1:1000]);
%     end
    if memsteps(i) ==200; memsteps(i) = 195; end % we had 195 steps actually
    if memsteps(i) ==-1  %  to correct for point 1, use == 1 instead
        T = kron(II,ZZ); 
        rhoML_rot{i} = T*rhoML{i}*T;
        rhoML_rot{i} = U{1}*rhoML_rot{i}*U{1}';
    else
        rhoML_rot{i} = U{1}*rhoML{i}*U{1}';
    end
    
    for sampl = 1:out.samples
         if memsteps(i) ==-1
            rhoMC_rot{i}(:,:,sampl) = U{1}*T*out.rhoMC{1}(:,:,sampl)*T*U{1}'; % need to correct odd spin-echos
        else
            rhoMC_rot{i}(:,:,sampl) = U{1}*out.rhoMC{1}(:,:,sampl)*U{1}';
        end
        
%        rhoMC_rot{i}(:,:,sampl) = U{1}*out.rhoMC{1}(:,:,sampl)*U{1}';
        fidoptMC_rot(sampl) = mixedfid(rhoMC_rot{i}(:,:,sampl), phipm);
    end
    if (memsteps(i) == 195) % plot only this memstep
        figure(f_fidhist);
        histogram(fidoptMC_rot, [0:2:100]/100, 'FaceAlpha', 0.3, 'DisplayName', ['Fidelity with phi+  for ' num2str(memsteps(i)) ' mem steps'])
    end
    fidopt_rot(i) = mixedfid(rhoML_rot{i}, phipm); %take the fidelity with phi+ directly!
    fidstd_rot(i) = std(fidoptMC_rot);
end
title('Non-memory ion')
xlabel('Fidelity')
grid minor
legend('Show','Location', 'NorthWest' )
xlim([0.4 1]);
saveas(f_fidhist, 'Nonmemory_854_Fhist.png')
%Rho_Nonmem = (counts(2)*rhoML_rot{2}+counts(3)*rhoML_rot{3}+counts(4)*rhoML_rot{4})/(counts(2)+counts(3)+counts(4)); %would be better to add  up counts and then reconstruct
Rho_Nonmem.ML =rhoML_rot{1}; %nonmemory state for 195 steps
Rho_Nonmem.MC =rhoMC_rot{1}
%% reproducing https://labblogs.quantumoptics.at/qfc/2021/03/08/limitations-for-the-memory-repeater-experiments/#entanglement

fnm = figure();

errorbar(memsteps(1:end-1), fidopt(1:end-1), fidstd(1:end-1), 'DisplayName', 'Fidelity with an independent nearest max. ent', 'LineStyle', 'none', 'LineWidth', 2);
hold on
errorbar(memsteps(1:end-1), fidopt_rot(1:end-1), fidstd_rot(1:end-1), 'DisplayName', ['Fidelity with phi+ and rotation found for ' num2str(memsteps(1)) ' mem steps'], 'LineStyle', 'none', 'LineWidth', 2);
errorbar(memsteps(end), fidopt_rot(end), fidstd_rot(end), 'DisplayName',  ['Added up state,  Fidelity with phi+ and rotation found for ' num2str(memsteps(1)) ' mem steps'], 'LineStyle', 'none', 'LineWidth', 2);

K = 10;
%errorbar(memsteps, K*eff, K*eff./sqrt(counts), 'DisplayName', ['Efficiency x' num2str(K)])

hold on
figure(fnm)

for i = 1:length(memsteps)-1  %plotting nonmemory ion efficiency for all measurements
    %figure(fnm)
    errorbar( [2:length(count_loop{i})]-1, K*count_loop{i}(2:end)/attempts(i)*memsteps(i), K*sqrt(count_loop{i}(2:end))/attempts(i)*memsteps(i),... %0 memloops point isn't valid for this seq.
        'DisplayName', ['Efficiency for the measurement with ' num2str(memsteps(i)) ' mem. steps x' num2str(K)])
end
i = 1;% take eff. of 1st data point, memsteps = 195
% bar( [2:length(count_loop{i})]-1, K*count_loop{i}(2:end)/attempts(i)*memsteps(i),... %0 memloops point isn't valid for this seq.
%         'DisplayName', ['Efficiency for the measurement with ' num2str(memsteps(i)) ' mem. steps x' num2str(K)])

max_len = min(length(find(summed_counts)), length(find(summed_attempts))); %find nonzero elements
good_summed_cnts = summed_counts(1:max_len);
good_summed_atts = summed_attempts(1:max_len);
 
Rho_Nonmem.eff = count_loop{i}(2:max(memsteps))/attempts(i)*memsteps(i);
Rho_Nonmem.eff_err =  sqrt(count_loop{i}(2:max(memsteps)))/attempts(i)*memsteps(i);

Rho_Nonmem.eff = good_summed_cnts./good_summed_atts;
Rho_Nonmem.eff_err = sqrt(good_summed_cnts)./good_summed_atts;
Rho_Nonmem.Fid = fidopt_rot(1);
Rho_Nonmem.FidSTD =  fidstd_rot(1);

xlim([-15,200])
ylim([0, 1])
grid minor
xlabel('Memory steps. (to add second axis with equivalent wait time)')
title('Non memory (second succeded) ion')
legend('show',  'Location', 'SouthEast')
savefig(fnm, 'nonmemory_854_i_ph')
saveas(fnm, 'nonmemory_854_i_ph.png')
