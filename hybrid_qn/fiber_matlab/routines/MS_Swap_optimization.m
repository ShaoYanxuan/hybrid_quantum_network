function y = MS_Swap_optimization(Photon2Ion1, Photon1Ion2,rhoopt, t, x, mode)
standardbell 
if nargin< 6
    mode = 'optim';
end
% phi =x(4);
% Upi =[0, 1i*exp(1i*phi);...
%       1i*exp(-1i*phi), 0];
% 
% th = 1.17*pi/2+pi/4+x(1);% set1;
% %th =1.17*pi/2+x(1);  %set2

th = x(1);
%th = 0.2513; %pi*0.43+pi*0.15;
H1 = (cos(th)*XX+sin(th)*YY);
H=nkron(II,H1, II, H1);
MS=expm(1i*H*pi/4);
standardpolns
Ut1 = [1,0;0,1]; Ut2 = Ut1;
% % if(t == 2)
%      Ut1 =arbZ(x(2)); %arbZ(1.4455); %
% % end
% % if(t == 1)
%     Ut2 =  arbZ(x(2)); %+x(1)
% % end
swapbas = nkron(II, Ut1, II,Ut2);
%swapbas = nkron(II,II, II, Upi);
rop=MS*swapbas*kron( Photon1Ion2,Photon2Ion1 )*swapbas'*MS';
%swapcorr = nkron(II,YY, II,YY);
%rop = swapcorr*rop*swapcorr';



%% project middle qubits into 00, then trace out middle qubits 
% % correct for 19th Nov
SS=nkron(II,Hm,II,Hm)*rop/trace(nkron(II,Hm,II,Hm)*rop);
rho{1}=partialTr_slow(SS,[2,2,2,2],[2,4]);

%project middle qubits into 01, then trace out middle qubits
SD=nkron(II,Hm,II,Vm)*rop/trace(nkron(II,Hm,II,Vm)*rop);
rho{2}=partialTr_slow(SD,[2,2,2,2],[2,4]);

%project middle qubits into 10, then trace out middle qubits
DS=nkron(II,Vm,II,Hm)*rop/trace(nkron(II,Vm,II,Hm)*rop);
rho{3}=partialTr_slow(DS,[2,2,2,2],[2,4]);

%project middle qubits into 11,, then trace out middle qubits
DD=nkron(II,Vm,II,Vm)*rop/trace(nkron(II,Vm,II,Vm)*rop);
rho{4}=partialTr_slow(DD,[2,2,2,2],[2,4]);




k =2;
if contains(mode, 'result')
    y = rho;
else
    y =[ mixedfid(rho{1},rhoopt{1})^k , mixedfid(rho{2},rhoopt{2})^k, mixedfid(rho{3},rhoopt{3})^k, mixedfid(rho{4},rhoopt{4})^k ];
end

 