function Ug=GlobCar(theta,phi,n)

%symmetric carrier pulse on n qubits, with length theta and phase phi

sigma=cos(phi)*XX+sin(phi)*YY;
Uc=expm(-i*theta/2*sigma);


Ut=Uc;
if (n-1)~=0
    for ii=1:(n-1);
        Ut=kron(Ut,Uc);
    end
end

Ug=Ut;