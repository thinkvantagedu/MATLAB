clear variables; clc;

a = rand(10);

tic

for i = 1:1000
    [a1] = sumDiagSqMTXAll(a);
end
toc

tic
for i = 1:1000
    [a2] = sumDiagSqMTXUpTri(a);
end
toc