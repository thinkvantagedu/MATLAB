clear variables; clc;
format short;
tic
trialName = 'l9h2Coarse';
lin = 1; % linux or mac?

[INPfilename, MTX_M, MTX_K, loc_string_start, loc_string_end] = ...
    GSATrialCaseSelection(trialName, lin);

% heads for GSA.
GSAHeads;

phi.ident = sparse(eye(no.dof));
[~, ~, ~, Dis.trial.exact, ~, ~, ~, ~] = ...
    NewmarkBetaReducedMethod(phi.ident, ...
    MTX_M.mtx, MTX_C.mtx, MTX_K.trial.exact, ...
    fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);

err.max.store_exactwRB = []; % exact with enriched RB.
err.loc.store_exactwRB = [];err.max.store_hat = []; % ehat
err.loc.store_hat = [];
err.max.store_hhat = []; % ehhat
err.loc.store_hhat = [];

draw.row = 2;
draw.col = 4;
err.store.all.hat = cell(draw.row * draw.col, 1);
err.store.all.hhat = cell(draw.row * draw.col, 1);
err.store.all.exactwRB = cell(draw.row * draw.col, 1);
err.store.all.diff = cell(draw.row * draw.col, 1);

%% main while loop for GSA.
i_cnt_general = 1;
err.max.val = 1;
err.bd = 1e-8;

%% set up the initial hat and hhat pm (and pm block) domain.

pmExp.pre.hat = [(1:4)' [domain.bond.L.I1, domain.bond.L.I2; ...
    domain.bond.R.I1, domain.bond.L.I2; ...
    domain.bond.L.I1, domain.bond.R.I2; ...
    domain.bond.R.I1, domain.bond.R.I2]];

pmExp.pre.block.hat = GSAGridtoBlockwithIndx(pmExp.pre.hat);
[pmExp.pre.block.hhat, pmExp.pre.hhat] = GSARefineGridLocalwithIdx...
    (pmExp.pre.block.hat, 1.5, 1.5); % use middle point for initial refinement.
pmVal.pre.hhat = 10 .^ pmExp.pre.hhat(:, 2:3);

no.block.hat = numel(pmExp.pre.block.hat);
no.pre.hat = size(pmExp.pre.hat, 1);
no.block.hhat = numel(pmExp.pre.block.hhat);
no.pre.hhat = size(pmExp.pre.hhat, 1);

%% set up the refinement conditions.
% usually fixed, only change when thres changes.
refinement.cond = [];
% this is the threshold value, larger value allows less refinement.
refinement.thres = 0.1;

%% the main while loop
while err.max.val > err.bd
    % the initial iteration is the error-controlled rb computation.
    if i_cnt_general == 1
        
        [phi, Nphi] = GSAErrorControlledRB(err, ...
            Dis, MTX_M, MTX_K, fce, NMcoef, time, no, projection);
        
        [MTX_K, MTX_M, MTX_C, fce] = GSAReducedSysConstruction...
            (projection, phi, MTX_K, MTX_M, MTX_C, fce);
        
        Dis.RE.inpt = sparse(length(MTX_M.RE.iter), 1);
        Vel.RE.inpt = sparse(length(MTX_M.RE.iter), 1);
        
        % compute approximation at max error point.
        [Dis] = GSAApproSolution(MTX_M, MTX_C, MTX_K, fce, pmVal, ...
            NMcoef, time, Dis, Vel, phi, 'init');
        no.rb0 = size(phi.fre.all, 2);
        phi.no.rb0 = no.rb0;
        no.rb = no.rb0;
    elseif i_cnt_general > 1 && refinement.indicator == 0;
        
        Nphi.iter = 1;
        %% new basis from error (current exact - previous appro).
        [phi] = GSARbEnrichment(summation, ...
            pmVal, MTX_K, phi, MTX_M, MTX_C, fce, NMcoef, time, Dis, Vel, Nphi);
        
        [MTX_K, MTX_M, MTX_C, fce] = GSAReducedSysConstruction...
            (projection, phi, MTX_K, MTX_M, MTX_C, fce);
        
        Dis.RE.inpt = sparse(length(MTX_M.RE.iter), 1);
        Vel.RE.inpt = sparse(length(MTX_M.RE.iter), 1);
        
        % compute approximation at max error point.
        [Dis] = GSAApproSolution(MTX_M, MTX_C, MTX_K, fce, pmVal, ...
            NMcoef, time, Dis, Vel, phi, 'iter');
        no.rb = size(phi.fre.all, 2);
        
    end
    
    % total number of scalars.
    
    no.total = no.rb * no.phy * no.t_step + 1;
    %     disp('offline dynamic computation start')
    
    %% OFFLINE
    
    % 1.1 assemble MTX in cell.
    mtx.asemb = cell(no.phy, 1);
    mtx.asemb{1} = {MTX_M.mtx};
    mtx.asemb{2} = {MTX_C.mtx};
    mtx.asemb{3} = {MTX_K.I1120S0};
    mtx.asemb{4} = {MTX_K.I1021S0};
    mtx.asemb{5} = {MTX_K.I1020S1};
    % 1.2 genarate impulses.
    imp.asemb = cell(no.phy, 1);
    for i_cel = 1:no.phy
        imp.asemb(i_cel) = {mtx.asemb{i_cel}{:} * phi.fre.all};
    end
    resp.store.all_pm.hhat = cell(no.pre.hhat, no.rb, no.phy, 2);
    imp.aply.asemb = cell(2, 1);
    resp.store.fce.hhat = cell(no.pre.hhat, 1);
    %===========================================================================
    % 1.3.1. pre-computation from parameter domain.
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
        
        % 1.3.2. pre-compute from reduced basis.
        for i_rb = 1:no.rb
            % 1.3.3. pre-compute from physical domains.
            for i_phy = 1:no.phy
                
                imp.aply.init = zeros(no.dof, no.t_step);
                imp.aply.step = zeros(no.dof, no.t_step);
                imp.aply.init(:, 1) = imp.aply.init(:, 1) + ...
                    imp.asemb{i_phy}(:, i_rb);
                imp.aply.step(:, 2) = imp.aply.step(:, 2) + ...
                    imp.asemb{i_phy}(:, i_rb);
                
                imp.aply.asemb(1) = {imp.aply.init};
                imp.aply.asemb(2) = {imp.aply.step};
                % 1.3.4. pre-compute regarding time difference
                % (initial and step-in).
                for i_tdiff = 1:2
                    % when i_tdiff = 1, apply initial impulse; i_tdiff = 2,
                    % apply step-in impulse.
                    [~, ~, ~, resp.otpt.all_pm.tdiff, ~, ~, ~, ~] = ...
                        NewmarkBetaReducedMethod...
                        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
                        imp.aply.asemb{i_tdiff}, ...
                        NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                    
                    resp.store.all_pm.hhat(i_pre, i_rb, i_phy, i_tdiff) = ...
                        {resp.otpt.all_pm.tdiff};
                end
                
            end
            
        end
        
    end
    
    %     disp('offline dynamic computation end')
    %     disp('offline vector products start')
    
    % extract from each interpolation sample point to obtain affined error
    % matrices, then assemble resp.pre.col_asemb.hhat into a (no.pre.hhat*1)
    % cell according to number of sample points.
    
    [err.pre.trans_store.hhat] = GSAItplPreComputeUseShortVec(no, resp);
    
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
    
    % the newly added block.
    pmExpAdd = pmExp.pre.block.hhat(end - 3 : end);
    coefAdd = coef.block.store.hhat(end - 3 : end);
    %     disp('offline vector products end')
    %     disp('online start')
    
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
            fce.RE.iter.loop, NMcoef, time.step, time.max, ...
            Dis.RE.inpt, Vel.RE.inpt);
        
        pmVal.rep.I1 = pmVal.loop.I1 * pm.one;
        pmVal.rep.I2 = pmVal.loop.I2 * pm.one;
        pmVal.rep.I3 = pmVal.fix.I3 * pm.one;
        
        [rv.up] = GSARvPmUpTriangular...
            (Acc.RE.otpt, Vel.RE.otpt, Dis.RE.otpt, 1, 'rv');
        
        [pm.up] = GSARvPmUpTriangular...
            (pm.one, pmVal.rep.I1, pmVal.rep.I2, pmVal.rep.I3, 'pm');
        
        %===============================================================================================
        % interpolate from coeff for each pm point in each polygon.
        [err.otpt.itpl.hhat] = GSAInpolyItplOtptNoTri(no.block.hhat, ...
            pmExp, pmVal, pmExp.pre.block.hhat, coef.block.store.hhat);
        
        if no.block.hat == 1
            % before the first h-refinement, all pm need to be
            % interpolated;
            [err.otpt.itpl.hat] = GSAInpolyItplOtptNoTri(no.block.hat, ...
                pmExp, pmVal, pmExp.pre.block.hat, coef.block.store.hat);
            
        elseif no.block.hat > 1
            % after the first h-refinement, only the refined pm need to be
            % interpolated.
            % find the refined grid blocks and related coefficients.
            
            itpl.indicator = cellfun(@(pmExpAdd) inpolygon...
                (pmExp.loop.ori.I1, pmExp.loop.ori.I2, ...
                pmExpAdd(:,2), pmExpAdd(:,3)), pmExpAdd);
            
            % if pm point is in any newly added block, interpolate
            if any(itpl.indicator) == 1
                [err.otpt.itpl.hat] = GSAInpolyItplOtptNoTri(4, ...
                    pmExp, pmVal, pmExpAdd, coefAdd);
                
            elseif any(itpl.indicator) == 0
                err.otpt.itpl.hat = err.otpt.itpl.hhat;
                
            end
        end
        
        
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
        
        % record the difference between hat and hhat surface.
        err.store.diff.val = err.store.hat.val - err.store.hhat.val;
        
        % compute exact error with the enriched RB, which is U^e - \phi *
        % \alpha. Requires exact solution in pm domain.
        
        [err.exactwRB] = GSAExactWithRB(summation, relativeErrSq, ...
            MTX_M, MTX_C, MTX_K, pmVal, phi, fce, NMcoef, time, Dis, Vel);
        
        err.store.exactwRB.val(i_iter) = err.store.exactwRB.val(i_iter) + ...
            err.exactwRB;
        
    end
    
    %     disp('online end')
    [err.max.val_hat, err.loc.idx.max_hat] = max(err.store.hat.val(:));
    [err.max.val_hhat, err.loc.idx.max_hhat] = max(err.store.hhat.val(:));
    [err.max.val_exactwRB, err.loc.idx.max_exactwRB] = ...
        max(err.store.exactwRB.val(:));
    [err.max.val_diff, err.loc.idx.max_diff] = max(err.store.diff.val(:));
    
    %
    pm.iter.row_exactwRB = pm.space.comb(err.loc.idx.max_exactwRB, :);
    err.loc.val.max_exactwRB = pm.iter.row_exactwRB(:, 1:2);
    pm.iter.row_hat = pm.space.comb(err.loc.idx.max_hat, :);
    err.loc.val.max_hat = pm.iter.row_hat(:, 1:2);
    pm.iter.row_hhat = pm.space.comb(err.loc.idx.max_hhat, :);
    err.loc.val.max_hhat = pm.iter.row_hhat(:, 1:2);
    
    % find parameter information related to max error.
    pmLoc.max.I1 = pmVal.space.I1(err.loc.val.max_exactwRB(1, 1));
    pmLoc.max.I2 = pmVal.space.I2(err.loc.val.max_exactwRB(1, 2));
    pmVal.max.I1 = pm.space.comb(err.loc.idx.max_exactwRB, 3);
    pmVal.max.I2 = pm.space.comb(err.loc.idx.max_exactwRB, 4);
    pmExp.max.ori.I1 = log10(pmVal.max.I1);
    pmExp.max.ori.I2 = log10(pmVal.max.I2);
    % the new error estimate: 'maxPointatSurfaceDiff' = max difference between
    % hhat and hat surfaces.
    % the old error estimate: 'maxPointatEachSurface' = difference between max
    % point in hhat and hat surfaces.err.max.store.
    
    err.estimate = 'maxPointatEachSurface';
    switch err.estimate
        case 'maxPointatSurfaceDiff'
            err.diff.store = ...
                abs(err.store.diff.val) ./ ...
                err.store.hhat.val;
            refinement.cond = max(err.diff.store(:));
            
        case 'maxPointatEachSurface'
            refinement.cond = ...
                abs((err.max.val_hhat - err.max.val_hat) / ...
                err.max.val_hhat);
    end
    
    disp('refinement condition = '), disp(refinement.cond)
    
    if refinement.cond <= refinement.thres
        refinement.indicator = 0;
        disp('iteration '), disp(i_cnt_general)
        disp('no h-refinement')
        
        %% NO H-REFINEMENT, assess error information, enrich rb.
        % find info regarding exact error with enriched RB.err.loc.val.max
        
        
        err.loc.store_exactwRB = [err.loc.store_exactwRB; ...
            err.loc.val.max_exactwRB];
        err.max.store_exactwRB = [err.max.store_exactwRB; err.max.val_exactwRB];
        
        % error info of ehat.
        
        
        err.loc.store_hat = [err.loc.store_hat; err.loc.val.max_hat];
        err.max.store_hat = [err.max.store_hat; err.max.val_hat];
        
        % error info of ehhat.
        
        
        err.loc.store_hhat = [err.loc.store_hhat; err.loc.val.max_hhat];
        err.max.store_hhat = [err.max.store_hhat; err.max.val_hhat];
        
        %%
        
        
        %%
        turnon = 1;
        recordon = 0;
        font_size.label = 20;
        font_size.axis = 12;
        view_angle.x = -30;
        view_angle.y = 30;
        
        if turnon == 1
            %% store error surface.
            err.store.all.hat(i_cnt_general) = {err.store.hat.val};
            err.store.all.hhat(i_cnt_general) = {err.store.hhat.val};
            err.store.all.exactwRB(i_cnt_general) = {err.store.exactwRB.val};
            err.store.all.diff(i_cnt_general) = {err.store.diff.val};
            disp('max error = '), disp(err.max.val_exactwRB)
            disp(err.loc.val.max_exactwRB)
            
            %%
            % err.store.val is the error response surface to be plotted.
            % choices of test: err.store.hat.val, err.store.hhat.val,
            % err.store.diff.val, err.store.exactwRB.val.
            err.store.val = err.store.exactwRB.val;
            % choices of test: err.max.val_hat, err.max.val_hhat,
            % err.max.val_diff, err.max.val_exactwRB.
            err.max.val = err.max.val_exactwRB;
            if i_cnt_general == 1
                axisLim = err.max.val;
            end
            
            gridSwitch = 1;
            surface = GSAPlotFigure(font_size, draw, i_cnt_general, ...
                domain, pmLoc, pmExp, axisLim, err, cool, view_angle, ...
                gridSwitch);
            
            %%
            if i_cnt_general >= draw.row * draw.col
                disp('iterations reach maximum plot number')
                break
            end
            
        end
        i_cnt_general = i_cnt_general+1;
        
    elseif refinement.cond > refinement.thres
        refinement.indicator = 1;
        disp('h-refinement')
        
        %% H-REFINEMENT.
        pmExp.pre.hat = pmExp.pre.hhat;
        pmExp.pre.block.hat = GSAGridtoBlockwithIndx(pmExp.pre.hat);
        [pmExp.pre.block.hhat, pmExp.pre.hhat] = GSARefineGridLocalwithIdx...
            (pmExp.pre.block.hat, pmExp.max.ori.I1, pmExp.max.ori.I2);
        pmVal.pre.hhat = 10.^pmExp.pre.hhat(:, 2:3);
        
        no.block.hat = numel(pmExp.pre.block.hat);
        no.pre.hat = size(pmExp.pre.hat, 1);
        no.block.hhat = numel(pmExp.pre.block.hhat);
        no.pre.hhat = size(pmExp.pre.hhat, 1);
        
    end
    
end
toc
%% record the data

recordOn = 0;

if recordOn == 1
    
    progdata.store = cell(2, 2);
    
    progdata.store{1, 1} = 'All reduced basis information';
    progdata.store{2, 1} = 'All error information';
    
    progdata.store{1, 2} = {phi};
    progdata.store{2, 2} = {err};
    
    dataloc = ...
        ['/home/xiaohan/Desktop/Temp/numericalResults/[%d_%d]'...
        '/GreedyAppro/NormShortVecAdapt/t[%.1f]l[%.2f]rb0[%g]_',...
        trialName, datestr(now, 'mmmddyyyy_HH-MM-SS'), '.mat'];
    datafile_name = sprintf(dataloc, pmVal.trial.I1(1), pmVal.trial.I2(2), ...
        time.max, time.step, no.rb0);
    save(datafile_name, 'progdata')
    
end