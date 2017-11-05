clear; clc;

u1 = (1:10)';
u2 = (5:14)';
u1m = reshape(u1, [5, 2]);
u2m = reshape(u2, [5, 2]);

%% Fro norm
umsum = u1m + u2m;
fnmu = norm(umsum, 'fro');

%% align mtx, sum trace, sqare root trace sum. 
ualg = [u1m u2m];
utu = ualg' * ualg;
ucell = mat2cell(utu, [2 2], [2 2]);
utrsum = cellfun(@(v) trace(v), ucell, 'UniformOutput', false);
utrsum = cell2mat(utrsum);
utrsum = sum(utrsum(:));
utrsq = sqrt(utrsum);

%% apply svd
ucel = {u1m; u2m};
[x, sig, y] = cellfun(@(v) svd(v, 'econ'), ucel, 'UniformOutput', false);

x1 = x{1}(:, 1);
x2 = x{2}(:, 2);

y1 = y{1}(:, 1);
y2 = y{2}(:, 2);

traxy = trace(y2 * x2' * x1 * y1');

trax = trace(y2 * y1');

tray = trace(x2' * x1);

trasep = trax * tray;

y1ty2 = y1' * y2;

x2tx1 = x2' * x1;

xyprod = y1ty2 * x2tx1;

