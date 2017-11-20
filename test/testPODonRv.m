clear; clc;

% this script simulate eTe and related reduced variables and pm values, to
% see if SVD in rv would work. 
%% case 1: original with column space-time responses
% set up related responses. 2 interpolation samples.
testGSAVecShortMultiDimINP4t;
nr = 2;
nf = 3;
nt = 4;
respColAlli1 = [a{:}];
respColAlli2 = respColAlli1 * 3;
% set up pm domain and interpolation sample domain.
% itpl domain:
xcoord = [1 4];
% pm domain:
pmx = [1 2 3 4];

% affine pm grid, multiply these with responses:
pmafi1 = [a{1, 2, 3, 1}; a{1, 1, 1, 2}];
pmafi2 = pmafi1 + 3;
pmafi3 = pmafi1 + 5;
pmafi4 = pmafi1 - 2;

% set up eTe. 
eTepm1 = respColAlli1' * respColAlli1;
eTepm4 = respColAlli2' * respColAlli2;

% interpolate for inptx.
ycoord = {eTepm1 eTepm4};
inptxpm2 = 2;
inptxpm3 = 3;
eTepm2 = lagrange(xcoord, ycoord, inptxpm2, 'matrix');
eTepm3 = lagrange(xcoord, ycoord, inptxpm3, 'matrix');

% set up rv values for pm domain. size of rv = nr * nt.
rvpm2f1 = [1:nt; 2:nt + 1];
rvpm2f2 = rvpm2f1 - 3;
rvpm2f3 = rvpm2f1 - 8;

rvpm2cell = {rvpm2f1; rvpm2f2; rvpm2f3};
rvpm1cell = cellfun(@(v) v + 2, rvpm2cell, 'UniformOutput', 0);
rvpm3cell = cellfun(@(v) v - 5, rvpm2cell, 'UniformOutput', 0);
rvpm4cell = cellfun(@(v) v - 2, rvpm2cell, 'UniformOutput', 0);

rvpm2row = cell2mat(rvpm2cell);
rvpm1row = cell2mat(rvpm1cell);
rvpm3row = cell2mat(rvpm3cell);
rvpm4row = cell2mat(rvpm4cell);
rvpm2 = rvpm2row(:);
rvpm1 = rvpm1row(:);
rvpm3 = rvpm3row(:);
rvpm4 = rvpm4row(:);

% compute original results: rvT eT e rv.
sqrvTeTervpm1 = sqrt((pmafi1 .* rvpm1)' * (eTepm1' * eTepm1) * (rvpm1 .* pmafi1));
sqrvTeTervpm2 = sqrt((pmafi2 .* rvpm2)' * (eTepm2' * eTepm2) * (rvpm2 .* pmafi2));
sqrvTeTervpm3 = sqrt((pmafi3 .* rvpm3)' * (eTepm3' * eTepm3) * (rvpm3 .* pmafi3));
sqrvTeTervpm4 = sqrt((pmafi4 .* rvpm4)' * (eTepm4' * eTepm4) * (rvpm4 .* pmafi4));

%% case 2: developed with space and time responses and SVD on reduced variables.

rvpm = [rvpm1 rvpm2 rvpm3 rvpm4];

[rvl, rvsig, rvr] = svd(rvpm, 0);

rvl = rvl * rvsig;

eTepm1svd = rvl' * ((eTepm1' * eTepm1) .* (pmafi1 * pmafi1')) * rvl;
eTepm2svd = rvl' * ((eTepm2' * eTepm2) .* (pmafi2 * pmafi2')) * rvl;
eTepm3svd = rvl' * ((eTepm3' * eTepm3) .* (pmafi3 * pmafi3')) * rvl;
eTepm4svd = rvl' * ((eTepm4' * eTepm4) .* (pmafi4 * pmafi4')) * rvl;

% interpolate.
inptxpm1 = 1;
inptxpm4 = 4;
ycoordsvd = {eTepm1svd eTepm4svd};
eTepm1itpl = lagrange(xcoord, ycoordsvd, inptxpm1, 'matrix');
eTepm2itpl = lagrange(xcoord, ycoordsvd, inptxpm2, 'matrix');
eTepm3itpl = lagrange(xcoord, ycoordsvd, inptxpm3, 'matrix');
eTepm4itpl = lagrange(xcoord, ycoordsvd, inptxpm4, 'matrix');
% final result.
sqrvTeTervpm1svd = sqrt(rvr * eTepm1itpl * rvr');
sqrvTeTervpm2svd = sqrt(rvr * eTepm2itpl * rvr');
sqrvTeTervpm3svd = sqrt(rvr * eTepm3itpl * rvr');
sqrvTeTervpm4svd = sqrt(rvr * eTepm4itpl * rvr');






