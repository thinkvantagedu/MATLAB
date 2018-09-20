clc; clf;
% exact solution.
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter10Add2.mat', 'errOriginalIter10Add2')
load('nouiTuj/errProposedNouiTujN20Iter10Add2.mat', 'errProposedNouiTujN20Iter10Add2')
phi = errOriginalIter10Add2.phi.val;
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
%%
% approximation;
al = rand(size(phi, 2), canti.no.t_step);
ntest = 30;
tratio = zeros(10, ntest);
for ic = 1:ntest % repeat ntest times and take average.
    for it = 1:10
        
        nit = 2 * it;
        phic = phi(:, 1:nit);
        alc = al(1:nit, :);
        func = @() phic * alc;
        tr = timeit(func);
        tratio(it, ic) = tratio(it, ic) + te / tr;
        
    end
    trav = sum(tratio, 2) / ntest;
end
%%
xA = 2:2:20;
plotData;

plot(xA, trav, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
grid on
set(gca,'fontsize',fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel('Speed-up', 'FontSize', fsAll);
axis square
xlim([0 20])