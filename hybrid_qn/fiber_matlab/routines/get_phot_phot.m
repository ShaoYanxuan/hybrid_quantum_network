function probs = get_phot_phot(PhotA, PhotB, projA, projB)
%copied function from ions. Notations have to be swapped.
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
SS=nkron(II,sigmaZeig{projA},II,sigmaZeig{projB})*ro/trace(nkron(II,sigmaZeig{projA},II,sigmaZeig{projB})*ro);
rho=partialTr_slow(SS,[2,2,2,2],[2,4]);
ion_state_probs = diag(rho);
cumprob = cumsum(ion_state_probs);
% x = rand();
% i = find( x<=cumprob);
% ion_state(i(1)) = 1;
probs = abs(ion_state_probs)'; % actually this are photon states probs now