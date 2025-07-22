% processkron.m
%
% Created by: Nathan Langford
% Last modified: 15th Jan 2007

function newrho = processkron(oldrho1,oldrho2,oldbasis1,oldbasis2,newbasis)

opdim1 = length(oldbasis1);
opdim2 = length(oldbasis2);
opdim = opdim1*opdim2;

index1 = reshape(repmat([1:opdim1],opdim2,1),opdim,1);
index2 = repmat([1:opdim2].',opdim1,1);

rho=kron(oldrho1,oldrho2);
for p=1:opdim
  basis{p}=kron(oldbasis1{index1(p)},oldbasis2{index2(p)});
end

newrho = processchangebasis(rho,basis,newbasis);