% eBasis.m - creates a cell array containing the elementary
%     operator basis elements
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function basis = eBasis(d)

A = eye(d^2);
for j=1:d^2
  basis{j} = sparse(reshape(A(:,j),d,d));
end
