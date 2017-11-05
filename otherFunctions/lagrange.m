function otpt = lagrange(xcoord, ycoord, inptx, type)
% lagrange interpolation in 1d. Input xd is the coords of x-direction, yd are 
% known values of y-direction, inptx is the x-value wish to be interpolated. 
% xcoord is sample location of x, ycoord is the related known values for x,
% scalar arrays for scalar case and matrix cells for matrix case. 
% inptx is the input x value to be computed. 
% see the Wikipedia page for the following tests:
% clear; clc;
% scalar case
% x1 = 1;
% x2 = 2;
% x3 = 3;
% y1 = 1;
% y2 = 8; 
% y3 = 27;
% xcoord = [x1 x2 x3]';
% ycoord = [y1 y2 y3]';
% inptx = 1;
% type = 'scalar';

% matrix case
% x1 = 1;
% x2 = 2;
% x3 = 3;
% y1 = [1 2; 3 4];
% y2 = [3 4; 1 2]; 
% y3 = [2 4; 5 6];
% xcoord = [x1 x2 x3]';
% ycoord = {y1 y2 y3}';
% inptx = 2;
% type = 'matrix';

otpt = sparse(0);

for i=1:length(xcoord)
    
    % fix ith sample x value, to obtain ith Lagrange polynomial.
    afterFix = [xcoord(1:i - 1); xcoord(i + 1:end)];
    % denominator, [fix - x1; fix - x2; ... ; fix - xn].
    de = xcoord(i) - afterFix;
    % numerator, [inptx - x1; inptx - x2; ... ; inptx - xn].
    nu = inptx - afterFix;
    % prod(nu)) / (prod(de) is the polynomial value at inptx
    switch type
        case 'scalar'
            % yd(i) * (prod(nu)) / (prod(de)) denotes (the y value at sample
            % point i) multiply (polynomial value at inptx). 
            otpt = otpt + ycoord(i) * (prod(nu)) / (prod(de));
        case 'matrix'
            otpt = otpt + ycoord{i} * (prod(nu)) / (prod(de));
            
    end
    
end
% sum yd(i) * (prod(nu)) / (prod(de)) for i times, to obtain the desired
% value at inptx