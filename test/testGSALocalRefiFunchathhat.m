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
no.plot = 6;
pmEXP.inpt1 = GSAGridtoBlockwithIndx(pmEXP.idx.inpt);

% loop random point, create refined pm grid and plot.
for iPlot = 1:no.plot / 2 
    
%     generate the refined grid.

    pmEXP.maxLoc1 = randi([0, 50],1, 1);
    pmEXP.maxLoc2 = randi([0, 50],1, 1);
    
%     [pmEXP.inpt1, ~] = GSARefineGridLocalwithIdx...
%         (pmEXP.inpt1, pmEXP.maxLoc1, pmEXP.maxLoc2);
    
    % plot hat.
    
    subplot(2, no.plot / 2, iPlot)
    
    
    
    for iScat = 1:length(pmEXP.inpt1)
        for jScat = 1:4
            plotScatter(iScat, jScat, pmEXP.inpt1);
        end
        hold on
    end
    axis square
    scatter(pmEXP.maxLoc1, pmEXP.maxLoc2, 100, 'k', 'x');
    
    [pmEXP.inpt2, ~] = GSARefineGridLocalwithIdx...
        (pmEXP.inpt1, pmEXP.maxLoc1, pmEXP.maxLoc2);
    
    % plot hhat
    
    subplot(2, no.plot / 2, iPlot + no.plot / 2)
    
    for iScat = 1:length(pmEXP.inpt2)
        for jScat = 1:4
            plotScatter(iScat, jScat, pmEXP.inpt2);
        end
        hold on
    end
    axis square
    scatter(pmEXP.maxLoc1, pmEXP.maxLoc2, 100, 'k', 'x');
    
    pmEXP.inpt1 = pmEXP.inpt2;
    
end





