function Um=MS2(theta,phi)

%MS operation on 4 qubits, with 'rotation angle' theta and 'phase' phi

SS=cos(phi)*XX+sin(phi)*YY;

Hms2=nkron(SS,SS);
Um=expm(-i*Hms2*theta);
