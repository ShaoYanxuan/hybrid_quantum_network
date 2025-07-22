function out = doTomo_cumulative_partial_data(res)
load(res);
prob=out.state{1}./out.tomo_matrix_attempts1{1};

%% in case matrix is not full:

probt = prob;
probt(isnan(prob)) = 0;
pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
prob = prob./pup;

%% - load the tomo data: probability data Matrix

load(res)
% 
% %% - do maximum-likelyhood state tomography/reconstruction, for each gate window in out separately. 
 for hh=1:length(out.tomo_matrix1)
    %first build the cprb probability matrix (that linear code wants for max-likely reconstruction. 
    cprb=zeros(9,5); 
    cprb(:,1)=0:8;
    cprb(:,2:5)=out.tomo_matrix1{hh};

%     %now make 2 qubit projectors, reflecting measurements made
    

% - when running early photon analysis, ion 2 e.g.:

    sing_obs={ZZ,ZZ;...%0   phot x ion 
        XX,ZZ;...%1
        -YY,ZZ;...%2
        ZZ,YY;...%3
        XX,YY;...%4
        -YY,YY;...%5
        ZZ,XX;...%6
        XX,XX;...%7
        -YY,XX;...%8
        };


% - when running late photon analysis, ion 1 e.g.:
    

    sing_obs={ZZ,ZZ;...%0   phot x ion 
        XX,ZZ;...%1
        YY,ZZ;...%2
        ZZ,YY;...%3
        XX,YY;...%4
        YY,YY;...%5
        ZZ,XX;...%6
        XX,XX;...%7
        YY,XX;...%8
        };


    ps=create_2ion_projectors(sing_obs,[1 2]);
    [out.rhoML{hh}, out.P{hh}]=iterfun_data_projectors_tweaked(cprb,2,200,ps);
    [drows,dcols]=size(cprb);
    probs =cprb(:,2:dcols);
    [a,b]=size(probs);
    out.probs{hh} = reshape(probs',1,a*b)';
    out.sing_obs = sing_obs;
    
    
    FF=isnan(out.rhoML{hh});
    if max(max(FF))>0
        out.rhoML{hh}=zeros(4,4);
    end
    
    %Monte Carlo error analysis
    samples=25; %number of noisty data sets to create and analyse
    meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
    out.rhoMC{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,200,samples,ps);%(data, Nqubits, cycleIf s, Niter, N0 mc samples)
    
    FF=isnan(out.rhoMC{hh});
    if max(max(FF))>0
        out.rhoMC{hh}=zeros(4,4,samples);
    end
    
 end



%now do Max likely for cumulative sum of gate windows, startings at gate 2
%(starting 10microseconds) and ending at gate 6 (finisihing at 60 microseconds)

cprb=zeros(9,5);
cumcounts=zeros(9,4);
jt=1:length(out.gatestop);
 for hh=1:length(jt)
    %first build the cprb probability matrix (that linear code wants for max-likely reconstruction.     
    cumcounts=cumcounts+out.tomo_matrix1_counts{jt(hh)};
    out.tomo_matrix1_counts_cum{hh}=cumcounts;
    out.tomo_matrix1_cum{hh}=diag(1./sum(out.tomo_matrix1_counts_cum{hh},2))*out.tomo_matrix1_counts_cum{hh},2;
    cprb(:,1)=0:8;
    cprb(:,2:5)=out.tomo_matrix1_cum{hh};
    out.rhoML_cum{hh}=iterfun_data_projectors_tweaked(cprb,2,100,ps);
    
    
    FF=isnan(out.rhoML_cum{hh});
    if max(max(FF))>0
        out.rhoML_cum{hh}=zeros(4,4);
    end
    
    %Monte Carlo error analysis
    %samples=100; %number of noisty data sets to create and analyse
    meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts_cum{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
    out.rhoMC_cum{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,100,samples,ps);%(data, Nqubits, cycles, Niter, N0 mc samples)
    %out.rhoMC_cum{hh} = MC_victors(out.tomo_matrix1_counts_cum{hh}, samples,100, ps);
    FF=isnan(out.rhoMC_cum{hh});
    if max(max(FF))>0
        out.rhoMC_cum{hh}=zeros(4,4,samples);
    end
    
 end
 
 out.samples=samples;
 %add_noise(dens_Mat_before_noise, out_structure,  dark_rate_per_second, say'cum'for_Cumulative)
%out = add_noise(zeros(4,4), out,ps,-1,  'cum',2);
%<<<<<<< HEAD
% TTT =[0.0192 - 0.0000i  -0.0030 - 0.0538i   0.0229 - 0.0520i   0.0144 + 0.0043i;
%   -0.0030 + 0.0538i   0.4758 + 0.0000i   0.4371 + 0.1776i  -0.0168 + 0.0562i;
%    0.0229 + 0.0520i   0.4371 - 0.1776i   0.4898 + 0.0000i   0.0143 + 0.0560i;
%    0.0144 - 0.0043i  -0.0168 - 0.0562i   0.0143 - 0.0560i   0.0151 - 0.0000i];
% out = add_noise(TTT, out,ps,-1,  'cum',1);
% o
% for hh=1:length(jt)
%     cprb(:,2:5)=out.counts_noised{hh};
%     out.rhoMC_noise_cum{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,100,samples,ps);%(data, Nqubits, cycles, Niter, N0 mc samples)
%      % out.rhoMC_noise_cum{hh} = MC_victors(out.counts_noised{hh},samples,100, ps); tested with it but requieres stat. toolbox 
%     if max(max(FF))>0
%         out.rhoMC_noise_cum{hh}=zeros(4,4,samples);
%     end
% end

%=======


save out out
analyse_tomoresults_cumulative
plot_tomoresults_cumulative
save([res(1:end-4) '_reconstructed.mat'],'out');

