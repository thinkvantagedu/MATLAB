function [obj] = lagItplOtptSingle(obj, type)
% interpolate from coefficient blocks to single output blocks. Called in
% inpolyItplOtpt.
% when coeff are not consisted of square blocks but rectangular blocks,
% goes to last case, where only 4 sample points linear case is considered.

coeff = obj.coef.block;

m = size(coeff, 1);
x = obj.pmVal.iter{1};
y = obj.pmVal.iter{2};

no_pre = 4;
if no_pre == 4
    
    no_mtx = m / 4;
    
    lag_val = coeff(1 : no_mtx, :) * x * y+...
        coeff(2 * no_mtx - no_mtx + 1 : 2 * no_mtx, :) * x + ...
        coeff(3 * no_mtx - no_mtx + 1 : 3 * no_mtx, :) * y + ...
        coeff(4 * no_mtx - no_mtx + 1 : 4 * no_mtx, :) * x ^ 0;
    
elseif no_pre == 9
    
    no_mtx = m / 9;
    lag_val = coeff(1 : no_mtx, :) * x ^ 2 * y ^ 2 + ...
        coeff(2 * no_mtx - no_mtx + 1 : 2 * no_mtx, :) * x ^ 2 * y + ...
        coeff(3 * no_mtx - no_mtx + 1 : 3 * no_mtx, :) * x * y ^ 2 + ...
        coeff(4 * no_mtx - no_mtx + 1 : 4 * no_mtx, :) * x ^ 2 + ...
        coeff(5 * no_mtx - no_mtx + 1 : 5 * no_mtx, :) * y ^ 2 + ...
        coeff(6 * no_mtx - no_mtx + 1 : 6 * no_mtx, :) * x * y + ...
        coeff(7 * no_mtx - no_mtx + 1 : 7 * no_mtx, :) * x + ...
        coeff(8 * no_mtx - no_mtx + 1 : 8 * no_mtx, :) * y + ...
        coeff(9 * no_mtx - no_mtx + 1 : 9 * no_mtx, :) * x ^ 0;
    
end

switch type
    case 'hat'
        obj.err.itpl.hat = lag_val;
    case 'hhat'
        obj.err.itpl.hhat = lag_val;
end