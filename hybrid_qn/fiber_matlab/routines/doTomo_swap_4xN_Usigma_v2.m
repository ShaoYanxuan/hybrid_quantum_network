function out = doTomo_swap_4xN_Usigma_v2(res, UN, addname, samples)
%combining several data of 4 states each
data_4states = [];
ps_4states = [];
counts_4states = [];
attempts_4states = [];
countsA_4states = [];
attemptsB_4states = [];
res1 = [];
out.U4 = UN;
for ndat = 1:length(res)
    clear out
    load(res{ndat});
    U = UN{ndat};
    res1 = [res1 res{ndat}]
    
    if isfield(out, 'photon_first')
        Nc  =zeros(9,16);
        Na  =zeros(9,16);
        Kc  =zeros(9,16);
        Ka  =zeros(9,16);
       %now:     %Pdark_dark|HH*Phh
       for j = 1:4 %ion state index
           for i = 1:4  %photon state index
             %coinc number
            Nc(:,i+(j-1)*4) = out.state{1}(:,i+(j-1)*4);%./(out.state{1}(:,i)+out.state{1}(:,i+4)+out.state{1}(:,i+8)+out.state{1}(:,i+12) );
            %singles number
            Na(:,i+(j-1)*4) = (out.photon_first{1}(:,i)+out.photon_first{1}(:,i+4)+out.photon_first{1}(:,i+8)+out.photon_first{1}(:,i+12) );
            %coinc attempts
            Ka(:,i+(j-1)*4) = (out.tomo_matrix_attempts1{1}(:,i)+out.tomo_matrix_attempts1{1}(:,i+4)+out.tomo_matrix_attempts1{1}(:,i+8)+out.tomo_matrix_attempts1{1}(:,i+12));
            Kc(:,i+(j-1)*4) = (out.tomo_matrix_attempts2{1}(:,i)+out.tomo_matrix_attempts2{1}(:,i+4)+out.tomo_matrix_attempts2{1}(:,i+8)+out.tomo_matrix_attempts2{1}(:,i+12)); %(out.state{1}(:,i)+out.state{1}(:,i+4)+out.state{1}(:,i+8)+out.state{1}(:,i+12) )/
           end
           if contains(res{ndat},'Tr_3') %first photon is photon B
           m = 2;
           n = 4;
           else  %first photon is photon A
               m = 1;
               n = 3;
           end
           Na(:,m+(j-1)*4) = Na(:,m+(j-1)*4)+Na(:,n+(j-1)*4);
           Na(:,n+(j-1)*4) =  Na(:,m+(j-1)*4);
           Ka(:,m+(j-1)*4) = Ka(:,m+(j-1)*4)+Ka(:,n+(j-1)*4);
           Ka(:,n+(j-1)*4) =  Ka(:,m+(j-1)*4);
           
       end
        prob = Nc.*Na./Kc./Ka;
        cond = 'Cn_';

    else   % no conditional probabilities possible
        prob=out.state{1}./out.tomo_matrix_attempts1{1};
        probt = prob;
        probt(isnan(prob)) = 0;
        pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
        prob = prob./pup; %propper way?
        cond = '_';
    end
%     %prob=out.state{1}./out.tomo_matrix_attempts1{1};
%     %% in case matrix is not full:
%     probt = prob;
%     probt(isnan(prob)) = 0;
%     pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
%     prob = prob./pup; %propper way?
    %%
     sing_obs{1}={ZZ,ZZ;...%0    % before Jan 15th 2020
            ZZ,XX;...%1
            ZZ,-YY;...%2
            XX,ZZ;...%3
            XX,XX;...%4
            XX,-YY;...%5
            YY,ZZ;...%6
            YY,XX;...%7
            YY,-YY;...%8
            };
    %     
    %  sing_obs{1}={ZZ,ZZ;...%0  %correcct for 19th Nov
    %         ZZ,XX;...%1
    %         ZZ,YY;...%2
    %         XX,ZZ;...%3
    %         XX,XX;...%4
    %         XX,YY;...%5
    %         -YY,ZZ;...%6
    %         -YY,XX;...%7
    %         -YY,YY;...%8
    %         };
      
    %     
    
           
    sing_obs{1}={ZZ,ZZ;...%0    % phot1 x phot2 before feb, 1
            ZZ,XX;...%1
            ZZ,-YY;...%2
            XX,ZZ;...%3
            XX,XX;...%4
            XX,-YY;...%5
            YY,ZZ;...%6
            YY,XX;...%7
            YY,-YY;...%8
            };
          sing_obs{1}={ZZ,ZZ;...%0    % phot1 x phot2 before March, 8th 2022
            ZZ,XX;...%1
            ZZ,YY;...%2
            XX,ZZ;...%3
            XX,XX;...%4
            XX,YY;...%5
            -YY,ZZ;...%6
            -YY,XX;...%7
            -YY,YY;...%8
            };
        sing_obs{1}={ZZ,ZZ;...%0    % phot1 x phot2 
            ZZ,-YY;...%1
            ZZ,XX;...%2
            YY,ZZ;...%3
            YY,-YY;...%4
            YY,XX;...%5
            XX,ZZ;...%6
            XX,-YY;...%7
            XX,XX;...%8
            };
   
    
     Usigma{1} = nkron(II,II); Usigma{2} = nkron(II,XX); Usigma{4} = nkron(II,YY); Usigma{3} = nkron(II,ZZ); 
     %Usigma{1} = nkron(II,II); Usigma{3} = nkron(II,XX); Usigma{4} = nkron(II,YY); Usigma{2} = nkron(II,ZZ);

     for hh=1:4 % 4 ion-ion outcomes
        %first build the cprb probability matrix (that linear code wants for max-likely reconstruction. 
        SS=prob(:,1+(hh-1)*4:hh*4);
        counts = Nc(:,1+(hh-1)*4:hh*4);
        attempts = Ka(:,1+(hh-1)*4:hh*4);
        if isfield(out, 'photon_first') % for conditional probs
            countsA = Na(:,1+(hh-1)*4:hh*4);
            attemptsB = Kc(:,1+(hh-1)*4:hh*4);
            countsA_4states =  cat(1, countsA_4states, countsA);
            attemptsB_4states = cat(1, attemptsB_4states, attemptsB);
        end
        %now make 2 qubit projectors, reflecting measurements made



        iterations = 500;
        ps_full=create_2ion_projectors(sing_obs{1},[1 2]);


        SS = SS./sum(SS,2);%%only for full Matrix!!

        probs=reshape(SS',1,9*4);
        measured = find(~isnan(probs));
        data = probs(measured);
        ps = ps_full(:,:,measured);

        
        Basis_Rot = U'*Usigma{hh}*U;
        for tt = 1:length(ps(1,1,:))
            ps(:,:,tt) =U*Basis_Rot*ps(:,:,tt)*Basis_Rot*U';
        end
        out.ps{hh} = ps;
        ps_4states = cat(3, ps_4states, ps);
        data_4states = cat(2, data_4states, data);
        counts_4states = cat(1, counts_4states, counts);
        attempts_4states = cat(1, attempts_4states, attempts);
        %% ps
     end
end
 hh = 1;
    %%
[out.rhoML{hh}, out.P{hh}]=iterfun_data_projectors_tweaked_V(data_4states,2,iterations,ps_4states);
out.probs{hh} = data_4states';
out.sing_obs = sing_obs;
out.counts_4states = counts_4states;
out.countsA_4states = countsA_4states;

FF=isnan(out.rhoML{hh});
if max(max(FF))>0
    out.rhoML{hh}=zeros(4,4);
end

%Monte Carlo error analysis
%samples=200; %number of noisty data sets to create and analyse



%     
%     meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
%     out.rhoMC{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,200,samples,ps);%(data, Nqubits, cycleIf s, Niter, N0 mc samples)
 
    if  isfield(out, 'photon_first')
        out.rhoMC{hh} = MC_victors_cond_v2(counts_4states, countsA_4states, attemptsB_4states,    attempts_4states,     samples,iterations, ps_4states);
    else 
        out.rhoMC{hh} = MC_victors(counts_4states, attempts_4states, samples,iterations, ps_4states);
        %out.rhoMC{hh} = MC_victors(counts, attempts, samples,iterations, ps);
    end 

    FF=isnan(out.rhoMC{hh});
    if max(max(FF))>0
        out.rhoMC{hh}=zeros(4,4,samples);
    end
    out.rhoML_cum{hh} = out.rhoMC{hh};






 out.samples=samples;



%save out out
analyse_tomoresults_cumulative_BELL
plot_tomoresults_cumulative1
dir ='v2_Nstate';
res1 = res{1}
if nargin < 3
    addname = [];
end
last =  find(res1 == '\');
if length(last)> 0
    lastfolder = last(end);
    mkdir([res1(1:lastfolder)  dir])
    save([res1(1:lastfolder) dir filesep 'out_4xN_comb_' addname cond res{1}(lastfolder+1:end) res{2}(lastfolder+1:end)],'out');
else
    mkdir(dir)
    save([dir filesep 'out_4xN_comb_' addname cond res1],'out');
end
figure(3)



