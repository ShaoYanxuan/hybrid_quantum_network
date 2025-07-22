function [wavepacket, distribution, ratio] = plots_from_dario_trajectory(fname, gate, dt, histlength )
%===========================================Oct 3, 2019 ===================
%by viktor based on  HOManalysis_MC_theory_2019_09_04


MC_samples = 1;
%--------------
%loading
bin_arr = -histlength:dt:histlength;
bin_ar = bin_arr(1:length(bin_arr)-1);
int_range = [-1*histlength/2 histlength/2];
[gate_stop_bin, gate_start_bin, gate_length, zer] = bin_numbers_from_gate(bin_arr, int_range);  
    Input0= load(fname)/2/pi;
    if (1)
        Input(:,1) = Input0(:,3);
        Input(:,2) = Input0(:,4);
        Input(:,3) = Input0(:,1);
        Input(:,4) = Input0(:,2);
    else
        Input = Input0;
    end
    NN = length(Input(:, 1));
    k = 0;
    kk = 0;
    tch = 1;  % impossible events counter
%      figure(21)
%      hist(Input(:, 1), bin_arr)
     figure(22)
     wp = histogram(Input(:, 3), bin_arr);
    
     wavepacket(:, 1) = bin_ar;
     
%      figure(23)
%      hist(Input(:, 3), bin_arr)
%     figure(24)
%     hist(Input(:, 4), bin_arr)

    
    for i = 1:NN               
        %flaging
        if(Input(i,3) > gate(1) && Input(i,3) < gate(2) && Input(i,4) > gate(1) && Input(i,4) < gate(2))
            k = k+1;
            coinc_all_tdiff(k) = Input(i,4)-Input(i,3);    %all events
            check_double_UV = 0;
            if(  (Input(i,3) > Input(i,1) && Input(i,4) < Input(i,1))) 
               kk = kk +1;
                coinc_disting_tdiff(kk) = Input(i,4)-Input(i,3);
                check_double_UV = 1;
            end;
            if( (Input(i,3) < Input(i,2) && Input(i,4) > Input(i,2)))   % scattering 2
                if (~check_double_UV)
                    kk = kk +1;
                    coinc_disting_tdiff(kk) = Input(i,4)-Input(i,3);
                else
                    tch = tch +1;
                    this_cannot_happen(tch) = i;
                end
            end;
        end;
    end;
    clear H
    figure(1001)
    H = histogram(coinc_disting_tdiff, bin_arr);
    HOM1 = H.BinCounts;                %here are distinguishable counts now
    clear H
    figure(1002)
    H = histogram( coinc_all_tdiff, bin_arr);
    HOM_P = H.BinCounts;                % here are all coincidences 

    distribution(:, 1) = bin_ar;
    distribution(:, 2) = HOM1;
    distribution(:, 3) = HOM_P;
    
    
    HOM1_r = poissrnd1( (zeros(MC_samples,1)+1)*HOM1);         % randomised data for Monte-Carlo
    HOM_P_r = poissrnd1( (zeros(MC_samples,1)+1)*HOM_P);
    attempts = i;

    
    for ii = 1:( gate_stop_bin- gate_start_bin)         %integration 
         binsize(ii) = dt*ii*2;
         %integration of distinguishable counts (blue curve in my blogposts)
         HOM_value_cumm(ii) =sum(HOM1(zer-ii:zer+ii-1));
         HOM_value_cumm_norm(ii) =  HOM_value_cumm(ii)/(attempts);

         HOM_r_value_cumm(:,ii) =sum(HOM1_r(:, zer-ii:zer+ii-1), 2);          %MC randomized data integration
         HOM_r_value_cumm_norm(:,ii) =  HOM_r_value_cumm(:, ii)/(attempts);

         %integration of all counts (red curve in my blogposts)
         P_value_cumm(ii) =sum(HOM_P(zer-ii:zer+ii-1));
         P_value_cumm_norm(ii) =  P_value_cumm(ii)/(attempts);

         P_r_value_cumm(:,ii) =sum(HOM_P_r(:, zer-ii:zer+ii-1), 2);           %MC randomized data integration
         P_r_value_cumm_norm(:,ii) =  P_r_value_cumm(:, ii)/(attempts);
    end;

    
    HOM_ratio = HOM_value_cumm_norm./P_value_cumm_norm;                        % THIS WILL BE THE VISIBILITY CURVE
    HOM_ratio_err = HOM_ratio.*sqrt((1./sqrt(HOM_value_cumm)).^2+(1./sqrt(P_value_cumm)).^2);
    HOM_ratio_r = HOM_r_value_cumm_norm./P_r_value_cumm_norm;
    
    wavepacket(:, 2) = wp.BinCounts/attempts;
      wavepacket(zer, 2) = 0;
     distribution(:, 2) = distribution(:, 2) /attempts;
    distribution(:, 3) =  distribution(:, 3)/attempts;
    ratio(:,1)  = binsize;
    ratio(:,2)  =HOM_ratio;
    ratio(:,3)  = HOM_ratio_err;
    close(22);
    close(1002);
    close(1001);

   
    



            