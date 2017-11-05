clear variables; clc;
format short;
tic
trialName = 'l2h1';
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

%% main while loop for GSA.

i_cnt_general = 1;
i_cnt_plot = 1;
err.match = 1;
err.bd = 1e-8;

draw.row = 2;
draw.col = 4;
err.store.all = cell(draw.row * draw.col, 1);
err.max.store = []; % truth.
err.loc.store = [];

while err.match > err.bd
    
    % the initial iteration is the error-controlled rb computation.
    if i_cnt_general == 1 
        
        err.control.thres = 0.01;
        
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
        
    elseif i_cnt_general > 1
        
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
        
    end
    
    no.rb = size(phi.fre.all, 2);
    
    %%
    % the error data we need to assess (thus initialize): truth, exact with
    % enriched RB, the two error estimate: ehat and ehhat. Error location
    % and max are needed for truth and exact with enriched RB, the rest
    % needs max only.

    err.store.val = zeros(domain.length.I1, domain.length.I2);
    h = waitbar(0,'Wait');
    steps = size(pm.space.comb, 1);
    % each iteration computes one norm error.
    Dis.trial.exact = Dis.trial.exact;
    for i_iter = 1:size(pm.space.comb, 1)
        
        waitbar(i_iter / steps)
        
        %%
        % compute alpha and ddot_alpha for each PP.
        MTX_K.RE.iter = summation...
            (MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
            pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4), ...
            pmVal.fix.I3);

        [Dis.RE.otpt, Vel.RE.otpt, Acc.RE.otpt, ~, ~, ~, ~, ~] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, ...
            MTX_K.RE.iter, fce.RE.iter.loop, NMcoef, ...
            time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
        %%
        % compute residual and corresponding error for each pm.
        MTX_K.iter.loop = ...
            summation(MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4), ...
            pmVal.fix.I3);
        
        res.inpt = fce.val - ...
            MTX_M.mtx * phi.fre.all * Acc.RE.otpt...
            - MTX_K.iter.loop * phi.fre.all * Dis.RE.otpt;
        Dis.inpt = zeros(no.dof, 1);
        Vel.inpt = zeros(no.dof, 1);
        
        [~, ~, ~, Dis.iter.res, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
            res.inpt, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        
        err.val = relativeErrSq(Dis.iter.res, Dis.trial.exact);
        err.store.val(i_iter) = err.store.val(i_iter) + err.val;
        
    end
    close(h)
    
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
    
    %% plot error response surfaces.
    
    turnon = 1;
    recordon = 0;
    font_size.label = 20;
    font_size.axis = 12;
    view_angle.x = -30;
    view_angle.y = 30;
    
    if turnon == 1
        %% store error surface.

        err.store.all(i_cnt_general) = {err.store.val};
        if i_cnt_general == 1
            axisLim = err.max.val;
        end
        
        gridSwitch = 0;
        GSAPlotFigure(font_size, draw, i_cnt_general, domain, pmLoc, pmExp, ...
            axisLim, err, cool, view_angle, gridSwitch);
        
    end
    if i_cnt_general >= draw.row * draw.col
        disp('iterations reach maximum plot number')
        break
    end
    i_cnt_general = i_cnt_general+1;
    
end
toc
%% record the data

recordOn = 1;

if recordOn == 1
    
    progdata.store = cell(2, 2);
    
    progdata.store{1, 1} = 'All reduced basis information';
    progdata.store{2, 1} = 'All error information';
    
    progdata.store{1, 2} = {phi};
    progdata.store{2, 2} = {err};
    
    dataloc = ...
        ['/home/xiaohan/Desktop/Temp/numericalResults/[%d_%d]'...
        '/GreedyExact/t[%.1f]l[%.2f]rb0[%g]_',...
        trialName, datestr(now, 'mmmddyyyy_HH-MM-SS'), '.mat'];
    datafile_name = sprintf(dataloc, pm.trial.val(1), pm.trial.val(2), ...
        time.max, time.step, no.rb0);
    save(datafile_name, 'progdata')
    
end