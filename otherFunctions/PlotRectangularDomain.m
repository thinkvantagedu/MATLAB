clear variables; clc;

a = linspace(1, 2, 25);

b = linspace(1, 2, 25);

c = a;

plot(a, c)

set(gca,'fontsize',25)

xlabel('inclusion 1', 'FontSize', 36)
ylabel('inclusion 2', 'FontSize', 36)
axis square
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')