function y = unitaries_similar(U1,U2, rho_base)
%% returns average fidelity of 4 Bell states rotated with 1 and anothe unitries, 
%also array of fidelities for each of the Bell states rotation

res = 0;
N = length( rho_base);
for j = 1:N
   res(j) = mixedfid( U1'*rho_base{j}*U1,U2'*rho_base{j}*U2 ); 
end
y = [sum(res)/N, 0, res];