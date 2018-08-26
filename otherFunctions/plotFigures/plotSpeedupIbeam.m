clc; 
% exact solution.
plotData;
dt = canti.time.step;
maxt = canti.time.max;
M = canti.mas.mtx;
C = canti.sti.mtxCell{1} * 10;
K = canti.sti.mtxCell{1} * 10 + ...
    canti.sti.mtxCell{2} * canti.pmVal.s.fix;
F = canti.fce.val;
nd = canti.no.dof;
u0 = zeros(nd, 1);
v0 = zeros(nd, 1);
[~, ~, ~, disMax, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (eye(nd), M, C, K, F, 'average', dt, maxt, u0, v0);
disMaxq = disMax(canti.qoi.dof, canti.qoi.t);
funcN = @() NewmarkBetaReducedMethod(eye(nd), ...
    M, C, K, F, 'average', dt, maxt, u0, v0);
te = timeit(funcN);

% approximation;
phi = canti.phi.val;
al = canti.dis.re.reVar;
ur = phi * al;
urq = ur(canti.qoi.dof, canti.qoi.t);
tratio = zeros(10, 1);
for it = 1:10
    
    phic = phi(:, 1:2 * it);
    alc = al(1:2 * it, :);
    func = @() phic * alc;
    tr = timeit(func);
    tratio(it) = tratio(it) + te / tr;
    
end
%%
xA = 2:2:20;
plotData;

semilogy(xA, tratio, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
grid on
set(gca,'fontsize',fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel('Speed-up', 'FontSize', fsAll);
axis square