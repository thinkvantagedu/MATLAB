clear; clc;
% this script tests note 61.
%% matrix case
y1 = [1 2; 3 4];
y2 = [8 7; 6 5];

x1 = 1;
x2 = 5;

xco = [x1; x2];
yco = {y1; y2};

inptx = 4;
% compute Lagrange interpolation.
otpt = sparse(0);
coefStore = zeros(length(xco), 1);

for i=1:length(xco)
    
    % fix ith sample x value, to obtain ith Lagrange polynomial.
    afterFix = [xco(1:i - 1); xco(i + 1:end)];
    % denominator, [fix - x1; fix - x2; ... ; fix - xn].
    de = xco(i) - afterFix;
    % numerator, [inptx - x1; inptx - x2; ... ; inptx - xn].
    nu = inptx - afterFix;
    % prod(nu)) / (prod(de) is the polynomial value at inptx, see wiki
    % example.
    coef = prod(nu) / prod(de);
    otpt = otpt + yco{i} * coef;
    coefStore(i) = coefStore(i) + coef;
    
end

eteotpt = otpt' * otpt;

yty = cell(length(xco), length(xco));
for i = 1:length(xco)
    yt1 = yco{i};
    for j = 1:length(xco)
        yt2 = yco{j};
        yty{i, j} = yt1' * yt2;
    end
end

ctc = num2cell(coefStore * coefStore');

ytc = cellfun(@(u, v) u * v, yty, ctc, 'un', 0);

etesum = zeros(2, 2);

for i = 1:numel(ytc)
    etesum = etesum + ytc{i};
end

% result: eteotpt = etesum.

%% vector case.
y1v = [1 2 3 4]';
y2v = [8 7 6 5]';

yvco = {y1v; y2v};
otptv = sparse(0);

for i=1:length(xco)
    
    % fix ith sample x value, to obtain ith Lagrange polynomial.
    afterFix = [xco(1:i - 1); xco(i + 1:end)];
    % denominator, [fix - x1; fix - x2; ... ; fix - xn].
    de = xco(i) - afterFix;
    % numerator, [inptx - x1; inptx - x2; ... ; inptx - xn].
    nu = inptx - afterFix;
    % prod(nu)) / (prod(de) is the polynomial value at inptx, see wiki
    % example.
    coef = prod(nu) / prod(de);
    otptv = otptv + yvco{i} * coef;
    
end

ycol = [y1v y2v];
yctyc = ycol' * ycol;