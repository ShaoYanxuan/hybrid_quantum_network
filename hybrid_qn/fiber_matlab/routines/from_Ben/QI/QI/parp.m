function error = alrk(Uparams,rho)

standardpolns;

Um = arbUxzx(Uparams(1:3));
ph=Hm*Um;
pv=Vm*Um;

P1=kron(ph,II);%applies the projectors to 1st subsystem.
P2=kron(pv,II);

rhop1=P1*rho*P1';
rhop2=P2*rho*P2';

prob1=trace(rhop1);
prob2=trace(rhop2);

%prob1=trace(rho*P1);
%prob2=trace(rho*P2);

rhop1=rhop1/prob1;
rhop2=rhop2/prob2;

rhos1=partialTr_slow(rhop1,[2,2],1);
rhos2=partialTr_slow(rhop2,[2,2],1);


HtildaSM=prob1*quantumentropy(rhos1)+prob2*quantumentropy(rhos2);

error=HtildaSM;

