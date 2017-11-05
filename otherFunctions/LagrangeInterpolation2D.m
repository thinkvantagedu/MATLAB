function [otpt] = LagrangeInterpolation2D...
    (inptx, inpty, gridx, gridy, gridz, type)
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
    switch type
        case 'matrix'
            % interpolate for every parameter value j and add it to p
            p = [p, lagrange(x,z,inptx, 'matrix')];
        case 'scalar'
            p = [p, lagrange(x,z,inptx, 'scalar')];
    end
    % save curves in x direction
    xstore{i} = p;
    
end

y = gridy(:,1);

% interpolate in y-direction
for i=1:length(xstore{1})
    switch type
        case 'matrix'
            
            z = cell(2, 1);
            
            for l=1:length(y)
                z(l) = xstore(l);
            end
            
            % interpolate for every parameter value j and add it to p
            otpt =lagrange(y, z, inpty, 'matrix');
            
        case 'scalar'
            
            z = zeros(2, 1);
            
            for l=1:length(y)
                z(l) = z(l) + xstore{l}(i);
            end
            
            % interpolate for every parameter value j and add it to p
            otpt = lagrange(y, z, inpty, 'scalar');
            
    end
end