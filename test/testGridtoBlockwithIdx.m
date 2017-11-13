% % give grid coord as input, sort and output 2*2 blocks for
% % determining whether coord is within the block.
% % new edit: add row index to inpt, index will follow the otpt.
%
clear variables; clc;
%
% nInc = 3;
%
% if nInc == 1 % the 1D case
%     coords = [1 1.5 2 2.5 3 3.5]';
% elseif nInc == 2 % the 2D case
% %     coords = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0];
%     %     coords = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0; 2 0; 2 1; ...
%     %         0 2; -1 2; -2 0; -2 -1];
%     %     coords = [-1 -1; -1 1; 1 -1; 1 1];
%     coords = [-1 -1; -1 1; 1 -1; 1 1; -1 0; 0 -1; 0 0; 0 1; 1 0; ...
%         -1 -0.5; -0.5, 0; 0 -0.5; -0.5 -1; -0.5 -0.5; ...
%         0.5 0; 1 -0.5; 0.5 -1; 0.5 -0.5; ...
%         0.5 1; 1 0.5; 0.5 0.5; 0 0.5; -0.5 0.5; -0.5 1; -1 0.5];
% elseif nInc == 3 % the 3D case
%     inptCell = cell(3, 1);
%     [inptCell{:}] = meshgrid(-1:1, -1:1, -1:1);
%     coords = [];
%     for i = 1:nInc
%         coords = [coords inptCell{i}(:)];
%     end
% end
% coords = [(1:length(coords))' coords];
%% version 1
% dim = size(coords, 2) - 1;
% L = (dec2bin(0:2 ^ dim - 1) - '0') * 2 - 1;
% N = size(L,1);
% otNid = cell(1, 1);
% T = coords(:, 2:end);
% for i = 1:N
%     idx = all(bsxfun(@times, T, L(i,:)) >= 0, 2);
%     otNid{i}=T(idx,:);
% end
%
% % make otpt carry the original index.
% otpt = cell(numel(otNid), 1);
% for iEq = 1:numel(otNid)
%     otptBlk = [zeros(length(otNid{iEq}), 1) otNid{iEq}];
%     for jEq = 1:length(coords)
%         for kEq = 1:length(otptBlk)
%             if isequal(coords(jEq, 2:nInc + 1), otptBlk(kEq, 2:nInc + 1)) == 1
%                 otptBlk(kEq, 1) = coords(jEq, 1);
%
%             end
%         end
%     end
%     otpt(iEq) = {otptBlk};
% end
%
%% version 2
% % xyCellIdx = cellfun(@unique, num2cell(coords, 1), 'UniformOutput', false);
% % xy = [xyCellIdx{2:nInc + 1}];
% %
% % x = xyCellIdx{2};
% % y = xyCellIdx{3};
% % % create output
% % otptNidx = cell(numel(y) - 1, numel(x) - 1);
% %
% % % iterate through the grid and fill output.
% % for xidx = 1 : numel(x) - 1
% %     for yidx = 1 : numel(y) - 1
% %         otptNidx{yidx, xidx} = [repmat(x(xidx:xidx+1), 2, 1), ...
% %             repelem(y(yidx:yidx+1), 2)];
% %     end
% % end
% %
% % % make node route of each block anti-clockwise. Current is lu, ru, ll, rl.
% % for iRte = 1:numel(otptNidx)
% %     otptTemp = otptNidx{iRte};
% %     otptNidx{iRte}(3, :) = otptTemp(4, :);
% %     otptNidx{iRte}(4, :) = otptTemp(3, :);
% % end
% %
% % % make otpt carry the original index.
% % otpt = cell(numel(otptNidx), 1);
% % for iEq = 1:numel(otptNidx)
% %     otptBlk = [zeros(4, 1) otptNidx{iEq}];
% %     for jEq = 1:length(coords)
% %         for kEq = 1:length(otptBlk)
% %             if isequal(otptBlk(kEq, 2:nInc + 1), coords(jEq, 2:nInc + 1)) == 1
% %                 otptBlk(kEq, :) = [coords(jEq, 1) otptBlk(kEq, 2:nInc + 1)];
% %             end
% %         end
% %     end
% %     otpt(iEq) = {otptBlk};
% % end
%% version 3
coords = ...
    [1    -1    -1
    2    -1     1
    3     1    -1
    4     1     1
    5    -1     0
    6     0    -1
    7     0     0];
%     8     0     1
%     9     1     0
%     10     2     0
%     11     2     1
%     12     0     2
%     13    -1     2
%     14    -2     0
%     15    -2    -1];
xtaxi = -coords(:,2)+coords(:,2)';         % taxi displacements
ytaxi = -coords(:,3)+coords(:,3)';
r = xtaxi==1&ytaxi==0;                     % point on right or not, etc.
rd = xtaxi==1&ytaxi==-1;
d = xtaxi==0&ytaxi==-1;
ulef = find(any(r,2)&any(rd,2)&any(d,2));  % upper left corner of squares
n = length(ulef);
sqquares = zeros(4,3,n);
for k=1:n
    ind = ulef(k);
    vtx = [ind find(r(ind,:)) find(rd(ind,:)) find(d(ind,:))];   % cw order
    sqquares(:,:,k) = coords(vtx,:);
end



