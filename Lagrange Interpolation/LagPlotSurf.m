% LagInterpolationMtx--->MTX--->LagInterpolationCoeff--->coeff--->
% +xy--->LagInterpolationOtptSingle--->single for random point--->for
% loop--->iterate over entire domain.

% inpt_xy = [1 1; 1 2; 2 1; 2 2];
% 
% inpt_z = [2; 3; 7; 4];
% 
% [coeff]=LagInterpolationCoeff(inpt_xy, inpt_z);
% 
% x = (1:0.01:2);
% 
% y = (1:0.01:2);
% 
% xy = combvec(x, y);
% 
% xy = xy'; 
% 
% z_ind = zeros(length(x), length(y));
% 
% for i = 1:length(xy)
%     
%     [lag_val] = LagInterpolationOtptSingle(coeff, xy(i, 1), xy(i, 2));
%     z_ind(i) = z_ind(i)+lag_val;
%     
% end
% 
% surf(x, y, z_ind);
% 
% % hold on
% 
inpt_xy = [1 1; 1 1.5; 1 2; 1.5 1; 1.5 1.5; 1.5 2; 2 1; 2 1.5; 2 2];

inpt_z = [2; 1; 3; 2; 3; 2; 7; 3; 4];

[coeff]=LagInterpolationCoeff(inpt_xy, inpt_z);

z_ind = zeros(length(x), length(y));

for i = 1:length(xy)
    
    [lag_val] = LagInterpolationOtptSingle(coeff, xy(i, 1), xy(i, 2));
    z_ind(i) = z_ind(i)+lag_val;
    
end

surf(x, y, z_ind);
axis([1 2 1 2 1 7])