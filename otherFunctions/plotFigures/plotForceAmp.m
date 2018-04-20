figure

x = 0:fixie.time.step:fixie.time.max;
y = fixie.fce.val(18, :);

plot(x, -y, 'k', 'LineWidth', 3);
grid on
xlabel('Time');
ylabel('Amplitude');
set(gca,'fontsize',40)