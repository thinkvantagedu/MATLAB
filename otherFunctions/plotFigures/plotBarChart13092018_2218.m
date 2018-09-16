clf;

cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;

load errProposedNouiTujN20Iter10Add2Profiler.mat;
% profview(0, errProposedNouiTujN20Iter10Add2Profiler)

load errOriginalIter10Add2Profiler.mat
% profview(0, errOriginalIter10Add2Profiler)

% original: pm sweep = NM, basis processing.
% proposed: impulse response = NM, construct Wa, pm sweep, basis processing.
% proposed.
% case 1.
tpall1 = 26343; % total
tpNM1 = 1924; % exact solution
tpMTM1 = 5476;
tpSweep1 = 18357;
tpRB1 = tpall1 - tpNM1 - tpMTM1 - tpSweep1;

% case 2.
tpall2 = 41038; % total
tpNM2 = 7629; % exact solution
tpMTM2 = 23031;
tpSweep2 = 9585;
tpRB2 = tpall2 - tpNM2 - tpMTM2 - tpSweep2;

toRB = 2035 - 1980;
toNMsweep = 1980;
ttNMsweep = toNMsweep / 810 * 65^2 * 10;
plotData;

tall = [ toRB toNMsweep   0 0;  toRB ttNMsweep   0 0; ...
    tpRB2 tpSweep2 tpNM2 tpMTM2; tpRB1 tpSweep1 tpNM1 tpMTM1];

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