function [obj] = gridtoBlockwithIndx(obj)
% give grid coord as input, sort and output 2*2 blocks for
% determining whether coord is within the block.
% new edit: add row index to inpt, index will follow the otpt.

% clear variables; clc;
% inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0];
% inpt = [1 -1 -1; 2 -1 1; 3 1 -1; 4 1 1; 5 -1 0; 6 0 -1; 7 0 0; 8 0 1; 9 1 0];

% inpt = [-1 -1; -1 1; 1 -1; 1 1];
% inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0; ...
%     -1 -0.5; -0.5, 0; 0 -0.5; -0.5 -1; -0.5 -0.5; ...
%     0.5 0; 1 -0.5; 0.5 -1; 0.5 -0.5; ...
%     0.5 1; 1 0.5; 0.5 0.5; 0 0.5; -0.5 0.5; -0.5 1; -1 0.5];
% inpt = [1 1; 1.5 1; 2 1; 1 1.5; 1.5 1.5; 2 1.5; 1 2; 1.5 2; 2 2];
% get the sorted unique x and y coordinates:

inpt = obj.pmExpo.temp.inpt;
xyCellIdx = cellfun(@unique, num2cell(inpt, 1), 'UniformOutput', false);
xy = [xyCellIdx{2:obj.no.inc + 1}];

x = xyCellIdx{2};
if obj.no.inc == 1
    
else
    y = xyCellIdx{3};
    % create output
    otptNidx = cell(numel(y) - 1, numel(x) - 1);
    
    % iterate through the grid and fill output.
    for xidx = 1 : numel(x) - 1
        for yidx = 1 : numel(y) - 1
            otptNidx{yidx, xidx} = [repmat(x(xidx:xidx+1), 2, 1), ...
                repelem(y(yidx:yidx+1), 2)];
        end
    end
    
    % make node route of each block anti-clockwise. Current is lu, ru, ll, rl.
    for iRte = 1:numel(otptNidx)
        otptTemp = otptNidx{iRte};
        otptNidx{iRte}(3, :) = otptTemp(4, :);
        otptNidx{iRte}(4, :) = otptTemp(3, :);
    end
    
    % make otpt carry the original index.
    otpt = cell(numel(otptNidx), 1);
    for iEq = 1:numel(otptNidx)
        otptBlk = [zeros(4, 1) otptNidx{iEq}];
        for jEq = 1:length(inpt)
            for kEq = 1:length(otptBlk)
                if isequal(otptBlk(kEq, 2:3), inpt(jEq, 2:3)) == 1
                    otptBlk(kEq, :) = [inpt(jEq, 1) otptBlk(kEq, 2:3)];
                end
            end
        end
        otpt(iEq) = {otptBlk};
    end
    obj.pmExpo.temp.otpt = otpt;
end
end