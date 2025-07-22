function res = checktrace(rho)
res = trace(rho);
if(abs(res-1) >1e-6)
    sprintf('Trace = %f', res)
end;
for i = 1:length(rho)
    if real(rho(i,i))<0 || abs(imag(rho(i,i)))>1e-7
        sprintf('Oups,negative element %d, %f: \n rho ', i, rho(i,i))
        rho
        break
    end
end