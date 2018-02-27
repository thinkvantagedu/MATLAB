% this script tests speed of different cases of P' * M' * M * P.
clear; clc;
L = 10;  % Number of loops
N = 10000;
M = rand(N, N);
P = rand(N, 3);
% Warm up! Ignore!
for k = 1:L
  C = P' * (M' * M) * P;
end
tic;
for k = 1:L
  D  = M' * M;
  C1 = P' * D * P;
end
toc
tic;
for k = 1:L
  C2 = P' * (M' * M) * P;
end
toc
tic;
for k = 1:L
  C3 = P' * M' * M * P;
end
toc
tic;
for k = 1:L
  D  = M * P;
  C4 = D' * D;
end
toc

norm((C - C1) ./ C, 'fro')
norm((C - C2) ./ C, 'fro')
norm((C - C3) ./ C, 'fro')
norm((C - C4) ./ C, 'fro')