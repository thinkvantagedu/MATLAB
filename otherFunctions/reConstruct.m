function [otpt] = reConstruct(inpt)
% reconstruct full matrix from a 

otpt = full(inpt + tril(inpt', -1));