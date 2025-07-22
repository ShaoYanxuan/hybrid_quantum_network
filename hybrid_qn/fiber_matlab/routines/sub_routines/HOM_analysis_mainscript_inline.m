%===========================================Oct 29 based on Sept 3 ===================
%inline substitution for the script that has a loop over timetags files and
%parameters definitions
% this scripts works with a newr measurements that have normalization
% attempt right after HOM attemt    

%%
%--------------------------------------analysing efficiencies-------and wavepackets---
        
    gate_len_us = gate(2)-gate(1);
    
    
    channeldata1_converted = analyse_counts(TAGS_HOM{nfile}, 2,   histlength,TriggerCH   ); 
    channeldata2_converted = analyse_counts(TAGS_HOM{nfile}, 6, histlength,TriggerCH ); 
    attempts(nfile) = channeldata1_converted.attempts;
    
    It = 1;
    figure(It+100*nfile)
    ch1 = histogram(channeldata1_converted.time_diff, bin_arr);
    hold on
    xlabel('Time delay, us')
    ylabel('Counts per per bin')
    title(sprintf('CH2 first run %.1f us bin, %.1e raman pulses file %d', dt,channeldata1_converted.attempts, nfile ))
    xlim([0 histlength])
    grid on
    draw_gate(gate, It+100*nfile, 'blue') 
    draw_gate(gate_disting, It+100*nfile, 'red') 
    draw_gate(gate_disting+delay_disting, It+100*nfile, 'red') 
    [eff_sum(It, nfile), noise_prob_sum(It, nfile)] =efficiency_from_hystogram3(ch1.BinCounts, It+100*nfile, channeldata1_converted.attempts, gate, bin_arr, noise_del, noise_window, 0);
    [eff_long(It, nfile), noise_prob_long(It, nfile)] =efficiency_from_hystogram3(ch1.BinCounts, It+100*nfile, channeldata1_converted.attempts, gate_disting, bin_arr, noise_del, noise_window, 0);
    [eff_short(It, nfile), noise_prob_short(It, nfile)] =efficiency_from_hystogram3(ch1.BinCounts, It+100*nfile,channeldata1_converted.attempts, gate_disting+delay_disting, bin_arr, noise_del, noise_window, 0);
    
    It = 2;
    figure(It+100*nfile)
    ch2 = histogram(channeldata2_converted.time_diff, bin_arr);
    xlabel('Time delay, us')
    ylabel('Counts per per bin')
    title(sprintf('CH6 first run %.1f us bin, %.1e raman pulses, file %d', dt,channeldata1_converted.attempts, nfile ))
    grid on
    draw_gate(gate, It+100*nfile, 'blue') 
    draw_gate(gate_disting, It+100*nfile, 'red') 
    draw_gate(gate_disting+delay_disting, It+100*nfile, 'red') 
    [eff_sum(It, nfile), noise_prob_sum(It, nfile)] =efficiency_from_hystogram3(ch2.BinCounts, It+100*nfile, channeldata1_converted.attempts, gate, bin_arr, noise_del,noise_window, 0);
    [eff_long(It, nfile), noise_prob_long(It, nfile)] =efficiency_from_hystogram3(ch2.BinCounts, It+100*nfile, channeldata1_converted.attempts, gate_disting, bin_arr, noise_del, noise_window, 0);
    [eff_short(It, nfile), noise_prob_short(It, nfile)] =efficiency_from_hystogram3(ch2.BinCounts, It+100*nfile, channeldata1_converted.attempts, gate_disting+delay_disting, bin_arr, noise_del, noise_window, 0);

    
    bin_ar = bin_arr(1:length(bin_arr)-1);
    clear tosave
    tosave(:,1) = bin_ar;
    tosave(:, 2)= ch1.BinCounts/channeldata1_converted.attempts;
    tosave(:, 3) = ch1.BinCounts;
    tosave(:, 4)= ch2.BinCounts/channeldata1_converted.attempts;
    tosave(:, 5) = ch2.BinCounts;
    save(sprintf('%sWavepackets%.0fMHz_%d_sn%d_g%d.txt', fold, Rabi_freq, nfile, subtract_noise, subtract_G)', 'tosave', '-ascii')
    events_prob = ch1.BinCounts/channeldata1_converted.attempts - noise_prob_long(1)/gate_length;
    
    if(nfile ==1)
        averaged_wp(:,1) =  bin_ar;
        averaged_wp(:, 3) = ch1.BinCounts;
        averaged_wp(:, 5) =  ch2.BinCounts;
    else
        averaged_wp(:, 3) = averaged_wp(:, 3)+ch1.BinCounts(:);
        averaged_wp(:, 5) = averaged_wp(:, 5)+ch2.BinCounts(:);
    end
    if(nfile == MaxFile)
        averaged_wp(:, 2) = averaged_wp(:, 3)/sum(attempts);
        averaged_wp(:, 4) = averaged_wp(:, 5)/sum(attempts);
        save(sprintf('%sWavepackets%.0fMHz_av_sn%d_g%d.txt', fold, Rabi_freq, subtract_noise, subtract_G)', 'averaged_wp', '-ascii')
        figure(2)
         plot(bin_ar, averaged_wp(:, 3), '.-')
         hold on
         plot(bin_ar, averaged_wp(:, 5), '.-')
         title('First and second channel total')
         xlabel('Time delay, us')
          ylabel('counts per bin')
          grid on
          
        attempts
        eff_long
        eff_short
    
    end
     
%%    
    %----------------------Advanced-------------------(wavepackets comparison)----------------
%     figure(1+100*nfile)
%     hold on
%     plot(bin_ar+delay_disting,ch1.BinCounts*eff_short(1)/eff_long(1), '--' )
    
      figure(3+100)%*nfile)
      
      plot(bin_ar, events_prob, '.-')%, 'color', 'blue')
      draw_gate(gate, 3+100, 'blue') 
    draw_gate(gate_disting, 3+100, 'red') 
    draw_gate(gate_disting+delay_disting, 3+100, 'red') 
      hold on
      
       figure(5+100*nfile)
      hold on
      plot(bin_ar+delay_disting, ch1.BinCounts, '.-', 'color', 'blue')
      plot(bin_ar, eff_long(1, nfile)/eff_short(2, nfile)*ch2.BinCounts, '.-', 'color', 'red')
%     plot(bin_ar+del_to_reference+delay_disting, events_prob*eff_short(1)/eff_sum(1), '.-', 'color', 'red')
%     hold on
%     xlabel('Time delay, us')
%     ylabel('Event prob per bin')
%     title(sprintf('delayed channels comparison, %.1f us bin', dt ))
     grid on
%     xlim(gate_disting_big)
%     
%     figure(4+100*nfile)
%     plot(bin_ar, ch1.BinCounts, '.-', 'color', 'blue')
%     hold on
%     %plot(bin_ar, ch2.BinCounts*eff_long(1)/eff_long(2), '.-', 'color', 'red')
%    % plot(bin_ar, eff_long(1, nfile)/eff_short(2, nfile)*ch2.BinCounts, '.-', 'color', 'red')
%     plot(bin_ar, ch2.BinCounts, '.-', 'color', 'red')
%     xlabel('Time delay, us')
%     ylabel('Event prob per bin')
%     title(sprintf('direct and delayed channels comparison, %.1f us bin', dt ))
%     grid on
%     xlim([0 histlength])
%      
    
   %%
   % Here we start coincuidences ana;ysis
   %first we do integrated curves, fig 15, 14 aka Dario style
   %then we do histograms with different binning
    
    
    hist_range = histlength;
    bin_ar = bin_arr(1:length(bin_arr)-1);
    figure_range = [-1*(gate_disting_big(2)+w); gate_disting_big(2)+w];
    noise_window = 20;
    int_range = [-1*gate_len_us gate_len_us];
    [gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(bin_arr, int_range);
    [gate_stop_bin_i, gate_start_bin_i, gate_length_i, zer_i] =bin_numbers_from_gate(bin_arr,gate_disting_big);  
    [gate_stop_bin_s, gate_start_bin_s, gate_length_S, zer_s] = bin_numbers_from_gate(bin_arr-delay_rep_rate, int_range);
    coinc_gate = [-1*gate_len_us gate_len_us];
    coinc_gate_len_us = coinc_gate(2)-coinc_gate(1);  
    %%
%     %--------------------------------coincedence analysis integrated--------------------
%     
%     %--indistinguishable case ----
%     %draw_gate( [gate(1), gate(2)+w], 1+100*nfile, 'black') 
%     Coinc_HOM1 = analyse_coincidendes(gated(TAGS_HOM{nfile}, 6, [gate(1), gate(2)+w]), maxdel, gate, 2, 6);
%     figure(100*nfile+8)
%     H = histogram(Coinc_HOM1.eventdiff, bin_arr);
%     xlabel('Detection events time difference, us')
%     ylabel('Number of coincedences per bin')
%     title(sprintf('Overlapped in time photon coincidences  %.1f us bin', dt))
%     HOM1 = H.BinCounts;
%    
%     HOM1_r = poissrnd1( (zeros(MC_samples,1)+1)*HOM1);
%     HOM1(gate_start_bin:gate_stop_bin) = HOM1(gate_start_bin:gate_stop_bin)-HOM1(gate_start_bin_s:gate_stop_bin_s)*G2err;%double events correction   
%     HOM1_r(:,gate_start_bin:gate_stop_bin) = HOM1_r(:,gate_start_bin:gate_stop_bin)-HOM1_r(:,gate_start_bin_s:gate_stop_bin_s)*G2err; 
%     if(nfile == 1)
%         Total = HOM1;
%         Total_r = HOM1_r;
%     else
%         Total = Total+HOM1;
%         Total_r = Total_r+HOM1_r;
%     end;
%     Total_attempts = Total_attempts+Coinc_HOM1.attempts;
% 
%     [coinc_prob(1), noise_C_prob(1)] = efficiency_from_hystogram3( HOM1, 100*nfile+8, Coinc_HOM1.attempts,  coinc_gate , bin_arr, 10, noise_window);
%     if(noise_C_prob(1)*Coinc_HOM1.attempts)
%         noise_C_prob_err = 1/sqrt(noise_C_prob(1)*Coinc_HOM1.attempts/(coinc_gate(2)-coinc_gate(1))*noise_window);
%     else
%         noise_C_prob_err = 0;
%     end;
%         
%     for MC_i = 1: MC_samples
%         [coinc_r_prob( MC_i,1), noise_r_C_prob( MC_i, 1)] = efficiency_from_hystogram3( HOM1_r( MC_i,:), 100*nfile+8, Coinc_HOM1.attempts,  coinc_gate , bin_arr, 10, noise_window);
%     end
%     draw_gate( coinc_gate , 100*nfile+8, 'blue') 
%     
%     correction =1;
%     for ii = 1:( gate_stop_bin- gate_start_bin)
%          binsize(ii) = dt*ii*2;
%          HOM_value_cumm(ii) =sum(HOM1(zer-ii:zer+ii-1));
%          HOM_value_cumm_norm(ii) =  HOM_value_cumm(ii)/(Coinc_HOM1.attempts)-subtract_noise*noise_C_prob(1)/coinc_gate_len_us*binsize(ii);
%          
%          HOM_r_value_cumm(:,ii) =sum(HOM1_r(:, zer-ii:zer+ii-1), 2);
%          HOM_r_value_cumm_norm(:,ii) =  HOM_r_value_cumm(:, ii)/(Coinc_HOM1.attempts)-subtract_noise*noise_r_C_prob(:,1)/coinc_gate_len_us*binsize(ii);
%         
%      end;
%     if nfile == 1
%         HOM_value_cumm_total =HOM_value_cumm;
%         HOM_value_cumm_norm_total =HOM_value_cumm_norm;
%         HOM_r_value_cumm_norm_total =HOM_r_value_cumm_norm;
%     else
%         HOM_value_cumm_total  =HOM_value_cumm +HOM_value_cumm_total ;
%         HOM_value_cumm_norm_total  =HOM_value_cumm_norm +HOM_value_cumm_norm_total *(nfile-1);
%         HOM_r_value_cumm_norm_total  =HOM_r_value_cumm_norm +HOM_r_value_cumm_norm_total *(nfile-1);
%     end
%      HOM_value_cumm_norm_total  =HOM_value_cumm_norm_total /(nfile);
%      HOM_r_value_cumm_norm_total  =HOM_r_value_cumm_norm_total /(nfile);
%       
%     %distinguishable case ----------------------------------------
%     draw_gate( [gate_disting_big(1),gate_disting_big(2)+w ], 1+100*nfile, 'red') 
%     draw_gate( [gate_disting_big(1),gate_disting_big(2)], 1+100*nfile, 'red') 
%     Coinc_P1 = analyse_coincidendes(gated(TAGS_HOM{nfile}, 6, [gate_disting_big(1),gate_disting_big(2)+w ]), maxdel, gate_disting_big, 2, 6);
%     figure(100*nfile+7)
%     H = histogram(Coinc_P1.eventdiff, bin_arr);
%     xlabel('Detection events time difference, us')
%     ylabel('Number of coincedences per bin')
%     title(sprintf('Displaced in time photon coincidences  %.1f us bin', dt))
%     HOM2 = H.BinCounts;
%     pairs(nfile) = sum(HOM2(gate_start_bin_i: gate_stop_bin_i))
%     HOM2_r = poissrnd1( (zeros(MC_samples,1)+1)*HOM2);
%     HOM2(gate_start_bin:gate_stop_bin) = HOM2(gate_start_bin:gate_stop_bin)-HOM2(gate_start_bin_s:gate_stop_bin_s)*G2err;
%     HOM2_r(:,gate_start_bin:gate_stop_bin) = HOM2_r(:,gate_start_bin:gate_stop_bin)-HOM2(:,gate_start_bin_s:gate_stop_bin_s)*G2err;
%   
%     if(nfile == 1)
%         Total2 = HOM2;
%         Total2_r = HOM2_r;
%     else
%         Total2 = Total2+HOM2;
%         Total2_r = Total2+HOM2_r;
%     end;
%     [coinc_prob(2), noise_C_prob(2)] = efficiency_from_hystogram3(HOM2, 100*nfile+7, Coinc_P1.attempts,  coinc_gate +delay_disting, bin_arr, 10,noise_window );
%     [coinc_prob_t, noise_C_prob_t] = efficiency_from_hystogram3(HOM2, 100*nfile+7, Coinc_P1.attempts,  coinc_gate -delay_disting, bin_arr, 10,noise_window);
%     coinc_prob(2) = coinc_prob(2)+coinc_prob_t;    % yes it's strange
%     draw_gate(gate_disting_big, 100*nfile+7, 'red') 
%     
%   %  draw_gate( coinc_gate +delay_disting, 100*nfile+7, 'red') 
%     
%     [gate_stop_bin1, gate_start_bin1, gate_length1, zer] = bin_numbers_from_gate(bin_arr+delay_disting, int_range);
%     [gate_stop_bin2, gate_start_bin2, gate_length2, zer2] = bin_numbers_from_gate(bin_arr-delay_disting, int_range);
%     for ii = 1:( gate_stop_bin- gate_start_bin)
%         Perp_value_cumm(ii) =sum(HOM2(zer-ii:zer+ii-1))+sum(HOM2(zer2-ii:zer2+ii-1));
%         Perp_value_cumm_norm(ii) =correction*Perp_value_cumm(ii)/(Coinc_P1.attempts)-subtract_noise*noise_C_prob(1)/coinc_gate_len_us*binsize(ii);%0*noise_C_prob(2);
%         
%         Perp_value_cumm_r(:,ii) =sum(HOM2_r(:,zer-ii:zer+ii-1),2)+sum(HOM2_r(:,zer2-ii:zer2+ii-1),2);
%         Perp_value_cumm_norm_r(:,ii) =correction*Perp_value_cumm_r(:,ii)/(Coinc_P1.attempts)-subtract_noise*noise_C_prob(1)/coinc_gate_len_us*binsize(ii);
%     end;
%      if nfile == 1
%         Perp_value_cumm_total =Perp_value_cumm;
%         Perp_value_cumm_norm_total =Perp_value_cumm_norm;
%         Perp_value_cumm_norm_total_r =Perp_value_cumm_norm_r;
%      else
%           Perp_value_cumm_total  =Perp_value_cumm +Perp_value_cumm_total ;
%           Perp_value_cumm_norm_total  =Perp_value_cumm_norm +Perp_value_cumm_norm_total *(nfile-1);
%           Perp_value_cumm_norm_total_r  =Perp_value_cumm_norm_r +Perp_value_cumm_norm_total_r *(nfile-1);
%      end
%     
%     Perp_value_cumm_norm_total  =Perp_value_cumm_norm_total /(nfile);
%     Perp_value_cumm_norm_total_r  =Perp_value_cumm_norm_total_r /(nfile);
%     
% %     if(nfile == MaxFile)
% %         figure(14) %averaged over files
% %         for MC_i = 1: MC_samples
% %            plot(binsize, HOM_r_value_cumm_norm_total(MC_i, :),'-', 'color',[0.800000011920929 0.800000011920929 0.800000011920929]); 
% %            hold on
% %         end
% %         for MC_i = 1: MC_samples
% %            plot(binsize, Perp_value_cumm_norm_total_r(MC_i, :),'-', 'color',[0.800000011920929 0.800000011920929 0.800000011920929]); 
% %            hold on
% %         end
% %         errorbar(binsize, HOM_value_cumm_norm_total, HOM_value_cumm_norm_total./sqrt(HOM_value_cumm_total), 'color', 'blue')
% %         hold on
% %         errorbar(binsize, Perp_value_cumm_norm, Perp_value_cumm_norm_total./sqrt(Perp_value_cumm_total), 'color', 'red')
% %         xlabel('Binsize, us')
% %         ylabel('Coincedence probability')
% %         title(sprintf('Overlapped (blue) and displaced in time (red) integrated\n drive %.1f MHz average of all files', Rabi_freq))
% %         grid('on')
% %         xlim([0 (int_range(2)-int_range(1))])
% %     end
% %     figure(100*nfile+14)
% %     errorbar(binsize, HOM_value_cumm_norm, HOM_value_cumm_norm./sqrt(HOM_value_cumm), 'color', 'blue')
% %     hold on
% %     errorbar(binsize, Perp_value_cumm_norm, Perp_value_cumm_norm./sqrt(Perp_value_cumm), 'color', 'red')
% %     hold on
% %     xlim([0 (int_range(2)-int_range(1))])
% %     xlabel('Binsize, us')
% %     ylabel('Coincedence probability')
% %     title(sprintf('Overlapped (blue) and displaced in time (red) integrated\n drive %.1f MHz file %d ', Rabi_freq, nfile ))
% %     grid('on')
% %     
% %     HOM_ratio = HOM_value_cumm_norm./Perp_value_cumm_norm;
% %     HOM_ratio_err = HOM_ratio.*sqrt((1./sqrt(HOM_value_cumm)).^2+(1./sqrt(Perp_value_cumm)).^2);
% %     HOM_ratio_total = HOM_value_cumm_norm_total./Perp_value_cumm_norm_total;
% %     HOM_ratio_err_total = HOM_ratio_total.*sqrt((1./sqrt(HOM_value_cumm_total)).^2+(1./sqrt(Perp_value_cumm_total)).^2);
% %     HOM_ratio_total_r = HOM_r_value_cumm_norm_total./Perp_value_cumm_norm_total_r;
% %     if(nfile == MaxFile)
% %         figure(15) %averaged over files
% %          for MC_i = 1: MC_samples
% %            plot(binsize,  HOM_ratio_total_r (MC_i, :),'-', 'color',[0.800000011920929 0.800000011920929 0.800000011920929]); 
% %            hold on
% %         end
% %         errorbar(binsize, HOM_ratio_total, HOM_ratio_err_total, 'color', 'blue');
% %         xlabel('Bin size, us')
% %         ylabel('Ratio of coincedences')
% %         title(sprintf('1-contrast, Drive %.1f MHz average of all experiments', Rabi_freq))
% %         grid('on')
% %         xlim([0 (int_range(2)-int_range(1))])
% %     end
% %     figure(100*1+15) %100*nfile+15 
% %     errorbar(binsize, HOM_ratio, HOM_ratio_err, 'LineWidth', 2)%, 'color', 'blue');
% %     hold on
% %     xlabel('Bin size, us')
% %     ylabel('Ratio of coincedences')
% %     title(sprintf('1-contrast, Drive %.1f MHz, file %d', Rabi_freq, nfile))
% %     grid('on')
% %     xlim([0 (int_range(2)-int_range(1))])
% %     
% %     %saving  (averaged) 
% %     fordario(:,1) = binsize;
% %     fordario(:,2) = HOM_value_cumm_norm_total;
% %     fordario(:,5) = HOM_value_cumm_norm./sqrt(HOM_value_cumm);
% %     fordario(:,3) = Perp_value_cumm_norm_total;
% %     fordario(:,6) = Perp_value_cumm_norm./sqrt(Perp_value_cumm);
% %     fordario(:,4) = 1-HOM_ratio_total;
% %     fordario(:,7) = HOM_ratio_err_total;
% %     save(sprintf('%sintegral_%.0fMHz_av_sn%d_g%d.txt', fold, Rabi_freq, subtract_noise, subtract_G)', 'fordario', '-ascii')
%     
%     %------------------------------------------end integrated 
% 
%     
%     %%
%     %=============-plotting for different bins-===============================================================================================================   
%     Total_attemptsb = 0;
%     if(~exist('binwidths'))
%         binwidths = [0.5 1];    %select desired bins set here 
%     end
%     for i = 1:length(binwidths)   
%         dt = binwidths(i);
%         bin_arr = [-hist_range:dt:hist_range];
%         [gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(bin_arr, int_range);
%         [gate_stop_bin2, gate_start_bin2, gate_length2, zer2] = bin_numbers_from_gate(bin_arr-delay_rep_rate, int_range);
%         figure(100*nfile+11)
%         H = histogram(Coinc_HOM1.eventdiff, bin_arr);
%         HOMb0 = H.BinCounts;
%         HOMb = HOMb0;
%         HOMb(gate_start_bin:gate_stop_bin) = HOMb0(gate_start_bin:gate_stop_bin)-HOMb0(gate_start_bin2:gate_stop_bin2)*G2err;
%         
%         figure(100*nfile+15+i)
%         hist_overlaped = (HOMb/Coinc_HOM1.attempts-subtract_noise*noise_C_prob(1)/coinc_gate_len_us*dt)/dt/1e-6;
%         error_overlaped = sqrt(HOMb0/(Coinc_HOM1.attempts*dt*1e-6)^2  + ((subtract_noise*noise_C_prob(1)/coinc_gate_len_us/1e-6)*noise_C_prob_err)^2);
%         %errorbar(bin_arr(1:length(bin_arr)-1),hist_overlaped, sqrt(correction*HOMb0)/(Coinc_HOM1.attempts)/dt/1e-6,'.-','MarkerSize', 15)
%         errorbar(bin_arr(1:length(bin_arr)-1),hist_overlaped, error_overlaped,'.-','MarkerSize', 15)
%         hold on
%         figure(100*nfile+11)
%              
%         H = histogram(Coinc_P1.eventdiff, bin_arr);
%         HOMb20 = H.BinCounts;
%         HOMb2 = HOMb20;
%         HOMb2(gate_start_bin:gate_stop_bin) = HOMb20(gate_start_bin:gate_stop_bin)-HOMb20(gate_start_bin2:gate_stop_bin2)*G2err;        
%        
%         figure(100*nfile+15+i)
%         % gate_start_bin and gate_stop_bin are determined in bin_numbers_from_gate
%         hist_displaced = correction*(HOMb2/Coinc_P1.attempts-subtract_noise*noise_C_prob(1)/coinc_gate_len_us*dt)/dt/1e-6;
%         error_displaced = sqrt(HOMb20/(Coinc_HOM1.attempts*dt*1e-6)^2  + ((subtract_noise*noise_C_prob(1)/coinc_gate_len_us/1e-6)*noise_C_prob_err)^2);
%         %errorbar(bin_arr(1:length(bin_arr)-1),hist_displaced, sqrt(correction*HOMb20)/(Coinc_P1.attempts)/dt/1e-6,'.-','MarkerSize', 15)
%         errorbar(bin_arr(1:length(bin_arr)-1),hist_displaced, error_displaced,'.-','MarkerSize', 15)
%         xlim(figure_range)
%         xlabel('Detection events time difference, us')
%         ylabel('Coincedence per sec')
%         title(sprintf('Overlapped (blue) and displaced in time (red) %.1f us bin \n file number %d', dt, nfile))
%         grid('on')
% 
%     %-----averaged----------attempts should be equal --
%         if(nfile == 1)
%             Total_b{i} = hist_overlaped;
%             Total_b2{i} = hist_displaced;
%            % Total_b0{i} = HOMb0;
%            % Total_b02{i} = HOMb20;
%             Total_err{i} = error_overlaped.^2;
%             Total_err2{i} = error_displaced.^2;
%             
%         else
%             Total_b{i} = Total_b{i}*(nfile-1)+hist_overlaped;
%             Total_b2{i} = Total_b2{i}*(nfile-1)+hist_displaced;
%          %   Total_b0{i} = Total_b0{i}+HOMb0;
%          %   Total_b02{i} =Total_b02{i}+ HOMb20;
%             Total_err{i} = Total_err{i}+error_overlaped.^2;
%             Total_err2{i} = Total_err2{i}+error_displaced.^2;
%         end
%          
%         Total_b{i} = Total_b{i}/nfile;
%         Total_b2{i} = Total_b2{i}/nfile;
%         Total_attemptsb = Total_attemptsb+Coinc_HOM1.attempts;
%         if(nfile == MaxFile)
%             Total_err{i} = sqrt(Total_err{i})/nfile;
%             Total_err2{i} = sqrt(Total_err2{i})/nfile;
%             figure(15+i)
%             errorbar(bin_arr(1:length(bin_arr)-1),Total_b{i}, Total_err{i},'.--','MarkerSize', 15)
%             hold on
%             errorbar(bin_arr(1:length(bin_arr)-1),correction*(Total_b2{i}), Total_err2{i},'.','MarkerSize', 15)
%             xlim(figure_range)
%             xlabel('Detection events time difference, us')
%             ylabel('Coincedence per sec')
%             title(sprintf('Averaged overlapped (blue) and displaced in time (red) %.1f us bin', dt))
%             grid('on')
%             
%             %save averaged
%             clear tosave
%             tosave(:,1) = bin_arr(1:length(bin_arr)-1);
%             tosave(:, 2)= Total_b{i};                % overlapped probability per unit time noise corrected
%             tosave(:, 3)= Total_err{i};  
%             tosave(:, 4) = correction*(Total_b2{i});     % displaced probability per unit time noise corrected
%             tosave(:, 5)= Total_err2{i};  
%             save(sprintf('%sdistribution%.0fMHz_%dus_av_sn%d_g%d.txt', fold, Rabi_freq, dt, subtract_noise, subtract_G)', 'tosave', '-ascii')
%         end
%   %-------------
%          clear tosave
%          % save for each file
%         tosave(:,1) = bin_arr(1:length(bin_arr)-1);   
%         tosave(:, 2)= hist_overlaped;                % overlapped probability per unit time noise corrected
%         tosave(:, 3) = error_overlaped;
%         tosave(:, 4) = hist_displaced;     % displaced probability per unit time noise corrected
%         tosave(:, 5) = error_displaced; 
%         save(sprintf('%sdistribution%.0fMHz_%dus_%d_sn%d_g%d.txt', fold, Rabi_freq, dt, nfile, subtract_noise, subtract_G)', 'tosave', '-ascii')
%         
%         close(figure(100*nfile+11))
%          close(figure(100*nfile+8))
%  end
%    
