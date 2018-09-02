plotData;
cd ~/Desktop/Temp/thesisResults/30082018_1554_residual/trial=289;

load('errOriginal.mat', 'errOriginal');
load('errProposed.mat', 'errProposed');
load('errResidual.mat', 'errResidual');

nPhiIni = 2;
nPhiAdd = 2;
nRb = 20;

%% plot decay value curve.
errx = (nPhiIni:nPhiAdd:nRb);
errOriMax = errOriginal.store.realMax;
errProMax = errProposed.store.max.verify;

% residual needs to find related magic points location, this is done by
% re-calculating all response surfaces.
resLoc = errResidual.store.realLoc;
resSurf = errOriginal.store.allSurf;
errResMax = zeros(10, 1);
phi = errResidual.phi.val;
K1 = fixie.sti.mtxCell{1};
K2 = fixie.sti.mtxCell{2};
M = fixie.mas.mtx;
F = fixie.fce.val;

dt = fixie.time.step;
maxt = fixie.time.max;
U0 = zeros(length(K1), 1);
V0 = zeros(length(K1), 1);
phiid = eye(length(K1));
qd = fixie.qoi.dof;
qt = fixie.qoi.t;
pm1 = logspace(-1, 1, 17);
pm2 = logspace(-1, 1, 17);
for ic = 1:10
    % knowing magic point.
    % calculate 1 reduced variable --> approximation --> error.
    phiv = phi(:, 1:ic);
    
    pm = [pm1(resLoc(ic, 1)) pm2(resLoc(ic, 2))];
    K = K1 * pm(1) + K2 * 1;
    C = K1 * pm(2);
    m = phiv' * M * phiv;
    k = phiv' * K * phiv;
    c = phiv' * C * phiv;
    f = phiv' * F;
    u0 = zeros(length(k), 1);
    v0 = zeros(length(k), 1);
    [rvDis, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiv, m, c, k, f, 'average', dt, maxt, u0, v0);
    [U, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiid, M, C, K, F, 'average', dt, maxt, U0, V0);
    
    Ur = phiv * rvDis;
    Uerr = U - Ur;
    err = norm(Uerr(qd, qt), 'fro') / fixie.dis.norm.trial;
    errResMax(ic) = errResMax(ic) + err;
end



figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errx, errResMax, 'g-*', 'MarkerSize', msAll, 'lineWidth', lwAll);

xticks(errx);
axis([0 nRb errProMax(end) errResMax(1)]);
axis square
grid on
legend({'true RB-error indicator', 'proposed indicator', 'residual indicator'}, 'FontSize', fsAll);
set(gca,'fontsize',fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);