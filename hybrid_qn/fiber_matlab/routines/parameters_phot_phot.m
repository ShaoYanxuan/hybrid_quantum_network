%% Parameters for addressed exp

%clear all
%close all
fsep = filesep;

%   



 
% tricsfolder_arr = {'194545','195246' ,'194916',   '205623',  '205301',  '205926'};; % 100 cycles!!
%  timetag_files = { '2020_08_07_194545.txt','2020_08_07_195246.txt' , '2020_08_07_194916.txt',    '2020_08_07_205623.txt',  '2020_08_07_205301.txt',  '2020_08_07_205926.txt'  } 
%   timetag_bases = [1,2,3,5,4,6];

  tricsfolder_arr = { '214800', '215156','214131',   '220916',  '220402', '221322'}; % 50 cycles!!
  timetag_files = { '2020_08_07_214800.txt' , '2020_08_07_215156.txt',  '2020_08_07_214131.txt',   '2020_08_07_220917.txt',  '2020_08_07_220403.txt' ,  '2020_08_07_221323.txt' } 

timetag_bases = [1,2,3,4,5,6];



foldername = '2020_08_07_2ions_1';

timetag_root = [fsep fsep 'zidshare.uibk.ac.at' fsep 'qos' fsep 'qfc' fsep 'measurements' fsep 'QFC' fsep '2020_08_07' fsep];
trics_root_folder = [fsep fsep 'zidshare.uibk.ac.at' fsep 'qos' fsep 'qfc' fsep 'measurements' fsep 'trics_data' fsep '2020-08-07' fsep];

ChRaman = 0;
ChAPD1 = 2;
ChAPD2 = 6;
ChCycle =7;

threshold = 1.2e5; 
seq_cycles = 50; 
gate_number = 1;

 wavepacket_start = 5%313% 490 %557 %614%498        %313 %368 %256 %356  % 245%    
 wavepacket_stop =  60%
 delay_to_second  = 105;
  wavepacket_ROI = wavepacket_stop - wavepacket_start;
% 
%
gate_length = wavepacket_ROI/gate_number;
gate_start{1} = wavepacket_start;
gate_stop{1} = gate_start{1} + gate_length;

for ii = 2:gate_number
    gate_start{ii} = gate_start{ii-1} + gate_length;
    gate_stop{ii} = gate_start{ii} + gate_length;
end
 


for jj = 1:gate_number
    out{jj} = timetags_cam_2ion_2phot(timetag_root, trics_root_folder, tricsfolder_arr,  timetag_files, timetag_bases, ChRaman, ChAPD1, ChAPD2, ChCycle, threshold, seq_cycles,  gate_start{jj}, gate_stop{jj}, delay_to_second, jj);
       
end

%% merge out-structures into one

f = fieldnames(out{gate_number});

for ii = 1:length(f)
    for jj = 1: length( out{gate_number}.(f{ii}) )
        if isempty(out{gate_number}.(f{ii}){jj})
          out{gate_number}.(f{ii})(jj) = out{jj}.(f{ii})(jj);
        end
    end
end
out = out{gate_number}

% test = zeros(7, 17);
% test(1:6, 1:16) = out.state_norm{1};
% figure
% surface(test);

test = zeros(7, 5);
test(1:6, 1:4) = out.parity{1};
figure
surface(test);


save(['allresults_' foldername '.mat'],'out');




tosave = out.clean_tags{1};
%  tosave(:,1) = tosave(:,1)*1e6; %back to ps
%   save(['clean_tags_' timetag_files{1}(1:end-4) '_' timetag_files{2}(1:end-4) '_' timetag_files{3}(1:end-4) '.txt'],'tosave', '-ascii', '-double' )


% ParityH(1,:) = out.parity{1}(1,:)
% ParityH(3,:) = out.parity{1}(4,:)
% ParityD(1,:) = out.parity{1}(2,:)
% ParityD(3,:) = out.parity{1}(5,:)
% ParityR(1,:) = out.parity{1}(3,:)
% ParityR(3,:) = out.parity{1}(6,:)
% 
% 
for kk = 1:4
    figure(10+kk)
    hold off
    plot(ParityH(:,kk))
    hold on
    plot(ParityD(:,kk))
    plot(ParityR(:,kk))
    ylim([-1;1])
    xlabel('phase')
    ylabel('parity')
    legend('H/V', 'D/A', 'R/L')
end;