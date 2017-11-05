clear; clc;
% umn, m denotes sample point, n denotes nth response at mth sample point.
u11 = (1:6)';
u12 = (3:8)';
u13 = (4:9)';

e13c = [u11 u12 u13];
e13ct = e13c' * e13c;
e13cnm = sqrt(sum(e13ct(:)));

u21 = u11 + 1;
u22 = u12 + 2;
u23 = u13 + 1;

e23c = [u21 u22 u23];
e23ct = e23c' * e23c;
e23cnm = sqrt(sum(e23ct(:)));

u31 = u11 + 4;
u32 = u12 + 5;
u33 = u13 + 2;

e33c = [u31 u32 u33];
e33ct = e33c' * e33c;
e33cnm = sqrt(sum(e33ct(:)));

u41 = u11 + 3;
u42 = u12 + 1;
u43 = u13 + 7;

e43c = [u41 u42 u43];
e43ct = e43c' * e43c;
e43cnm = sqrt(sum(e43ct(:)));

e13ct = triu(e13ct);
e23ct = triu(e23ct);
e33ct = triu(e33ct);
e43ct = triu(e43ct);

% interpolate emnct at random point.
xl = 0;
xr = 2;
yl = 0;
yr = 2;
x = 1.3;
y = 1.77;
[gridx, gridy] = meshgrid([xl, xr], [yl, yr]);
gridz3 = {e13ct e23ct; e33ct e43ct};
[otpt3] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridz3);

% add a new response to the 4 sample eTe
u14 = (2:7)';
e14c = [e13c u14];
u24 = u14 + 3;
e24c = [e23c u24];
u34 = u14 - 2;
e34c = [e33c u34];
u44 = u14 + 5;
e44c = [e43c u44];

e14ct = triu(e14c' * e14c);
e24ct = triu(e24c' * e24c);
e34ct = triu(e34c' * e34c);
e44ct = triu(e44c' * e44c);

gridz4 = {e14ct e24ct; e34ct e44ct};
[otpt4] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridz4);

u15 = (-1:4)';
e15c = [e14c u15];
u25 = u15 + 3;
e25c = [e24c u25];
u35 = u15 - 2;
e35c = [e34c u35];
u45 = u15 + 5;
e45c = [e44c u45];

e15ct = triu(e15c' * e15c);
e25ct = triu(e25c' * e25c);
e35ct = triu(e35c' * e35c);
e45ct = triu(e45c' * e45c);

gridz5 = {e15ct e25ct; e35ct e45ct};
[otpt5] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridz5);

% only interpolate the newly added column of eTe, is the result of
% interpolation same as interpolating the entire eTe? YES!

e14ctn = e14ct(:, end);
e24ctn = e24ct(:, end);
e34ctn = e34ct(:, end);
e44ctn = e44ct(:, end);

gridz4n = {e14ctn e24ctn; e34ctn e44ctn};
[otpt4n] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridz4n);

e15ctn = e15ct(:, end);
e25ctn = e25ct(:, end);
e35ctn = e35ct(:, end);
e45ctn = e45ct(:, end);

gridz5n = {e15ctn e25ctn; e35ctn e45ctn};
[otpt5n] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, gridz5n);













