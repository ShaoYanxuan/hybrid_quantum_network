function ans = nxor(first, varargin)
% nxor.m : exclusive OR operation for 2 or more arguments
% based on nkron.m (originally written by Julio Barreiro)
% ans : true if one and only one input argument is true

ans = xor(first,varargin{1});
if nargin > 2
  ans = nxor(ans,varargin{2:end});
end
