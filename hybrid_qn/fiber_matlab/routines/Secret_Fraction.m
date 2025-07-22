function rs = Secret_Fraction(rho, method)
if nargin <2
    method = 's';
end
ZZ = [1 0;0 -1];
YY = [0 -1i;1i 0];
XX = [0 1;1 0];
ez = 1-abs(trace(rho*kron(ZZ,ZZ))+1)/2; %check this abs
ey = 1-abs(-1*trace(rho*kron(YY,YY))+1)/2;
ex = 1-abs(trace(rho*kron(XX,XX))+1)/2; 

if method == 's'
    standardbell
    checktrace(rho);
    hex = bin_shannon(ex);
    hez = bin_shannon(ez);
    %hey = bin_shannon(ey);
    
    rs = 1/2*(1-hex-hez);
end
if method == 'a'
    hex = bin_shannon((ex+ez)/2);
    hez = bin_shannon(ez);
    rs = 1/2*(1-2*hex);
end
if method == '6'
    rs = 1*(...
    1-ez*bin_shannon(0.5*(1+(ex-ey)/ez))-...
    (1-ez)*bin_shannon( (1-0.5*(ex+ey+ez))/(1-ez) )-...
    bin_shannon(ez));
end
if(rs < 0)
    rs = 0;
end
if abs(rs > 1)
    sprintf('Strange secret fraction:  = %f', rs)
end;
% if( bin_shannon(ex) > 0.5)
%     sprintf('ex = %f', ex)
% end
% if( bin_shannon(ey) > 0.5)
%     sprintf('ey = %f', ey)
% end
% if( bin_shannon(ez) > 0.5)
%     sprintf('ez = %f', ez)
% end