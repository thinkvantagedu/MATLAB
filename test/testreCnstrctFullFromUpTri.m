clear variables; clc;


inpt = magic(1000);

inpt_temp = triu(inpt);

tic
for i = 1:1000
    
    [otpt] = reCnstrctFullFromUpTri(inpt_temp);
    
end
toc