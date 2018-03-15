clear; clc;
% this script tests the effcient way of storing upper triangular matrices.
N = 10000;
m1 = triu(rand(N, N)); % Our sample test matrix
m2 = triu(rand(N, N));
%% method 1: store vectors
% transform upper trniangular matrix into Boolean vectors.
% tic
% Boolind = triu(true(N, N));
% Boolind = Boolind(:);
% m1vec = m1(Boolind);
% m2vec = m2(Boolind);
% toc
% % transform the vectors back to upper triangular full matrices.
% tic
% UTcopy = zeros(N);
% UTcopy(Boolind) = UTvec;
% toc

%% method 2: store 2 triangles as 1 square.
tic
d2 = diag(m2);
m2(1 : N + 1 : N ^ 2) = 0;
m12 = [m1 + m2.' d2];     % n x (n + 1) to store
toc