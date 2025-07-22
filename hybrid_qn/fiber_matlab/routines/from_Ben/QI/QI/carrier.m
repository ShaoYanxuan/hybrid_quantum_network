function Uc=carrier(theta,phi)

%carrier pulse on 1 qubit with length theta and phase phi

sigma=cos(phi)*XX+sin(phi)*YY;
Uc=expm(-i*theta/2*sigma);