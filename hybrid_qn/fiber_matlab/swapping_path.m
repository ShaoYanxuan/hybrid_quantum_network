function swapped_F = swapping_path(path_fidelity, Fswap)

standardbell;standardpolns;

rho_ii = path_fidelity(1)*phipm+(1-path_fidelity(1))*phimm;
for i=2:length(path_fidelity)
    F = path_fidelity(i);
    rho_ii1 = F*phipm+(1-F)*phimm;
    rho_ii = estimate_swapped_fidelity(rho_ii,rho_ii1,Fswap, 'depolarize');
end
U = find_opt_U(rho_ii, phipm);
swapped_F = mixedfid(U*rho_ii*U', phipm);