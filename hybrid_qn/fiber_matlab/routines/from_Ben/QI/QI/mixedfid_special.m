% mixedfid_special.m - calculates the mixed state fidelity between two states, rho1
% and rho2.
%    - performs sqrt operations manually, so can ignore small negative eigenvalues
%
% Created by: Nathan Langford
% Last modified: 16th Jan 2007

function fidelity = mixedfid_special(rho1,rho2)

rho1pure=(abs(trace(rho1^2)-trace(rho1)^2)<100*eps);
rho2pure=(abs(trace(rho2^2)-trace(rho2)^2)<100*eps);

if (rho1pure | rho2pure)
  fidelity = trace(rho1*rho2);
else
  [rho1V,rho1D]=eig(rho1);
  [rho2V,rho2D]=eig(rho2);
  if ~all(diag(rho1D)>0)
    if (sum(diag(rho1D).*(diag(rho1D)<0)) > 1e-6)
      warning('rho1 has large negative eigenvalues');
    end
    rho1D=rho1D.*(rho1D>0);
  end
  if ~all(diag(rho2D)>0)
    if (sum(diag(rho2D).*(diag(rho2D)<0)) > 1e-6)
      warning('rho2 has large negative eigenvalues');
    end
    rho2D=rho2D.*(rho2D>0);
  end
  temp = (rho1V*sqrt(rho1D)*rho1V') * rho2 * (rho1V*sqrt(rho1D)*rho1V');
  [tempV,tempD]=eig(temp);
  if ~all(diag(tempD)>0)
    if (sum(diag(tempD).*(diag(tempD)<0)) > 1e-6)
      warning('sqrt(rho1)*rho2*sqrt(rho1) has large negative eigenvalues');
    end
    tempD=tempD.*(tempD>0);
  end
  fidelity = (trace( tempV*sqrt(tempD)*tempV' ))^2;
end
fidelity=real(fidelity);