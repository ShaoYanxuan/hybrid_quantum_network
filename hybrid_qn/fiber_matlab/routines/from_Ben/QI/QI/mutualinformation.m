function poo = mutualinformation(rho)

S=partialTr_slow(rho,[2,2],1);%last argument is system to be ellimiated. 
M=partialTr_slow(rho,[2,2],2);

HS=quantumentropy(S);
HM=quantumentropy(M);
HSM=quantumentropy(rho);

poo= HS+HM-HSM;



