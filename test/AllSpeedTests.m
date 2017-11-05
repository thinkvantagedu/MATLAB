clear variables; clc;

%% perform all sort of speed tests.

testname = 'shortvec';

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
end