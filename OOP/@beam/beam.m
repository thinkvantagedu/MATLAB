classdef beam < handle
    
    properties
        err
        countGreedy
        refinement
    end
    
    properties (SetAccess = protected, GetAccess = public)
        pmExpo
        resp
        indicator
        asemb
        str
        INPname
        node
        elem
        domLeng
        domBond
        pmComb
        pmVal
        pmLoc
        pmGrid
        time
        phi
        coef
        draw
        imp
        qoi
        mas
        dam
        sti
        acc
        vel
        dis
        no
    end
    
    properties (Dependent, Hidden)
        
        damMtx
        disInpt
        velInpt
        phiInit
        
    end
    
    methods
        
        function obj = beam(masFile, damFile, stiFile, ...
                locStart, locEnd, INPname, domLengi, domLengs, domBondi, ...
                domMid, trial, noIncl, tMax, tStep, ...
                mid1, mid2, errLowBond, errMaxValInit, errRbCtrl, ...
                errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
                drawRow, drawCol)
            
            obj.mas.file = masFile;
            obj.dam.file = damFile;
            obj.sti.file = stiFile;
            
            obj.str.locStart = locStart;
            obj.str.locEnd = locEnd;
            obj.INPname = INPname;
            
            obj.domBond.i = domBondi;
            obj.domLeng.i = domLengi;
            obj.domLeng.s = domLengs;
            
            obj.pmVal.s.fix = 1000;
            obj.pmVal.comb.trial = trial;
            
            obj.no.inc = noIncl;
            obj.no.phy = noIncl + 2;
            obj.no.t_step = length((0:tStep:tMax));
            obj.no.Greedy = drawRow * drawCol;
            
            obj.time.step = tStep;
            obj.time.max = tMax;
            obj.phi.ident = [];
            obj.pmExpo.mid1 = mid1;
            obj.pmExpo.mid2 = mid2;
            obj.pmExpo.mid = domMid;
            
            obj.err.lowBond = errLowBond;
            obj.err.max.val.slct = errMaxValInit;
            obj.err.rbCtrl = errRbCtrl;
            obj.err.rbCtrlThres = errRbCtrlThres;
            obj.err.rbCtrlTrialNo = errRbCtrlTNo;
            
            obj.countGreedy = cntInit;
            obj.refinement.thres = refiThres;
            
        end
        %%
        function obj = get.damMtx(obj) % method for dependent properties
            
            obj.dam.mtx = sparse(obj.no.dof, obj.no.dof);
            
        end
        
        function obj = get.disInpt(obj) % method for dependent properties
            
            obj.dis.inpt = sparse(obj.no.dof, 1);
            
        end
        
        function obj = get.velInpt(obj) % method for dependent properties
            
            obj.vel.inpt = sparse(obj.no.dof, 1);
            
        end
        %%
        function [obj] = readMTX2DOF(obj, ndofPerNode)
            % works for both 2d and 3d.
            %============== Import Mass Matrix ==============%
            
            ASM = dlmread(obj.mas.file);
            Node_n = max(ASM(:,1));    %or max(ASM(:,3))
            ndof = Node_n * ndofPerNode;
            %
            for ii = 1:size(ASM,1)
                indI(ii) = ndofPerNode * (ASM(ii,1)-1) + ASM(ii,2);
                indJ(ii) = ndofPerNode * (ASM(ii,3)-1) + ASM(ii,4);
            end
            
            M = sparse(indI, indJ, ASM(:, 5), ndof, ndof);
            
            obj.mas.mtx = M' + M;
            
            for i_tran = 1:length(M)
                obj.mas.mtx(i_tran, i_tran) = ...
                    obj.mas.mtx(i_tran, i_tran) / 2;
            end
            
            obj.no.dof = length(obj.mas.mtx);
        end
        %%
        function [obj] = readMTX2DOFBCMod(obj, ndofPerNode)
            % works for both 2d and 3d.
            %========= Import Stiffness Matrix and modify with BC=========%
            n = length(obj.sti.file);
            
            obj.sti.mtxCell = cell(n, 1);
            for in = 1:n
                if isnan(obj.sti.file{in}) == 0
                    
                    ASM = dlmread(obj.sti.file{in});
                    indI = zeros(length(ASM), 1);
                    indJ = zeros(length(ASM), 1);
                    Node_n = max(ASM(:, 1));    %or max(ASM(:,3))
                    ndof = Node_n*ndofPerNode;
                    
                    for ii=1:size(ASM,1)
                        indI(ii) = ndofPerNode*(ASM(ii,1)-1) + ASM(ii,2);
                        indJ(ii) = ndofPerNode*(ASM(ii,3)-1) + ASM(ii,4);
                    end
                    M = sparse(indI,indJ,ASM(:,5),ndof,ndof);
                    globalMBC = M' + M;
                    
                    for i_tran=1:length(M)
                        globalMBC(i_tran,i_tran)=globalMBC(i_tran,i_tran)/2;
                    end
                    
                    for i = 1:obj.no.consEnd
                        
                        diagindx = (obj.cons.dof{i} - 1) * (ndof + 1) + 1;
                        globalMBC(obj.cons.dof{i}, :) = 0;
                        globalMBC(:, obj.cons.dof{i}) = 0;
                        globalMBC(diagindx) = 1;
                        
                    end
                    
                    obj.sti.mtxCell{in} = globalMBC;
                end
                
            end
            
        end
        %%
        function obj = readINPgeoMultiInc(obj)
            % read INP file, extract node and element informations,
            % read random number of inclusions.
            % outputs are cells.
            lineNode = [];
            lineElem = [];
            lineInc = [];
            nInc = obj.no.inc;
            
            % read INP file line by line
            fid = fopen(obj.INPname);
            tline = fgetl(fid);
            lineNo = 1;
            
            while ischar(tline)
                lineNo = lineNo + 1;
                tline = fgetl(fid);
                celltext{lineNo} = tline;
                
                if strncmpi(tline, '*Node', 5) == 1 || ...
                        strncmpi(tline, '*Element', 8) == 1
                    lineNode = [lineNode; lineNo];
                end
                
                if strncmpi(tline, '*Element', 8) == 1 || ...
                        strncmpi(tline, '*Nset', 5) == 1
                    lineElem = [lineElem; lineNo];
                    
                end
                for i = 1:nInc
                    
                    strInci = num2str(i);
                    incNline = strcat('*Nset, nset=Set-I', strInci);
                    incEline = strcat('*Elset, elset=Set-I', strInci);
                    
                    if strncmpi(tline, incNline, length(incNline)) == 1 || ...
                            strncmpi(tline, incEline, length(incEline)) == 1
                        lineInc = [lineInc; lineNo];
                        
                    end
                    
                end
                
            end
            % element may contains multiple locations, but only takes the
            % first 2 locations.
            lineElem = lineElem(1:2);
            lineInc = reshape(lineInc, [2, length(lineInc) / 2]);
            strtext = char(celltext(2:(length(celltext) - 1)));
            
            % node
            txtNode = strtext((lineNode(1) : lineNode(2) - 2), :);
            trimNode = strtrim(txtNode);%delete spaces in heads and tails
            obj.node.all = str2num(trimNode);
            obj.no.node.all = size(obj.node.all, 1);
            
            % element
            txtElem = strtext((lineElem(1):lineElem(2) - 2), :);
            trimElem = strtrim(txtElem);
            obj.elem.all = str2num(trimElem);
            obj.no.elem = size(obj.elem.all, 1);
            
            % inclusions
            nodeIncCell = cell(obj.no.inc, 1);
            nNodeInc = zeros(obj.no.inc, 1);
            incConn = cell(obj.no.inc, 1);
            trimIncCell = {};
            
            for i = 1:obj.no.inc
                % nodal info of inclusions
                
                txtInc = strtext((lineInc(1, i):lineInc(2, i) - 2), :);
                trimInc = strtrim(txtInc);
                for j = 1:size(trimInc, 1)
                    
                    trimIncCell(j) = {str2num(trimInc(j, :))};
                    
                end
                trimIncCell = cellfun(@(v) v(:), trimIncCell, 'Uni', 0);
                nodeInc = cell2mat(trimIncCell(:));
                nodeInc = obj.node.all(nodeInc, :);
                nInc = size(nodeInc, 1);
                nodeIncCell(i) = {nodeInc};
                nNodeInc(i) = nInc;
                % connectivities of inclusions
                connSwitch = zeros(obj.no.node.all, 1);
                connSwitch(nodeIncCell{i}(:, 1)) = 1;
                elemInc = [];
                for k = 1:obj.no.elem
                    
                    ind = (connSwitch(obj.elem.all(k, 2:4)))';
                    if isequal(ind, ones(1, 3)) == 1
                        elemInc = [elemInc; obj.elem.all(k, 1)];
                    end
                    
                end
                incConn(i) = {elemInc};
                
            end
            obj.elem.inc = incConn;
            obj.node.inc = nodeIncCell;
            obj.no.node.inc = size(cell2mat(obj.node.inc), 1);
            obj.no.node.mtx = obj.no.dof - obj.no.node.inc;
            obj.no.incNode = cellfun(@(v) size(v, 1), obj.node.inc, 'un', 0);
            obj.no.incNode = (cell2mat(obj.no.incNode))';
            
        end
        %%
        function obj = generatePmSpaceMultiDim(obj)
            % generate n-D parameter space, n = number of inclusions.
            
            for i = 1:obj.no.inc
                
                pmValIspace(i) = {logspace(obj.domBond.i{i}(1), ...
                    obj.domBond.i{i}(2), obj.domLeng.i(i))};
                pmValIspace{i} = ...
                    [(1:length(pmValIspace{i})); pmValIspace{i}];
                
            end
            
            obj.pmVal.comb.space = combvec(pmValIspace{:});
            obj.pmVal.comb.space = obj.pmVal.comb.space';
            
            if obj.no.inc > 1
                obj.pmVal.comb.space(:, [2, 3]) = obj.pmVal.comb.space...
                    (:, [3, 2]);
            end
            pmValIspace = cellfun(@(v) v', pmValIspace, 'un', 0);
            
            obj.pmVal.i.space = pmValIspace;
            
            obj.pmExpo.i = cellfun(@(v) log10(v(:, 2)), obj.pmVal.i.space, ...
                'un', 0);
            
            obj.no.dom.discretisation = cellfun(@(v) size(v, 1), ...
                pmValIspace, 'un', 0);
            
            obj.no.dom.discretisation = cell2mat(obj.no.dom.discretisation);
            
        end
        %%
        function obj = rbEnrichment(obj, nEnrich, reductionRatio, ...
                singularSwitch, ratioSwitch)
            % this method add a new basis vector to current basis. New basis
            % vector = SVD(current exact -  previous approximation). GramSchmidt
            % is applied to the basis to ensure orthogonality.
            
            % new basis from error (phi * phi' * response).
            rbEnrich = obj.dis.rbEnrich - ...
                obj.phi.val * obj.phi.val' * obj.dis.rbEnrich;
            
            [u, s, ~] = svd(rbEnrich);
            
            if singularSwitch == 0 && ratioSwitch == 0
                phiEnrich = u(:, 1:nEnrich);
                obj.phi.val = [obj.phi.val phiEnrich];
            elseif singularSwitch == 1 && ratioSwitch == 0
                nEnrich = 0;
                singular = diag(s);
                singularSum = sqrt(sum(singular .^ 2));
                
                for i = 1:length(singular)
                    
                    ss = sqrt(sum((singular(1:i)) .^ 2));
                    nEnrich = nEnrich + 1;
                    singularRatio = ss / singularSum;
                    
                    if singularRatio >= reductionRatio
                        break
                    end
                    
                end
                obj.no.nEnrich = [obj.no.nEnrich; nEnrich];
                phiEnrich = u(:, 1:nEnrich);
                obj.phi.val = [obj.phi.val phiEnrich];
            elseif singularSwitch == 0 && ratioSwitch == 1
                emax = obj.err.max.val.slct;
                egoal = emax * (1 - reductionRatio);
                nEnrich = 0;
                % exact solution at previous maximum error point.
                m = obj.mas.mtx;
                c = obj.dam.mtx;
                k = obj.sti.mtxCell{1} * obj.pmVal.max(1) + ...
                    obj.sti.mtxCell{2} * obj.pmVal.max(2) + ...
                    obj.sti.mtxCell{3} * obj.pmVal.s.fix;
                f = obj.fce.val;
                vInpt = zeros(obj.no.dof, 1);
                uInpt = zeros(obj.no.dof, 1);
                obj.NewmarkBetaMethod(m, c, k, f, vInpt, uInpt);
                uOtpt = obj.dis.val;
                for i = 1:obj.no.dof
                    % reduced solution
                    phiTmp = obj.phi.val;
                    phiEnrich = u(:, 1:i);
                    nEnrich = nEnrich + 1;
                    phiTmp = [phiTmp phiEnrich];
                    nphi = size(phiTmp, 2);
                    obj.GramSchmidt(phiTmp);
                    phiTmp = obj.phi.otpt;
                    mr = phiTmp' * obj.mas.mtx * phiTmp;
                    cr = phiTmp' * obj.dam.mtx * phiTmp;
                    krc = cellfun(@(v) phiTmp' * v * phiTmp, ...
                        obj.sti.mtxCell, 'un', 0);
                    kr = krc{1} * obj.pmVal.max(1) + ...
                        krc{2} * obj.pmVal.max(2) + ...
                        krc{3} * obj.pmVal.s.fix;
                    fr = phiTmp' * obj.fce.val;
                    vrInpt = zeros(nphi, 1);
                    urInpt = zeros(nphi, 1);
                    obj.NewmarkBetaMethod(mr, cr, kr, fr, vrInpt, urInpt);
                    urOtpt = phiTmp * obj.dis.val;
                    
                    relErr = norm(urOtpt - uOtpt, 'fro') / ...
                        norm(obj.dis.trial, 'fro');
                    if relErr <= egoal
                        break
                    end
                    
                end
                obj.phi.val = phiTmp;
                obj.no.nEnrich = [obj.no.nEnrich; nEnrich];
            end
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.phiAdd = nEnrich;
            
            obj.indicator.refinement = 0;
            obj.indicator.enrichment = 1;
            obj.countGreedy = obj.countGreedy + 1;
            
            obj.vel.re.inpt = sparse(obj.no.rb, 1);
            obj.dis.re.inpt = sparse(obj.no.rb, 1);
            
        end
        %%
        function obj = rbSingularInitial(obj, reductionRatio)
            % this method iteratively uses singular value to determine
            % how many basis vectors are needed in reduced basis.
            obj.no.nEnrich = 0;
            [u, s, ~] = svd(obj.dis.trial, 0);
            s = diag(s);
            ssum = sqrt(sum(s .^ 2));
            for i = 1:length(s)
                
                singularSum = sqrt(sum((s(1:i)) .^ 2));
                obj.no.nEnrich = obj.no.nEnrich + 1;
                singularRatio = singularSum / ssum;
                
                if singularRatio > reductionRatio
                    break
                end
                
            end
            obj.phi.val = u(:, 1:obj.no.nEnrich);
            obj.no.rb = size(obj.phi.val, 2);
            obj.dis.re.inpt = sparse(obj.no.rb, 1);
            obj.vel.re.inpt = sparse(obj.no.rb, 1);
            
        end
        %%
        function obj = rbReVarInitial(obj, reductionRatio)
            % this method iteratively uses reduced variables to determine
            % how many vectors are needed in reduced basis (use phi * alpha).
            obj.no.nEnrich = 0;
            [rb, ~, ~] = svd(obj.dis.trial, 0);
            
            for i = 1:obj.no.dof
                
                rbTmp = rb(:, 1:i);
                obj.no.nEnrich = i;
                mr = rbTmp' * obj.mas.mtx * rbTmp;
                cr = rbTmp' * obj.dam.mtx * rbTmp;
                kr = rbTmp' * obj.sti.trial * rbTmp;
                fr = rbTmp' * obj.fce.val;
                vr0 = zeros(i, 1);
                ur0 = zeros(i, 1);
                obj.NewmarkBetaMethod(mr, cr, kr, fr, vr0, ur0);
                reVarDis = obj.dis.val;
                ur = rbTmp * reVarDis;
                relErr = norm(ur - obj.dis.trial, 'fro') / ...
                    norm(obj.dis.trial, 'fro');
                
                if relErr <= 1 - reductionRatio
                    break
                end
                
            end
            obj.phi.val = rbTmp;
            obj.no.rb = size(obj.phi.val, 2);
            obj.dis.re.inpt = sparse(obj.no.rb, 1);
            obj.vel.re.inpt = sparse(obj.no.rb, 1);
            
        end
        %%
        function obj = rbCtrlInitial(obj, rbCtrlThres)
            obj.no.nEnrich = 0;
            % Error controlled scheme for initial reduced basis from trial
            % point.
            while obj.err.rbCtrl > rbCtrlThres
                
                [obj] = SVDoop(obj, 'rbCtrlInitial');
                
                obj.mas.re.mtx = obj.phi.val' * obj.mas.mtx * obj.phi.val;
                obj.sti.re.mtx = obj.phi.val' * obj.sti.trial * obj.phi.val;
                obj.dam.re.mtx = ...
                    sparse(length(obj.sti.re.mtx), length(obj.sti.re.mtx));
                
                obj.dis.re.inpt = sparse(obj.err.rbCtrlTrialNo, 1);
                obj.vel.re.inpt = sparse(obj.err.rbCtrlTrialNo, 1);
                
                obj.sti.reduce = obj.sti.re.mtx;
                obj.mas.reduce = obj.mas.re.mtx;
                obj.dam.reduce = obj.dam.re.mtx;
                obj.fce.pass = obj.fce.val;
                
                obj = NewmarkBetaReducedMethodOOP(obj, 'rewRb');
                obj.dis.errCtrl = obj.dis.full;
                
                obj.err.rbCtrl = (norm(obj.dis.trial - ...
                    obj.dis.errCtrl, 'fro')) / norm(obj.dis.trial, 'fro');
                
                obj.err.rbCtrlTrialNo = obj.err.rbCtrlTrialNo + 1;
                
            end
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.nEnrich = obj.no.rb;
            
        end
        %%
        function obj = rbInitial(obj, nInit)
            % initialize reduced basis, take n SVD vectors from initial
            % solution, nPhi is chosen by user.
            snap = obj.dis.trial;
            [u, ~, ~] = svd(snap, 0);
            u = u(:, 1:nInit);
            obj.phi.val = u;
            
            obj.dis.re.inpt = sparse(nInit, 1);
            obj.vel.re.inpt = sparse(nInit, 1);
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.phiAdd = nInit;
        end
        %%
        function obj = exactSolution(obj, type, qoiSwitchTime, qoiSwitchSpace)
            % this method computes exact solution at maximum error points.
            stiIcell = obj.sti.mtxCell(1:end - 1);
            switch type
                case 'initial'
                    pmIcell = mat2cell(obj.pmVal.i.trial', ...
                        ones(obj.no.inc, 1), 1);
                case 'Greedy'
                    pmIcell = mat2cell(obj.pmVal.max', ones(obj.no.inc, 1), 1);
            end
            stiIcell = cellfun(@(u, v) u * v, stiIcell, ...
                pmIcell, 'un', 0);
            stiS = obj.sti.mtxCell{end} * obj.pmVal.s.fix;
            stiImtx = cell2mat(stiIcell);
            stiI = sparse(obj.no.dof, obj.no.dof);
            for i = 1:obj.no.inc
                
                stiI = stiI + stiImtx((i - 1) * obj.no.dof + 1 : ...
                    i * obj.no.dof, :);
                
            end
            obj.sti.sum = stiI + stiS;
            % compute trial solution
            obj.sti.full = obj.sti.sum;
            obj.fce.pass = obj.fce.val;
            obj.NewmarkBetaReducedMethodOOP('full');
            
            switch type
                case 'initial'
                    obj.dis.trial = obj.dis.full;
                    
                    if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                        obj.dis.qoi.trial = obj.dis.trial;
                        
                    elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                        obj.dis.qoi.trial = obj.dis.trial(:, obj.qoi.t);
                        
                    elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                        obj.dis.qoi.trial = obj.dis.trial(obj.qoi.dof, :);
                        
                    elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                        obj.dis.qoi.trial = obj.dis.trial(obj.qoi.dof, ...
                            obj.qoi.t);
                        
                    end
                case 'Greedy'
                    obj.dis.rbEnrich = obj.dis.full;
            end
            
        end
        %%
        function obj = pmTrial(obj)
            % extract parameter information for trial point.
            pmValCombIdx = obj.pmVal.comb.space(:, 1:obj.no.inc);
            for i = 1:length(pmValCombIdx)
                pmCombComp = isequal(obj.pmVal.comb.trial, pmValCombIdx(i, :));
                if pmCombComp == 1
                    pmIdx = i;
                end
            end
            
            pmCombRow = obj.pmVal.comb.space(pmIdx, :);
            obj.pmVal.i.trial = pmCombRow(obj.no.inc + 1 : end);
            if obj.no.inc == 1
                obj.err.setZ.sInc = zeros(obj.domLeng.i, 1);
            else
                obj.err.setZ.mInc = zeros(obj.domLeng.i);
            end
        end
        
        %%
        function obj = trialSti(obj, pm1, pm2, pms)
            % affinely sum stiffness matrix for trial point.
            obj.sti.trial = obj.sti.mtxCell{1} * pm1 + ...
                obj.sti.mtxCell{2} * pm2 + obj.sti.mtxCell{3} * pms;
            
        end
        
        %%
        function obj = initHatPm(obj)
            % initialize exponential itpl parameter domain.
            pmIdx = (1:2 ^ obj.no.inc)';
            pmDom = cell(obj.no.inc, 1);
            if obj.no.inc == 1
                pmDom = {(obj.domBond.i{:})'};
            else
                [pmDom{1:obj.no.inc}] = ndgrid(obj.domBond.i{:});
            end
            pmCoord = cellfun(@(v) v(:), pmDom, 'un', 0);
            pmCoord = [pmCoord{:}];
            obj.pmExpo.hat = [pmIdx pmCoord];
            obj.no.pre.hat = size(obj.pmExpo.hat, 1);
            obj.pmExpo.temp.inpt = obj.pmExpo.hat;
            
            % from obj.pmExpo.hat to obj.pmExpo.block.hat.
            obj.gridtoBlockwithIndx;
            obj.pmExpo.block.hat = obj.pmExpo.temp.otpt;
            obj.no.block.hat = 1;
        end
        %%
        function obj = otherPrepare(obj, nSVD)
            
            obj.no.respSVD = nSVD;
            obj.indicator.refinement = 0;
            obj.indicator.enrichment = 1;
            obj.acc.rv.store = cell(prod(obj.no.incNode), 1);
            obj.vel.rv.store = cell(prod(obj.no.incNode), 1);
            obj.dis.rv.store = cell(prod(obj.no.incNode), 1);
            
        end
        %%
        function obj = errPrepareRemain(obj)
            obj.err.store.max.errwRb = [];
            obj.err.store.max.hhat = [];
            obj.err.store.max.hat = [];
            obj.err.store.max.diff = [];
            obj.err.store.loc.errwRb = [];
            obj.err.store.loc.hhat = [];
            obj.err.store.loc.hat = [];
            obj.err.store.loc.diff = [];
            obj.err.pre.hhat = cell(obj.no.pre.hhat, 3);
            obj.err.store.surf.hhat = zeros(obj.no.dom.discretisation);
            obj.err.store.surf.hat = zeros(obj.no.dom.discretisation);
        end
        %%
        function obj = errPrepareRemainOriginal(obj)
            
            obj.err.store.max = [];
            obj.err.store.loc = [];
            
        end
        %%
        function obj = errPrepareSetZero(obj)
            if obj.no.inc == 1
                obj.err.store.surf.errwRb = obj.err.setZ.sInc;
                obj.err.store.surf.diff = obj.err.setZ.sInc;
            else
                obj.err.store.surf.errwRb = obj.err.setZ.mInc;
                obj.err.store.surf.diff = obj.err.setZ.mInc;
            end
        end
        %%
        function obj = errPrepareSetZeroOriginal(obj)
            if obj.no.inc == 1
                obj.err.store.surf = obj.err.setZ.sInc;
            else
                obj.err.store.surf = obj.err.setZ.mInc;
            end
        end
        %%
        function obj = inpolyItplLag(obj, nblk, pmBlk, coef)
            
            for i = 1:nblk
                
                coefBlk = coef{i};
                if inpolygon(obj.pmExpo.iter{1}, obj.pmExpo.iter{2}, ...
                        pmBlk{i}(:, 2), pmBlk{i}(:, 3)) == 1
                    
                    nmtx = size(coefBlk, 1) / 4;
                    x = obj.pmVal.iter{1};
                    y = obj.pmVal.iter{2};
                    
                    obj.err.itpl.otpt = coefBlk(1:nmtx, :) * x * y + ...
                        coefBlk(2 * nmtx - nmtx + 1 : 2 * nmtx, :) * x + ...
                        coefBlk(3 * nmtx - nmtx + 1 : 3 * nmtx, :) * y + ...
                        coefBlk(4 * nmtx - nmtx + 1 : 4 * nmtx, :) * x ^ 0;
                    
                end
                
            end
            
        end
        %%
        function obj = preSelectErrtoItpl(obj)
            % this method selects the newly added elements of eTe.
            % There are 2 new parts:
            % 1. nt * nphy - 1 by (nt * nphy - 1) * (nr - 1)
            % (small, errSlctBlkS);
            % 2. nt * nphy by nt * nrb * nphy + 1 (Lagre, errSlctBlkL).
            % If Greedy iteration = 1, use obj.err.pre.hhat as the selection to
            % interpolate. size of origin eTe is nt * nrb * nphy + 1
            % by nt * nrb * nphy + 1.
            
            errPre = obj.err.pre.hhat;
            obj.err.pre.slct.hhat = cell(obj.no.pre.hhat, 2);
            obj.err.pre.unslct = cell(obj.no.pre.hhat, 1);
            
            if obj.countGreedy == 1
                obj.err.pre.slct.hhat = errPre;
            else
                nold = obj.no.t_step * obj.no.phy * (obj.no.rb - 1) + 1;
                for i = 1:obj.no.pre.hhat
                    obj.err.pre.slct.hhat{i, 1} = errPre{i, 1};
                    obj.err.pre.slct.hhat{i, 2} = errPre{i, 2}(:, nold + 1:end);
                    obj.err.pre.unslct{i} = errPre{i, 2}(:, 1:nold);
                end
                
            end
            obj.err.pre.slct.hat = obj.err.pre.slct.hhat(1:obj.no.pre.hat, :);
            
        end
        %%
        function obj = preSelectDistoItpl(obj, timeType)
            % this method only select NEWLY added DISPLACEMENTS to
            % interpolate. Number should be nphy_dis * nrb_add * 2 for
            % partTime, nphy_dis * nrb_add * nt for allTime.
            % Change sign for pm responses.
            pmSlcthhat =  obj.resp.store.pm.hhat(:, :, :, :);
            pmSlcthhat = cellfun(@(v) -v, pmSlcthhat, 'un', 0);
            
            switch timeType
                case 'allTime'
                    pmSlcthhat1 = reshape(pmSlcthhat, [obj.no.pre.hhat, ...
                        obj.no.phy * obj.no.t_step * obj.no.phInit]);
                    % add force related responses to pmSlct.
                    pmSlcthhatAll = [obj.resp.store.fce.hhat pmSlcthhat1];
                    obj.resp.pre.slct.hhat = cell(obj.no.pre.hhat, 2);
                    
                    for iPre = 1:obj.no.pre.hhat
                        
                        obj.resp.pre.slct.hhat(iPre, 1) = {iPre};
                        obj.resp.pre.slct.hhat(iPre, 2) = ...
                            {cell2mat(pmSlcthhatAll(iPre, :))};
                        
                    end
                    
            end
            
        end
        %%
        function obj = preSelectResptoItpl(obj, timeType)
            % this method selects the newly added responses (SVD vectors)
            % to interpolate. number should be nphy * nrb_add * 2. Reshape
            % the cell to matrix ready to be interpolated. Responses
            % regarding forces are inserted in the first location of the
            % interpolated matrix.
            % only select 1 newly added basis at the moment.
            pmSlcthhat = obj.resp.store.pm.hhat(:, :, :, end);
            
            % reshape 3rd index, then 2nd index. loop nphy, then loop nt
            switch timeType
                case 'allTime'
                    pmSlcthhat1 = reshape(pmSlcthhat, ...
                        [obj.no.pre.hhat, obj.no.phy * obj.no.t_step]);
                    % add force related responses to pmSlct.
                    pmSlcthhatAll = [obj.resp.store.fce.hhat pmSlcthhat1];
                    obj.resp.pre.slct.hhat = cell(obj.no.pre.hhat, 2);
                    for iPre = 1:obj.no.pre.hhat
                        
                        obj.resp.pre.slct.hhat(iPre, 1) = {iPre};
                        obj.resp.pre.slct.hhat(iPre, 2) = ...
                            {cell2mat(pmSlcthhatAll(iPre, :))};
                        
                    end
                    
                case 'partTime'
                    pmSlcthhat1 = ...
                        reshape(pmSlcthhat, ...
                        [obj.no.pre.hhat, obj.no.phy * 2]);
                    % add force related responses to pmSlct.
                    pmSlcthhatAll = [obj.resp.store.fce.hhat pmSlcthhat1];
                    
                    % now there is a cell matrix, row number = ni, col number =
                    % 1 + nphy * 2 * nrb_add.
                    % separate left and right singular vectors and store them
                    % in 2 matrices.
                    pmSlcthhatL = cellfun(@(v) v{1}, pmSlcthhatAll, 'un', 0);
                    pmSlcthhatR = cellfun(@(v) v{2}, pmSlcthhatAll, 'un', 0);
                    pmSlcthhatL = mat2cell(cell2mat(pmSlcthhatL), ...
                        obj.no.dof * ones(1, obj.no.pre.hhat));
                    pmSlcthhatR = mat2cell(cell2mat(pmSlcthhatR), ...
                        obj.no.t_step * ones(1, obj.no.pre.hhat));
                    
                    obj.resp.pre.slct.hhat.l = cell(obj.no.pre.hhat, 2);
                    obj.resp.pre.slct.hhat.r = cell(obj.no.pre.hhat, 2);
                    
                    for iPre = 1:obj.no.pre.hhat
                        
                        obj.resp.pre.slct.hhat.l(iPre, 1) = {iPre};
                        obj.resp.pre.slct.hhat.r(iPre, 1) = {iPre};
                        obj.resp.pre.slct.hhat.l(iPre, 2) = pmSlcthhatL(iPre);
                        obj.resp.pre.slct.hhat.r(iPre, 2) = pmSlcthhatR(iPre);
                        
                    end
            end
        end
        %%
        function obj = LagItpl2Dmtx(obj, gridx, gridy, gridz)
            % This function performs Lagrange interpolation with matrix inputs.
            % inptx, inpty are input x-y coordinate (the point to compute).
            % gridx, gridy are n by n matrices denotes x-y coordinates of
            % sample points (generated from meshgrid function). z are the
            % corresponding matrices of gridx, gridy, in a 2 by 2 cell
            % array. Notice gridx and gridy needs to be in clockwise or
            % anti-clockwise order, cannot be disordered.
            
            xstore = cell(1, 2);
            for i=1:size(gridx,1)
                % x vector must be a column vector for the lagrange function
                x = gridx(i,:)';
                % z vector must be a column vector for the lagrange function
                z = gridz(i,:)';
                
                p=[];
                % interpolate for every parameter value j and add it to p
                
                p = [p,lagrange(x,z,obj.pmVal.iter{1}, 'matrix')];
                
                % save curves in x direction
                xstore{i} = p;
                
            end
            
            y = gridy(:,1);
            
            % interpolate in y-direction
            for i=1:length(xstore{1})
                z = cell(2, 1);
                for l=1:length(y)
                    z(l) = xstore(l);
                end
                
                % interpolate for every parameter value j and add it to p
                obj.err.itpl.otpt = lagrange(y,z,obj.pmVal.iter{2}, 'matrix');
                
            end
            
        end
        %%
        function obj = respMultiplyPmRvSum(obj, timeType, iIter)
            % this method accepts the interpolation results and multiply
            % them with corresponding pm values and reduced variables.
            % After multiplication, all responses are summed and normed to
            % ba added to error response surfaces.
            
            % pm values for affine mass and damping matrices are 1.
            pmPass = cell2mat(obj.pmVal.iter);
            rvAcc = obj.acc.re.reVar;
            rvVel = obj.vel.re.reVar;
            rvDis = obj.dis.re.reVar;
            
            % the interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            resphhat =  obj.resp.itpl.hhat;
            resphat = obj.resp.itpl.hat;
            rvStore = zeros(obj.no.phy * obj.no.t_step + 1, obj.no.rb);
            switch timeType
                case 'allTime'
                    % repeat for nt times to fit length of pre-computed
                    % responses.
                    pmAll = repmat([1; 1; pmPass], ...
                        obj.no.t_step * obj.no.phInit, 1);
                    
                    for i = 1:obj.no.rb
                        
                        rvAccSiRow = rvAcc(i, :);
                        rvVelSiRow = rvVel(i, :);
                        rvDisSiRow = rvDis(i, :);
                        rvDisRepRow = repmat(rvDisSiRow, obj.no.inc, 1);
                        rvAllRow = [rvAccSiRow; rvVelSiRow; rvDisRepRow];
                        rvAllCol = rvAllRow(:);
                        
                        if i == 1
                            % initial iteration, need to consider force.
                            pmAll = [1; pmAll];
                            rvAllCol = [1; rvAllCol(:)];
                            rvStore(:, i) = rvStore(:, i) + rvAllCol;
                        else
                            % successive iterations, need to cancel force.
                            pmAll = [0; pmAll];
                            rvAllCol = [0; rvAllCol(:)];
                            rvStore(:, i) = rvStore(:, i) + rvAllCol;
                        end
                        
                    end
                    
                    
                    respPmRvhhat = sparse(size(resphhat, 1), size(resphhat, 2));
                    respPmRvhat = sparse(size(resphat, 1), size(resphat, 2));
                    
                    for i = 1:size(resphhat, 2)
                        respPmRvhhat(:, i) = respPmRvhhat(:, i) + ...
                            pmAll(i) * resphhat(:, i) * rvAllCol(i);
                        respPmRvhat(:, i) = respPmRvhat(:, i) + ...
                            pmAll(i) * resphat(:, i) * rvAllCol(i);
                    end
                    
                    respPmRvhhatSum = sum(respPmRvhhat, 2);
                    obj.resp.store.hhat{iIter} = ...
                        obj.resp.store.hhat{iIter} + respPmRvhhatSum;
                    respPmRvhatSum = sum(respPmRvhat, 2);
                    obj.resp.store.hat{iIter} = ...
                        obj.resp.store.hat{iIter} + respPmRvhatSum;
                    
                    
            end
            
        end
        %%
        function obj = resptoErrStore(obj)
            % this method takes stored responses and compute relative
            % error, store in a matrix to plot error response surfaces.
            resphhat = obj.resp.store.hhat;
            resphat = obj.resp.store.hat;
            errhhat = cellfun(@(v) norm(v, 'fro') / ...
                norm(obj.dis.trial, 'fro'), resphhat, 'un', 0);
            obj.err.store.surf.hhat = cell2mat(errhhat);
            errhat = cellfun(@(v) norm(v, 'fro') / ...
                norm(obj.dis.trial, 'fro'), resphat, 'un', 0);
            obj.err.store.surf.hat = cell2mat(errhat);
            
        end
        %%
        function obj = respStorePrepareRemain(obj, svdSwitch, timeType)
            obj.resp.store.fce.hhat = cell(obj.no.pre.hhat, 1);
            obj.resp.store.all = cell(obj.no.pre.hhat, 1);
            obj.resp.surfStore.hhat = cell([obj.no.incNode obj.no.Greedy]);
            obj.resp.store.tDiff = ...
                cell(obj.no.pre.hhat, obj.no.phy, 2, obj.no.rb);
            
            switch timeType
                case 'allTime'
                    obj.resp.store.pm.hhat = cell(obj.no.pre.hhat, ...
                        obj.no.phy, obj.no.t_step, obj.no.rb);
                case 'partTime'
                    obj.resp.store.pm.hhat = cell(obj.no.pre.hhat, ...
                        obj.no.phy, 2, obj.no.rb);
            end
            
            if svdSwitch == 1
                
                obj.resp.store.hhat = cellfun(@(v) ...
                    sparse(obj.no.dof * obj.no.t_step, 1), ...
                    obj.resp.store.hhat, 'un', 0);
                obj.resp.store.hat = cellfun(@(v) ...
                    sparse(obj.no.dof * obj.no.t_step, 1), ...
                    obj.resp.store.hat, 'un', 0);
                
            end
        end
        
        function obj = impPrepareRemain(obj)
            
            obj.imp.store.mtx = cell(obj.no.phy, 2, obj.no.rb);
            
        end
        %%
        function obj = impGenerate(obj)
            % first obtain responses from physical domains + mas, dam, sti
            % matrices + rb vectors + force for OFFLINE stage.
            % this method is irrelevant to interpolation.
            % only needs to be repeated when there is enrichment.
            
            % generate sparse impulse matrices, impulse is irrelevant to i,
            % only related to j and r. 2 impulses for each jr, due to
            % initial and successive are different.
            
            % this method suits allTime and partTime cause only 2 impulse
            % are computed, not nt impulses.
            % total number of impulses are nf * 2 * nrb.
            mtxAsemb = cell(obj.no.phy, 1);
            mtxAsemb(1) = {obj.mas.mtx};
            mtxAsemb(2) = {obj.dam.mtx};
            mtxAsemb(3:5) = obj.sti.mtxCell;
            obj.asemb.imp.cel = cell(obj.no.phy, 1);
            
            if obj.indicator.refinement == 0 && obj.indicator.enrichment == 1
                
                obj.asemb.imp.cel = cellfun(@(v) v * obj.phi.val, mtxAsemb, ...
                    'un', 0);
                obj.asemb.imp.apply = cell(2, 1);
                
                for i = 1:obj.no.phy
                    for j = 1:2
                        % only generate responses reagrding the newly added
                        % basis vectors.
                        for k = obj.no.rb - obj.no.phiAdd + 1:obj.no.rb
                            impMtx = sparse(obj.no.dof, obj.no.t_step);
                            impMtx(:, j) = impMtx(:, j) + ...
                                mtxAsemb{i} * obj.phi.val(:, k);
                            obj.imp.store.mtx{i, j, k} = impMtx;
                        end
                    end
                end
                
            end
        end
        %%
        function obj = respImpFce(obj, svdSwitch, qoiSwitchTime, qoiSwitchSpace)
            
            if obj.indicator.refinement == 0 && obj.indicator.enrichment == 1
                % if no refinement, only enrich, force related responses does
                % not change since it's not related to new basis vectors.
                for i_pre = 1:obj.no.pre.hhat
                    obj.sti.pre = ...
                        obj.sti.mtxCell{1} * obj.pmVal.hhat(i_pre, 2) + ...
                        obj.sti.mtxCell{2} * obj.pmVal.hhat(i_pre, 3) + ...
                        obj.sti.mtxCell{3} * obj.pmVal.s.fix;
                    obj.sti.full = obj.sti.pre;
                    obj.fce.pass = obj.fce.val;
                    obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                    if svdSwitch == 0
                        if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                            obj.resp.store.fce.hhat{i_pre} = obj.dis.full(:);
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                            tempdis = obj.dis.full(:, obj.qoi.t);
                            obj.resp.store.fce.hhat{i_pre} = tempdis(:);
                            
                        elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                            tempdis = obj.dis.full(obj.qoi.dof, :);
                            obj.resp.store.fce.hhat{i_pre} = tempdis(:);
                            
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                            tempdis = obj.dis.full(obj.qoi.dof, obj.qoi.t);
                            obj.resp.store.fce.hhat{i_pre} = tempdis(:);
                        end
                    elseif svdSwitch == 1
                        % if SVD is not on-the-fly, comment this.
                        [uFcel, uFcesig, uFcer] = ...
                            svd(obj.dis.full, 'econ');
                        uFcel = uFcel * uFcesig;
                        uFcel = uFcel(:, 1:obj.no.respSVD);
                        uFcer = uFcer(:, 1:obj.no.respSVD);
                        obj.resp.store.fce.hhat{i_pre} = ...
                            [{uFcel}; {uFcer}];
                    end
                end
                
            elseif obj.indicator.refinement == 1 && ...
                    obj.indicator.enrichment == 0
                % if refine, no enrichment, only compute force related
                % responses regarding the new interpolation samples.
                for i_pre = 1:obj.no.itplAdd
                    obj.sti.pre = ...
                        obj.sti.mtxCell{1} * obj.pmVal.add(i_pre, 2) + ...
                        obj.sti.mtxCell{2} * obj.pmVal.add(i_pre, 3) + ...
                        obj.sti.mtxCell{3} * obj.pmVal.s.fix;
                    obj.sti.full = obj.sti.pre;
                    obj.fce.pass = obj.fce.val;
                    obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                    if svdSwitch == 0
                        if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                            obj.resp.store.fce.hhat{obj.no.iExist + i_pre} = ...
                                obj.dis.full(:);
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                            obj.resp.store.fce.hhat{obj.no.iExist + i_pre} = ...
                                obj.dis.full(:, obj.qoi.t);
                        elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                            obj.resp.store.fce.hhat{obj.no.iExist + i_pre} = ...
                                obj.dis.full(obj.qoi.dof, :);
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                            obj.resp.store.fce.hhat{obj.no.iExist + i_pre} = ...
                                obj.dis.full(obj.qoi.dof, obj.qoi.t);
                        end
                    elseif svdSwitch == 1
                        % if SVD is not on-the-fly, comment this.
                        [uFcel, uFcesig, uFcer] = ...
                            svd(obj.dis.full, 'econ');
                        uFcel = uFcel * uFcesig;
                        uFcel = uFcel(:, 1:obj.no.respSVD);
                        uFcer = uFcer(:, 1:obj.no.respSVD);
                        obj.resp.store.fce.hhat{obj.no.iExist + i_pre} = ...
                            [{uFcel}; {uFcer}];
                    end
                end
            end
        end
        %%
        function obj = impInitStep(obj, nrb, i_phy)
            
            impInit = sparse(obj.no.dof, obj.no.t_step);
            impStep = sparse(obj.no.dof, obj.no.t_step);
            impInit(:, 1) = impInit(:, 1) + ...
                obj.asemb.imp.cel{i_phy}(:, nrb);
            impStep(:, 2) = impStep(:, 2) + ...
                obj.asemb.imp.cel{i_phy}(:, nrb);
            
            obj.asemb.imp.apply(1) = {impInit};
            obj.asemb.imp.apply(2) = {impStep};
            
        end
        %%
        function obj = respImpPartTime(obj, i_pre, i_phy, nrb)
            obj.sti.pre = ...
                obj.sti.mtxCell{1} * obj.pmVal.hhat(i_pre, 2) + ...
                obj.sti.mtxCell{2} * obj.pmVal.hhat(i_pre, 3) + ...
                obj.sti.mtxCell{3} * obj.pmVal.s.fix;
            for i_tdiff = 1:2
                
                impPass = obj.asemb.imp.apply{i_tdiff};
                obj.sti.full = obj.sti.pre;
                obj.fce.pass = impPass;
                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                disPass = obj.dis.full;
                
                obj.resp.store.pm.hhat(i_pre, i_phy, i_tdiff, nrb) = {disPass};
                
            end
            
        end
        %%
        function obj = respImpPartTimeSVD...
                (obj, i_pre, i_phy, nrb, nsvd)
            obj.sti.pre = ...
                obj.sti.mtxCell{1} * obj.pmVal.hhat(i_pre, 2) + ...
                obj.sti.mtxCell{2} * obj.pmVal.hhat(i_pre, 3) + ...
                obj.sti.mtxCell{3} * obj.pmVal.s.fix;
            for i_tdiff = 1:2
                
                impPass = obj.asemb.imp.apply{i_tdiff};
                obj.sti.full = obj.sti.pre;
                obj.fce.pass = impPass;
                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                [disl, dissig, disr] = svd(obj.dis.full, 'econ');
                disl = disl(:, 1:nsvd);
                dissig = dissig(1:nsvd, 1:nsvd);
                disr = disr(:, 1:nsvd);
                disl = disl * dissig;
                % change sign for responses.
                obj.resp.store.pm.hhat{i_pre, ...
                    i_phy, i_tdiff, nrb} = [{-disl}; {disr}];
                
            end
            
        end
        %%
        function obj = respTdiffComputation(obj, svdSwitch)
            % this method compute 2 responses for each interpolation
            % sample, each affin term, each basis vector.
            % only compute responses regarding newly added basis vectors,
            % but store all responses regarding all basis vectors.
            
            if obj.indicator.refinement == 0 && obj.indicator.enrichment == 1
                % if no refinement, enrich basis: compute the new exact
                % solutions regarding the newly added basis vectors.
                for iPre = 1:obj.no.pre.hhat
                    obj.sti.pre = ...
                        obj.sti.mtxCell{1} * obj.pmVal.hhat(iPre, 2) + ...
                        obj.sti.mtxCell{2} * obj.pmVal.hhat(iPre, 3) + ...
                        obj.sti.mtxCell{3} * obj.pmVal.s.fix;
                    for iPhy = 1:obj.no.phy
                        for iTdiff = 1:2
                            % only compute exact solutions regarding the
                            % newly added basis vectors.
                            for iRb = obj.no.rb - obj.no.phiAdd + 1:obj.no.rb
                                impPass = obj.imp.store.mtx{iPhy, iTdiff, iRb};
                                obj.sti.full = obj.sti.pre;
                                obj.fce.pass = impPass;
                                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                                if svdSwitch == 0
                                    obj.resp.store.tDiff...
                                        (iPre, iPhy, iTdiff, iRb) = ...
                                        {obj.dis.full};
                                elseif svdSwitch == 1
                                    [ul, usig, ur] = svd(obj.dis.full);
                                    ul = ul * usig;
                                    ul = ul(:, 1:obj.no.respSVD);
                                    ur = ur(:, 1:obj.no.respSVD);
                                    obj.resp.store.tDiff...
                                        {iPre, iPhy, iTdiff, iRb} = ...
                                        {ul; ur};
                                end
                            end
                        end
                    end
                end
                
            elseif obj.indicator.refinement == 1 && ...
                    obj.indicator.enrichment == 0
                % if refine, no enrichment, compute exact solutions
                % regarding all basis vectors but only for the newly added
                % interpolation samples.
                for iPre = 1:obj.no.itplAdd
                    obj.sti.pre = ...
                        obj.sti.mtxCell{1} * obj.pmVal.add(iPre, 2) + ...
                        obj.sti.mtxCell{2} * obj.pmVal.add(iPre, 3) + ...
                        obj.sti.mtxCell{3} * obj.pmVal.s.fix;
                    for iPhy = 1:obj.no.phy
                        for iTdiff = 1:2
                            % compute exact solutions reagrding all reduced
                            % basis vectors.
                            for iRb = 1:obj.no.rb
                                impPass = obj.imp.store.mtx{iPhy, iTdiff, iRb};
                                obj.sti.full = obj.sti.pre;
                                obj.fce.pass = impPass;
                                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                                if svdSwitch == 0
                                    obj.resp.store.tDiff(obj.no.iExist + iPre, ...
                                        iPhy, iTdiff, iRb) = {obj.dis.full};
                                elseif svdSwitch == 1
                                    [ul, usig, ur] = svd(obj.dis.full);
                                    ul = ul * usig;
                                    ul = ul(:, 1:obj.no.respSVD);
                                    ur = ur(:, 1:obj.no.respSVD);
                                    obj.resp.store.tDiff...
                                        (obj.no.iExist + iPre, ...
                                        iPhy, iTdiff, iRb) = ...
                                        {ul; ur};
                                end
                            end
                        end
                    end
                end
                
            end
            
        end
        
        %%
        function obj = respTimeShift(obj, qoiSwitchTime, qoiSwitchSpace)
            % this method shifts the responses in time.
            
            for iPre = 1:obj.no.pre.hhat
                for iPhy = 1:obj.no.phy
                    for iT = 1:obj.no.t_step
                        for iRb = 1:obj.no.rb
                            if iT == 1
                                
                                if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb};
                                    
                                elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}(:, obj.qoi.t);
                                    
                                elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}(obj.qoi.dof, :);
                                    
                                elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}...
                                        (obj.qoi.dof, obj.qoi.t);
                                    
                                end
                                respQoi = respQoi(:);
                                obj.resp.store.pm.hhat(iPre, iPhy, 1, iRb) ...
                                    = {respQoi};
                                
                            else
                                storePmzeros = zeros(obj.no.dof, iT - 2);
                                storePmNonzeros = ...
                                    obj.resp.store.tDiff...
                                    {iPre, iPhy, 2, iRb}...
                                    (:, 1:obj.no.t_step - iT + 2);
                                storePmAsemb = ...
                                    [storePmzeros storePmNonzeros];
                                
                                if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                                    storePmQoi = storePmAsemb;
                                    
                                elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                                    storePmQoi = storePmAsemb(:, obj.qoi.t);
                                    
                                elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                                    storePmQoi = storePmAsemb(obj.qoi.dof, :);
                                    
                                elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                                    storePmQoi = storePmAsemb...
                                        (obj.qoi.dof, obj.qoi.t);
                                    
                                end
                                obj.resp.store.pm.hhat(iPre, iPhy, iT, ...
                                    iRb) = {storePmQoi(:)};
                            end
                            
                        end
                    end
                end
            end
            
        end
        
        %%
        function obj = respImpAllTime(obj, i_pre, nrb, i_phy)
            if obj.indicator.refinement == 0
                obj.resp.store.pm.tdiff = cell(2, 1);
                obj.sti.pre = ...
                    obj.sti.mtxCell{1} * obj.pmVal.hhat(i_pre, 2) + ...
                    obj.sti.mtxCell{2} * obj.pmVal.hhat(i_pre, 3) + ...
                    obj.sti.mtxCell{3} * obj.pmVal.s.fix;
                for i_tdiff = 1:2
                    
                    impPass = obj.asemb.imp.apply{i_tdiff};
                    obj.sti.full = obj.sti.pre;
                    obj.fce.pass = impPass;
                    obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                    obj.resp.store.pm.tdiff(i_tdiff) = {obj.dis.full};
                    
                end
                
                for i_tall = 1:obj.no.t_step
                    
                    if i_tall == 1
                        obj.resp.store.pm.hhat(i_pre, i_phy, 1, nrb) = ...
                            {obj.resp.store.pm.tdiff{1}(:)};
                    else
                        storePmzeros = zeros(obj.no.dof, i_tall - 2);
                        storePmNonzeros = obj.resp.storePm.tdiff{2}...
                            (:, 1:obj.no.t_step - i_tall + 2);
                        storePmAsemb = [storePmzeros storePmNonzeros];
                        obj.resp.store.pm.hhat(i_pre, i_phy, i_tall, ...
                            nrb) = {storePmAsemb(:)};
                    end
                    
                end
            end
        end
        %%
        function obj = resptoErrPreCompAllTimeMatrix(obj, rvSvdSwitch)
            % CHANGE SIGN in this method!
            % here the index follows the refind grid sequence, not a
            % sequencial sequence.
            % this method compute eTe, results in a square full symmetric
            % matrix, to be interpolated.
            % reason of using eTe is size of eTe is decided by nt * nj *
            % nr. At least this is not related to nd. Cannot use anyting
            % relate to nd.
            
            if obj.indicator.enrichment == 1 && obj.indicator.refinement == 0
                % indicator for non-zero part of eTe.
                obj.indicator.nonzeroi = [];
                
                % if refine = 0, enrich = 1, compute the newly added basis
                % vectors for all interpolation samples.
                for iPre = 1:obj.no.pre.hhat
                    
                    obj.err.pre.hhat(iPre, 1) = {iPre};
                    % extract rsponse vectors regarding the newly added
                    % basis vectors for each interpolation sample.
                    respPmPass = obj.resp.store.pm.hhat(iPre, :, :, ...
                        obj.no.rb - obj.no.phiAdd + 1 : end);
                    
                    respCol = sparse(cat(2, respPmPass{:}));
                    
                    if obj.countGreedy == 1
                        respCol = [obj.resp.store.fce.hhat{iPre} -respCol];
                    else
                        respCol = -respCol;
                    end
                    
                    obj.resp.store.all{iPre} = ...
                        [obj.resp.store.all{iPre} respCol];
                    
                    respAllCol = obj.resp.store.all{iPre};
                    
                    if rvSvdSwitch == 1
                        % if SVD on reduced variables, pm needs to be
                        % interpolated, therefore here pre-multiply pm to
                        % related responses.
                        
                        pmhhat = obj.pmVal.hhat(iPre, 2:end);
                        pmAll = [1; 1; pmhhat'; obj.pmVal.s.fix];
                        pmRep = repmat(pmAll, obj.no.t_step * obj.no.rb, 1);
                        pmRep = [1; pmRep];
                        pmMtx = pmRep * pmRep';
                        respTrans = (respAllCol' * respAllCol) .* pmMtx;
                        
                    elseif rvSvdSwitch == 0
                        % compute eTe, including all zero elements, then take
                        % upper triangle only.
                        
                        respTrans = respAllCol' * respAllCol;
                    end
                    
                    respTrans = triu(respTrans);
                    % find the nonzero elements and interpolate these only.
                    
                    if iPre == 1
                        
                        for i = 1:size(respTrans, 2)
                            obj.indicator.nonzeroi = ...
                                [obj.indicator.nonzeroi; any(respTrans(:, i))];
                        end
                        obj.indicator.nonzeroi = find(obj.indicator.nonzeroi);
                        if obj.countGreedy == 1
                            obj.no.eTenz1 = length(obj.indicator.nonzeroi);
                            obj.no.eTeInc = obj.no.eTenz1;
                        elseif obj.countGreedy == 2
                            obj.no.eTenz2 = length(obj.indicator.nonzeroi);
                            obj.no.eTeInc = obj.no.eTenz2 - obj.no.eTenz1;
                            
                        end
                        
                    end
                    
                    respTransNonZero = ...
                        full(respTrans(obj.indicator.nonzeroi, ...
                        obj.indicator.nonzeroi));
                    
                    obj.err.pre.hhat(iPre, 3) = {respTransNonZero};
                end
                
            elseif obj.indicator.enrichment == 0 && ...
                    obj.indicator.refinement == 1
                % if refine = 1, enrich = 0, compute the newly added
                % interpolation samples for all basis vectors.
                obj.resp.store.all(obj.no.iExist + 1 : obj.no.pre.hhat) = ...
                    cell(obj.no.itplAdd, 1);
                obj.indicator.nonzeroi = [];
                for iPre = 1:obj.no.itplAdd
                    
                    obj.err.pre.hhat(obj.no.iExist + iPre, 1) = ...
                        {obj.no.iExist + iPre};
                    respPmPass = obj.resp.store.pm.hhat...
                        (obj.no.iExist + iPre, :, :, :);
                    respCol = sparse(cat(2, respPmPass{:}));
                    % if refined, force responses are also refined,
                    % therefore add the newly added force response to pm
                    % responses.
                    
                    respCol = [obj.resp.store.fce.hhat{obj.no.iExist + ...
                        iPre}(:) -respCol];
                    
                    obj.resp.store.all{obj.no.iExist + iPre} = ...
                        [obj.resp.store.all{obj.no.iExist + iPre} respCol];
                    
                    respTrans = obj.resp.store.all{obj.no.iExist + iPre}' * ...
                        obj.resp.store.all{obj.no.iExist + iPre};
                    
                    respTrans = triu(respTrans);
                    
                    if iPre == 1
                        
                        for i = 1:size(respTrans, 2)
                            obj.indicator.nonzeroi = ...
                                [obj.indicator.nonzeroi; any(respTrans(:, i))];
                        end
                        
                        obj.indicator.nonzeroi = find(obj.indicator.nonzeroi);
                        
                    end
                    
                    respTransNonZero = ...
                        respTrans(obj.indicator.nonzeroi, ...
                        obj.indicator.nonzeroi);
                    
                    obj.err.pre.hhat(obj.no.iExist + iPre, 3) = ...
                        {respTransNonZero};
                end
                
            end
            obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);
            
        end
        %%
        function obj = resptoErrPreCompPartTime(obj, qoiSwitchTime, ...
                qoiSwitchSpace)
            obj.err.pre.blk = cell(obj.no.pre.hhat, 1);
            nVecShift = obj.no.phy;
            obj.indicator.nonzeroi = [];
            % number of upper triangular blocks.
            nWidth = obj.no.t_step;
            nUpper = nWidth * (nWidth + 1) / 2;
            inda = 1:nUpper;
            indb = triu(ones(nWidth));
            indb = indb';
            indb(~~indb) = inda;
            indb = indb';
            indb = indb(:);
            tempBlk = cell(obj.no.rb, obj.no.rb);
            tempCellTri = cell(nWidth * nWidth, 1);
            respCell = cell(1);
            
            for iPre = 1:obj.no.pre.hhat
                
                obj.err.pre.hhat(iPre, 1) = {iPre};
                respPmPass = obj.resp.store.tDiff(iPre, :, :, :);
                respPreTemp = cellfun(@(v) -v, respPmPass, 'un', 0);
                respFce = zeros(obj.no.dof, obj.no.t_step);
                respFceTemp = obj.resp.store.fce.hhat{iPre};
                
                if qoiSwitchTime == 1
                    
                    respFceTemp = reshape(respFceTemp, ...
                        [obj.no.dof, length(obj.qoi.t)]);
                    for i = 1:length(obj.qoi.t)
                        respFce(:, obj.qoi.t(i)) = respFce(:, obj.qoi.t(i)) + ...
                            respFceTemp(:, i);
                    end
                end
                
                respPreTemp = cellfun(@(v) v(:), respPreTemp, 'un', 0);
                respPreTemp = [respPreTemp{:}];
                
                for i = 1:obj.no.rb * 2
                    respCell(i) = {respPreTemp(:, (i - 1) * obj.no.phy + 1:...
                        i * obj.no.phy)};
                end
                
                respCell(1) = {[respFce(:) respCell{1}]};
                
                respCell = reshape(respCell, [2, obj.no.rb]);
                
                respFixY = respCell(1, :);
                respFixN = respCell(2, :);
                
                for irb = 1:obj.no.rb
                    for jrb = irb:obj.no.rb
                        tempCell = cell(1);
                        counter = 1;
                        for ish = 1:obj.no.t_step
                            if ish == 1
                                respT1 = respFixY{irb};
                            else
                                respT1 = [zeros((ish - 2) * obj.no.dof, ...
                                    nVecShift); ...
                                    respFixN{irb}(1:end - obj.no.dof * ...
                                    (ish - 2), :)];
                            end
                            
                            if irb == jrb
                                
                                for jsh = ish:obj.no.t_step
                                    if jsh == 1
                                        respT2 = respFixY{jrb};
                                        
                                    else
                                        respT2 = [zeros((jsh - 2) * ...
                                            obj.no.dof, nVecShift); ...
                                            respFixN{jrb}(1:end - ...
                                            obj.no.dof * (jsh - 2), :)];
                                        
                                    end
                                    
                                    if qoiSwitchTime == 1
                                        respT1(obj.qoi.vecIndSetdiff, :) = 0;
                                        respT2(obj.qoi.vecIndSetdiff, :) = 0;
                                    end
                                    
                                    tempCell(counter) = {respT1' * respT2};
                                    counter = counter + 1;
                                    
                                end
                                
                            else
                                for jsh = 1:obj.no.t_step
                                    if jsh == 1
                                        respT2 = respFixY{jrb};
                                    else
                                        respT2 = [zeros((jsh - 2) * ...
                                            obj.no.dof, nVecShift); ...
                                            respFixN{jrb}(1:end - ...
                                            obj.no.dof * (jsh - 2), :)];
                                        
                                    end
                                    if qoiSwitchTime == 1
                                        respT1(obj.qoi.vecIndSetdiff, :) = 0;
                                        respT2(obj.qoi.vecIndSetdiff, :) = 0;
                                    end
                                    tempCell(counter) = {respT1' * respT2};
                                    counter = counter + 1;
                                    
                                end
                                
                            end
                            
                        end
                        if irb == jrb
                            % use indb to form the upper triangular cell
                            % block
                            for i = 1:nWidth * nWidth
                                if indb(i) ~= 0
                                    tempCellTri{i} = tempCell{indb(i)};
                                end
                            end
                            tempCellTri = reshape(tempCellTri, [nWidth, nWidth]);
                            
                            tempBlk(irb, jrb) = {tempCellTri};
                        elseif irb ~= jrb
                            % put cells into square block, then
                            % transpose.
                            tempCellSq = reshape(tempCell, ...
                                [obj.no.t_step, obj.no.t_step]);
                            tempCellSq = tempCellSq';
                            tempBlk(irb, jrb) = {tempCellSq};
                            
                        end
                    end
                end
                
                tempBlkExp = cell(obj.no.rb * obj.no.t_step, ...
                    obj.no.rb * obj.no.t_step);
                for i = 1:obj.no.rb
                    for j = 1:obj.no.rb
                        if i <= j
                            tempBlkExp((i - 1) * obj.no.t_step + 1 : ...
                                i * obj.no.t_step, ...
                                (j - 1) * obj.no.t_step + 1 : ...
                                j * obj.no.t_step) = tempBlk{i, j};
                        else
                            tempBlkExp((i - 1) * obj.no.t_step + 1 : ...
                                i * obj.no.t_step, ...
                                (j - 1) * obj.no.t_step + 1 : ...
                                j * obj.no.t_step) = cell(1);
                        end
                    end
                end
                idx = cellfun('isempty', tempBlkExp);
                c = cellfun(@transpose, tempBlkExp.', 'un', 0);
                tempBlkExp(idx) = c(idx);
                
                eTe = triu(cell2mat(tempBlkExp));
                
                if iPre == 1
                    
                    for i = 1:size(eTe, 2)
                        obj.indicator.nonzeroi = ...
                            [obj.indicator.nonzeroi; any(eTe(:, i))];
                    end
                    obj.indicator.nonzeroi = find(obj.indicator.nonzeroi);
                end
                
                eTeNonZero = ...
                    eTe(obj.indicator.nonzeroi, obj.indicator.nonzeroi);
                
                obj.err.pre.hhat(iPre, 2) = {eTeNonZero};
                
            end
            obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);
        end
        
        %%
        function obj = resptoErrPreFceCell(obj, i_pre)
            
            % process force response.
            respFce = obj.resp.store.fce.hhat{i_pre};
            [respFceL, respFceSig, respFceR] = svd(respFce, 'econ');
            obj.resp.fce.cell = cell(1, obj.no.respSVD);
            for i = 1:obj.no.respSVD
                
                x = respFceL(:, i) * respFceSig(i, i);
                y = respFceR(:, i);
                obj.resp.fce.cell{i} = {x; y};
                
            end
            
        end
        %%
        function obj = resptoErrPreCompSVDallTime(obj)
            nTotal = obj.no.rb * obj.no.phy * obj.no.t_step;
            obj.err.pre.hhat = cell(obj.no.pre.hhat, 2);
            
            for i_pre = 1:obj.no.pre.hhat
                
                obj.err.pre.hhat(i_pre, 1) = {i_pre};
                
                % process force response.
                respFce = obj.resp.store.fce.hhat{i_pre};
                
                % process pm responses, store all information from all time
                % responses.
                respPmPass = obj.resp.store.pm.hhat(i_pre, :, :, :);
                
                respPmPass = cellfun(@(v) -v, respPmPass, 'un', 0);
                
                % size of respPmSpaceTime cell = 1, nrb, nphy, ntime. So
                % are respL, respSig, respR.
                
                respPmSpaceTime = cellfun(@(v) ...
                    reshape(v, [obj.no.dof, obj.no.t_step]), ...
                    respPmPass, 'un', 0);
                
                [respPmL, respPmSig, respPmR] = cellfun(@(v) svd(v, 'econ'), ...
                    respPmSpaceTime, 'un', 0);
                
                respPmL = cellfun(@(u, v) u * v, respPmL, respPmSig, 'un', 0);
                rLres = reshape(respPmL, [nTotal, 1]);
                rRres = reshape(respPmR, [nTotal, 1]);
                rLres = cellfun(@(v) v(:, 1:obj.no.respSVD), rLres, 'un', 0);
                rRres = cellfun(@(v) v(:, 1:obj.no.respSVD), rRres, 'un', 0);
                rLres = [respFce(1); rLres];
                rRres = [respFce(2); rRres];
                
                respTrans = zeros(obj.no.rb * obj.no.phy * obj.no.t_step + 1);
                
                % +1 because force is one extra vector.
                for i = 1:obj.no.rb * obj.no.phy * obj.no.t_step + 1
                    for j = 1:obj.no.rb * obj.no.phy * obj.no.t_step + 1
                        respPass = 0;
                        
                        l1 = rLres{i};
                        l2 = rLres{j};
                        r1 = rRres{i};
                        r2 = rRres{j};
                        
                        respPass = respPass + trace(r2' * r1 * l1' * l2);
                        respTrans(i, j) = respTrans(i, j) + respPass;
                    end
                    
                end
                
                obj.err.pre.hhat(i_pre, 2) = {sparse(triu(respTrans))};
                
            end
            
            obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);
            
        end
        %%
        function obj = resptoErrPreCompSVDpartTimeNoCell(obj)
            
            obj.err.pre.hhat = cell(obj.no.pre.hhat, 2);
            % the number of vectors being shifted.
            nshift = obj.no.rb * obj.no.phy;
            ntotal = nshift * 2 + 1;
            for iPre = 1:obj.no.pre.hhat
                
                obj.err.pre.hhat(iPre, 1) = {iPre};
                % extract respPreStore from interpolation samples, each cell
                % contains left and right vectors. Dimension order is iPre,
                % nrb, nphy, 2. already change sign for respPreStore in function
                % respImpPartTimeSVD.
                respPreStore = obj.resp.store.pm.hhat(iPre, :, :, :);
                respPreStore = permute(respPreStore, [1 3 4 2]);
                % reshape respPreTemp in one dimension.
                respPreTemp = reshape(respPreStore, ...
                    obj.no.rb * obj.no.phy * 2, 1);
                
                % CT, add the response from force.
                respPreStore = [obj.resp.store.fce.hhat(iPre); respPreTemp];
                
                % separate left vectors and right vectors, release the cells to
                % doubles.
                
                respPmL = cellfun(@(v) v(1, :), respPreStore, 'un', 0);
                respPmL = cellfun(@(v) cell2mat(v), respPmL, 'un', 0);
                respPmR = cellfun(@(v) v(2, :), respPreStore, 'un', 0);
                respPmR = cellfun(@(v) cell2mat(v), respPmR, 'un', 0);
                
                % select the shifted left and right vectors.
                respPmLspec = respPmL(ntotal - nshift + 1:end);
                respPmRspec = respPmR(ntotal - nshift + 1:end);
                keyboard
                
            end
            
            
        end
        %%
        function obj = reducedVar(obj, iIter)
            % compute reduced variables for each pm value.
            
            obj.pmVal.iter = mat2cell([obj.pmVal.comb.space(iIter, ...
                obj.no.inc + 1 : end)'; ...
                obj.pmVal.s.fix], ones(obj.no.inc + 1, 1));
            obj.pmLoc.iter = obj.pmVal.comb.space(iIter, (1:obj.no.inc));
            obj.pmExpo.iter = ...
                cellfun(@(v) log10(v), obj.pmVal.iter, 'un', 0);
            stiReIter = ...
                cellfun(@(v, w) full(v) * w, ...
                obj.sti.re.mtxCell, obj.pmVal.iter, 'un', 0);
            stiReIter = sum(cat(3, stiReIter{:}), 3);
            obj.sti.reduce = stiReIter;
            obj.mas.reduce = obj.mas.re.mtx;
            obj.dam.reduce = obj.dam.re.mtx;
            obj.fce.pass = obj.fce.val;
            obj = NewmarkBetaReducedMethodOOP(obj, 'reduced');
            obj.acc.re.reVar = obj.acc.reduce;
            obj.vel.re.reVar = obj.vel.reduce;
            obj.dis.re.reVar = obj.dis.reduce;
            
        end
        %%
        function obj = reducedVarStore(obj, iIter)
            % this method stores all reduced variables in one cell.
            obj.resp.rv.store(iIter) = {obj.pmVal.rvCol};
            
        end
        %%
        function obj = reducedVarSVD(obj)
            % this method performs SVD on the stored reduced variables.
            rvStore = cell2mat(obj.resp.rv.store);
            [rvL, rvSig, rvR] = svd(rvStore, 0);
            rvL = rvL * rvSig;
            % size(rvL) = ntnrnf * domain size, size(rvR) = domain size *
            % domain size. size(eTe) = ntnrnf * ntnrnf, therefore size(rvR *
            % rvL' * eTe * rvL * rvR') = domain size * domain size
            % (rvL * rvR' = origin), and truncation can be performed.
            % what's being interpolated here is: rvL' * eTe * rvL.
            
            for i = 1:obj.no.pre.hhat
                
                obj.err.pre.hhat{i, 3} = rvL' * obj.err.pre.hhat{i, 3} * rvL;
                
            end
            
            for i = 1:obj.no.pre.hat
                
                obj.err.pre.hat{i, 3} = rvL' * obj.err.pre.hat{i, 3} * rvL;
                
            end
            
            obj.resp.rv.R = rvR;
            
        end
        %%
        function obj = pmPrepare(obj)
            % This method prepares parameter values to fit and multiply
            % related reduced variables.
            % The interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            % Repeat for nt times to fit length of pre-computed
            % responses.
            pmPass = cell2mat(obj.pmVal.iter);
            
            pmSlct = repmat([1; 1; pmPass], obj.no.t_step * obj.no.rb, 1);
            
            pmSlct = [1; pmSlct];
            
            pmNonZeroCol = pmSlct(obj.indicator.nonzeroi, :);
            
            obj.pmVal.pmCol = pmNonZeroCol;
            
        end
        
        %%
        function obj = rvPrepare(obj)
            % This method prepares reduced variables
            % to fit and multiply related reduced variables.
            % The interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            % Repeat for nt times to fit length of pre-computed
            % responses.
            
            % size of original rv is nr * nt.
            rvAcc = obj.acc.re.reVar;
            rvVel = obj.vel.re.reVar;
            rvDis = obj.dis.re.reVar;
            
            rvAccRow = rvAcc';
            rvAccRow = rvAccRow(:);
            rvAccRow = rvAccRow';
            rvVelRow = rvVel';
            rvVelRow = rvVelRow(:);
            rvVelRow = rvVelRow';
            rvDisRow = rvDis';
            rvDisRow = rvDisRow(:);
            rvDisRow = rvDisRow';
            
            %
            rvDisRepRow = repmat(rvDisRow, obj.no.inc, 1);
            
            rvAllRow = [rvAccRow; rvVelRow; rvDisRepRow];
            rvAllCol = rvAllRow(:);
            rvAllCol = [1; rvAllCol(:)];
            
            %
            rvNonZeroCol = rvAllCol(obj.indicator.nonzeroi, :);
            obj.no.totalResp = size(rvAllCol, 1);
            obj.pmVal.rvCol = rvNonZeroCol;
            
        end
        %%
        function obj = inpolyItpl(obj, type)
            switch type
                
                case 'hhat'
                    nblk = length(obj.pmExpo.block.hhat);
                    pmBlk = obj.pmExpo.block.hhat;
                case 'hat'
                    nblk = length(obj.pmExpo.block.hat);
                    pmBlk = obj.pmExpo.block.hat;
                case 'add' % only for newly added blocks
                    nblk = 4;
                    pmBlk = obj.pmExpo.block.add;
                    
            end
            for i = 1:nblk
                
                if inpolygon(obj.pmExpo.iter{1}, obj.pmExpo.iter{2}, ...
                        pmBlk{i}(:, 2), pmBlk{i}(:, 3)) == 1
                    
                    xl = min(pmBlk{i}(:, 2));
                    xr = max(pmBlk{i}(:, 2));
                    yl = min(pmBlk{i}(:, 3));
                    yr = max(pmBlk{i}(:, 3));
                    [gridxVal, gridyVal] = meshgrid([xl xr], [yl yr]);
                    gridx = 10 .^ gridxVal;
                    gridy = 10 .^ gridyVal;
                    switch type
                        case 'hhat'
                            gridzVal = obj.err.pre.hhat(pmBlk{i}(:, 1), 3);
                            
                        case 'hat'
                            gridzVal = obj.err.pre.hat(pmBlk{i}(:, 1), 3);
                            
                        case 'add'
                            % pmBlk is the added block now.
                            pmAdd = pmBlk{i};
                            gridzVal = obj.err.pre.hhat(pmAdd(:, 1), 3);
                            
                    end
                    
                    gridz = [gridzVal(1) gridzVal(2); ...
                        gridzVal(4) gridzVal(3)];
                    
                    obj.LagItpl2Dmtx(gridx, gridy, gridz);
                    
                end
                
            end
            switch type
                
                case 'hhat'
                    obj.err.itpl.hhat = obj.err.itpl.otpt;
                case 'hat'
                    obj.err.itpl.hat = obj.err.itpl.otpt;
                case 'add'
                    obj.err.itpl.add = obj.err.itpl.otpt;
            end
            
        end
        %%
        function obj = conditionalItplProdRvPm(obj, iIter)
            % this method considers the interpolation condition and enrichment
            % condition to efficiently perform interpolation.
            
            % the PRINCIPLE: if refine, let ehat = ehhat, interpolate in
            % new blocks, modify ehat at new blocks to get ehhat; if
            % enrich, interpolate through ehat blocks. For ehhat, only
            % interpolate the refined blocks, and modify ehat surface to
            % get ehhat surface.
            
            % if there is no refinement at all, both hhat and hat domain need to
            % perform interpolation.
            if obj.no.block.hat == 1
                
                obj.inpolyItpl('hhat');
                obj.inpolyItpl('hat');
                obj.rvPmErrProdSum('hhat', 0);
                obj.rvPmErrProdSum('hat', 0);
                obj.err.store.surf.hhat(iIter) = 0;
                obj.err.store.surf.hat(iIter) = 0;
                obj.errStoreSurfs('hhat');
                obj.errStoreSurfs('hat');
                % if enrich, interpolate ehat. For ehhat, only interpolate
                % the refined blocks, and modify ehat surface at new
                % blocks to get ehhat surface.
                % NO H-REF
            elseif obj.indicator.refinement == 0 && ...
                    obj.indicator.enrichment == 1
                
                % hat surface needs to be interpolated everywhere.
                obj.err.store.surf.hat(iIter) = 0;
                obj.inpolyItpl('hat');
                
                %                 disp(norm(obj.err.itpl.hat, 'fro'))
                
                obj.rvPmErrProdSum('hat', 0);
                obj.errStoreSurfs('hat');
                % Determine whether point is in refined block.
                obj.inAddBlockIndicator;
                if any(obj.indicator.inBlock) == 0
                    % if not in refined block, let hhat surface = hat surface
                    obj.err.store.surf.hhat(iIter) = ...
                        obj.err.store.surf.hat(iIter);
                    % if the point is in the refined block, interpolate
                    % to obtain hhat at refined points.
                elseif any(obj.indicator.inBlock) == 1
                    obj.err.store.surf.hhat(iIter) = 0;
                    obj.inpolyItpl('hhat');
                    obj.rvPmErrProdSum('hhat', 0);
                    obj.errStoreSurfs('hhat');
                    
                end
                keyboard
            elseif obj.indicator.refinement == 1 && ...
                    obj.indicator.enrichment == 0
                % if refine, let ehat surface = ehhat surface, interpolate new
                % blocks, modify ehat surface at new blocks to get ehhat.
                % H-REF
                
                if iIter == 1
                    % only if point is not in refined blocks, hat = hhat,
                    % otherwise all hat will = hhat.
                    obj.err.store.surf.hat = obj.err.store.surf.hhat;
                end
                % Determine whether point is in refined block.
                obj.inAddBlockIndicator;
                if any(obj.indicator.inBlock) == 1
                    % only interpolate and modify the refined part of hhat
                    % block, should be very fast.
                    obj.err.store.surf.hhat(iIter) = 0;
                    
                    obj.inpolyItpl('add');
                    obj.rvPmErrProdSum('add', 0);
                    obj.errStoreSurfs('hhat');
                end
                
            end
            
        end
        %%
        function obj = rvPmErrProdSum(obj, type, rvSvdSwitch)
            
            switch type
                case 'hhat'
                    e = obj.err.itpl.hhat;
                case 'hat'
                    e = obj.err.itpl.hat;
                case 'add'
                    e = obj.err.itpl.add;
            end
            % recover eTe
            e = reConstruct(e);
            if rvSvdSwitch == 0
                
                ePreSqrt = (obj.pmVal.rvCol .* obj.pmVal.pmCol)' * e * ...
                    (obj.pmVal.rvCol .* obj.pmVal.pmCol);
                switch type
                    case 'hhat'
                        obj.err.norm{1} = ...
                            sqrt(abs(ePreSqrt)) / ...
                            norm(obj.dis.qoi.trial, 'fro');
                    case 'hat'
                        obj.err.norm{2} = ...
                            sqrt(abs(ePreSqrt)) / ...
                            norm(obj.dis.qoi.trial, 'fro');
                    case 'add'
                        % only apply to hhat, cause refined blocks are in ehhat.
                        obj.err.norm{1} = ...
                            sqrt(abs(ePreSqrt)) / ...
                            norm(obj.dis.qoi.trial, 'fro');
                end
                
            elseif rvSvdSwitch == 1
                
                obj.err.store.preSqrt = obj.resp.rv.R * e * obj.resp.rv.R';
                
            end
            
        end
        %%
        function obj = inBlockItpl(obj)
            % this method decides interpolation for hat. there are 3
            % conditions:
            % 1. hat block == 1, then every points in hat needs to be
            % interpolated;
            % 2. hat block > 1, meaning there is at least 1 refinement,
            % find whether the point is in the refined block, if in, only
            % interpolate the refined blocks;
            % 3. if not in, hat = hhat.
            if obj.no.block.hat == 1
                
                % no refinement at all, ehat needs to be interpolated.
                obj.inpolyItpl('hat');
                
            elseif obj.no.block.hat > 1
                
                % when there is a refinement, only itpl the refined block.
                obj.inAddBlockIndicator;
                
                if any(obj.indicator.inBlock) == 1
                    
                    % if pm point is in refined block, interpolate.
                    obj.inpolyItpl('add');
                    obj.inpolyItpl('hat');
                    
                elseif any(obj.indicator.inBlock) == 0
                    
                    % if pm point is not in refined block, hat = hhat.
                    obj.err.itpl.hat = obj.err.itpl.hhat;
                    
                end
            end
            
        end
        %%
        function obj = rvpmSlct(obj)
            % select rv and pm to interpolate
            nold = obj.no.t_step * obj.no.phy * (obj.no.rb - 1) + 1;
            if obj.countGreedy == 1
                obj.pmVal.rvSlct = obj.pmVal.rv;
                obj.pmVal.pmSlct = obj.pmVal.pm;
            else
                obj.pmVal.rvSlct = obj.pmVal.rv(:, nold + 1:end);
                obj.pmVal.pmSlct = obj.pmVal.pm(:, nold + 1:end);
            end
            
        end
        
        %%
        function obj = inAddBlockIndicator(obj)
            % indicator for determining whether pm point is in added
            % parameter block (polygon).
            pmIter1 = obj.pmExpo.iter{1};
            pmIter2 = obj.pmExpo.iter{2};
            pmExpoAdd = obj.pmExpo.block.add;
            obj.indicator.inBlock = cellfun(@(pmExpoAdd) inpolygon...
                (pmIter1, pmIter2, pmExpoAdd(:, 2), ...
                pmExpoAdd(:, 3)), pmExpoAdd);
            
        end
        %%
        function obj = errStoreSurfs(obj, type)
            % store all error response surfaces: 2 hats, 1 diff, 1 errwithRb.
            switch type
                case 'hhat'
                    
                    obj.err.store.surf.hhat(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) = ...
                        obj.err.store.surf.hhat(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) + obj.err.norm{1};
                    
                case 'hat'
                    obj.err.store.surf.hat(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) = ...
                        obj.err.store.surf.hat(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) + obj.err.norm{2};
                    
                case 'diff'
                    obj.err.store.surf.diff(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) = ...
                        obj.err.store.surf.diff(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) + ...
                        abs(obj.err.store.surf.hhat(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) - ...
                        obj.err.store.surf.hat(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)));
                    
                case 'errwRb'
                    obj.err.store.surf.errwRb(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) = ...
                        obj.err.store.surf.errwRb(obj.pmLoc.iter(1), ...
                        obj.pmLoc.iter(2)) + obj.err.errwRb;
                    
                case 'original'
                    pmLocIter = num2cell(obj.pmLoc.iter);
                    surfSize = size(obj.err.store.surf);
                    obj.err.store.surf(sub2ind(surfSize, pmLocIter{:})) = ...
                        obj.err.store.surf(sub2ind(surfSize, pmLocIter{:})) + ...
                        obj.err.val;
                    keyboard
            end
            
        end
        %%
        function obj = rvPmErrProdSumSlct(obj)
            
            % multiply the square matrices: norm error * rv * pm.
            e = {obj.err.itpl.hat; obj.err.itpl.hhat};
            
            esm = cellfun(@(v) v .* obj.pmVal.rvSlct .* obj.pmVal.pmSlct, ...
                e, 'un', 0);
            
            % because esm has 2 upper triangular matrices, here sumfunc sum
            % all elements, then - trace(esm), then * 2, then plus trace(esm).
            
            nadd = obj.no.t_step * obj.no.phy;
            esmup = cellfun(@(v) v(1:end - nadd, :), esm, 'un', 0);
            esmlow = cellfun(@(v) v(end - nadd + 1 : end, :), esm, 'un', 0);
            sumfunc = @(v) (sum(v(:)) - trace(v)) * 2 + trace(v);
            
            esmupsum = cellfun(@(v) sum(v(:)), esmup, 'un', 0);
            esmlowsum = cellfun(sumfunc, esmlow, 'un', 0);
            obj.err.sm = cellfun(@(u, v) u + v, esmupsum, esmlowsum, 'un', 0);
            
        end
        %%
        function obj = exactErrwithRB(obj, qoiSwitchTime, qoiSwitchSpace)
            % compute exact error with the enriched RB, which is U^h - \phi *
            % \alpha. Requires exact solution in pm domain.
            
            relativeErrSq = @(xNum, xInit) ...
                (norm(xNum, 'fro')) / (norm(xInit, 'fro'));
            
            obj.sti.iter = cellfun(@(v, w) v * w, ...
                obj.sti.mtxCell, obj.pmVal.iter, 'un', 0);
            obj.sti.iter = cellfun(@full, obj.sti.iter, 'un', 0);
            obj.sti.iter = sum(cat(3, obj.sti.iter{:}), 3);
            obj.sti.full = obj.sti.iter;
            obj.fce.pass = obj.fce.val;
            obj = NewmarkBetaReducedMethodOOP(obj, 'full');
            
            respRecons = obj.phi.val * obj.dis.re.reVar;
            obj.dis.errwRb = obj.dis.full;
            
            if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                obj.dis.qoi.errwRb = obj.dis.errwRb;
                
            elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                obj.dis.qoi.errwRb = obj.dis.errwRb(:, obj.qoi.t);
                respRecons = respRecons(:, obj.qoi.t);
                
            elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                obj.dis.qoi.errwRb = obj.dis.errwRb(obj.qoi.dof, :);
                respRecons = respRecons(obj.qoi.dof, :);
                
            elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                obj.dis.qoi.errwRb = obj.dis.errwRb(obj.qoi.dof, obj.qoi.t);
                respRecons = respRecons(obj.qoi.dof, obj.qoi.t);
                
            end
            
            obj.err.errwRb = ...
                relativeErrSq(obj.dis.qoi.errwRb - respRecons, ...
                obj.dis.qoi.trial);
        end
        %%
        function obj = extractErrorInfo(obj, type, randomSwitch)
            % extract error max and location from surfaces. The maximum
            % error value displayed in main script is errwRb.
            
            switch type
                
                case 'hhat'
                    
                    [eMaxValhhat, eMaxLocIdxhhat] = ...
                        max(obj.err.store.surf.hhat(:));
                    pmValRowhhat = obj.pmVal.comb.space(eMaxLocIdxhhat, :);
                    obj.err.max.loc.hhat = pmValRowhhat(:, 1:2);
                    obj.err.max.val.hhat = eMaxValhhat;
                    
                case 'hat'
                    
                    [eMaxValhat, eMaxLocIdxhat] = ...
                        max(obj.err.store.surf.hat(:));
                    pmValRowhat = obj.pmVal.comb.space(eMaxLocIdxhat, :);
                    obj.err.max.loc.hat = pmValRowhat(:, 1:2);
                    obj.err.max.val.hat = eMaxValhat;
                    
                case 'errwRb'
                    [eMaxValerrwRb, eMaxLocIdxerrwRb] = ...
                        max(obj.err.store.surf.errwRb(:));
                    pmValRowerrwRb = obj.pmVal.comb.space(eMaxLocIdxerrwRb, :);
                    obj.err.max.loc.errwRb = pmValRowerrwRb(:, 1:2);
                    obj.err.max.val.errwRb = eMaxValerrwRb;
                    
                case 'original'
                    [eMaxVal, eMaxLocIdx] = max(obj.err.store.surf(:));
                    pmValRow = obj.pmVal.comb.space(eMaxLocIdx, :);
                    
                    obj.err.max.val.slct = eMaxVal;
                    
                    if randomSwitch == 1
                        if obj.countGreedy == 1
                            obj.err.max.loc = pmValRow(:, 1:obj.no.inc);
                        elseif obj.countGreedy > 1
                            eMlocRand = [];
                            for i = 1:obj.no.inc
                                eMlocRand = [eMlocRand ...
                                    randi([1 obj.domLeng.i(i)], 1)];
                            end
                            obj.err.max.loc = eMlocRand;
                        end
                    else
                        obj.err.max.loc = pmValRow(:, 1:obj.no.inc);
                    end
                    
            end
        end
        %%
        function obj = storeErrorInfo(obj, type)
            % store error information for each Greedy iterations.
            switch type
                case 'errwRb'
                    obj.err.store.max.errwRb = ...
                        [obj.err.store.max.errwRb; obj.err.max.val.errwRb];
                    obj.err.store.loc.errwRb = ...
                        [obj.err.store.loc.errwRb; obj.err.max.loc.errwRb];
                case 'hhat'
                    obj.err.store.max.hhat = ...
                        [obj.err.store.max.hhat; obj.err.max.val.hhat];
                    obj.err.store.loc.hhat = ...
                        [obj.err.store.loc.hhat; obj.err.max.loc.hhat];
                case 'hat'
                    obj.err.store.max.hat = ...
                        [obj.err.store.max.hat; obj.err.max.val.hat];
                    obj.err.store.loc.hat = ...
                        [obj.err.store.loc.hat; obj.err.max.loc.hat];
                case 'diff'
                    obj.err.store.max.diff = ...
                        [obj.err.store.max.diff; obj.err.max.val.diff];
                    obj.err.store.loc.diff = ...
                        [obj.err.store.loc.diff; obj.err.max.loc.diff];
            end
        end
        %%
        function obj = storeErrorInfoOriginal(obj)
            
            obj.err.store.max = [obj.err.store.max; obj.err.max.val.slct];
            obj.err.store.loc = [obj.err.store.loc; obj.err.max.loc];
            
        end
        %%
        function obj = extractPmInfo(obj, eMaxPmLoc, eMaxValLoc)
            % when extracting maximum error information, values and
            % locations of maximum error can be different, for example, use
            % eDiff to decide maximum error location (eMaxPmLoc =
            % canti.err.maxLoc.diff), and use ehat (canti.err.maxLoc.hat) to
            % decide parameter value regarding maximum error.
            
            obj.pmLoc.max = eMaxPmLoc;
            
            pmValMax = [];
            for i = 1:obj.no.inc
                
                pmValMax = [pmValMax, obj.pmVal.i.space{i}(eMaxValLoc(i), 2)];
                
            end
            obj.pmVal.max = pmValMax;
            obj.pmExpo.max = log10(obj.pmVal.max);
            
        end
        %%
        function obj = localHrefinement(obj)
            % local h-refinement
            obj.indicator.refinement = 1;
            obj.indicator.enrichment = 0;
            
            obj.pmExpo.hat = obj.pmExpo.hhat;
            obj.pmExpo.block.hat = obj.pmExpo.block.hhat;
            obj.no.pre.hat = size(obj.pmExpo.hat, 1);
            obj.no.block.hat = size(obj.pmExpo.block.hat, 1);
            % nExist + nAdd should equal to nhhat.
            obj.no.iExist = obj.no.pre.hat;
            obj = refineGridLocalwithIdx(obj, 'iteration');
            
        end
        %%
        function obj = extractPmAdd(obj)
            % when a h-refinement occurs, this method finds the information
            % relates to newly add samples.
            
            % the newly added blocks.
            obj.pmExpo.block.add = obj.pmExpo.block.hhat(end - 3 : end);
            
            % indices of the block being refined.
            obj.pmLoc.block.add = zeros(size(obj.pmExpo.block.add, 1), 4);
            for i = 1:size(obj.pmExpo.block.add, 1)
                obj.pmLoc.block.add(:, i) = obj.pmLoc.block.add(:, i) + ...
                    obj.pmExpo.block.add{i}(:, 1);
            end
            obj.pmLoc.block.add = unique(obj.pmLoc.block.add);
            
            % indices of newly added samples.
            pmNodehhat = obj.pmExpo.hhat(:, 1);
            pmNodehat = obj.pmExpo.hat(:, 1);
            obj.pmGrid.add = pmNodehhat(length(pmNodehat) + 1 : end);
            
            % pm values of newly added samples.
            obj.pmVal.add = obj.pmVal.hhat(obj.pmGrid.add, :);
            
            obj.no.itplAdd = size(obj.pmVal.add, 1);
        end
        %%
        function obj = residualfromForce...
                (obj, normType, qoiSwitchSpace, qoiSwitchTime)
            switch normType
                case 'l1'
                    relativeErrSq = @(xNum, xInit) ...
                        (norm(xNum, 1)) / (norm(xInit, 1));
                case 'fro'
                    relativeErrSq = @(xNum, xInit) ...
                        (norm(xNum, 'fro')) / (norm(xInit, 'fro'));
            end
            obj.sti.full = cellfun(@(v, w) full(v) * w, ...
                obj.sti.mtxCell, obj.pmVal.iter, 'un', 0);
            obj.sti.full = sum(cat(3, obj.sti.full{:}), 3);
            
            obj.fce.resi = obj.fce.val - ...
                obj.mas.mtx * obj.phi.val * obj.acc.re.reVar - ...
                obj.dam.mtx * obj.phi.val * obj.vel.re.reVar - ...
                obj.sti.full * obj.phi.val * obj.dis.re.reVar;
            
            obj.fce.pass = obj.fce.resi;
            obj = NewmarkBetaReducedMethodOOP(obj, 'full');
            obj.dis.resi = obj.dis.full;
            
            if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                obj.dis.qoi.resi = obj.dis.resi;
                obj.dis.qoi.trial = obj.dis.trial;
                
            elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                obj.dis.qoi.resi = obj.dis.resi(:, obj.qoi.t);
                obj.dis.qoi.trial = obj.dis.trial(:, obj.qoi.t);
                
            elseif qoiSwitchSpace == 1 && qoiSwitchTime == 0
                obj.dis.qoi.resi = obj.dis.resi(obj.qoi.dof, :);
                obj.dis.qoi.trial = obj.dis.trial(obj.qoi.dof, :);
                
            elseif qoiSwitchSpace == 1 && qoiSwitchTime == 1
                obj.dis.qoi.resi = obj.dis.resi(obj.qoi.dof, obj.qoi.t);
                obj.dis.qoi.trial = obj.dis.trial(obj.qoi.dof, obj.qoi.t);
                
            end
            
            obj.err.val = relativeErrSq(obj.dis.qoi.resi, obj.dis.qoi.trial);
            
        end
        %%
        function obj = clearmemory(obj)
            
            obj.err.reConstruct = [];
            obj.err.reConstructOtpt = [];
            obj.err.lagItplCoeff = [];
            obj.err.itpl = [];
            
        end
        %%
        function obj = reducedMatrices(obj)
            % this method constructs the reduced system after reduced basis
            % is computed.
            obj.sti.re.mtxCell = cell(obj.no.inc + 1, 1);
            
            for i = 1:obj.no.inc + 1
                
                obj.sti.re.mtxCell{i} = ...
                    obj.phi.val' * obj.sti.mtxCell{i} * obj.phi.val;
                
            end
            
            obj.mas.re.mtx = obj.phi.val' * obj.mas.mtx * obj.phi.val;
            obj.dam.re.mtx = obj.phi.val' * obj.dam.mtx * obj.phi.val;
            
        end
        %%
        function obj = refiCond(obj, type)
            % this method computes the refinement condition.
            switch type
                case 'maxValue'
                    % maximum distance between maximum values of 2 surfaces.
                    obj.refinement.condition = abs((obj.err.max.val.hhat - ...
                        obj.err.max.val.hat) / obj.err.max.val.hat);
                case 'maxSurf'
                    % maximum distance between 2 surfaces.
                    obj.refinement.condition = ...
                        abs(max(obj.err.store.surf.diff(:)) / ...
                        obj.err.max.val.hat);
            end
        end
        %%
        function obj = refiCondDisplay(obj, type)
            % this method displays refinement condition and refinement.
            disp(strcat('refinement condition', {' = '}, ...
                num2str(obj.refinement.condition)))
            switch type
                case 'noRefi'
                    disp('no h-refinement');
                case 'refi'
                    disp('h-refinement')
            end
        end
        %%
        function obj = maxErrorDisplay(obj, type)
            % this method displays maximum error value.
            disp(strcat('maximum error ', {' = '}, ...
                num2str(obj.err.max.val.slct)));
            switch type
                case 'original'
                    disp(strcat('location ', {' = '}, ...
                        num2str(obj.err.max.loc)));
                case 'hhat'
                    disp(strcat('location ', {' = '}, ...
                        num2str(obj.err.max.loc.hhat)));
                case 'hat'
                    disp(strcat('location ', {' = '}, ...
                        num2str(obj.err.max.loc.hat)));
            end
        end
        %%
        function obj = qoiSpaceTime(obj, nQoiT, ndpn, manual)
            % this method choose equally spaced number of time steps, number
            % depends on nQoiT.
            
            nt = obj.no.t_step;
            ntVec = 2:nt;
            ind = round(linspace(1, length(ntVec), nQoiT));
            %             obj.qoi.t = ntVec([2, 5, 10, 15, 20, 25]);
            obj.qoi.t = ntVec(ind);
            
            if manual == 1
                obj.qoi.t = [5:10];
                %                 obj.qoi.t = [2 4];
            end
            
            obj.qoi.tSetdiff = setdiff([1:obj.no.t_step], obj.qoi.t);
            
            obj.qoi.vecInd = zeros(obj.no.dof, length(obj.qoi.t));
            
            for i = 1:length(obj.qoi.t)
                
                obj.qoi.vecInd(:, i) = obj.qoi.vecInd(:, i) + ...
                    (obj.qoi.t(i) - 1) * obj.no.dof + 1:obj.qoi.t(i) * ...
                    obj.no.dof;
                
            end
            obj.qoi.vecInd = obj.qoi.vecInd(:);
            obj.qoi.vecIndSetdiff = setdiff([1:obj.no.dof * obj.no.t_step], ...
                obj.qoi.vecInd);
            
            obj.qoi.node = obj.node.inc;
            obj.qoi.dof = zeros(ndpn * obj.no.node.inc, 1);
            
            for i = 1:obj.no.inc
                
                obj.qoi.dof(i * ndpn - (ndpn - 1) : i * ndpn) = ...
                    obj.qoi.dof(i * ndpn - (ndpn - 1) : i * ndpn) + ...
                    (ndpn * obj.qoi.node{i} - (ndpn - 1) : ...
                    ndpn * obj.qoi.node{i})';
                
            end
            
        end
        %%
        function obj = NewmarkBetaMethod(obj, mas, dam, sti, fce, ...
                velInpt, disInpt)
            % set a Newmark method in beam for random input.
            beta = 1/4; gamma = 1/2;
            
            t = 0 : obj.time.step : (obj.time.max);
            
            a0 = 1 / (beta * obj.time.step ^ 2);
            a1 = gamma / (beta * obj.time.step);
            a2 = 1 / (beta * obj.time.step);
            a3 = 1/(2 * beta) - 1;
            a4 = gamma / beta - 1;
            a5 = gamma * obj.time.step/(2 * beta) - obj.time.step;
            a6 = obj.time.step - gamma * obj.time.step;
            a7 = gamma * obj.time.step;
            
            obj.dis.val = zeros(length(sti), length(t));
            obj.dis.val(:, 1) = obj.dis.val(:, 1) + disInpt;
            obj.vel.val = zeros(length(sti), length(t));
            obj.vel.val(:, 1) = obj.vel.val(:, 1) + velInpt;
            obj.acc.val = zeros(length(sti), length(t));
            obj.acc.val(:, 1) = obj.acc.val(:, 1) + mas \ (fce(:, 1) - ...
                dam * obj.vel.val(:, 1) - sti * obj.dis.val(:, 1));
            
            Khat = sti + a0 * mas + a1 * dam;
            
            for i_nm = 1 : length(t) - 1
                
                dFhat = fce(:, i_nm+1) + ...
                    mas * (a0 * obj.dis.val(:, i_nm) + ...
                    a2 * obj.vel.val(:, i_nm) + ...
                    a3 * obj.acc.val(:, i_nm)) + ...
                    dam * (a1 * obj.dis.val(:, i_nm) + ...
                    a4 * obj.vel.val(:, i_nm) + ...
                    a5 * obj.acc.val(:, i_nm));
                dU_r = Khat \ dFhat;
                dA_r = a0 * dU_r - a0 * obj.dis.val(:, i_nm) - ...
                    a2 * obj.vel.val(:, i_nm) - a3 * obj.acc.val(:, i_nm);
                dV_r = obj.vel.val(:, i_nm) + ...
                    a6 * obj.acc.val(:, i_nm) + a7 * dA_r;
                obj.acc.val(:, i_nm+1) = dA_r;
                obj.vel.val(:, i_nm+1) = dV_r;
                obj.dis.val(:, i_nm+1) = dU_r;
                
            end
            
        end
        %%
        function obj = GramSchmidt(obj, inpt)
            
            [m, n] = size(inpt);
            otpt = zeros(m, n);
            otpt(:, 1) = inpt(:, 1);
            otpt(:, 1) = otpt(:, 1) / norm(otpt(:, 1));
            
            for iOtpt = 2:n
                
                otpt(:, iOtpt) = otpt(:, iOtpt) + inpt(:, iOtpt);
                
                for jOtpt = 1:(iOtpt-1)
                    
                    a = dot(otpt(:, jOtpt), inpt(:, iOtpt));
                    b = norm(otpt(:, jOtpt)) ^ 2;
                    
                    otpt(:, iOtpt) = otpt(:, iOtpt) - ...
                        ((a / b) * otpt(:, jOtpt));
                    
                end
                
                otpt(:, iOtpt)=otpt(:, iOtpt)/norm(otpt(:, iOtpt));
                
            end
            
            obj.phi.otpt = otpt;
            
        end
        %%
        function obj = readINPgeoMultiIncPlot(obj, plotMeshSwitch, ...
                colorStruct, colorInc)
            % read INP file and extract node and element informations.
            lineNode = [];
            lineElem = [];
            lineInc = [];
            % Read INP file line by line
            fid = fopen(obj.INPname);
            tline = fgetl(fid);
            lineNo = 1;
            lineIncStart = cell(obj.no.inc - 1, 1);
            lineIncEnd = cell(obj.no.inc - 1, 1);
            idx = 1;
            while ischar(tline)
                
                lineNo = lineNo + 1;
                tline = fgetl(fid);
                celltext{lineNo} = tline;
                
                if strncmpi(tline, '*Node', 5) == 1 || ...
                        strncmpi(tline, '*Element', 8) == 1
                    lineNode = [lineNode; lineNo];
                end
                
                if strncmpi(tline, '*Element', 8) == 1 || ...
                        strncmpi(tline, '*Nset', 5) == 1
                    lineElem = [lineElem; lineNo];
                end
                
                strStart = strcat('*Nset, nset=Set-', num2str(idx));
                strEnd = strcat('*Elset, elset=Set-', ...
                    num2str(idx), ', generate');
                
                if strncmpi(tline, strStart, 18) == 1
                    lineIncStart(idx) = {lineNo};
                elseif strncmpi(tline, strEnd, 29) == 1
                    lineIncEnd(idx) = {lineNo};
                    idx = idx + 1;
                end
            end
            strtext = char(celltext(2:(length(celltext) - 1)));
            fclose(fid);
            
            % node
            txtNode = strtext((lineNode(1) : lineNode(2) - 2), :);
            trimNode = strtrim(txtNode);%delete spaces in heads and tails
            obj.node.all = str2num(trimNode);
            obj.no.node.all = size(obj.node.all, 1);
            
            % element
            txtElem = strtext((lineElem(1):lineElem(2) - 2), :);
            trimElem = strtrim(txtElem);
            obj.elem.all = str2num(trimElem);
            obj.no.elem = size(obj.elem.all, 1);
            
            % inclusions
            lineIncNo = [cell2mat(lineIncStart) cell2mat(lineIncEnd)];
            nNodeInc = zeros(obj.no.inc - 1, 1);
            incNode = cell(obj.no.inc - 1, 1);
            incConn = cell(obj.no.inc - 1, 1);
            
            for i = 1:obj.no.inc - 1
                % nodal info of inclusions
                nodeIncCol = [];
                txtInc = strtext((lineIncNo(i, 1):lineIncNo(i, 2) - 2), :);
                trimInc = strtrim(txtInc);
                for j = 1:size(trimInc, 1)
                    
                    nodeInc = str2num(trimInc(j, :));
                    nodeInc = nodeInc';
                    nodeIncCol = [nodeIncCol; nodeInc];
                end
                nodeIncCol = obj.node.all(nodeIncCol, :);
                nInc = size(nodeIncCol, 1);
                incNode(i) = {nodeIncCol};
                nNodeInc(i) = nInc;
                
                % connectivities of inclusions
                connSwitch = zeros(obj.no.node.all, 1);
                connSwitch(incNode{i}(:, 1)) = 1;
                elemInc = [];
                for j = 1:obj.no.elem
                    
                    ind = (connSwitch(obj.elem.all(j, 2:4)))';
                    if isequal(ind, ones(1, 3)) == 1
                        elemInc = [elemInc; obj.elem.all(j, 1)];
                    end
                    
                end
                incConn(i) = {elemInc};
            end
            obj.elem.inc = incConn;
            obj.node.inc = incNode;
            
            if plotMeshSwitch == 1
                % plot mesh with all inclusions
                nnode = size(obj.node.all, 1);
                x = obj.node.all(:, 2);
                y = obj.node.all(:, 3);
                cs = trisurf(obj.elem.all(:,2:4), x, y, zeros(nnode, 1));
                set(cs, 'FaceColor', colorStruct, 'CDataMapping', 'scaled');
                view(2);
                hold on
                % inclusions
                for i = 1:obj.no.inc - 1
                    
                    in = trisurf(obj.elem.all(obj.elem.inc{i}, 2:4), ...
                        x, y, zeros(nnode, 1));
                    set(in, 'FaceColor', colorInc, 'CDataMapping', 'scaled');
                end
                
                axis equal
                
            end
        end
        %%
        function obj = refineGridLocalwithIdx(obj, type)
            % Refine locally, only refine the block which surround the 
            % pm_maxLoc. input is 4 by 2 matrix representing 4 corner 
            % coordinate (in a column way). output is 5 by 2 matrix 
            % representing the computed 5 midpoints. This function is able 
            % to compute any number of given blocks, not just one block.
            % input is a matrix, output is also a matrix, not suitable for 
            % cell. input hat block and maximum point, output hhat points, 
            % hhat blocks. example: see testGSALocalRefiFunc.m
            
            switch type
                
                case 'initial'
                    
                    pmExpMax1 = obj.pmExpo.mid1;
                    pmExpMax2 = obj.pmExpo.mid2;
                    
                case 'iteration'
                    
                    pmExpMax1 = obj.pmExpo.max(1);
                    pmExpMax2 = obj.pmExpo.max(2);
                    
            end
            
            pmExpInptPmTemp = cell2mat(obj.pmExpo.block.hat);
            pmExpInptPm = pmExpInptPmTemp(:, 2:obj.no.inc + 1);
            pmEXPinptRaw = unique(pmExpInptPm, 'rows');
            nBlk = length(obj.pmExpo.block.hat);
            % find which block max pm point is in, refine.
            
            for iBlk = 1:nBlk
                keyboard
                if inpolygon(pmExpMax1, pmExpMax2, ...
                        obj.pmExpo.block.hat{iBlk}(:, 2), ...
                        obj.pmExpo.block.hat{iBlk}(:, 3)) == 1
                    obj = refineGrid(obj, iBlk);
                    iRec = iBlk;
                end
                
            end
            
            % delete repeated point with the chosen block.
            jRec = [];
            for iDel = 1:4
                for jDel = 1:length(obj.pmExpo.block.hhat)
                    
                    if isequal(obj.pmExpo.block.hat{iRec}(iDel, 2:3), ...
                            obj.pmExpo.block.hhat(jDel, :)) == 1
                        
                        jRec = [jRec; jDel];
                        
                    end
                    
                end
            end
            obj.pmExpo.block.hhat(jRec, :) = [];
            pmExpOtptTemp = obj.pmExpo.block.hhat;
            
            % compare pmEXP_otptTemp with pmEXP_inptRaw, only to find whether 
            % there is a repeated pm point.
            aRec = [];
            for iComp = 1:size(pmExpOtptTemp, 1)
                
                a = ismember(pmExpOtptTemp(iComp, :), pmEXPinptRaw, 'rows');
                aRec = [aRec; a];
                if a == 1
                    pmIdx = iComp;
                end
                
            end
            
            if any(aRec) == 1
                % if there is a repeated pm point, add 4 indices to new pm 
                % points and put the old pm point at the beginning.
                idxToAdd = 4;
                
                pmExpOtptSpecVal = obj.pmExpo.block.hhat(pmIdx, :);
                
                pmExpOtptTemp(pmIdx, :) = [];
                
                for iComp1 = 1:length(pmExpInptPmTemp)
                    b = ismember(pmExpOtptSpecVal, ...
                        pmExpInptPmTemp(iComp1, 2:3), 'rows');
                    if b == 1
                        pmExpOtptSpecIdx = pmExpInptPmTemp(iComp1, 1);
                    end
                end
                
                obj.pmExpo.block.hhat = [[pmExpOtptSpecIdx ...
                    pmExpOtptSpecVal]; ...
                    [(1:idxToAdd)' + length(pmEXPinptRaw) pmExpOtptTemp]];
                
            else
                % if there is no repeated point, add 5 indices.
                idxToAdd = 5;
                
                obj.pmExpo.block.hhat = ...
                    [(1:idxToAdd)' + length(pmEXPinptRaw) ...
                    obj.pmExpo.block.hhat];
                
            end
            
            % equip index, find refined block and perform grid to block.
            
            % NOTE: if only consider refined block, the number of added 
            % points do not need to be considered; however, if index is 
            % included, or total number of grid points is considered, 
            % then number of added points needs to be calculated. 
            % Principle: same size & same location block: +4; different size
            % block: +5.
            obj.pmExpo.temp.inpt = [obj.pmExpo.block.hat{iRec}; ...
                obj.pmExpo.block.hhat];
            obj.gridtoBlockwithIndx;
            
            % delete original block which needs to be refined, put final 
            % data together. pass value to a tmp var in case the 
            % origin (obj.pmExpo.block.hat) is modified.
            
            pmExpoPass = obj.pmExpo.block.hat;
            pmExpoPass(iRec) = [];
            obj.pmExpo.block.hhat = [pmExpoPass; obj.pmExpo.temp.otpt];
            
            % find the pm with indices in asending order.
            pmExpOtptPm = cell2mat(obj.pmExpo.block.hhat);
            pmExpOtptTemp = sortrows(pmExpOtptPm);
            obj.pmExpo.hhat = unique(pmExpOtptTemp, 'rows');
            obj.pmVal.hhat = 10 .^ obj.pmExpo.hhat(:, 2:3);
            obj.pmVal.hhat = [obj.pmExpo.hhat(:, 1) obj.pmVal.hhat];
            obj.pmVal.hat = 10 .^ obj.pmExpo.hat(:, 2:3);
            obj.pmVal.hat = [obj.pmExpo.hat(:, 1) obj.pmVal.hat];
            obj.no.pre.hhat = size(obj.pmVal.hhat, 1);
            obj.no.block.hhat = size(obj.pmExpo.block.hhat, 1);
        end
        
        %%
        obj = resptoErrPreCompSVDpartTimeImprovised(obj);
        obj = readINPgeo(obj);
        obj = NewmarkBetaReducedMethodOOP(obj, type);
        obj = gridtoBlockwithIndx(obj, type);
        obj = SVDoop(obj, type);
        obj = errStoretoCoefStore(obj, type);
        obj = resptoErrPreCompNoSVDpartTime(obj);
        obj = resptoErrPreCompSVDpartTime(obj)
        obj = refineGrid(obj, i_block);
        obj = lagItplCoeff(obj);
        obj = lagItplOtptSingle(obj, type);
        obj = inpolyItplOtpt(obj, type);
        obj = plotSurfGrid(obj, type, ...
            drawRow, drawCol, viewX, viewY, gridSwitch, axisLim);
        obj = plotGrid(obj, type);
        obj = plotMaxErrorDecay(obj, plotName);
        
    end
    
end


