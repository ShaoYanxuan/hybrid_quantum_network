%% - now analyse tomography results


%load out; 


%first each gate window
for hh=1:length(out.rhoML);

    %purity, tangle and concurrence
    out.purity(hh)=real(purity(out.rhoML{hh}));
    out.tangle(hh)=tangle(out.rhoML{hh});
    out.concurrence(hh)=sqrt(out.tangle(hh));

 
    %fidelity with Bell, search over phase
    fid=0;
    standardpolns;
    theta=-pi/2:pi/200:2*pi;
    for jj=1:length(theta);
        psi2=1/sqrt(2)*(nkron(Hv,Vv)-exp(+i*theta(jj))*nkron(Vv,Hv));
        rho2{jj}=psi2*psi2';
        fid(jj) = mixedfid(rho2{jj},out.rhoML{hh});   
    end
    [val,idx]=max(fid);
    out.fidML(hh)=val;
    out.fidphaseML(hh)=theta(idx);
    
    [val,idx]=max(fid);
    psiclosest=1/sqrt(2)*(nkron(Hv,Vv)-exp(+i*theta(idx))*nkron(Vv,Hv));
    rhoclosest=psiclosest*psiclosest';
    

   

    
    
    %find optimal rotations
standardpolns; standardbell
rhoin=out.rhoML{hh};
rhotarg=phipm;
%the function below rotates the input state to get it close to phipm;
fun=@(x)1-mixedfid(...
    rhotarg,...
nkron(...
arbUxzx([x(1) x(2) x(3)]),...
arbUxzx([x(4) x(5) x(6)])...
     )...
*rhoin*...
nkron(...
arbUxzx([x(1) x(2) x(3)]),...
arbUxzx([x(4) x(5) x(6)])...
    )'...
);


x0=[1,1,1,1,1,1];
x = fminsearch(fun,x0);

Uopt=nkron(...
arbUxzx(x(1:3)),...
arbUxzx(x(4:6))...
     );

rhoout=Uopt...
*rhoin*...
Uopt';
    
out.fidopt(hh)=mixedfid(rhotarg,rhoout);

 out.rhoML_optrot{hh}=rhoout;

out.optU{hh}= Uopt;  
    



for jj=1:out.samples;
        out.fidoptmc(hh,jj)=mixedfid(rhotarg,Uopt*out.rhoMC{hh}(:,:,jj)*Uopt');
        out.purmc(hh,jj)=purity(out.rhoMC{hh}(:,:,jj));
        out.concmc(hh,jj)=sqrt(tangle(out.rhoMC{hh}(:,:,jj)));
       
    end

    out.purSTD(hh)=std(out.purmc(hh,:));
    out.concSTD(hh)=std(out.concmc(hh,:));
    out.fidoptSTD(hh)=std(out.fidoptmc(hh,:));
    out.concM(hh)=mean(out.concmc(hh,:));
    out.fidoptM(hh)=mean(out.fidoptmc(hh,:));
    
    out.concMd(hh)=median(out.concmc(hh,:));
    out.fidoptMd(hh)=median(out.fidoptmc(hh,:));
    out.purMd(hh)=median(out.purmc(hh,:));
    
    out.fidoptSTDm(hh) = out.fidoptMd(hh) - quantile( out.fidoptmc(hh,:), 0.1587);
    out.fidoptSTDp(hh) = quantile( out.fidoptmc(hh,:), 0.8413)- out.fidoptMd(hh);
    out.concSTDm(hh) = -quantile( out.concmc(hh,:), 0.1587)+ out.concMd(hh);
    out.concSTDp(hh) =  -out.concMd(hh) + quantile( out.concmc(hh,:), 0.8413);
    out.purSTDm(hh) = -quantile( out.purmc(hh,:), 0.1587)+ out.purMd(hh);
    out.purSTDp(hh) = -out.purMd(hh) + quantile( out.purmc(hh,:), 0.8413) ;


end 





%now cumulative gates
% for hh=1:length(out.rhoML_cum);
%     %%--------------------noised bell analysis
% %     out.purity_noise(hh)=real(purity(out.rho_noised{hh}));
% %     out.tangle_noise(hh)=tangle(out.rho_noised{hh});
% %     out.concurrence_noise(hh)=sqrt(out.tangle_noise(hh));
% %     [fid, rho_opt, optU] = find_best_rotation_Ben(out.rho_noised{hh});
% %     out.fid_noised(hh) = fid;
% %     %%-----------------------------------
% 
%     %purity, tangle and concurrence
%     out.purity_cum(hh)=real(purity(out.rhoML_cum{hh}));
%     out.tangle_cum(hh)=tangle(out.rhoML_cum{hh});
%     out.concurrence_cum(hh)=sqrt(out.tangle_cum(hh));
% 
%  
%     %fidelity with Bell, search over phase
%     fid=0; idx=0; val=0
%     standardpolns;
%     theta=-pi/2:pi/20:2*pi;
%     for jj=1:length(theta);
%         psi2=1/sqrt(2)*(nkron(Hv,Vv)-exp(+i*theta(jj))*nkron(Vv,Hv));
%         rho2{jj}=psi2*psi2';
%         fid(jj) = mixedfid(rho2{jj},out.rhoML_cum{hh});   
%     end
%     [val,idx]=max(fid);
%     out.fidML_cum(hh)=val;
%     out.fidphaseML_cum(hh)=theta(idx);
%     
%     [val,idx]=max(fid);
%     psiclosest=1/sqrt(2)*(nkron(Hv,Vv)-exp(+i*theta(idx))*nkron(Vv,Hv));
%     rhoclosest=psiclosest*psiclosest';
%     
% 
%     for jj=1:out.samples;
%         out.purmc_cum(hh,jj)=purity(out.rhoMC_cum{hh}(:,:,jj));
%         out.concmc_cum(hh,jj)=sqrt(tangle(out.rhoMC_cum{hh}(:,:,jj)));
%         out.fidmc_cum(hh,jj)=mixedfid(rhoclosest,out.rhoMC_cum{hh}(:,:,jj));
% %<<<<<<< HEAD
% %         out.concmc_cum_noise(hh,jj)=sqrt(tangle(out.rhoMC_noise_cum{hh}(:,:,jj))); 
% %         out.fidmc_noise_cum(hh, jj) = mixedfid(rho_opt, out.rhoMC_noise_cum{hh}(:,:,jj));
% %         
%         
% %=======
% %>>>>>>> 7cab0c83f8d97a10bf98c4939dd5cf0c0681cc43
%     end
% 
%     out.purSTD_cum(hh)=std(out.purmc_cum(hh,:));
%     out.concSTD_cum(hh)=std(out.concmc_cum(hh,:));
%     out.fidSTD_cum(hh)=std(out.fidmc_cum(hh,:));
% %<<<<<<< HEAD
% %     out.fidmcmean_noise_cum(hh) = mean(out.fidmc_noise_cum(hh,:));
% %     out.fidmcSTD_noise_cum(hh) = std(out.fidmc_noise_cum(hh,:));
% %=======
% 
% %>>>>>>> 7cab0c83f8d97a10bf98c4939dd5cf0c0681cc43
% 
% 
%  
%     %find optimal rotations
% standardpolns; standardbell
% rhoin=out.rhoML_cum{hh};
% rhotarg=phipm;
% %the function below rotates the input state to get it close to phipm;
% fun=@(x)1-mixedfid(...
%     rhotarg,...
% nkron(...
% arbUxzx([x(1) x(2) x(3)]),...
% arbUxzx([x(4) x(5) x(6)])...
%      )...
% *rhoin*...
% nkron(...
% arbUxzx([x(1) x(2) x(3)]),...
% arbUxzx([x(4) x(5) x(6)])...
%     )'...
% );
% 
% 
% x0=[1,1,1,1,1,1];
% x = fminsearch(fun,x0);
% 
% Uopt=nkron(...
% arbUxzx(x(1:3)),...
% arbUxzx(x(4:6))...
%      );
% 
% rhoout=Uopt...
% *rhoin*...
% Uopt';
%     
% out.fidopt_cum(hh)=mixedfid(rhotarg,rhoout);
% 
% out.rhoML_optrot_cum{hh}=rhoout;
% 
% out.optU_cum{hh}= Uopt;  
%     
% 
% 
% 
% for jj=1:out.samples;
%         out.fidoptmc_cum(hh,jj)=mixedfid(rhotarg,Uopt*out.rhoMC_cum{hh}(:,:,jj)*Uopt');
% end
% 
% out.fidoptSTD_cum(hh)=std(out.fidoptmc_cum(hh,:));
% 





%end


%save out

%load out 
 

