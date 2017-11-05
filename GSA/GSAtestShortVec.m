a = resp.store.all_pm.hhat(1, :, :, :);

a2 = cat(2, a{:});

a2 = [resp.store.fce.hhat{1} -a2];
no.blk = size(a2, 2) / no.t_step;
atrans = a2' * a2;

atransblk = ...
    mat2cell(atrans, no.t_step * ones(1, no.blk), no.t_step * ones(1, no.blk));

