function [otpt] = GSAGridtoBlock(inpt)
%% give grid coord as input, sort and output 2*2 blocks for 
%% determining whether coord is within the block.
% clear variables; clc;
% inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0];
% inpt = [-1 -1; -1 1; 1 -1; 1 1];
% inpt = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0; ...
%     -1 -0.5; -0.5, 0; 0 -0.5; -0.5 -1; -0.5 -0.5; 0.5 0; 1 -0.5; 0.5 -1; 0.5 -0.5; ...
%     0.5 1; 1 0.5; 0.5 0.5; 0 0.5; -0.5 0.5; -0.5 1; -1 0.5];
% inpt = [1 1; 1.5 1; 2 1; 1 1.5; 1.5 1.5; 2 1.5; 1 2; 1.5 2; 2 2];

% get the sorted unique x and y coordinates:
xy = cellfun(@unique, num2cell(inpt, 1), 'UniformOutput', false);
x = xy{1};
y = xy{2};
% create output.
otpt = cell(numel(y) - 1, numel(x) - 1);

% iterate through the grid and fill output.
for xidx = 1 : numel(x) - 1
   for yidx = 1 : numel(y) - 1
      otpt{yidx, xidx} = [repmat(x(xidx:xidx+1), 2, 1), repelem(y(yidx:yidx+1), 2)];
   end
end
% make node route of each block clockwise. Current is lu, ru, ll, rl.
for i_rte = 1:numel(otpt)
    otpt_temp = otpt{i_rte};
    otpt{i_rte}(3, :) = otpt_temp(4, :);
    otpt{i_rte}(4, :) = otpt_temp(3, :);
end