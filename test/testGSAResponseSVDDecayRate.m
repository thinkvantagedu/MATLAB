xaxis = 1:no.t_step;

cellReshape = @(x) reshape(x, no.dof, no.t_step);

no.plot = no.rb * no.phy * 2;

no.cellplot = 2;

resp.store.all_pm.hhat = cellfun(cellReshape, resp.store.all_pm.hhat, ...
    'UniformOutput', false);

a = resp.store.all_pm.hhat(no.cellplot, :, :, :);

b = cellfun(@svd, a, 'UniformOutput', false);


for i = 1:numel(b)
    subplot(3, 10, i)
    plot(xaxis, b{i})
    xlim([1 no.t_step])
%     set(gca, 'YScale', 'log')
end