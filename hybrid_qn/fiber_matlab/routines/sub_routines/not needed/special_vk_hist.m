function y = special_vk_hist(times_arr_in, window_in, starts_arr)
%makes histogram with bin edges step not equal to bin size
times_arr = sort(times_arr_in);
N = length(times_arr);
k = 1;
y.BinCounts(1) =0;
wind = window_in;%/(starts_arr(2)-starts_arr(1));
i = 1;
while i< N+1
   
    if k > length(starts_arr)-1
        break
    end;
    if times_arr(i) >= starts_arr(k)
        y.BinCounts(k) =0;
        for j = i:N
            
            if times_arr(j) > starts_arr(k)+wind
                y.BinCounts(k) = j-i;
                
                i;
                break                
            end
            
        end
        k = k+1;
    else 
        i = i+1;
    end
end

