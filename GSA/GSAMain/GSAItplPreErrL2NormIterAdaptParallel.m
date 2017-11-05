%%
sigma.store = [];
err.match = abs(err.max.val0);
err.bd=1e-8;
%%
seq.int = 1;
err.indc.loop = 2;

pm.pre.hat = [domain.bond.L.I1, domain.bond.L.I2; ...
    domain.bond.R.I1, domain.bond.L.I2; ...
    domain.bond.L.I1, domain.bond.R.I2; ...
    domain.bond.R.I1, domain.bond.R.I2];
%%
refinement.cond = 0.01;
refinement.thres = 0.8;
while err.match > err.bd
    if iCntGeneral == 1
        %% compute the next exact solution.
        pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1), 2);
        pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2), 2);
        MTX_K.iter.exact = K1120S0*pm.iter.I1+...
            K1021S0*pm.iter.I2+K1020S1*pmI3;
        [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phiID, Mmtx, Cmtx, MTX_K.iter.exact, ...
            Fval, NMcoef, tStep, tMax, disInpt, velInpt);
        
        %% new basis from error (current exact - previous appro).
        ERR.iter.store = Dis.iter.exact-disAppr;
        Nphi.iter = 1;
        [phi.fre.ERR, ~, sigma.val] = SVDmod(ERR.iter.store, Nphi.iter);
        sigma.store=[sigma.store; nonzeros(sigma.val)];
        phiPAR = [phiPAR phi.fre.ERR];
        phiPAR = GramSchmidtNew(phiPAR);
        noRb = size(phiPAR, 2);
        %% construct the reduced system.
        KreI1120S0 = phiPAR'*K1120S0*phiPAR;
        KreI1021S0 = phiPAR'*K1021S0*phiPAR;
        KreI1020S1 = phiPAR'*K1020S1*phiPAR;
        MreIter = phiPAR'*Mmtx*phiPAR;
        CreIter = phiPAR'*Cmtx*phiPAR;
        disReInpt = sparse(noRb, 1);
        velReInpt = sparse(noRb, 1);
        FreIter = phiPAR'*Fval;
    elseif refinement.cond <= refinement.thres
        %% compute the next exact solution.
        pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1), 2);
        pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2), 2);
        MTX_K.iter.exact = K1120S0*pm.iter.I1+...
            K1021S0*pm.iter.I2+K1020S1*pmI3;
        [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phiID, Mmtx, Cmtx, MTX_K.iter.exact, ...
            Fval, NMcoef, tStep, tMax, disInpt, velInpt);
        
        %% new basis from error (current exact - previous appro).
        ERR.iter.store = Dis.iter.exact-disAppr;
        Nphi.iter = 1;
        [phi.fre.ERR, ~, sigma.val] = SVDmod(ERR.iter.store, Nphi.iter);
        sigma.store=[sigma.store; nonzeros(sigma.val)];
        phiPAR = [phiPAR phi.fre.ERR];
        phiPAR = GramSchmidtNew(phiPAR);
        noRb = size(phiPAR, 2);
        %% construct the reduced system.
        KreI1120S0 = phiPAR'*K1120S0*phiPAR;
        KreI1021S0 = phiPAR'*K1021S0*phiPAR;
        KreI1020S1 = phiPAR'*K1020S1*phiPAR;
        MreIter = phiPAR'*Mmtx*phiPAR;
        CreIter = phiPAR'*Cmtx*phiPAR;
        disReInpt = sparse(noRb, 1);
        velReInpt = sparse(noRb, 1);
        FreIter = phiPAR'*Fval;
    end
    % total number of scalars.
    noTotal = noRb * noPhy * noTstep + 1;
%     tic
    %% OFFLINE    
    % Parameter domain adaptivity.
    
    pm.pre.hat = [find(pm.pre.hat(:, 1)) pm.pre.hat];
    pmPreBlockHat = GSAGridtoBlockwithIndx(pm.pre.hat);
    noBlockHat = numel(pmPreBlockHat);
    pm.pre.val.hat = 10.^pm.pre.hat(:, 2:3);
    no.pre.hat = size(pm.pre.hat, 1);
    
    pm.pre.hhat = GSARefineGrid(pm.pre.hat(:, 2:3));
    pm.pre.hhat = [find(pm.pre.hhat(:, 1)) pm.pre.hhat];
    pmPreBlockHHat = GSAGridtoBlockwithIndx(pm.pre.hhat);
    noBlockHHat = numel(pmPreBlockHHat);
    pm.pre.val.hhat = 10.^pm.pre.hhat(:, 2:3);
    no.pre.hhat = size(pm.pre.hhat, 1);
    
    % assemble MTX in cell.
    mtx.asemb = cell(noPhy, 1);
    mtx.asemb{1} = {Mmtx};
    mtx.asemb{2} = {Cmtx};
    mtx.asemb{3} = {K1120S0};
    mtx.asemb{4} = {K1021S0};
    mtx.asemb{5} = {K1020S1};
    % genarate impulses.
    imp.asemb = cell(noPhy, 1);
    for i_cel = 1:noPhy
        imp.asemb(i_cel) = {mtx.asemb{i_cel}{:}*phiPAR};
    end
    imp.loc.init = 1;
    imp.loc.step = 2;
    
    no.tdiff = 2; % seperate initial and step-in time
    respStoreAllPmHHat = cell(no.pre.hhat, noRb, noPhy, noTstep);
    imp.aply.asemb = cell(no.tdiff, 1);
    resp.store.order.all_pm = cell(2, 1);
    respStoreFceHHat = cell(no.pre.hhat, 1);
    %===========================================================================
    % 1. pre-computation from parameter domain.
    for i_pre = 1:no.pre.hhat
        % always compute the finer pm domain, then select the related
        % coarse domain.
        MTX_K.pre = K1120S0*pm.pre.val.hhat(i_pre, 1)+...
            K1021S0*pm.pre.val.hhat(i_pre, 2)+K1020S1*pmI3;
        % pre-compute from force.
        [~, ~, ~, resp.val.fce, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phiID, Mmtx, Cmtx, MTX_K.pre, ...
            Fval, NMcoef, tStep, tMax, ...
            disInpt, velInpt);
        respStoreFceHHat(i_pre) = {resp.val.fce};
        % 2. pre-compute from reduced basis.
        for i_rb = 1:noRb
            % 3. pre-compute from physical domains.
            for i_phy = 1:noPhy
                
                imp.aply.init = sparse(noDof, noTstep);
                imp.aply.step = sparse(noDof, noTstep);
                imp.aply.init(:, imp.loc.init) = ...
                    imp.aply.init(:, imp.loc.init)+imp.asemb{i_phy}(:, i_rb);
                imp.aply.step(:, imp.loc.step) = ...
                    imp.aply.step(:, imp.loc.step)+imp.asemb{i_phy}(:, i_rb);
                
                imp.aply.asemb(1) = {imp.aply.init};
                imp.aply.asemb(2) = {imp.aply.step};
                % 4. pre-compute regarding time difference (initial and step-in).
                for i_tdiff = 1:no.tdiff
                    % when i_tdiff = 1, apply initial impulse; i_tdiff = 2,
                    % apply step-in impulse.
                    [~, ~, ~, resp.otpt.all_pm.tdiff, ~, ~, ~, ~] = ...
                        NewmarkBetaReducedMethod...
                        (phiID, Mmtx, Cmtx, MTX_K.pre, ...
                        imp.aply.asemb{i_tdiff}, ...
                        NMcoef, tStep, tMax, disInpt, velInpt);
                    resp.store.order.all_pm(i_tdiff) = ...
                        {resp.otpt.all_pm.tdiff};
                end
                for i_ts = 1:noTstep
                    if i_ts == 1
                        respStoreAllPmHHat(i_pre, i_rb, i_phy, 1) = ...
                            {resp.store.order.all_pm{1}(:)};
                    else
                        resp.otpt.zeros = zeros(noDof, i_ts-2);
                        resp.otpt.nonzeros = ...
                            resp.store.order.all_pm{2}(:, 1:noTstep-i_ts+2);
                        resp.otpt.asemb = [resp.otpt.zeros resp.otpt.nonzeros];
                        respStoreAllPmHHat(i_pre, i_rb, i_phy, i_ts) = ...
                            {resp.otpt.asemb(:)};
                    end
                    
                end
                
            end
            
        end
        
    end
    
    errPreTransStoreHHat = cell(no.pre.hhat, 2);
%     toc
%     disp('offline dynamic computations')
    tic
    % extract from each interpolation sample point to obtain affined error
    % matrices, then assemble them into a (no.pre.hhat*1) cell according to 
    % number of sample points. The vector products are also perform in this
    % section.
    
    % Due to vector products in this section, parallization is required to
    % improve the performance. 
    disp('vector products (parallel) start')
    parfor i_pre = 1:no.pre.hhat
        
        respPreStoreHHat = respStoreAllPmHHat(i_pre, :, :, :);
        respPrerColAsembHHat = cat(2, respPreStoreHHat{:});
        respPrerColAsembHHat = ...
            [respStoreFceHHat{i_pre}(:) -respPrerColAsembHHat];
        errPreTransHHat = (respPrerColAsembHHat'*respPrerColAsembHHat);
        errPreTransStoreHHat(i_pre, :) = {i_pre, errPreTransHHat};
        
    end
    toc
    disp('vector products (parallel) end')
    
    
    clear resp respPreStoreHHat respPrerColAsembHHat respStoreAllPmHHat ...
       respStoreFceHHat
    % extract err.pre.trans.hat from hhat, only need to locate with the
    % indices. NOtice that the new points always aligned after the old
    % points. therefore just need to use a counter to extract the old
    % points, as well as the related err. 
    
    err.pre.trans_store.hat = errPreTransStoreHHat(1:no.pre.hat, :);
    
    
    % compute COEFFicient blocks. Because of 4-point linear interpolation,
    % the number of coef blocks needed to be stored = 4*no.block.
    
    disp('error to coefficients start')
    tic
    [coefBlockStoreHHat] = GSAErrStoretoCoefStore...
        (noTotal, noBlockHHat, no.pre.hhat, ...
        pmPreBlockHHat, errPreTransStoreHHat);
    
    [coefBlockStoreHat] = GSAErrStoretoCoefStore...
        (noTotal, noBlockHat, no.pre.hat, ...
        pmPreBlockHat, err.pre.trans_store.hat);
    toc
    disp('error to coefficients end')
    
    
    disp('online start (polygon output is parallised)')
    tic
    %===========================================================================
    %% ONLINE
    pmOne = ones(noRb, noTstep);
    errStoreHHatVal = zeros(domain.length.I1, domain.length.I2);
    errStoreHatVal = zeros(domain.length.I1, domain.length.I2);
    
    
    pmCombIter = pmComb;
    disReOtptPass = zeros(noRb, noTstep);
    for i_iter = 1:size(pmCombIter, 1)
        
        pmLoopOriI1 = log10(pmCombI1(i_iter));
        pmLoopOriI2 = log10(pmCombI2(i_iter));
        
        % compute alpha and ddot alpha for each PP.
        KReIter = KreI1120S0 * pmCombI1(i_iter) +...
            KreI1021S0 * pmCombI2(i_iter) +...
            KreI1020S1 * pmI3;
        KiterLoop = K1120S0 * pmCombI1(i_iter) +...
            K1021S0 * pmCombI2(i_iter) +...
            K1020S1 * pmI3;
        [disReOtpt, velReOtpt, accReOtpt, ~, ~, ~, ~, ~] = ...
            NewmarkBetaReducedMethod...
            (phiPAR, MreIter, CreIter, KReIter, ...
            FreIter, NMcoef, tStep, tMax, disReInpt, velReInpt);
        disReOtptPass = disReOtptPass + disReOtpt;
        rvAsemb = ...
            [accReOtpt; velReOtpt; disReOtpt; disReOtpt; disReOtpt];
        rvCol = [1; rvAsemb(:)];
        rvTrans = rvCol * rvCol';
        rvUpTri = sparse(triu(rvTrans));
        
        muRepI1 = pmCombI1(i_iter)*pmOne;
        muRepI2 = pmCombI2(i_iter)*pmOne;
        muRepI3 = pmI3 * pmOne;
        muAsemb = [pmOne; pmOne; muRepI1; muRepI2; muRepI3];
        muCol = [1; muAsemb(:)];
        muTrans = muCol * muCol';
        
        muUpTri = sparse(triu(muTrans));
%         clear rv mu;
        % interpolate from coeff for each pm point in each polygon.
        [errOtptItplHHat] = GSAInpolyItplOtpt(noBlockHHat, ...
            pmLoopOriI1, pmLoopOriI2, ...
            pmCombI1(i_iter), pmCombI2(i_iter), ...
            pmPreBlockHHat, coefBlockStoreHHat);
        [errOtptItplHat] = GSAInpolyItplOtpt(noBlockHat, ...
            pmLoopOriI1, pmLoopOriI2, ...
            pmCombI1(i_iter), pmCombI2(i_iter), ...
            pmPreBlockHat, coefBlockStoreHat);
        
        % final assembly, multiply interpolated error matrices with reduced
        % variable and parameter matrices. 
        
        
        errOtptItplHHat = errOtptItplHHat .* rvTrans .* muTrans;
        errOtptSmHHat = sum(errOtptItplHHat(:));
        errStoreHHatVal(i_iter) = errStoreHHatVal(i_iter)+...
            abs(errOtptSmHHat/sumsqr(disTrialExact));
        
        errOtptItplHat = errOtptItplHat .* rvTrans .* muTrans;
        errOtptSmHat = sum(errOtptItplHat(:));
        errStoreHatVal(i_iter) = errStoreHatVal(i_iter) +...
            abs(errOtptSmHat / sumsqr(disTrialExact));
%         disp(i_iter)
    end
    clear coef coefBlockStoreHHat coefBlockStoreHat
    toc
    disp('online end (polygon output is parallised)')
    
    % the new error estimate.
    err.diff.store = ...
        abs(errStoreHHatVal - errStoreHatVal)./errStoreHHatVal;
    refinement.cond = max(err.diff.store(:));
    disp('error condition = '), disp(refinement.cond)
    iCntGeneral = iCntGeneral+1;
    if refinement.cond <= refinement.thres
        disp('no h-refinementnement')
        % if error condition <= 1, no h-refinementnement is performed, find
        % maximum error and related parameter information. 
        pm.pre.hat = pm.pre.hat(:, 2:3);
        % find all error information.
        [err.max.val, err.loc.idx.max]=max(errStoreHHatVal(:));
        err.max.store=[err.max.store; err.max.val];
        pm.iter.row=pmComb(err.loc.idx.max, :);
        err.loc.val.max=pm.iter.row(:, 1:2);
        err.loc.store=[err.loc.store; err.loc.val.max];
        % find parameter information related to max error.
        pm.max.loc.I1 = pm.space.I1(err.loc.val.max(1, 1));
        pm.max.loc.I2 = pm.space.I2(err.loc.val.max(1, 2));
        pm.max.val.I1 = pmComb(err.loc.idx.max, 3);
        pm.max.val.I2 = pmComb(err.loc.idx.max, 4);
        pm.max.ori.I1 = pm.ori.I1(err.loc.val.max(1, 1));
        pm.max.ori.I2 = pm.ori.I2(err.loc.val.max(1, 2));
        
        %%
        if turnon == 1
            %%
            iCntPlot = iCntPlot + 1;
            progdata.rsurf.store(iCntGeneral) = {errStoreHHatVal};
            disp('max error = '), disp(err.max.val)
            disp(err.loc.val.max)
            disp('plot iteration number = '), disp(iCntPlot)
            %%
            GSAPlotFigure(font_size.label, font_size.axis, ...
                draw.row, draw.col, iCntPlot, ...
                domain.bond.L.I1, domain.bond.R.I1, ...
                domain.length.I1, domain.bond.L.I2, ...
                domain.bond.R.I2, domain.length.I2, ...
                pm.max.loc.I1, pm.max.loc.I2, ...
                pm.max.ori.I1, pm.max.ori.I2, ...
                err.max.val0, err.max.val, errStoreHatVal, cool, ...
                view_angle.x, view_angle.y);
            %%
            if iCntPlot >= draw.row*draw.col
                disp('iterations reach maximum plot number')
                break
            end
            
        end
        %%
        % compute approximation at max error point.
        MTX_K.RE.appr = KreI1120S0*pmComb(err.loc.idx.max, 3)+...
            KreI1021S0*pmComb(err.loc.idx.max, 4)+...
            KreI1020S1*pmI3;
        [~, ~, ~, disAppr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phiPAR, MreIter, CreIter, MTX_K.RE.appr, ...
            FreIter, NMcoef, tStep, tMax, ...
            disReInpt, velReInpt);
    else
        
        disp('h-refinementnement')
        % if error condition > 1, refinementne the interpolation domain.
        pm.pre.hat = pm.pre.hhat(:, 2:3);
    end
    
    
end

%%
if recordon == 1
    
    progdata.store{1, 2} = {phiPAR};
    progdata.store{2, 2} = {disReOtptPass};
    progdata.store{3, 2} = {progdata.rsurf.store};
    progdata.store{4, 2} = {err.max.store};
    progdata.store{5, 2} = {err.loc.store};
    dataloc = ...
        ['/home/xiaohan/Desktop/Temp/Documents/'...
        'ACME2016-extendedAbstractLatex/'...
        'Results/GS_Algorithm/Interpolation/Decomposition/L2norm/'...
        'linear[%d_%d]Greedy'];
    datafile_name = sprintf(dataloc, pm.trial.val(1), pm.trial.val(2));
    save(datafile_name, 'progdata')
    
end
