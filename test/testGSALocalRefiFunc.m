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
    scatter(inpt{iScat}(jScat, 2), inpt{iScat}(jScat, 3), 30, 'filled');
textScatter = ...
    @(iScat, jScat,  inpt) ...
    text(inpt{iScat}(jScat, 2) + dx, inpt{iScat}(jScat, 3) + dy, ...
    num2str(inpt{iScat}(jScat, 1)));
no.plot = 8;
pmEXP.inpt = GSAGridtoBlockwithIndx(pmEXP.idx.inpt);

% loop random point, create refined pm grid and plot.
for iPlot = 1:no.plot
    
%     generate the refined grid.

    pmEXP.maxLoc1 = randi([0, 50],1, 1);
    pmEXP.maxLoc2 = randi([0, 50],1, 1);
    
    [pmEXP.inpt, pmEXP.otptRaw] = GSARefineGridLocalwithIdx...
        (pmEXP.inpt, pmEXP.maxLoc1, pmEXP.maxLoc2);
    
%     plot the grid.
    
    subplot(2, 4, iPlot)
    
    
    
    for iScat = 1:length(pmEXP.inpt)
        for jScat = 1:4
            plotScatter(iScat, jScat, pmEXP.inpt);
%             textScatter(iScat, jScat, pmEXP.inpt);
        end
        hold on
    end
    axis square
    scatter(pmEXP.maxLoc1, pmEXP.maxLoc2, 100, 'k', 'x');
    
end





