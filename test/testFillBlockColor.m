clear variables; clc;

domain.bond.L.I1 = 1;
domain.bond.R.I1 = 2;
domain.bond.L.I2 = 1;
domain.bond.R.I2 = 2;

pm.hat = [domain.bond.L.I1, domain.bond.L.I2; domain.bond.R.I1, domain.bond.L.I2; ...
    domain.bond.L.I1, domain.bond.R.I2; domain.bond.R.I1, domain.bond.R.I2];
for i1 = 1:1
    pm.block.hat = GSAGridtoBlock(pm.hat);
    
    pm.hhat = GSARefineGrid(pm.hat);
    
    pm.block.hhat = GSAGridtoBlock(pm.hhat);
    
    for i2 = 1:numel(pm.block.hhat)
        c = rand(4, 1);
        fill(pm.block.hat{i2}(:, 1), pm.block.hat{i2}(:, 2), c);
        colormap(cool)
        hold on
    end
    axis square
    
    pm.hat = pm.hhat;
    
end