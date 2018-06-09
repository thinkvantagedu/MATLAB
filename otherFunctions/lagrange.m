function [coeff, otpty] = lagrange(inptx, xcoord, ycoord)
% lagrange interpolation in 1d. Input xd is the coords of x-direction, yd are 
% known values of y-direction, inptx is the x-value wish to be interpolated. 
% xcoord is sample location of x, ycoord is the related known values for x,
% scalar arrays for scalar case and matrix cells for matrix case. 
% inptx is the input x value to be computed. 
% see the Wikipedia page for the following tests:

otpty = sparse(0);
coeff = zeros(length(xcoord), 1);
for i = 1:length(xcoord)
    
    % fix ith sample x value, to obtain ith Lagrange polynomial.
    afterFix = [xcoord{1:i - 1}; xcoord{i + 1:end}];
    % denominator, [fix - x1; fix - x2; ... ; fix - xn].
    de = xcoord{i} - afterFix;
    % numerator, [inptx - x1; inptx - x2; ... ; inptx - xn].
    nu = inptx - afterFix;
    if nargin == 2
        % store the coefficients.
        coeff(i) = coeff(i) + prod(nu) / prod(de);
    elseif nargin == 3
        % store the coefficients.
        coeff(i) = coeff(i) + prod(nu) / prod(de);
        % prod(nu)) / (prod(de) is the polynomial value at inptx
        otpty = otpty + ycoord{i} * (prod(nu)) / (prod(de));
    end
    
end
% sum yd(i) * (prod(nu)) / (prod(de)) for i times, to obtain the desired
% value at inptx

