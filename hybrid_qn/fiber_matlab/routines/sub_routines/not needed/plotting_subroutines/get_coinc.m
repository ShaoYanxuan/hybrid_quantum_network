function y = get_coinc(param)
for i = 1:length(param)
    if length(param(i).type) > 0
        if(param(i).type(1) == 'D')  %Dario
             [wavepacket, distribution, ratio] = plots_from_dario_trajectory([param(i).dir, param(i).filename], param(i).gate, param(i).dt, param(i).gate(2)*2 );
             coinc(i).data = distribution;
             coinc(i).data(:,1) = distribution(:,1);
             coinc(i).data(:,2) = distribution(:,2)*param(i).rescale;
             coinc(i).data2(:,2) = distribution(:,3)*param(i).rescale;
             coinc(i).legend = [param(i).type '; ' param(i).filename sprintf('\n multiplied by %.2e',param(i).rescale)];
             step = coinc(i).data(2,1)-coinc(i).data(1,1);
            coinc(i).data(:,1) = coinc(i).data(:,1)+step/2; %shift from bin edges to bin centers
            coinc(i).data2(:,1) = coinc(i).data(:,1);
        end;
        
        %% %Basel
        if(param(i).type(1) == 'B')  
            dat_tmp1 = load([param(i).dir, param(i).filename]);  %overlapped data
            len = length(dat_tmp1(:,1));
            coinc(i).data= zeros(2*len, 2);  %mirroring of the curve  (negative branch)
            coinc(i).data(1:len, 1) = -1*dat_tmp1(:,1);
            coinc(i).data(1:len, 2) = dat_tmp1(:,2)*param(i).rescale;
            coinc(i).data(len+1:2*len, 1) = dat_tmp1(:,1);     %positive branch
            coinc(i).data(len+1:2*len, 2) = dat_tmp1(:,2)*param(i).rescale;
            coinc(i).data = sortrows(coinc(i).data);
            dat_tmp2 = load([param(i).dir, param(i).filename2]);    % displaced data
            if(isfield(param(i), 'shift'))
             if(length(param(i).shift)>0)
                dat_tmp2(:, 1) = dat_tmp2(:, 1)+param(i).shift;
             end
            end;
            len = length(dat_tmp2(:,1));     
            coinc(i).data2= zeros(2*len, 2);    
            coinc(i).data2(1:len, 1) = -1*dat_tmp2(:,1);    % mirroring
            coinc(i).data2(1:len, 2) = dat_tmp2(:,2)*param(i).rescale;
            coinc(i).data2(len+1:2*len, 1) = dat_tmp2(:,1);
            coinc(i).data2(len+1:2*len, 2) = dat_tmp2(:,2)*param(i).rescale;
            coinc(i).data2 = sortrows(coinc(i).data2);
            coinc(i).legend = [param(i).type '; ' param(i).filename sprintf('\n multiplied by %.2e',param(i).rescale)];
            coinc(i).legend2 = [param(i).type '; ' param(i).filename2 sprintf('\n multiplied by %.2e',param(i).rescale)];
            
           if(isnotempty(param(i), 'add_background'))
                coinc(i).data(:, 2) = coinc(i).data(:, 2)+param(i).add_background;
                coinc(i).data2(:, 2) = coinc(i).data2(:, 2)+param(i).add_background;
                coinc(i).legend = sprintf('%s, \n %.2e backgorund coincidence added', coinc(i).legend, param(i).add_background );
                coinc(i).legend2 = sprintf('%s, \n %.2e backgorund coincidence added', coinc(i).legend2, param(i).add_background );
            end;
        end
        
        %% %exp
        if(param(i).type(1) == 'E')  
            coinc(i).legend = [param(i).type '; ' param(i).filename];
            data_tmp = load([param(i).dir, param(i).filename]);
            step = data_tmp(2,1)-data_tmp(1,1);
            coinc(i).data(:,1) = data_tmp(:,1)+step/2; %shift from bin edges to bin centers
            coinc(i).data2(:,1) = coinc(i).data(:,1);
            coinc(i).data(:,2) = data_tmp(:,2);
            coinc(i).data(:,3) = data_tmp(:,3);
            coinc(i).data2(:,2) = data_tmp(:,4);
            coinc(i).data2(:,3) = data_tmp(:,5);
        end
        
        if(isfield(param(i), 'label')) %add label to the legend
             if(length(param(i).label)>0)
                coinc(i).legend = sprintf('%s,\n%s', param(i).label, coinc(i).legend );
             end
         end;
         if(isfield(param(i), 'displace_ref_to_center')) %shift distinguishable curve to center
             if(length(param(i).displace_ref_to_center)>0)
                coinc(i).data2 = shift_ref_to_center(coinc(i).data2, param(i).displace_ref_to_center);
             end
             if(isnotempty(param(i), 'add_distinguish')) %will work only with shifted norm. curve
                coinc(i).data(:,2) = add_distinguishability_coinc(coinc(i).data,coinc(i).data2, param(i).add_distinguish );
            end
         end;
          coinc(i).data(:,2:end) = coinc(i).data(:,2:end)*1e-6; % to 1/us units
          coinc(i).data2(:,2:end) = coinc(i).data2(:,2:end)*1e-6;
        coinc(i).param = param(i);
    end
    
end
y = coinc;
end