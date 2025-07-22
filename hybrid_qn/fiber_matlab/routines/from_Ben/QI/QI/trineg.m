function TN=trineg(Rho)


     rhoAB = partialTr_slow(Rho,[2 2 2],3);
     rhoAC = partialTr_slow(Rho,[2 2 2],2);
     rhoBC = partialTr_slow(Rho,[2 2 2],2);
     
trineg = (negativity(rhoAB)*negativity(rhoAC)*negativity(rhoBC))^(1/3);
     
TN=trineg