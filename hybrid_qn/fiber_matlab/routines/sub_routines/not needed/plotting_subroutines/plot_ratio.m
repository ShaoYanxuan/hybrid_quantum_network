function y = plot_ratio(wp)
h = figure();
hold on;
ax1  = gca;
hold on
xlabel('Coincidence window, us');
ylabel('contrast');
grid on
hold on
ax1_pos = ax1.Position;
for i = 1:length(wp)
    if  length(wp(i).param) > 0
        clear typ
        if(wp(i).param.type(1) == 'D')
            typ = '--';
             errorbar(wp(i).data(:,1), wp(i).data(:,2), wp(i).data(:,3), 'Parent',ax1, typ, 'LineWidth', 2, 'DisplayName', wp(i).legend);
        end
        
        %% experiment
        if(wp(i).param.type(1) == 'E')
            typ = 'x';
            xlim([0 wp(i).param.range])
            errorbar(wp(i).data(:,1), wp(i).data(:,2), wp(i).data(:,3), 'Parent',ax1, typ, 'LineWidth', 1, 'DisplayName', wp(i).legend);
            if(isfield(wp(i).param, 'plot_integrated'))
                if( wp(i).param.plot_integrated == 1 )  %plot integrated efficiency
                    if(~exist('ax2'))
                        ax2 = axes('Position',ax1_pos,  'YAxisLocation','right', 'Color', 'none', 'XTick',[]);
                        hold on;
                        range = wp(i).param.range;
                    end;
                    errorbar(wp(i).data(:,1), wp(i).data(:,4),  wp(i).data(:,5), 'Parent',ax2, '.-', 'LineWidth', 1,'DisplayName', ['Integrated ' wp(i).legend]);
                    set(ax2, 'xlim', [0, range])
                    ylabel('Integrated click probability');
                                       
                end
            end
        end
        
        %% Basel
        if(wp(i).param.type(1) == 'B')
            typ = 'o-';
             plot(ax1, wp(i).data(:,1), wp(i).data(:,2), typ, 'DisplayName', wp(i).legend);
             if(isfield(wp(i).param, 'plot_integrated'))
                if( wp(i).param.plot_integrated == 1 )  %plot integrated efficiency
                    if(~exist('ax2'))
                        ax2 = axes('Position',ax1_pos,  'Color','none');
                        hold on;
                        range = wp(i).param.range;
                    end;
                    plot(ax2, wp(i).data(:,1), wp(i).data(:,4),  '-o', 'DisplayName', ['Integrated ' wp(i).legend]);
                    set(ax2, 'xlim', [0, range])
                    ylabel('Integrated click probability');
                   
                end
            end
             if(isfield(wp(i), 'data2'))
                if(length(wp(i).data2)>0)
                    hold on
                    plot(ax1, wp(i).data2(:,1), wp(i).data2(:,2), typ, 'DisplayName', wp(i).legend2);
                end
            end
        end
        
        %% common 
        tosave = wp(i).data;
        foldersep = find(wp(i).param.filename == filesep);
        foldersep_last = 0;
        if length(foldersep) >0
            foldersep_last = foldersep(length(foldersep));
        end
        savefile = sprintf('ratio_from_%s', wp(i).param.filename(foldersep_last+1:length(wp(i).param.filename)));
        if(isfield(wp(i).param, 'label'))
            if(length(wp(i).param.label)>0)
                savefile = strcat(wp(i).param.label, savefile);
            end
        end
        savefile = strcat(['plotted'  filesep ], savefile);
        save(savefile, 'tosave', '-ascii');
    end
end;


title('Ratio integrated');
% xlim([0 20]);
% ylim([0 0.65])
le = legend(ax1, 'show');
set(le, 'Interpreter','none');
if(exist('ax2'))
        le = legend(ax2, 'show'); 
        set(le, 'Interpreter','none');
        %set(ax2, 'xlim', [0, wp(i).param.range])
end

set(findall(gcf,'-property','FontSize'),'FontSize',14)
 set(h,'CurrentAxes',ax1);
y = h;
end