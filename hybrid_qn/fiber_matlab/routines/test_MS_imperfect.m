standardbell
standardpolns
Fid = 0.8
th = 0;

H1 = cos(th)*XX+sin(th)*YY;

H=nkron(H1,  H1);
MS=expm(-1i*H*pi/4); 
rhoout = MS*kron(Hm, Hm)*MS';
%dephasing
rhooutd = Fid*rhoout+(1-Fid)*kron(II,ZZ)*phipm*kron(II,ZZ);
%depolarization
rhooutd = Fid*rhoout +(1-Fid)/3*(kron(II,YY)*rhoout*kron(II,YY)+...
                                kron(II,XX)*rhoout*kron(II,XX)+...
                                kron(II,ZZ)*rhoout*kron(II,ZZ));
rhoout = rhooutd;
checktrace(rhoout);
pop1 = trace(rhoout*kron(Hm,Vm))+trace(rhoout*kron(Vm,Hm));
N = 50;
for i = 1:N
    ph = i*2*pi/N;
    phase(i)= ph;
    pihal = kron(pihalfpulse(ph),pihalfpulse(ph));
    rhoout_pihlaf = pihal*rhoout*pihal';
    p02(i) = real(rhoout_pihlaf(1,1)+rhoout_pihlaf(4,4));
    p11(i) = real(rhoout_pihlaf(2,2)+rhoout_pihlaf(3,3));
    
end
figure()
hold on
plot(phase, (p02), '--', 'DisplayName', 'P0,P2');
plot(phase, (p11), '--', 'DisplayName', 'P1');
plot(phase, p11-p02, 'DisplayName', 'Parity');
plot(phase, phase./phase*pop1, 'DisplayName', 'pop P1');
legend('show')    
(max(p11-p02)-min(p11-p02)+pop1)/2