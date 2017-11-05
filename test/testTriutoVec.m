clear; clc;

mlength = 5;
mtx = zeros(mlength);

for i = 1:mlength
    for j = i:mlength
        mtx(i, j) = mtx(i, j) + randi(100);
    end
end

mtxvec = mtx(:);
mtxnonzero = nonzeros(mtxvec);