function [errOtpt] = GSAMultiplyRvPmErr(rv, pm, errInpt)

rvFull = reConstruct(rv);

pmFull = reConstruct(pm);

errOtpt = errInpt .* rvFull .* pmFull;

errOtpt = sum(errOtpt(:));