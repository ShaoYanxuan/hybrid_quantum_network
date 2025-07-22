P = 1/(2*60); % per minute, corresponds to 1 every 2 hours 
t = [1:60*48];
Psurv = (1-P).^t; %survive every previous minute
figure(); plot(t/60, Psurv)  %plot in hours
hold on
xlim([0, 30])
xlabel('Time, hours')
ylabel('Probability to survive')
grid minor
title('Probability of an ion to survive next X hours given constant probability to loose an ion per hour of P')
legend('P = 1/5', 'P = 1/2')
% tt = 60;
% P_check =  Psurv([60:end])/Psurv(60);
% plot (t(1:length(P_check))/60,1-P_check)

K = 1:190;
Pb = 2.5e-3;
Pa = Pb;

%photon A first
Sb = sum(  Pb*(1-Pb).^K.*K )
Pxa = Pa*Sb/max(K);

%photon B first
Sa = sum(  Pa*(1-Pa).^K.*K )
Pxb = Pb*Sa/max(K);

P_total = Pxa+Pxb  %(~= , shouldn't add probabilities, but they are small )
