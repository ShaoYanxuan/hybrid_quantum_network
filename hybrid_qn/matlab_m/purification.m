function purified_F = purification_dephasing(F,n)

F_list = F*ones(1,n);
while length(F_list)>1
    F_list = sort(F_list);
    F1 = F_list(1);
    F2 = F_list(2);
    result = purification_2_1(F1,F2);
    F_list = F_list(3:end);
    F = result(1); prob = result(2);
    if rand()<prob
        F_list(end+1) = F;
    end
end

if length(F_list)>0
    purified_F = F_list(1);
else
    purified_F = F;
end