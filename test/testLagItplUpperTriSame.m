clear; clc;

x = 1.2;
y = 1.5;

xl = 0;
xr = 2;
yl = 0;
yr = 2;

[gridx, gridy] = meshgrid([xl, xr], [yl yr]);

gridz = {rand(8) rand(8); rand(8) rand(8)};

[otpt] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridz);

gridzt = cellfun(@(v) triu(v), gridz, 'un', 0);

[otptt] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridzt);

a = otpt - otptt;

spy(a);