% partialTr.m - calculates the partial trace for a general system
%      with n subsystems, each with dimension dim(j).
%      Uses a cool permutation trick.
% elimsys - list of indices of subsystems to be eliminated
% keepsys - list of indices of subsystems to be kept
%
% Created by: Nathan Langford
% Last modified: 8th Sept 2006

function reducedrho = partialTr_fast(rho,dim,elimsys)

% final update: this IS the funky (faster) method, using the
%   permuterho.m function to rearrange subspaces so that all the systems
%   to be discarded are first, and then the generalised form of partialTr_bp.m
%   that allows the systems to be different sizes.

keepsys=[1:length(dim)];
keepsys(elimsys)=0;
keepsys=nonzeros(keepsys).';

rho = permuterho(rho,dim,[elimsys keepsys]);
reducedrho = partialTr_bp(rho,1,[prod(dim(elimsys)) prod(dim(keepsys))]);