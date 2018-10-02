
plotData;
% cd('/Users/kevin/Documents/MATLAB/thesisResults/13092018_2218_Ibeam/trial=1');
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
load('errProposedNouiTujN20Iter20Add2.mat', ...
    'errProposedNouiTujN20Iter20Add2');


phiRef = errOriginalIter20Add2.phi.val;
phiPro = errProposedNouiTujN20Iter20Add2.phi.val;

pmAll = canti.pmVal.comb.space;
% for ip = 1:81
ip = 9;
pmTest = pmAll(ip, 4:5);
disp(pmTest)
% % solve alpha.
% K1 = canti.sti.mtxCell{1};
% K2 = canti.sti.mtxCell{2};
% M = canti.mas.mtx;
% F = canti.fce.val;
% dt = canti.time.step;
% maxt = canti.time.max;
% U0 = zeros(length(K1), 1);
% V0 = U0;
% phiid = eye(length(K1));
% qd = canti.qoi.dof;
% qt = canti.qoi.t;
% pm1 = logspace(-1, 1, 9);
% pm2 = pm1;
% 
% K = K1 * pmTest(1) + K2 * 1;
% C = K1 * pmTest(2);
% 
% % proposed approximation.
% mPro = phiPro' * M * phiPro;
% kPro = phiPro' * K * phiPro;
% cPro = phiPro' * C * phiPro;
% fPro = phiPro' * F;
% u0 = zeros(length(kPro), 1);
% v0 = u0;
% [rvDisPro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
%     (phiPro, mPro, cPro, kPro, fPro, 'average', dt, maxt, u0, v0);
% [Ue, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
%     (phiid, M, C, K, F, 'average', dt, maxt, U0, V0);
% UrPro = phiPro * rvDisPro;
% UerrPro = Ue - UrPro;
% errPro = norm(UerrPro(qd, qt), 'fro') / canti.dis.norm.trial;
% % reference approximation.
% mRef = phiRef' * M * phiRef;
% kRef = phiRef' * K * phiRef;
% cRef = phiRef' * C * phiRef;
% fRef = phiRef' * F;
% u0 = zeros(length(kRef), 1);
% v0 = u0;
% [rvDisRef, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
%     (phiRef, mRef, cRef, kRef, fRef, 'average', dt, maxt, u0, v0);
% UrRef = phiRef * rvDisRef;
% UerrRef = Ue - UrRef;
% errRef = norm(UerrRef(qd, qt), 'fro') / canti.dis.norm.trial;
% %%
% dofTest = 50;
% x = 0:99;
% Ueq = Ue(qd, :);
% UrProq = UrPro(qd, :);
% UrRefq = UrRef(qd, :);
% 
% % Ueqm = zeros(1, 100);
% % UrProqm = Ueqm;
% % UrRefqm = Ueqm;
% % for ip = 1:100
% %
% %     Ueqm(ip) = Ueqm(ip) + norm(Ueq(:, ip), 'fro');
% %     UrProqm(ip) = UrProqm(ip) + norm(UrProq(:, ip), 'fro');
% %     UrRefqm(ip) = UrRefqm(ip) + norm(UrRefq(:, ip), 'fro');
% %
% % end
% Ueqm = mean(Ueq);
% UrProqm = mean(UrProq);
% UrRefqm = mean(UrRefq);
% % plot(x, Ue(dofTest, :), 'k', 'LineWidth', lwOther)
% % hold on
% % plot(x, UrPro(dofTest, :), 'r--', 'LineWidth', lwOther)
% % plot(x, UrRef(dofTest, :), 'b-.', 'LineWidth', lwOther)
% % subplot(9, 9, ip)
% plot(x, Ueqm, 'k', 'LineWidth', lwOther)
% hold on
% plot(x, UrProqm, 'r--', 'LineWidth', lwOther)
% plot(x, UrRefqm, 'b-.', 'LineWidth', lwOther)
% legend('Exact Solution', 'Proposed method', 'Reference method', ...
%     'Location', 'northeast')
% xlabel('Time')
% ylabel('Amplitude')
% set(gca, 'fontsize', fsAll)
% grid on
% % set(gca,'xtick',[])
% % set(gca,'xticklabel',[])
% % set(gca,'ytick',[])
% % set(gca,'yticklabel',[])
% axis square
% % end