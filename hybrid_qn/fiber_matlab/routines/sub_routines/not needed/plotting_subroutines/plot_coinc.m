function y = plot_coinc(wp)
y = figure();
hold on;
for i = 1:length(wp)
    if  length(wp(i).param) > 0
        clear typ
        if(wp(i).param.type(1) == 'D')
            typ = '--';
            plot(wp(i).data(:,1), wp(i).data(:,2), typ, 'DisplayName', wp(i).legend);
            hold on;
            plot(wp(i).data2(:,1), wp(i).data2(:,2), typ, 'DisplayName', wp(i).legend);
        end
        if(wp(i).param.type(1) == 'E')
            typ = 'x-';
            errorbar(wp(i).data(:,1), wp(i).data(:,2),  wp(i).data(:,3), typ, 'LineWidth', 1,'DisplayName', wp(i).legend);
            hold on;
            errorbar(wp(i).data2(:,1), wp(i).data2(:,2), wp(i).data2(:,3), typ, 'LineWidth', 1, 'DisplayName', wp(i).legend);
        end
        if(wp(i).param.type(1) == 'B')
            typ = 'o-';
            plot(wp(i).data(:,1), wp(i).data(:,2), typ, 'DisplayName', wp(i).legend);
            hold on;
            plot(wp(i).data2(:,1), wp(i).data2(:,2), typ, 'DisplayName', wp(i).legend2);

        else

        end
        tosave = wp(i).data; tosave2 = wp(i).data2;
        foldersep = find(wp(i).param.filename == filesep);
        foldersep_last = 0;
        if length(foldersep) >0
            foldersep_last = foldersep(length(foldersep));
        end
        savefile = sprintf('coincidence_from_%s', wp(i).param.filename(foldersep_last+1:length(wp(i).param.filename)));
        if(isfield(wp(i).param, 'label'))
            if(length(wp(i).param.label)>0)
                savefile = strcat(wp(i).param.label, savefile);
            end
        end
        savefil = ['plotted'  filesep  savefile];
        save(savefil, 'tosave', '-ascii');
        savefil = ['plotted'  filesep  '2' savefile];
        save(savefil, 'tosave2', '-ascii');
    end
end;
xlim(wp(i).param.range);
xlabel('Detection times difference, us');
ylabel('Coincidence probability density, 1/us');
title('Coincidences');
le = legend('show');
set(le, 'Interpreter','none');
%xlim([-15 15]);
%ylim([-1 140])
grid on;
set(findall(gcf,'-property','FontSize'),'FontSize',16)
end