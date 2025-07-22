function [ratio] = integrated_from_Basel(rescale, background, basel_file_hom, basel_file_normalization, delay_disting, range)
%===========================================Oct 3, 2019 ===================
%by viktor based on  HOManalysis_MC_theory_2019_09_04

%=================================Basel data======================================================== 
basel_HOM = load(basel_file_hom);
basel_P = load(basel_file_normalization);
basel_HOM(:,2) = basel_HOM(:,2)*rescale + background;
basel_P(:,2) = basel_P(:,2)*rescale + background;
dt1 = basel_HOM(2,1)-basel_HOM(1,1);
if(basel_P(2,1)-basel_P(1,1) ~= dt1)
    different_time_steps_Basel_files 
end

HOM_value_cumm_bt(1)=0;%basel_HOM(1,2);
P_value_cumm_bt(1) = 0;
%P_value_cumm_bt(1) = sum(basel_P(1:round((delay_disting-basel_P(1,1))/dt1),2));    %test Azadeh's integration [0 to delay+T} instead [delay-T to delay +T]

binsize1(1) = 0; 
for ii = 2:min([length(basel_HOM(:,2)) , round(length(basel_P(:,2))/2)-1, round(range/2/dt1)+1, fix((delay_disting-basel_P(1,1))/dt1)+1, fix((-delay_disting+basel_P(end,1))/dt1)+1] ) %0.5*( gate_stop_bin- gate_start_bin)         %integration 
     binsize1(ii) = 2*dt1*(ii-1);
     %integration of distinguishable counts (blue curve in my blogposts)
     %HOM_value_cumm_bt(ii) =sum(basel_HOM(1:ii,2));
     HOM_value_cumm_bt(ii) =HOM_value_cumm_bt(ii-1) + 0.5*(basel_HOM(ii,2)+(basel_HOM(ii-1,2)));

     %integration of all counts (red curve in my blogposts)
    % P_value_cumm_bt(ii) =sum(  basel_P(round(delay_disting/dt1)-ii+1:round(delay_disting/dt1)+ii-2,2)); %um(basel_P(zer1-ii:zer1+ii-1),2)+
    P_value_cumm_bt(ii) =P_value_cumm_bt(ii-1) + (basel_P(round((delay_disting-basel_P(1,1))/dt1)-ii+1, 2)+ basel_P(round((delay_disting-basel_P(1,1))/dt1)-ii+2, 2))*0.5         + 0.5*(basel_P(round((delay_disting-basel_P(1,1))/dt1)+ii-2,2)+basel_P(round((delay_disting-basel_P(1,1))/dt1)+ii-1,2));
  
    %test Azadeh's integration [0 to delay+T} instead [delay-T to delay +T]:   %P_value_cumm_bt(ii) =P_value_cumm_bt(ii-1)       + 0.5*(basel_P(round((delay_disting-basel_P(1,1))/dt1)+ii-2,2)+basel_P(round((delay_disting-basel_P(1,1))/dt1)+ii-1,2));
    
 end;
 ratio(:, 1) = binsize1;
 ratio(:, 2) =  HOM_value_cumm_bt./P_value_cumm_bt;
 ratio(:, 3) = 2*P_value_cumm_bt*dt1*1e-6;  % 2 because integrating over two sides, dt1*1e-6 - step

 
%%  tests

%   figure()
%  plot( binsize1, HOM_value_cumm_bt./P_value_cumm_bt)

%      if(drive == 25)
%           HOM_value_cumm_b =  HOM_value_cumm_b/5.6*5; % redo correction
%      end
%      if(drive == 40)
%           HOM_value_cumm_b =  HOM_value_cumm_b/3.5*3; % redo correction
%      end
%          
    



            