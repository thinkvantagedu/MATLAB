function [err_otpt_itpl] = GSAInpolyItplOtptNoTri(no_block, pmExp, pmVal, ...
    pm_pre_block, coef_block_store)


% interpolate from coeff for each pm point in each polygon.
for i_block = 1:no_block
    
    % is pm point in polygon? loop through polygons.
    if inpolygon(pmExp.loop.ori.I1, pmExp.loop.ori.I2, ...
            pm_pre_block{i_block}(:, 2), ...
            pm_pre_block{i_block}(:, 3)) == 1
        
        err_otpt_itpl = LagInterpolationOtptSingle...
            (coef_block_store{i_block}, ...
            pmVal.loop.I1, pmVal.loop.I2, 4);
        
    end
    
end