% Created by: Benjamin Lanyon
% Last modified: 10th Sept 2012

function U = aenbed_ACadd(n, qubit)

%n is number of qubits in total
%qubit is target qubit

uu = arbZ(pi);
m=qubit;

    if m-1~=0
        A=II;
        for jj=1:(m-2);
            A=nkron(A,II);
        end
    else
        A=1;
    end

    
    
    if n-m~=0
        B=II;
        for jj=1:(n-m-1);
            B=nkron(B,II);
        end
    else
        B=1;
    end

    U=nkron(A,uu,B);
    



