err.dif = abs(c);
err.log.dif = zeros(domain.length.I1, domain.length.I2);
for i = 1:size(pm.space.comb, 1)
    
    err.log.dif(i) = err.log.dif(i)+log10(err.dif(i));
    
end

figure(2)
% titl.log_err.exact=sprintf('Difference between exact and interpolation, initial point = [%d %d]', ...
%     pm.trial.val(1), pm.trial.val(2));

surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.dif');
% title(titl.log_err.exact);
xlabel('inclusion 1', 'FontSize', 18)
ylabel('inclusion 2', 'FontSize', 18)
zlabel('log error difference', 'FontSize', 18)
set(gca,'fontsize',18)
axi.err = sprintf('');
axis([1 2 1 2])
axi.lim = [-8, -2];
zlim(axi.lim)
axis square
view([-60 30])
set(legend,'FontSize',18);