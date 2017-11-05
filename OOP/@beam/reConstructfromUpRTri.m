function [obj] = reConstructfromUpRTri(obj)
% reconstruct from upper right triangular matrix, For storage purposes.

inpt = obj.err.reConstruct;

otpt = full(inpt + tril(inpt', -1));

obj.err.reConstructOtpt = otpt;