function averaged_purified_F = purification_average(F,n)

purified_F = [];
for iter=1:10000
    purified_F(end+1) = purification(F,n-1);
end
averaged_purified_F = mean(purified_F);
