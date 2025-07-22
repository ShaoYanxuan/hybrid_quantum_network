function data_out = shift_ref_to_center(data_in, displacement)
dat_rows = length(data_in(:,1));
dat_cols = length(data_in(1,:));

dt = data_in(2,1)- data_in(1,1);
[stop_bin, start_bin, l, zero] = bin_numbers_from_gate(data_in(:,1), [-1*displacement, displacement]); 
limit = min([start_bin, dat_rows-stop_bin, round(displacement/dt/2)])-1;
data_out = zeros(2*limit, dat_cols);
for i = 1:2*limit
    data_out(i, 1) = dt*i-dt*limit;
    data_out(i, 2) = data_in(start_bin-limit+i, 2)+data_in(stop_bin-limit+i, 2);
    if(dat_cols>2)
        data_out(i, 3) = sqrt(data_in(start_bin-limit+i, 3)^2+data_in(stop_bin-limit+i, 3)^2);
    end;
    
end;