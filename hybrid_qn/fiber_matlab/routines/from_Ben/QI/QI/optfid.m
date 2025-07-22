% Created by: Nathan Langford
% Last modified: 8th Sept 2006

phiplus = 1/2*[1 0 0 1;0 0 0 0;0 0 0 0;1 0 0 1];
onePauli = cell(4,1);
onePauli{1} = [0 1;1 0];
onePauli{2} = [0 -i;i 0];
onePauli{3} = [1 0;0 -1];
onePauli{4} = [1 0;0 1];

% find optimal fidelity with a maximally-entangled state
[UparamOpt,errorOpt] = fminsearch('twoQoptfid',[0,0,0],[],rho,phiplus,onePauli);
R1 = cos(UparamOpt(1)/2)*onePauli{4} - i*sin(UparamOpt(1)/2)*onePauli{1};
R2 = cos(UparamOpt(2)/2)*onePauli{4} - i*sin(UparamOpt(2)/2)*onePauli{3};
R3 = cos(UparamOpt(3)/2)*onePauli{4} - i*sin(UparamOpt(3)/2)*onePauli{1};
U = kron(onePauli{4},R3*R2*R1);
phiOpt = U*phiplus*U';
fidelity = trace(rho*phiOpt)

