function dephasing_F = dephasing(F0,t,tau_de)

standardbell;standardpolns;


UZ = nkron(ZZ,II);

rho_ii0 = F0*phipm+(1-F0)*phimm;
p = (1-exp(-t^2/tau_de^2))/2; 
rho_ii = p*rho_ii0 + (1-p)*UZ*rho_ii0*UZ'; 
U = find_opt_U(rho_ii, phipm);
dephasing_F = mixedfid(U*rho_ii*U', phipm);


% rho_ii0 = estimate_swapped_fidelity(rho_ii0,rho_ii0,Fswap, 'depolarize');
% U = find_opt_U(rho_ii0,phipm);
% F0 = mixedfid(U*rho_ii0*U', phipm);
% 
% rho{i} = Fid*rho{i}+(1-Fid)*UZ*rho{i}*UZ';