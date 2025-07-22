function Svn = quantumentropy(rho)
% Svn=quantumentropy(rho)
% work out the vonNeumann entropy of a density matrix
%
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

erho = nonzeros(eig(rho));
Svn = -sum(erho.*log2(erho));
