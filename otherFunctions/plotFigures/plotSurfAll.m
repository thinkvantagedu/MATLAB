clear; clc; clf;
% this script imports the file and plot all stored surfaces in one figure.
cd ~/Desktop/Temp/thesisResults/18042018_1112+;
% cd ~/Desktop/Temp/thesisResults/26042018_1658;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')
pmSpaceOri = linspace(-1, 1, 129);
pmSpacePro = linspace(-1, 1, 1025);

figure(1)
hold on
for iPlot = 7:11
    hAx = semilogy(pmSpaceOri, errOriginalStore.allSurf{iPlot}, ...
        'k', 'LineWidth', 1);
end

for iPlot = 7:11
    hAy = semilogy(pmSpacePro, errProposedStore.allSurf.hhat{iPlot}, ...
        'b', 'LineWidth', 1);
end
grid on

