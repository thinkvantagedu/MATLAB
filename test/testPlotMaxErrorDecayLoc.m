figure(3)

x = fixie.err.store.loc;
y = fixie.err.store.max;
semilogy(x, y, 'k-*', 'LineWidth', 2);
for i = 1:length(y)
    stri = num2str(i);
    text(x(i), y(i), stri, 'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'bottom');
end
axis([1 fixie.domLeng.i 0 fixie.err.store.max(1)])
grid on