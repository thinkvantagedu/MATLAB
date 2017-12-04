% this script follows NewmarkBetaReducedMethodAssembleMTXSolution, test
% case 1: mphialpha + cphialpha + mu1k1phialpha + mu2k2phialpha = f;
% case 2: separate phi into phiVec, see if it is a sum relation.
k1 = [2 -1; -2 1];
k2 = k - k1;

mu1 = 0.8;
mu2 = 0.3;

phi = magic(2);
phi1 = phi(:, 1);
phi2 = phi(:, 2);

alm = [5; 8];
alc = [3; 4];
alk = [9; 6];

% case 1:
f1 = m * phi * alm + c * phi * alc + (mu1 * k1 + mu2 * k2) * phi * alk;

% case 2:
f2e1 = m * phi1 * alm(1) + c * phi1 * alc(1) + ...
    mu1 * k1 * phi1 * alk(1) + mu2 * k2 * phi1 * alk(1);
f2e2 = m * phi2 * alm(2) + c * phi2 * alc(2) + ...
    mu1 * k1 * phi2 * alk(2) + mu2 * k2 * phi2 * alk(2);

% result: f1 = f2e1 + f2e2, case 1 = case 2. 