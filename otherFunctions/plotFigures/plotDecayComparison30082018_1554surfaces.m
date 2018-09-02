plotData;
cd ~/Desktop/Temp/thesisResults/30082018_1554_residual/trial=289/;

load('errOriginal.mat', 'errOriginal');
load('errProposed.mat', 'errProposed');
load('errResidual.mat', 'errResidual');

ex = logspace(-1, 1, 17);
ey = logspace(-1, 1, 17);

eoSurfAll = errOriginal.store.allSurf;
epSurfAll = errProposed.store.allSurf.hhat;

for ip = 1:10
    
    eoSurf = eoSurfAll{ip};
    epSurf = epSurfAll{ip};
    eDiff = abs(eoSurf - epSurf);
    figure
    surf(ex, ey, eDiff');
    set(gca, 'XScale', 'log', 'YScale', 'log', 'ZScale','log')
    shading interp
    view(3)
    
    xlabel('Youngs Modulus')
    ylabel('Damping coefficient')
    zlabel('Maximum relative error')
    colormap(jet)
    set(gca,'fontsize', 20)
    axis square
end