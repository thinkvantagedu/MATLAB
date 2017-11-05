clear; clc;
%% STARTVARIABLES
[X,Y]=meshgrid([1 2], [-1 1]);
Z = [1 2; 3 4];

% step = 0.5;
px = 1.5;
py = 0;

%% INTERPOLATION
for i=1:size(X,1)
    % x vector must be a column vector for the lagrange function
    x = X(i,:)';
    % z vector must be a column vector for the lagrange function
    z = Z(i,:)';
    p=[];

    p = [p,lagrange(x,z,px, 'scalar')];
    
    % save curves in x direction
    xstore{i} = p;
    
end

y = Y(:,1);
% interpolate in y-direction
for i=1:length(xstore{1})
    p=[];
    z=[];
    for l=1:length(y)
        z = [z;xstore{l}(i)];
    end
    
    p = [p;lagrange(y,z,py, 'scalar')];
    
end

%% test function LagrangeInterpolation2Dscalar.
gridx = X;
gridy = Y;    

gridz = Z;
inptx = px;
inpty = py;

otpt = LagrangeInterpolation2Dscalar(inptx, inpty, gridx, gridy, gridz);

%% test different sample points but same values, same otpt?
gridxs = X;
gridys = Y;
gridxe = 10 .^ gridxs;
gridye = 10 .^ gridys;
gridzs = {[1 2 3; 3 4 5] [1 3 5; 5 7 9]; [2 3 4; 4 5 6] [2 4 6; 6 8 9]};

inptxs = 1.5; 
inptys = 0;
inptxe = 10 ^ inptxs;
inptye = 10 ^ inptys;
[otpts] = LagrangeInterpolation2Dmatrix(inptxs, inptys, gridxs, gridys, gridzs);
[otpte] = LagrangeInterpolation2Dmatrix(inptxe, inptye, gridxe, gridye, gridzs);

%% test function LagrangeInterpolation2Dmatrix
[gridxm, gridym] = meshgrid([-1, 1], [-1, 1]);
gridzm = gridzs;

inptxm = 0.5;
inptym = -0.5;

[otptm] = LagrangeInterpolation2Dmatrix(inptxm, inptym, gridxm, gridym, gridzm);
% compare with the coeffcient interpolation
xy = [gridxm(:) gridym(:)];
z = gridzm(:);
z = cell2mat(z);
[coeff] = LagInterpolationCoeff(xy, z);

[val] = LagInterpolationOtptSingle(coeff, inptxm, inptym, 4);