clear variables; clc; clf;

pmEXP.maxLoc10 = 10;
pmEXP.maxLoc20 = 10;

pmEXP.noidx.inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 50 25; 25 50];
no_inpt0 = length(pmEXP.noidx.inpt(:, 1));
pmEXP.idx.inpt = [(1:no_inpt0)' pmEXP.noidx.inpt];

% plot coefficients
dx = 0.5;
dy = 1.2;
plotScatter = ...
    @(iScat, jScat,  inpt) ...
    scatter(inpt{iScat}(jScat, 2), inpt{iScat}(jScat, 3), 20, 'b', 'filled');
textScatter = ...
    @(iScat, jScat,  inpt) ...
    text(inpt{iScat}(jScat, 2) + dx, inpt{iScat}(jScat, 3) + dy, ...
    num2str(inpt{iScat}(jScat, 1)));
nplot = 5;
pmEXP.hhatBlk = GSAGridtoBlockwithIndx(pmEXP.idx.inpt);
nhatBlk = length(pmEXP.hhatBlk);
% loop random point, create refined pm grid and plot.
pmPos = [10 15; 33 3; 35 43; 5 31; 20 18];
for iPlot = 1:nplot
    %     generate the refined grid.
    pmEXP.loc1 = pmPos(iPlot, 1);
    pmEXP.loc2 = pmPos(iPlot, 2);
    
    % plot hat blocks.
    pmEXP.hatBlk = pmEXP.hhatBlk;
    subplot(2, nplot, iPlot + nplot);
    for iScat = 1:length(pmEXP.hatBlk)
        for jScat = 1:4
            plotScatter(iScat, jScat, pmEXP.hatBlk);
        end
        hold on
    end
    scatter(pmEXP.loc1, pmEXP.loc2, 30, 'r', 'd', 'filled');
    text(pmEXP.loc1 + 2, pmEXP.loc2, ...
        num2str(iPlot), 'Color', 'r', 'FontSize', 20);
    grid minor
    axis([0 50 0 50])
    axis square
    [pmEXP.hhatBlk, pmEXP.otptRaw] = GSARefineGridLocalwithIdx...
        (pmEXP.hhatBlk, pmEXP.loc1, pmEXP.loc2);
    % plot hhat blocks.
    %     plot the grid.
    subplot(2, nplot, iPlot);
    
    for iScat = 1:length(pmEXP.hhatBlk)
        for jScat = 1:4
            plotScatter(iScat, jScat, pmEXP.hhatBlk);
        end
        hold on
    end    
    scatter(pmEXP.loc1, pmEXP.loc2, 30, 'r', 'd', 'filled');
    text(pmEXP.loc1 + 2, pmEXP.loc2, ...
        num2str(iPlot), 'Color', 'r', 'FontSize', 20);
    grid minor
    axis([0 50 0 50])
    axis square
    nhatBlk = length(pmEXP.hhatBlk);
end




