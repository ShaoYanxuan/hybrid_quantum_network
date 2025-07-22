% negativity.m - calculates the negativity for a bipartite system
% of arbitrary dimension
%
% Created by: Nathan Langford
% Last modified: 26th Feb 2007

function N = negativity(rho,varargin)

if nargin>1
  dims=varargin{1};
else
  dim=sqrt(length(rho));
  dims=[dim dim];
end
rhoT = partialtranspose(rho,dims,1);
evalues = eig(rhoT);
negevalues = evalues.*(evalues<0);
N = 2*sum(-negevalues);
