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
        MTX_K.fre.OR.I10_I20_IS1*domain.fix.I3;
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
    
    %     h = waitbar(0,'Wait');
    %     steps=size(pm.space.comb, 1);
    pd.check = zeros(size(pm.space.comb, 1), 1);
    pm.pre.loc.all.corner = {[domain.bond.L.I1, domain.bond.L.I2; domain.bond.R.I1, domain.bond.L.I2; ...
        domain.bond.L.I1, domain.bond.R.I2; domain.bond.R.I1, domain.bond.R.I2]};
    
    err.indc.max = 2;
    err.indc.thres = 1;
    
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
        err.dis_store.hat = [];
        pm.pre.loc.block.hat = GSAGridtoBlock(pm.pre.loc.all.hat');
        for i_pre = 1:numel(pm.pre.loc.block.hat)
            for j_pre = 1:4
                MTX_K.fre.RE.pre.hat = MTX_K.fre.RE.I11_I20_IS0*10.^pm.pre.loc.block.hat{i_pre}(j_pre, 1)+...
                    MTX_K.fre.RE.I10_I21_IS0*10.^pm.pre.loc.block.hat{i_pre}(j_pre, 2)+...
                    MTX_K.fre.RE.I10_I20_IS1*domain.fix.I3;
                MTX_K.fre.OR.pre.hat = MTX_K.fre.OR.I11_I20_IS0*10.^pm.pre.loc.block.hat{i_pre}(j_pre, 1)+...
                    MTX_K.fre.OR.I10_I21_IS0*10.^pm.pre.loc.block.hat{i_pre}(j_pre, 2)+...
                    MTX_K.fre.OR.I10_I20_IS1*domain.fix.I3;
                [Dis.fre.RE.otpt.pre.hat, Vel.fre.RE.otpt.pre.hat, Acc.fre.RE.otpt.pre.hat, ...
                    Dis.fre.OR.otpt.pre.hat, Vel.fre.OR.otpt.pre.hat, Acc.fre.OR.otpt.pre.hat, ...
                    time.fre.OR.otpt.iter_iter, time_cnt.fre.OR.otpt.iter_iter] = ...
                    NewmarkBetaReducedMethod...
                    (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.pre.hat, ...
                    fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
                    Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
                res.inpt_pre.hat = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.pre.hat...
                    -MTX_K.fre.OR.pre.hat*phi.fre.all*Dis.fre.RE.otpt.pre.hat;
                [Dis.fre.OR.otpt.pre.hat, Vel.fre.OR.otpt.pre.hat, Acc.fre.OR.otpt.pre.hat, ...
                    Dis.fre.OR.otpt.pre.hat, Vel.fre.OR.otpt.pre.hat, Acc.fre.OR.otpt.pre.hat, ...
                    time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
                    NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, ...
                    MTX_K.fre.OR.pre.hat, res.inpt, NMcoeff, time.step, time.max, ...
                    Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop);
                
                err.dis_store.hat = [err.dis_store.hat; Dis.fre.OR.otpt.pre.hat];
            end
        end
        
        err.dis_store.hhat = [];
        pm.pre.loc.all.hhat = pm.pre.loc.all.hat;
        pm.pre.loc.mid.hhat = GSAGridMidPoint(pm.pre.loc.all.hhat);
        pm.pre.loc.all.hhat = [pm.pre.loc.all.corner{:}' pm.pre.loc.mid.hhat];
        pm.pre.loc.block.hhat = GSAGridtoBlock(pm.pre.loc.all.hhat'); % transpose row vec into column vec.
        
        for i_pre = 1:numel(pm.pre.loc.block.hhat)
            for j_pre = 1:4
                MTX_K.fre.RE.pre.hhat = MTX_K.fre.RE.I11_I20_IS0*10.^pm.pre.loc.block.hhat{i_pre}(j_pre, 1)+...
                    MTX_K.fre.RE.I10_I21_IS0*10.^pm.pre.loc.block.hhat{i_pre}(j_pre, 2)+...
                    MTX_K.fre.RE.I10_I20_IS1*domain.fix.I3;
                MTX_K.fre.OR.pre.hhat = MTX_K.fre.OR.I11_I20_IS0*10.^pm.pre.loc.block.hhat{i_pre}(j_pre, 1)+...
                    MTX_K.fre.OR.I10_I21_IS0*10.^pm.pre.loc.block.hhat{i_pre}(j_pre, 2)+...
                    MTX_K.fre.OR.I10_I20_IS1*domain.fix.I3;
                [Dis.fre.RE.otpt.pre.hhat, Vel.fre.RE.otpt.pre.hhat, Acc.fre.RE.otpt.pre.hhat, ...
                    Dis.fre.OR.otpt.pre.hhat, Vel.fre.OR.otpt.pre.hhat, Acc.fre.OR.otpt.pre.hhat, ...
                    time.fre.OR.otpt.iter_iter, time_cnt.fre.OR.otpt.iter_iter] = ...
                    NewmarkBetaReducedMethod...
                    (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.pre.hhat, ...
                    fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
                    Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
                res.inpt_pre.hhat = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.pre.hhat...
                    -MTX_K.fre.OR.pre.hhat*phi.fre.all*Dis.fre.RE.otpt.pre.hhat;
                [Dis.fre.OR.otpt.pre.hhat, Vel.fre.OR.otpt.pre.hhat, Acc.fre.OR.otpt.pre.hhat, ...
                    Dis.fre.OR.otpt.pre.hhat, Vel.fre.OR.otpt.pre.hhat, Acc.fre.OR.otpt.pre.hhat, ...
                    time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
                    NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, ...
                    MTX_K.fre.OR.pre.hhat, res.inpt, NMcoeff, time.step, time.max, ...
                    Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop);
                
                err.dis_store.hhat = [err.dis_store.hhat; Dis.fre.OR.otpt.pre.hhat];
            end
        end
        
        %         keyboard
        
        for i_iter = 1:size(pm.space.comb, 1)
            %             waitbar(i_iter / steps)
            
            pm.pre.val.iter.x = pm.space.comb(i_iter, 3);
            pm.pre.val.iter.y = pm.space.comb(i_iter, 4);
            for i_block = 1:numel(pm.pre.loc.block.hat)
                indc.poly = inpolygon(pm.pre.val.iter.x, pm.pre.val.iter.y, ...
                    10.^pm.pre.loc.block.hat{i_block}(:, 1), 10.^pm.pre.loc.block.hat{i_block}(:, 2));
                if indc.poly == 1
                    % interpolate error within each block for each parameter point.
                    [err.dis.hat] = LagInterpolationOtptSingle...
                        (err.dis_store.hat(4*(i_block-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                        4*i_block*length(MTX_K.fre.OR.I11_I20_IS0), :), ...
                        pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                    err.val_hat = norm(err.dis.hat, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                    err.store.lag_hat(i_iter) = err.store.lag_hat(i_iter)+err.val_hat;
                end
            end
            
            for i_block = 1:numel(pm.pre.loc.block.hhat)
                indc.poly = inpolygon(pm.pre.val.iter.x, pm.pre.val.iter.y, ...
                    10.^pm.pre.loc.block.hhat{i_block}(:, 1), 10.^pm.pre.loc.block.hhat{i_block}(:, 2));
                if indc.poly == 1
                    % interpolate error within each block for each parameter point.
                    [err.dis.hhat] = LagInterpolationOtptSingle...
                        (err.dis_store.hhat(4*(i_block-1)*length(MTX_K.fre.OR.I11_I20_IS0)+1:...
                        4*i_block*length(MTX_K.fre.OR.I11_I20_IS0), :), ...
                        pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                    err.val_hhat = norm(err.dis.hhat, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                    err.store.lag_hhat(i_iter) = err.store.lag_hhat(i_iter)+err.val_hhat;
                end
            end
            
        end
        %         close(h)
        
        err.indc.val = abs((err.store.lag_hhat-err.store.lag_hat)./err.store.lag_hhat);
        err.indc.max = max(err.indc.val(:));
        seq.int = seq.int+1;
        err.indc.loop = 1;
        
    end
    
    err.indc.loop = 2;
    keyboard
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
        MTX_K.fre.RE.I10_I20_IS1*domain.fix.I3;
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
