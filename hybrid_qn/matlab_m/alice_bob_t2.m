% clear all
% F0 = 0.962; Fphoton = 0.692; Fswap = 0.952;
% OUTC = 1;

F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;
V = 2*Fphoton-1;
F0 = 1/2*(1+V*(1-2*F0)^2); % == (F0^2+(1-F0)^2)*(1+V)/2+2*F0*(1-F0)*(1-V)/2

purified_F_final = readmatrix('./purified_F_final.csv');
optimal_time = readmatrix('./optimal_time.csv');
Path = readmatrix('./alice_bob_path2.csv');
Real_optimal_time2 = []; path_total_length2 = [];
% for i=21:size(Path,1)
for i=1:size(Path,1)
    path = Path(i,:);
    path = path(~isnan(path));
    path_total_length2(end+1)=sum(path);
    optimal_t = optimal_time(floor(sum(path))-20);
    Real_optimal_time2(end+1) = path_optimal(path,optimal_t,Fswap,purified_F_final);
    disp(Real_optimal_time2)
end
    
writematrix(path_total_length2, './path_total_length2.csv');
writematrix(Real_optimal_time2,'./Real_optimal_time2.csv');

