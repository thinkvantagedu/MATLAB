clear; clc;

nh = 1000;
nw = 5;
nd = 100;
nt = 10;
nCount = 1000;
emtx = rand(nh, nw);
%% test ete
% implicit
tTime1 = 0;
for count = 1:nCount
    tic;
    ete = emtx' * emtx;
    x = toc;
    tTime1 = tTime1 + x;
end
aTime1 = tTime1 / nCount

% explicit
etetest = zeros(nw, nw);
tTime2 = 0;
for count = 1:nCount
    tic;
    for i = 1:nw
        for j = 1:nw
            e1 = emtx(:, i);
            e2 = emtx(:, j);
            etetest(i, j) = etetest(i, j) + e1' * e2;
        end
    end
    x = toc;
    tTime2 = tTime2 + x;
end
aTime2 = tTime2 / nCount
%% test cellfun
disp('cellfun')

ecell = mat2cell(emtx, nh, ones(1, nw));

tTime3 = 0;
for count = 1:nCount
    tic;
    ecellres = cellfun(@(v) reshape(v, [nd, nt]), ecell, 'un', 0);
    x = toc;
    tTime3 = tTime3 + x;
end
aTime3 = tTime3 / nCount




ecellres1 = cell(1, nw);
tTime4 = 0;
for count = 1:nCount
    tic;
    for i = 1:nw
        ecellres1(i) = {reshape(ecell{i}, [nd, nt])};
    end
    x = toc;
    tTime4 = tTime4 + x;
end
aTime4 = tTime4 / nCount