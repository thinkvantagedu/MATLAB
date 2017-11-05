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
err.indc.loop = 1;
while err.match > err.bd
    % compute the next exact solution.
    % test_NO = 1;
    % for i_test = 1:test_NO
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
    % works well
    % ERROR = current exact solution - previous approximation.
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
%     h = waitbar(0,'Wait');
%     steps=size(pm.space.comb, 1);
    pd.check = zeros(size(pm.space.comb, 1), 1);
    pm.pre.loc.all.corner = {[domain.bond.L.I1, domain.bond.L.I2; domain.bond.R.I1, domain.bond.L.I2; ...
        domain.bond.L.I1, domain.bond.R.I2; domain.bond.R.I1, domain.bond.R.I2]};
    
    while err.indc.max > err.indc.thres
        %         err.indc.max>threshold, refine; <threshold, jump out and keep the
        %         finer grid.
        if seq.int == 1
            pm.pre.loc.all.hat = pm.pre.loc.all.corner{:}';
        elseif err.indc.loop == 2
            pm.pre.loc.all.hat = pm.pre.loc.all.hat;
        elseif err.indc.loop == 1
            pm.pre.loc.all.hat = pm.pre.loc.all.hhat;
        end
        %%
        pm.pre.loc.block.hat = GSAGridtoBlock(pm.pre.loc.all.hat');
        % construct [4*DOF, DOF] size of MTX inverse coefficients for use of linear Lag interpolation.
        [coeff.store.hat] = GSAMTXinvCoeffConstruct(pm.pre.loc.block.hat, MTX_K.fre.OR.I11_I20_IS0, ...
            MTX_K.fre.OR.I10_I21_IS0, MTX_K.fre.OR.I10_I20_IS1, ...
            MTX_C.fre.OR.trial.loop, MTX_M.fre.OR.all, a1, a2, pm.fix.I3);
        
        pm.pre.loc.all.hhat = pm.pre.loc.all.hat;
        pm.pre.loc.mid.hhat = GSAGridMidPoint(pm.pre.loc.all.hhat);
        pm.pre.loc.all.hhat = [pm.pre.loc.all.corner{:}' pm.pre.loc.mid.hhat];
        pm.pre.loc.block.hhat = GSAGridtoBlock(pm.pre.loc.all.hhat'); % transpose row vec into column vec.
        
        [coeff.store.hhat] = GSAMTXinvCoeffConstruct(pm.pre.loc.block.hhat, MTX_K.fre.OR.I11_I20_IS0, ...
            MTX_K.fre.OR.I10_I21_IS0, MTX_K.fre.OR.I10_I20_IS1, ...
            MTX_C.fre.OR.trial.loop, MTX_M.fre.OR.all, a1, a2, pm.fix.I3);
        
        for i_iter = 1:size(pm.space.comb, 1)
            %             waitbar(i_iter / steps)
            
            %%
            MTX_K.fre.OR.iter.loop = MTX_K.fre.OR.I11_I20_IS0*pm.space.comb(i_iter, 3)+...
                MTX_K.fre.OR.I10_I21_IS0*pm.space.comb(i_iter, 4)+...
                MTX_K.fre.OR.I10_I20_IS1*pm.fix.I3;
            
            % compute alpha and ddot alpha for each PP.
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
            %%
            % compute residual and corresponding error for each PP.
            
            res.inpt = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.iter.loop...
                -MTX_K.fre.OR.iter.loop*phi.fre.all*Dis.fre.RE.otpt.iter.loop;
            
            pm.pre.val.iter.x = pm.space.comb(i_iter, 3);
            pm.pre.val.iter.y = pm.space.comb(i_iter, 4);
            
            for i_block = 1:numel(pm.pre.loc.block.hat)
                indc.poly = inpolygon(pm.pre.val.iter.x, pm.pre.val.iter.y, ...
                    10.^pm.pre.loc.block.hat{i_block}(:, 1), 10.^pm.pre.loc.block.hat{i_block}(:, 2));
                if indc.poly == 1
                    % interpolate MTX inverse within each block for each parameter point.
                    [MTX.pre.inv.hat] = LagInterpolationOtptSingle...
                        (coeff.store.hat(4*(i_block-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                        4*i_block*length(MTX_K.fre.OR.I11_I20_IS0), :), ...
                        pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                    [~, pd.val] = chol(MTX.pre.inv.hat);
                    pd.check(i_iter) = pd.check(i_iter)+pd.val;
                    % compute error (Ae = R) using interpolated matrix inverse.
                    [Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
                        Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
                        time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
                        NewmarkBetaReducedMethodwithINVMTX...
                        (phi.ident, MTX.pre.inv.hat, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, ...
                        MTX_K.fre.OR.iter.loop, res.inpt, NMcoeff, time.step, time.max, ...
                        Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop, a1, a2);
                    % compute relative error using ||error||/||U_exact||.
                    err.val_hat = norm(Dis.fre.OR.otpt.trial.res, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                    err.store.lag_hat(i_iter) = err.store.lag_hat(i_iter)+err.val_hat;
                    err.log.store_lag_hat(i_iter) = err.log.store_lag_hat(i_iter)+log10(err.val_hat);
                    
                end
            end
            
            for i_block = 1:numel(pm.pre.loc.block.hhat)
                indc.poly = inpolygon(pm.pre.val.iter.x, pm.pre.val.iter.y, ...
                    10.^pm.pre.loc.block.hhat{i_block}(:, 1), 10.^pm.pre.loc.block.hhat{i_block}(:, 2));
                if indc.poly == 1
                    [MTX.pre.inv.hhat] = LagInterpolationOtptSingle...
                        (coeff.store.hhat(4*(i_block-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                        4*i_block*length(MTX_K.fre.OR.I11_I20_IS0), :), ...
                        pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                    [~, pd.val] = chol(MTX.pre.inv.hhat);
                    pd.check(i_iter) = pd.check(i_iter)+pd.val;
                    %         compute solution using interpolated matrix inverse.
                    [Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
                        Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
                        time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
                        NewmarkBetaReducedMethodwithINVMTX...
                        (phi.ident, MTX.pre.inv.hhat, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, ...
                        MTX_K.fre.OR.iter.loop, res.inpt, NMcoeff, time.step, time.max, ...
                        Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop, a1, a2);
                    
                    err.val_hhat = norm(Dis.fre.OR.otpt.trial.res, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                    err.store.lag_hhat(i_iter) = err.store.lag_hhat(i_iter)+err.val_hhat;
                    err.log.store_lag_hhat(i_iter) = err.log.store_lag_hhat(i_iter)+log10(err.val_hhat);
                    
                end
            end
        end
%         close(h)
        
        err.indc.val = abs((err.store.lag_hhat-err.store.lag_hat)./err.store.lag_hhat);
        err.indc.max = max(err.indc.val(:));
        seq.int = seq.int+1;
        err.indc.loop = 1;
        keyboard
    end
    err.indc.loop = 2;
    
    %%
    %
    [err.max.val, err.loc.idx.max]=max(err.store.lag_hat(:));
    err.max.store_lag=[err.max.store_lag; err.max.val];
    err.match = abs(err.max.val);
    pm.iter.row=pm.space.comb(err.loc.idx.max, :);
    err.loc.val.max=pm.iter.row(:, 1:2);
    err.loc.store_lag=[err.loc.store_lag; err.loc.val.max];
    MTX_K.fre.RE.all.appr = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(err.loc.idx.max, 3)+...
        MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(err.loc.idx.max, 4)+...
        MTX_K.fre.RE.I10_I20_IS1*pm.fix.I3;
    [Dis.fre.RE.otpt.all.appr, Vel.fre.RE.otpt.all.appr, Acc.fre.RE.otpt.all.appr, ...
        Dis.fre.OR.otpt.all.appr, Vel.fre.OR.otpt.all.appr, Acc.fre.OR.otpt.all.appr, ...
        time.fre.OR.otpt.trial0, time_cnt.fre.OR.otpt.trial0] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.all.appr, ...
        fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
        Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
        
    %     err.max.log_store=[err.max.log_store log10(err.max.val)];
    %     err.loc.store_lag_hat=[err.loc.store_lag_hat err.max.store_lag_hat];
    
    
    
    turnon = 0;
    if turnon == 1
        figure(1)
        subplot(3, 4, i_cnt)
        surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
            linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.lag');
        GSAPlotParameters;
        
        figure(2)
        subplot(3, 4, i_cnt)
        surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
            linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.store_lag');
        GSAPlotParameters;
        
        disp(err.max.val)
        disp(err.loc.val.max)
        if i_cnt>=12
            disp('iterations reach maximum plot number')
            break
        end
    end
end
