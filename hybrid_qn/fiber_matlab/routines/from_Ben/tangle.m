function tau=tangle(rho)
% tau=tangle(rho)
% work out the tangle of a two x two density matrix
%
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

Y=[0 -i;i 0];
YY=kron(Y,Y);

rhoTilde = YY*rho.'*YY;
evalues = sqrt(eig(rho*rhoTilde));
evalues = sort(evalues);
diff = real(evalues(4)-evalues(3)-evalues(2)-evalues(1));
concurrence = max(0,diff);
tau=concurrence^2;
