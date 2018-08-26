clc; 
% exact solution.
plotData;
dt = fixie.time.step;
maxt = fixie.time.max;
M = fixie.mas.mtx;
C = fixie.sti.mtxCell{1} * 10;
K = fixie.sti.mtxCell{1} * 10 + ...
    fixie.sti.mtxCell{2} * fixie.pmVal.s.fix;
F = fixie.fce.val;
nd = fixie.no.dof;
u0 = zeros(nd, 1);
v0 = zeros(nd, 1);
[~, ~, ~, disMax, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (eye(nd), M, C, K, F, 'average', dt, maxt, u0, v0);
disMaxq = disMax(fixie.qoi.dof, fixie.qoi.t);
funcN = @() NewmarkBetaReducedMethod(eye(nd), ...
    M, C, K, F, 'average', dt, maxt, u0, v0);
te = timeit(funcN);

% approximation.
phi = rand(nd, 78);
al = rand(78, 50);
xa = [12 17 21 29 32 36 45 54 65 70 78];
tratio = zeros(11, 1);
for it = 1:11
    
    phic = phi(:, 1:xa(it));
    alc = al(1:xa(it), :);
    func = @() phic * alc;
    tr = timeit(func);
    tratio(it) = tratio(it) + te / tr;
    
end

%%
plotData;

semilogy(xa, tratio, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
grid on
set(gca,'fontsize',fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel('Speed-up', 'FontSize', fsAll);
axis square
xticks(xa);
ylim([500 1500])