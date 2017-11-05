clear variables; clc;

inpt = triu(rand(1000));
tic
for i = 1:1000
    otpt1 = inpt + tril(inpt', -1);
end
toc

tic
for i = 1:1000
    otpt2 = inpt + inpt' - diag(diag(inpt));
end
toc


