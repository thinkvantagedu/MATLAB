clear; clc;

%% load data for approximation.

data.route = '/home/xiaohan/Desktop/Temp/numericalResults';

data.loc.appro = strcat(data.route, ...
    '/[8_9]/GreedyAppro/NormShortVecAdapt/t[5.0]l[1.00]rb0[2]_l9h2CoarseMar022017_09-37-58.mat');

data.val.appro = load(data.loc.appro);

% load data for exact.

data.loc.exact = strcat(data.route, ...
    '/[8_9]/GreedyExact/t[5.0]l[1.00]rb0[2]_l9h2CoarseMar022017_10-29-49.mat');

data.val.exact = load(data.loc.exact);

%% plot two error decays in one. 

plotName.appro = 'approximation';

plotName.exact = 'truth';

% extract max error store for approximation.

errMax.store.appro = data.val.appro.progdata.store{2, 2}{:}.max.store_exactwRB;

% extract max error store for exact.

errMax.store.exact = data.val.exact.progdata.store{2, 2}{:}.max.store;


GSAPlotTwoDecayOverlap(errMax.store.appro, errMax.store.exact, ...
    plotName.appro, plotName.exact)