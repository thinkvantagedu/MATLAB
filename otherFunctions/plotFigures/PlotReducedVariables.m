figure(2)
x = 1:61;
phi.fre.all = progdata.store{1, 2}{:};

phi.fre.toplot = phi.fre.all(:, 4:10);

reduced_var.all = progdata.store{2, 2}{:};

reduced_var.toplot = reduced_var.all(4:10, :);

for i = 1:size(phi.fre.toplot, 2)

subplot(4, 2, i)

plot(x, reduced_var.toplot(i, :))

set(gca,'fontsize',20)
set(legend,'FontSize',20);
grid on

end