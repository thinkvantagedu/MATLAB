function [err_otpt_itpl] = GSAInpolyItplOtptTri(no_block, ...
    pm_loop_ori_I1, pm_loop_ori_I2, pm_loop_I1, pm_loop_I2, ...
    pm_pre_block, coef_block_store)

coef_cell = cell(no_block, 1);
for i_block = 1:no_block
    
    coef_slct = coef_block_store{i_block};
    coef_temp = mat2cell(coef_slct, repmat(size(coef_slct, 2), [1, 4]));
    coef_cell_temp = cell(4, 1);
    
    for i_slct = 1:4
        
        coef_full = reConstruct(coef_temp{i_slct});
        coef_cell_temp(i_slct) = {coef_full};
        
    end
    
    coef_cell_asemb = cell2mat(coef_cell_temp);
    
    coef_cell(i_block) = {coef_cell_asemb};
    
end

% interpolate from coeff for each pm point in each polygon.
for i_block = 1:no_block
    
    % is pm point in polygon? loop through polygons.
    if inpolygon(pm_loop_ori_I1, pm_loop_ori_I2, ...
            pm_pre_block{i_block}(:, 2), ...
            pm_pre_block{i_block}(:, 3)) == 1
        
        err_otpt_itpl = LagInterpolationOtptSingle...
            (coef_cell{i_block}, pm_loop_I1, pm_loop_I2, 4);
        
    end
    
end