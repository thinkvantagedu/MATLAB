%%
i_cnt=1;
err.match = abs(err.max.val);
err.bd=0.001;
gamma = 1/2; beta = 1/4;
a1 = gamma/(beta*time.step);
a2 = 1/(beta*time.step^2);
lag.order = 'linear';

%%
seq.int = 1;
err.indc.loop = 2;
while err.match > err.bd
    %%
    pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1));
    pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2));
    
    Dis.fre.OR.inpt.iter.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
    Vel.fre.OR.inpt.iter.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
    
    MTX_K.fre.OR.iter.exact = MTX_K.fre.OR.I11_I20_IS0*pm.iter.I1+...
        MTX_K.fre.OR.I10_I21_IS0*pm.iter.I2+...
        MTX_K.fre.OR.I10_I20_IS1*pm.fix.I3;
    MTX_C.fre.OR.iter.exact = sparse(length(MTX_K.fre.OR.iter.exact), ...
        length(MTX_K.fre.OR.iter.exact));
    
    [~, ~, ~, Dis.fre.OR.otpt.iter.exact, Vel.fre.OR.otpt.iter.exact, Acc.fre.OR.otpt.iter.exact, ...
        time.fre.OR.otpt.iter, time_cnt.fre.OR.otpt.iter] = ...
        NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.exact, MTX_K.fre.OR.iter.exact, ...
        fce.fre.OR.all, NMcoeff, time.step, time.max, ...
        Dis.fre.OR.inpt.iter.exact, Vel.fre.OR.inpt.iter.exact);
    %%
    ERR.iter.store_lag = Dis.fre.OR.otpt.iter.exact-Dis.fre.OR.otpt.all.appr;
    Nphi.iter = 2;
    [phi.fre.ERR, ~, sigma.val] = SVD(ERR.iter.store_lag, Nphi.iter);
    sigma.store_lag=[sigma.store_lag; nonzeros(sigma.val)];
    phi.fre.all = [phi.fre.all phi.fre.ERR];
    phi.fre.all = GramSchmidtNew(phi.fre.all);
    %%
    MTX_K.fre.RE.I11_I20_IS0 = phi.fre.all'*MTX_K.fre.OR.I11_I20_IS0*phi.fre.all;
    MTX_K.fre.RE.I10_I21_IS0 = phi.fre.all'*MTX_K.fre.OR.I10_I21_IS0*phi.fre.all;
    MTX_K.fre.RE.I10_I20_IS1 = phi.fre.all'*MTX_K.fre.OR.I10_I20_IS1*phi.fre.all;
    MTX_M.fre.RE.iter.loop = phi.fre.all'*MTX_M.fre.OR.all*phi.fre.all;
    MTX_C.fre.RE.iter.loop = sparse(length(MTX_M.fre.RE.iter.loop), ...
        length(MTX_M.fre.RE.iter.loop));
    
    MTX_C.fre.OR.iter.loop = sparse(length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
    Dis.fre.RE.inpt.iter.loop = sparse(length(MTX_M.fre.RE.iter.loop), 1);
    Vel.fre.RE.inpt.iter.loop = sparse(length(MTX_M.fre.RE.iter.loop), 1);
    Dis.fre.OR.inpt.iter.loop = sparse(length(MTX_M.fre.OR.all), 1);
    Vel.fre.OR.inpt.iter.loop = sparse(length(MTX_M.fre.OR.all), 1);
    fce.fre.RE.iter.loop = phi.fre.all'*fce.fre.OR.all;
    
    err.store.lag_hat = zeros(domain.length.I1, domain.length.I2);
    err.log.store_lag_hat = zeros(domain.length.I1, domain.length.I2);
    err.store.lag_hhat = zeros(domain.length.I1, domain.length.I2);
    err.log.store_lag_hhat = zeros(domain.length.I1, domain.length.I2);
    err.indc.max = 2;
    err.indc.thres = 1;
    
    pm.pre.loc.all.corner = {[domain.bond.L.I1, domain.bond.L.I2; domain.bond.R.I1, domain.bond.L.I2; ...
        domain.bond.L.I1, domain.bond.R.I2; domain.bond.R.I1, domain.bond.R.I2]};
    %%
    while err.indc.max > err.indc.thres
        
        if seq.int == 1
            pm.pre.loc.all.hat = pm.pre.loc.all.corner{:}';
        elseif err.indc.loop == 2
            pm.pre.loc.all.hat = pm.pre.loc.all.hat;
        elseif err.indc.loop == 1
            pm.pre.loc.all.hat = pm.pre.loc.all.hhat;
        end
        
        pm.pre.loc.block.hat = GSAGridtoBlock(pm.pre.loc.all.hat');
        [coeff.store.hat] = GSAMTXinvCoeffConstruct(pm.pre.loc.block.hat, MTX_K.fre.OR.I11_I20_IS0, ...
            MTX_K.fre.OR.I10_I21_IS0, MTX_K.fre.OR.I10_I20_IS1, ...
            MTX_C.fre.OR.trial.loop, MTX_M.fre.OR.all, a1, a2, pm.fix.I3);
        
        fce.pre.store.hat = zeros(size(coeff.store.hat, 1)/size(coeff.store.hat, 2)*...
            length(MTX_K.fre.OR.I10_I21_IS0), size(fce.fre.OR.all, 2));
        
        for i_aff = 1:size(coeff.store.hat, 1)/size(coeff.store.hat, 2)
            fce.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :) = ...
                fce.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :)+...
                coeff.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :)*fce.fre.OR.all;
            
        end
        
        [MTX_M.pre.store.hat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hat, MTX_M.fre.OR.all, phi.fre.all);
        [MTX_K.pre_I11_I20_IS0.store.hat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hat, MTX_K.fre.OR.I11_I20_IS0, phi.fre.all);
        [MTX_K.pre_I10_I21_IS0.store.hat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hat, MTX_K.fre.OR.I10_I21_IS0, phi.fre.all);
        [MTX_K.pre_I10_I20_IS1.store.hat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hat, MTX_K.fre.OR.I10_I20_IS1, phi.fre.all);
        %%
        pm.pre.loc.all.hhat = pm.pre.loc.all.hat;
        pm.pre.loc.mid.hhat = GSAGridMidPoint(pm.pre.loc.all.hhat);
        pm.pre.loc.all.hhat = [pm.pre.loc.all.corner{:}' pm.pre.loc.mid.hhat];
        pm.pre.loc.block.hhat = GSAGridtoBlock(pm.pre.loc.all.hhat'); % transpose row vec into column vec.
        
        [coeff.store.hhat] = GSAMTXinvCoeffConstruct(pm.pre.loc.block.hhat, MTX_K.fre.OR.I11_I20_IS0, ...
            MTX_K.fre.OR.I10_I21_IS0, MTX_K.fre.OR.I10_I20_IS1, ...
            MTX_C.fre.OR.trial.loop, MTX_M.fre.OR.all, a1, a2, pm.fix.I3);
        fce.pre.store.hhat = zeros(size(coeff.store.hhat, 1)/size(coeff.store.hhat, 2)*...
            length(MTX_K.fre.OR.I10_I21_IS0), size(fce.fre.OR.all, 2));
        
        for i_aff = 1:size(coeff.store.hhat, 1)/size(coeff.store.hhat, 2)
            fce.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :) = ...
                fce.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :)+...
                coeff.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :)*fce.fre.OR.all;
        end
        
        [MTX_M.pre.store.hhat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hhat, MTX_M.fre.OR.all, phi.fre.all);
        [MTX_K.pre_I11_I20_IS0.store.hhat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hhat, MTX_K.fre.OR.I11_I20_IS0, phi.fre.all);
        [MTX_K.pre_I10_I21_IS0.store.hhat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hhat, MTX_K.fre.OR.I10_I21_IS0, phi.fre.all);
        [MTX_K.pre_I10_I20_IS1.store.hhat] = ...
            GSAAffDynmcOpratrPre(coeff.store.hhat, MTX_K.fre.OR.I10_I20_IS1, phi.fre.all);
        
        for i_iter = 1:size(pm.space.comb, 1)
            MTX_K.fre.RE.iter.loop = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(i_iter, 3)+...
                MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(i_iter, 4)+...
                MTX_K.fre.RE.I10_I20_IS1*pm.fix.I3;
            [Dis.fre.RE.otpt.iter.loop, Vel.fre.RE.otpt.iter.loop, Acc.fre.RE.otpt.iter.loop, ...
                Dis.fre.OR.otpt.iter.loop, Vel.fre.OR.otpt.iter.loop, Acc.fre.OR.otpt.iter.loop, ...
                time.fre.OR.otpt.iter_iter, time_cnt.fre.OR.otpt.iter_iter] = ...
                NewmarkBetaReducedMethod...
                (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.iter.loop, ...
                fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
                Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
            
            err_M.pre.store.hat = MTX_M.pre.store.hat*Acc.fre.RE.otpt.iter.loop;
            err_C.pre.store.hat = zeros(size(MTX_M.pre.store.hat, 1), size(MTX_M.pre.store.hat, 2));
            err_K.pre.store.hat = (MTX_K.pre_I11_I20_IS0.store.hat*pm.space.comb(i_iter, 3)+...
                MTX_K.pre_I10_I21_IS0.store.hat*pm.space.comb(i_iter, 4)+...
                MTX_K.pre_I10_I20_IS1.store.hat*pm.fix.I3)*Dis.fre.RE.otpt.iter.loop;
            
            err.pre.store.hat = zeros(size(coeff.store.hat, 1)/size(coeff.store.hat, 2)*...
                length(MTX_K.fre.OR.I10_I21_IS0), size(fce.fre.OR.all, 2));
            for i_aff = 1:size(coeff.store.hat, 1)/size(coeff.store.hat, 2)
                %             get B*M*phi*ddot_alpha, B*C*phi*dot_alpha, B*K*phi*alpha, B*F
                %             for each pre-pm_point.
                err_M.pre.sep.hat = err_M.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :);
                err_C.pre.sep.hat = zeros(size(err_M.pre.sep.hat, 1), size(err_M.pre.sep.hat, 2));
                err_K.pre.sep.hat = err_K.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :);
                fce.pre.sep.hat = fce.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :);
                err.pre.val.hat = fce.pre.sep.hat-err_M.pre.sep.hat-err_C.pre.sep.hat-err_K.pre.sep.hat;
                err.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :) = ...
                    err.pre.store.hat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :)+err.pre.val.hat;            
            end
            
            pm.pre.val.iter.x = pm.space.comb(i_iter, 3);
            pm.pre.val.iter.y = pm.space.comb(i_iter, 4);
            
            for i_block = 1:numel(pm.pre.loc.block.hat)
                indc.poly = inpolygon(pm.pre.val.iter.x, pm.pre.val.iter.y, ...
                    10.^pm.pre.loc.block.hat{i_block}(:, 1), 10.^pm.pre.loc.block.hat{i_block}(:, 2));
                if indc.poly == 1
                    [err.lag.val.hat] = LagInterpolationOtptSingle...
                        (err.pre.store.hat(4*(i_block-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                        4*i_block*length(MTX_K.fre.OR.I11_I20_IS0), :), ...
                        pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                    err.val_hat = norm(err.lag.val.hat, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                    err.store.lag_hat(i_iter) = err.store.lag_hat(i_iter)+err.val_hat;
                    err.log.store_lag_hat(i_iter) = err.log.store_lag_hat(i_iter)+log10(err.val_hat);
                    
                end
            end
            
            err_M.pre.store.hhat = MTX_M.pre.store.hhat*Acc.fre.RE.otpt.iter.loop;
            err_C.pre.store.hhat = zeros(size(MTX_M.pre.store.hhat, 1), size(MTX_M.pre.store.hhat, 2));
            err_K.pre.store.hhat = (MTX_K.pre_I11_I20_IS0.store.hhat*pm.space.comb(i_iter, 3)+...
                MTX_K.pre_I10_I21_IS0.store.hhat*pm.space.comb(i_iter, 4)+...
                MTX_K.pre_I10_I20_IS1.store.hhat*pm.fix.I3)*Dis.fre.RE.otpt.iter.loop;
            
            err.pre.store.hhat = zeros(size(coeff.store.hhat, 1)/size(coeff.store.hhat, 2)*...
                length(MTX_K.fre.OR.I10_I21_IS0), size(fce.fre.OR.all, 2));
            for i_aff = 1:size(coeff.store.hhat, 1)/size(coeff.store.hhat, 2)
                %             get B*M*phi*ddot_alpha, B*C*phi*dot_alpha, B*K*phi*alpha, B*F
                %             for each pre-pm_point.
                err_M.pre.sep.hhat = err_M.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :);
                err_C.pre.sep.hhat = zeros(size(err_M.pre.sep.hhat, 1), size(err_M.pre.sep.hhat, 2));
                err_K.pre.sep.hhat = err_K.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :);
                fce.pre.sep.hhat = fce.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :);
                err.pre.val.hhat = fce.pre.sep.hhat-err_M.pre.sep.hhat-err_C.pre.sep.hhat-err_K.pre.sep.hhat;
                err.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :) = ...
                    err.pre.store.hhat((i_aff-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                    i_aff*length(MTX_K.fre.OR.I11_I20_IS0), :)+err.pre.val.hhat;
            end
            
            pm.pre.val.iter.x = pm.space.comb(i_iter, 3);
            pm.pre.val.iter.y = pm.space.comb(i_iter, 4);
            
            for i_block = 1:numel(pm.pre.loc.block.hhat)
                indc.poly = inpolygon(pm.pre.val.iter.x, pm.pre.val.iter.y, ...
                    10.^pm.pre.loc.block.hhat{i_block}(:, 1), 10.^pm.pre.loc.block.hhat{i_block}(:, 2));
                if indc.poly == 1
                    [err.lag.val.hhat] = LagInterpolationOtptSingle...
                        (err.pre.store.hhat(4*(i_block-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                        4*i_block*length(MTX_K.fre.OR.I11_I20_IS0), :), ...
                        pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                    err.val_hhat = norm(err.lag.val.hhat, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                    err.store.lag_hhat(i_iter) = err.store.lag_hhat(i_iter)+err.val_hhat;
                    err.log.store_lag_hhat(i_iter) = err.log.store_lag_hhat(i_iter)+log10(err.val_hhat);
                    
                end
            end
        end
        keyboard
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end