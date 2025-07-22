function out = doTomo_swap_4states_arb_4U(res, U, addname)
%combining data for 4 outcomes given 4 arb Unitaries affecting phipm
load(res);

prob=out.state{1}./out.tomo_matrix_attempts1{1};

data_4states = [];
ps_4states = [];
counts_4states = [];
attempts_4states = [];
%% in case matrix is not full:


probt = prob;
probt(isnan(prob)) = 0;
pup = sum(probt,2)./sum((~isnan(prob)),2)*4;
prob = prob./pup; %propper way?
%%
 sing_obs{1}={ZZ,ZZ;...%0   %before Jan 15th
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
          sing_obs{1}={ZZ,ZZ;...%0    % phot1 x phot2
            ZZ,XX;...%1
            ZZ,YY;...%2
            XX,ZZ;...%3
            XX,XX;...%4
            XX,YY;...%5
            -YY,ZZ;...%6
            -YY,XX;...%7
            -YY,YY;...%8
            };
   

 Usigma{1} = nkron(II,II); Usigma{2} = nkron(II,XX); Usigma{4} = nkron(II,YY); Usigma{3} = nkron(II,ZZ); 
 %Usigma{1} = nkron(II,II); Usigma{3} = nkron(II,XX); Usigma{4} = nkron(II,YY); Usigma{2} = nkron(II,ZZ);
 
 for hh=1:4 % 4 ion-ion outcomes
    %first build the cprb probability matrix (that linear code wants for max-likely reconstruction. 
    SS=prob(:,1+(hh-1)*4:hh*4);
    counts = out.state{1}(:,1+(hh-1)*4:hh*4);
    attempts = out.tomo_matrix_attempts1{1}(:,1+(hh-1)*4:hh*4);
    %now make 2 qubit projectors, reflecting measurements made
    
    
   
    iterations = 200;
    ps_full=create_2ion_projectors(sing_obs{1},[1 2]);

    
   % SS = SS./sum(SS,2);%%only for full Matrix!!
   
    probs=reshape(SS',1,9*4);
    measured = find(~isnan(probs));
    data = probs(measured);
    ps = ps_full(:,:,measured);
    
    out.U4 = U;
    Basis_Rot = U{hh};
    for tt = 1:length(ps(1,1,:))
        ps(:,:,tt) = Basis_Rot*ps(:,:,tt)*Basis_Rot';
    end
    out.ps{hh} = ps;
    ps_4states = cat(3, ps_4states, ps);
    data_4states = cat(2, data_4states, data);
    counts_4states = cat(1, counts_4states, counts);
    attempts_4states = cat(1, attempts_4states, attempts);
    %% ps
 end
 hh = 1;
    %%
[out.rhoML{hh}, out.P{hh}]=iterfun_data_projectors_tweaked_V(data_4states,2,iterations,ps_4states);
out.probs{hh} = data_4states';
out.sing_obs = sing_obs;

FF=isnan(out.rhoML{hh});
if max(max(FF))>0
    out.rhoML{hh}=zeros(4,4);
end

%Monte Carlo error analysis
samples=100; %number of noisty data sets to create and analyse
    
    
    
%     
%     meanphotonnumber=round(mean(sum(out.tomo_matrix1_counts{hh},2)),0); %estimate of equilvalent number of 'cycles' from which to determine statistical uncetainty
%     out.rhoMC{hh}=statetomMCX_projectors(cprb,2,meanphotonnumber,200,samples,ps);%(data, Nqubits, cycleIf s, Niter, N0 mc samples)
    
    out.rhoMC{hh} = MC_victors(counts_4states, attempts_4states, samples,iterations, ps_4states);
    FF=isnan(out.rhoMC{hh});
    if max(max(FF))>0
        out.rhoMC{hh}=zeros(4,4,samples);
    end
    out.rhoML_cum{hh} = out.rhoMC{hh};





 
 out.samples=samples;



%save out out
analyse_tomoresults_cumulative1
plot_tomoresults_cumulative1
dir ='v3_4state';
mkdir(dir)

if nargin < 3
    addname = [];
end
figure(3)
save([dir filesep  'out_4state_arb_Us_comb' addname '_' res],'out');

%load([dir filesep  'out_4state_comb_U_' addname '_' res])
