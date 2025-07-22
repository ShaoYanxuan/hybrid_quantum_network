function [dis,P1,P2] = dischordU(rho)
standardpolns

[params,poop]=measurementmutualinformation(rho);

dis=(mutualinformation(rho)-poop);%/log(2);

U=arbUxzx(params(1:3));

P1=U'*Hm*U;

P2=U'*Vm*U;