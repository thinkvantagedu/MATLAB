clear; clc;
% this script tests note 61.
% 2 cases: 1. interpolate u, then uTu; 2. uTu, then interpolate.
%% matrix case, y1, y2 are pre-computed displacements.
y1 = [1 2; 3 4; 5 6];
y2 = [8 7; 6 5; 4 3];

x1 = 1;
x2 = 5;

xco = {x1; x2};
yco = {y1; y2};

inptx = 4;
% compute Lagrange interpolation.
[coefStore, otpt] = lagrange(inptx, xco, yco);

% otpt is the interpolation result of DISPLACEMENT, not eTe.
% eteotpt is the most original eTe, i.e. interpolate disp, then find eTe.
% 1. original approach.
eteotpt = otpt' * otpt;

% 2. new approach: find eiTej first,
eiTej = cell(length(xco), length(xco));
for i = 1:length(xco)
    yt1 = yco{i};
    for j = 1:length(xco)
        yt2 = yco{j};
        eiTej{i, j} = yt1' * yt2;
    end
end
% find coefTcoef,
ctc = num2cell(coefStore * coefStore');
% multiply cTc with eiTej,
ytc = cellfun(@(u, v) u * v, eiTej, ctc, 'un', 0);
% sum all elements.
etesum = zeros(2, 2);
for i = 1:numel(ytc)
    etesum = etesum + ytc{i};
end

% result: eteotpt = etesum.

%% vector case.
y1v = [1 2 3 4 5 6]';
y2v = [8 7 6 5 4 3]';

yvco = {y1v; y2v};
[~, otptv] = lagrange(inptx, xco, yvco);

ycol = [y1v y2v];
yctyc = ycol' * ycol;