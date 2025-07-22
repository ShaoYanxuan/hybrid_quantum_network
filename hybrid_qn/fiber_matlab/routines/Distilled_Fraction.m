function rs = Distilled_Fraction(rho, method)
if nargin <2
    method = 0;
end
%Both methods give the same result.
standardbell;
    if method == 1
        F = mixedfid(phimm, rho);
        if(F >0.5)
            rs = bin_shannon(1/2+sqrt(F*(1-F)));
        else
            rs = 0;
        end
    end
    if method == 0
       
        T= tangle(rho); % = C^2
        rs = bin_shannon((1+ sqrt(1-T))/2  );
        
    end
    
    if method == 4 % calculate secret key rate instead
        rs = Secret_Fraction(rho, 's'); % BB84, single SKR
    end
    if method == 6 % calculate secret key rate instead
        rs = Secret_Fraction(rho, '6'); % 6-state
    end
    
%     
%     if abs(rs > 0.5)
%         sprintf('Strange secret fraction:  = %f', rs)
%     end;