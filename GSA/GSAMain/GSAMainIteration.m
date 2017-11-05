%%
% keywords:
% WHILE: =======================================================================
% module: compute the next exact solution.
% module: new basis from error (current exact - previous appro).
% module: construct the reduced system.
% OFFLINE begins
% module: parameter domain adaptivity.
% submodule: initialize interpolating sample domain.
% submodule: assemble MTX in cell.
% submodule: genarate impulses.
% subsubmodule: pre-computation from parameter domain.
% subsubmodule: pre-computation from reduced basis.
% subsubmodule: pre-computation from physical domains.
% subsubmodule: pre-computation regarding time difference.
% module: SVD on each response, decide how many vectors should be added.
% module: extract from each interpolation sample point. [Use ShortVec]
% module: compute COEFFicient blocks.
% OFFLINE ends
% ONLINE begins
% module: compute alpha and ddot alpha for each PP.
% module: upper triangular matrix for reduced variables and parameters.
% module: interpolate from scalar coeff mtx for each pm point in each polygon.
% module: final assembly, multiply interpolated error mtx with rv and pm.
% module: compute exact error with the enriched RB.
% ONLINE ends
% the new error estimate and the old one.
% module: assess error information.
% module: compute approximation at max error point.
% END WHILE: ===================================================================
% module: store information needed.
%%
err.match = abs(err.max.val0);
err.bd = 1e-8;

pm.pre.hat = [domain.bond.L.I1, domain.bond.L.I2; ...
    domain.bond.R.I1, domain.bond.L.I2; ...
    domain.bond.L.I1, domain.bond.R.I2; ...
    domain.bond.R.I1, domain.bond.R.I2];

refinement.cond = 0.01;% usually fixed, only change when thres changes.
refinement.thres = 0.1;

while err.match > err.bd
    tic
    if i_cnt_general == 1
        %% compute the next exact solution.
        pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1), 2);
        pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2), 2);
        MTX_K.iter.exact = summation...
            (MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            pm.iter.I1, pm.iter.I2, pm.fix.I3);
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
        fce.RE.iter = phi.fre.all'*fce.val;
    elseif refinement.cond <= refinement.thres
        % if no h-refinement, add 1 new reduced basis.
        %% compute the next exact solution.
        pm.iter.I1 = pm.space.I1(err.loc.val.max_exactwRB(1, 1), 2);
        pm.iter.I2 = pm.space.I2(err.loc.val.max_exactwRB(1, 2), 2);
        MTX_K.iter.exact = summation...
            (MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            pm.iter.I1, pm.iter.I2, pm.fix.I3);
        [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.exact, ...
            fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        
        %% new basis from error (current exact - previous appro).
        ERR.iter.store = Dis.iter.exact - Dis.all.appr;
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
        fce.RE.iter = phi.fre.all'*fce.val;
        
    end
    % total number of scalars.
    no.total = no.rb * no.phy * no.t_step + 1;
    disp('offline dynamic computation start')
    
    %% OFFLINE
    % 1. parameter domain adaptivity.
    % 1.1 initialize interpolating sample domain.
    pm.pre.hat = [find(pm.pre.hat(:, 1)) pm.pre.hat];
    pm.pre.block.hat = GSAGridtoBlockwithIndx(pm.pre.hat);
    no.block.hat = numel(pm.pre.block.hat);
    pm.pre.val.hat = 10.^pm.pre.hat(:, 2:3);
    no.pre.hat = size(pm.pre.hat, 1);
    
    pm.pre.hhat = GSARefineGrid(pm.pre.hat(:, 2:3));
    pm.pre.hhat = [find(pm.pre.hhat(:, 1)) pm.pre.hhat];
    pm.pre.block.hhat = GSAGridtoBlockwithIndx(pm.pre.hhat);
    no.block.hhat = numel(pm.pre.block.hhat);
    pm.pre.val.hhat = 10.^pm.pre.hhat(:, 2:3);
    no.pre.hhat = size(pm.pre.hhat, 1);
    
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
    
    resp.store.allPm.hhat = cell(no.pre.hhat, no.rb, no.phy, 2);
    imp.aply.asemb = cell(2, 1);
    resp.store.order.allPm = cell(2, 1);
    resp.store.fce.hhat = cell(no.pre.hhat, 1);
    %===========================================================================
    % 1.4.1. pre-computation from parameter domain.
    no.respRb = 2;
    for i_pre = 1:no.pre.hhat
        % always compute the finer pm domain, then select the related
        % coarse domain.
        MTX_K.pre = summation...
            (MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            pm.pre.val.hhat(i_pre, 1), pm.pre.val.hhat(i_pre, 2), pm.fix.I3);
        % pre-computation from force.
        [~, ~, ~, resp.fce.val, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
            fce.val, NMcoef, time.step, time.max, ...
            Dis.inpt, Vel.inpt);
        
        [resp.fce.svd.lvec, resp.fce.sigma, resp.fce.svd.rvec] = ...
            SVDmod(resp.fce.val, no.respRb);
        
        
        resp.store.fce.hhat(i_pre) = ...
            {{resp.fce.svd.lvec, resp.fce.sigma, resp.fce.svd.rvec'}};
        % 1.4.2. pre-computation from reduced basis. Due to change of
        % reduced basis, 1.4 has to be repeated in OFFLINE.
        for i_rb = 1:no.rb
            % 1.4.3. pre-computation from physical domains.
            for i_phy = 1:no.phy
                
                imp.aply.init = zeros(no.dof, no.t_step);
                imp.aply.step = zeros(no.dof, no.t_step);
                imp.aply.init(:, imp.loc.init) = ...
                    imp.aply.init(:, imp.loc.init) + imp.asemb{i_phy}(:, i_rb);
                imp.aply.step(:, imp.loc.step) = ...
                    imp.aply.step(:, imp.loc.step) + imp.asemb{i_phy}(:, i_rb);
                
                imp.aply.asemb(1) = {imp.aply.init};
                imp.aply.asemb(2) = {imp.aply.step};
                
                % 1.4.4. pre-computation regarding time difference.
                % (initial and step-in).
                for i_tdiff = 1:2
                    % when i_tdiff = 1, apply initial impulse; i_tdiff = 2,
                    % apply step-in impulse.
                    [~, ~, ~, resp.otpt.allPm.tdiff, ~, ~, ~, ~] = ...
                        NewmarkBetaReducedMethod...
                        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
                        imp.aply.asemb{i_tdiff}, ...
                        NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                    [resp.otpt.allPm.svd.lvec, resp.sigma, ...
                        resp.otpt.allPm.svd.rvec] = ...
                        SVDmod(resp.otpt.allPm.tdiff, no.respRb);
                    resp.store.allPm.hhat(i_pre, i_rb, i_phy, i_tdiff) = ...
                        {{resp.otpt.allPm.svd.lvec, resp.sigma, ...
                        resp.otpt.allPm.svd.rvec'}};
                    
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
    
    [err.pre.trans_store.hhat] = GSAItplPreShortVecSVD...
        (no.respRb, no.rb, no.phy, no.pre.hhat, no.dof, no.t_step, ...
        resp.store.allPm.hhat, resp.store.fce.hhat);
    
    
    
    clear resp
    % extract err.pre.trans.hat from hhat, only need to locate with the
    % indices. Notice that the new points always aligned after the old
    % points. therefore just need to use a counter to extract the old
    % points, as well as the related err.
    
    err.pre.trans_store.hat = err.pre.trans_store.hhat(1:no.pre.hat, :);
    
    
    %% compute COEFFicient blocks. Because of 4-point linear interpolation,
    % the number of coef blocks needed to be stored = 4 * no.block.
    
    [coef.block.store.hhat] = GSAErrStoretoCoefStore...
        (no.total, no.block.hhat, no.pre.hhat, ...
        pm.pre.block.hhat, err.pre.trans_store.hhat);
    
    [coef.block.store.hat] = GSAErrStoretoCoefStore...
        (no.total, no.block.hat, no.pre.hat, ...
        pm.pre.block.hat, err.pre.trans_store.hat);
    
    
    disp('offline vector products end')
    disp('online start')
    
    %===========================================================================
    %% ONLINE
    pm.one = ones(no.rb, no.t_step);
    err.store.hhat.val = zeros(domain.length.I1, domain.length.I2);
    err.store.hat.val = zeros(domain.length.I1, domain.length.I2);
    err.store.exactwRB.val = zeros(domain.length.I1, domain.length.I2);
    
    for i_iter = 1:size(pm.space.comb, 1)
        %% compute alpha and ddot alpha for each PP.
        pm.loop.I1 = pm.space.comb(i_iter, 3);
        pm.loop.I2 = pm.space.comb(i_iter, 4);
        
        pm.loop.ori.I1 = log10(pm.loop.I1);
        pm.loop.ori.I2 = log10(pm.loop.I2);
        
        
        MTX_K.RE.iter = summation...
            (MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
            pm.loop.I1, pm.loop.I2, pm.fix.I3);
        
        [Dis.RE.otpt, Vel.RE.otpt, Acc.RE.otpt, ~, ~, ~, ~, ~] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.iter, ...
            fce.RE.iter, NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
        pm.rep.I1 = pm.loop.I1 * pm.one;
        pm.rep.I2 = pm.loop.I2 * pm.one;
        pm.rep.I3 = pm.fix.I3 * pm.one;
        
        %% upper triangular matrix for reduced variables and parameters.
        % 1 for reduced variables, 0 for parameter.
        [rv.up] = GSARvPmUpTriangular...
            (Acc.RE.otpt, Vel.RE.otpt, Dis.RE.otpt, 1, 1);
        
        [pm.up] = GSARvPmUpTriangular...
            (pm.one, pm.rep.I1, pm.rep.I2, pm.rep.I3, 0);
        
        %% interpolate from scalar coeff mtx for each pm point in each polygon.
        [err.otpt.itpl.hhat] = GSAInpolyItplOtptNoTri(no.block.hhat, ...
            pm.loop.ori.I1, pm.loop.ori.I2, pm.loop.I1, pm.loop.I2, ...
            pm.pre.block.hhat, coef.block.store.hhat);
        [err.otpt.itpl.hat] = GSAInpolyItplOtptNoTri(no.block.hat, ...
            pm.loop.ori.I1, pm.loop.ori.I2, pm.loop.I1, pm.loop.I2, ...
            pm.pre.block.hat, coef.block.store.hat);
        
        %% final assembly, multiply interpolated error matrices with reduced
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
        
        clear err.otpt
        
        %% compute exact error with the enriched RB, which is U^e - \phi *
        % \alpha. Requires exact solution in pm domain.
        
        [err.exactwRB] = GSAExactWithRB(summation, relativeErrSq, ...
            MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ....
            pm.loop.I1, pm.loop.I2, pm.fix.I3, phi.ident, fce.val, ...
            NMcoef, time.step, time.max, ...
            Dis.inpt, Vel.inpt, phi.fre.all, Dis.RE.otpt, Dis.trial.exact);
        err.store.exactwRB.val(i_iter) = err.store.exactwRB.val(i_iter) + ...
            err.exactwRB;
        
    end
    clear coef
    
    disp('online end')
    
    %% the new error estimate: 'surface' = max difference between hhat and hat
    % surfaces.
    % the old error estimate: 'maxPoint' = difference between max point in hhat
    % and hat surfaces.
    err.estimate = 'surface';
    switch err.estimate
        case 'maxPoint'
            err.diff.store = ...
                abs(err.store.hhat.val - err.store.hat.val) ./ ...
                err.store.hhat.val;
            refinement.cond = max(err.diff.store(:));
        case 'surface'
            [err.max.val_hhat, err.loc.idx.max_hhat] = ...
                max(err.store.hhat.val(:));
            [err.max.val_hat, err.loc.idx.max_hat] = max(err.store.hat.val(:));
            refinement.cond = ...
                abs((err.max.val_hhat - err.max.val_hat) / ...
                err.max.val_hhat);
    end
    disp('error condition = '), disp(refinement.cond)
    i_cnt_general = i_cnt_general+1;
    if refinement.cond <= refinement.thres
        disp('no h-refinement')
        % if error condition <= 1, no h-refinementnement is performed, find
        % maximum error and related parameter information.
        pm.pre.hat = pm.pre.hat(:, 2:3);
        
        %% assess error information.
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
        pm.max.loc.I1 = pm.space.I1(err.loc.val.max_hat(1, 1));
        pm.max.loc.I2 = pm.space.I2(err.loc.val.max_hat(1, 2));
        pm.max.val.I1 = pm.space.comb(err.loc.idx.max_hat, 3);
        pm.max.val.I2 = pm.space.comb(err.loc.idx.max_hat, 4);
        pm.max.ori.I1 = pm.ori.I1(err.loc.val.max_hat(1, 1));
        pm.max.ori.I2 = pm.ori.I2(err.loc.val.max_hat(1, 2));
        
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
                pm.max.loc.I1, pm.max.loc.I2, ...
                pm.max.ori.I1, pm.max.ori.I2, ...
                err.max.val0, err.max.val_exactwRB, err.store.exactwRB.val, cool, ...
                view_angle.x, view_angle.y);
            %%
            if i_cnt_plot >= draw.row * draw.col
                disp('iterations reach maximum plot number')
                break
            end
            
        end
        %% compute approximation at max error point.
        
        MTX_K.RE.appr = summation...
            (MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
            pm.space.comb(err.loc.idx.max_hat, 3), ...
            pm.space.comb(err.loc.idx.max_hat, 4), pm.fix.I3);
        
        [~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.appr, ...
            fce.RE.iter, NMcoef, time.step, time.max, ...
            Dis.RE.inpt, Vel.RE.inpt);
    else
        disp(i_cnt_general)
        disp('h-refinement')
        
        % if error condition > 1, refine the interpolation domain.
        pm.pre.hat = pm.pre.hhat(:, 2:3);
    end
    toc
    keyboard
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
    '/GreedyAppro/mainIteration/t[%.1f]l[%.2f]rb0[%g]',...
    trialName, datestr(now, 'mmmddyyyy_HH-MM-SS'), '.mat'];
    datafile_name = sprintf(dataloc, pm.trial.val(1), pm.trial.val(2), ...
        time.max, time.step, no.rb0);
    save(datafile_name, 'progdata')
    
end
