function obj = generatePmSpace(obj)
% generate 2-D parameter space: values and exponentials. 
obj.pmVal.I1.space = ...
    logspace(obj.domBond.I1.L, obj.domBond.I1.R, obj.domLeng.I1);

obj.pmVal.I1.space = ...
    [(1:length(obj.pmVal.I1.space)); obj.pmVal.I1.space];

obj.pmVal.I2.space = ...
    logspace(obj.domBond.I2.L, obj.domBond.I2.R, obj.domLeng.I2);
obj.pmVal.I2.space = ...
    [(1:length(obj.pmVal.I2.space)); obj.pmVal.I2.space];

obj.pmVal.comb.space = combvec(obj.pmVal.I1.space, obj.pmVal.I2.space);
obj.pmVal.comb.space = obj.pmVal.comb.space';
obj.pmVal.comb.space(:, [2, 3]) = obj.pmVal.comb.space(:, [3, 2]);

obj.pmVal.I1.space = obj.pmVal.I1.space';
obj.pmVal.I2.space = obj.pmVal.I2.space';

obj.pmExpo.I1 = log10(obj.pmVal.I1.space(:, 2));
obj.pmExpo.I2 = log10(obj.pmVal.I2.space(:, 2));

obj.pmVal.i.space = {obj.pmVal.I1.space obj.pmVal.I2.space};
obj.pmExpo.i = {obj.pmVal.I1 obj.pmVal.I2};

obj.no.dom.discretisation = cellfun(@(v) size(v, 1), obj.pmVal.i.space, ...
    'un', 0);

obj.no.dom.discretisation = cell2mat(obj.no.dom.discretisation);