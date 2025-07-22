function rhoout = Decohere_1q(rho, K, T)
F= exp(-K/T); % decoherence function
Al = (F-1/4)/(1-1/4);
U0 = kron(II, II);
U1 = kron(II, XX);
U2 = kron(II, YY);
U3 = kron(II, ZZ);

rhoout = F*U0*rho*U0' + (1-F)/3*(U1*rho*U1' + U2*rho*U2' + U3*rho*U3');
checktrace(rhoout);