% partialTr_bp.m - calculates the partial trace for bipartite systems
% where the subsystems A and B can be different sizes.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function reducedrho = partialTr_bp(rho,whichsub,varargin)

if (nargin>2)
  dim=varargin{1};
else
  % check rho is "evenly" bipartite
  dim = sqrt(length(rho));
  if (round(dim) ~= dim)
    error('rho is not the appropriate size');
  end
  dim = dim*[1 1];
end

rhobreaks = dim(2)*ones(1,dim(1));
rhocell = mat2cell(rho,rhobreaks,rhobreaks);

switch whichsub
  case 1
    reducedrho = sum(cell2mat(reshape(diag(rhocell),1,1,dim(1))),3);
  case 2
    for p = 1:dim(1)
      for q = 1:dim(1)
	reducedrho(p,q) = trace(rhocell{p,q});
      end
    end
end
