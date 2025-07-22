function [F, rho, state, ph] = find_closest_bell(T)
F = 0;
Nphase = 50;
Nampl = 50;
for i = 1:Nphase
    phase =  (i/Nampl)*pi;
    for j = 1:Nampl
        ampl = (j/Nampl)*2*pi;
        tt = cos(ampl)*exp(1i*phase);
        rr = sin(ampl)*exp(1i);
        Unitary = exp(0*1i)*[tt, rr; -1*rr', tt'];
        phot1(:, i, j) = Unitary*[1;0];
        phot2(:, i, j) = Unitary*[0;1];
        bell1 = kron([1; 0], phot1(:, i,j));
        bell2 = kron([0; 1], phot2(:, i,j));
        BELL(:, i,j) = 1/sqrt(2)*(bell1+bell2);
        bell_rhos{i,j} = BELL(:, i,j)*BELL(:, i,j)';
        fid = fidelity4(bell_rhos{i,j}, T);
        if fid > F
            F = fid;
            rho = bell_rhos{i,j};
            ph = phase;
            state = BELL(:, i,j);
        end;
    end
end
% F = 0;
% bell1 = kron([1 0], [1 0]);
% bell2 = kron([0 1], [0 1]);
% N = 100;
% for i = 1:N
%     phase = i/N*2*pi;
%     BELL = 1/sqrt(2)*(bell1+exp(1i*phase)*bell2);
%     rho_bell = BELL'*BELL;
%     fid = fidelity4(rho_bell, T);
%     if fid > F
%         F = fid;
%         rho = rho_bell;
%         ph = phase;
%     end;
% end;
% bell1 = kron([1 0], [1 0]);
% bell2 = kron([0 1], [0 1]);
% N = 100;
% for i = 1:N
%     phase = i/N*2*pi;
%     BELL = 1/sqrt(2)*(bell1+exp(1i*phase)*bell2);
%     rho_bell = BELL'*BELL;
%     fid = fidelity4(rho_bell, T);
%     if fid > F
%          F = fid;
%         rho = rho_bell;
%         ph = phase;
%     end;
% end;
%     