%clear;
standardpolns;
standardbell;
%rho=psipm;
clear out;
ops={II,XX,YY,ZZ};

for j=1:4
for i=1:4;
out(i,j)=0.25*trace(kron(ops{i},ops{j})*rho);
end
end

out=reshape(out,[16,1]);
out=real(out);

bar(out)

