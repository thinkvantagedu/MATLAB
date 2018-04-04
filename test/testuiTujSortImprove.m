% this method tries to find out how to improve the speed of uiTujSort.
clear; clc;
% number of total tests.
nTest = 500;

% generate nTest*2 random matrices.
nd = 1000;
nt = 100;
dis = cell(nTest, 2);
dis = cellfun(@(v) rand(nd, nt), dis, 'un', 0);

% perform SVD on each matrix, only leave nRem singular vectors and values.
nRem = 50;
disSVD = cell(nTest, 2);
for isvd = 1:nTest
    for jsvd = 1:2
        [u, s, v] = svd(dis{isvd, jsvd}, 0);
        disSVD{isvd, jsvd} = {u(:, 1:nRem), s(1:nRem, 1:nRem), v(:, 1:nRem)};
    end
end

% for each SVD result, perform trace to obtain disTrans. disTrans is
% non-symmetric, thus jtr needs to start from 1.
disTrans = zeros(nTest);
for itr = 1:nTest
    u1 = disSVD{itr, 1};
    for jtr = 1:nTest
        u2 = disSVD{jtr, 2};
        %         disTrans(itr, jtr) = ...
        %             trace(u1{3} * u1{2}' * u1{1}' * u2{1} * u2{2} * u2{3}');
        % this is the fastest method so far.
        disTrans(itr, jtr) = ...
            trace((u2{3}' * u1{3}) * u1{2}' * (u1{1}' * u2{1}) * u2{2});
    end
end