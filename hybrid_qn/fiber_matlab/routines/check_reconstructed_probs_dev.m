K = 2 % ~true when 2 states are musrged
%K = 1 should be normally

A2 = out.P{1}/(sum(out.P{1}));
A2n = A2*sum(sum(K*out.state{1}))
A1 = out.probs{1}/(sum(out.P{1}));
A1n = A1*sum(sum(K*out.state{1}));
round([A1n, A2n, 100*(A1n-A2n)./sqrt(A2n)])

mu = 0;
sigma = 1;
x = [-400:8:400]/100;
Ampl = length(A1n)*(x(2)-x(1));
F = Ampl/(sigma*sqrt(2*pi))*exp(-1/2*((x-mu)/sigma).^2);
figure; histogram(real((A1n-A2n)./sqrt(A2n)), X)
hold on
plot(x, F, 'LineWidth', 2, 'DisplayName', ['Gaussian with \mu = ' num2str(mu) , ' \sigma = ' num2str(sigma)])
sigma = std(real((A1n-A2n)./sqrt(A2n)))
F = Ampl/(sigma*sqrt(2*pi))*exp(-1/2*((x-mu)/sigma).^2);
plot(x, F, 'LineWidth', 2, 'DisplayName', ['Gaussian with \mu = ' num2str(mu) , ' \sigma = ' num2str(sigma)])
legend('show')
title('Repeater data all outcomes')
xlabel('How far is the outcome from predicted: (N_{exp}-N_{reconstr})/ sqrt(N_{reconstr}))')
ylabel('# of occurances')