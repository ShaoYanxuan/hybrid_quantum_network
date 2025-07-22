standardbell
standardpolns
phi = sym('f')
sigm = cos(phi)*XX+sin(phi)*YY;
sig = kron(sigm,sigm)
U = expm(-i*pi/4*sig);
s = U*[1;0;0;0];
simplify(s)