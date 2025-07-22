function Uac=carrier(theta)

%AC stark shift on 1 qubit with length theta
%for detuned less (red) 
Uac=expm(-i*theta/2*ZZ);