function out = doTomo_cumulative_swap(res, path)
    %Monte Carlo error analysis
    samples=500; %number of noisty data sets to create and analyse

load(res);
if isfield(out, 'photon_first')
    probA = out.photon_first{1}./out.tomo_matrix_attempts1{1};   % first photon total counts/ first photon attempts
    probBA = out.state{1}./out.tomo_matrix_attempts2{1};    %coincidences when first photon first / attempts of second photon, given first succed  
    prob = probBA.*probA;
    cond = 'Cn_';

else   % no conditional probabilities possible
    prob=out.state{1}./out.tomo_matrix_attempts1{1};
    probt = prob;
    probt(isnan(prob)) = 0;
    pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
    prob = prob./pup; %propper way?
    cond = '_';
end
%% in case matrix is not full:


%prob = prob/sum(sum(probt))*34;
%%

% 
% %% - do maximum-likelyhood state tomography/reconstruction, for each gate window in out separately. 
 for hh=1:4 % 4 ion-ion outcomes
    %first build the cprb probability matrix (that linear code wants for max-likely reconstruction. 
    SS=prob(:,1+(hh-1)*4:hh*4);
    counts = out.state{1}(:,1+(hh-1)*4:hh*4);
    attempts = out.tomo_matrix_attempts1{1}(:,1+(hh-1)*4:hh*4);
    if isfield(out, 'photon_first')
         countsA = out.photon_first{1}(:,1+(hh-1)*4:hh*4);
        attemptsB = out.tomo_matrix_attempts2{1}(:,1+(hh-1)*4:hh*4);
    end
    
    %now make 2 qubit projectors, reflecting measurements made
    
    
   sing_obs{2}={ZZ,ZZ;...%0
        XX,ZZ;...%1
        YY,ZZ;...%2
        ZZ,XX;...%3
        XX,XX;...%4
        YY,XX;...%5
        ZZ,-YY;...%6
        XX,-YY;...%7
        YY,-YY;...%8
        }; 
    
    
        
    %observables for 4nd state (SD outcome) % zz correction
   sing_obs{3}={ZZ,ZZ;...%0
        XX,ZZ;...%1
        YY,ZZ;...%2
        ZZ,-XX;...%3
        XX,-XX;...%4
        YY,-XX;...%5
        ZZ,YY;...%6
        XX,YY;...%7
        YY,YY;...%8
        }; 
    
    
    %observables for 3rd state (DS outcome) %yy correction
   
        sing_obs{4} = {ZZ,-ZZ
            XX,-ZZ;...%1
        YY,-ZZ;...%2
        ZZ,-XX;...%3
        XX,-XX;...%4
        YY,-XX;...%5
        ZZ,-YY;...%6
        XX,-YY;...%7
        YY,-YY;...%8
        }; 
    
    
    
    %observables for 4th state (DD outcome) %xx correction
   
         sing_obs{1}={ZZ,-ZZ;...%0
        XX,-ZZ;...%1
        YY,-ZZ;...%2
        ZZ,XX;...%3
        XX,XX;...%4
        YY,XX;...%5
        ZZ,YY;...%6
        XX,YY;...%7
        YY,YY;...%8
        }; 

    sing_obs={ZZ,-ZZ;...%0   %%{1}
        XX,-ZZ;...%1
        YY,-ZZ;...%2
        ZZ,XX;...%3
        XX,XX;...%4
        YY,XX;...%5
        ZZ,-YY;...%6
        XX,-YY;...%7
        YY,-YY;...%8
        }; 
% % % % 
%        sing_obs={ZZ,-ZZ;...% {4}
%         XX,-ZZ;...%1
%         YY,-ZZ;...%2
%         ZZ,-XX;...%3
%         XX,-XX;...%4
%         YY,-XX;...%5
%         ZZ,YY;...%6
%         XX,YY;...%7
%         YY,YY;...%8
%         }; 
%     
%     %%
%
%      
    sing_obs={ZZ,ZZ;...%0   %%{1} %before Jan 15th
        ZZ,XX;...%1
        ZZ,-YY;...%2
        XX,ZZ;...%3
        XX,XX;...%4
        XX,-YY;...%5
        YY,ZZ;...%6
        YY,XX;...%7
        YY,-YY;...%8
        };  
%      sing_obs={ZZ,ZZ;...%0  %correcct for 19th Nov
%         ZZ,XX;...%1
%         ZZ,YY;...%2
%         XX,ZZ;...%3
%         XX,XX;...%4
%         XX,YY;...%5
%         -YY,ZZ;...%6
%         -YY,XX;...%7
%         -YY,YY;...%8
%         };
    
       
     sing_obs={ZZ,ZZ;...%0    % phot1 x phot2 before feb, 1
            ZZ,XX;...%1
            ZZ,-YY;...%2
            XX,ZZ;...%3
            XX,XX;...%4
            XX,-YY;...%5
            YY,ZZ;...%6
            YY,XX;...%7
            YY,-YY;...%8
            };
          sing_obs={ZZ,ZZ;...%0    % phot1 x phot2 before Feb, 21st, 2022
            ZZ,XX;...%1
            ZZ,YY;...%2
            XX,ZZ;...%3
            XX,XX;...%4
            XX,YY;...%5
            -YY,ZZ;...%6
            -YY,XX;...%7
            -YY,YY;...%8
            };
 sing_obs={ZZ,ZZ;...%0    % phot1 x phot2 
            ZZ,-YY;...%1
            ZZ,XX;...%2
            YY,ZZ;...%3
            YY,-YY;...%4
            YY,XX;...%5
            XX,ZZ;...%6
            XX,-YY;...%7
            XX,XX;...%8
            };
   

    
    %sing_obs =sing_obs{2};
    iterations = 100;
    ps_full=create_2ion_projectors(sing_obs,[1 2]);
    out.sing_obs = sing_obs;
    
    SS = SS./sum(SS,2);%%only for full Matrix!!
%     SS = SS/sum(sum(SS))*9;
    probs=reshape(SS',1,9*4);
    measured = find(~isnan(probs));
    data = probs(measured);
    ps = ps_full(:,:,measured);
    
    
    
    %%
    [out.rhoML{hh}, out.P{hh}]=iterfun_data_projectors_tweaked_V(data,2,iterations,ps);
    out.probs{hh} = data';
    out.sing_obs = sing_obs;
    
    FF=isnan(out.rhoML{hh});
    if max(max(FF))>0
        out.rhoML{hh}=zeros(4,4);
    end
    

    
    
    
%     
%     meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
%     out.rhoMC{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,200,samples,ps);%(data, Nqubits, cycleIf s, Niter, N0 mc samples)
    if isfield(out, 'photon_first')
        out.rhoMC{hh} = MC_victors_cond(counts,countsA, attemptsB,    attempts,     samples,iterations, ps);
    else    
        out.rhoMC{hh} = MC_victors(counts, attempts, samples,iterations, ps);
    end
    FF=isnan(out.rhoMC{hh});
    if max(max(FF))>0
        out.rhoMC{hh}=zeros(4,4,samples);
    end
    out.rhoML_cum{hh} = out.rhoMC{hh};
 end



%now do Max likely for cumulative sum of gate windows, startings at gate 2
%(starting 10microseconds) and ending at gate 6 (finisihing at 60 microseconds)

% cprb=zeros(9,5);
% cumcounts=zeros(9,4);
% jt=1:length(out.gatestop);
%  for hh=1:length(jt)
%     %first build the cprb probability matrix (that linear code wants for max-likely reconstruction.     
%     cumcounts=cumcounts+out.tomo_matrix1_counts{jt(hh)};
%     out.tomo_matrix1_counts_cum{hh}=cumcounts;
%     out.tomo_matrix1_cum{hh}=diag(1./sum(out.tomo_matrix1_counts_cum{hh},2))*out.tomo_matrix1_counts_cum{hh},2;
%     cprb(:,1)=0:8;
%     cprb(:,2:5)=out.tomo_matrix1_cum{hh};
%     out.rhoML_cum{hh}=iterfun_data_projectors_tweaked(cprb,2,100,ps);
%     
%     
%     FF=isnan(out.rhoML_cum{hh});
%     if max(max(FF))>0
%         out.rhoML_cum{hh}=zeros(4,4);
%     end
%     
%     %Monte Carlo error analysis
%     %samples=100; %number of noisty data sets to create and analyse
%     meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts_cum{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
%     out.rhoMC_cum{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,100,samples,ps);%(data, Nqubits, cycles, Niter, N0 mc samples)
%     %out.rhoMC_cum{hh} = MC_victors(out.tomo_matrix1_counts_cum{hh}, samples,100, ps);
%     FF=isnan(out.rhoMC_cum{hh});
%     if max(max(FF))>0
%         out.rhoMC_cum{hh}=zeros(4,4,samples);
%     end
%     
%  end
 
 out.samples=samples;



%save out out
analyse_tomoresults_cumulative1
plot_tomoresults_cumulative1
if nargin> 1 
    save(path,'out');
else
    dir ='final';

    last =  find(res == '\');
    if length(last)> 0
        lastfolder = last(end);
        mkdir([res(1:lastfolder)  dir])
        save([res(1:lastfolder) dir filesep 'swapped_states' cond res(lastfolder+1:end)],'out');
    else
        mkdir(dir)
        save([dir filesep 'swapped_states' cond res],'out');
    end
end
figure(3)

