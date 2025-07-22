function SL=linearentropy(rho)
% SL=linearentropy(rho)
% work out the linear entropy of a density matrix
%
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

mixedstate = eye(size(rho))/length(rho);
minP = trace(mixedstate^2);
P = purity(rho);
SL = (1-P)/(1-minP);