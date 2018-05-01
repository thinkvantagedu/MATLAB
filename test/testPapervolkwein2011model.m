clear; clc;
% this script tests paper: Model reduction using proper orthogonal
% Decomposition by S.Volkwein.
n = 3;
% P1, page 2
Y = rand(n);
[u, sig, v] = svd(Y, 0);
sigVal = diag(sig);
% first i singular vector.
i = 2;
uPick = u(:, 1:i);
YTY = Y' * Y;
[eVecYTY, eValYTY] = eig(YTY); % equals to sig .^ 2.
% lam1 is the largest eigenvalue of YTY.
lamPick = sort(diag(eValYTY), 'descend');
lamPick = lamPick(1:i);

% test 1.7b, test1 = lamPick, therefore ul solves Pl in theorem 1.1, see page 4.
test1 = sum((uPick' * Y)' .^ 2)';

% 
YYT = Y * Y';
[eVecYYT, eValYYT] = eig(YYT);