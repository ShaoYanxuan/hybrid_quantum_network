function out = doTomo_swap_combineN(res, UN, addname, samples)
%combining several data of 4 states each
standardbell
Usigma{1} = nkron(II,II); Usigma{2} = nkron(II,XX); Usigma{4} = nkron(II,YY); Usigma{3} = nkron(II,ZZ); 
rho_base{1} = phipm; rho_base{3} = phimm; rho_base{2} = psipm; rho_base{4} = psimm;
for hh=1:4
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
        if ndat ==1 && hh == 1
            out_new = out;
        end
        U = UN{ndat};
       % res1 = [res1 res{ndat}]

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
    %     %prob=out.state{1}./out.tomo_matrix_attempts1{1};
    %     %% in case matrix is not full:
    %     probt = prob;
    %     probt(isnan(prob)) = 0;
    %     pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
    %     prob = prob./pup; %propper way?
        %%

            sing_obs{1}={ZZ,ZZ;...%0    % phot1 x phot2 before Feb, 23st, 2022
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

         
         %Usigma{1} = nkron(II,II); Usigma{3} = nkron(II,XX); Usigma{4} = nkron(II,YY); Usigma{2} = nkron(II,ZZ);

       % 4 ion-ion outcomes
            %first build the cprb probability matrix (that linear code wants for max-likely reconstruction. 
        SS=prob(:,1+(hh-1)*4:hh*4);
        counts = out.state{1}(:,1+(hh-1)*4:hh*4);
        attempts = out.tomo_matrix_attempts1{1}(:,1+(hh-1)*4:hh*4);
        if isfield(out, 'photon_first') % for conditional probs
            countsA = out.photon_first{1}(:,1+(hh-1)*4:hh*4);
            attemptsB = out.tomo_matrix_attempts2{1}(:,1+(hh-1)*4:hh*4);
            countsA_4states =  cat(1, countsA_4states, countsA);
            attemptsB_4states = cat(1, attemptsB_4states, attemptsB);
        end
        %now make 2 qubit projectors, reflecting measurements made



        iterations = 200;
        ps_full=create_2ion_projectors(sing_obs{1},[1 2]);


        SS = SS./sum(SS,2);%%only for full Matrix!!

        probs=reshape(SS',1,9*4);
        measured = find(~isnan(probs));
        data = probs(measured);
        ps = ps_full(:,:,measured);


        Basis_Rot = eye(4);%U'*Usigma{hh}*U;
        for tt = 1:length(ps(1,1,:))
            ps(:,:,tt) =U*Basis_Rot*ps(:,:,tt)*Basis_Rot*U';
        end
        out_new.ps{hh} = ps;
        ps_4states = cat(3, ps_4states, ps);
        data_4states = cat(2, data_4states, data);
        counts_4states = cat(1, counts_4states, counts);
        attempts_4states = cat(1, attempts_4states, attempts);
        %% ps

    end
     
        %%
    [out_new.rhoML{hh}, out_new.P{hh}]=iterfun_data_projectors_tweaked_V(data_4states,2,iterations,ps_4states);
    out_new.probs{hh} = data_4states';
    out_new.sing_obs = sing_obs;
    
    out.counts_4states{hh} = counts_4states;
    out.countsA_4states{hh} = countsA_4states;

    FF=isnan(out_new.rhoML{hh});
    if max(max(FF))>0
        out_new.rhoML{hh}=zeros(4,4);
    end

    %Monte Carlo error analysis
   % samples=500; %number of noisty data sets to create and analyse



    %     
    %     meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
    %     out.rhoMC{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,200,samples,ps);%(data, Nqubits, cycleIf s, Niter, N0 mc samples)

    if  isfield(out, 'photon_first')
        out_new.rhoMC{hh} = MC_victors_cond(counts_4states, countsA_4states, attemptsB_4states,    attempts_4states,     samples,iterations, ps_4states);
    else 
        out_new.rhoMC{hh} = MC_victors(counts_4states, attempts_4states, samples,iterations, ps_4states);
        %out_new.rhoMC{hh} = MC_victors(counts, attempts, samples,iterations, ps);
    end 

    FF=isnan(out_new.rhoMC{hh});
    if max(max(FF))>0
        out_new.rhoMC{hh}=zeros(4,4,samples);
    end
    out_new.rhoML_cum{hh} = out_new.rhoMC{hh};






     out_new.samples=samples;

end

%save out out
out = out_new;
analyse_tomoresults_cumulative_BELL
plot_tomoresults_cumulative1
dir ='v2_combine';
res1 = res{1} ;
if nargin < 3
    addname = [];
end
last =  find(res1 == '\');
if length(last)> 0
    lastfolder = last(end);
    mkdir([res1(1:lastfolder)  dir])
    save([res1(1:lastfolder) dir filesep 'out_N_comb_' addname cond res1(lastfolder+1:end)],'out');
else
    mkdir(dir)
    save([dir filesep 'out_N_comb_' addname cond res1],'out');
end
figure(3)



