function purified_F_prob = purification_2_1(F1,F2)

p1 = (4*F1-1)/3;
p2 = (4*F2-1)/3;

purified_p = (p1+p2+4*p1*p2)/(3+3*p1*p2);
purified_F = (3*purified_p+1)/4;
prob = (1+p1*p2)/2;

purified_F_prob = [purified_F,prob];
