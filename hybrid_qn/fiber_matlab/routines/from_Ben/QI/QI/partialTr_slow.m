% partialTr_slow.m - calculates the partial trace for a general system
%      with n subsystems, each with dimension dim(j).
%      This works and is a fully flexible method, but a much cooler,
%      faster method is given in partialTr.m.
% elim - list of indices of subsystems to be eliminated
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function reducedrho = partialTr_slow(rho,dim,elim)

newbasis={sparse(1)};
oldbasis=newbasis;
for j=1:length(dim)
  if ~any(elim==j)
    basis = eBasis(dim(j));
    tempnewbasis=newbasis;
    tempoldbasis=oldbasis;
    for k=1:length(tempnewbasis)
      for l=1:dim(j)^2
	newbasis{k,l} = kron(tempnewbasis{k},basis{l});
	oldbasis{k,l} = kron(tempoldbasis{k},basis{l});
      end
    end
    newbasis={newbasis{:}};
    oldbasis={oldbasis{:}};
  else
    for k=1:length(oldbasis)
      oldbasis{k} = kron(oldbasis{k},speye(dim(j)));
    end
  end
end

reducedrho = sparse(0);
for k=1:length(newbasis)
  reducedrho = reducedrho + newbasis{k}*trace(oldbasis{k}'*rho);
end

reducedrho = full(reducedrho);

%for k=1:length(oldbasis)
%  test{k} = full(oldbasis{k});
%end
%
%whos