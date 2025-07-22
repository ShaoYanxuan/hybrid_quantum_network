function y  = define_trics_times(PMTdataArray, cycl_num, seq_cycles)

meas_point =  fix((cycl_num-1)/seq_cycles)+1;
if(meas_point > length(PMTdataArray{1}) )
    y = [-1,-1];
else
   if( PMTdataArray{1,1}{meas_point}(1) == '#')    % melting in dected by trics
        y(1) =  eval(PMTdataArray{1,1}{meas_point}(2:end))*1e3;
        y(2) =  eval(PMTdataArray{1,2}{meas_point}(2:end))*1e3;
    else
        y(1) =  eval(PMTdataArray{1,1}{meas_point})*1e3;
        y(2) =  eval(PMTdataArray{1,2}{meas_point})*1e3;
    end
end
    