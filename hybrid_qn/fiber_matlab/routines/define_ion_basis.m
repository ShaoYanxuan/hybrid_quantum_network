function y  = define_ion_basis(PMTdataArray, cycl_num, seq_cycles, threshold)

meas_point =  fix((cycl_num-1)/seq_cycles)+1;
if(meas_point > length(PMTdataArray{1}) )
    y = -1;
else
    if( PMTdataArray{1,1}{meas_point}(1) == '#' ||...  % melting in dected by trics
            ( eval(PMTdataArray{1,6}{meas_point}) < threshold) )    % or threshold
   %if
        y = -1;
    else
        y =  mod(PMTdataArray{1,3}(meas_point), 3);
    end
end
    