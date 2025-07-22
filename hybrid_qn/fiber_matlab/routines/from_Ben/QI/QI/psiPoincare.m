% psiPoincare.m
% eta = elevation angle
% xi = azimuthal angle
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006


function psi = psiPoincare(xi,eta)

U = realWP(xi/2+pi/4,eta)*HWP(xi/4);
psi = U*[1,0].';