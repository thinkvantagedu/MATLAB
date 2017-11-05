function [otpt] = GSAGridtoBlockwithIndx(inpt)
%% give grid coord as input, sort and output 2*2 blocks for
% determining whether coord is within the block. 
%% new edit: add row index to inpt, index will follow the otpt. 

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
xy = cellfun(@unique, num2cell(inpt, 1), 'UniformOutput', false);
x = xy{2};
y = xy{3};
% create output
otpt_noindx = cell(numel(y) - 1, numel(x) - 1);

% iterate through the grid and fill output.
for xidx = 1 : numel(x) - 1
    for yidx = 1 : numel(y) - 1
        otpt_noindx{yidx, xidx} = [repmat(x(xidx:xidx+1), 2, 1), ...
            repelem(y(yidx:yidx+1), 2)];
    end
end
% make node route of each block clockwise. Current is lu, ru, ll, rl.
for i_rte = 1:numel(otpt_noindx)
    otpt_temp = otpt_noindx{i_rte};
    otpt_noindx{i_rte}(3, :) = otpt_temp(4, :);
    otpt_noindx{i_rte}(4, :) = otpt_temp(3, :);
end

% make otpt carry the original index.
otpt = cell(numel(otpt_noindx), 1);
for i_eq = 1:numel(otpt_noindx)
    otpt_block = [zeros(4, 1) otpt_noindx{i_eq}];
    for j_eq = 1:length(inpt)
        for k_eq = 1:length(otpt_block)
            if isequal(otpt_block(k_eq, 2:3), inpt(j_eq, 2:3)) == 1
                otpt_block(k_eq, :) = [inpt(j_eq, 1) otpt_block(k_eq, 2:3)];
                otpt(i_eq) = {otpt_block};
            end
        end
    end
end