clear; clc;

% 4 sample matrices, interpolate within a square domain. 
% test 2 cases: 
% 1. original: interpolate matrix for each parameter combination first, then
% take Frobenius norm;
% 2. comparison: take Frobenius norm first, then interpolate the norm. 
% Theory: case 1 should <= case 2. 

nd = 3;
nt = 5;

a1 = (1:15)';
a2 = a1 + 3;
a3 = a1 - 6;
a4 = a1 + 9;

a1 = reshape(a1, [nd, nt]);
a2 = reshape(a2, [nd, nt]);
a3 = reshape(a3, [nd, nt]);
a4 = reshape(a4, [nd, nt]);

z = [a1; a2; a3; a4];
l1 = 1;
r1 = 2;
l2 = 2;
r2 = 3;
xy = [l1 l2; r1 l2; l1 r2; r1 r2];
%% test 1, normal case: interpolate the full displacement, then norm the result.
[coeff] = LagInterpolationCoeff(xy, z);
<<<<<<< HEAD
% set up a sample range:
samprx = 1:0.1:2;
sampry = 1:0.1:2;
otptStore = zeros(length(samprx));
=======
samprx = l1:0.1:r1;
sampry = l2:0.1:r2;
otptfrostore = zeros(length(samprx));
>>>>>>> a1b7583500ef707fd5584c4f16a9a20a56842e0b
for i = 1:length(samprx)
    for j = 1:length(sampry)
        sampx = samprx(i);
        sampy = sampry(j);
        otpt = LagInterpolationOtptSingle(coeff, sampx, sampy, 4);
        otptfro = norm(otpt, 'fro');
<<<<<<< HEAD
        otptStore(i, j) = otptStore(i, j) + otptfro;
    end
end


%% test 2, experiment: take the norm first, then interpolate the results. t = test.
=======
        otptfrostore(i, j) = otptfrostore(i, j) + otptfro;
    end
end

%% test 2, comparison: take the norm first, then interpolate the results. t = test.
>>>>>>> a1b7583500ef707fd5584c4f16a9a20a56842e0b
a1t = norm(a1, 'fro');
a2t = norm(a2, 'fro');
a3t = norm(a3, 'fro');
a4t = norm(a4, 'fro');
otpttStore = zeros(length(samprx));
zt = [a1t; a2t; a3t; a4t];

<<<<<<< HEAD
coefft = LagInterpolationCoeff(xy, zt);
=======
[coefft] = LagInterpolationCoeff(xy, zt);

otpttstore = zeros(length(samprx));

>>>>>>> a1b7583500ef707fd5584c4f16a9a20a56842e0b
for i = 1:length(samprx)
    for j = 1:length(sampry)
        sampx = samprx(i);
        sampy = sampry(j);
        otptt = LagInterpolationOtptSingle(coefft, sampx, sampy, 4);
<<<<<<< HEAD
        otpttStore(i, j) = otpttStore(i, j) + otptt;
    end
end

disp(otptStore)
disp(otpttStore)
=======
        otpttstore(i, j) = otpttstore(i, j) + otptt;
    end
end

% Theory passed: otpttstore >= otptfrostore -----> test 2 >= test 1. 
>>>>>>> a1b7583500ef707fd5584c4f16a9a20a56842e0b
