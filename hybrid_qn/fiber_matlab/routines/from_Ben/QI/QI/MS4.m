function Um=MS4(theta,phi)

%MS operation on 4 qubits, with 'rotation angle' theta and 'phase' phi

SS=cos(phi)*XX+sin(phi)*YY;

Hms4=nkron(SS,SS,II,II)+nkron(SS,II,SS,II)+nkron(SS,II,II,SS)+...
    nkron(II,SS,SS,II)+nkron(II,SS,II,SS)+...
    nkron(II,II,SS,SS);

Um=expm(-i*Hms4*theta);
