% rhoPoincare.m
% eta = elevation angle
% xi = azimuthal angle
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006


function rho = rhoPoincare(xi,eta)

U = realWP(xi/2+pi/4,eta)*HWP(xi/4);
rho = U*[1,0;0,0]*U';