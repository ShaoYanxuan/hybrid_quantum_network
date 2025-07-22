% quditswap.m - calculates the SWAP operation matrix for a dual
%      system where subsystems A and B are the same dimension, dim.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function SWAP = quditswap(dim)

swapblocks=cell(dim);
[swapblocks{:}] = deal(zeros(dim));
for p=1:dim
  for q=1:dim
    swapblocks{p,q}(q,p)=1;
  end
end
SWAP=cell2mat(swapblocks);