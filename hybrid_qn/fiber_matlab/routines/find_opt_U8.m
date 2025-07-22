function [U1,U2] = fi4nd_opt_U8(rhoin1, rhoin2, rho_targ)
k = 2;
arg = zeros(4,4,8);
maxfid = 0;
for i = 1:4
    arg(:,:,i) = rhoin1{i};
    maxfid = maxfid+(purity( rhoin1{i}));
    arg(:,:,i+4) = rhoin2{i};
    maxfid = maxfid+(purity( rhoin2{i}));
    %using sqrt(Purity) as max. fideity for optimisation
end
    
fun=@(x)cost_opt_U8(x, arg, maxfid);

%x0=[1,1,1,1,1,1,1,1,1,1,1,1];%,1,1,1
x0= zeros(8,1)+1;
x0([8]) = 0;
[x,val] = fminsearch(fun,x0)
x(8) = 0;
opt = optimset('MaxFunEvals', 20000, 'MaxIter', 20000);

[x,val] = fminsearch(fun,x, opt)

[rho_interm1, rho_interm2, U] =cost_opt_U8_body(x);
Ut1 = find_opt_U4(rho_interm1, rho_targ);
Ut2 = find_opt_U4(rho_interm2, rho_targ);
U1 = Ut1*U'; %Unitary
U2 = Ut2*U';
 %mixedfid(rho_targ{4}, Ut1*U'*rhoin1{4}*U*Ut1')

function R = cost_opt_U8(x, rhotarg, maxfid)
[rhoin1, rhoin2, U] =cost_opt_U8_body(x);
k = 2; % order 
Up = U';
%using sqrt(Purity) as max. fideity for optimisation
R = abs(maxfid-    mixedfid(rhotarg(:,:,1),U*rhoin1{1}*Up )^k -...
    mixedfid(rhotarg(:,:,2),U*rhoin1{2}*Up )^k-...
    mixedfid(rhotarg(:,:,3),U*rhoin1{3}*Up )^k-...
    mixedfid(rhotarg(:,:,4),U*rhoin1{4}*Up )^k-...
 mixedfid(rhotarg(:,:,5),U*rhoin2{1}*Up )^k -...
    mixedfid(rhotarg(:,:,6),U*rhoin2{2}*Up )^k-...
    mixedfid(rhotarg(:,:,7),U*rhoin2{3}*Up )^k-...
    mixedfid(rhotarg(:,:,8),U*rhoin2{4}*Up )^k);



% rhoout=Uopt...
% *rhoin*...
% Uopt';
%     
% out.fidopt(hh)=mixedfid(rhotarg,rhoout);