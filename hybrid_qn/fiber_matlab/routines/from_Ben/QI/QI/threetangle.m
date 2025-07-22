function TT=threetangle(Rho)


     rhoAB = partialTr_slow(Rho,[2 2 2],3);
     rhoAC = partialTr_slow(Rho,[2 2 2],2);
     rhoA = partialTr_slow(Rho,[2 2 2],[2 3]);
     
threetangle = 4*det(rhoA)-tangle(rhoAB)-tangle(rhoAC);
     
TT=threetangle.*(abs(threetangle)>1e-6);