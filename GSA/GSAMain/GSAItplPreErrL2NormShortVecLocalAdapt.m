%%
sigma.store = [];
err.match = abs(err.max.val0);
err.bd=1e-8;
%%
seq.int = 1;
err.indc.loop = 2;
%% set up the initial hat and hhat pm (and pm block) domain.

pmExp.pre.hat = [(1:4)' [domain.bond.L.I1, domain.bond.L.I2; ...
    domain.bond.R.I1, domain.bond.L.I2; ...
    domain.bond.L.I1, domain.bond.R.I2; ...
    domain.bond.R.I1, domain.bond.R.I2]];

pmExp.pre.block.hat = GSAGridtoBlockwithIndx(pmExp.pre.hat);
[pmExp.pre.block.hhat, pmExp.pre.hhat] = GSARefineGridLocalwithIdx...
    (pmExp.pre.block.hat, pmExp.max.ori.I1, pmExp.max.ori.I2);

%% set up the refinement conditions.
% usually fixed, only change when thres changes.
refinement.cond = 0.01;
% this is the threshold value, larger value allows less refinement.
refinement.thres = 0.5;

%% the GSA while loop.
while err.match > err.bd
    tic
    if i_cnt_general == 1 || refinement.cond <= refinement.thres
        %% when NO H-REFINEMENT, compute the next exact solution, add 1 rb vec.
        pmVal.iter.I1 = pmVal.space.I1(err.loc.val.max(1, 1), 2);
        pmVal.iter.I2 = pmVal.space.I2(err.loc.val.max(1, 2), 2);
        MTX_K.iter.exact = summation...
            (MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            pmVal.iter.I1, pmVal.iter.I2, pmVal.fix.I3);
        [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.exact, ...
            fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        
        %% new basis from error (current exact - previous appro).
        ERR.iter.store = Dis.iter.exact-Dis.all.appr;
        Nphi.iter = 1;
        [phi.fre.ERR, ~, ~] = SVDmod(ERR.iter.store, Nphi.iter);
        phi.fre.all = [phi.fre.all phi.fre.ERR];
        phi.fre.all = GramSchmidtNew(phi.fre.all);
        no.rb = size(phi.fre.all, 2);
        %% construct the reduced system.
        MTX_K.RE.I1120S0 = projection(phi.fre.all, MTX_K.I1120S0);
        MTX_K.RE.I1021S0 = projection(phi.fre.all, MTX_K.I1021S0);
        MTX_K.RE.I1020S1 = projection(phi.fre.all, MTX_K.I1020S1);
        MTX_M.RE.iter = projection(phi.fre.all, MTX_M.mtx);
        MTX_C.RE.iter = projection(phi.fre.all, MTX_C.mtx);
        Dis.RE.inpt = sparse(no.rb, 1);
        Vel.RE.inpt = sparse(no.rb, 1);
        fce.RE.iter = phi.fre.all' * fce.val;
        
    end
    % total number of scalars.
    no.total = no.rb * no.phy * no.t_step + 1;
    disp('offline dynamic computation start')
    
    %% OFFLINE
    % 1. Parameter domain local adaptivity.
    % 1.1 initialize interpolating sample domain.
    
    no.block.hat = numel(pmExp.pre.block.hat);
    no.pre.hat = size(pmExp.pre.hat, 1);
    
    % pmExp.pre.hhat is related to the location of maximum error Exp point.
    
    
    no.block.hhat = numel(pmExp.pre.block.hhat);
    pmVal.pre.hhat = 10.^pmExp.pre.hhat(:, 2:3);
    no.pre.hhat = size(pmExp.pre.hhat, 1);
    
    % 1.2 assemble MTX in cell.
    mtx.asemb = cell(no.phy, 1);
    mtx.asemb{1} = {MTX_M.mtx};
    mtx.asemb{2} = {MTX_C.mtx};
    mtx.asemb{3} = {MTX_K.I1120S0};
    mtx.asemb{4} = {MTX_K.I1021S0};
    mtx.asemb{5} = {MTX_K.I1020S1};
    % 1.3 genarate impulses.
    imp.asemb = cell(no.phy, 1);
    for i_cel = 1:no.phy
        imp.asemb(i_cel) = {mtx.asemb{i_cel}{:} * phi.fre.all};
    end
    imp.loc.init = 1;
    imp.loc.step = 2;
    
    no.tdiff = 2; % seperate initial and step-in time
    resp.store.all_pm.hhat = cell(no.pre.hhat, no.rb, no.phy, 2);
    imp.aply.asemb = cell(no.tdiff, 1);
    resp.store.order.all_pm = cell(2, 1);
    resp.store.fce.hhat = cell(no.pre.hhat, 1);
    %===========================================================================
    % 1.4.1. pre-computation from parameter domain.
    for i_pre = 1:no.pre.hhat
        % always compute the finer pm domain, then select the related
        % coarse domain.
        MTX_K.pre = summation...
            (MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            pmVal.pre.hhat(i_pre, 1), pmVal.pre.hhat(i_pre, 2), pmVal.fix.I3);
        % pre-compute from force.
        [~, ~, ~, resp.val.fce, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
            fce.val, NMcoef, time.step, time.max, ...
            Dis.inpt, Vel.inpt);
        resp.store.fce.hhat(i_pre) = {resp.val.fce};
        % 1.4.2. pre-compute from reduced basis.
        for i_rb = 1:no.rb
            % 1.4.3. pre-compute from physical domains.
            for i_phy = 1:no.phy
                
                imp.aply.init = zeros(no.dof, no.t_step);
                imp.aply.step = zeros(no.dof, no.t_step);
                imp.aply.init(:, imp.loc.init) = ...
                    imp.aply.init(:, imp.loc.init) + imp.asemb{i_phy}(:, i_rb);
                imp.aply.step(:, imp.loc.step) = ...
                    imp.aply.step(:, imp.loc.step) + imp.asemb{i_phy}(:, i_rb);
                
                imp.aply.asemb(1) = {imp.aply.init};
                imp.aply.asemb(2) = {imp.aply.step};
                % 1.4.4. pre-compute regarding time difference
                % (initial and step-in).
                for i_tdiff = 1:no.tdiff
                    % when i_tdiff = 1, apply initial impulse; i_tdiff = 2,
                    % apply step-in impulse.
                    [~, ~, ~, resp.otpt.all_pm.tdiff, ~, ~, ~, ~] = ...
                        NewmarkBetaReducedMethod...
                        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
                        imp.aply.asemb{i_tdiff}, ...
                        NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                    resp.store.order.all_pm(i_tdiff) = ...
                        {resp.otpt.all_pm.tdiff};
                end
                % 1.4.5. assemble all responses into one cell, ready for
                % vector products.
                for i_ts = 1:2
                    if i_ts == 1
                        resp.store.all_pm.hhat(i_pre, i_rb, i_phy, 1) = ...
                            resp.store.order.all_pm(1);
                    else
                        resp.store.all_pm.hhat(i_pre, i_rb, i_phy, 2) = ...
                            resp.store.order.all_pm(2);
                    end
                    
                end
                
            end
            
        end
        
    end
    
    
    
    disp('offline dynamic computation end')
    disp('offline vector products start')
    %%
    % extract from each interpolation sample point to obtain affined error
    % matrices, then assemble themresp.pre.col_asemb.hhat into a (no.pre.hhat*1)
    % cell according to number of sample points.
    
    [err.pre.trans_store.hhat] = GSAItplPreComputeUseShortVec...
        (no.rb, no.phy, no.pre.hhat, no.dof, no.t_step, ...
        resp.store.all_pm.hhat, resp.store.fce.hhat);
    
    % % % % %     clear resp
    %%
    % extract err.pre.trans.hat from hhat, only need to locate with the
    % indices. Notice that the new points always aligned after the old
    % points. therefore just need to use a counter to extract the old
    % points, as well as the related err.
    
    err.pre.trans_store.hat = err.pre.trans_store.hhat(1:no.pre.hat, :);
    
    
    % compute COEFFicient blocks. Because of 4-point linear interpolation,
    % the number of coef blocks needed to be stored = 4*no.block.
    
    [coef.block.store.hhat] = GSAErrStoretoCoefStore...
        (no.total, no.block.hhat, no.pre.hhat, ...
        pmExp.pre.block.hhat, err.pre.trans_store.hhat);
    
    [coef.block.store.hat] = GSAErrStoretoCoefStore...
        (no.total, no.block.hat, no.pre.hat, ...
        pmExp.pre.block.hat, err.pre.trans_store.hat);
    
    
    disp('offline vector products end')
    disp('online start')
    
    %===========================================================================
    %% ONLINE
    pm.one = ones(no.rb, no.t_step);
    err.store.hhat.val = zeros(domain.length.I1, domain.length.I2);
    err.store.hat.val = zeros(domain.length.I1, domain.length.I2);
    err.store.exactwRB.val = zeros(domain.length.I1, domain.length.I2);
    
    for i_iter = 1:size(pm.space.comb, 1)
        
        pmVal.loop.I1 = pm.space.comb(i_iter, 3);
        pmVal.loop.I2 = pm.space.comb(i_iter, 4);
        
        pmExp.loop.ori.I1 = log10(pmVal.loop.I1);
        pmExp.loop.ori.I2 = log10(pmVal.loop.I2);
        
        % compute alpha and ddot alpha for each PP.
        MTX_K.RE.iter = summation...
            (MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
            pmVal.loop.I1, pmVal.loop.I2, pmVal.fix.I3);
        
        [Dis.RE.otpt, Vel.RE.otpt, Acc.RE.otpt, ~, ~, ~, ~, ~] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.iter, ...
            fce.RE.iter, NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
        pmVal.rep.I1 = pmVal.loop.I1 * pm.one;
        pmVal.rep.I2 = pmVal.loop.I2 * pm.one;
        pmVal.rep.I3 = pmVal.fix.I3 * pm.one;
        
        % 1 for rv, 0 for pm.
        [rv.up] = GSARvPmUpTriangular...
            (Acc.RE.otpt, Vel.RE.otpt, Dis.RE.otpt, 1, 1);
        
        [pm.up] = GSARvPmUpTriangular...
            (pm.one, pmVal.rep.I1, pmVal.rep.I2, pmVal.rep.I3, 0);
        
        % interpolate from coeff for each pm point in each polygon.
        [err.otpt.itpl.hhat] = GSAInpolyItplOtptNoTri(no.block.hhat, ...
            pmExp.loop.ori.I1, pmExp.loop.ori.I2, pmVal.loop.I1, pmVal.loop.I2, ...
            pmExp.pre.block.hhat, coef.block.store.hhat);
        [err.otpt.itpl.hat] = GSAInpolyItplOtptNoTri(no.block.hat, ...
            pmExp.loop.ori.I1, pmExp.loop.ori.I2, pmVal.loop.I1, pmVal.loop.I2, ...
            pmExp.pre.block.hat, coef.block.store.hat);
        
        % final assembly, multiply interpolated error matrices with reduced
        % variable and parameter matrices.
        % reconstruct the full rv and pm, multiply them with
        % err.otpt.itpl.hhat, in order to ignore unused variables.
        % err.otpt.itpl.hhat is summed, thus results in a scalar.
        [err.otpt.sm.hhat] = ...
            GSAMultiplyRvPmErr(rv.up, pm.up, err.otpt.itpl.hhat);
        err.store.hhat.val(i_iter) = err.store.hhat.val(i_iter) + ...
            abs(err.otpt.sm.hhat / sumsqr(Dis.trial.exact));
        
        [err.otpt.sm.hat] = ...
            GSAMultiplyRvPmErr(rv.up, pm.up, err.otpt.itpl.hat);
        err.store.hat.val(i_iter) = err.store.hat.val(i_iter) + ...
            abs(err.otpt.sm.hat / sumsqr(Dis.trial.exact));
        
        %         disp(i_iter)
        % % % % %         clear err.otpt
        
        % compute exact error with the enriched RB, which is U^e - \phi *
        % \alpha. Requires exact solution in pm domain.
        
        [err.exactwRB] = GSAExactWithRB(summation, relativeErrSq, ...
            MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ....
            pmVal.loop.I1, pmVal.loop.I2, pmVal.fix.I3, phi.ident, fce.val, ...
            NMcoef, time.step, time.max, ...
            Dis.inpt, Vel.inpt, phi.fre.all, Dis.RE.otpt, Dis.trial.exact);
        err.store.exactwRB.val(i_iter) = err.store.exactwRB.val(i_iter) + ...
            err.exactwRB;
        
    end
    % % % % %     clear coef
    
    disp('online end')
    
    [err.max.val_hhat, err.loc.idx.max_hhat] = max(err.store.hhat.val(:));
    [err.max.val_hat, err.loc.idx.max_hat] = max(err.store.hat.val(:));
    
    % the new error estimate: 'surface' = max difference between hhat and hat
    % surfaces.
    % the old error estimate: 'maxPoint' = difference between max point in hhat
    % and hat surfaces.
    err.estimate = 'maxPointatEachSurface';
    switch err.estimate
        case 'maxPointatSurfaceDiff'
            err.diff.store = ...
                abs(err.store.hhat.val - err.store.hat.val) ./ ...
                err.store.hhat.val;
            refinement.cond = max(err.diff.store(:));
            
        case 'maxPointatEachSurface'
            refinement.cond = ...
                abs((err.max.val_hhat - err.max.val_hat) / ...
                err.max.val_hhat);
            
    end
    
    disp('error condition = '), disp(refinement.cond)
    i_cnt_general = i_cnt_general+1;
    
    if refinement.cond <= refinement.thres
        disp('no h-refinement')
        %% NO H-REFINEMENT, assess error information.
        % find info regarding exact error with enriched RB.err.loc.val.max
        [err.max.val_exactwRB, err.loc.idx.max_exactwRB] = ...
            max(err.store.exactwRB.val(:));
        err.max.store_exactwRB = [err.max.store_exactwRB; err.max.val_exactwRB];
        pm.iter.row_exactwRB = pm.space.comb(err.loc.idx.max_exactwRB, :);
        err.loc.val.max_exactwRB = pm.iter.row_exactwRB(:, 1:2);
        err.loc.store_exactwRB = [err.loc.store_exactwRB; ...
            err.loc.val.max_exactwRB];
        
        % error info of ehat.
        pm.iter.row_hat = pm.space.comb(err.loc.idx.max_hat, :);
        err.loc.val.max_hat = pm.iter.row_hat(:, 1:2);
        err.loc.store_hat = [err.loc.store_hat; err.loc.val.max_hat];
        err.max.store_hat = [err.max.store_hat; err.max.val_hat];
        
        % error info of ehhat.
        pm.iter.row_hhat = pm.space.comb(err.loc.idx.max_hhat, :);
        err.loc.val.max_hhat = pm.iter.row_hhat(:, 1:2);
        err.loc.store_hhat = [err.loc.store_hhat; err.loc.val.max_hhat];
        err.max.store_hhat = [err.max.store_hhat; err.max.val_hhat];
        
        %%
        % find parameter information related to max error.
        pmLoc.max.I1 = pmVal.space.I1(err.loc.val.max_exactwRB(1, 1));
        pmLoc.max.I2 = pmVal.space.I2(err.loc.val.max_exactwRB(1, 2));
        pmVal.max.I1 = pm.space.comb(err.loc.idx.max_exactwRB, 3);
        pmVal.max.I2 = pm.space.comb(err.loc.idx.max_exactwRB, 4);
        pmExp.max.ori.I1 = pmExp.ori.I1(err.loc.val.max_exactwRB(1, 1));
        pmExp.max.ori.I2 = pmExp.ori.I2(err.loc.val.max_exactwRB(1, 2));
        
        %%
        if turnon == 1
            %%
            i_cnt_plot = i_cnt_plot + 1;
            progdata.rsurf.store_exactwRB(i_cnt_general) = ...
                {err.store.exactwRB.val};
            disp('max error = '), disp(err.max.val_exactwRB)
            disp(err.loc.val.max_exactwRB)
            disp('plot iteration number = '), disp(i_cnt_plot)
            %%
            GSAPlotFigure(font_size.label, font_size.axis, ...
                draw.row, draw.col, i_cnt_plot, ...
                domain.bond.L.I1, domain.bond.R.I1, ...
                domain.length.I1, domain.bond.L.I2, ...
                domain.bond.R.I2, domain.length.I2, ...
                pmLoc.max.I1, pmLoc.max.I2, ...
                pmExp.max.ori.I1, pmExp.max.ori.I2, ...
                err.max.val0, err.max.val_exactwRB, err.store.exactwRB.val, cool, ...
                view_angle.x, view_angle.y);
            %%
            if i_cnt_plot >= draw.row * draw.col
                disp('iterations reach maximum plot number')
                break
            end
            
        end
        %%
        % compute approximation at max error point.
        
        MTX_K.RE.appr = summation...
            (MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
            pm.space.comb(err.loc.idx.max_hat, 3), ...
            pm.space.comb(err.loc.idx.max_hat, 4), pmVal.fix.I3);
        
        [~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.appr, ...
            fce.RE.iter, NMcoef, time.step, time.max, ...
            Dis.RE.inpt, Vel.RE.inpt);
    elseif refinement.cond > refinement.thres
        disp(i_cnt_general)
        disp('h-refinement')
        %% H-REFINEMENT.
        pmExp.pre.hat = pmExp.pre.hhat;
        pmExp.pre.block.hat = GSAGridtoBlockwithIndx(pmExp.pre.hat);
        [pmExp.pre.block.hhat, pmExp.pre.hhat] = GSARefineGridLocalwithIdx...
            (pmExp.pre.block.hat, pmExp.max.ori.I1, pmExp.max.ori.I2);
        
    end
    toc
    
end

%% store information needed.
% 1. phi; 2. exactwRB surf; 3. exactwRB loc; 4. exactwRB max; 5. ehat loc;
% 6. ehat max; 7. ehhat loc; 8. ehhat max.

if recordon == 1
    progdata.store = cell(8, 1);
    
    progdata.store{1, 1} = 'Reduced basis';
    progdata.store{2, 1} = 'Exact error with reduced basis surface';
    progdata.store{3, 1} = 'Exact error with reduced basis location';
    progdata.store{4, 1} = 'Exact error with reduced basis maximum';
    progdata.store{5, 1} = 'Error hat location';
    progdata.store{6, 1} = 'Error hat maximum';
    progdata.store{7, 1} = 'Error hhat location';
    progdata.store{8, 1} = 'Error hhat maximum';
    
    
    progdata.store{1, 2} = {phi.fre.all};
    progdata.store{2, 2} = {progdata.rsurf.store_exactwRB};
    progdata.store{3, 2} = {err.loc.store_exactwRB};
    progdata.store{4, 2} = {err.max.store_exactwRB};
    progdata.store{5, 2} = {err.loc.store_hat};
    progdata.store{6, 2} = {err.max.store_hat};
    progdata.store{7, 2} = {err.loc.store_hhat};
    progdata.store{8, 2} = {err.max.store_hhat};
    dataloc = ...
        ['/home/xiaohan/Desktop/Temp/numericalResults/[%d_%d]'...
        '/GreedyAppro/L2NormShortVecAdapt/t[%.1f]l[%.2f]rb0[%g]',...
        trialName, datestr(now, 'mmmddyyyy_HH-MM-SS'), '.mat'];
    datafile_name = sprintf(dataloc, pm.trial.val(1), pm.trial.val(2), ...
        time.max, time.step, no.rb0);
    save(datafile_name, 'progdata')
    
end