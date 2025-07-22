% Created by: Nathan Langford
% Last modified: 8th Sept 2006

dim1Q=4;

pauli1Q = cell(dim1Q,1);
pauli1Q{1} = [0 1;1 0];
pauli1Q{2} = [0 -i;i 0];
pauli1Q{3} = [1 0;0 -1];
pauli1Q{4} = [1 0;0 1];
for p=1:dim1Q
  pauli1Qn{p} = pauli1Q{p}/sqrt(trace(pauli1Q{p}'*pauli1Q{p}));
end

pauli2Q = cell(dim1Q,dim1Q);
pauli2Qn = cell(dim1Q,dim1Q);
for p=1:dim1Q
  for q=1:dim1Q
    pauli2Q{p,q} = kron(pauli1Q{p},pauli1Q{q});
    pauli2Qn{p,q} = kron(pauli1Qn{p},pauli1Qn{q});
  end
end
pauli2Q = reshape(pauli2Q.',dim1Q^2,1);
pauli2Qn = reshape(pauli2Qn.',dim1Q^2,1);

%tempdim=sqrt(dim1Q);
%elem1Q = cell(tempdim,tempdim);
%[elem1Q{:}] = deal(zeros(tempdim));
%for p=1:tempdim
%  for q=1:tempdim
%    elem1Q{p,q}(p,q) = 1;
%  end
%end
%elem1Q = reshape(elem1Q,dim1Q,1);
%clear tempdim

elem2Q = cell(dim1Q,dim1Q);
[elem2Q{:}] = deal(zeros(dim1Q));
for p=1:dim1Q
  for q=1:dim1Q
    elem2Q{p,q}(p,q) = 1;
  end
end
elem2Q = reshape(elem2Q,dim1Q^2,1);

for p=1:dim1Q^2
  for q=1:dim1Q^2
    elem2pauli(p,q) = trace(pauli2Qn{p}'*elem2Q{q});
  end
end

clear p q