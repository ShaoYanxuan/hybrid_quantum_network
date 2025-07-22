% rotateprocess.m - calculates the rotated process matrix from the old
%     process matrix given the old operator bases and a unitary rotation. If the basis
%     is orthonormal, then the trace of the process matrix is preserved.
%     - accepts as input: oldrho, oldbasis, U
%
% Created by: Nathan Langford
% Last modified: 15th Jan 2007

function newrho = rotateprocess(oldrho,oldbasis,U)

opdim = length(oldbasis);

for p=1:opdim
  newbasis{p}=U*oldbasis{p};
end

newrho = processchangebasis(oldrho,oldbasis,newbasis);