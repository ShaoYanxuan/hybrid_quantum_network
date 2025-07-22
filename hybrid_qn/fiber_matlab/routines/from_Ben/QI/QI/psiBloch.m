% psiBloch.m
% eta = elevation angle
% xi = azimuthal angle
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006


function psi = psiBloch(xi,eta)

U = realWP(0,pi/2-xi)*realWP(pi/4,pi/2-eta);
psi = U*[1,0].';