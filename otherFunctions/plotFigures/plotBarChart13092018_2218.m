clf;

cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;

load errProposedNouiTujN20Iter10Add2Profiler.mat;
% profview(0, errProposedNouiTujN20Iter10Add2Profiler)

load errOriginalIter10Add2Profiler.mat
% profview(0, errOriginalIter10Add2Profiler)

% original: pm sweep = NM, basis processing.
% proposed: impulse response = NM, construct Wa, pm sweep, basis processing.
% proposed.
tpall = 26343; % total
tpNM = 1924; % exact solution
tpMTM = 5476;
tpSweep = 18357;
tpRB = tpall - tpNM - tpMTM - tpSweep;

toRB = 2035 - 1980;
toNMsweep = 1980;
ttNMsweep = toNMsweep / 810 * 65^2 * 10;
plotData;

tall = [ toRB toNMsweep   0 0;  toRB ttNMsweep   0 0; tpRB tpSweep tpNM tpMTM ];

h = barh(tall, 'stacked');
set(h, {'facecolor'}, {'b'; 'r'; 'y'; 'g'})
axis normal
grid on
legend('Basis generation', 'Parameter sweep', 'Computation of U^{imp}', ...
    'Computation of M_i^{trans}', 'Interpreter', 'latex', 'Location', 'southeast')
set(gca,'fontsize', fsAll)
set(gca,'xscale','log')
xlabel('Execution time (seconds)', 'FontSize', fsAll)
xlim([10, 110000])
axis normal
% data1a = 63752; % total
% data1b = 14122; % exact solution
% data1c = 48066 - 239;
% data1d = 452 + 239;
% data1e = data1a - data1b - data1c - data1d;
% 
% data2b = 10609 - 10193;
% data2d = 10193;
% data3 = data2d / 1620 * 1089 * 20;
% plotData;
% 
% dataAll = [ data2b data2d 0 0;  data2b data3 0 0;  data1b data1d data1e data1c ];
% 
% h = barh(dataAll, 'stacked');
% % set(h, {'facecolor'}, {'b'; 'y'})
% % axis normal
% % grid on
% % legend('Basis generation', 'Parameter sweep')
% % set(gca,'fontsize', fsAll)
% set(gca,'xscale','log')
% % xlabel('Execution time (seconds)', 'FontSize', fsAll)
% % axis auto