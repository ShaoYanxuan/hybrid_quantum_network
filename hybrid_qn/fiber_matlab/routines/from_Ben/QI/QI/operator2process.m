% operator2process.m - calculates the process matrix for single
%     operator in a particular operator basis
%     - accepts as input: A, chibasis
%
% Created by: Nathan Langford
% Last modified: 17th Jan 2007

function chi = operator2process(A,chibasis)

for m=1:length(chibasis)
  for n=1:length(chibasis)
    chi(m,n)=trace(chibasis{m}'*A)*trace(chibasis{n}'*A)';
  end
end
