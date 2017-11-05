font_size.label = 30;
font_size.axis = 20;
draw.row = 2;
draw.col = 4;

plot3(err_itpl.loc.store(:, 1), err_itpl.loc.store(:, 2), err_itpl.max.store, 'r-v', ...
    err_ori.loc.store(:, 1), err_ori.loc.store(:, 2), err_ori.max.store, 'b-o');
hold on
quiver3(err_itpl.loc.store(:, 1), err_itpl.loc.store(:, 2), err_itpl.max.store, 'r--v');
hold on 
quiver3(err_ori.loc.store(:, 1), err_ori.loc.store(:, 2), err_ori.max.store, 'b--o');
grid on
axis([1 25 1 25]);
axis square;
view([-60 15]);
for i_txt = 1:(draw.row*draw.col)
    txt = sprintf(' %d', i_txt);
    text(err_itpl.plot.x(i_txt), err_itpl.plot.y(i_txt), err_itpl.max.store(i_txt), txt, 'fontsize', 18);
    text(err_ori.plot.x(i_txt), err_ori.plot.y(i_txt), err_ori.max.store(i_txt), txt, 'fontsize', 18);
    
end
xlabel('inclusion 1', 'FontSize', 18)
ylabel('inclusion 2', 'FontSize', 18)
zlabel('maximum error', 'FontSize', 18)
set(gca,'fontsize',18)
set(legend,'FontSize',18);
set(gca, 'ZScale', 'log')
legend('Estimation', strcat('''', 'Truth', ''''), 'location', [0.32 0.22 0.085 0.085])