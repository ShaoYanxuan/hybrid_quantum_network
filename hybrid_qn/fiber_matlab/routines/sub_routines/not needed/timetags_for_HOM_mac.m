fsep = filesep;
timetag_root = [fsep 'Volumes' fsep 'qos' fsep 'qfc' fsep 'measurements' fsep 'QFC' fsep '2019_04_02' fsep];
%2019_04_02_225539.txt - converted_only

%2019_04_02_230906.txt - HOM*
%2019_04_03_000106.txt - ort. waveplate

%timetag_file = '2019_04_02_230906.txt'% - HOM*
timetag_file = '2019_04_04_200138.txt'% - HOM
filename = strcat(timetag_root, timetag_file)
TAGS_HOMw1 =  load_tags(filename);

timetag_file = '2019_04_04_204649.txt'% - HOM
filename = strcat(timetag_root, timetag_file)
TAGS_HOMw2 =  load_tags(filename);

timetag_file = '2019_04_03_000106.txt'% - HOM -perp
filename = strcat(timetag_root, timetag_file)
TAGS_P =  load_tags(filename);

timetag_file = '2019_04_04_174955.txt'% - HOM -perp
filename = strcat(timetag_root, timetag_file)
TAGS_P2 =  load_tags(filename);

%timetag_file = '2019_04_04_154750.txt'% - HOM2
timetag_file = '2019_04_04_185205.txt'% - HOM3
timetag_file = '2019_04_04_232855.txt'% - high Rabi, 
filename = strcat(timetag_root, timetag_file)
TAGS_HOM2 =  load_tags(filename);

timetag_file = '2019_04_02_225539.txt'% - converted_only
filename = strcat(timetag_root, timetag_file)
TAGS1 =  load_tags(filename);
channeldata1_converted = analyse_counts(TAGS1, 1,   100 )
channeldata2_converted = analyse_counts(TAGS1, 2, 100 )
ch1_c = histogram(channeldata1_converted.time_diff, [0:0.5:200]);
figure
ch2_c = histogram(channeldata2_converted.time_diff, [0:0.5:200]);

timetag_file = '2019_04_02_230310.txt' % - direct only
filename = strcat(timetag_root, timetag_file)
TAGS =  load_tags(filename);
%TAGS_t = gated(TAGS, 2, [65 75]);
channeldata1 = analyse_counts(TAGS, 2,   500 )
channeldata2 = analyse_counts(TAGS_n, 2, 1000 )
figure
ch1 = histogram(channeldata1.time_diff, [-500:0.5:500]);
figure
ch2 = histogram(channeldata2.time_diff, [-1000:2:1000]);

figure
plot(ch1.BinEdges(1:length(ch1.BinEdges)-1),ch1.BinCounts)
hold on
plot(ch2.BinEdges(1:length(ch2.BinEdges)-1),ch2.BinCounts)
hold on
plot(ch1_c.BinEdges(1:length(ch1_c.BinEdges)-1),ch1_c.BinCounts)
hold on
plot(ch2_c.BinEdges(1:length(ch2_c.BinEdges)-1),ch2_c.BinCounts)

figure
plot(ch1.BinEdges(1:length(ch1.BinEdges)-1),ch1.BinCounts)
hold on
plot(ch2.BinEdges(1:length(ch2.BinEdges)-1),ch2.BinCounts)
hold on
plot(ch1_c.BinEdges(1:length(ch1_c.BinEdges)-1),(ch1_c.BinCounts-ch1_c.BinCounts(1))*25.4)
hold on
plot(ch2_c.BinEdges(1:length(ch2_c.BinEdges)-1),(ch2_c.BinCounts-ch2_c.BinCounts(1))*25.4)

dt = 0.2;
% analyse_coincidendes(TAGS, maxdelay, gate, CH1, CH2)
maxdel = 2000;
Coinc_conv = analyse_coincidendes(TAGS1, maxdel, [64 90], 1, 2)
figure(2)
histogram(Coinc_conv.eventdiff, [-maxdel:5:maxdel]);
title('Coincidences in converted path')

Coinc_direct = analyse_coincidendes(TAGS, maxdel, [64 90], 1, 2)
figure(3)
h = histogram(Coinc_direct.eventdiff, [-maxdel:dt:maxdel]);
plot(h.BinEdges(1:length(h.BinEdges)-1),h.BinCounts/Coinc_direct.attempts)
title('Coincidences in direct path')
xlim([-30, 30])

gate = [65 85];
maxdel = 2000;
dt = 0.2;

Coinc_HOM = analyse_coincidendes(TAGS_HOMw1, maxdel, gate, 1, 2)
figure(4)
HOM = histogram(Coinc_HOM.eventdiff, [-50:dt:50]);
title('Coincidences HOM')
figure(11)
plot(HOM.BinEdges(1:length(HOM.BinEdges)-1),HOM.BinCounts/Coinc_HOM.attempts)
xlim([-30, 30])
xlabel('Time delay, us')
ylabel('Coincedence per attempt per bin')
title(sprintf('Propper polarisations %.1f us bin', dt))
Coinc_HOM2 = analyse_coincidendes(TAGS_HOMw2, maxdel, gate, 1, 2)
figure()
HOM2 = histogram(Coinc_HOM2.eventdiff, [-50:dt:50]);
title('Coincidences HOM')
figure(24)
plot(HOM.BinEdges(1:length(HOM.BinEdges)-1),(HOM.BinCounts+HOM2.BinCounts)/(Coinc_HOM.attempts+Coinc_HOM2.attempts), '.-')
%xlim([-30, 30])
xlabel('Time delay, us')
ylabel('Coincedence per attempt per bin')
title(sprintf('Propper polarisations %.1f us bin', dt))
hold on

Coinc_P = analyse_coincidendes(TAGS_P, maxdel, gate, 1, 2)
figure(5)
Perp = histogram(Coinc_P.eventdiff, [-maxdel:dt:maxdel]);
title('Coincidences Perp')
figure(12)
plot(Perp.BinEdges(1:length(Perp.BinEdges)-1),Perp.BinCounts/Coinc_P.attempts)
xlim([-30, 30])
xlabel('Time delay, us')
ylabel('Coincedence per attempt per bin')
title(sprintf('Perpendicular polarisations %.1f us bin', dt))

Coinc_HOM = analyse_coincidendes(TAGS_HOM2, maxdel, gate, 1, 2)
figure()
HOM = histogram(Coinc_HOM.eventdiff, [-maxdel:dt:maxdel]);
title('Coincidences HOM')
figure(21)
plot(HOM.BinEdges(1:length(HOM.BinEdges)-1),HOM.BinCounts/Coinc_HOM.attempts)
xlim([-50, 50])
xlabel('Time delay, us')
ylabel('Coincedence per attempt per bin')
title(sprintf('Propper polarisations %.1f us bin', dt))

Coinc_P = analyse_coincidendes(TAGS_P2, maxdel, [195 230], 1, 2)
figure(5)
Perp = histogram(Coinc_P.eventdiff, [-100:dt:100]);
title('Coincidences Perp')
figure(17)
plot(Perp.BinEdges(1:length(Perp.BinEdges)-1),Perp.BinCounts/Coinc_P.attempts)
xlim([-30, 30])
xlabel('Time delay, us')
ylabel('Coincedence per attempt per bin')
title(sprintf('Perpendicular polarisations %.1f us bin', dt))
%% 
channeldata1_converted = analyse_counts(TAGS_HOMw2, 1,   300 )
channeldata2_converted = analyse_counts(TAGS_HOM2, 2, 300 )
figure
ch1_c = histogram(channeldata1_converted.time_diff, [0:0.5:300]);
figure
ch2_c = histogram(channeldata2_converted.time_diff, [0:0.5:300]);



%correlations(TAGS, binsize, gate1, gate2)