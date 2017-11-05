clear variables; clc;
% 4 sample points, each has 3 values.
a1.val1 = [1 2 3; 4 5 6];
a1.val2 = [3 2 1; 6 5 4];
a1.val3 = [1 4 3; 2 4 1];
a2.val1 = [2 3 4; 5 6 7];
a2.val2 = [4 3 2; 7 6 5];
a2.val3 = [2 8 7; 9 5 3];
a3.val1 = [3 4 5; 6 7 8];
a3.val2 = [5 4 3; 8 7 6];
a3.val3 = [5 6 7; 6 5 8];
a4.val1 = [4 5 6; 7 8 9];
a4.val2 = [6 5 4; 9 8 7];
a4.val3 = [1 2 3; 2 9 5];
% 
z.val = [a1.val1 a1.val2 a1.val3; a2.val1 a2.val2 a2.val3; ...
    a3.val1 a3.val2 a3.val3; a4.val1 a4.val2 a4.val3];

xy = [1 1; 1 2; 2 1; 2 2];
%% interpolate, sum, sumsqr.
[coeff.val] = LagInterpolationCoeff(xy, z.val);

range.x = (1:0.1:2);
range.y = (1:0.1:2);
no.range = length(range.x);
range.forthsm = zeros(no.range, no.range);

for i_range = 1:no.range
    for j_range = 1:no.range
        
        otpt.x = range.x(i_range);
        otpt.y = range.y(j_range);
        
        otpt.val = LagInterpolationOtptSingle(coeff.val, otpt.x, otpt.y, 4);
        otpt.sm = otpt.val(:, 1:3) + otpt.val(:, 4:6) + otpt.val(:, 7:9);
        otpt.sq = sumsqr(otpt.sm);
        range.forthsm(i_range, j_range) = range.forthsm(i_range, j_range) + otpt.sq;
        
    end
end

%% interpolate, re-align, combine.
otpt.range = zeros(no.range, no.range);
for i_range = 1:no.range
    for j_range = 1:no.range
        
        otpt.x = range.x(i_range);
        otpt.y = range.y(j_range);
        
        otpt.val = LagInterpolationOtptSingle(coeff.val, otpt.x, otpt.y, 4);
        otpt.realgn = reshape(otpt.val, [6, 3]);
        otpt.comb = otpt.realgn' * otpt.realgn;
        otpt.final = sum(otpt.comb(:));
        otpt.range(i_range, j_range) = otpt.range(i_range, j_range)+otpt.final;
    end
end

%% 


%%
a1.nm1 = sumsqr(a1.val1);
a1.nm2 = sumsqr(a1.val2);
a1.nm3 = sumsqr(a1.val3);
a1.nm = a1.nm1 + a1.nm2 + a1.nm3;


a2.nm1 = sumsqr(a2.val1);
a2.nm2 = sumsqr(a2.val2);
a2.nm3 = sumsqr(a2.val3);
a2.nm = a2.nm1 + a2.nm2 + a2.nm3;

a3.nm1 = sumsqr(a3.val1);
a3.nm2 = sumsqr(a3.val2);
a3.nm3 = sumsqr(a3.val3);
a3.nm = a3.nm1 + a3.nm2 + a3.nm3;
 
a4.nm1 = sumsqr(a4.val1);
a4.nm2 = sumsqr(a4.val2);
a4.nm3 = sumsqr(a4.val3);
a4.nm = a4.nm1 + a4.nm2 + a4.nm3;

% z.nm = [a1.nm1 a1.nm2 a1.nm3; a2.nm1 a2.nm2 a2.nm3; a3.nm1 a3.nm2 a3.nm3; a4.nm1 a4.nm2 a4.nm3];
z.nm = [a1.nm; a2.nm; a3.nm; a4.nm];

[coeff.nm] = LagInterpolationCoeff(xy, z.nm);
range.onsm = zeros(no.range, no.range);
for i_range = 1:no.range
    for j_range = 1:no.range
        
        otpt.x = range.x(i_range);
        otpt.y = range.y(j_range);
        otpt.nm = LagInterpolationOtptSingle(coeff.nm, otpt.x, otpt.y, 4);
        range.onsm(i_range, j_range) = range.onsm(i_range, j_range)+otpt.nm;
        
    end
end
keyboard
figure(1)
surf(range.x, range.y, range.forthsm);
figure(2)
surf(range.x, range.y, range.onsm);
figure(3)
surf(range.x, range.y, abs(range.forthsm-range.onsm))

