function [otpt] = reConstruct(inpt)
% reconstruct full matrix from a
if istriu(inpt) == 0
    error('input is not upper triangular matrix')
elseif istriu(inpt) == 1
    otpt = full(inpt + tril(inpt', -1));
end