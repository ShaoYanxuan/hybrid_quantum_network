function [ion_state,ro] = get_ion_ion(PhotA, PhotB, projA, projB)
ion_state = [0 0 0 0];
standardbell;
standardpolns;
sigmaZeig{1} = Hm;
sigmaZeig{2} = Vm;
H1 = XX;
H=nkron(II,H1, II, H1);
MS=expm(1i*H*pi/4);
ro=MS*kron( PhotA, PhotB )*MS';
%projecting onto photon state
SS=nkron(sigmaZeig{projA},II,sigmaZeig{projB},II)*ro/trace(nkron(sigmaZeig{projA},II,sigmaZeig{projB},II)*ro);
rho=partialTr_slow(SS,[2,2,2,2],[1,3]);
ion_state_probs = diag(rho);
cumprob = cumsum(ion_state_probs);
x = rand();
i = find( x<=cumprob);
ion_state(i(1)) = 1;
