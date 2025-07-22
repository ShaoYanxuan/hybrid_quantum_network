% mixedfid.m - calculates the mixed state fidelity between two states, rho1
% and rho2.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function distance = tracedistance(rho1,rho2)

distance = trace(sqrtm( (rho1-rho2)'*(rho1-rho2) ))/2;