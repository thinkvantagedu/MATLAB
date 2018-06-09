clear; clc;
m1 = zeros(10, 10);
for i = 1:numel(m1)
    m1(i) = m1(i) + randi(50);
end

m1i = m1(4:8, 4:7);

m1o = m1;
m1o(4:8, 4:7) = 0;

m2 = zeros(10, 10);
for i = 1:numel(m2)
    m2(i) = m2(i) + randi(50);
end

m2i = m2(4:8, 4:7);

m2o = m2;
m2o(4:8, 4:7) = 0;

m3 = zeros(10, 10);
for i = 1:numel(m3)
    m3(i) = m3(i) + randi(50);
end

m3i = m3(4:8, 4:7);

m3o = m3;
m3o(4:8, 4:7) = 0;

m4 = zeros(10, 10);
for i = 1:numel(m4)
    m4(i) = m4(i) + randi(50);
end

m4i = m4(4:8, 4:7);

m4o = m4;
m4o(4:8, 4:7) = 0;

% interpolate entire matrix.
xl = 0;
xr = 2;
yl = 0;
yr = 2;
x = 1.35;
y = 1.77;
[gridx, gridy] = meshgrid([xl, xr], [yl, yr]);
gridz = {m1 m2; m3 m4};
[otpt] = LagrangeInterpolation2D(x, y, gridx, gridy, gridz, 'matrix');

% interpolate in and out separately
gridzi = {m1i m2i; m3i m4i};
[otpti] = LagrangeInterpolation2D(x, y, gridx, gridy, gridzi, 'matrix');
gridzo = {m1o m2o; m3o m4o};
[otpto] = LagrangeInterpolation2D(x, y, gridx, gridy, gridzo, 'matrix');


