function uf=unitaryfid(U,A)
% P=purity(rho)
% work out the purity of a density matrix
%
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

uf = abs(trace(U'*A))^2 / (trace(A'*A)*length(U));