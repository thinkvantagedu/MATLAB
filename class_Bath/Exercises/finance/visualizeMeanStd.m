function visualizeMeanStd(m, s, varNames)
% VISUALIZEMEANSTD visualizes means M and standard deviations S and
% uses the names in varNames for labelling.

nVars = numel(varNames);
figure

errorbar(m, s, '+')
ax = gca;
ax.XTick = 1:nVars;
ax.XTickLabel = varNames;
ax.XTickLabelRotation = 90;
title('mean \pm 1 standard deviation')