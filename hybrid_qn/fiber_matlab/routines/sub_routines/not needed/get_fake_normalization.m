function coinc_hist = get_fake_normalization(counts_hist, counts_hist2, bin_arr, gate)
for ii = 1:(length(bin_arr)-1)
    if( bin_arr(ii) <= 0 &&  bin_arr(ii+1)> 0)%search start inicies
           zer = ii;
     end;
     if(bin_arr(ii) <= gate(1) && bin_arr(ii+1)> gate(1))
            gate_start_bin = ii;
      end;
      if(bin_arr(ii) <= gate(2) && bin_arr(ii+1)> gate(2))
             gate_stop_bin = ii;
      end;

 end;
 coinc = zeros(length(bin_arr),1)';
 gate_len = -gate_start_bin+gate_stop_bin;
for i = gate_start_bin:gate_stop_bin
    for  j = i-gate_len:i+gate_len
        coinc(zer+j-i) = coinc(zer+j-i)+counts_hist(i)*counts_hist2(j);
    end;
end;
coinc_hist = coinc;%/gate_len;