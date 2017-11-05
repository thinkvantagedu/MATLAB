%%
profile on
i_cnt=1;
sigma.store = [];
err.match = abs(err.max.val0);
err.bd=1e-4;
%%
seq.int = 1;
err.indc.loop = 1;
while err.match > err.bd
    %% compute the next exact solution.
    pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1));
    pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2));
    
    MTX_K.iter.err_max = MTX_K.I1120S0*pm.iter.I1+MTX_K.I1021S0*pm.iter.I2+MTX_K.I1020S1*pm.fix.I3;
    
    [~, ~, ~, Dis.iter.exact, ~, ~, ~, ~] = ...
        NewmarkBetaReducedMethod(phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.iter.err_max, ...
        fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
    %% new basis from error (current exact - previous appro).
    % ERROR = current exact solution - previous approximation.
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
    
    fce.RE.iter.loop = phi.fre.all'*fce.val;
    
    err.indc.max = 2;
    err.indc.thres = 1;
    err.store.val = zeros(domain.length.I1, domain.length.I2);
    %% OFFLINE
    pm.pre.all.corner = {[domain.bond.L.I1, domain.bond.L.I2; domain.bond.R.I1, domain.bond.L.I2; ...
        domain.bond.L.I1, domain.bond.R.I2; domain.bond.R.I1, domain.bond.R.I2]};
    pm.pre.all.corner = {[1 1; 1 1.5; 1 2; 1.5 1;1.5 1.5; 1.5 2; 2 1; 2 1.5; 2 2]};
    %  while err.indc.max > err.indc.thres
    %  err.indc.max>threshold, refine; <threshold, jump out and keep the finer grid.
    if seq.int == 1
        pm.pre.all.hat = pm.pre.all.corner{:}';
    elseif err.indc.loop == 2
        pm.pre.all.hat = pm.pre.all.hat;
    elseif err.indc.loop == 1
        pm.pre.all.hat = pm.pre.all.hhat;
    end
    
    pm.pre.block.hat = GSAGridtoBlock(pm.pre.all.hat');
    
    pm.pre.all.hhat = pm.pre.all.hat;
    pm.pre.mid.hhat = GSAGridMidPoint(pm.pre.all.hhat);
    pm.pre.all.hhat = [pm.pre.all.corner{:}' pm.pre.mid.hhat];
    pm.pre.block.hhat = GSAGridtoBlock(pm.pre.all.hhat');
    % genarate impulses.
    imp.store.M = MTX_M.mtx*phi.fre.all;
    imp.store.C = MTX_C.mtx*phi.fre.all;
    imp.store.K1120S0 = MTX_K.I1120S0*phi.fre.all;
    imp.store.K1021S0 = MTX_K.I1021S0*phi.fre.all;
    imp.store.K1020S1 = MTX_K.I1020S1*phi.fre.all;
    imp.loc.init = 1;
    imp.loc.step = 2;
    pm.pre.val.block = 10.^pm.pre.all.hat';
    % pre-computation from force.
    resp.store.fce = zeros(no.pre*no.dof, no.t_step);
    for i_fce = 1:no.pre
        MTX_K.resp.fce = ...
            MTX_K.I1120S0*pm.pre.val.block(i_fce, 1)+...
            MTX_K.I1021S0*pm.pre.val.block(i_fce, 2)+MTX_K.I1020S1*pm.fix.I3;
        [~, ~, ~, resp.val.fce, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.resp.fce, ...
            fce.val, NMcoef, time.step, time.max, ...
            Dis.inpt, Vel.inpt);
        resp.store.fce((i_fce-1)*no.dof+1:i_fce*no.dof, :) = ...
            resp.store.fce((i_fce-1)*no.dof+1:i_fce*no.dof, :)+resp.val.fce;
    end
    resp.coef.fce = LagInterpolationCoeff(pm.pre.val.block, resp.store.fce);
    
    %===========================================================================
    % 1. pre-computation from mass, damping, stiffness1, stiffness2, stiffnessS.
    
    resp.coef.init.glob.M = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.step.glob.M = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.init.glob.C = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.step.glob.C = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.init.glob.K1120S0 = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.step.glob.K1120S0 = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.init.glob.K1021S0 = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.step.glob.K1021S0 = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.init.glob.K1020S1 = zeros(no.pre*no.rb*no.dof, no.t_step);
    resp.coef.step.glob.K1020S1 = zeros(no.pre*no.rb*no.dof, no.t_step);
    for i_m_rb = 1:no.rb
        %
        [resp.coef.init.local.M, resp.coef.step.local.M] = GSAPreComputeCoefStore...
            (i_m_rb, no.dof, no.t_step, no.pre, imp.store.M, imp.loc.init, imp.loc.step, ...
            pm.pre.val.block, pm.fix.I3, phi.ident, MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        resp.coef.init.glob.M((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.init.glob.M((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.init.local.M;
        resp.coef.step.glob.M((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.step.glob.M((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.step.local.M;
        %
        [resp.coef.init.local.C, resp.coef.step.local.C] = GSAPreComputeCoefStore...
            (i_m_rb, no.dof, no.t_step, no.pre, imp.store.C, imp.loc.init, imp.loc.step, ...
            pm.pre.val.block, pm.fix.I3, phi.ident, MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        resp.coef.init.glob.C((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.init.glob.C((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.init.local.C;
        resp.coef.step.glob.C((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.step.glob.C((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.step.local.C;
        %
        [resp.coef.init.local.K1120S0, resp.coef.step.local.K1120S0] = GSAPreComputeCoefStore...
            (i_m_rb, no.dof, no.t_step, no.pre, imp.store.K1120S0, imp.loc.init, imp.loc.step, ...
            pm.pre.val.block, pm.fix.I3, phi.ident, MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        resp.coef.init.glob.K1120S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.init.glob.K1120S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.init.local.K1120S0;
        resp.coef.step.glob.K1120S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.step.glob.K1120S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.step.local.K1120S0;
        %
        [resp.coef.init.local.K1021S0, resp.coef.step.local.K1021S0] = GSAPreComputeCoefStore...
            (i_m_rb, no.dof, no.t_step, no.pre, imp.store.K1021S0, imp.loc.init, imp.loc.step, ...
            pm.pre.val.block, pm.fix.I3, phi.ident, MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        resp.coef.init.glob.K1021S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.init.glob.K1021S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.init.local.K1021S0;
        resp.coef.step.glob.K1021S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.step.glob.K1021S0((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.step.local.K1021S0;
        %
        [resp.coef.init.local.K1020S1, resp.coef.step.local.K1020S1] = GSAPreComputeCoefStore...
            (i_m_rb, no.dof, no.t_step, no.pre, imp.store.K1020S1, imp.loc.init, imp.loc.step, ...
            pm.pre.val.block, pm.fix.I3, phi.ident, MTX_M.mtx, MTX_C.mtx, ...
            MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
            NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
        resp.coef.init.glob.K1020S1((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.init.glob.K1020S1((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.init.local.K1020S1;
        resp.coef.step.glob.K1020S1((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :) = ...
            resp.coef.step.glob.K1020S1((i_m_rb-1)*no.pre*no.dof+1:i_m_rb*no.pre*no.dof, :)+...
            resp.coef.step.local.K1020S1;
    end
    
    %% ONLINE
    err.store.val = zeros(domain.length.I1, domain.length.I2);
    err.log_store.val = zeros(domain.length.I1, domain.length.I2);
    tic
    % define quantity of interest with a rectangular frame.
    qoi.l = -1;
    qoi.r = 91;
    qoi.u = 21;
    qoi.d = -0.5;
    [qoi.seq, no.qoi.node, qoi.dof, no.qoi.dof] = GSAQoI_Info(node, qoi.l, qoi.r, qoi.u, qoi.d);
    disp(qoi.seq)
    % define a time window. min t.l = 1, max t.r = no.t_step.
    qoi.t.l = 3/time.step;
    qoi.t.r = 5/time.step;
    no.qoi.t_step = length(qoi.t.l:qoi.t.r);
    
    for i_iter = 1:size(pm.space.comb, 1)
        
        pm.loop.I1 = pm.space.comb(i_iter, 3);
        pm.loop.I2 = pm.space.comb(i_iter, 4);
        % interpolate response from force.
        [resp.itpl.fce] = LagInterpolationOtptSingle...
            (resp.coef.fce, pm.loop.I1, pm.loop.I2, no.pre);
        resp.qoi.fce = resp.itpl.fce(qoi.dof, 1:qoi.t.r);
        % compute alpha and ddot alpha for each PP.
        MTX_K.RE.loop = MTX_K.RE.I1120S0*pm.space.comb(i_iter, 3)+...
            MTX_K.RE.I1021S0*pm.space.comb(i_iter, 4)+...
            MTX_K.RE.I1020S1*pm.fix.I3;
        MTX_K.iter.loop = MTX_K.I1120S0*pm.space.comb(i_iter, 3)+...
            MTX_K.I1021S0*pm.space.comb(i_iter, 4)+...
            MTX_K.I1020S1*pm.fix.I3;
        [Dis.RE.iter.loop, Vel.RE.otpt.iter.loop, Acc.RE.otpt.iter.loop, ...
            ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.loop, ...
            fce.RE.iter.loop, NMcoef, time.step, time.max, ...
            Dis.RE.inpt, Vel.RE.inpt);
        for i_block = 1:numel(pm.pre.block.hat)
            indc.poly = inpolygon(pm.loop.I1, pm.loop.I2, ...
                10.^pm.pre.block.hat{i_block}(:, 1), 10.^pm.pre.block.hat{i_block}(:, 2));
            if indc.poly == 1
                pm.pre.val.block = 10.^pm.pre.block.hat{i_block};
                
            end
        end
        %===========================================================================
        % 2. interpolate response from mass, damping, stiffness
        % coefficient for each RB.
        resp.otpt.init.glob.M = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.step.glob.M = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.init.glob.C = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.step.glob.C = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.init.glob.K1120S0 = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.step.glob.K1120S0 = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.init.glob.K1021S0 = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.step.glob.K1021S0 = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.init.glob.K1020S1 = zeros(no.rb*no.qoi.dof, qoi.t.r);
        resp.otpt.step.glob.K1020S1 = zeros(no.rb*no.qoi.dof, qoi.t.r);
        for i_itpl = 1:no.rb
            %
            % size = no.qoi.dof, no.qoi.t_step.
            [resp.otpt.init.local.M, resp.otpt.step.local.M] = GSAInterpolateRespFromCoef...
                (i_itpl, no.pre, no.dof, pm.loop.I1, pm.loop.I2, ...
                resp.coef.init.glob.M, resp.coef.step.glob.M, ...
                qoi.dof, no.qoi.dof, qoi.t.r);
            % size = (no.rb*no.qoi.dof).
            resp.otpt.init.glob.M((i_itpl-1)*no.qoi.dof+1:i_itpl*no.qoi.dof, :) = ...
                resp.otpt.init.glob.M((i_itpl-1)*no.qoi.dof+1:i_itpl*no.qoi.dof, :)+...
                resp.otpt.init.local.M;
            resp.otpt.step.glob.M((i_itpl-1)*no.qoi.dof+1:i_itpl*no.qoi.dof, :) = ...
                resp.otpt.step.glob.M((i_itpl-1)*no.qoi.dof+1:i_itpl*no.qoi.dof, :)+...
                resp.otpt.step.local.M;
            
            
        end
        keyboard
        %%{
        % 3. sum over time and rb for QoI only.
        resp.qoi.asemb.M = zeros(no.qoi.dof, qoi.t.r);
        resp.qoi.asemb.C = zeros(no.qoi.dof, qoi.t.r);
        resp.qoi.asemb.K1120S0 = zeros(no.qoi.dof, qoi.t.r);
        resp.qoi.asemb.K1021S0 = zeros(no.qoi.dof, qoi.t.r);
        resp.qoi.asemb.K1020S1 = zeros(no.qoi.dof, qoi.t.r);
        
        for i_sum = 1:qoi.t.r
            for i_rb = 1:no.rb
                if i_sum == 1
                    resp.qoi.local.M = resp.otpt.init.glob.M...
                        ((i_rb-1)*no.qoi.dof+1:i_rb*no.qoi.dof, 1:qoi.t.r);
                    resp.qoi.asemb.M = resp.qoi.asemb.M+...
                        resp.qoi.local.M*Acc.RE.otpt.iter.loop(i_rb, 1);
                    
                    
                else
                    resp.qoi.local.M = resp.otpt.step.glob.M...
                        ((i_rb-1)*no.qoi.dof+1:i_rb*no.qoi.dof, 1:qoi.t.r);
                    resp.zeros = zeros(no.qoi.dof, i_sum-2);
                    resp.nonzeros = ...
                        resp.qoi.local.M(:, 1:(qoi.t.r-i_sum+2));
                    resp.imp.M = [resp.zeros resp.nonzeros];
                    resp.qoi.asemb.M = resp.qoi.asemb.M+...
                        resp.imp.M*Acc.RE.otpt.iter.loop(i_rb, i_sum);
                    
                end
            end
        end
        
        
        %===========================================================================
        resp.final = resp.qoi.fce-resp.qoi.asemb.M-resp.qoi.asemb.C-...
            resp.qoi.asemb.K1120S0*pm.loop.I1-...
            resp.qoi.asemb.K1021S0*pm.loop.I2-...
            resp.qoi.asemb.K1020S1*pm.fix.I3;
        err.store.val(i_iter) = err.store.val(i_iter)+...
            norm(resp.final, 'fro')/norm(Dis.trial.exact, 'fro');
        err.log_store.val(i_iter) = err.log_store.val(i_iter)+...
            log10(norm(resp.final, 'fro')/norm(Dis.trial.exact, 'fro'));
        disp(i_iter)
        %}
        toc
    end
    keyboard
    [err.max.val, err.loc.idx.max]=max(err.store.val(:));
    err.max.store=[err.max.store; err.max.val];
    pm.iter.row=pm.space.comb(err.loc.idx.max, :);
    err.loc.val.max=pm.iter.row(:, 1:2);
    err.loc.store=[err.loc.store; err.loc.val.max];
    %%
    %% plot
    if turnon == 1
        i_cnt=i_cnt+1;
        draw.row = 2;
        draw.col = 3;
        figure(1)
        titl.err_itpl=sprintf...
            ('Error response surface from interpolation, initial point = [%d %d]', ...
            pm.trial.val(1), pm.trial.val(2));
        suptitle(titl.err_itpl)
        subplot(draw.row, draw.col, i_cnt)
        surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
            linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.val');
        xlabel('inclusion 1', 'FontSize', 10)
        ylabel('inclusion 2', 'FontSize', 10)
        zlabel('error', 'FontSize', 10)
        set(gca,'fontsize',10)
        axis([1 2 1 2])
        axi.lim = [0, 0.025];
        %     zlim(axi.lim)
        axis square
        view([-60 30])
        set(legend,'FontSize',8);
        %%
        figure(2)
        titl.log_err_itpl=sprintf...
            ('Log error response surface from interpolation, initial point = [%d %d]', ...
            pm.trial.val(1), pm.trial.val(2));
        suptitle(titl.log_err_itpl)
        subplot(draw.row, draw.col, i_cnt)
        surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
            linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log_store.val');
        xlabel('inclusion 1', 'FontSize', 10)
        ylabel('inclusion 2', 'FontSize', 10)
        zlabel('log error', 'FontSize', 10)
        set(gca,'fontsize',10)
        axis([1 2 1 2])
        axi.log_lim = [-5, -1.5];
        %     zlim(axi.log_lim)
        axis square
        view([-60 30])
        set(legend,'FontSize',8);
        disp(err.max.val)
        disp(err.loc.val.max)
        
        if i_cnt>=6
            disp('iterations reach maximum plot number')
            break
        end
    end
    %% compute approximation at max error point.
    MTX_K.RE.all.appr = MTX_K.RE.I1120S0*pm.space.comb(err.loc.idx.max, 3)+...
        MTX_K.RE.I1021S0*pm.space.comb(err.loc.idx.max, 4)+...
        MTX_K.RE.I1020S1*pm.fix.I3;
    [~, ~, ~, Dis.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_K.RE.all.appr, ...
        fce.fre.RE.iter.loop, NMcoef, time.step, time.max, ...
        Dis.RE.inpt.iter.loop, Vel.RE.inpt.iter.loop);
    keyboard
end