function res = gauss_decoh(rho, T, tau, P0, Fid0 )
standardbell;
standardpolns;
if nargin < 4
    P0 = 1;
    Fid0 = 1;
end
if length(rho) == 2
    QB = 1;
end
if length(rho) == 4
    QB = II;
end
UZ = kron(QB, ZZ);
UX = kron(QB, XX);
UY = kron(QB, XX);
rho0_flip = expm(-1i*UZ*pi/2)*rho*expm(1i*UZ*pi/2);
N = 100;
Th_max = 5;
fact = Th_max*2/N;
thetas = ((1:N)-N/2)*fact;
sig = T/tau;
sig2 = T/(tau/P0);
integ = 0;
integ2 = 0;
pt = zeros(N,1);
pt2 = pt;
for i = 1:N
    thet = thetas(i);
    p = 1/sqrt(2*pi*sig)*exp(-thet^2/2/sig^2);
    %p2= 1/sqrt(2*pi*sig2)*exp(-thet^2/2/sig2^2);
    pt(i) = p;
    integ= integ+ p*(P0*expm(-1i*UZ*thet)*rho*expm(1i*UZ*thet)+(1-P0)*0.5*expm(-1i*UX*thet)*rho*expm(1i*UX*thet)+0.5*(1-P0)*expm(-1i*UY*thet)*rho*expm(1i*UY*thet));
%     integ= integ+ p*expm(-1i*UZ*thet)*rho*expm(1i*UZ*thet);
%     integ2 = integ2+p2*expm(-1i*UX*thet)*rho*expm(1i*UX*thet)-p2*expm(-1i*UZ*thet)*rho*expm(1i*UZ*thet);
    %pt2(i) = p2;
end
integ = integ/sum(pt);  %(thetas[1]-thetas[0])
% integ = (integ/sum(pt)+integ2/sum(pt2));
if abs((1-trace(integ))>0.01)
    print('warning')
end
rhoout = Fid0*integ+(1-Fid0)*rho0_flip;
res = rhoout; 
%meanX = (-1*np.trace(np.dot(XX, rhoout))) #mean sigma X measurement
%out.append(np.abs(meanX)	)
