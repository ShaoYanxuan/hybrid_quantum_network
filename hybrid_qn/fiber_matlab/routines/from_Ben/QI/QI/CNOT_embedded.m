% Created by: Benjamin Lanyon
% Last modified: 10th Sept 2012

function U = arb1qubitrot_embedded(thetas,n, qubit)

%n is number of qubits in total
%qubit is target qubit

uu = arbX(thetas(1))*arbZ(thetas(2))*arbX(thetas(3));
m=qubit;

    if m-1~=0
        A=II/2;
        for jj=1:(m-2);
            A=nkron(A,II/2);
        end
    else
        A=1;
    end

    if n-m~=0
        B=II/2;
        for jj=1:(n-m-1);
            B=nkron(B,II/2);
        end
    else
        B=1;
    end

    U=nkron(A,uu,B);
    



