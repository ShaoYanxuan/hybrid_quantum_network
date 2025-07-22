% applyprocess.m - calculates the output state for a specified input state
%     into an arbitrary process.
%     - accepts as input: chi, chibasis, rhoin
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function rhoout = applyprocess(chi,rhoin,chibasis)

rhoout = zeros(size(rhoin));
for p=1:length(chibasis)
  for q=1:length(chibasis)
    rhoout = rhoout + chi(p,q)*chibasis{p}*rhoin*chibasis{q}';
  end
end
