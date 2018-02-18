function otpt = gridtoBlock(inpt, ninc)
% give grid coord as input, sort and output 2*2 blocks for
% determining whether coord is within the block.
% new edit: add row index to inpt, index will follow the otpt.

% clear variables; clc;
% inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0];

% inpt = [-1 -1; -1 1; 1 -1; 1 1];
% inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0; ...
%     -1 -0.5; -0.5, 0; 0 -0.5; -0.5 -1; -0.5 -0.5; ...
%     0.5 0; 1 -0.5; 0.5 -1; 0.5 -0.5; ...
%     0.5 1; 1 0.5; 0.5 0.5; 0 0.5; -0.5 0.5; -0.5 1; -1 0.5];
% inpt = [1 1; 1.5 1; 2 1; 1 1.5; 1.5 1.5; 2 1.5; 1 2; 1.5 2; 2 2];
% get the sorted unique x and y coordinates:

xyCellIdx = cellfun(@unique, num2cell(inpt, 1), 'UniformOutput', false);
x = xyCellIdx{2};

if ninc == 1
    for xidx = 1 : numel(x) - 1
        otptNidx{xidx} = repmat(x(xidx:xidx+1), ninc, 1);
    end
    
elseif ninc == 2
    y = xyCellIdx{3};
    % create output
    otptNidx = cell(numel(y) - 1, numel(x) - 1);
    
    % iterate through the grid and fill output.
    for xidx = 1 : numel(x) - 1
        for yidx = 1 : numel(y) - 1
            otptNidx{yidx, xidx} = [repmat(x(xidx:xidx+1), ninc, 1), ...
                repelem(y(yidx:yidx+1), ninc)];
        end
    end
    
    % make node route of each block anti-clockwise. Current is lu, ru, ll, rl.
    for iRte = 1:numel(otptNidx)
        otptTemp = otptNidx{iRte};
        otptNidx{iRte}(3, :) = otptTemp(4, :);
        otptNidx{iRte}(4, :) = otptTemp(3, :);
    end
end
% make otpt carry the original index.
otpt = cell(numel(otptNidx), 1);
for iEq = 1:numel(otptNidx)
    otptBlk = [zeros(length(otptNidx{iEq}), 1) otptNidx{iEq}];
    for jEq = 1:length(inpt)
        for kEq = 1:length(otptBlk)
            if isequal(otptBlk(kEq, 2:ninc + 1), inpt(jEq, 2:ninc + 1)) == 1
                otptBlk(kEq, :) = [inpt(jEq, 1) otptBlk(kEq, 2:ninc + 1)];
            end
        end
    end
    otpt(iEq) = {otptBlk};
end
end