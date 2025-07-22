function out = add_noise(dens_Mat, IN, ps, manual_dark, type, ndetectors)
%add_noise(dens_Mat,count_exp, attempts, dark_per_gate)

%Input: state to be exposed to the noise, Matrix of experimantal counts (to
%extract SNR), number of raman pulses per 1 WP setting, noise per one rman
%pulse
%example: add_noise_common(BELL, data, 400000, 2*16e-6)
%%-------------------copy paste from reconstruction
out = IN;
found_dark = manual_dark;
out.Allcounts = [];
out.Allcounts2 = []
noise_window_size = 20;
if(manual_dark < 0)
    %hist1 = histogram(out.Allcounts{1}{1}(:,2)-out.Allcounts{1}{1}(:,3),2*1543);
    for i = 1:length(out.Counts2{1}(1,:))
        out.Allcounts = [out.Allcounts; out.Counts1{1}(:,i)];
        out.Allcounts2 = [out.Allcounts2; out.Counts2{1}(:,i)];
    end
    figure()
    
    hist1 = histogram(out.Allcounts, 1:1000);
    dark_gate_start = fix((out.gatestop{length(out.gatestop)}+5)/hist1.BinWidth);
    dark_gate_stop = fix( dark_gate_start + noise_window_size /hist1.BinWidth);
    dark_per_50us = sum(hist1.Values( dark_gate_start : dark_gate_stop  ));
    found_dark = dark_per_50us/noise_window_size /1e-6/sum( out.attemptsbases{1} );
    title(['hist for noise', dark_gate_start, dark_gate_start])
end;
if(ndetectors == 2)
    manual_dark = manual_dark*2;
    if(manual_dark < 0)
        
        hist1 = histogram(out.Allcounts2, 1:1000);
        dark_gate_start = fix((out.gatestop{length(out.gatestop)}+5)/hist1.BinWidth);
        dark_gate_stop = fix( dark_gate_start + noise_window_size /hist1.BinWidth);
        dark_per_50us = sum(hist1.Values( dark_gate_start : dark_gate_stop  ));
        manual_dark = found_dark+dark_per_50us/noise_window_size /1e-6/sum( out.attemptsbases{1} );
    end
else
    manual_dark = found_dark;
end;    
out.darkrate =  manual_dark
if(max(max(abs(dens_Mat))) == 0)
    bell1 = kron([1 0], [1 0]);
    bell2 = kron([0 1], [0 1]);
    BELL = 1/sqrt(2)*(bell1+bell2);
    dens_Mat =   BELL'*BELL;
     
end;
% sing_obs={YY,ZZ;...%0  %now make 2 qubit projectors, reflecting measurements made
% 
%     YY,XX;...%1
%     YY,YY;...%2
%     ZZ,ZZ;...%3
%     ZZ,XX;...%4
%     ZZ,YY;...%5
%     XX,ZZ;...%6
%     XX,XX;...%7
%     XX,YY;...%8
%     };
%ps=create_2ion_projectors(sing_obs,[1 2]);
cprb=zeros(9,5);
 simulated_data = zeros(9,4);
cprb(:,1)=0:8;
%------------------------
for ii=1:36;

    AA(ii)=trace(ps(:,:,ii)*dens_Mat);       %recover prob matrix for a given density matrix
    
end

probs_fromRho=reshape(real(AA),4,9);
simulated_prob=probs_fromRho';


for hh = 1:(length(out.gatestart))
    attempts = sum(sum(out.tomo_matrix_attempts1{1}))/36;
         
     if(type == 'cum')
        count_exp= out.tomo_matrix1_counts_cum{hh};
        dark_per_gate = 1e-6*manual_dark*(out.gatestop{hh}-out.gatestart{1});
     else
         count_exp= out.tomo_matrix1_counts{hh};
         dark_per_gate = 1e-6*manual_dark*(out.gatestop{hh}-out.gatestart{hh});
     end;
     dark = dark_per_gate*attempts/2;
    Intens = sum(count_exp-dark,2);

    for i = 1:length(Intens)  %should be 9 raws
        simulated_data(i, :) = simulated_prob(i, :)*Intens(i) + dark;
        new_intens = sum(simulated_data(i, :));
        noised_prob(i, :) = simulated_data(i, :)/new_intens;
    end
    cprb(:,2:5)=noised_prob;
    out.rho_noised{hh} =iterfun_data_projectors_tweaked(cprb,2,100,ps);
    out.counts_noised{hh} = simulated_data;
    
end


