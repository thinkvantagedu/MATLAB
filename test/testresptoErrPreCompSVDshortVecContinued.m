%% to compare, resp7 is shifting resp5 once. resp8 is shifting resp4 twice. 

% r4, r5 are original responses (no shift); r7 is shifting r5 once, r8 is
% shifting r4 twice. 
r4 = reshape(resp(:, 4), [nd, nt]);
r5 = reshape(resp(:, 5), [nd, nt]);
r7 = reshape(resp(:, 7), [nd, nt]);
r8 = reshape(resp(:, 8), [nd, nt]);

% we aim to obtain same result as acomp with only shifting right singular
% vectors. 
acomp = resp(:, 7)' * resp(:, 8);

% 
[r4l, r4sig, r4r] = svd(r4, 'econ');
[r5l, r5sig, r5r] = svd(r5, 'econ');
r4l = r4l * r4sig;
r5l = r5l * r5sig;

r4lc1 = r4l(:, 1);
r4lc2 = r4l(:, 2);
r4lc3 = r4l(:, 3);

r4rc1 = r4r(:, 1);
r4rc2 = r4r(:, 2);
r4rc3 = r4r(:, 3);

r4rc1s = [zeros(2, 1); r4rc1(1)];
r4rc2s = [zeros(2, 1); r4rc2(1)];
r4rc3s = [zeros(2, 1); r4rc3(1)];

r5lc1 = r5l(:, 1);
r5lc2 = r5l(:, 2);
r5lc3 = r5l(:, 3);

r5rc1 = r5r(:, 1);
r5rc2 = r5r(:, 2);
r5rc3 = r5r(:, 3);

r5rc1s = [0; r5rc1(1:2)];
r5rc2s = [0; r5rc2(1:2)];
r5rc3s = [0; r5rc3(1:2)];


l1c1 = r5lc1;
l2c1 = r4lc1;
r1c1 = r5rc1s;
r2c1 = r4rc1s;

reconsc1 = r2c1' * r1c1 * l1c1' * l2c1;

l1c2 = r5lc2;
l2c2 = r4lc2;
r1c2 = r5rc2s;
r2c2 = r4rc2s;

reconsc12 = ...
    r2c1' * r1c1 * l1c1' * l2c1 + ...
    r2c2' * r1c2 * l1c2' * l2c2;

l1c3 = r5lc3;
l2c3 = r4lc3;
r1c3 = r5rc3s;
r2c3 = r4rc3s;

reconsc123 = ...
    r2c1' * r1c1 * l1c1' * l2c1 + ...
    r2c2' * r1c2 * l1c2' * l2c2 + ...
    r2c3' * r1c3 * l1c3' * l2c3;

l1sum = [l1c1 l1c2 l1c3];
l2sum = [l2c1 l2c2 l2c3];
r1sum = [r1c1 r1c2 r1c3];
r2sum = [r2c1 r2c2 r2c3];

reconssum = (r2sum)' * (r1sum) * (l1sum)' * (l2sum);






















