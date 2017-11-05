%%
sigma.store = [];
err.match = abs(err.max.val0);
err.bd=1e-8;
%%
seq.int = 1;
err.indc.loop = 2;
%%
while err.match > err.bd
    
    % compute the next exact solution.
    % test_NO = 1;
    % for i_test = 1:test_NO
    pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1), 2);
    pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2), 2);
    
    MTX_K.iter.exact = MTX_K.I1120S0*pm.iter.I1+...
        MTX_K.I1021S0*pm.iter.I2+...
        MTX_K.I1020S1*pm.fix.I3;
    
    [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.exact, ...
        fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
    %% new basis from error (current exact - previous appro).
    ERR.iter.store = Dis.iter.exact-Dis.all.appr;
    Nphi.iter = 1;
    [phi.fre.ERR, ~, sigma.val] = SVDmod(ERR.iter.store, Nphi.iter);
    sigma.store=[sigma.store; nonzeros(sigma.val)];
    phi.fre.all = [phi.fre.all phi.fre.ERR];
    phi.fre.all = GramSchmidtNew(phi.fre.all);
    no.rb = size(phi.fre.all, 2);
    %%
    MTX_K.RE.I1120S0 = phi.fre.all'*MTX_K.I1120S0*phi.fre.all;
    MTX_K.RE.I1021S0 = phi.fre.all'*MTX_K.I1021S0*phi.fre.all;
    MTX_K.RE.I1020S1 = phi.fre.all'*MTX_K.I1020S1*phi.fre.all;
    MTX_M.RE.iter = phi.fre.all'*MTX_M.mtx*phi.fre.all;
    MTX_C.RE.iter = phi.fre.all'*MTX_C.mtx*phi.fre.all;
    Dis.RE.inpt = sparse(no.rb, 1);
    Vel.RE.inpt = sparse(no.rb, 1);
    fce.RE.iter = phi.fre.all'*fce.val;
    err.indc.max = 2;
    err.indc.thres = 1;
    
    method.time = 'itpl';
    switch method.time
        case 'decomp'
            err_sqr.store = zeros(domain.length.I1, domain.length.I2);
            imp.store.M = MTX_M.mtx*phi.fre.all;
            imp.store.C = MTX_C.mtx*phi.fre.all;
            imp.store.K.I1120S0 = MTX_K.I1120S0*phi.fre.all;
            imp.store.K.I1021S0 = MTX_K.I1021S0*phi.fre.all;
            imp.store.K.I1020S1 = MTX_K.I1020S1*phi.fre.all;
            tic
            for i_iter = 1:size(pm.space.comb, 1)
                %% compute alpha and ddot alpha for each PP.
                MTX_K.RE.iter = MTX_K.RE.I1120S0*pm.space.comb(i_iter, 3)+...
                    MTX_K.RE.I1021S0*pm.space.comb(i_iter, 4)+...
                    MTX_K.RE.I1020S1*pm.fix.I3;
                MTX_K.iter.loop = MTX_K.I1120S0*pm.space.comb(i_iter, 3)+...
                    MTX_K.I1021S0*pm.space.comb(i_iter, 4)+...
                    MTX_K.I1020S1*pm.fix.I3;
                [Dis.RE.otpt, Vel.RE.otpt, Acc.RE.otpt, ...
                    ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                    (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.iter, ...
                    fce.RE.iter, NMcoef, time.step, time.max, ...
                    Dis.RE.inpt, Vel.RE.inpt);
                %% response from force.
                [~, ~, ~, Dis.asemb.fce, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                
                loc.init = 1;
                loc.step = 2;
                
                %% generate impulse response from initial impulse and step impulse, each
                %% size = no.rb*no.dof, no.t_Step.
                Dis.storerb.init.M = GSAImpulseSolutionStoreRB...
                    (imp.store.M, loc.init, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                Dis.storerb.step.M = GSAImpulseSolutionStoreRB...
                    (imp.store.M, loc.step, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                
                Dis.storerb.init.K.I1120S0 = GSAImpulseSolutionStoreRB...
                    (imp.store.K.I1120S0, loc.init, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                Dis.storerb.step.K.I1120S0 = GSAImpulseSolutionStoreRB...
                    (imp.store.K.I1120S0, loc.step, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                
                Dis.storerb.init.K.I1021S0 = GSAImpulseSolutionStoreRB...
                    (imp.store.K.I1021S0, loc.init, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                Dis.storerb.step.K.I1021S0 = GSAImpulseSolutionStoreRB...
                    (imp.store.K.I1021S0, loc.step, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                
                Dis.storerb.init.K.I1020S1 = GSAImpulseSolutionStoreRB...
                    (imp.store.K.I1020S1, loc.init, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                Dis.storerb.step.K.I1020S1 = GSAImpulseSolutionStoreRB...
                    (imp.store.K.I1020S1, loc.step, ...
                    no.dof, no.t_step, no.rb, phi.ident, ...
                    MTX_M.mtx, MTX_C.mtx, MTX_K.iter.loop, ...
                    NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                %%
                Dis.asemb.M = zeros(no.dof, no.t_step);
                Dis.asemb.K.I1120S0 = zeros(no.dof, no.t_step);
                Dis.asemb.K.I1021S0 = zeros(no.dof, no.t_step);
                Dis.asemb.K.I1020S1 = zeros(no.dof, no.t_step);
                for i_time = 1:no.t_step
                    for i_rb = 1:no.rb
                        if i_time == 1
                            Dis.asemb.M = Dis.asemb.M+...
                                Dis.storerb.init.M...
                                ((i_rb-1)*no.dof+1:i_rb*no.dof, :)*...
                                Acc.RE.otpt(i_rb, 1);
                            Dis.asemb.K.I1120S0 = Dis.asemb.K.I1120S0+...
                                Dis.storerb.init.K.I1120S0...
                                ((i_rb-1)*no.dof+1:i_rb*no.dof, :)*...
                                Dis.RE.otpt(i_rb, 1);
                            Dis.asemb.K.I1021S0 = Dis.asemb.K.I1021S0+...
                                Dis.storerb.init.K.I1021S0...
                                ((i_rb-1)*no.dof+1:i_rb*no.dof, :)*...
                                Dis.RE.otpt(i_rb, 1);
                            Dis.asemb.K.I1020S1 = Dis.asemb.K.I1020S1+...
                                Dis.storerb.init.K.I1020S1...
                                ((i_rb-1)*no.dof+1:i_rb*no.dof, :)*...
                                Dis.RE.otpt(i_rb, 1);
                            
                        elseif i_time>1
                            % Dis.zeros starts from 0 columns,
                            % otherwise there will be 2 zeros
                            % columns.
                            Dis.zero.M = zeros(no.dof, i_time-2);
                            Dis.nonzero.M = ...
                                Dis.storerb.step.M((i_rb-1)*no.dof+1:...
                                i_rb*no.dof, 1:(no.t_step-i_time+2));
                            Dis.imp.M = [Dis.zero.M Dis.nonzero.M];
                            Dis.asemb.M = Dis.asemb.M+...
                                Dis.imp.M*Acc.RE.otpt(i_rb, i_time);
                            
                            Dis.zero.K.I1120S0 = zeros(no.dof, i_time-2);
                            Dis.nonzero.K.I1120S0 = ...
                                Dis.storerb.step.K.I1120S0((i_rb-1)*no.dof+1:...
                                i_rb*no.dof, 1:(no.t_step-i_time+2));
                            Dis.imp.K.I1120S0 = ...
                                [Dis.zero.K.I1120S0 Dis.nonzero.K.I1120S0];
                            Dis.asemb.K.I1120S0 = Dis.asemb.K.I1120S0+...
                                Dis.imp.K.I1120S0*Dis.RE.otpt(i_rb, i_time);
                            
                            Dis.zero.K.I1021S0 = zeros(no.dof, i_time-2);
                            Dis.nonzero.K.I1021S0 = ...
                                Dis.storerb.step.K.I1021S0((i_rb-1)*no.dof+1:...
                                i_rb*no.dof, 1:(no.t_step-i_time+2));
                            Dis.imp.K.I1021S0 = ...
                                [Dis.zero.K.I1021S0 Dis.nonzero.K.I1021S0];
                            Dis.asemb.K.I1021S0 = Dis.asemb.K.I1021S0+...
                                Dis.imp.K.I1021S0*Dis.RE.otpt(i_rb, i_time);
                            
                            Dis.zero.K.I1020S1 = zeros(no.dof, i_time-2);
                            Dis.nonzero.K.I1020S1 = ...
                                Dis.storerb.step.K.I1020S1((i_rb-1)*no.dof+1:...
                                i_rb*no.dof, 1:(no.t_step-i_time+2));
                            Dis.imp.K.I1020S1 = ...
                                [Dis.zero.K.I1020S1 Dis.nonzero.K.I1020S1];
                            Dis.asemb.K.I1020S1 = Dis.asemb.K.I1020S1+...
                                Dis.imp.K.I1020S1*Dis.RE.otpt(i_rb, i_time);
                            
                        end
                        
                    end
                    
                end
                
                Dis.asemb.K.total = Dis.asemb.K.I1120S0*pm.space.comb(i_iter, 3)+...
                    Dis.asemb.K.I1021S0*pm.space.comb(i_iter, 4)+...
                    Dis.asemb.K.I1020S1*pm.fix.I3;
                err.mtx = Dis.asemb.fce-Dis.asemb.M-Dis.asemb.K.total;
                err_sqr.store(i_iter) = err_sqr.store(i_iter)+...
                    sumsqr(err.mtx)/sumsqr(Dis.trial.exact);
                err.val = norm(err.mtx, 'fro')/norm(Dis.trial.exact, 'fro');
                err.store.val(i_iter) = err.store.val(i_iter)+err.val;
                disp(i_iter)
            end
            toc
            keyboard
        case 'itpl'
            err.store.val = zeros(domain.length.I1, domain.length.I2);
            %% OFFLINE
            pm.pre.loc.all.corner = {[domain.bond.L.I1, domain.bond.L.I2; ...
                domain.bond.R.I1, domain.bond.L.I2; ...
                domain.bond.L.I1, domain.bond.R.I2; ...
                domain.bond.R.I1, domain.bond.R.I2]};
            % assemble MTX in cell.
            mtx.asemb = cell(no.phy, 1);
            mtx.asemb{1} = mat2cell(MTX_M.mtx, no.dof, no.dof);
            mtx.asemb{2} = mat2cell(MTX_C.mtx, no.dof, no.dof);
            mtx.asemb{3} = mat2cell(MTX_K.I1120S0, no.dof, no.dof);
            mtx.asemb{4} = mat2cell(MTX_K.I1021S0, no.dof, no.dof);
            mtx.asemb{5} = mat2cell(MTX_K.I1020S1, no.dof, no.dof);
            % genarate impulses.
            imp.asemb = cell(no.phy, 1);
            for i_cel = 1:no.phy
                
                imp.asemb(i_cel) = {mtx.asemb{i_cel}{:}*phi.fre.all};
                
            end
            
            imp.loc.init = 1;
            imp.loc.step = 2;
            
            pm.pre.val.block = 10.^pm.pre.loc.all.corner{:};
            no.pre = size(pm.pre.val.block, 1);
            
            
            %===================================================================
            % 1. pre-computation from physical domains.
            no.order = 2;
            
            resp.rb_pre_phy_t.store = cell(no.pre, no.rb, no.phy, no.t_step);
            imp.aply.asemb = cell(no.order, 1);
            resp.otpt.rb_pre_phy_t.order_store = cell(2, 1);
            resp.store.fce = cell(no.pre, 1);
            for i_pre = 1:no.pre
                
                % pre-computation from force.
                
                MTX_K.pre = MTX_K.I1120S0*pm.pre.val.block(i_pre, 1)+...
                    MTX_K.I1021S0*pm.pre.val.block(i_pre, 2)+...
                    MTX_K.I1020S1*pm.fix.I3;
                [~, ~, ~, resp.val.fce, ~, ~, ~, ~] = ...
                    NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
                    fce.val, NMcoef, time.step, time.max, ...
                    Dis.inpt, Vel.inpt);
                resp.store.fce(i_pre) = {resp.val.fce};
                
                for i_rb = 1:no.rb
                    
                    for i_phy = 1:no.phy
                        
                        imp.aply.init = sparse(no.dof, no.t_step);
                        imp.aply.step = sparse(no.dof, no.t_step);
                        imp.aply.init(:, imp.loc.init) = ...
                            imp.aply.init(:, imp.loc.init)+...
                            imp.asemb{i_phy}(:, i_rb);
                        imp.aply.step(:, imp.loc.step) = ...
                            imp.aply.step(:, imp.loc.step)+...
                            imp.asemb{i_phy}(:, i_rb);
                        imp.aply.asemb(1) = {imp.aply.init};
                        imp.aply.asemb(2) = {imp.aply.step};
                        
                        for i_order = 1:no.order
                            
                            [~, ~, ~, resp.otpt.rb_pre_phy_t.order, ~, ~, ~, ~]...
                                = NewmarkBetaReducedMethod...
                                (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.pre, ...
                                imp.aply.asemb{i_order}, ...
                                NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
                            resp.otpt.rb_pre_phy_t.order_store(i_order) = ...
                                {resp.otpt.rb_pre_phy_t.order};
                        end
                        for i_ts = 1:no.t_step
                            if i_ts == 1
                                resp.rb_pre_phy_t.store(i_pre, i_rb, i_phy, 1)...
                                    = {resp.otpt.rb_pre_phy_t.order_store{1}(:)};
                            else
                                resp.otpt.zeros = zeros(no.dof, i_ts-2);
                                resp.otpt.nonzeros = ...
                                    resp.otpt.rb_pre_phy_t.order_store{2}...
                                    (:, 1:no.t_step-i_ts+2);
                                resp.otpt.asemb = ...
                                    [resp.otpt.zeros resp.otpt.nonzeros];
                                resp.rb_pre_phy_t.store(i_pre, i_rb, i_phy, i_ts)...
                                    = {resp.otpt.asemb(:)};
                            end
                            
                        end
                        
                    end
                    
                end
                
            end
            
            err.pre.trans_store = cell(no.pre, 1);
            
            for i_pre = 1:no.pre
                
                resp.pre.store = resp.rb_pre_phy_t.store(i_pre, :, :, :);
                resp.pre.col_asemb = cat(2, resp.pre.store{:});
                resp.pre.col_asemb = ...
                    [resp.store.fce{i_pre}(:) -resp.pre.col_asemb];
                err.pre.trans = {resp.pre.col_asemb'*resp.pre.col_asemb};
                err.pre.trans_store(i_pre) = err.pre.trans;
                
            end
            
            [resp.pre.coeff] = LagInterpolationCoeff...
                (pm.pre.val.block, cell2mat(err.pre.trans_store));
            
            %% ONLINE
            pm.one = ones(no.rb, no.t_step);
            err.store.val = zeros(domain.length.I1, domain.length.I2);
            err.log_store.val = zeros(domain.length.I1, domain.length.I2);
            tic
            for i_iter = 1:size(pm.space.comb, 1)
                
                pm.loop.I1 = pm.space.comb(i_iter, 3);
                pm.loop.I2 = pm.space.comb(i_iter, 4);
                
                % compute alpha and ddot alpha for each PP.
                MTX_K.RE.iter = MTX_K.RE.I1120S0*pm.loop.I1+...
                    MTX_K.RE.I1021S0*pm.loop.I2+...
                    MTX_K.RE.I1020S1*pm.fix.I3;
                MTX_K.iter.loop = MTX_K.I1120S0*pm.loop.I1+...
                    MTX_K.I1021S0*pm.loop.I2+...
                    MTX_K.I1020S1*pm.fix.I3;
                [Dis.RE.otpt, Vel.RE.otpt, Acc.RE.otpt, ~, ~, ~, ~, ~] = ...
                    NewmarkBetaReducedMethod...
                    (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.iter, ...
                    fce.RE.iter, NMcoef, time.step, time.max, ...
                    Dis.RE.inpt, Vel.RE.inpt);
                
                rv.asemb = [Acc.RE.otpt; Vel.RE.otpt; ...
                    Dis.RE.otpt; Dis.RE.otpt; Dis.RE.otpt];
                rv.col = [1; rv.asemb(:)];
                rv.trans = rv.col*rv.col';
                
                
                pm.rep.I1 = pm.loop.I1*pm.one;
                pm.rep.I2 = pm.loop.I2*pm.one;
                pm.rep.I3 = pm.fix.I3*pm.one;
                pm.asemb = [pm.one; pm.one; pm.rep.I1; pm.rep.I2; pm.rep.I3];
                pm.col = [1; pm.asemb(:)];
                pm.trans = pm.col*pm.col';
                
                err.otpt.itpl = LagInterpolationOtptSingle...
                    (resp.pre.coeff, pm.loop.I1, pm.loop.I2, no.pre);
                
                err.otpt.itpl = err.otpt.itpl.*rv.trans.*pm.trans;
                err.otpt.sm = sum(err.otpt.itpl(:));
                err.store.val(i_iter) = err.store.val(i_iter)+...
                    abs(err.otpt.sm/sumsqr(Dis.trial.exact));
                disp(i_iter)
            end
            toc
            [err.max.val, err.loc.idx.max]=max(err.store.val(:));
            err.max.store=[err.max.store; err.max.val];
            pm.iter.row=pm.space.comb(err.loc.idx.max, :);
            err.loc.val.max=pm.iter.row(:, 1:2);
            err.loc.store=[err.loc.store; err.loc.val.max];
            
    end
    
    pm.max.loc.I1 = pm.space.I1(err.loc.val.max(1, 1));
    pm.max.loc.I2 = pm.space.I2(err.loc.val.max(1, 2));
    pm.max.val.I1 = pm.space.comb(err.loc.idx.max, 3);
    pm.max.val.I2 = pm.space.comb(err.loc.idx.max, 4);
    pm.max.ori.I1 = pm.ori.I1(err.loc.val.max(1, 1));
    pm.max.ori.I2 = pm.ori.I2(err.loc.val.max(1, 2));
    %%
    if turnon == 1
        %%
        i_cnt=i_cnt+1;
        progdata.rsurf.store(i_cnt) = {err.store.val};
        disp(err.max.val)
        disp(err.loc.val.max)
        disp(i_cnt)
        %%
        GSAPlotFigure(font_size.label, font_size.axis, ...
            draw.row, draw.col, i_cnt, domain.bond.L.I1, domain.bond.R.I1, ...
            domain.length.I1, domain.bond.L.I2, ...
            domain.bond.R.I2, domain.length.I2, ...
            pm.max.loc.I1, pm.max.loc.I2, ...
            pm.max.ori.I1, pm.max.ori.I2, ...
            err.max.val0, err.max.val, err.store.val);
        %%
        if i_cnt>=draw.row*draw.col
            disp('iterations reach maximum plot number')
            break
        end
        
    end
    %%
    % compute approximation at max error point.
    MTX_K.RE.appr = MTX_K.RE.I1120S0*pm.space.comb(err.loc.idx.max, 3)+...
        MTX_K.RE.I1021S0*pm.space.comb(err.loc.idx.max, 4)+...
        MTX_K.RE.I1020S1*pm.fix.I3;
    [~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.appr, ...
        fce.RE.iter, NMcoef, time.step, time.max, ...
        Dis.RE.inpt, Vel.RE.inpt);
    disp(err.max.val)
    disp(err.loc.val.max)
    keyboard
end

%%
if recordon == 1
    
    
    progdata.store{1, 2} = {phi.fre.all};
    progdata.store{2, 2} = {Dis.RE.otpt};
    progdata.store{3, 2} = {progdata.rsurf.store};
    progdata.store{4, 2} = {err.max.store};
    progdata.store{5, 2} = {err.loc.store};
    dataloc = ['/home/xiaohan/Desktop/Temp/Documents/ACME2016-extendedAbstractLatex/'...
        'Results/GS_Algorithm/Interpolation/Decomposition/L2norm/linear[%d_%d]Greedy'];
    datafile_name = sprintf(dataloc, pm.trial.val(1), pm.trial.val(2));
    save(datafile_name, 'progdata')
    
end

