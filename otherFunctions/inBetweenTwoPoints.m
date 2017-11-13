function otpt = inBetweenTwoPoints(inpt, region)
% this function determines in 1D, if a point inpt is between a domain 
% [endL endR]. If in, otpt = 1, if not, otpt = 0.
% inpt is a scalar, region is a 2-by-1 array which denotes a domain.
endL = region(1);
endR = region(2);
if inpt < endL || inpt > endR
    otpt = 0;
elseif endL <= inpt && inpt <= endR
    otpt = 1;
end