% partialtranspose.m - calculates the partial transpose for dual systems
% where the subsystems A and B have dimension dim(1) and dim(2) resp.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function rhoT = partialtranspose(rho,dim,whichsub)

% check
if prod(dim)~=length(rho)
  disp('There is a problem with your partial transpose');
end

rowcol = dim(2)*ones(dim(1),1);
rho = mat2cell(rho,rowcol,rowcol);
rhoT = cell(size(rho));
switch whichsub
  case 1
    rhoT = rho.';
  case 2
    for j=1:length(rho)^2
      rhoT{j} = rho{j}.';
    end
  otherwise
    rhoT = rho.';
end
rhoT = cell2mat(rhoT);