% mixedfid.m - calculates the mixed state fidelity between two states, rho1
% and rho2.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function fidelity = mixedfid(rho1,rho2)

rho1pure=(abs(trace(rho1^2)-trace(rho1)^2)<100*eps);
rho2pure=(abs(trace(rho2^2)-trace(rho2)^2)<100*eps);

if (rho1pure | rho2pure)
  fidelity = trace(rho1*rho2);
else
  fidelity = (trace(sqrtm(sqrtm(rho1)*rho2*sqrtm(rho1))))^2;
end
fidelity=real(fidelity);