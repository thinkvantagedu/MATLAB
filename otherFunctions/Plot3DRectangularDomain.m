a = zeros(25, 25);

a(1) = 0.1;

surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), a);


set(gca,'fontsize',25)
xlabel('inclusion 1', 'FontSize', 36)
ylabel('inclusion 2', 'FontSize', 36)
zlabel('error', 'FontSize', 36)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
set(gca, 'ZScale', 'log')
axi.err=sprintf('');
axis([1 2 1 2])
axi.lim = [0, err.max.val0];
zlim(axi.lim)
axis square
view([-60 30])
set(legend,'FontSize',20);