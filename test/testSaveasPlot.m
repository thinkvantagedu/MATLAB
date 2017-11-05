clear variables; clc;

x = 1:1:50;

y = sin(x);
trialName = 'l2h1';
z = plot(x, y);
pm.trial.val = [10, 20];
time.max = 3;
time.step = 0.1;
no.rb0 = 2;
dataloc = ...
    '/home/xiaohan/Desktop/';

dataname = [dataloc, '[%d_%d]t[%.1f]l[%.2f]rb0[%g]', trialName, datestr(now, 'mmmddyyyy_HH-MM-SS')];

datafile_name = sprintf(dataname, pm.trial.val(1), pm.trial.val(2), ...
    time.max, time.step, no.rb0);

saveas(gcf, datafile_name, 'png')

