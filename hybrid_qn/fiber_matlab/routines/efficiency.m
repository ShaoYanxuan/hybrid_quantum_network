function y = efficiency(results)
clear out
load(results);
i = 1;
M{1} = out.tomo_matrix1_counts{1}./out.tomo_matrix_attempts1{1};
time(1) = (-out.gatestart{1}+out.gatestop{i});;
eff(1) = sum(sum(M{1}))/9;
for i = 2:length(out.gatestop)

   M{i} = M{i-1} + out.tomo_matrix1_counts{i}./out.tomo_matrix_attempts1{i};
    time(i) = (-out.gatestart{1}+out.gatestop{i});
    eff(i) = sum(sum(M{i}))/9;
end

%plot(time, eff_backsubtracted)

figure1 = figure();

% Create axes
% axes1 = axes('Parent',figure1);
% hold(axes1,'on');

% Create plot
%plot(time, eff, 'o', 'MarkerFaceColor', 'blue');
%plot(eff_backsubtracted);
hold on
%ylim([0 1])
xlabel('Time, us')
ylabel('Efficieny')

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.120967741935484 60.1209677419355]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0.0003 0.0006]);
% box(axes1,'on');
% % Set the remaining axes properties
% set(axes1,'XGrid','on','XTick',...
%     [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60],...
%     'YGrid','on','YTick',...
%     [0.0003 0.00032 0.00034 0.00036 0.00038 0.0004 0.00042 0.00044 0.00046 0.00048 0.0005 0.00052 0.00054 0.00056 0.00058 0.0006]);
y = eff;