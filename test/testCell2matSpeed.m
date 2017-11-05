clear variables; clc;
%% it seems that for loop is faster than cell2mat.
a1 = rand(300, 300);

a2 = rand(300, 300);

a3 = rand(300, 300);

a4 = rand(300, 300);

testCell = [{a1}; {a2}; {a3}; {a4}];

tic

otptCell = cell2mat(testCell);

toc

tic

otptNum = zeros(1200, 300);

    
otptNum(1:300, :) = otptNum(1:300, :) + a1;
    
otptNum(301:600, :) = otptNum(301:600, :) + a2;

otptNum(601:900, :) = otptNum(601:900, :) + a3;

otptNum(901:1200, :) = otptNum(901:1200, :) + a4;


toc