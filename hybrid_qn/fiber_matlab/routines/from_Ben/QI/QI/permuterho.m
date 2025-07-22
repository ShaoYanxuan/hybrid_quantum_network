function newrho = permuterho(rho,dim,neworder)
% permuterho.m : permutes the subspaces of a density matrix to describe
%     what happens when the subsystems of an overall system are likewise permuted
% rho: density matrix of overall system in the form nkron(H(1),...,H(end))
% H(j): Hilbert space of the jth subsystem
% dim(j): dimension of jth subsystem
% neworder: a reordering of [1:length(dim)] which describes the new order of
%     the subsystems
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

% check dim and neworder are row vectors
if sum(size(dim)==1) > 0
  if size(dim,1) ~= 1
    dim=dim.';
  end
else
  error('dim is not a vector');
end
if sum(size(neworder)==1) > 0
  if size(neworder,1) ~= 1
    neworder=neworder.';
  end
else
  error('neworder is not a vector');
end
flipdim=fliplr(dim);
flipneworder=fliplr(neworder);
nsystems=length(dim);
reorder=1+[nsystems-flipneworder,2*nsystems-flipneworder];

rho = reshape(rho,[flipdim flipdim]);
newrho = permute(rho,reorder);
newrho = reshape(newrho,prod(dim)*[1 1]);