clear all
OUTC = 1;

standardbell;standardpolns;
F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
V = 2*Fphoton-1;
F0 = 1/2*(1+V*(1-2*F0)^2); % == (F0^2+(1-F0)^2)*(1+V)/2+2*F0*(1-F0)*(1-V)/2

fidelity_rep_num = []; 
for i=1:25
    fidelity_rep_num(end+1) = swapping_path(F0*ones(i+1), Fswap); 
end

writematrix(fidelity_rep_num, './figure2/fidelity_num_repeaters.csv')