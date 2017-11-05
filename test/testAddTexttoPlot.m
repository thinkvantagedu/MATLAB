surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.val');
txt_plot = sprintf('[%d %d]', pm.max.loc.I1, pm.max.loc.I2);
text(pm.max.ori.I1, pm.max.ori.I2, err.max.val, txt_plot);