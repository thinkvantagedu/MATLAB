clear; clc;
% this script tests the effcient way of storing upper triangular matrices.
N = 41;
UT = triu(rand(N, N)); % Our sample test matrix
%% method 1: store vectors
% transform upper triangular matrix into Boolean vectors.
tic
Boolind = triu(true(N, N));
Boolind = Boolind(:);
UTvec = UT(Boolind);
toc
% transform the vectors back to upper triangular full matrices.
tic
UTcopy = zeros(N);
UTcopy(Boolind) = UTvec;
toc

%% method 2: store 2 triangles as 1 square.
% tic
% d2 = diag(m2);
% m2(1 : N + 1 : N ^ 2) = 0;
% m12 = [m1 + m2.' d2];     % n x (n + 1) to store
% toc