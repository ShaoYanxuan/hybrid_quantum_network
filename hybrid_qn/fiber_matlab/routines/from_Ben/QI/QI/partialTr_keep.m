% partialTr.m - calculates the partial trace for a general system
%      with n subsystems, each with dimension dim(j).
%      Uses a cool permutation trick.
% elimsys - list of indices of subsystems to be eliminated
% keepsys - list of indices of subsystems to be kept
%
% COMMENTS
% This is the same method used in partialTr_fast.m, but implemented as a
% "stand-alone" function, i.e., rather than calling partialTr_bp.m, it implements
% the relevant code directly.
% ALGORITHM
% Rearranges subspaces so that all the systems to be discarded are first,
% and then implements the quick bipartite partial trace from partialTr_bp.m.
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function reducedrho = partialTr(rho,dim,keepsys)

%rho=rho1;
%dim=2*ones(m,1)';
%[ceil(m/2):m];


elimsys=[1:length(dim)];
elimsys(keepsys)=0;
elimsys=nonzeros(elimsys).';

% work out which systems to keep
keepsys=[1:length(dim)];
keepsys(elimsys)=0;
keepsys=nonzeros(keepsys).';

% rearrange density matrix so all discarded systems are first (in kronecker tensor product sense)
rho = permuterho(rho,dim,[elimsys keepsys]);

% implement simple partial trace trick
coarsedim = [prod(dim(elimsys)) prod(dim(keepsys))];
rhobreaks = coarsedim(2)*ones(1,coarsedim(1));
rho = mat2cell(rho,rhobreaks,rhobreaks);

reducedrho = sum(cell2mat(reshape(diag(rho),1,1,coarsedim(1))),3);
