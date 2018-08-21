figure

% x = 0:fixie.time.step:fixie.time.max;
x = 0:0.1:4.9;
y = [canti.fce.val(66, :) zeros(1, 40)];

plot(x, y, 'k', 'LineWidth', 3);
grid on
xlabel('Time');
ylabel('Amplitude');
set(gca,'fontsize',40)