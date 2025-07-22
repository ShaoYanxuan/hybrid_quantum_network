function [rhoin1, rhoin2, U]  = cost_opt_U8_body(x)
%rhoin - 4 state produced by swapping with unitary correction on one ion

H1 = [0 1;1 0];%+sin(th)*YY;
H=nkron(II,H1, II, H1);
%T1=nkron(II,arbUxzx([x(7) x(8) x(9)]));
T1=nkron(II,arbZ([x(7)]));
% T1=nkron(II,II);
MS=expm(-1i*H*pi/4);
Hv = [1 0].';
Vv = [0 1].';
Hm = Hv*Hv';
Vm = Vv*Vv';
phipv = (kron(Hv,Hv)+kron(Vv,Vv))/sqrt(2);
phipm = phipv*phipv';
rop=MS*kron( T1*phipm*T1' ,phipm)*MS';
SS=nkron(II,Hm,II,Hm)*rop/trace(nkron(II,Hm,II,Hm)*rop);
rho{1}=partialTr_slow(SS,[2,2,2,2],[2,4]);
SD=nkron(II,Hm,II,Vm)*rop/trace(nkron(II,Hm,II,Vm)*rop);
rho{2}=partialTr_slow(SD,[2,2,2,2],[2,4]);
DS=nkron(II,Vm,II,Hm)*rop/trace(nkron(II,Vm,II,Hm)*rop);
rho{3}=partialTr_slow(DS,[2,2,2,2],[2,4]);
DD=nkron(II,Vm,II,Vm)*rop/trace(nkron(II,Vm,II,Vm)*rop);
rho{4}=partialTr_slow(DD,[2,2,2,2],[2,4]);
rhoin1 = rho;

%T2=nkron(II,arbUxzx([x(7) x(8) x(9)]+[x(10) x(11) x(12)]));
T2=nkron(II,arbZ(x(8)+x(7)));

rop=MS*kron(phipm ,T2*phipm*T2' )*MS';
SS=nkron(II,Hm,II,Hm)*rop/trace(nkron(II,Hm,II,Hm)*rop);
rho{1}=partialTr_slow(SS,[2,2,2,2],[2,4]);
SD=nkron(II,Hm,II,Vm)*rop/trace(nkron(II,Hm,II,Vm)*rop);
rho{2}=partialTr_slow(SD,[2,2,2,2],[2,4]);
DS=nkron(II,Vm,II,Hm)*rop/trace(nkron(II,Vm,II,Hm)*rop);
rho{3}=partialTr_slow(DS,[2,2,2,2],[2,4]);
DD=nkron(II,Vm,II,Vm)*rop/trace(nkron(II,Vm,II,Vm)*rop);
rho{4}=partialTr_slow(DD,[2,2,2,2],[2,4]);
rhoin2 = rho;

k = 2;
U = nkron(arbUxzx([x(1) x(2) x(3)]),arbUxzx([x(4) x(5) x(6)]));
Up = U';