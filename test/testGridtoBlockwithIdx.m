% give grid coord as input, sort and output 2*2 blocks for
% determining whether coord is within the block.
% new edit: add row index to inpt, index will follow the otpt.

clear variables; clc;

nInc = 3;

if nInc == 1 % the 1D case
    inpt = [1 1.5 2 2.5 3 3.5]';
elseif nInc == 2 % the 2D case
    inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0];
elseif nInc == 3 % the 3D case
    inptCell = cell(3, 1);
    [inptCell{:}] = meshgrid(-1:1, -1:1, -1:1);
    inpt = [];
    for i = 1:nInc
        inpt = [inpt inptCell{i}(:)];
    end
end

inpt = [(1:length(inpt))' inpt];
xyCellIdx = cellfun(@unique, num2cell(inpt, 1), 'UniformOutput', false);
xy = [xyCellIdx{2:nInc + 1}];
x = xyCellIdx{2};
nId = size(xy, 1) - 1;

if nInc == 1
    otNid = cell(nId, 1);
    
    for i = 1 : nId
        otNid{i} = repmat(x(i:i+1), 1, 1);
    end
    
elseif nInc == 2
    y = xyCellIdx{3};
    % create output
    
    otNid = cell(nId, nId);
    
    % iterate through the grid and fill output. Otpt is already the output
    % of refined coordinates.
    mtxSize = size(otNid);
    test = cell(nId ^ 2, 1);
    %     for idx = 1:nId ^ 2
    %         [indx{1:nInc}] = ind2sub(mtxSize, idx);
    %         otNid(sub2ind(mtxSize, indx{:})) = {[]};
    %     end
    for i = 1 : nId
        for j = 1 : nId
            otNid{j, i} = [repmat(x(i:i+1), 2, 1), ...
                repelem(y(j:j+1), 2)];
        end
    end
    
    % make node route of each block anti-clockwise. Current is lu, ru, ll, rl.
    for iRte = 1:numel(otNid)
        otptTemp = otNid{iRte};
        otNid{iRte}(3, :) = otptTemp(4, :);
        otNid{iRte}(4, :) = otptTemp(3, :);
    end
elseif nInc == 3
    y = xyCellIdx{3};
    z = xyCellIdx{4};
    % create output
    
    otNid = cell(nId, nId, nId);
    
    % iterate through the grid and fill output. Otpt is already the output
    % of refined coordinates.
    mtxSize = size(otNid);
    test = cell(nId ^ nInc, 1);
    %     for idx = 1:nId ^ nInc
    %         [indx{1:nInc}] = ind2sub(mtxSize, idx);
    %         otNid(sub2ind(mtxSize, indx{:})) = {[]};
    %     end
    for i = 1 : nId
        for j = 1 : nId
            for k = 1:nId
                otNid{k, j, i} = [repmat(x(i:i+1), 4, 1), ...
                    repmat(y(j:j+1), 4, 1), ...
                    repelem(z(k:k+1), 4)];
                keyboard
            end
        end
    end
    
    % make node route of each block anti-clockwise. Current is lu, ru, ll, rl.
    for iRte = 1:numel(otNid)
        otptTemp = otNid{iRte};
        otNid{iRte}(3, :) = otptTemp(4, :);
        otNid{iRte}(4, :) = otptTemp(3, :);
    end
end
% make otpt carry the original index.
otpt = cell(numel(otNid), 1);
for iEq = 1:numel(otNid)
    otptBlk = [zeros(nInc * 2, 1) otNid{iEq}];
    for jEq = 1:length(inpt)
        for kEq = 1:length(otptBlk)
            if isequal(otptBlk(kEq, 2:nInc + 1), inpt(jEq, 2:nInc + 1)) == 1
                otptBlk(kEq, :) = [inpt(jEq, 1) otptBlk(kEq, 2:nInc + 1)];
            end
        end
    end
    otpt(iEq) = {otptBlk};
end
