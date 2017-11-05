clear; clc;

nd = 3;

nt = 5;

u1 = rand(nd, nt);

u2 = rand(nd, nt);

u = {u1; u2};

u = cellfun(@(v) reshape(v, [nd, nt]), u, 'UniformOutput', false);

u1 = u{1};
u2 = u{2};

[ul, usig, ur] = cellfun(@(v) svd(v, 'econ'), u, 'UniformOutput', false);


%% original trace
utr = trace(u{1}' * u{2});

%% test rank 1 explicit trace(u1Tu2).
utrexp = usig{1}(1, 1) * usig{2}(1, 1) * ...
    ur{2}(:, 1)' * ur{1}(:, 1) * ...
    ul{1}(:, 1)' * ul{2}(:, 1);

%% test rank 1 reconstruction with shifted right singular vectors. 

nshift = 2;

urshift = cellfun(@(v) [zeros(nshift, nd); v(1:(nt - nshift), :)], ur, 'UniformOutput', false);

urecons = cellfun(@(x, y, z) x * y * z', ul, usig, urshift, 'UniformOutput', false);

uorishift = cellfun(@(v) [zeros(nd, nshift), v(:, 1:(nt - nshift))], u, 'UniformOutput', false);

%% test rank 1 explicit trace(u1Tu2) with shifted u2.

% shift u2.
u2s = uorishift{2};
% trace of u1 and u2shift.
u2str = trace(u1' * u2s);
% get u2rshift, which is the shifted right singular vector of u2.
u2rs = urshift{2};
% the explicit trace(u1Tu2) with shifted u2r only, the rest remains the
% same. 
rank1 = usig{1}(1, 1) * usig{2}(1, 1) * ...
    u2rs(:, 1)' * ur{1}(:, 1) * ...
    ul{1}(:, 1)' * ul{2}(:, 1);

rank2 = usig{1}(2, 2) * usig{2}(2, 2) * ...
    u2rs(:, 2)' * ur{1}(:, 2) * ...
    ul{1}(:, 2)' * ul{2}(:, 2);

u2sexp =  rank1 + rank2;
    












