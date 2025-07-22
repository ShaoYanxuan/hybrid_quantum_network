function y = fun_fid_gauss_fit(x, a)
 rho = [0.5139 - 0.0000i   0.0335 - 0.0094i   0.0173 + 0.0150i   0.4706 - 0.0000i;
   0.0335 + 0.0094i   0.0053 + 0.0000i  -0.0046 + 0.0069i   0.0229 + 0.0133i;
   0.0173 - 0.0150i  -0.0046 - 0.0069i   0.0218 + 0.0000i   0.0391 - 0.0077i;
   0.4706 + 0.0000i   0.0229 - 0.0133i   0.0391 + 0.0077i   0.4590 - 0.0000i];
 phipm = [ 0.5000         0         0    0.5000;
         0         0         0         0;
         0         0         0         0;
    0.5000         0         0    0.5000];

F0 = mixedfid(rho, phipm);
y = zeros(length(x),1);
 for i = 1:length(x)
        y(i) =  mixedfid(gauss_decoh_simple(rho ,x(i), a),   phipm);
 end
% A = 1-2*(1-F0);
% gauss = A*exp(-0.5*(x/a).^2);
% y = gauss/2+0.5; % 1 qubit gauss decoher
end