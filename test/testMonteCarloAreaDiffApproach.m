clear; clc; clf;
% this script tests convergence speed of Monte carlo area estimation using
% 3 sampling approaches: Halton, Sobol, Latin hypercube. 
np = 100;
ntest = length(np);
exactArea = pi / 4;


% plot the 1/4 circle.
% xaxis = 0 : 0.01 : 1;
% yaxis = sqrt(1 - xaxis .^ 2);
% plot(xaxis, yaxis, 'LineWidth', 10);
% xlabel('x');
% ylabel('y');
% legend('x^2 + y^2 = 1');

% generate the 3 sequences of points.
hp = haltonset(2); % Halton
sp = sobolset(2); % Sobol
lp = lhsdesign(np(end), 2);


errhp = zeros(ntest, 1);
errsp = zeros(ntest, 1);
errlp = zeros(ntest, 1);
errrp = zeros(ntest, 1);

for ip = 1:ntest
    npi = np(ip);
    hps = hp(1:npi, :);
    sps = sp(1:npi, :);
    lps = lp(1:npi, :); % Latin
    xhps = hps(:, 1);
    yhps = hps(:, 2);
    xsps = sps(:, 1);
    ysps = sps(:, 2);
    xlps = lps(:, 1);
    ylps = lps(:, 2);
    xrp = unifrnd(0, 1, [1, npi]);
    yrp = unifrnd(0, 1, [1, npi]);
    pInhp = sum(yhps <= sqrt(1 - xhps .^ 2) & xhps <= 1);
    pInsp = sum(ysps <= sqrt(1 - xsps .^ 2) & xsps <= 1);
    pInlp = sum(ylps <= sqrt(1 - xlps .^ 2) & xlps <= 1);
    pInrp = sum(yrp <= sqrt(1 - xrp .^ 2) & xrp <= 1);
    errhp(ip) = abs(pInhp / npi - exactArea);
    errsp(ip) = abs(pInsp / npi - exactArea);
    errlp(ip) = abs(pInlp / npi - exactArea);
    errrp(ip) = abs(pInrp / npi - exactArea);
end

xystore = {xrp, xhps, xsps, xlps; yrp, yhps, ysps, ylps};
lgd = {'Pseudorandom', 'Halton', 'Sobol', 'Latin Hypercube'};

for iq = 1:4
    axes('box', 'on') 
    scatter(xystore{1, iq}, xystore{2, iq}, 'k', 'filled');
    legend(lgd{iq})
    axis([0 1 0 1]);
    axis square
    set(gca, 'FontSize', 20)
    figure    
    
end


% semilogy(np, errhp)
% hold on
% semilogy(np, errsp)
% semilogy(np, errlp)
% semilogy(np, errrp)
% legend('Halton', 'Sobol', 'Latin', 'prandom')

grid minor
axis square

% conclusion: Sobol works best.