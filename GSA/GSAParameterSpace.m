function [pmVal, pm] = GSAParameterSpace(domain)

pmVal.space.I1 = logspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1);
pmVal.space.I1 = [(1:length(pmVal.space.I1)); pmVal.space.I1];
pmVal.space.I2 = logspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2);
pmVal.space.I2 = [(1:length(pmVal.space.I2)); pmVal.space.I2];
pm.space.comb = combvec(pmVal.space.I1, pmVal.space.I2);
pm.space.comb = pm.space.comb';
pm.space.comb(:, [2, 3]) = pm.space.comb(:, [3, 2]);
pmVal.space.I1 = pmVal.space.I1';
pmVal.space.I2 = pmVal.space.I2';
[pm.mg.I1, pm.mg.I2] = meshgrid(pmVal.space.I1(:, 2), pmVal.space.I2(:, 2));
pm.mg.I1 = pm.mg.I1';
pm.mg.I2 = pm.mg.I2';
