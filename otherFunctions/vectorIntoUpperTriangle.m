function otpt = vectorIntoUpperTriangle(inpt, bool, N)
% this function 1. transforms the input vector into full upper triangular
% matrix (follow the transformation in upperTriangleIntoVector.m); 2.
% determine if output is upper triangular matrix.

% inpt is the input vector, bool is the boolean vector, N is the dimension
% of the square upper trianglular matrix.

otpt = zeros(N);
otpt(bool) = inpt;

if istriu(otpt) == 0
    error('The output is not upper triangular matrix')
end