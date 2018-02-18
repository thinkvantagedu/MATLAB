function PlotScatterFromIdxedPmwithPmLabel(pmEXP_inpt)

%% This function plot scatter with index label on right up corner.
% input: parameter cell blocks with corresponding indices.

% set offset values for index labels.
dx = 0.5;
dy = 1.2;

% anonymous functions.
plotScatter = ...
    @(iScat, jScat,  inpt) ...
    scatter(inpt{iScat}(jScat, 2), inpt{iScat}(jScat, 3), 30, 'filled');
textScatter = ...
    @(iScat, jScat,  inpt) ...
    text(inpt{iScat}(jScat, 2) + dx, inpt{iScat}(jScat, 3) + dy, ...
    num2str(inpt{iScat}(jScat, 1)));

hold on

for iScat = 1:length(pmEXP_inpt)
    % each block must possess 4 points.
    for jScat = 1:4
        plotScatter(iScat, jScat, pmEXP_inpt);
        textScatter(iScat, jScat, pmEXP_inpt);
    end
end
axis square
