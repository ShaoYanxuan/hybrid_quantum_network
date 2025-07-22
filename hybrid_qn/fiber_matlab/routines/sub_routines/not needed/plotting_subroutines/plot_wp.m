function y = plot_wp(wp)

h = figure();
hold on;
ax1  = gca;
grid on
xlabel('Detection time, us');
ylabel('Probability density, \mu s^{-1}');
hold on
ax1_pos = ax1.Position;

%et(ax2, 'YAxisLocation','right', 'Color', 'none');
set(h,'CurrentAxes',ax1);

%% plotting
for i = 1:length(wp)
    if length(wp(i).param) > 0
        clear typ
        %% %Dario
        
        if(wp(i).param.type(1) == 'D')  
            typ = '--';
             plot(ax1, wp(i).data(:,1), wp(i).data(:,2), typ, 'DisplayName', wp(i).legend);
        end
        
        %%
        if(wp(i).param.type(1) == 'E') %Experiment
            xlim([0, wp(i).param.duration]);
            %xlim([0 15])
            typ = 'o';
             %l = errorbar(wp(i).data(:,1), wp(i).data(:,2),  wp(i).data(:,3), typ,'Parent',ax1,  'LineWidth', 1,'DisplayName', wp(i).legend);
             l = plot(wp(i).data(:,1), wp(i).data(:,2), typ,'Parent',ax1,  'LineWidth', 1,'DisplayName', wp(i).legend);
           l.MarkerFaceColor = l.Color;
           

%             
%             axis = gca   ;
% 
% yd = get(axis,'YNegativeDelta');
%  yd(:)=nan;
%    set(ax,'YNegativeDelta',yd);
%     set(ax,'YPositiveDelta',yd);
            
%             % Make cap-lines twice as long
%             mult = 0.3;                               % twice as long
%             b = l.Bar;                           % hidden property/handle
%             drawnow                                 % populate b's properties
%             vd = b.VertexData;
%             X=wp(i).data(:,1);
%             N = numel(X);                           % number of error bars
%             capLength = vd(1,2*N+2,1) - vd(1,1,1);  % assumes equal length on all
%             newLength = capLength * mult;
%             leftInds = N*2+1:2:N*6;
%             rightInds = N*2+2:2:N*6;
%             vd(1,leftInds,1) = [X-newLength, X-newLength];
%             vd(1,rightInds,1) = [X+newLength, X+newLength];
%             b.VertexData = vd;
            
            
            if(isfield(wp(i).param, 'plot_integrated'))
                if( wp(i).param.plot_integrated == 1 )  %plot integrated WP 
                    %yyaxis right
                    if(~exist('ax2'))
                        ax2 = axes('Position',ax1_pos,  'Color','none', 'YAxisLocation','right', 'Color', 'none', 'XTick',[]);
                        hold on;
                    end;
                    set(h,'CurrentAxes',ax2);
                    errorbar(wp(i).data(:,1), wp(i).data(:,4),  wp(i).data(:,5), 'Parent',ax2, '.-', 'LineWidth', 1,'DisplayName', ['Integrated ' wp(i).legend]);
                    set(ax2, 'xlim', [0, wp(i).param.duration])
                    ylabel('Integrated click probability');
                    set(h,'CurrentAxes',ax1);
                    
                end
            end
        end
        
        %% % basel
        if(wp(i).param.type(1) == 'B') 
            typ = 'o-';
             plot(ax1, wp(i).data(:,1), wp(i).data(:,2), typ, 'DisplayName', wp(i).legend);
             if(isfield(wp(i).param, 'plot_integrated'))
                if( wp(i).param.plot_integrated == 1 )  %plot integrated WP 
                   if(~exist('ax2'))
                        ax2 = axes('Position',ax1_pos,  'Color','none', 'YAxisLocation','right', 'Color', 'none', 'XTick',[]);
                        hold on;
                    end;
                    set(h,'CurrentAxes',ax2);
                    plot(ax2, wp(i).data(:,1), wp(i).data(:,4), typ, 'DisplayName', ['Integrated ' wp(i).legend]); 
                    set(ax2, 'xlim', [0, wp(i).param.duration])
                    ylabel('Integrated click probability');
                    set(h,'CurrentAxes',ax1);
                    
                end

             end
        end
        
        %% % Josef
        if( wp(i).param.type(1) == 'J') 
            typ = ':';
             plot(ax1, wp(i).data(:,1), wp(i).data(:,2), typ, 'LineWidth', 3, 'DisplayName', wp(i).legend);
             
        end
        
        %% all cases
        
        tosave = wp(i).data;
        foldersep = find(wp(i).param.filename == filesep);
        foldersep_last = 0;
        if length(foldersep) >0
            foldersep_last = foldersep(length(foldersep));
        end
        savefile = sprintf('wavepacket_from_%s', wp(i).param.filename(foldersep_last+1:length(wp(i).param.filename)));
        if(isfield(wp(i).param, 'label'))
            if(length(wp(i).param.label)>0)
                savefile = strcat(wp(i).param.label, savefile);
            end
        end
        savefile = strcat(['plotted'  filesep ], savefile);
        save(savefile, 'tosave', '-ascii');
    


        %% formatting
        title('Wavepackets');
        

%         wplim = 12;
%         set( ax1, 'xlim', [0 wplim] );
%         set(ax2, 'xlim', [0 wplim], 'YAxisLocation','right', 'Color', 'none', 'XTick',[]);
%         if(length(ax1.Children)>2)
%             set(ax1.Children(1), 'Marker', 'none',  'Color', 'red');   %basel
%             set( ax1.Children(2), 'MarkerSize',4, 'Marker','diamond', 'Color','black')   %long path 
%             set( ax1.Children(3), 'MarkerSize',4, 'Marker','o', 'Color', 'red')   %short path 
%         end;
%         if(exist('ax2'))
%             if(length(ax2.Children)>1)
%                 set( ax2.Children(1), 'MarkerSize',1, 'Marker','diamond',  'LineStyle', 'none','Color', [0.8 0.8 0.8]) %integrated long path 
%                 set( ax2.Children(2), 'MarkerSize',1, 'Marker','x', 'LineStyle', 'none', 'Color', [0.8 0.8 0.8])         %integrated short path 
%             end
%         end

        set(findall(gcf,'-property','FontSize'),'FontSize',14)
%        

        set(h,'CurrentAxes',ax1);
        
    
    end;
    y = h;
    legend(ax1, 'off')
    le = legend(ax1, 'show');
    set(le, 'Interpreter','none');
    if(exist('ax2'))
        le = legend(ax2, 'show'); 
        set(le, 'Interpreter','none');
    end
     set(h,'CurrentAxes',ax1);
end