clear variables; clc;
Phi=eye(2);
K = [6 -2; -2 4];
M = [2 0; 0 1];
C = [0 0; 0 0];

dTs = 0.28;
maxT = 28;
U0 = [0; 0];
V0 = [0; 0];
acce = 'average';
nts = round(maxT / dTs) + 1;
nd = length(K);

Fs = zeros(2, nts);
Fs(:, 1) = Fs(:, 1) + [0; 10];

[us, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, Fs, acce, dTs, maxT, U0, V0);

dTl = 0.56;
ntl = round(maxT / dTl) + 1;
Fl = zeros(2, ntl);
Fl(:, 1) = Fl(:, 1) + [0; 10];

[ul, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, Fl, acce, dTl, maxT, U0, V0);

xs = 1:nts;
figure(7)
plot(xs, us(1, :));

xl = 1:ntl;
figure(8)
plot(xl, ul(1, :)); 