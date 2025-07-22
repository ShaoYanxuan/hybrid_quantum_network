% partialTr.m - calculates the partial trace for dual systems
% where the subsystems A and B are the same size.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function reducedrho = partialTr_simple(rho,whichsub)

dim = length(rho);
subdim = sqrt(dim);

if whichsub==2
  swapblocks=cell(subdim);
  [swapblocks{:}] = deal(zeros(subdim));
  for p=1:subdim
    for q=1:subdim
      swapblocks{p,q}(q,p)=1;
    end
  end
  swap=cell2mat(swapblocks);
  rho = swap*rho*swap;
end

rhobreaks = subdim*ones(1,subdim);
rhocell = mat2cell(rho,rhobreaks,rhobreaks);
reducedrho = zeros(subdim);
for p = 1:subdim
  reducedrho = reducedrho+rhocell{p,p};
end
