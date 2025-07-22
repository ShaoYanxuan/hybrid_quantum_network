% rhoBloch.m
% eta = elevation angle
% xi = azimuthal angle
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006


function rho = rhoBloch(xi,eta)

U = realWP(0,pi/2-xi)*realWP(pi/4,pi/2-eta);
rho = U*[1,0;0,0]*U';