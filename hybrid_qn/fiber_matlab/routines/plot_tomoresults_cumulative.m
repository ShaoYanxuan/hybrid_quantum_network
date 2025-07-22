%% - now plot things

%load out
close all


%% - plot wavepackets
aver1 = 0;
aver2 = 0;
i = 1;
%counts1 = out.Counts1{i};
counts2 = out.Counts2{i};
tr_counts1 = out.good_triggering_counts1{i};
tr_counts2 = out.good_triggering_counts2{i};
for i = 2:length(out.gatestart)
%     counts1 =[counts1 out.Counts1{i}];
%     counts2 =[counts2 out.Counts2{i}];
    tr_counts1 =[tr_counts1 out.good_triggering_counts1{i}];
    tr_counts2 =[tr_counts2 out.good_triggering_counts2{i}];
    
end

 figure(1)
  %nf = length(out.Counts1{1}(1,:));
  nf = length(out.Counts2{1}(1,:));
  bin_arr = (out.gatestart{1}-200):1:(out.gatestart{length(out.gatestop)}+200);
 ii = 1;
 for ii = 1:nf 
     subplot(nf,1,ii)
%      hist1 = histogram( out.Counts1{1}(:,ii), bin_arr );
%      v1 = hist1.Values; b1=hist1.BinEdges;
      hist2 = histogram( out.Counts2{1}(:,ii), bin_arr );
     v2 = hist2.Values; b2=hist2.BinEdges;
%      aver1 = aver1 + v1;
     aver2 = aver2 + v2;
%      plot(b1(1:end-1),v1)
%      hold on
     plot(b2(1:end-1),v2)
     hold off
    for dd=1:length(out.gatestart);
        line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
        line([out.gatestop{dd},out.gatestop{dd}],ylim, 'LineWidth', 2, 'LineStyle', ':','Color', 'k');
    end
   xlim([out.gatestart{1}-30 out.gatestop{dd}+30]);;
  end
ii = ii+1;
figure()
hist4 = histogram( tr_counts2, bin_arr );
v4 = hist4.Values; 
figure(1)
%subplot(nf+1,1,ii)
%  hist3 = histogram( tr_counts1, bin_arr );
% v3 = hist3.Values; 

% plot(b1(1:end-1),aver1, 'blue', 'LineStyle', ':', 'LineWidth', 2)
xlim([out.gatestart{1}-30 out.gatestop{dd}+30]);
xlabel('Time after Raman pulse, us')
ylabel('Counts per bin')
hold off;
figure(4)
hold on
 plot(b2(1:end-1),aver2, 'red', 'LineStyle', ':', 'LineWidth', 2)
% plot(b1(1:end-1),v3, 'blue');
plot(b2(1:end-1),v4, 'red');

 for dd=1:length(out.gatestart);
    line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
    line([out.gatestop{dd},out.gatestop{dd}],ylim, 'LineWidth', 2, 'LineStyle', ':','Color', 'k');
end
xlim([out.gatestart{1}-30 out.gatestop{dd}+30]);
xlabel('Time after Raman pulse, us')
ylabel('Counts per bin')
legend('detected counts', 'triggering counts')

%     hist1 = histogram(out.Allcounts{ii}{1}(:,2)-out.Allcounts{ii}{1}(:,3),2*1543);
%     v1 = hist1.Values; b1=hist1.BinEdges;
%      ex=ex+v1;
% %     hist2 = histogram(out.Allcounts{ii}{2}(:,2)-out.Allcounts{ii}{2}(:,3),2*1543)
% %     v2 = hist2.Values; b2=hist2.BinEdges;
% %     wy=wy+v2;
%     plot(b1(1:end-1),v1)
%     hold on
%     %plot(b2(1:end-1),v2)
%     %hold off
%     ylim([0 50])
%     for dd=1:length(out.gatestart);
%     line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
%     end
    %xlim([out.gatestart{1} out.gatestop{end}])
%end
% 
% subplot(4,1,4)
% plot(b1(1:end-1),ex)
%     hold on
%     plot(b2(1:end-1),wy)
%     xlim([out.gatestart{1} out.gatestop{end}])
%     for dd=1:length(out.gatestart);
%     line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
%     end

% 
% figure(33)
% subplot(2,1,1);
% %plot(b1(1:end-1),ex)
%     hold on
%     plot(b2(1:end-1),wy)
%     xlim([out.gatestart{1} out.gatestop{end}])
%     for dd=1:length(out.gatestart);
%     line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
%     
%     end
%     line([out.gatestop{end},out.gatestop{end}],ylim, 'LineWidth', 2, 'Color', 'k');
% grid minor
% %title('total clicks for APD and APD2')
% 
% xlim([out.gatestart{1}-20 out.gatestop{end}+30])
% ylim([0 50])
% 
% out.wavepacketx=b1(1:end-1);
% out.wavepackety=ex;

save out out


%% PMT histograms
% figure(33)
% 
%   subplot(2,1,2)
%     bar(sum(out.pmt_hist_sum{1}(:,:))+sum(out.pmt_hist_sum{2}(:,:))+sum(out.pmt_hist_sum{3}(:,:)))
%     ylim([0 max(sum(out.pmt_hist_sum{1}(:,:))+sum(out.pmt_hist_sum{2}(:,:))+sum(out.pmt_hist_sum{3}(:,:)))+100])
%     %line([threshold,threshold],ylim, 'LineWidth', 2, 'Color', 'k');
%     xlim([0 35])





%% - Plot density matrices

%PLOT the max-likely states, as 3D bar chart. (abs, parts)
    %indiviudal bins
    A=length(out.rhoML); 
    figure1=figure(22);
    for hh=1:A;
    
    subplot(A,2,2*hh-1);  
    AA=bar3(abs(out.rhoML{hh}));
    view([-28 24]);
    zlim([0 0.6])
    title('raw rho')
    subplot(A,2,2*hh);    
    AA=bar3(abs(out.rhoML_optrot{hh}));
    view([-28 24]);
    zlim([0 0.6])
    title('rotated rho')

    end
    title('individual bins')

    % Create textbox
annotation(figure1,'textbox',...
    [0.397428571428571 0.902380952380953 0.177571428571429 0.0642857142857151],...
    'String','Individual Bins',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off',...
    'EdgeColor','none');
    

    %cumulative bins
    if ~exist('NO_CUMULATIVE')
        B=length(out.rhoML_cum); 
        figure2=figure(222);
        for hh=1:B;

        subplot(A,2,2*hh-1);    
        bar3(abs(out.rhoML_cum{hh}));
        view([-28 24]);
        zlim([0 0.6]);
        title('raw rho')
        subplot(A,2,hh*2);    
        bar3(abs(out.rhoML_optrot_cum{hh}));
        view([-28 24]);
        zlim([0 0.6])
        title('rotated rho')
        end
        title('cumulative bins')
   

% Create textbox
    annotation(figure2,'textbox',...
    [0.397428571428571 0.902380952380953 0.177571428571429 0.0642857142857151],...
    'String','Cumulative Bins',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off',...
    'EdgeColor','none');
 end



%% plot wavepackets




%% - plot wavepackets

% %this first thing is a hangover from the way josef gets the wavepackets by
% %first plotting them as bar historgrams. Note that I clear this figure
% %right after.
%     ex=0; wy=0;
%     figure(233)
%     for ii = 1:3 
%         subplot(4,1,ii)
%         hist1 = histogram(out.Allcounts{ii}{1}(:,2)-out.Allcounts{ii}{1}(:,3),2*1543)
%         v1 = hist1.Values; b1=hist1.BinEdges;
%         ex=ex+v1;
%         hist2 = histogram(out.Allcounts{ii}{2}(:,2)-out.Allcounts{ii}{2}(:,3),2*1543)
%         v2 = hist2.Values; b2=hist2.BinEdges;
%         wy=wy+v2;
%         plot(b1(1:end-1),v1)
%         hold on
%         plot(b2(1:end-1),v2)
%         %hold off
%         ylim([0 100])
%         for dd=1:length(out.gatestart);
%         line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
%         end
%         xlim([out.gatestart{1} out.gatestop{end}])
%     end
% 
% 
%     %PLOT WAVEPACKETS
%     figure(2);
%     axes('Position', [.12, .1, .8, .2]);%[left, bottom, width, height]
%     plot(b1(1:end-1),ex,'LineWidth',2)
%      ylim([0 300])
%          hold on
%          plot(b2(1:end-1),wy,'LineWidth',2)
%          xlim([1 out.gatestop{end}])
%          for dd=1:length(out.gatestart);
%          line([out.gatestart{dd},out.gatestart{dd}],ylim, 'LineWidth', 2, 'Color', 'k');
%          end
%      grid minor
%     % title('total clicks for APD and APD2')
%     legend('APD1','APD2')
%     %set(gca,'fontsize', 18)
%     xlabel('Time, microseconds')


%% - plot purity concurrence fidelity

%first of indivudal bins
    figure(3);
    subplot(2,1,1);
    errorbar(1:length(out.purity), out.purity, out.purSTD,'sb','MarkerFaceColor' ,'b', 'MarkerSize',10,'LineWidth',2)
    hold on
   % ylim([0.5 1]);
    xlim([0 length(out.fidML)+3])
    grid minor
    xlabel('Bin')
    %ylabel('Purity')

    %subplot(3,1,2);
    errorbar((1:length(out.concurrence))+0.1, out.concurrence, out.concSTD,'^r','MarkerFaceColor' ,'r', 'MarkerSize',10,'LineWidth',2)
    %ylim([0.8 1]);
    


    %subplot(3,1,3);
    %errorbar((1:length(out.fidML))+0.2, out.fidML, out.fidSTD,'dk','MarkerFaceColor' ,'k', 'MarkerSize',10,'LineWidth',2)

    
    errorbar((1:length(out.fidopt))+0.3, out.fidopt, out.fidoptSTD,'dg','MarkerFaceColor' ,'g', 'MarkerSize',10,'LineWidth',2)
    
   % xlim([0.1, 3.9])
    ylim([0.4 1]) 
    legend('Purity','Concurrence','Fidelity-maxetang','Location','NorthEast') %'Fidelity Bell',
    set(gca,'fontsize', 18)

    
    if ~exist('NO_CUMULATIVE')

    %next of cumulative bins
        subplot(2,1,2);
        errorbar((1:length(out.purity_cum))+0, out.purity_cum, out.purSTD_cum,'sb','MarkerFaceColor' ,'b', 'MarkerSize',10,'LineWidth',2)
        hold on
      %  plot((1:length(out.purity_noise))+0, out.purity_noise, 'Marker','x','LineWidth',1.5,'MarkerFaceColor' ,'b', 'MarkerSize',10)
        hold on
        %ylim([0.5 1]);
        %xlim([0 10])
        grid minor
        xlim([0 length(out.fidML_cum)+3])

        %ylabel('Purity')

        %subplot(3,1,2);
        errorbar((1:length(out.concurrence_cum))+0.1, out.concurrence_cum, out.concSTD_cum,'^r','MarkerFaceColor' ,'r', 'MarkerSize',10,'LineWidth',2)
        hold on
      %  plot((1:length(out.purity_noise))+0, out.concurrence_noise, 'Marker','x','LineWidth',1.5,'MarkerFaceColor' ,'r', 'MarkerSize',10)
        hold on
       
        %ylabel('Concurrence')

        %subplot(3,1,3);
       % errorbar((1:length(out.fidML_cum))+0.2, out.fidML_cum, out.fidSTD_cum,'dk','MarkerFaceColor' ,'k', 'MarkerSize',10,'LineWidth',2)

    
        errorbar((1:length(out.fidopt_cum))+0.3, out.fidopt_cum, out.fidoptSTD_cum,'dg','MarkerFaceColor' ,'g', 'MarkerSize',10,'LineWidth',2)
        hold on
    %    plot((1:length(out.purity_noise))+0, out.fid_noised, 'Marker','x','LineWidth',1.5,'MarkerFaceColor',[0 1 0],'Color',[0 1 0], 'MarkerSize',10)
        hold on
%         errorbar((1:length(out.purity_noise))+0, out.fidmcmean_noise_cum,out.fidmcSTD_noise_cum, 'Marker','v','LineWidth',0.5,'MarkerFaceColor',[0 1 0],'Color',[0 1 0], 'MarkerSize',10)
ylim([0.4 1])   
    end
    %legend('Purity','P','Concurrence','C', 'Fidelity Bell','Fidelity-maxetang','F', 'F noised','Location','NorthEast')
     legend('Purity','Concurrence', 'Fidelity-maxetang',  'Location','NorthEast') %'Fid ideal+background',
    set(gca,'fontsize', 18)

    for iii = 1:length(out.rhoML)
%     histogram(out.concmc(iii,:), [1:100]/100)%, 'FaceColor', 'none', 'EdgeColor', 'auto', 'LineWidth', '3');
%     for jjj = 1:4
%         FID(iii,jjj) = mixedfid(out.rhoML{iii}, out.rhoML{jjj});
%     end;
    real([out.probs{iii}, out.P{iii}, round((out.probs{iii}- out.P{iii})*100)])
    sum(abs(((out.probs{iii}- out.P{iii}))))/length(out.probs{iii})
end
    
    %--------------noised
%     figure(300)
%     plot((1:length(out.purity_noise))+0, out.purity_noise, 'sb','MarkerFaceColor' ,'b', 'MarkerSize',10)
%     hold on
%     %ylim([0.5 1]);
%     %xlim([0 10])
%     grid minor
%     xlim([0 length(out.fidML_cum)+3])
% 
%     %ylabel('Purity')
% 
%     %subplot(3,1,2);
%      plot((1:length(out.purity_noise))+0, out.concurrence_noise, '^r','MarkerFaceColor' ,'r', 'MarkerSize',10)
%     %ylabel('Concurrence')
%     %subplot(3,1,3);
%      plot((1:length(out.fid_noised))+0, out.fid_noised, 'dg','MarkerFaceColor' ,'g', 'MarkerSize',10)
% 
%    
% 
%     legend('Purity','Concurrence','Fidelity Bell','Fidelity-maxetang','Location','NorthEast')
%     set(gca,'fontsize', 18)














 %% - see how well the found max-likely state matches data

% %cprbML=zeros(9,4);
% 
% for ii=1:36;
% 
%     AA(ii)=trace(ps(:,:,ii)*out.rhoML{hh});
%     
% end
% 
% probs_fromRhoML=reshape(real(AA),4,9);
% probs_fromRhoML=probs_fromRhoML'
% 
% out.probs_fromRhoML=probs_fromRhoML;
%     
% CC=probs_fromRhoML-  tomo_matrix1
% 
% probdifferences=sum(sum(abs(CC)))
% 
% figure(3*gg);subplot(2,1,2); imagesc(out.tomo_matrix1{hh})
% subplot(2,1,1); imagesc(probs_fromRhoML)
% 
% 
% %out0ms=out;
% 
% %save out0ms out0ms

