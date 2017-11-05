clear variables;
test_NO = 1;
GreedyAlgorithmTrial;
GreedyAlgorithmIteration;
clear phi.fre.all
GreedyAlgorithmInterpolationTrial;
GreedyAlgorithmInterpolationIteration;
hold on
suptitle('error in error (refined grid)');
subplot(2, 3, test_NO)
%%
err.store.diff = abs(err.store.lag' - err.store.val');
err.store.log_diff = MTXintoLog10Scale(err.store.diff);
surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.log_diff);
xlabel('parameter 1', 'FontSize', 10)
ylabel('parameter 2', 'FontSize', 10) 
zlabel('error in error', 'FontSize', 10)
set(gca,'fontsize',10)
axis([-1 1 -1 1])
axi.lim = [-5 -1.5];
zlim(axi.lim)
axis square
view([120 30])
set(legend,'FontSize',8);

% err_save = err.store_diff;
% save('/home/xiaohan/Desktop/Temp/MATLAB/Results/GS_Algorithm/interpolation/error_in_error_linear_refine_iter2.mat', ...
%     'err_save');