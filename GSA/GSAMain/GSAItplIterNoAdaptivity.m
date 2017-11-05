%%
i_cnt=1;
err.match = abs(err.max.val);
err.bd=0.01;
gamma = 1/2; beta = 1/4;
a1 = gamma/(beta*time.step);
a2 = 1/(beta*time.step^2);
lag.order = 'linear';
switch lag.order
    case 'linear'
        % 4 corner points:
        pm.pre.num = 4;
%         pm.pre.rect = [pm.space.comb(1, :); pm.space.comb(50, :); pm.space.comb(2451, :); pm.space.comb(2500, :)];
        
        pm.pre.rect = [pm.mg.I1(1, 1) pm.mg.I2(1, 1); pm.mg.I1(50, 1) pm.mg.I2(50, 1); ...
            pm.mg.I1(1, 50) pm.mg.I2(1, 50); pm.mg.I1(50, 50) pm.mg.I2(50, 50)];
        %%
        pm.pre.loc.corner = [-1 -1; -1 1; 1 -1; 1 1]';
        pm.pre.loc.mid = GSAadaptivityMidPoint(pm.pre.loc.corner);
        pm.pre.loc.all = [pm.pre.loc.corner pm.pre.loc.mid];
        pm.pre.loc.val = 10.^pm.pre.loc.all;
        pm.pre.loc.val = pm.pre.loc.val';
        %%
        pm.pre.lu = [pm.space.comb(1, :); pm.space.comb(25, :); pm.space.comb(1201, :); pm.space.comb(1225, :)];
        pm.pre.ru = [pm.space.comb(25, :); pm.space.comb(50, :); pm.space.comb(1225, :); pm.space.comb(1250, :)];
        pm.pre.ld = [pm.space.comb(1201, :); pm.space.comb(1225, :); pm.space.comb(2451, :); pm.space.comb(2475, :)];
        pm.pre.rd = [pm.space.comb(1225, :); pm.space.comb(1250, :); pm.space.comb(2475, :); pm.space.comb(2500, :)];
        
    case 'quadratic9'
        pm.num = 9;
        pm.pre.rect = [pm.space.comb(1, :); pm.space.comb(25, :); pm.space.comb(50, :); pm.space.comb(1201, :); ...
            pm.space.comb(1225, :); pm.space.comb(1250, :); pm.space.comb(2451, :); pm.space.comb(2475, :); ...
            pm.space.comb(2500, :)];
        pm.pre.rect = [pm.mg.I1(1, 1) pm.mg.I2(1, 1); pm.mg.I1(25, 1) pm.mg.I2(25, 1); pm.mg.I1(50, 1) pm.mg.I2(50, 1);...
            pm.mg.I1(1, 25) pm.mg.I2(1, 25); pm.mg.I1(25, 25) pm.mg.I2(25, 25); pm.mg.I1(50, 25) pm.mg.I2(50, 25);...
            pm.mg.I1(1, 50) pm.mg.I2(1, 50); pm.mg.I1(25, 50) pm.mg.I2(25, 50); pm.mg.I1(50, 50) pm.mg.I2(50, 50)];
        
        pm.pre.lu = [pm.space.comb(1, :); pm.space.comb(13, :); pm.space.comb(25, :); pm.space.comb(601, :); ...
            pm.space.comb(613, :); pm.space.comb(625, :); pm.space.comb(1201, :); pm.space.comb(1213, :); ...
            pm.space.comb(1225, :)];
        pm.pre.ru = [pm.space.comb(25, :); pm.space.comb(37, :); pm.space.comb(50, :); pm.space.comb(625, :); ...
            pm.space.comb(637, :); pm.space.comb(650, :); pm.space.comb(1225, :); pm.space.comb(1237, :); ...
            pm.space.comb(1250, :)];
        pm.pre.ld = [pm.space.comb(1201, :); pm.space.comb(1213, :); pm.space.comb(1225, :); pm.space.comb(1801, :); ...
            pm.space.comb(1813, :); pm.space.comb(1825, :); pm.space.comb(2451, :); pm.space.comb(2463, :); ...
            pm.space.comb(2475, :)];
        pm.pre.rd = [pm.space.comb(1225, :); pm.space.comb(1237, :); pm.space.comb(1250, :); pm.space.comb(1825, :); ...
            pm.space.comb(1837, :); pm.space.comb(1850, :); pm.space.comb(2475, :); pm.space.comb(2487, :); ...
            pm.space.comb(2500, :)];
        
end
MTX.hat.ori_asmbl.rect = zeros(pm.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.lu = zeros(pm.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.ru = zeros(pm.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.ld = zeros(pm.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.rd = zeros(pm.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
a=0;

for i_hat = 1:pm.num
    
    if a==0
        % a==0: coarse grid.
        
        MTX_K.fre.OR.iter.hat =  MTX_K.fre.OR.I11_I20_IS0*pm.pre.rect(i_hat, 1)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.pre.rect(i_hat, 2)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        
        MTX.hat.ori = MTX_K.fre.OR.iter.hat+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        
        MTX.hat.inv = inv(MTX.hat.ori);
        
        MTX.hat.ori_asmbl.rect((i_hat*length(MTX.hat.ori)-length(MTX.hat.ori)+1):i_hat*length(MTX.hat.ori), :)...
            = MTX.hat.ori_asmbl.rect((i_hat*length(MTX.hat.ori)-length(MTX.hat.ori)+1):i_hat*length(MTX.hat.ori), :)...
            +MTX.hat.inv;
        
    elseif a==1
        % a==1: refined grid.
        MTX_K.fre.OR.iter.hat.lu =  MTX_K.fre.OR.I11_I20_IS0*pm.pre.lu(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.pre.lu(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.lu = MTX_K.fre.OR.iter.hat.lu+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.lu = inv(MTX.hat.ori.lu);
        MTX.hat.ori_asmbl.lu((i_hat*length(MTX.hat.ori.lu)-length(MTX.hat.ori.lu)+1):i_hat*length(MTX.hat.ori.lu), :)...
            = MTX.hat.ori_asmbl.lu((i_hat*length(MTX.hat.ori.lu)-length(MTX.hat.ori.lu)+1):i_hat*length(MTX.hat.ori.lu), :)...
            +MTX.hat.inv.lu;
        
        MTX_K.fre.OR.iter.hat.ru =  MTX_K.fre.OR.I11_I20_IS0*pm.pre.ru(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.pre.ru(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.ru = MTX_K.fre.OR.iter.hat.ru+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.ru = inv(MTX.hat.ori.ru);
        MTX.hat.ori_asmbl.ru((i_hat*length(MTX.hat.ori.ru)-length(MTX.hat.ori.ru)+1):i_hat*length(MTX.hat.ori.ru), :)...
            = MTX.hat.ori_asmbl.ru((i_hat*length(MTX.hat.ori.ru)-length(MTX.hat.ori.ru)+1):i_hat*length(MTX.hat.ori.ru), :)...
            +MTX.hat.inv.ru;
        
        MTX_K.fre.OR.iter.hat.ld =  MTX_K.fre.OR.I11_I20_IS0*pm.pre.ld(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.pre.ld(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.ld = MTX_K.fre.OR.iter.hat.ld+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.ld = inv(MTX.hat.ori.ld);
        MTX.hat.ori_asmbl.ld((i_hat*length(MTX.hat.ori.ld)-length(MTX.hat.ori.ld)+1):i_hat*length(MTX.hat.ori.ld), :)...
            = MTX.hat.ori_asmbl.ld((i_hat*length(MTX.hat.ori.ld)-length(MTX.hat.ori.ld)+1):i_hat*length(MTX.hat.ori.ld), :)...
            +MTX.hat.inv.ld;
        
        MTX_K.fre.OR.iter.hat.rd =  MTX_K.fre.OR.I11_I20_IS0*pm.pre.rd(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.pre.rd(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.rd = MTX_K.fre.OR.iter.hat.rd+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.rd = inv(MTX.hat.ori.rd);
        MTX.hat.ori_asmbl.rd((i_hat*length(MTX.hat.ori.rd)-length(MTX.hat.ori.rd)+1):i_hat*length(MTX.hat.ori.rd), :)...
            = MTX.hat.ori_asmbl.rd((i_hat*length(MTX.hat.ori.rd)-length(MTX.hat.ori.rd)+1):i_hat*length(MTX.hat.ori.rd), :)...
            +MTX.hat.inv.rd;
    end
end

% while err.match > err.bd 
    %%
    % compute the next exact solution.
    
    for i_test = 1:test_NO
    pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1));
    pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2));
    
    Dis.fre.OR.inpt.iter.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
    Vel.fre.OR.inpt.iter.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
    MTX_K.fre.OR.iter.exact = MTX_K.fre.OR.I11_I20_IS0*pm.iter.I1+...
        MTX_K.fre.OR.I10_I21_IS0*pm.iter.I2+...
        MTX_K.fre.OR.I10_I20_IS1*0.01;
    MTX_C.fre.OR.iter.exact = sparse(length(MTX_K.fre.OR.iter.exact), ...
        length(MTX_K.fre.OR.iter.exact));
    [~, ~, ~, Dis.fre.OR.otpt.iter.exact, Vel.fre.OR.otpt.iter.exact, Acc.fre.OR.otpt.iter.exact, ...
        time.fre.OR.otpt.iter, time_cnt.fre.OR.otpt.iter] = ...
        NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.exact, MTX_K.fre.OR.iter.exact, ...
        fce.fre.OR.all, NMcoeff, time.step, time.max, ...
        Dis.fre.OR.inpt.iter.exact, Vel.fre.OR.inpt.iter.exact);
    
    %%
    % compute new phi
    
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
    
    err.store.lag = zeros(domain.length.I1, domain.length.I2);
    err.log.store_lag = zeros(domain.length.I1, domain.length.I2);
    
    h = waitbar(0,'Walk back again');
    pd.check = zeros(size(pm.space.comb, 1), 1);
    for i_iter = 1:size(pm.space.comb, 1)
        waitbar(i_iter / steps)
        
        %%
        % compute alpha and ddot alpha for each PP.
        MTX_K.fre.RE.iter.loop = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(i_iter, 3)+...
            MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(i_iter, 4)+...
            MTX_K.fre.RE.I10_I20_IS1*0.01;
        MTX_K.fre.OR.iter.loop = MTX_K.fre.OR.I11_I20_IS0*pm.space.comb(i_iter, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.space.comb(i_iter, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        
        [Dis.fre.RE.otpt.iter.loop, Vel.fre.RE.otpt.iter.loop, Acc.fre.RE.otpt.iter.loop, ...
            Dis.fre.OR.otpt.iter.loop, Vel.fre.OR.otpt.iter.loop, Acc.fre.OR.otpt.iter.loop, ...
            time.fre.OR.otpt.iter_iter, time_cnt.fre.OR.otpt.iter_iter] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.iter.loop, ...
            fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
            Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
        %%
        % compute residual and corresponding error for each PP.
        
        res_store.inpt = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.iter.loop...
            -MTX_K.fre.OR.iter.loop*phi.fre.all*Dis.fre.RE.otpt.iter.loop;
        pm.space.x = pm.space.comb(i_iter, 1);
        pm.space.y = pm.space.comb(i_iter, 2);
        if a==0
            
                [coeff]=LagInterpolationCoeff(pm.pre.rect, MTX.hat.ori_asmbl.rect);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
                [~, pd.val] = chol(MTX.hat.inv);
                pd.check(i_iter) = pd.check(i_iter)+pd.val;
                
        elseif a==1
            if 1<=pm.space.x&&pm.space.x<=25&&1<=pm.space.y&&pm.space.y<=25
                pm.iter.intplt = pm.pre.lu(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.lu);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            elseif 25<=pm.space.x&&pm.space.x<=50&&1<=pm.space.y&&pm.space.y<=25
                pm.iter.intplt = pm.pre.ru(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.ru);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            elseif 1<=pm.space.x&&pm.space.x<=25&&25<=pm.space.y&&pm.space.y<=50
                pm.iter.intplt = pm.pre.ld(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.ld);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            elseif 25<=pm.space.x&&pm.space.x<=50&&25<=pm.space.y&&pm.space.y<=50
                pm.iter.intplt = pm.pre.rd(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.rd);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            end
            
        end

        [Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
            Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
            time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
            NewmarkBetaReducedMethodwithINVMTX...
            (phi.ident, MTX.hat.inv, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, MTX_K.fre.OR.iter.loop, ...
            res_store.inpt, NMcoeff, time.step, time.max, ...
            Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop, a1, a2);
        
        err.val = norm(Dis.fre.OR.otpt.trial.res, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
        err.store.lag(i_iter) = err.store.lag(i_iter)+err.val;
        err.log.store_lag(i_iter) = err.log.store_lag(i_iter)+log10(err.val);
        
    end
    close(h)
    
    i_cnt=i_cnt+1;
    
    toc
    %%
    [err.max.val, err.loc.idx.max]=max(err.store.lag(:));
    pm.iter.row=pm.space.comb(err.loc.idx.max, :);
    err.loc.val.max=pm.iter.row(:, 1:2);
    err.loc.store_lag=[err.loc.store_lag; err.loc.val.max];
    MTX_K.fre.RE.all.appr = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(err.loc.idx.max, 3)+...
        MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(err.loc.idx.max, 4)+...
        MTX_K.fre.RE.I10_I20_IS1*0.01;
    [Dis.fre.RE.otpt.all.appr, Vel.fre.RE.otpt.all.appr, Acc.fre.RE.otpt.all.appr, ...
        Dis.fre.OR.otpt.all.appr, Vel.fre.OR.otpt.all.appr, Acc.fre.OR.otpt.all.appr, ...
        time.fre.OR.otpt.trial0, time_cnt.fre.OR.otpt.trial0] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.all.appr, ...
        fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
        Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
    err.max.store_lag=[err.max.store_lag; err.max.val];
    err.max.log_store=[err.max.log_store log10(err.max.val)];
    turnon = 0;
    if turnon == 1
    
    figure(1)
    subplot(3, 4, i_cnt)
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.lag');
    xlabel('parameter 1', 'FontSize', 10)
    ylabel('parameter 2', 'FontSize', 10)
    zlabel('error', 'FontSize', 10)
    set(gca,'fontsize',10)
    axis([-1 1 -1 1])
    zlim(axi.lim)
    axis square
    view([120 30])
    set(legend,'FontSize',8);
    
    figure(2)
    subplot(3, 4, i_cnt)
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.store_lag');
    xlabel('parameter 1', 'FontSize', 10)
    ylabel('parameter 2', 'FontSize', 10)
    zlabel('log error', 'FontSize', 10)
    set(gca,'fontsize',10)
    axis([-1 1 -1 1])
    zlim(axi.log_lim)
    axis square
    view([120 30])
    set(legend,'FontSize',8);
    disp(err.max.val)
    disp(err.loc.val.max)
    
    %     disp(i_cnt)
    
    %     if i_cnt>=12
    %         disp('iterations reach maximum plot number')
    %         break
    %     end
    % end
    
    err.loc.store_lag=[err.loc.store_lag err.max.store_lag];
    end
    end