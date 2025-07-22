function y = gauss_decoh_simple(rho ,x, a)
F = exp(-(x/a).^2); %
standardpolns
U = kron(II, ZZ);
y = F*rho+(1-F)*(U*rho*U'+rho)/2;