% sentanglement.m - calculates the entropy (S) of entanglement
% of an arbitrary system
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function E = sentanglement(rho,vargin)

if (nargin>1)
  dim=varargin{1};
  rrho=partialTr_bp(rho,2,dim);
else % assume evenly bipartite
  rrho=partialTr_bp(rho,2);
end

reigs=nonzeros(eig(rrho));
E=-sum(reigs.*log(reigs))/log(2);