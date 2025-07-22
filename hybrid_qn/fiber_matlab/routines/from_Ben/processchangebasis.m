% processchangebasis.m - calculates the new process matrix from the old
%     process matrix given the old and new operator bases. If the bases
%     are orthonormal, then the trace of the process matrix is preserved.
%     - accepts as input: oldrho, oldbasis, newbasis
%
% Created by: Nathan Langford
% Last modified: 15th Jan 2007

function newrho = processchangebasis(oldrho,oldbasis,newbasis)

opdim = length(oldbasis);

for p=1:opdim
  for q=1:opdim
    beta(p,q) = trace(newbasis{p}'*oldbasis{q});
  end
end

newrho = beta*oldrho*beta';
