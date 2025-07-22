function y = get_ratio(param)
for i = 1:length(param)
    d2 = 0;
    if length(param(i).type) > 0
        if(~isfield(param(i), 'rescale'))
            param(i).rescale = 1;
        else
            if(length(param(i).rescale) == 0)
                param(i).rescale = 1;
            end
        end
        
        %% % Dario
        if(param(i).type(1) == 'D')
             [wavepacket, distribution, rat] = plots_from_dario_trajectory([param(i).dir, param(i).filename], param(i).gate, param(i).dt, param(i).gate(2)*2 );
            ratio(i).data = rat;
             ratio(i).legend = [param(i).type '; ' param(i).filename];
        end;
       
        %% %experiment
        if(param(i).type(1) == 'E')  
            tmp_dat  = load([param(i).dir, param(i).filename]);
            ratio(i).data(:,1) = tmp_dat(:,1);
            ratio(i).data(:,2) = 1-tmp_dat(:,4);   %ratio
            ratio(i).data(:, 3) = tmp_dat(:,7);
            ratio(i).data(:, 4) = tmp_dat(:,3)*param(i).rescale;   %probabi;ity distinguish
            ratio(i).data(:, 5) = tmp_dat(:,6)*param(i).rescale;    %err
             ratio(i).legend = [param(i).type '; ' param(i).filename];
            
        end;
        
        %% %Basel;
        if(param(i).type(1) == 'B')  
            ratio(i).legend = [param(i).type '; ' param(i).filename];
             background  = 0;
            if(isnotempty(param(i), 'add_background')) %noise
                background = param(i).add_background;
                ratio(i).legend = sprintf('%s, \n %.2e backgorund coincidence added', ratio(i).legend, param(i).add_background );
            end;
            tmp_data =  integrated_from_Basel(param(i).rescale, background, [param(i).dir, param(i).filename],[param(i).dir, param(i).filename2], param(i).delay_between_delayed_photons, param(i).range );
            ratio(i).data(:,1:2) =  tmp_data(:, 1:2);
            ratio(i).data(:, 4) =  tmp_data(:, 3);
                      
            if(isnotempty(param(i), 'filename3')) %integrated curve from Basel
                d2 = 1;
                tmp_dat  = load([param(i).dir, param(i).filename3]);
                ratio(i).data2(:,1) = tmp_dat(:,1);
                ratio(i).data2(:,2) = tmp_dat(:,2);
                ratio(i).legend2 = [param(i).type '; ' param(i).filename3];
            end;
        end
        
        %% general
        if(isnotempty(param(i), 'label')) %add label to the legend
            ratio(i).legend = sprintf('%s,\n%s', param(i).label,  ratio(i).legend );
        end;
         if(isnotempty(param(i), 'add_distinguish'))
             ratio(i).data(:,2) = add_distinguishability(ratio(i).data(:,2),param(i).add_distinguish );
             if(d2)
                 ratio(i).data2(:,2) = add_distinguishability(ratio(i).data2(:,2),param(i).add_distinguish );
             end
         end;
        if(isnotempty(param(i), 'plot_contarst')) % 1-ratio
             if(param(i).plot_contarst)
                ratio(i).data(:,2) = 1-ratio(i).data(:,2);
                 %ratio(i).data(:,2) = (1+ ratio(i).data(:,2)).^-1-(1+ ratio(i).data(:,2).^-1).^-1;
                if(d2)
                    ratio(i).data2(:,2) = 1-ratio(i).data2(:,2);
                    %ratio(i).data2(:, 2) = (1+ ratio(i).data2(:,2)).^-1-(1+ ratio(i).data2(:,2).^-1).^-1;
                end;
             end;
          end;
         ratio(i).data(:,1) = ratio(i).data(:,1)/2;
          param(i).range =  param(i).range/2;
        ratio(i).param = param(i);
    end
    
end
y = ratio;
end
