%% this script plots max error decay curve in semilog scale.
clear variables; clc;
dom_size = 17;
font_size.label = 30;
font_size.axis = 20;
draw.row = 2;
draw.col = 3;
% 1. phi; 2. exactwRB surf; 3. exactwRB loc; 4. exactwRB max; 5. ehat loc;
% 6. ehat max; 7. ehhat loc; 8. ehhat max.
data_loc_itpl = ['/home/xiaohan/Desktop/[17_1]appro'];
load(data_loc_itpl);
progdata_itpl = progdata;

% 1. RB; 2. surf; 3. max; 4. loc.
data_loc_ori = ['/home/xiaohan/Desktop/[17_1]exact'];
load(data_loc_ori);
progdata_ori = progdata;

%% extract information
% itpl
err_itpl.loc.store_exactwRB = progdata_itpl.store{3, 2}{:};
err_itpl.max.store_exactwRB = progdata_itpl.store{4, 2}{:};
err_itpl.loc.store_hat = progdata_itpl.store{5, 2}{:};
err_itpl.max.store_hat = progdata_itpl.store{6, 2}{:};
err_itpl.loc.store_hhat = progdata_itpl.store{7, 2}{:};
err_itpl.max.store_hhat = progdata_itpl.store{8, 2}{:};

no_plot = length(err_itpl.max.store_exactwRB);
err_itpl.plot.x_exactwRB = err_itpl.loc.store_exactwRB(:, 1);
err_itpl.plot.y_exactwRB = err_itpl.loc.store_exactwRB(:, 2);
err_itpl.plot.x_hat = err_itpl.loc.store_hat(:, 1);
err_itpl.plot.y_hat = err_itpl.loc.store_hat(:, 2);
err_itpl.plot.x_hhat = err_itpl.loc.store_hhat(:, 1);
err_itpl.plot.y_hhat = err_itpl.loc.store_hhat(:, 2);
% truth
err_ori.max.store = progdata_ori.store{3, 2}{:};
err_ori.loc.store = progdata_ori.store{4, 2}{:};
err_ori.plot.x = err_ori.loc.store(:, 1);
err_ori.plot.y = err_ori.loc.store(:, 2);

%% plot the 3d routes. There should be 4 routes.
subplot(1, 2, 1)

% plot3(err_itpl.loc.store_exactwRB(:, 1), err_itpl.loc.store_exactwRB(:, 2), ...
%     err_itpl.max.store_exactwRB, 'r-^', ...
%     err_ori.loc.store(:, 1), err_ori.loc.store(:, 2), ...
%     err_ori.max.store, 'g-v', ...
%     err_itpl.loc.store_hat(:, 1), err_itpl.loc.store_hat(:, 2), ...
%     err_itpl.max.store_hat, 'b->', ...
%     err_itpl.loc.store_hhat(:, 1), err_itpl.loc.store_hhat(:, 2), ...
%     err_itpl.max.store_hhat, 'k-<');
plot3(err_itpl.loc.store_exactwRB(:, 1), err_itpl.loc.store_exactwRB(:, 2), ...
    err_itpl.max.store_exactwRB, 'r-^', ...
    err_ori.loc.store(:, 1), err_ori.loc.store(:, 2), ...
    err_ori.max.store, 'g-v', ...
    err_itpl.loc.store_hat(:, 1), err_itpl.loc.store_hat(:, 2), ...
    err_itpl.max.store_hat, 'b->', ...
    err_itpl.loc.store_hhat(:, 1), err_itpl.loc.store_hhat(:, 2), ...
    err_itpl.max.store_hhat, 'k-<');

grid on
axis([1 dom_size 1 dom_size]);
axis square;
view([-60 15]);
for i_txt = 1:(no_plot)
    
    txt = sprintf(' %d', i_txt);
    text(err_itpl.plot.x_exactwRB(i_txt), err_itpl.plot.y_exactwRB(i_txt), ...
        err_itpl.max.store_exactwRB(i_txt), txt, 'fontsize', 18);
    text(err_ori.plot.x(i_txt), err_ori.plot.y(i_txt), ...
        err_ori.max.store(i_txt), txt, 'fontsize', 18);
    text(err_itpl.plot.x_hat(i_txt), err_itpl.plot.y_hat(i_txt), ...
        err_itpl.max.store_hat(i_txt), txt, 'fontsize', 18);
    text(err_itpl.plot.x_hhat(i_txt), err_itpl.plot.y_hhat(i_txt), ...
        err_itpl.max.store_hhat(i_txt), txt, 'fontsize', 18);
    
end
% xlabel('inclusion 1', 'FontSize', 18)
% ylabel('inclusion 2', 'FontSize', 18)
% zlabel('maximum error', 'FontSize', 18)
set(gca,'fontsize',18)
set(legend,'FontSize',18);
set(gca, 'ZScale', 'log')
legend('approximation', ...
    strcat('''', 'truth', ''''), ...
    strcat('''', 'error', ''''),...
    strcat('''', 'error in error', ''''), ...
    'location', [0.17 0.23 0.085 0.085])

%%
subplot(1, 2, 2)
semilogy((1:no_plot), err_itpl.max.store_exactwRB, 'r-^', ...
    (1:no_plot), err_ori.max.store, 'g-v', ...
    (1:no_plot), err_itpl.max.store_hat, 'b->', ...
    (1:no_plot), err_itpl.max.store_hhat, 'k-<');

grid on
set(gca, 'fontsize', font_size.axis)
xlim([1 no_plot])
axis square
legend('approximation', ...
    strcat('''', 'truth', ''''), ...
    strcat('''', 'error', ''''),...
    strcat('''', 'error in error', ''''), ...
    'Location', 'southwest')

