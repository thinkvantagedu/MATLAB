function [bool, otpt] = upperTriangleIntoVector(inpt)
% this function 1. determines if input is upper triangular matrix; 2.
% transform upper triangular matrix into column vector in order to optimise
% storage. 
if istriu(inpt) == 0
    error('The input is not upper triangular matrix')
elseif istriu(inpt) == 1
    N = size(inpt, 1);
    
    bool = triu(true(N, N));
    bool = bool(:);
    otpt = inpt(bool);
    
end