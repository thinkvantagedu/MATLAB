%%
sigma.store = [];
err.match = abs(err.max.val0);
err.bd=1e-8;
seq.int = 1;
err.indc.loop = 2;
while err.match > err.bd
    i_cnt_general = i_cnt_general + 1;

    %%
    % compute the next exact solution.
    pm.iter.I1 = pmVal.space.I1(err.loc.val.max(1, 1), 2);
    pm.iter.I2 = pmVal.space.I2(err.loc.val.max(1, 2), 2);

    MTX_K.iter.exact = MTX_K.I1120S0 * pm.iter.I1 + ...
        MTX_K.I1021S0 * pm.iter.I2 + ...
        MTX_K.I1020S1 * pmVal.fix.I3;
    
    [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = ...
        NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.exact, ...
        fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
    
    %% new basis from error (current exact - previous appro).
    ERR.iter.store = Dis.iter.exact - Dis.all.appr;
    Nphi.iter = 1;
    [phi.fre.ERR, ~, sigma.val] = SVDmod(ERR.iter.store, Nphi.iter);
    sigma.store=[sigma.store; nonzeros(sigma.val)];
    phi.fre.all = [phi.fre.all phi.fre.ERR];
    phi.fre.all = GramSchmidtNew(phi.fre.all);
    no.rb = size(phi.fre.all, 2);
    
    %%
    MTX_K.RE.I1120S0 = phi.fre.all' * MTX_K.I1120S0 * phi.fre.all;
    MTX_K.RE.I1021S0 = phi.fre.all' * MTX_K.I1021S0 * phi.fre.all;
    MTX_K.RE.I1020S1 = phi.fre.all' * MTX_K.I1020S1 * phi.fre.all;
    MTX_M.RE.iter = phi.fre.all' * MTX_M.mtx * phi.fre.all;
    MTX_C.RE.iter = phi.fre.all' * MTX_C.mtx * phi.fre.all;
    
    Dis.RE.inpt = sparse(no.rb, 1);
    Vel.RE.inpt = sparse(no.rb, 1);
    
    fce.RE.iter = phi.fre.all' * fce.val;
    err_sqr.store.val = zeros(domain.length.I1, domain.length.I2);    
    err.store.val = zeros(domain.length.I1, domain.length.I2);    
    err.log_store.val = zeros(domain.length.I1, domain.length.I2);
    %%
    % compute approximation at max error point.
    MTX_K.RE.appr = MTX_K.RE.I1120S0 * pm.space.comb(err.loc.idx.max, 3) + ...
        MTX_K.RE.I1021S0 * pm.space.comb(err.loc.idx.max, 4) + ...
        MTX_K.RE.I1020S1 * pmVal.fix.I3;
    [~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.appr, ...
        fce.RE.iter, NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
    
    tic
    for i_iter = 1:size(pm.space.comb, 1)
        
        %%
        % compute alpha and ddot alpha for each PP.
        MTX_K.RE.iter = MTX_K.RE.I1120S0 * pm.space.comb(i_iter, 3) + ...
            MTX_K.RE.I1021S0*pm.space.comb(i_iter, 4) + ...
            MTX_K.RE.I1020S1 * pmVal.fix.I3;
        MTX_K.iter.loop = MTX_K.I1120S0 * pm.space.comb(i_iter, 3) + ...
            MTX_K.I1021S0 * pm.space.comb(i_iter, 4) + ...
            MTX_K.I1020S1 * pmVal.fix.I3;
        
        [Dis.RE.otpt, Vel.RE.otpt, Acc.RE.otpt, ~, ~, ~, ~, ~] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.iter, ...
            fce.RE.iter, NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
        %%
        % compute residual and corresponding error for each PP.
        err.def = 'residual';
        % error comes from residual.
        % error comes from displacement.
        switch err.def
            case 'residual'
                res_store.inpt = fce.val - ...
                    MTX_M.mtx * phi.fre.all * Acc.RE.otpt...
                    - MTX_K.iter.loop * phi.fre.all * Dis.RE.otpt;
                
                [~, ~, ~, Dis.iter.res, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    res_store.inpt, NMcoef, time.step, time.max, ...
                    Dis.inpt, Vel.inpt);
                
%               err.val = norm(Dis.iter.res, 'fro')/norm(Dis.trial.exact, 'fro');
                err.val = (norm(Dis.iter.res, 'fro'))^2/...
                    (norm(Dis.trial.exact, 'fro'))^2;
            case 'displacement'
                [Dis.OR.otpt.exact, Vel.fre.OR.otpt.exact, ...
                    Acc.fre.OR.otpt.exact, ...
                    Dis.OR.otpt.exact, Vel.fre.OR.otpt.exact, ...
                    Acc.fre.OR.otpt.exact, ...
                    time.fre.OR.otpt.exact, time_cnt.fre.OR.otpt.exact] = ...
                    NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, ...
                    MTX_K.fre.OR.iter.loop, ...
                    fce.fre.OR.all, NMcoef, time.step, time.max, ...
                    Dis.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop);
                
                err.test = Dis.OR.otpt.exact-Dis.OR.otpt.iter.loop;
%                 err.val = norm(err.test, 'fro')/...
%                     norm(Dis.OR.otpt.iter.exact, 'fro');
                err.val = (norm(err.test, 'fro')) ^ 2 / ...
                    (norm(Dis.trial.exact, 'fro')) ^ 2;
        end
        
        err.store.val(i_iter) = err.store.val(i_iter) + err.val;
        err.log_store.val(i_iter) = err.log_store.val(i_iter) + log10(err.val);
                
    end
    
    toc
    %% extract max error information.
    [err.max.val, err.loc.idx.max] = max(err.store.val(:));
    pm.iter.row = pm.space.comb(err.loc.idx.max, :);
    err.loc.val.max = pm.iter.row(:, 1:2);
    err.max.store = [err.max.store; err.max.val];
    err.loc.store = [err.loc.store; err.loc.val.max];
    
    pmLoc.max.I1 = err.loc.val.max(1, 1);
    pmLoc.max.I2 = err.loc.val.max(1, 2);
    pmVal.max.I1 = pm.space.comb(err.loc.idx.max, 3);
    pmVal.max.I2 = pm.space.comb(err.loc.idx.max, 4);
    pmExp.max.ori.I1 = pmExp.ori.I1(err.loc.val.max(1, 1));
    pmExp.max.ori.I2 = pmExp.ori.I2(err.loc.val.max(1, 2));
    
    disp('maximum error value is'), disp(err.max.val)
    disp('maximum error location is'), disp(err.loc.val.max)
    disp('iteration'), disp(i_cnt_general)
    %%
    if turnon == 1
        progdata.rsurf.store(i_cnt_general) = {err.store.val};
        
        
        GSAPlotFigure(font_size.label, font_size.axis, ...
            draw.row, draw.col, i_cnt_general, ...
            domain.bond.L.I1, domain.bond.R.I1, ...
            domain.length.I1, domain.bond.L.I2, ...
            domain.bond.R.I2, domain.length.I2, ...
            pmLoc.max.I1, pmLoc.max.I2, ...
            pmExp.max.ori.I1, pmExp.max.ori.I2, ...
            err.max.val0, err.max.val, err.store.val, cool, ...
            view_angle.x, view_angle.y);
        
        if i_cnt_general >= draw.row*draw.col
            disp('iterations reach maximum plot number')
            break
        end
    end
    
end
%% save data
saveloc = ['/home/xiaohan/Desktop/Temp/numericalResults/[%d_%d]/GreedyExact'...
    '/t[%.1f]l[%.2f]rb0[%g]',...
    trialName, datestr(now, 'mmmddyyyy_HH-MM-SS')];

if turnon == 1
    
    plotloc = saveloc;
    plotfile_name = sprintf(plotloc, pm.trial.val(1), pm.trial.val(2), ...
        time.max, time.step, no.rb0);
    saveas(gcf, plotfile_name, 'png')
    
end

if recordon == 1
    progdata.store = cell(4, 1);
    progdata.store{1, 1} = 'Reduced basis';
    progdata.store{2, 1} = 'Error surface';
    progdata.store{3, 1} = 'Error maximum value';
    progdata.store{4, 1} = 'Error maximum location';
    progdata.store{1, 2} = {phi.fre.all};
    progdata.store{2, 2} = {progdata.rsurf.store};
    progdata.store{3, 2} = {err.max.store};
    progdata.store{4, 2} = {err.loc.store};
    
    dataloc = [saveloc, '.mat'];
    datafile_name = sprintf(dataloc, pm.trial.val(1), pm.trial.val(2), ...
        time.max, time.step, no.rb0);
    save(datafile_name, 'progdata')
    
end