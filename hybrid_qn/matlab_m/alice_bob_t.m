% clear all
% F0 = 0.962; Fphoton = 0.692; Fswap = 0.952;
% OUTC = 1;

F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
T0 = 175e-6; gamma = 0.0173; P0 = 0.21; c = 2e5;

standardbell;standardpolns;
V = 2*Fphoton-1;
F0 = 1/2*(1+V*(1-2*F0)^2); % == (F0^2+(1-F0)^2)*(1+V)/2+2*F0*(1-F0)*(1-V)/2

purified_F_final = readmatrix('./purified_F_final.csv');
optimal_time = readmatrix('./direct_fibers/optimal_time_theory.csv');
Path = readmatrix('./alice_bob_path.csv');
Real_optimal_time = []; path_total_length = [];
for i=1:size(Path,1)
    disp(i);
% for i=1:100
    path = Path(i,:);
    path = path(~isnan(path));
    while max(path)>63
        [a,b] = max(path);
        path = [path(1:b-1),a/8,a/8,a/8,a/8,a/8,a/8,a/8,a/8,path(b+1:end)];
    end
    path_total_length(end+1) = sum(path); 
    if sum(path)<1000 && sum(path)>20
        optimal_t = optimal_time(floor(sum(path))-20)/10;
        Real_optimal_time(end+1) = path_optimal(path,optimal_t,Fswap,purified_F_final);
        % disp(Real_optimal_time); results_index(end+1) = i;
    else
        Real_optimal_time(end+1) = 0;
    end

end
    