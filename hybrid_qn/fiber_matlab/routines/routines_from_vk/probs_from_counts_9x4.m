function prob_mat = probs_from_counts_9x4(exp_counts)
prob_mat = zeros(9,4);
for i = 1:9  %should be 9 raws
    intens = sum(exp_counts(i, :));
    prob_mat(i, :) = exp_counts(i, :)/ intens;
end