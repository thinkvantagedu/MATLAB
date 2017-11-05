clear variables; clc;
turnon = 0;
xy = [1 1; 1 2; 2 1; 2 2];
z.val = [1 2; 3 4; 2 3; 4 5; 1 3; 5 7; 2 4; 6 8];
% xy = [1 1; 1 5; 1 10; 5 1; 5 5; 5 10; 10 1; 10 5; 10 10];
% z.val = [1 2; 2 1; 2 3; 3 1; 1 3; 2 2; 3 2; 1 1; 2 4; 3 3; 3 1; 2 2; 1 2; 3 4; 2 2; 4 1; 1 3; 2 4];
% z.val = [6; 3; 4; 2; 1; 3; 5; 2; 6];
% test symmetric samples, are coeff also symmetric? Yes coeff are also
% symmetric, thus save half?
% z.val = [1 2 3; 2 5 6; 3 6 7; 2 3 4; 3 6 5; 4 5 2; 3 4 5; 4 6 2; 5 2 1; 4 5 6; 5 1 3; 6 3 2];
no_pm = 9;
[coeff_store] = LagInterpolationCoeff(xy, z.val);
if turnon == 1
    no_int = 10;
    lag_val_store = z.valeros(no_int, no_int);
    for x = 1:no_int
        for y = 1:no_int
            lag_val = LagInterpolationOtptSingle(coeff_store, x, y, no_pm);
            lag_val_store(x, y) = lag_val_store(x, y)+lag_val;
        end
    end
    a = 1:no_int;
    b = 1:no_int;
    
    surf(a, b, lag_val_store);
end
x = 1;
y = 1;
no_pm = 4;
lag_val = LagInterpolationOtptSingle(coeff_store, x, y, no_pm);
z0.lag_val = sum(abs((lag_val(:)).^2));
% z1 get l2 norm of original matrices. This is the correct solution.
z1.sm = zeros(4, 1);
for i = 1:4
    z1.blk = z.val((2*i-1:2*i), :);
    z1.nm = sum(abs((z1.blk(:)).^2));
    z1.sm(i) = z1.sm(i)+z1.nm;
end

z1.coef = LagInterpolationCoeff(xy, z1.sm);
z1.lag_val = LagInterpolationOtptSingle(z1.coef, x, y, no_pm);

% z2 get l2 norm of interpolating coefficients.
z2.sm = zeros(4, 1);
for i = 1:4
   z2.blk = coeff_store((2*i-1:2*i), :);
   z2.nm = sum(abs((z2.blk(:)).^2));
   z2.sm(i) = z2.sm(i)+z2.nm;
end
z2.lag_val = LagInterpolationOtptSingle(z2.sm, x, y, no_pm);