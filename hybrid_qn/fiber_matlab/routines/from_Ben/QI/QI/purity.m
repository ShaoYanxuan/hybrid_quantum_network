function P=purity(rho)
% P=purity(rho)
% work out the purity of a density matrix
%
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

P = trace(rho^2);