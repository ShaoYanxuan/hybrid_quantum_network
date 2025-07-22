% Created by: Nathan Langford
% Last modified: 8th Sept 2006

standardpolns

phipv = (kron(Hv,Hv)+kron(Vv,Vv))/sqrt(2);
phimv = (kron(Hv,Hv)-kron(Vv,Vv))/sqrt(2);
psipv = (kron(Hv,Vv)+kron(Vv,Hv))/sqrt(2);
psimv = (kron(Hv,Vv)-kron(Vv,Hv))/sqrt(2);

phipm = phipv*phipv';
phimm = phimv*phimv';
psipm = psipv*psipv';
psimm = psimv*psimv';

standardpolns_clear