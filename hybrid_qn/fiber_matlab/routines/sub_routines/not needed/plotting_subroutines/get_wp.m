function y = get_wp(param)
for i = 1:length(param)
    
    %%  Dario
    if length(param(i).type) > 0
        if(~isnotempty(param(i), 'average'))
            param(i).average = 1;
        end
        if(param(i).type(1) == 'D')       
            if(~isfield(param(i), 'shift'))
                param(i).shift = 0;
            else
                if(length(param(i).shift) == 0)
                    param(i).shift = 0;
                end
            end
            [wavepacket, distribution, ratio] = plots_from_dario_trajectory([param(i).dir, param(i).filename], [param(i).shift, param(i).shift+param(i).duration], param(i).dt, param(i).duration*3 );
            wp(i).data = wavepacket;
            wp(i).data(:,2) = wp(i).data(:,2);
        end
        %% %Basel or simple format
        if(param(i).type(1) == 'B' || param(i).type(1) == 'S' )  
            dat_tmp1 = make_average(load([param(i).dir, param(i).filename]),param(i).average ) ;
            wp(i).data(:, 1) = dat_tmp1(:,1);
            wp(i).data(:, 2) = dat_tmp1(:,2);
            L = length(dat_tmp1 (:, 1));
             dt = (dat_tmp1(2,1)-dat_tmp1(1,1))*1e-6;
             for j = 1:L  %getting the integrated efficiency
                wp(i).data(j, 4) = sum( wp(i).data(1:j, 2) )*dt;
                wp(i).data(j, 5) = 0;
                
             end
        end
    %% %Josef
        if(param(i).type(1) == 'J') 
            jos = load([param(i).dir, param(i).filename]);
            wp(i).data(:, 1) =jos.data.tlist';
            wp(i).data(:, 2) = jos.data.wavepacket';
             L = length( wp(i).data(:, 1));
             dt = ( wp(i).data(2, 1)- wp(i).data(1, 1));
             for j = 1:L  %getting the integrated efficiency
                wp(i).data(j, 4) = sum( wp(i).data(1:j, 2) )*dt;
                wp(i).data(j, 5) = 0;
                
             end
            
        end;
           %% % Experiment
         if(param(i).type(1) == 'E')   
             dat_tmp =  load([param(i).dir, param(i).filename]);
             L = length(dat_tmp (:, 1));
             dt = (dat_tmp(2,1)-dat_tmp(1,1))*1e-6;
             wp(i).data = zeros(L, 5);
             wp(i).data(:, 1) = dat_tmp(:,1);
             wp(i).data(:, 2) = dat_tmp(:,2); 
             det = 0;
             if(isfield(param(i), 'detector')) %add label to the legend
                 if(length(param(i).detector)>0)
                     det = param(i).detector;
                     if(det == 1)
                         wp(i).data(:, 3) =  wp(i).data(:, 2)./sqrt(dat_tmp(:,3));
                     end
                     if (det == 2)
                         wp(i).data(:, 2) = dat_tmp(:,4); 
                         wp(i).legend = sprintf('%s,\n%s', 'det2', wp(i).legend );
                          wp(i).data(:, 3) =  wp(i).data(:, 4)./sqrt(dat_tmp(:,5));
                     end
                 end
             end;
             if(length( dat_tmp(1,:))>4 && det == 0)  %newer format, has absolute counts to polot errorbars
                 wp(i).data(:, 2) =  dat_tmp(:,2)+dat_tmp(:,4);
                 wp(i).data(:, 3) =  wp(i).data(:, 2)./sqrt(dat_tmp(:,3)+dat_tmp(:,5));
             end
             [stop_bin, start_bin, l, z] = bin_numbers_from_gate(dat_tmp(:,1), [param(i).shift param(i).shift+1]); % searching from where to integrate: from t= shift in absolute values, means t = 0 in the plot
             for j = 1:L  %getting the integrated efficiency
                wp(i).data(j, 4) = sum( wp(i).data(start_bin:j, 2) )*dt*1e6;
                wp(i).data(j, 5) = sqrt(sum( wp(i).data(start_bin:j, 3).^2))*dt*1e6;
             end
                     
         end
         
         %% ----all cases --------------------
         if(isnotempty(param(i), 'X_rescale')) %will work only with shifted norm. curve
                 wp(i).data(:,1) = wp(i).data(:,1)*param(i).X_rescale;
          end
         if(param(i).type(1) == 'B' ||param(i).type(1) == 'J')
             wp(i).data(:,2:end) = wp(i).data(:,2:end)/1e-6; %basel is special :)
         else
            wp(i).data(:,2:end) = wp(i).data(:,2:end)/(wp(i).data(2,1)-wp(i).data(1,1))/1e-6;
         end;
          wp(i).legend = [param(i).type '; ' param(i).filename];
         
          if(isfield(param(i), 'rescale'))
             if(length(param(i).rescale)>0)
                wp(i).data(:,2:end) = wp(i).data(:,2:end)*param(i).rescale;
                wp(i).legend = [param(i).type '; ' param(i).filename sprintf('\n multiplied by %.2e',param(i).rescale)];
             end
         end;
         if(isfield(param(i), 'shift'))
             if(length(param(i).shift)>0)
                wp(i).data(:,1) = wp(i).data(:,1)-param(i).shift;
             end
         end;
         if(isfield(param(i), 'label')) %add label to the legend
             if(length(param(i).label)>0)
                wp(i).legend = sprintf('%s,\n%s', param(i).label, wp(i).legend );
             end
         end;
        wp(i).data(:,2:end) = wp(i).data(:,2:end)*1e-6; % to 1/us units
        wp(i).param = param(i);
    end
    
end
y = wp;
end

