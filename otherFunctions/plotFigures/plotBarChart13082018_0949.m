tpoff = 4950;
tpon = 10955 - 4950;
tooff = 5060 - 4940;
toon = 4940;
tothe = 4940 / 810 * 1089 * 10;
plotData;

tall = [tooff toon; tooff tothe; tpoff tpon];

h = barh(tall, 'stacked');
set(h, {'facecolor'}, {'b'; 'y'})
axis normal
grid on
legend('POD-Greedy offline', 'POD-Greedy online')
set(gca,'fontsize', fsAll)
set(gca,'xscale','log')
xlabel('Execution time (seconds)', 'FontSize', fsAll)
axis auto