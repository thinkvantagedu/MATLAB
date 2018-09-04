cd ~/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1;

load errProposedNouiTujIter20Add4Profiler.mat;
% profview(0, errProposedNouiTujIter20Add4Profiler)

load errOriginalIter20Add4Profiler.mat
% profview(0, errOriginalIter20Add4Profiler)


% % proposed.
% tpall = 63752; % total
% tpNM = 14122; % exact solution
% tpWa = 48066 - 239;
% tpSweep = 452 + 239;
% tpother = tpall - tpNM - tpWa - tpSweep;
% 
% toNM = 10609 - 10193;
% toSweep = 10193;
% tothe = toSweep / 1620 * 1089 * 20;
% plotData;
% 
% tall = [toSweep toNM 0 0; tothe toNM 0 0; tpSweep tpNM tpother tpWa ];
% 
% h = barh(tall, 'stacked');
% % set(h, {'facecolor'}, {'b'; 'y'})
% axis normal
% grid on
% legend('Basis generation', 'Parameter sweep')
% set(gca,'fontsize', fsAll)
% set(gca,'xscale','log')
% xlabel('Execution time (seconds)', 'FontSize', fsAll)
% axis auto

data1a = 63752; % total
data1b = 14122; % exact solution
data1c = 48066 - 239;
data1d = 452 + 239;
data1e = data1a - data1b - data1c - data1d;

data2b = 10609 - 10193;
data2d = 10193;
data3 = data2d / 1620 * 1089 * 20;
plotData;

dataAll = [data2d data2b 0 0; data3 data2b 0 0; data1d data1b data1e data1c ];

h = barh(dataAll, 'stacked');
% set(h, {'facecolor'}, {'b'; 'y'})
% axis normal
% grid on
% legend('Basis generation', 'Parameter sweep')
% set(gca,'fontsize', fsAll)
set(gca,'xscale','log')
% xlabel('Execution time (seconds)', 'FontSize', fsAll)
% axis auto