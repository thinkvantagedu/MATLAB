clear; clc;

%% perform all sort of speed tests.

testname = 'tracevsVec';

switch testname
    
    case 'shortvec'
        % this case test speed of long and short vector products, total
        % size are similar.
        a1 = rand(100, 100);
        a2 = rand(5, 2000);
        tic
        b1 = a1'*a1;
        toc
        tic
        b2 = a2'*a2;
        toc
    case 'tracevsVec'
        N = 50;
        u1 = rand(10000, 100);
        u2 = rand(10000, 100);
        [l1, s1, r1] = svd(u1, 0);
        [l2, s2, r2] = svd(u2, 0);
        l1 = l1(:, 1:N);
        s1 = s1(1:N, 1:N);
        r1 = r1(:, 1:N);
        l2 = l2(:, 1:N);
        s2 = s2(1:N, 1:N);
        r2 = r2(:, 1:N);
        tic
        u1Tu2 = u1(:)' * u2(:);
        toc
        tic
        tru1Tu2 = trace((r2' * r1) * s1' * (l1' * l2) * s2);
        toc
end