function [a,b,c,rhoout]=CM(rho)


paus=[{II},{XX},{YY},{ZZ}];


    for hh=1:length(paus);
        for mm=1:length(paus);
        rhoout(hh,mm)=trace(kron(paus{hh},paus{mm})*rho);
        end
    end

    [a,b,c]=svd(rhoout); 


