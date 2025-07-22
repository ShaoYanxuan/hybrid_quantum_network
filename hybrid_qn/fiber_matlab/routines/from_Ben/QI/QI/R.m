% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function out=R(S,theta)

out = cos(theta/2)*eye(size(S))+i*sin(theta/2)*S;


