clear; clc;

a = 2;
b = 3;
matL = 5;
matW = 4;

myCell = cell(a, b);

myCell = cellfun(@(v) rand(matL, matW), myCell, 'UniformOutput', false);

[myCellL, myCellSig, myCellR] = ...
    cellfun(@(v) svd(v, 'econ'), myCell, 'UniformOutput', false);

myOtpt = cell(a, b, matW);

for i = 1:a
    for j = 1:b
        for k = 1:matW
            myA = myCellL{i, j}(:, k);
            myB = myCellSig{i, j}(k, k);
            myC = myCellR{i, j}(:, k);
            myOtpt{i, j, k} = {myA, myB, myC};
        end
    end
end