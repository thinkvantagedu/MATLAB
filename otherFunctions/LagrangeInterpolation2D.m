function [coeff1, coeff2, otpt] = LagrangeInterpolation2D...
    (inptx, inpty, gridx, gridy, gridz)
% this function performs Lagrange interpolation with matrix inputs. inptx,
% inpty are input x-y coordinate (the point to compute). gridx, gridy are n
% by n matrices denotes x-y coordinates of sample points (generated from
% meshgrid function). z are the corresponding matrices of gridx, gridy, in a 2 
% by 2 cell array. Notice gridx and gridy needs to be in clockwise or
% anti-clockwise order, cannot be disordered.
% example: see testItplCut.
xstore = cell(1, 2);
for i=1:size(gridx,1)
    % x vector must be a column vector for the lagrange function
    x = gridx(i,:)';
    % z vector must be a column vector for the lagrange function
    z = gridz(i,:)';
    
    p=[];
    
    % interpolate for every parameter value j and add it to p
    [coeff1, otpt] = lagrange(inptx, num2cell(x), z);
    p = [p, otpt];
    % save curves in x direction
    xstore{i} = p;
    
end

y = gridy(:,1);

% interpolate in y-direction
for i=1:length(xstore{1})
    
    z = cell(2, 1);
    
    for l=1:length(y)
        z(l) = xstore(l);
    end
    
    % interpolate for every parameter value j and add it to p
    [coeff2, otpt] = lagrange(inpty, num2cell(y), z);
    
end