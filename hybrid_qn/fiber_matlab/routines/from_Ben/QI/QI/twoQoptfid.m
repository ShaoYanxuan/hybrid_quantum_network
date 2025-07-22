% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function error = twoQoptfid(Uparam,rho,sigma,onePauli)

% Uparam - parameters defining single qubit unitary
% rho - state for optimal fidelity comparison
% sigma - initial maximally entangled state

R1 = cos(Uparam(1)/2)*onePauli{4} - i*sin(Uparam(1)/2)*onePauli{1};
R2 = cos(Uparam(2)/2)*onePauli{4} - i*sin(Uparam(2)/2)*onePauli{3};
R3 = cos(Uparam(3)/2)*onePauli{4} - i*sin(Uparam(3)/2)*onePauli{1};

U = kron(onePauli{4},R3*R2*R1);

error = 1 - trace(rho*U*sigma*U');
