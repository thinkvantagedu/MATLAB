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
        aba
    end
    
    properties (Dependent, Hidden)
        
        damMtx
        disInpt
        velInpt
        phiInit
        
    end
    
    methods
        
        function obj = beam(abaInpFile, masFile, damFile, stiFile, ...
                locStart, locEnd, INPname, domLengi, domBondi, ...
                domMid, trial, noIncl, noStruct, noMas, noDam, tMax, tStep, ...
                errLowBond, errMaxValInit, errRbCtrl, ...
                errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
                drawRow, drawCol)
            obj.aba.file = abaInpFile;
            
            obj.mas.file = masFile;
            obj.dam.file = damFile;
            obj.sti.file = stiFile;
            
            obj.str.locStart = locStart;
            obj.str.locEnd = locEnd;
            obj.INPname = INPname;
            
            obj.domBond.i = domBondi;
            obj.domLeng.i = domLengi;
            
            obj.pmVal.s.fix = 1;
            obj.pmVal.comb.trial = trial;
            
            obj.no.inc = noIncl;
            obj.no.struct = noStruct;
            obj.no.phy = noIncl + noStruct + noMas + noDam;
            obj.no.t_step = length((0:tStep:tMax));
            obj.no.Greedy = drawRow * drawCol;
            obj.no.nEnrich = 0;
            
            obj.time.step = tStep;
            obj.time.max = tMax;
            obj.phi.ident = [];
            obj.pmExpo.mid = domMid;
            
            obj.err.lowBond = errLowBond;
            obj.err.max.val = errMaxValInit;
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
        function [obj] = readMasMTX2DOF(obj, ndofPerNode)
            % Read and import mass matrix from Abaqus mas file.
            % works for both 2d and 3d.
            % Input:
            % obj.mas.file: Imported Abaqus mass file.
            % Output:
            % obj.mas.mtx: scalar mass matrix.
            % obj.no.dof: number of degrees of freedom.
            ASM = dlmread(obj.mas.file);
            Node_n = max(ASM(:,1));    %or max(ASM(:,3))
            ndof = Node_n * ndofPerNode;
            indI = zeros(length(ASM), 1);
            indJ = zeros(length(ASM), 1);
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
        function [obj] = readStiMTX2DOFBCMod(obj, ndofPerNode)
            % Read and import stiffness matrix from Abaqus sti file and
            % modify related values with boundary conditions.
            % works for both 2d and 3d.
            
            n = length(obj.sti.file);
            
            obj.sti.mtxCell = cell(n, 1);
            for in = 1:n
                if isnan(obj.sti.file{in}) == 0
                    
                    ASM = dlmread(obj.sti.file{in});
                    indI = zeros(length(ASM), 1);
                    indJ = zeros(length(ASM), 1);
                    Node_n = max(ASM(:, 1));    %or max(ASM(:,3))
                    ndof = Node_n * ndofPerNode;
                    
                    for ii=1:size(ASM, 1)
                        indI(ii) = ndofPerNode * (ASM(ii,1)-1) + ASM(ii,2);
                        indJ(ii) = ndofPerNode * (ASM(ii,3)-1) + ASM(ii,4);
                    end
                    M = sparse(indI, indJ, ASM(:, 5), ndof, ndof);
                    globalMBC = M' + M;
                    
                    for i_tran=1:length(M)
                        globalMBC(i_tran, i_tran) = ...
                            globalMBC(i_tran, i_tran) / 2;
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
            obj.no.node.mtx = obj.no.node.all - obj.no.node.inc;
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
            % vector = SVD(current exact solution -  previous approximation).
            % GramSchmidt is applied to the basis to ensure orthogonality.
            
            % new basis from error (phi * phi' * response).
            rbEnrich = obj.dis.rbEnrich - ...
                obj.phi.val * obj.phi.val' * obj.dis.rbEnrich;
            
            [u, s, ~] = svd(rbEnrich);
            
            if singularSwitch == 0 && ratioSwitch == 0
                phiEnrich = u(:, 1:nEnrich);
                phi_ = [obj.phi.val phiEnrich];
                obj.GramSchmidt(phi_);
                obj.phi.val = obj.phi.otpt;
                
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
                pm = [obj.pmVal.max obj.pmVal.s.fix];
                pm = num2cell(pm');
                stiCell = cellfun(@(u, v) u * v, obj.sti.mtxCell, pm, 'un', 0);
                k = sparse(obj.no.dof, obj.no.dof);
                for i = 1:length(stiCell)
                    k = k + stiCell{i};
                end
                f = obj.fce.val;
                vInpt = zeros(obj.no.dof, 1);
                uInpt = zeros(obj.no.dof, 1);
                obj.NewmarkBetaMethod(m, c, k, f, vInpt, uInpt);
                uOtpt = obj.dis.val;
                for i = 1:obj.no.dof
                    % reduced solution
                    phi_ = obj.phi.val;
                    phiEnrich = u(:, 1:i);
                    nEnrich = nEnrich + 1;
                    phi_ = [phi_ phiEnrich];
                    nphi = size(phi_, 2);
                    obj.GramSchmidt(phi_);
                    phi_ = obj.phi.otpt;
                    mr = phi_' * obj.mas.mtx * phi_;
                    cr = phi_' * obj.dam.mtx * phi_;
                    krc = cellfun(@(v) phi_' * v * phi_, ...
                        obj.sti.mtxCell, 'un', 0);
                    stiRcell = cellfun(@(u, v) u * v, krc, pm, 'un', 0);
                    kr = sparse(length(mr), length(mr));
                    for i = 1:length(stiRcell)
                        kr = kr + stiRcell{i};
                    end
                    fr = phi_' * obj.fce.val;
                    vrInpt = zeros(nphi, 1);
                    urInpt = zeros(nphi, 1);
                    obj.NewmarkBetaMethod(mr, cr, kr, fr, vrInpt, urInpt);
                    urOtpt = phi_ * obj.dis.val;
                    
                    relErr = norm(urOtpt - uOtpt, 'fro') / ...
                        norm(obj.dis.qoi.trial, 'fro');
                    if relErr <= egoal
                        break
                    end
                    
                end
                obj.phi.val = phi_;
                obj.no.nEnrich = [obj.no.nEnrich; nEnrich];
            end
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.phiAdd = nEnrich;
            
            obj.indicator.refine = 0;
            obj.indicator.enrich = 1;
            obj.countGreedy = obj.countGreedy + 1;
            
            obj.vel.re.inpt = sparse(obj.no.rb, 1);
            obj.dis.re.inpt = sparse(obj.no.rb, 1);
            
        end
        %%
        function obj = rbSingularInitial(obj, reductionRatio)
            % this method iteratively uses singular value to determine
            % how many basis vectors are needed in reduced basis.
            obj.no.nEnrich = 0;
            [u, s, ~] = svd(obj.dis.qoi.trial, 0);
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
            [rb, ~, ~] = svd(obj.dis.qoi.trial, 0);
            
            for i = 1:obj.no.dof
                
                phi_ = rb(:, 1:i);
                obj.no.nEnrich = i;
                mr = phi_' * obj.mas.mtx * phi_;
                cr = phi_' * obj.dam.mtx * phi_;
                kr = phi_' * obj.sti.trial * phi_;
                fr = phi_' * obj.fce.val;
                vr0 = zeros(i, 1);
                ur0 = zeros(i, 1);
                obj.NewmarkBetaMethod(mr, cr, kr, fr, vr0, ur0);
                reVarDis = obj.dis.val;
                ur = phi_ * reVarDis;
                relErr = norm(ur - obj.dis.qoi.trial, 'fro') / ...
                    norm(obj.dis.qoi.trial, 'fro');
                
                if relErr <= 1 - reductionRatio
                    break
                end
                
            end
            obj.phi.val = phi_;
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
                
                snap = obj.dis.trial;
                [phiVal, ~, ~] = svd(snap, 0);
                obj.phi.val = phiVal(:, 1:obj.err.rbCtrlTrialNo);
                obj.mas.re.mtx = obj.phi.val' * obj.mas.mtx * obj.phi.val;
                % here obj.sti.full is inherited from obj.exactSolution.
                obj.sti.re.mtx = obj.phi.val' * obj.sti.full * obj.phi.val;
                obj.dam.re.mtx = ...
                    sparse(length(obj.sti.re.mtx), length(obj.sti.re.mtx));
                
                obj.dis.re.inpt = sparse(obj.err.rbCtrlTrialNo, 1);
                obj.vel.re.inpt = sparse(obj.err.rbCtrlTrialNo, 1);
                
                obj.sti.reduce = obj.sti.re.mtx;
                obj.mas.reduce = obj.mas.re.mtx;
                obj.dam.reduce = obj.dam.re.mtx;
                obj.fce.pass = obj.fce.val;
                % 'rewRb' needs to be modified.
                obj = NewmarkBetaReducedMethodOOP(obj, 'reduced');
                obj.dis.errCtrl = obj.phi.val * obj.dis.reduce;
                
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
        function obj = exactSolution(obj, type, ...
                qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch, trialName)
            % this method computes exact solution at maximum error points.
            switch type
                case 'initial'
                    pmValcell = [obj.pmVal.i.trial'; obj.pmVal.s.fix];
                case 'Greedy'
                    pmValcell = [obj.pmVal.max'; obj.pmVal.s.fix];
            end
            if AbaqusSwitch == 0
                % use MATLAB Newmark code to obtain exact solutions.
                stiPre = sparse(obj.no.dof, obj.no.dof);
                for iSti = 1:obj.no.inc + 1
                    stiPre = stiPre + obj.sti.mtxCell{iSti} * pmValcell(iSti);
                end
                % compute trial solution
                obj.sti.full = stiPre;
                obj.fce.pass = obj.fce.val;
                obj.NewmarkBetaReducedMethodOOP('full');
            elseif AbaqusSwitch == 1
                % use Abaqus to obtain exact solutions.
                obj.abaqusStrInfo(trialName);
                % define the logarithm input for inclusion and matrix.
                pmI = obj.pmVal.i.trial';
                pmS = obj.pmVal.s.fix;
                % input parameter 0 indicates the force is not modified. 
                obj.abaqusJob(trialName, pmI, pmS, 0, 0);
                obj.abaqusOtpt;
            end
            
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
            obj.indicator.refine = 0;
            obj.indicator.enrich = 1;
            obj.resp.rv.store = cell(1, prod(obj.domLeng.i));
            
        end
        %%
        function obj = errPrepareRemainHats(obj)
            obj.err.store.max.hhat = [];
            obj.err.store.max.hat = [];
            obj.err.store.max.diff = [];
            obj.err.store.loc.hhat = [];
            obj.err.store.loc.hat = [];
            obj.err.store.loc.diff = [];
            obj.err.store.allSurf = {};
            obj.err.pre.hhat = cell(obj.no.pre.hhat, 6); % 6 cols in total,
            % 2 extra for the pyramid base shape cell elements, 1extra for
            % pm exponential values.
            obj.err.norm = zeros(1, 2);
            if obj.no.inc == 1
                obj.err.store.surf.hhat = zeros(obj.no.dom.discretisation, 1);
                obj.err.store.surf.hat = zeros(obj.no.dom.discretisation, 1);
            else
                obj.err.store.surf.hhat = zeros(obj.no.dom.discretisation);
                obj.err.store.surf.hat = zeros(obj.no.dom.discretisation);
            end
            % initialise maximum error
            obj.err.max = rmfield(obj.err.max, 'val');
            obj.err.max.val.hhat = 1;
        end
        %%
        function obj = errPrepareRemainOriginal(obj)
            
            obj.err.store.max = [];
            obj.err.store.loc = [];
            obj.err.store.allSurf = {};
            
        end
        %%
        function obj = errPrepareSetZero(obj)
            if obj.no.inc == 1
                obj.err.store.surf.diff = obj.err.setZ.sInc;
            else
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
            % This function performs interpolation with matrix inputs.
            % inptx, inpty are input x-y coordinate (the point to compute).
            % gridx, gridy are n by n matrices denotes x-y coordinates of
            % sample points (generated from meshgrid function). z are the
            % corresponding matrices of gridx, gridy, in a 2 by 2 cell
            % array. Notice gridx and gridy needs to be in clockwise or
            % anti-clockwise order, cannot be disordered.
            
            xstore = cell(1, 2);
            for i = 1:size(gridx, 1)
                % x vector must be a column vector
                x = gridx(i, :)';
                % z vector must be a column vector
                z = gridz(i, :)';
                
                p = [];
                
                x = num2cell(x);
                % interpolate for every parameter value j and add it to p
                [~, p_] = lagrange(obj.pmVal.iter{1}, x, z);
                p = [p; p_];
                
                % save curves in x direction
                xstore{i} = p;
                
            end
            
            y = gridy(:, 1);
            y = num2cell(y);
            % interpolate in y-direction
            for i = 1:length(xstore{1})
                z = cell(2, 1);
                for l = 1:length(y)
                    z(l) = xstore(l);
                end
                % interpolate for every parameter value j and add it to p
                [~, otpt_] = lagrange(obj.pmVal.iter{2}, y, z);
                obj.err.itpl.otpt = otpt_;
            end
            
        end
        %%
        function obj = resptoErrStore(obj)
            % this method takes stored responses and compute relative
            % error, store in a matrix to plot error response surfaces.
            resphhat = obj.resp.store.hhat;
            resphat = obj.resp.store.hat;
            errhhat = cellfun(@(v) norm(v, 'fro') / ...
                norm(obj.dis.qoi.trial, 'fro'), resphhat, 'un', 0);
            obj.err.store.surf.hhat = cell2mat(errhhat);
            errhat = cellfun(@(v) norm(v, 'fro') / ...
                norm(obj.dis.qoi.trial, 'fro'), resphat, 'un', 0);
            obj.err.store.surf.hat = cell2mat(errhat);
            
        end
        %%
        function obj = respStorePrepareRemain(obj, respSVDswitch, timeType)
            obj.resp.store.fce.hhat = cell(obj.no.pre.hhat, 1);
            obj.resp.store.all = cell(obj.no.pre.hhat, 3);
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
            
            if respSVDswitch == 1
                
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
            mtxAsemb(3:3 + obj.no.inc) = obj.sti.mtxCell;
            obj.asemb.imp.cel = cell(obj.no.phy, 1);
            
            if obj.indicator.refine == 0 && obj.indicator.enrich == 1
                % impulse is system matrices multiply reduced basis
                % vectors.
                obj.asemb.imp.cel = cellfun(@(v) v * obj.phi.val, ...
                    mtxAsemb, 'un', 0);
                obj.asemb.imp.apply = cell(2, 1);
                
                for iPhy = 1:obj.no.phy
                    for iTdiff = 1:2
                        % only generate responses regarding the newly added
                        % basis vectors.
                        for iRb = obj.no.rb - obj.no.phiAdd + 1:obj.no.rb
                            impMtx = sparse(obj.no.dof, obj.no.t_step);
                            impMtx(:, iTdiff) = impMtx(:, iTdiff) + ...
                                mtxAsemb{iPhy} * obj.phi.val(:, iRb);
                            obj.imp.store.mtx{iPhy, iTdiff, iRb} = impMtx;
                        end
                    end
                end
            end
        end
        %%
        function obj = respfromFce(obj, respSVDswitch, ...
                qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch, trialName)
            % only compute exact solutions regarding external force
            % when pm domain is refined.
            if obj.indicator.refine == 0 && obj.indicator.enrich == 1
                % if no refinement, only enrich, force related responses does
                % not change since it's not related to new basis vectors.
                for iPre = 1:obj.no.pre.hhat
                    pmValCell = [obj.pmVal.hhat(iPre, 2:obj.no.inc + 1) ...
                        obj.pmVal.s.fix];
                    if AbaqusSwitch == 0
                        % use MATLAB Newmark code to obtain exact solutions.
                        stiPre = sparse(obj.no.dof, obj.no.dof);
                        for iSti = 1:obj.no.inc + 1
                            stiPre = stiPre + obj.sti.mtxCell{iSti} * ...
                                pmValCell(iSti);
                        end
                        obj.sti.full = stiPre;
                        obj.fce.pass = obj.fce.val;
                        obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                    elseif AbaqusSwitch == 1
                        % use Abaqus to obtain exact solutions.
                        pmI = obj.pmVal.hhat(iPre, 2:obj.no.inc + 1);
                        pmS = obj.pmVal.s.fix;
                        % input parameter 0 indicates the force is not modified 
                        % thus stick to original external force (if not 
                        % modifying force, use original inp file).
                        obj.abaqusJob(trialName, pmI, pmS, 0, 0);
                        obj.abaqusOtpt;
                    end
                    if respSVDswitch == 0
                        if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                            obj.resp.store.fce.hhat{iPre} = obj.dis.full(:);
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                            dis_ = obj.dis.full(:, obj.qoi.t);
                            obj.resp.store.fce.hhat{iPre} = dis_(:);
                            
                        elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                            dis_ = obj.dis.full(obj.qoi.dof, :);
                            obj.resp.store.fce.hhat{iPre} = dis_(:);
                            
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                            dis_ = obj.dis.full(obj.qoi.dof, obj.qoi.t);
                            obj.resp.store.fce.hhat{iPre} = dis_(:);
                        end
                    elseif respSVDswitch == 1
                        % if SVD is not on-the-fly, comment this.
                        [uFcel, uFceSig, uFcer] = ...
                            svd(obj.dis.full, 0);
%                         uFcel = uFcel(:, 1:obj.no.respSVD);
%                         uFceSig = uFceSig(1:obj.no.respSVD, 1:obj.no.respSVD);
%                         uFcer = uFcer(:, 1:obj.no.respSVD);
                        obj.resp.store.fce.hhat{iPre} = ...
                            [{uFcel}; {uFceSig}; {uFcer}];
                    end
                end
                
            elseif obj.indicator.refine == 1 && ...
                    obj.indicator.enrich == 0
                % if refine, no enrichment, only compute force related
                % responses regarding the new interpolation samples.
                for iPre = 1:obj.no.itplAdd
                    pmValCell = [obj.pmVal.add(iPre, 2:obj.no.inc + 1) ...
                        obj.pmVal.s.fix];
                    if AbaqusSwitch == 0
                        % use MATLAB Newmark code to obtain exact solutions.
                        stiPre = sparse(obj.no.dof, obj.no.dof);
                        for iSti = 1:obj.no.inc + 1
                            stiPre = stiPre + obj.sti.mtxCell{iSti} * ...
                                pmValCell(iSti);
                        end
                        obj.sti.full = stiPre;
                        obj.fce.pass = obj.fce.val;
                        obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                    elseif AbaqusSwitch == 1
                        % use Abaqus to obtain exact solutions.
                    end
                    if respSVDswitch == 0
                        if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                            obj.resp.store.fce.hhat...
                                {obj.no.itplEx + iPre} = obj.dis.full(:);
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                            obj.resp.store.fce.hhat...
                                {obj.no.itplEx + iPre} = ...
                                obj.dis.full(:, obj.qoi.t);
                        elseif qoiSwitchTime == 0 && qoiSwitchSpace == 1
                            obj.resp.store.fce.hhat...
                                {obj.no.itplEx + iPre} = ...
                                obj.dis.full(obj.qoi.dof, :);
                        elseif qoiSwitchTime == 1 && qoiSwitchSpace == 1
                            obj.resp.store.fce.hhat...
                                {obj.no.itplEx + iPre} = ...
                                obj.dis.full(obj.qoi.dof, obj.qoi.t);
                        end
                    elseif respSVDswitch == 1
                        % if SVD is not on-the-fly, comment this.
                        [uFcel, uFceSig, uFcer] = ...
                            svd(obj.dis.full, 'econ');
                        uFcel = uFcel(:, 1:obj.no.respSVD);
                        uFceSig = uFceSig(1:obj.no.respSVD, 1:obj.no.respSVD);
                        uFcer = uFcer(:, 1:obj.no.respSVD);
                        obj.resp.store.fce.hhat{obj.no.itplEx + iPre} = ...
                            [{uFcel}; {uFceSig}; {uFcer}];
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
        function obj = respImpPartTime(obj, iPre, iPhy, nrb)
            pmValI = [obj.pmVal.hhat(iPre, 2:obj.no.inc + 1) obj.pmVal.s.fix];
            stiPre = sparse(obj.no.dof, obj.no.dof);
            for i = 1:obj.no.inc + 1
                stiPre = stiPre + obj.sti.mtxCell{i} * pmValI(i);
            end
            obj.sti.pre = stiPre;
            for i_tdiff = 1:2
                
                impPass = obj.asemb.imp.apply{i_tdiff};
                obj.sti.full = obj.sti.pre;
                obj.fce.pass = impPass;
                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                disPass = obj.dis.full;
                obj.resp.store.pm.hhat(iPre, iPhy, i_tdiff, nrb) = {disPass};
                
            end
            
        end
        %%
        function obj = respImpPartTimeSVD(obj, iPre, iPhy, nRb, nSvd)
            pmValI = [obj.pmVal.hhat(iPre, 2:obj.no.inc + 1) obj.pmVal.s.fix];
            stiPre = sparse(obj.no.dof, obj.no.dof);
            for i = 1:obj.no.inc + 1
                stiPre = stiPre + obj.sti.mtxCell{i} * pmValI(i);
            end
            obj.sti.pre = stiPre;
            for iTdiff = 1:2
                
                impPass = obj.asemb.imp.apply{iTdiff};
                obj.sti.full = obj.sti.pre;
                obj.fce.pass = impPass;
                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                [disl, dissig, disr] = svd(obj.dis.full, 'econ');
                disl = disl(:, 1:nSvd);
                dissig = dissig(1:nSvd, 1:nSvd);
                disr = disr(:, 1:nSvd);
                disl = disl * dissig;
                % change sign for responses.
                obj.resp.store.pm.hhat{iPre, iPhy, iTdiff, nRb} = ...
                    [{-disl}; {disr}];
                
            end
            
        end
        %% 
        function obj = respTdiffComputation1(obj, respSVDswitch, ...
                AbaqusSwitch, trialName)
            if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                nPre = obj.no.pre.hhat;
                nRbInit = obj.no.rb - obj.no.phiAdd + 1;
            elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                nPre = obj.no.itplAdd;
                nRbInit = 1;
            end
            nPhy = obj.no.phy;
            nRb = obj.no.rb;
            for iPre = 1:nPre
                if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                    pmValCell = [obj.pmVal.hhat(iPre, 2:obj.no.inc + 1)...
                        obj.pmVal.s.fix];
                elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                    pmValCell = [obj.pmVal.add(iPre, 2:obj.no.inc + 1)...
                        obj.pmVal.s.fix];
                end
                for iPhy = 1:nPhy
                    for iTdiff = 1:2
                        % obj.indicator.tDiff works in abaqusJob.
                        obj.indicator.tDiff = iTdiff;
                        for iRb = nRbInit:nRb
                            impPass = obj.imp.store.mtx{iPhy, iTdiff, iRb};
                            obj.fce.pass = impPass;
                            if AbaqusSwitch == 0
                                stiPre = sparse(obj.no.dof, obj.no.dof);
                                for iSti = 1:obj.no.inc + 1
                                    stiPre = stiPre + ...
                                        obj.sti.mtxCell{iSti} * ...
                                        pmValCell(iSti);
                                end
                                obj.sti.full = stiPre;
                                obj = NewmarkBetaReducedMethodOOP...
                                    (obj, 'full');
                                
                            elseif AbaqusSwitch == 1
                                % use Abaqus to obtain exact solutions.
                                pmI = obj.pmVal.hhat...
                                    (iPre, 2:obj.no.inc + 1);
                                pmS = obj.pmVal.s.fix;
                                % input parameter 1 indicates the force is
                                % modified to the impulse.
                                obj.abaqusJob(trialName, pmI, pmS, ...
                                    1, 'impulse');
                                obj.abaqusOtpt;
                            end
                            if respSVDswitch == 0
                                if obj.indicator.enrich == 1 && ...
                                        obj.indicator.refine == 0
                                    iPreRef = iPre;
                                elseif obj.indicator.enrich == 0 && ...
                                        obj.indicator.refine == 1
                                    iPreRef = obj.no.itplEx + iPre;
                                end
                                obj.resp.store.tDiff...
                                    (iPreRef, iPhy, iTdiff, iRb) = ...
                                    {obj.dis.full};
                            elseif respSVDswitch == 1
                                [ul, usig, ur] = svd(obj.dis.full, 0);
                                ul = ul(:, 1:obj.no.respSVD);
                                usig = usig(1:obj.no.respSVD, ...
                                    1:obj.no.respSVD);
                                ur = ur(:, 1:obj.no.respSVD);
                                if obj.indicator.enrich == 1 && ...
                                        obj.indicator.refine == 0
                                    iPreRef = iPre;
                                elseif obj.indicator.enrich == 0 && ...
                                        obj.indicator.refine == 1
                                    iPreRef = obj.no.itplEx + iPre;
                                end
                                obj.resp.store.tDiff...
                                    {iPreRef, iPhy, iTdiff, iRb} = ...
                                    {ul; usig; ur};
                            end
                        end
                    end
                end
            end
        end
        %%
        function obj = respTdiffComputation(obj, respSVDswitch, ...
                AbaqusSwitch, trialName)
            % this method compute 2 responses for each interpolation
            % sample, each affine term, each basis vector.
            % only compute responses regarding newly added basis vectors,
            % but store all responses regarding all basis vectors.
            
            if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                % if no refinement, enrich basis: compute the new exact
                % solutions regarding the newly added basis vectors.
                for iPre = 1:obj.no.pre.hhat
                    for iPhy = 1:obj.no.phy
                        for iTdiff = 1:2
                            obj.indicator.tDiff = iTdiff;
                            % only compute exact solutions regarding the
                            % newly added basis vectors.
                            for iRb = obj.no.rb - obj.no.phiAdd + 1:obj.no.rb
                                impPass = obj.imp.store.mtx{iPhy, iTdiff, iRb};
                                pmValCell = ...
                                    [obj.pmVal.hhat(iPre, 2:obj.no.inc + 1)...
                                    obj.pmVal.s.fix];
                                obj.fce.pass = impPass;
                                if AbaqusSwitch == 0
                                    stiPre = sparse(obj.no.dof, obj.no.dof);
                                    for iSti = 1:obj.no.inc + 1
                                        stiPre = stiPre + ...
                                            obj.sti.mtxCell{iSti} * ...
                                            pmValCell(iSti);
                                    end
                                    obj.sti.full = stiPre;
                                    obj = NewmarkBetaReducedMethodOOP...
                                        (obj, 'full');
                                    
                                elseif AbaqusSwitch == 1
                                    % use Abaqus to obtain exact solutions.
                                    pmI = obj.pmVal.hhat...
                                        (iPre, 2:obj.no.inc + 1);
                                    pmS = obj.pmVal.s.fix;
                                    % input parameter 1 indicates the force is 
                                    % modified to the impulse.
                                    obj.abaqusJob(trialName, pmI, pmS, ...
                                        1, 'impulse');
                                    obj.abaqusOtpt;
                                end
                                if respSVDswitch == 0
                                    obj.resp.store.tDiff...
                                        (iPre, iPhy, iTdiff, iRb) = ...
                                        {obj.dis.full};
                                elseif respSVDswitch == 1
                                    [ul, usig, ur] = svd(obj.dis.full, 0);
                                    ul = ul(:, 1:obj.no.respSVD);
                                    usig = usig(1:obj.no.respSVD, ...
                                        1:obj.no.respSVD);
                                    ur = ur(:, 1:obj.no.respSVD);
                                    obj.resp.store.tDiff...
                                        {iPre, iPhy, iTdiff, iRb} = ...
                                        {ul; usig; ur};
                                end
                            end
                        end
                    end
                end
                
            elseif obj.indicator.refine == 1 && ...
                    obj.indicator.enrich == 0
                % if refine, no enrichment, compute exact solutions
                % regarding all basis vectors but only for the newly added
                % interpolation samples.
                for iPre = 1:obj.no.itplAdd
                    for iPhy = 1:obj.no.phy
                        for iTdiff = 1:2
                            obj.indicator.tDiff = iTdiff;
                            % compute exact solutions reagrding all reduced
                            % basis vectors.
                            for iRb = 1:obj.no.rb
                                impPass = obj.imp.store.mtx{iPhy, iTdiff, iRb};
                                pmValCell = ...
                                    [obj.pmVal.add(iPre, 2:obj.no.inc + 1)...
                                    obj.pmVal.s.fix];
                                obj.fce.pass = impPass;
                                if AbaqusSwitch == 0
                                    stiPre = sparse(obj.no.dof, obj.no.dof);
                                    for iSti = 1:obj.no.inc + 1
                                        stiPre = stiPre + ...
                                            obj.sti.mtxCell{iSti} * ...
                                            pmValCell(iSti);
                                    end
                                    obj.sti.full = stiPre;
                                    obj = NewmarkBetaReducedMethodOOP...
                                        (obj, 'full');
                                elseif AbaqusSwitch == 1
                                    % use Abaqus to obtain exact solutions.
                                    pmI = obj.pmVal.add...
                                        (iPre, 2:obj.no.inc + 1);
                                    pmS = obj.pmVal.s.fix;
                                    % input parameter 1 indicates the force is 
                                    % modified to the impulse.
                                    obj.abaqusJob(trialName, pmI, pmS, ...
                                        1, 'impulse');
                                    obj.abaqusOtpt;
                                end
                                if respSVDswitch == 0
                                    obj.resp.store.tDiff...
                                        (obj.no.itplEx + iPre, ...
                                        iPhy, iTdiff, iRb) = {obj.dis.full};
                                elseif respSVDswitch == 1
                                    [ul, usig, ur] = svd(obj.dis.full);
                                    ul = ul(:, 1:obj.no.respSVD);
                                    usig = usig(1:obj.no.respSVD, ...
                                        1:obj.no.respSVD);
                                    ur = ur(:, 1:obj.no.respSVD);
                                    obj.resp.store.tDiff...
                                        {obj.no.itplEx + iPre, ...
                                        iPhy, iTdiff, iRb} = ...
                                        {ul; usig; ur};
                                end
                            end
                        end
                    end
                end
            end
        end
        
        %%
        function obj = respTimeShift...
                (obj, qoiSwitchTime, qoiSwitchSpace, respSVDswitch)
            % this method shifts the responses in time.
            for iPre = 1:obj.no.pre.hhat
                for iPhy = 1:obj.no.phy
                    for iT = 1:obj.no.t_step
                        for iRb = 1:obj.no.rb
                            if iT == 1
                                % conditions for quantity of interest
                                if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb};
                                    
                                elseif qoiSwitchTime == 1 && ...
                                        qoiSwitchSpace == 0
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}(:, obj.qoi.t);
                                    
                                elseif qoiSwitchTime == 0 && ...
                                        qoiSwitchSpace == 1
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}(obj.qoi.dof, :);
                                    
                                elseif qoiSwitchTime == 1 && ...
                                        qoiSwitchSpace == 1
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}...
                                        (obj.qoi.dof, obj.qoi.t);
                                    
                                end
                                respQoi = respQoi(:);
                                obj.resp.store.pm.hhat(iPre, iPhy, 1, iRb) ...
                                    = {respQoi};
                                
                            else
                                
                                if respSVDswitch == 0
                                    storePmZeros = zeros(obj.no.dof, iT - 2);
                                    storePmNonZeros = ...
                                        obj.resp.store.tDiff...
                                        {iPre, iPhy, 2, iRb}...
                                        (:, 1:obj.no.t_step - iT + 2);
                                    storePmAsemb = ...
                                        [storePmZeros storePmNonZeros];
                                    if qoiSwitchTime == 0 && ...
                                            qoiSwitchSpace == 0
                                        storePmQoi = storePmAsemb;
                                        
                                    elseif qoiSwitchTime == 1 && ...
                                            qoiSwitchSpace == 0
                                        storePmQoi = storePmAsemb(:, obj.qoi.t);
                                        
                                    elseif qoiSwitchTime == 0 && ...
                                            qoiSwitchSpace == 1
                                        storePmQoi = ...
                                            storePmAsemb(obj.qoi.dof, :);
                                        
                                    elseif qoiSwitchTime == 1 && ...
                                            qoiSwitchSpace == 1
                                        storePmQoi = storePmAsemb...
                                            (obj.qoi.dof, obj.qoi.t);
                                        
                                    end
                                    
                                    obj.resp.store.pm.hhat...
                                        (iPre, iPhy, iT, iRb)...
                                        = {storePmQoi(:)};
                                elseif respSVDswitch == 1
                                    % only shift the right singular
                                    % vectors, if recast the displacements,
                                    % fro norm of the recast should match
                                    % original displacements.
                                    storePmZeros = ...
                                        zeros(obj.no.respSVD, iT - 2);
                                    store_ = obj.resp.store.tDiff...
                                        {iPre, iPhy, 2, iRb}{3};
                                    store_ = store_';
                                    storePmNonZeros = store_...
                                        (:, 1:obj.no.t_step - iT + 2);
                                    storePmL = obj.resp.store.tDiff...
                                        {iPre, iPhy, 2, iRb}{1};
                                    storePmSig = obj.resp.store.tDiff...
                                        {iPre, iPhy, 2, iRb}{2};
                                    storePmR = ...
                                        [storePmZeros storePmNonZeros]';
                                    obj.resp.store.pm.hhat...
                                        {iPre, iPhy, iT, iRb}...
                                        = {storePmL; storePmSig; storePmR};
                                end
                            end
                        end
                    end
                end
            end
        end
        %%
        function obj = respImpAllTime(obj, iPre, iPhy, nRb)
            if obj.indicator.refine == 0
                obj.resp.store.pm.tdiff = cell(2, 1);
                pmValI = [obj.pmVal.hhat(iPre, 2:obj.no.inc + 1) ...
                    obj.pmVal.s.fix];
                stiPre = sparse(obj.no.dof, obj.no.dof);
                for i = 1:obj.no.inc + 1
                    stiPre = stiPre + obj.sti.mtxCell{i} * pmValI(i);
                end
                
                for iTdiff = 1:2
                    impPass = obj.asemb.imp.apply{iTdiff};
                    obj.sti.full = stiPre;
                    obj.fce.pass = impPass;
                    obj = NewmarkBetaReducedMethodOOP(obj, 'full');
                    obj.resp.store.pm.tdiff(iTdiff) = {obj.dis.full};
                    
                end
                
                for iTall = 1:obj.no.t_step
                    
                    if iTall == 1
                        obj.resp.store.pm.hhat(iPre, iPhy, 1, nRb) = ...
                            {obj.resp.store.pm.tdiff{1}(:)};
                    else
                        storePmZeros = zeros(obj.no.dof, iTall - 2);
                        storePmNonZeros = obj.resp.storePm.tdiff{2}...
                            (:, 1:obj.no.t_step - iTall + 2);
                        storePmAsemb = [storePmZeros storePmNonZeros];
                        obj.resp.store.pm.hhat(iPre, iPhy, iTall, ...
                            nRb) = {storePmAsemb(:)};
                    end
                    
                end
            end
        end
        %%
        function obj = resptoErrPreCompAllTimeMatrix...
                (obj, respSVDswitch, rvSvdSwitch)
            % CHANGE SIGN in this method!
            % here the index follows the refind grid sequence, not a
            % sequencial sequence.
            % this method compute eTe, results in a square full symmetric
            % matrix, to be interpolated.
            % reason of using eTe is size of eTe is decided by nt * nj *
            % nr. At least this is not related to nd. Cannot use anyting
            % relate to nd.
            if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                % indicator for non-zero part of eTe.
                obj.indicator.nonzeroi = [];
                
                % if refine = 0, enrich = 1, compute the newly added basis
                % vectors for all interpolation samples.
                for iPre = 1:obj.no.pre.hhat
                    
                    obj.err.pre.hhat(iPre, 1) = {iPre};
                    obj.err.pre.hhat(iPre, 2) = {obj.pmExpo.hhat(iPre, 2)};
                    % extract rsponse vectors regarding the newly added
                    % basis vectors for each interpolation sample.
                    respPmPass = obj.resp.store.pm.hhat(iPre, :, :, ...
                        obj.no.rb - obj.no.phiAdd + 1 : end);
                    
                    if respSVDswitch == 0
                        % respCol changes respPmPass from nD to 2D.
                        % respPmPass has DIM(ni, nf, nt, nr). respColaligns
                        % in the order of (nf, nt, nr), i.e. loop nf first,
                        % then nt, nr.
                        respCol = sparse(cat(2, respPmPass{:}));
                        % change sign here.
                        if obj.countGreedy == 1
                            respCol = [obj.resp.store.fce.hhat{iPre} -respCol];
                        else
                            respCol = -respCol;
                        end
                        obj.resp.store.all(iPre, 1) = {iPre};
                        obj.resp.store.all(iPre, 2) = ...
                            {obj.pmExpo.hhat(iPre, 2)};
                        obj.resp.store.all{iPre, 3} = ...
                            [obj.resp.store.all{iPre, 3} respCol];
                        respAllCol = obj.resp.store.all{iPre, 3};
                        if rvSvdSwitch == 1
                            respTrans_ = respAllCol * obj.resp.rv.L;
                            respTrans = respTrans_' * respTrans_;
                        elseif rvSvdSwitch == 0
                            respTrans = respAllCol' * respAllCol;
                        end
                        obj.err.pre.hhat(iPre, 5) = {respTrans};
                    elseif respSVDswitch == 1
                        % reshape multi dim cell to 2d cell array.
                        respCol = reshape(respPmPass, [1, numel(respPmPass)]);
                        if obj.countGreedy == 1
                            % cellfun in cellfun to apply minus to cell in
                            % cell. Align in column.
                            respCol = [obj.resp.store.fce.hhat(iPre) ...
                                cellfun(@(x) cellfun(@uminus, x, 'un', 0), ...
                                respCol, 'un', 0)]';
                        else
                            respCol = cellfun(@(x) ...
                                cellfun(@uminus, x, 'un', 0), respCol, 'un', 0);
                            respCol = respCol';
                        end
                        
                        obj.resp.store.all(iPre, 1) = {iPre};
                        obj.resp.store.all(iPre, 2) = ...
                            {obj.pmExpo.hhat(iPre, 2)};
                        obj.resp.store.all{iPre, 3} = ...
                            [obj.resp.store.all{iPre, 3}; respCol];
                        respAllCol = obj.resp.store.all{iPre, 3};
                        respTrans = zeros(numel(respAllCol));
                        % trace(uiTuj) = trace(vri*sigi*vliT*vlj*sigj*vrjT).
                        for iTr = 1:numel(respAllCol)
                            u1 = respAllCol{iTr};
                            for jTr = iTr:numel(respAllCol)
                                u2 = respAllCol{jTr};
                                respTrans(iTr, jTr) = ...
                                    trace(u1{3} * u1{2}' * u1{1}' * ...
                                    u2{1} * u2{2} * u2{3}');
                            end
                        end
                        % reconstruct the upper triangular matrix back to full.
                        respTrans = reConstruct(respTrans);
                        obj.err.pre.hhat(iPre, 5) = {respTrans};
                    end
                end
                % compute uiTui+1 and store in the last column of
                % obj.err.pre.hhat.
                respStoretoTrans = obj.resp.store.all;
                obj.uiTujSort(respStoretoTrans, rvSvdSwitch, respSVDswitch);
                obj.err.pre.hhat(:, end) = obj.err.pre.trans(:, 3);
            elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                % if refine = 1, enrich = 0, compute the newly added
                % interpolation samples for all basis vectors.
                obj.resp.store.all(obj.no.itplEx + 1:obj.no.pre.hhat, :) = ...
                    cell(obj.no.itplAdd, 3);
                
                
                
                
                
                
                
                
                for iPre = 1:obj.no.itplAdd
                    
                    obj.err.pre.hhat(obj.no.itplEx + iPre, 1) = ...
                        {obj.no.itplEx + iPre};
                    obj.err.pre.hhat(obj.no.itplEx + iPre, 2) = ...
                        {obj.pmExpo.hhat(obj.no.itplEx + iPre, 2)};
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    respPmPass = obj.resp.store.pm.hhat...
                        (obj.no.itplEx + iPre, :, :, :);
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    % if refined, force responses are also refined,
                    % therefore add the newly added force response to pm
                    % responses.
                    if respSVDswitch == 0
                        respCol = sparse(cat(2, respPmPass{:}));
                        
                        
                        
                        
                        
                        
                        
                        respCol = [obj.resp.store.fce.hhat{obj.no.itplEx + ...
                            iPre}(:) -respCol];
                        
                        
                        
                        
                        
                        
                        
                        obj.resp.store.all(obj.no.itplEx + iPre, 1) = ...
                            {obj.no.itplEx + iPre};
                        obj.resp.store.all(obj.no.itplEx + iPre, 2) = ...
                            {obj.pmExpo.hhat(obj.no.itplEx + iPre, 2)};
                        obj.resp.store.all{obj.no.itplEx + iPre, 3} = ...
                            [obj.resp.store.all{obj.no.itplEx + iPre, 3} ...
                            respCol];
                        respAllCol = ...
                            obj.resp.store.all{obj.no.itplEx + iPre, 3};
                        if rvSvdSwitch == 1
                            respTrans_ = respAllCol * obj.resp.rv.L;
                            respTrans = respTrans_' * respTrans_;
                        elseif rvSvdSwitch == 0
                            respTrans = respAllCol' * respAllCol;
                        end
                        obj.err.pre.hhat(obj.no.itplEx + iPre, 5) = {respTrans};
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    elseif respSVDswitch == 1
                        % reshape multi dim cell to 2d cell array.
                        respCol = reshape(respPmPass, [1, numel(respPmPass)]);
                        if obj.countGreedy == 1
                            resp_ = obj.resp.store.fce.hhat...
                                (obj.no.itplEx + iPre);
                            respCol = [resp_ ...
                                cellfun(@(x) cellfun(@uminus, x, 'un', 0), ...
                                respCol, 'un', 0)]';
                        else
                            respCol = cellfun(@(x) ...
                                cellfun(@uminus, x, 'un', 0), respCol, 'un', 0);
                            respCol = respCol';
                        end
                        obj.resp.store.all(obj.no.itplEx + iPre, 1) = ...
                            {obj.no.itplEx + iPre};
                        obj.resp.store.all(obj.no.itplEx + iPre, 2) = ...
                            {obj.pmExpo.hhat(obj.no.itplEx + iPre, 2)};
                        obj.resp.store.all{obj.no.itplEx + iPre, 3} = ...
                            [obj.resp.store.all{obj.no.itplEx + iPre, 3}; ...
                            respCol];
                        respAllCol = ...
                            obj.resp.store.all{obj.no.itplEx + iPre, 3};
                        respTrans = zeros(numel(respAllCol));
                        % trace(uiTuj) = trace(vri*sigi*vliT*vlj*sigj*vrjT).
                        for i = 1:numel(respAllCol)
                            u1 = respAllCol{i};
                            for j = i:numel(respAllCol)
                                u2 = respAllCol{j};
                                respTrans(i, j) = ...
                                    trace(u1{3} * u1{2}' * u1{1}' * ...
                                    u2{1} * u2{2} * u2{3}');
                            end
                        end
                        % reconstruct the upper triangular matrix back to full.
                        respTrans = reConstruct(respTrans);
                        obj.err.pre.hhat(obj.no.itplEx + iPre, 5) = {respTrans};
                    end
                end
                % compute uiTui+1 and store in the last column of
                % obj.err.pre.hhat.
                respStoretoTrans = obj.resp.store.all;
                obj.uiTujSort(respStoretoTrans, rvSvdSwitch, respSVDswitch);
                obj.err.pre.hhat(:, end) = obj.err.pre.trans(:, 3);
                
                
                
                
                
                
                
                
                
            end
            % the 5th column of obj.err.pre.hat is inherited from the first
            % nhat rows of obj.err.pre.hhat. the 6th column is a recalculation
            % using uiTui+1.
            obj.err.pre.hat(1:obj.no.pre.hat, 1:5) = ...
                obj.err.pre.hhat(1:obj.no.pre.hat, 1:5);
            respStoretoTrans = obj.resp.store.all(1:obj.no.pre.hat, :);
            obj.uiTujSort(respStoretoTrans, rvSvdSwitch, respSVDswitch);
            obj.err.pre.hat(:, 6) = obj.err.pre.trans(:, 3);
            
        end
        %%
        function obj = uiTujSort(obj, respStoreInpt, rvSvdSwitch, respSVDswitch)
            % sort stored displacements, perform uiTui+1, then sort back to
            % previous order, put in the last column of obj.err.pre.hhat,
            % to be ready to be interpolated.
            
            % sort according to the 2nd col of element, which is pm exp value.
            respStoreSort = sortrows(respStoreInpt, 2);
            % a temp cell to store uiTui+1, should contain a void
            % after filling.
            respStoreCell_ = cell(size(respStoreSort, 1), 3);
            for iPre = 1:size(respStoreSort, 1)
                % respStoreSort_ should contain n-1 uiTui+1 matrix element
                %  and 1 void element.
                if iPre < size(respStoreSort, 1)
                    if respSVDswitch == 0
                        respTrans = respStoreSort{iPre, 3}' * ...
                            respStoreSort{iPre + 1, 3};
                        if rvSvdSwitch == 0
                            respTransSorttoStore = respTrans;
                        elseif rvSvdSwitch == 1
                            respTransSorttoStore = ...
                                obj.resp.rv.L' * respStoreSort{iPre, 3}' * ...
                                respStoreSort{iPre + 1, 3} * obj.resp.rv.L;
                        end
                    elseif respSVDswitch == 1
                        
                        respSVD = respStoreSort{iPre, 3};
                        respSVDp = respStoreSort{iPre + 1, 3};
                        respTrans = zeros(numel(respSVD));
                        % trace(uiTuj) = trace(vri*sigi*vliT*vlj*sigj*vrjT).
                        % here j cannot start from i, because respTrans is
                        % not symmetric. 
                        for i = 1:numel(respSVD)
                            u1 = respSVD{i};
                            for j = 1:numel(respSVD)
                                u2 = respSVDp{j};
                                respTrans(i, j) = ...
                                    trace(u1{3} * u1{2}' * u1{1}' * ...
                                    u2{1} * u2{2} * u2{3}');
                            end
                        end
                        respTransSorttoStore = respTrans;
                    end
                elseif iPre == size(respStoreSort, 1)
                    respTransSorttoStore = [];
                end
                respStoreCell_(iPre, 1) = {respStoreSort{iPre, 1}};
                respStoreCell_(iPre, 2) = {respStoreSort{iPre, 2}};
                respStoreCell_(iPre, 3) = {respTransSorttoStore};
            end
            obj.err.pre.trans = sortrows(respStoreCell_, 1);
        end
        %%
        function obj = resptoErrPreCompPartTime(obj, qoiSwitchTime, ~)
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
            blk_ = cell(obj.no.rb, obj.no.rb);
            cellTri_ = cell(nWidth * nWidth, 1);
            respCell = cell(1);
            
            for iPre = 1:obj.no.pre.hhat
                
                obj.err.pre.hhat(iPre, 1) = {iPre};
                obj.err.pre.hhat(iPre, 2) = {obj.pmExpo.hhat(iPre, 2)};
                respPmPass = obj.resp.store.tDiff(iPre, :, :, :);
                respPre_ = cellfun(@(v) -v, respPmPass, 'un', 0);
                respFce = zeros(obj.no.dof, obj.no.t_step);
                respFce_ = obj.resp.store.fce.hhat{iPre};
                
                if qoiSwitchTime == 1
                    
                    respFce_ = reshape(respFce_, ...
                        [obj.no.dof, length(obj.qoi.t)]);
                    for i = 1:length(obj.qoi.t)
                        respFce(:, obj.qoi.t(i)) = ...
                            respFce(:, obj.qoi.t(i)) + respFce_(:, i);
                    end
                end
                
                respPre_ = cellfun(@(v) v(:), respPre_, 'un', 0);
                respPre_ = [respPre_{:}];
                
                for i = 1:obj.no.rb * 2
                    respCell(i) = {respPre_(:, (i - 1) * obj.no.phy + 1:...
                        i * obj.no.phy)};
                end
                
                respCell(1) = {[respFce(:) respCell{1}]};
                
                respCell = reshape(respCell, [2, obj.no.rb]);
                
                respFixY = respCell(1, :);
                respFixN = respCell(2, :);
                
                for irb = 1:obj.no.rb
                    for jrb = irb:obj.no.rb
                        cell_ = cell(1);
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
                                    cell_(counter) = {respT1' * respT2};
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
                                    cell_(counter) = {respT1' * respT2};
                                    counter = counter + 1;
                                end
                            end
                        end
                        if irb == jrb
                            % use indb to form the upper triangular cell
                            % block
                            for i = 1:nWidth * nWidth
                                if indb(i) ~= 0
                                    cellTri_{i} = cell_{indb(i)};
                                end
                            end
                            cellTri_ = reshape(cellTri_, ...
                                [nWidth, nWidth]);
                            
                            blk_(irb, jrb) = {cellTri_};
                        elseif irb ~= jrb
                            % put cells into square block, then
                            % transpose.
                            cellSq_ = reshape(cell_, ...
                                [obj.no.t_step, obj.no.t_step]);
                            cellSq_ = cellSq_';
                            blk_(irb, jrb) = {cellSq_};
                        end
                    end
                end
                
                blkExp_ = cell(obj.no.rb * obj.no.t_step, ...
                    obj.no.rb * obj.no.t_step);
                for i = 1:obj.no.rb
                    for j = 1:obj.no.rb
                        if i <= j
                            blkExp_((i - 1) * obj.no.t_step + 1 : ...
                                i * obj.no.t_step, ...
                                (j - 1) * obj.no.t_step + 1 : ...
                                j * obj.no.t_step) = blk_{i, j};
                        else
                            blkExp_((i - 1) * obj.no.t_step + 1 : ...
                                i * obj.no.t_step, ...
                                (j - 1) * obj.no.t_step + 1 : ...
                                j * obj.no.t_step) = cell(1);
                        end
                    end
                end
                idx = cellfun('isempty', blkExp_);
                c = cellfun(@transpose, blkExp_.', 'un', 0);
                blkExp_(idx) = c(idx);
                
                eTe = triu(cell2mat(blkExp_));
                
                if iPre == 1
                    
                    for i = 1:size(eTe, 2)
                        obj.indicator.nonzeroi = ...
                            [obj.indicator.nonzeroi; any(eTe(:, i))];
                    end
                    obj.indicator.nonzeroi = find(obj.indicator.nonzeroi);
                end
                
                eTeNonZero = ...
                    eTe(obj.indicator.nonzeroi, obj.indicator.nonzeroi);
                obj.err.pre.hhat(iPre, 5) = {eTeNonZero};
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
        function obj = pmIter(obj, iIter)
            % this method extract the pm values, pm locations, pm
            % exponential values for iterations.
            obj.pmVal.iter = mat2cell([obj.pmVal.comb.space(iIter, ...
                obj.no.inc + 1 : end)'; ...
                obj.pmVal.s.fix], ones(obj.no.inc + 1, 1));
            obj.pmLoc.iter = obj.pmVal.comb.space(iIter, (1:obj.no.inc));
            obj.pmExpo.iter = ...
                cellfun(@(v) log10(v), obj.pmVal.iter(1:obj.no.inc), 'un', 0);
        end
        
        %%
        function obj = reducedVar(obj)
            % compute reduced variables for each pm value.
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
        function obj = rvSVD(obj, rvSVDreRatio)
            % this method performs SVD on the stored reduced variables.
            rvStore = cell2mat(obj.resp.rv.store);
            [rvL, rvSig, rvR] = svd(rvStore, 0);
            rvL = rvL * rvSig;
            rvSigCol = diag(rvSig);
            for isig = 1:length(rvSigCol)
                sigSumRatio = sum(rvSigCol(1:(length(rvSigCol) - isig))) /...
                    sum(rvSigCol);
                if sigSumRatio < rvSVDreRatio
                    nRvSVD = length(rvSigCol) - isig + 1;
                    break
                end
            end
            
            % size(rvL) = ntnrnf * domain size, size(rvR) = domain size *
            % domain size. size(eTe) = ntnrnf * ntnrnf, therefore size(rvR *
            % rvL' * eTe * rvL * rvR') = domain size * domain size
            % (rvL * rvR' = origin), and truncation can be performed.
            % what's being interpolated here is: rvL' * eTe * rvL.
            
            rvL = rvL(:, 1:nRvSVD);
            rvR = rvR(:, 1:nRvSVD);
            obj.resp.rv.sig = rvSig(1:nRvSVD, 1:nRvSVD);
            obj.resp.rv.L = rvL;
            obj.resp.rv.R = rvR;
            obj.no.nRvSVD = nRvSVD;
            
        end
        %%
        function obj = rvLTePrervL(obj)
            % this method multiplies left singular vectors from collected
            % reduced variables with pre-computed eTe.
            
            for i = 1:obj.no.pre.hhat
                if size(obj.err.pre.hhat{i, 5}, 1) == ...
                        size(obj.resp.rv.L, 1)
                    eTe5 = obj.err.pre.hhat{i, 5};
                    obj.err.pre.hhat{i, 5} = ...
                        obj.resp.rv.L' * eTe5 * obj.resp.rv.L;
                end
                if size(obj.err.pre.hhat{i, 6}, 1) == ...
                        size(obj.resp.rv.L, 1)
                    eTe6 = obj.err.pre.hhat{i, 6};
                    obj.err.pre.hhat{i, 6} = ...
                        obj.resp.rv.L' * eTe6 * obj.resp.rv.L;
                end
            end
            
            for i = 1:obj.no.pre.hat
                if size(obj.err.pre.hat{i, 5}, 1) == ...
                        size(obj.resp.rv.L, 1)
                    eTe5 = obj.err.pre.hat{i, 5};
                    obj.err.pre.hat{i, 5} = ...
                        obj.resp.rv.L' * eTe5 * obj.resp.rv.L;
                end
                if size(obj.err.pre.hat{i, 6}, 1) == ...
                        size(obj.resp.rv.L, 1)
                    eTe6 = obj.err.pre.hat{i, 6};
                    obj.err.pre.hat{i, 6} = ...
                        obj.resp.rv.L' * eTe6 * obj.resp.rv.L;
                end
            end
            
        end
        %%
        function obj = pmPrepare(obj, rvSvdSwitch)
            % This method prepares parameter values to fit and multiply
            % related reduced variables.
            % The interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            % Repeat for nt times to fit length of pre-computed
            % responses.
            % if rvSvdSwitch = 1, there is no need to find the nonzero
            % elements.
            pmPass = cell2mat(obj.pmVal.iter);
            pmSlct = repmat([1; 1; pmPass], obj.no.t_step * obj.no.rb, 1);
            pmSlct = [1; pmSlct];
            if rvSvdSwitch == 0
                % pmNonZeroCol = pmSlct(obj.indicator.nonzeroi, :);
                pmNonZeroCol = pmSlct;
                obj.pmVal.pmCol = pmNonZeroCol;
            elseif rvSvdSwitch == 1
                obj.pmVal.pmCol = pmSlct;
            end
            
        end
        
        %%
        function obj = rvPrepare(obj, rvSvdSwitch)
            % This method prepares reduced variables
            % to fit and multiply related reduced variables.
            % The interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            % Repeat for nt times to fit length of pre-computed
            % responses.
            % size of original rv is nr * nt.
            % if rvSvdSwitch = 1, there is no need to find the nonzero
            % elements.
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
            % manually duplicate rv vector for nphy times.
            rvDisRepRow = repmat(rvDisRow, obj.no.inc + 1, 1);
            rvAllRow = [rvAccRow; rvVelRow; rvDisRepRow];
            rvAllCol = rvAllRow(:);
            rvAllCol = [1; rvAllCol(:)];
            
            if rvSvdSwitch == 0
                % rvNonZeroCol = rvAllCol(obj.indicator.nonzeroi, :);
                rvNonZeroCol = rvAllCol;
                obj.pmVal.rvCol = rvNonZeroCol;
            elseif rvSvdSwitch == 1
                obj.pmVal.rvCol = rvAllCol;
            end
            
        end
        %%
        function obj = pmMultiRv(obj)
            % this method multiplies the same dim rv vector with pm vector,
            % ready for the POD on rv.
            pmVec = obj.pmVal.pmCol;
            rvVec = obj.pmVal.rvCol;
            obj.pmVal.pmrv = pmVec .* rvVec;
            
        end
        %%
        function obj = rvpmColStore(obj, iIter)
            % this method stores reduced variables to perform SVD.
            rvpmCol = obj.pmVal.pmrv;
            obj.resp.rv.store(iIter) = {rvpmCol};
        end
        %%
        function obj = inpolyItpl(obj, type)
            % this method interpolates within 2 points (1D) or 1 polygon
            % (2D).
            % nBlk is the number of pm blocks in current iteration.
            % pmBlk is the pm blocks.
            switch type
                case 'hhat'
                    nBlk = length(obj.pmExpo.block.hhat);
                    pmBlk = obj.pmExpo.block.hhat;
                    ehats = obj.err.pre.hhat;
                case 'hat'
                    nBlk = length(obj.pmExpo.block.hat);
                    pmBlk = obj.pmExpo.block.hat;
                    ehats = obj.err.pre.hat;
                case 'add' % this is the number of the newly divided blocks.
                    nBlk = 2 ^ obj.no.inc;
                    pmBlk = obj.pmExpo.block.add;
                    ehats = obj.err.pre.hhat;
            end
            
            for i = 1:nBlk
                % pmIter is the single expo pm value for current iteration.
                pmIter = obj.pmExpo.iter{:};
                % pmBlkCell is the cell block of itpl pm domain values.
                pmBlkDom = pmBlk{i}(:, 2:obj.no.inc + 1);
                pmBlkCell = mat2cell(pmBlkDom, size(pmBlkDom, 1), ...
                    ones(size(pmBlkDom, 2), 1));
                
                % generate x-y (1 inclusion) or x-y-z (2 inclusions) domain.
                if obj.no.inc == 1
                    if inBetweenTwoPoints(pmIter, pmBlkCell{:}) == 1
                        switch type
                            case 'hhat'
                                uiTui = ehats(pmBlk{i}(:, 1), 5);
                                uiTuj = ehats(pmBlk{i}(1, 1), 6);
                            case 'hat'
                                uiTui = ehats(pmBlk{i}(:, 1), 5);
                                uiTuj = ehats(pmBlk{i}(1, 1), 6);
                            case 'add'
                                % pmBlk is the added block now, there are 2
                                % blocks in 1D case.
                                pmAdd = pmBlk{i};
                                uiTui = ehats(pmAdd(:, 1), 5);
                                uiTuj = ehats(pmAdd(1, 1), 6);
                        end
                        pmCell = num2cell(cell2mat(pmBlkCell));
                        % this is the Lagrange coefficient matrix, 2 by 2
                        % for linear interpolations.
                        coefOtpt = lagrange(pmIter, pmCell);
                        cfcfT = coefOtpt * coefOtpt';
                        uiCell = cell(2, 2);
                        
                        for iut = 1:2
                            uiCell{iut, iut} = uiTui{iut};
                        end
                        
                        uiCell{1, 2} = uiTuj{:};
                        uiCell{2, 1} = uiTuj{:}';
                        uTuOtpt = zeros(size(uiCell{2}));
                        for iut = 1:4
                            uTuOtpt = uTuOtpt + uiCell{iut} * cfcfT(iut);
                        end
                        % non-diag entries of uiCell are not symmetric, but
                        % once sum all cells of uiCell becomes symmetric.
                        obj.err.itpl.otpt = uTuOtpt;
                    end
                    
                elseif obj.no.inc == 2
                    if inpolygon(pmIter, pmBlkCell{:}) == 1
                        
                        xl = min(pmBlk{i}(:, 2));
                        xr = max(pmBlk{i}(:, 2));
                        yl = min(pmBlk{i}(:, 3));
                        yr = max(pmBlk{i}(:, 3));
                        
                        [gridxVal, gridyVal] = meshgrid([xl xr], [yl yr]);
                        gridx = 10 .^ gridxVal;
                        uiTui = 10 .^ gridyVal;
                        switch type
                            case 'hhat'
                                gridzVal = ehats(pmBlk{i}(:, 1), 5);
                            case 'hat'
                                gridzVal = ehats(pmBlk{i}(:, 1), 5);
                            case 'add'
                                % pmBlk is the added block now.
                                pmAdd = pmBlk{i};
                                gridzVal = ehats(pmAdd(:, 1), 5);
                        end
                        gridz = [gridzVal(1) gridzVal(2); ...
                            gridzVal(4) gridzVal(3)];
                        % interpolate in 2D.
                        obj.LagItpl2Dmtx(gridx, uiTui, gridz);
                    end
                else
                    disp('dimension > 2')
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
        function obj = conditionalItplProdRvPm(obj, iIter, rvSvdSwitch)
            % this method considers the interpolation condition and enrichment
            % condition to efficiently perform interpolation.
            
            % the PRINCIPLE: if refine, let ehat = ehhat, interpolate in
            % new blocks, modify ehat at new blocks to get ehhat; if
            % enrich, interpolate through ehat blocks. For ehhat, only
            % interpolate the refined blocks, and modify ehat surface to
            % get ehhat surface.
            
            % if there is no refinement at all, both hhat and hat domain
            % need to perform interpolation.
            if obj.no.block.hat == 1
                obj.inpolyItpl('hhat');
                obj.inpolyItpl('hat');
                obj.rvPmErrProdSum('hhat', rvSvdSwitch, iIter);
                obj.rvPmErrProdSum('hat', rvSvdSwitch, iIter);
                obj.err.store.surf.hhat(iIter) = 0;
                obj.err.store.surf.hat(iIter) = 0;
                obj.errStoreSurfs('hhat');
                obj.errStoreSurfs('hat');
                
                % if enrich, interpolate ehat. For ehhat, only interpolate
                % the refined blocks, and modify ehat surface at new
                % blocks to get ehhat surface.
                % NO H-REF
            elseif obj.indicator.refine == 0 && ...
                    obj.indicator.enrich == 1
                % hat surface needs to be interpolated everywhere.
                obj.err.store.surf.hat(iIter) = 0;
                obj.inpolyItpl('hat');
                
                obj.rvPmErrProdSum('hat', rvSvdSwitch, iIter);
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
                    obj.rvPmErrProdSum('hhat', rvSvdSwitch, iIter);
                    obj.errStoreSurfs('hhat');
                end
                
            elseif obj.indicator.refine == 1 && ...
                    obj.indicator.enrich == 0
                % if refine, let ehat surface = ehhat surface, interpolate new
                % blocks, modify ehat surface at new blocks to get ehhat.
                % H-REF
                if iIter == 1
                    % only if point is not in refined blocks, hat = hhat,
                    % otherwise all hat = hhat.
                    obj.err.store.surf.hat = obj.err.store.surf.hhat;
                end
                
                % Determine whether point is in refined block.
                obj.inAddBlockIndicator;
                if any(obj.indicator.inBlock) == 1
                    % only interpolate and modify the refined part of hhat
                    % block, should be very fast.
                    obj.err.store.surf.hhat(iIter) = 0;
                    obj.inpolyItpl('add');
                    obj.rvPmErrProdSum('add', rvSvdSwitch, iIter);
                    obj.errStoreSurfs('hhat');
                end
            end
        end
        %%
        function obj = rvPmErrProdSum(obj, type, rvSvdSwitch, iIter)
            
            switch type
                case 'hhat'
                    e = obj.err.itpl.hhat;
                case 'hat'
                    e = obj.err.itpl.hat;
                case 'add'
                    e = obj.err.itpl.add;
            end
            if rvSvdSwitch == 0
                
                ePreSqrt = (obj.pmVal.rvCol .* obj.pmVal.pmCol)' * e * ...
                    (obj.pmVal.rvCol .* obj.pmVal.pmCol);
                switch type
                    case {'hhat', 'add'}
                        obj.err.norm(1) = ...
                            sqrt(abs(ePreSqrt)) / ...
                            norm(obj.dis.qoi.trial, 'fro');
                    case 'hat'
                        obj.err.norm(2) = ...
                            sqrt(abs(ePreSqrt)) / ...
                            norm(obj.dis.qoi.trial, 'fro');
                end
                
            elseif rvSvdSwitch == 1
                ePreSqrtMtx = obj.resp.rv.R * e * obj.resp.rv.R';
                ePreMtx = sqrt(abs(ePreSqrtMtx)) / ...
                    norm(obj.dis.qoi.trial, 'fro');
                ePreDiag = diag(ePreMtx);
                switch type
                    case {'hhat', 'add'}
                        % in case add, obj.err.norm(2) doesn't change,
                        % fixes to the last value of the previous iteration.
                        obj.err.norm(1) = ePreDiag(iIter);
                    case 'hat'
                        obj.err.norm(2) = ePreDiag(iIter);
                end
                
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
            pmIterCell = obj.pmExpo.iter;
            pmExpoAdd = obj.pmExpo.block.add;
            
            if obj.no.inc == 1
                obj.indicator.inBlock = cellfun(@(pmExpoAdd) ...
                    inBetweenTwoPoints(pmIterCell{:}, pmExpoAdd(:, 2)), ...
                    pmExpoAdd);
            elseif obj.no.inc == 2
                obj.indicator.inBlock = cellfun(@(pmExpoAdd) inpolygon...
                    (pmIterCell{:}, pmExpoAdd(:, 2), ...
                    pmExpoAdd(:, 3)), pmExpoAdd);
            else
                disp('dimension > 2')
            end
        end
        %%
        function obj = errStoreSurfs(obj, type)
            % store all error response surfaces: 2 hats, 1 diff, 1 errwithRb.
            pmLocIter = num2cell(obj.pmLoc.iter);
            if obj.no.inc == 1
                surfSize = [obj.domLeng.i 1];
            else
                surfSize = obj.domLeng.i;
            end
            % use idx here cause in 2d, subindices need to be transformed
            % into xy coords.
            idx = sub2ind(surfSize, pmLocIter{:});
            switch type
                case 'hhat'
                    obj.err.store.surf.hhat(idx) = ...
                        obj.err.store.surf.hhat(idx) + obj.err.norm(1);
                    
                case 'hat'
                    obj.err.store.surf.hat(idx) = ...
                        obj.err.store.surf.hat(idx) + obj.err.norm(2);
                    
                case 'diff'
                    obj.err.store.surf.diff = ...
                        abs(obj.err.store.surf.hhat - obj.err.store.surf.hat);
                    
                case 'original'
                    obj.err.store.surf(idx) = ...
                        obj.err.store.surf(idx) + obj.err.val;
            end
        end
        %%
        function obj = errStoreAllSurfs(obj, type)
            % store all error response surfaces.
            switch type
                case 'original'
                    obj.err.store.allSurf = [obj.err.store.allSurf; ...
                        obj.err.store.surf];
                case 'hhat'
                    obj.err.store.allSurf = [obj.err.store.allSurf; ...
                        obj.err.store.surf.hhat];
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
        function obj = extractMaxErrorInfo(obj, type, randomSwitch)
            % extract error max and location from surfaces.
            switch type
                
                case 'hhat'
                    [eMaxValhhat, eMaxLocIdxhhat] = ...
                        max(obj.err.store.surf.hhat(:));
                    pmValRowhhat = obj.pmVal.comb.space(eMaxLocIdxhhat, :);
                    obj.err.max.loc.hhat = pmValRowhhat(:, 1:obj.no.inc);
                    obj.err.max.val.hhat = eMaxValhhat;
                    
                case 'hat'
                    [eMaxValhat, eMaxLocIdxhat] = ...
                        max(obj.err.store.surf.hat(:));
                    pmValRowhat = obj.pmVal.comb.space(eMaxLocIdxhat, :);
                    obj.err.max.loc.hat = pmValRowhat(:, 1:obj.no.inc);
                    obj.err.max.val.hat = eMaxValhat;
                    
                case 'original'
                    [eMaxVal, eMaxLocIdx] = max(obj.err.store.surf(:));
                    pmValRow = obj.pmVal.comb.space(eMaxLocIdx, :);
                    obj.err.max.val = eMaxVal;
                    
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
            
            obj.err.store.max = [obj.err.store.max; obj.err.max.val];
            obj.err.store.loc = [obj.err.store.loc; obj.err.max.loc];
            
        end
        %%
        function obj = extractMaxPmInfo(obj, type)
            % when extracting maximum error information, values and
            % locations of maximum error can be different, for example, use
            % eDiff to decide maximum error location (eMaxPmLoc =
            % obj.err.maxLoc.diff), and use ehat (obj.err.maxLoc.hat) to
            % decide parameter value regarding maximum error.
            
            switch type
                case 'original'
                    eMaxPmLoc = obj.err.max.loc;
                    eMaxValLoc = obj.err.max.loc;
                case 'hhat'
                    eMaxPmLoc = obj.err.max.loc.hhat;
                    eMaxValLoc = obj.err.max.loc.hhat;
            end
            obj.pmLoc.max = eMaxPmLoc;
            
            pmValMax = [];
            for i = 1:obj.no.inc
                pmValMax = [pmValMax, obj.pmVal.i.space{i}(eMaxValLoc(i), 2)];
            end
            
            obj.pmVal.max = pmValMax;
            obj.pmExpo.max = num2cell(log10(obj.pmVal.max));
            
        end
        %%
        function obj = localHrefinement(obj)
            % local h-refinement
            obj.indicator.refine = 1;
            obj.indicator.enrich = 0;
            % let hat surface = hhat surface.
            obj.pmExpo.hat = obj.pmExpo.hhat;
            obj.pmExpo.block.hat = obj.pmExpo.block.hhat;
            obj.no.pre.hat = size(obj.pmExpo.hat, 1);
            obj.no.block.hat = size(obj.pmExpo.block.hat, 1);
            % nExist + nAdd should equal to nhhat.
            obj.no.itplEx = obj.no.pre.hat;
            % find where the maximum distance is between hhat and hat
            % surfaces.
            if obj.no.inc == 1
                [~, maxDistLoc] = max(obj.err.store.surf.diff);
                obj.pmExpo.maxDist = {obj.pmExpo.i{:}(maxDistLoc)};
            end
            obj = refineGridLocalwithIdx(obj, 'iteration');
            obj.no.block.add = 2 ^ obj.no.inc - 1;
        end
        %%
        function obj = extractPmAdd(obj)
            % when a h-refinement occurs, this method finds the information
            % relates to newly added samples.
            
            % the newly added blocks.
            obj.pmExpo.block.add = obj.pmExpo.block.hhat...
                (end - obj.no.block.add : end);
            
            % indices of newly added samples.
            pmIdxhhat = obj.pmExpo.hhat(:, 1);
            pmIdxhat = obj.pmExpo.hat(:, 1);
            pmIdxAdd = pmIdxhhat(length(pmIdxhat) + 1 : end);
            
            % pm values of newly added samples.
            obj.pmVal.add = obj.pmVal.hhat(pmIdxAdd, :);
            obj.no.itplAdd = size(obj.pmVal.add, 1);
            
        end
        %%
        function obj = residualfromForce...
                (obj, normType, qoiSwitchSpace, qoiSwitchTime, ...
                AbaqusSwitch, trialName)
            switch normType
                case 'l1'
                    relativeErrSq = @(xNum, xInit) ...
                        (norm(xNum, 1)) / (norm(xInit, 1));
                case 'fro'
                    relativeErrSq = @(xNum, xInit) ...
                        (norm(xNum, 'fro')) / (norm(xInit, 'fro'));
            end
            pmValCell = obj.pmVal.iter;
            stiPre = sparse(obj.no.dof, obj.no.dof);
            for iSti = 1:obj.no.inc + 1
                stiPre = stiPre + obj.sti.mtxCell{iSti} * pmValCell{iSti};
            end
            obj.sti.full = stiPre;
            obj.fce.pass = obj.fce.val - ...
                obj.mas.mtx * obj.phi.val * obj.acc.re.reVar - ...
                obj.dam.mtx * obj.phi.val * obj.vel.re.reVar - ...
                obj.sti.full * obj.phi.val * obj.dis.re.reVar;
            if AbaqusSwitch == 0
                obj = NewmarkBetaReducedMethodOOP(obj, 'full');
            elseif AbaqusSwitch == 1
                % use Abaqus to obtain exact solutions. 
                pmI = obj.pmVal.iter{1};
                pmS = obj.pmVal.iter{2};
                % input parameter 1 indicates the force is completely
                % modified. 
                obj.abaqusJob(trialName, pmI, pmS, 1, 'residual');
                obj.abaqusOtpt;
            end
            obj.dis.resi = obj.dis.full;
            
            if qoiSwitchTime == 0 && qoiSwitchSpace == 0
                obj.dis.qoi.resi = obj.dis.resi;
                
            elseif qoiSwitchTime == 1 && qoiSwitchSpace == 0
                obj.dis.qoi.resi = obj.dis.resi(:, obj.qoi.t);
                
            elseif qoiSwitchSpace == 1 && qoiSwitchTime == 0
                obj.dis.qoi.resi = obj.dis.resi(obj.qoi.dof, :);
                
            elseif qoiSwitchSpace == 1 && qoiSwitchTime == 1
                obj.dis.qoi.resi = obj.dis.resi(obj.qoi.dof, obj.qoi.t);
                
            end
            
            obj.err.val = relativeErrSq(obj.dis.qoi.resi, obj.dis.qoi.trial);
            
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
                    % 'maxValue' may have a problem: the maximum values are
                    % at the same location (corners), which are interpolation
                    % samples, result in the same value, and the refinement
                    % condition = 0, so there is no refinement, which is
                    % not good.
                    % another problem of maxValue is we do not know where
                    % to refine.
                    obj.refinement.condition = abs((obj.err.max.val.hhat - ...
                        obj.err.max.val.hat) / obj.err.max.val.hat);
                case 'maxSurf'
                    % maximum distance between same locations of 2 surfaces.
                    % obj.refinement.condition = ...
                    %     max(obj.err.store.surf.diff(:)) / ...
                    %     obj.err.max.val.hat;
                    % obj.refinement.condition = ...
                    %     max(obj.err.store.surf.diff ./ ...
                    %     obj.err.store.surf.hat);
                    obj.refinement.condition = ...
                        max(obj.err.store.surf.diff);
                    
            end
        end
        %%
        function obj = refiCondDisplay(obj, type)
            % this method displays refinement condition and refinement.
            switch type
                case 'noRefi'
                    disp(strcat('condition', {' = '}, ...
                        num2str(obj.refinement.condition), ...
                        ', Greedy'));
                case 'refi'
                    disp(strcat('condition', {' = '}, ...
                        num2str(obj.refinement.condition), ...
                        ', Refine'));
            end
            
        end
        %%
        function obj = maxErrorDisplay(obj, type)
            % this method displays maximum error value.
            
            switch type
                case 'original'
                    disp(strcat('location ', {' = '}, ...
                        num2str(obj.err.max.loc)));
                    disp(strcat('maximum error ', {' = '}, ...
                        num2str(obj.err.max.val)));
                case 'hhat'
                    disp(strcat('location ', {' = '}, ...
                        num2str(obj.err.max.loc.hhat)));
                    disp(strcat('maximum error ', {' = '}, ...
                        num2str(obj.err.max.val.hhat)));
                case 'hat'
                    disp(strcat('location ', {' = '}, ...
                        num2str(obj.err.max.loc.hat)));
                    disp(strcat('maximum error ', {' = '}, ...
                        num2str(obj.err.max.val.hat)));
            end
        end
        %%
        function obj = qoiSpaceTime(obj, nQoiT, nDofPerNode, qoiSwitchManual)
            % this method choose equally spaced number of time steps, number
            % depends on nQoiT.
            
            nt = obj.no.t_step;
            ntVec = 2:nt;
            ind = round(linspace(1, length(ntVec), nQoiT));
            %             obj.qoi.t = ntVec([2, 5, 10, 15, 20, 25]);
            obj.qoi.t = ntVec(ind)';
            
            obj.qoi.tSetdiff = setdiff((1:obj.no.t_step), obj.qoi.t)';
            
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
            
            if nDofPerNode == 2
                
                qoiInc = [obj.qoi.node{1}(:, 1) * 2 - 1, ...
                    obj.qoi.node{1}(:, 1) * 2];
                qoiInc = qoiInc';
                qoiInc = qoiInc(:);
                
            end
            obj.qoi.dof = qoiInc;
            
            if qoiSwitchManual == 1
                obj.qoi.t = (5:10)';
                obj.qoi.dof = [1 2 11 12 243:260]';
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
                colorStruct, colorInc, labelSwitch)
            % read INP file and extract node and element informations.
            lineNode = [];
            lineElem = [];
            lineInc = [];
            % Read INP file line by line
            fid = fopen(obj.INPname);
            tline = fgetl(fid);
            lineNo = 1;
            lineIncStart = cell(obj.no.inc, 1);
            lineIncEnd = cell(obj.no.inc, 1);
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
                
                if obj.no.inc == 1
                    strStart = strcat('*Nset, nset=Set-I', num2str(idx));
                    strEnd = strcat('*Elset, elset=Set-I', ...
                        num2str(idx), ', generate');
                elseif obj.no.inc == 9
                    strStart = strcat('*Nset, nset=Set-', num2str(idx));
                    strEnd = strcat('*Elset, elset=Set-', ...
                        num2str(idx), ', generate');
                end
                
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
            
            for i = 1:obj.no.inc
                % nodal info of inclusions
                nodeIncCol = [];
                
                txtInc = strtext((lineIncNo(i, 1):lineIncNo(i, 2) - 1), :);
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
                for i = 1:obj.no.inc
                    
                    in = trisurf(obj.elem.all(obj.elem.inc{i}, 2:4), ...
                        x, y, zeros(nnode, 1));
                    set(in, 'FaceColor', colorInc, 'CDataMapping', 'scaled');
                end
                
                axis equal
            end
            
            % label each node
            if labelSwitch == 1
                for i3 = 1:size(obj.node.all, 1)
                    node_str = num2str(obj.node.all(i3, 1));
                    text(obj.node.all(i3, 2), obj.node.all(i3, 3), node_str);
                end
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
                    % initial iteration refine the entire domain.
                    pmExptoTest = obj.pmExpo.mid;
                case 'iteration'
                    % following iterations refine where maximum difference
                    % is (between hhat and hat surfaces).
                    pmExptoTest = obj.pmExpo.maxDist;
            end
            
            pmExpInpPm_ = cell2mat(obj.pmExpo.block.hat);
            pmExpInpPm = pmExpInpPm_(:, 2:obj.no.inc + 1);
            pmExpInpRaw = unique(pmExpInpPm, 'rows');
            nBlk = length(obj.pmExpo.block.hat);
            % find which block max pm point is in, refine.
            for iBlk = 1:nBlk
                
                if obj.no.inc == 1
                    if inBetweenTwoPoints(pmExptoTest{:}, ...
                            obj.pmExpo.block.hat{iBlk}...
                            (:, obj.no.inc + 1)) == 1
                        obj = refineGrid(obj, iBlk);
                        iRec = iBlk;
                    end
                elseif obj.no.inc == 2
                    if inpolygon(pmExptoTest{1}, pmExptoTest{2}, ...
                            obj.pmExpo.block.hat{iBlk}(:, obj.no.inc), ...
                            obj.pmExpo.block.hat{iBlk}...
                            (:, obj.no.inc + 1)) == 1
                        obj = refineGrid(obj, iBlk);
                        iRec = iBlk;
                    end
                else
                    disp('dimension >= 3')
                end
                
            end
            
            % delete repeated point with the chosen block.
            jRec = [];
            for iDel = 1:2 ^ obj.no.inc
                for jDel = 1:length(obj.pmExpo.block.hhat)
                    
                    if isequal(obj.pmExpo.block.hat{iRec}...
                            (iDel, 2:obj.no.inc + 1), ...
                            obj.pmExpo.block.hhat(jDel, :)) == 1
                        
                        jRec = [jRec; jDel];
                        
                    end
                    
                end
            end
            obj.pmExpo.block.hhat(jRec, :) = [];
            pmExpOtpt_ = obj.pmExpo.block.hhat;
            
            if obj.no.inc == 1
                % if dimension = 1, always add 1 itpl point each refinement;
                obj.pmExpo.block.hhat = [length(obj.pmExpo.hat) + 1 ...
                    obj.pmExpo.block.hhat];
            elseif obj.no.inc == 2
                % compare pmExpOtpt_ with pmEXP_inptRaw, only to find
                % whether there is a repeated pm point.
                % elseif dimension = 2, may add 4 or 5 itpl points each
                % refinement, depending on whether there is a repeated pm
                % point.
                aRec = [];
                for iComp = 1:size(pmExpOtpt_, 1)
                    
                    a = ismember(pmExpOtpt_(iComp, :), pmExpInpRaw, 'rows');
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
                    pmExpOtpt_(pmIdx, :) = [];
                    
                    for iComp1 = 1:length(pmExpInpPm_)
                        b = ismember(pmExpOtptSpecVal, ...
                            pmExpInpPm_(iComp1, 2:3), 'rows');
                        if b == 1
                            pmExpOtptSpecIdx = pmExpInpPm_(iComp1, 1);
                        end
                    end
                    
                    obj.pmExpo.block.hhat = [[pmExpOtptSpecIdx ...
                        pmExpOtptSpecVal]; ...
                        [(1:idxToAdd)' + length(pmExpInpRaw) pmExpOtpt_]];
                    
                else
                    % if there is no repeated point, add 5 indices.
                    idxToAdd = 5;
                    obj.pmExpo.block.hhat = ...
                        [(1:idxToAdd)' + length(pmExpInpRaw) ...
                        obj.pmExpo.block.hhat];
                end
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
            pmExpOtpt_ = sortrows(pmExpOtptPm);
            obj.pmExpo.hhat = unique(pmExpOtpt_, 'rows');
            obj.pmVal.hhat = 10 .^ obj.pmExpo.hhat(:, 2:obj.no.inc + 1);
            obj.pmVal.hhat = [obj.pmExpo.hhat(:, 1) obj.pmVal.hhat];
            obj.pmVal.hat = 10 .^ obj.pmExpo.hat(:, 2:obj.no.inc + 1);
            obj.pmVal.hat = [obj.pmExpo.hat(:, 1) obj.pmVal.hat];
            obj.no.pre.hhat = size(obj.pmVal.hhat, 1);
            obj.no.block.hhat = size(obj.pmExpo.block.hhat, 1);
            
        end
        %%
        function obj = NewmarkBetaReducedMethodOOP(obj, type)
            
            beta = 1/4; gamma = 1/2; % al = alpha
            
            %% pass struct to constants
            
            t = 0 : obj.time.step : (obj.time.max);
            
            a0 = 1 / (beta * obj.time.step ^ 2);
            a1 = gamma / (beta * obj.time.step);
            a2 = 1 / (beta * obj.time.step);
            a3 = 1/(2 * beta) - 1;
            a4 = gamma / beta - 1;
            a5 = gamma * obj.time.step/(2 * beta) - obj.time.step;
            a6 = obj.time.step - gamma * obj.time.step;
            a7 = gamma * obj.time.step;
            
            switch type
                case 'full'
                    dis0 = obj.dis.inpt;
                    vel0 = obj.vel.inpt;
                    K = obj.sti.full;
                    M = obj.mas.mtx;
                    C = obj.dam.mtx;
                    fce = obj.fce.pass;
                case {'reduced'}
                    dis0 = obj.dis.re.inpt;
                    vel0 = obj.vel.re.inpt;
                    K = obj.sti.reduce;
                    M = obj.mas.reduce;
                    C = obj.dam.reduce;
                    fce = obj.phi.val' * obj.fce.pass;
            end
            
            obj.dis.val = zeros(length(K), length(t));
            obj.dis.val(:, 1) = obj.dis.val(:, 1) + dis0;
            obj.vel.val = zeros(length(K), length(t));
            obj.vel.val(:, 1) = obj.vel.val(:, 1) + vel0;
            obj.acc.val = zeros(length(K), length(t));
            obj.acc.val(:, 1) = obj.acc.val(:, 1) + M \ (fce(:, 1) - ...
                C * obj.vel.val(:, 1) - K * obj.dis.val(:, 1));
            
            Khat = K + a0 * M + a1 * C;
            
            for i_nm = 1 : length(t) - 1
                
                dFhat = fce(:, i_nm+1) + ...
                    M * (a0 * obj.dis.val(:, i_nm) + ...
                    a2 * obj.vel.val(:, i_nm) + ...
                    a3 * obj.acc.val(:, i_nm)) + ...
                    C * (a1 * obj.dis.val(:, i_nm) + ...
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
            
            switch type
                case 'full'
                    obj.acc.full = obj.acc.val;
                    obj.vel.full = obj.vel.val;
                    obj.dis.full = obj.dis.val;
                    for iCons = 1:length(obj.no.cons)
                        obj.acc.full(obj.cons.dof{iCons}, :) = 0;
                        obj.vel.full(obj.cons.dof{iCons}, :) = 0;
                        obj.dis.full(obj.cons.dof{iCons}, :) = 0;
                    end
                case 'reduced'
                    obj.acc.reduce = obj.acc.val;
                    obj.vel.reduce = obj.vel.val;
                    obj.dis.reduce = obj.dis.val;
            end
        end
        %%
        function obj = abaqusStrInfo(obj, trialName)
            % this method defines the string infos, prepare to modify the
            % .inp file.
            abaPath = '/home/xiaohan/Desktop/Temp/AbaqusModels';
            obj.aba.inp.path.unmo = [abaPath '/fixBeam/'];
            obj.aba.inp.path.mo = [abaPath '/iterModels/'];
            obj.aba.dat.name = [trialName '_iter'];
        end
        %%
        function obj = abaqusJob(obj, trialName, pmI, pmS, fceMod, fceType)
            % this method:
            % 1. reads the raw .inp file;
            % 2. locates the string to be modified;
            % 3. outputs the modified, run Abaqus job by calling it.
            % fceMod == 1, force is modified.
            % fceType == residual, each element is non-zero;
            % fceType == impulse, only initial or 2nd elements are non-zeros.
            
            % read the original unmodified .inp file.
            inpTextUnmo = fopen(obj.aba.file);
            rawInpStr = textscan(inpTextUnmo, ...
                '%s', 'delimiter', '\n', 'whitespace', '');
            fclose(inpTextUnmo);
            
            % generate the force part to be written in .inp file.
            if fceMod == 1
                % force string locations.
                fceStr = {'*Nset, nset=Set-af'; ...% nsetStart
                    '*Nset, nset=Set-lc'; ...% nsetEnd
                    '*Amplitude'; ...% ampStart
                    '** MATERIALS'; ...% ampEnd
                    '*Cload, amplitude'; ...% cloadStart
                    '** OUTPUT REQUESTS'};% cloadEnd
                fceStrLoc = zeros(length(fceStr), 1);
                for iFce = 1:length(fceStr)
                    fceStrLoc(iFce) = ...
                        find(strncmp(rawInpStr{1}, fceStr{iFce}, ...
                        length(fceStr{iFce})));
                end
                switch fceType
                    case 'residual'
                        % set up the force values, residual case has value
                        % for each time step.
                        fceAmp = zeros(obj.no.dof, 2 * obj.no.t_step);
                        fceAmp(:, 1:2:end) = fceAmp(:, 1:2:end) + ...
                            repmat((0:obj.time.step:obj.time.max), ...
                            [obj.no.dof, 1]);
                        fceAmp(:, 2:2:end) = fceAmp(:, 2:2:end) + obj.fce.pass;
                        
                    case 'impulse'
                        % set up the force values, impulse case has value
                        % for only time step 1 or 2.
                        fceAmp = zeros(obj.no.dof, 8);
                        tInd = obj.indicator.tDiff;
                        fceAmp(:, 1:2:end) = fceAmp(:, 1:2:end) + ...
                            (0:obj.time.step:0.3);
                        fceAmp(:, 2 * tInd) = ...
                            fceAmp(:, 2 * tInd) + obj.fce.pass(:, tInd);
                        
                end
                setCell = [];
                cloadCell = [];
                ampCell = [];
                for iNode = 1:obj.no.node.all
                    setStr = ['*Nset, nset=Set-af' ...
                        num2str(iNode) ', instance=beam-1'];
                    setCell_ = {setStr; num2str(iNode)};
                    setCell = [setCell; setCell_];
                    cload1 = ['*Cload, amplitude=Amp-af' ...
                        num2str(iNode * 2 - 1)];
                    cload2 = ['Set-af' num2str(iNode) ', 1, 1'];
                    cload3 = ['*Cload, amplitude=Amp-af' ...
                        num2str(iNode * 2)];
                    cload4 = ['Set-af' num2str(iNode) ', 2, 1'];
                    cloadCell = [cloadCell; ...
                        {cload1; cload2; cload3; cload4}];
                    
                end
                nline = floor(obj.no.t_step * 2 / 8);
                
                for iDof = 1:obj.no.dof
                    ampStr = ...
                        {['*Amplitude, name=Amp-af' num2str(iDof)]};
                    ampVal = fceAmp(iDof, :);
                    if length(ampVal) > 8
                        ampInsLine1 = ampVal(1:nline * 8);
                        ampInsLine1 = reshape(ampInsLine1, [8, nline]);
                        ampInsCell1 = mat2cell...
                            (ampInsLine1', ones(1, nline), 8);
                        ampInsCell1 = ...
                            cellfun(@(v) num2str(v), ampInsCell1, 'un', 0);
                        ampInsCell2 = ...
                            {num2str(...
                            ampVal(length(ampVal(1:nline * 8)) + 1:end))};
                        ampInsCell = [ampInsCell1; ampInsCell2];
                    else
                        ampInsCell = {num2str(ampVal)};
                    end
                    
                    % add semi-colon after each num element.
                    ampInsCell = ...
                        regexprep(ampInsCell,'(\d)(?=( |$))','$1,');
                    ampCell = [ampCell; ampStr; ampInsCell];
                end
                rawInpStr{1} = [rawInpStr{1}(1:fceStrLoc(1) - 1);...
                    setCell; ...
                    rawInpStr{1}(fceStrLoc(2):fceStrLoc(3) - 1); ...
                    ampCell; ...
                    rawInpStr{1}(fceStrLoc(4):fceStrLoc(5) - 1);...
                    cloadCell; ...
                    rawInpStr{1}(fceStrLoc(6):end)];
            end
            
            % 2. locate the strings to be modified.
            % 2.1 pm strings.
            pmStr = {'*Material, name=Material-I1'; ...
                '*Material, name=Material-S'};
            pmStrLoc = zeros(length(pmStr), 1);
            for iPm = 1:length(pmStr)
                pmStrLoc(iPm) = ...
                    find(strncmp(rawInpStr{1}, pmStr{iPm}, length(pmStr{iPm})));
            end
            
            % 2.2 step strings.
            stepStr = {'*Dynamic'};
            stepStrLoc = find(strncmp(rawInpStr{1}, ...
                stepStr{1}, length(stepStr{1})));
            
            lineImod = pmStrLoc(1) + 4;
            lineSmod = pmStrLoc(2) + 4;
            lineStepMod = stepStrLoc + 1;
            
            % 3. output the modified .inp file, run Abaqus job by calling it.
            % split the strings, find the num str to be modified.
            
            % set the text file to be written.
            otptInpStr = rawInpStr;
            % modify pm part in .inp file.
            splitStr = strsplit(rawInpStr{:}{pmStrLoc(1) + 4});
            posRatio = splitStr{end};
            strI = [' ', num2str(pmI), ', ', posRatio];
            strS = [' ', num2str(pmS), ', ', posRatio];
            strStep = [num2str(obj.time.step), ', ', num2str(obj.time.max)];
            otptInpStr{:}(pmStrLoc(1) + 4) = {strI};
            otptInpStr{:}(pmStrLoc(2) + 4) = {strS};
            otptInpStr{:}(lineStepMod) = {strStep};
            
            % modified inp file name.
            inpNameMo = [trialName, '_iter'];
            inpPathMo = obj.aba.inp.path.mo;
            % print the modified inp file to the output path.
            fid = fopen([inpPathMo inpNameMo, '.inp'], 'wt');
            fprintf(fid, '%s\n', string(otptInpStr{:}));
            fclose(fid);
            
            % run Abaqus value.
            cd(inpPathMo)
            jobDef = ...
                '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
            runStr = strcat(jobDef, inpNameMo, ' inp=', inpPathMo, ...
                inpNameMo, '.inp interactive ask_delete=OFF');
            system(runStr);
            
        end
        %%
        function obj = abaqusOtpt(obj)
            % this method reads the data in abaqus .dat file and transform
            % into the output matrix.
            
            % read the .dat file.
            datText = fopen([obj.aba.inp.path.mo, obj.aba.dat.name, '.dat']);
            rawDatStr = textscan(datText, ...
                '%s', 'delimiter', '\n', 'whitespace', '');
            fclose(datText);
            
            % locate the strings to be modified.
            datStr = {'THE FOLLOWING TABLE IS PRINTED FOR'; 'AT NODE'};
            datStrLoc = cell(1);
            for iDat = 1:length(datStr)
                datStrLoc{iDat} = ...
                    find(strncmp(strtrim(rawDatStr{1}), datStr{iDat}, ...
                    length(datStr{iDat})));
            end
            
            % find the locations of displacement outputs.
            if any(datStrLoc{2}) == 0
                obj.dis.full = sparse(obj.no.dof, obj.no.t_step);
            else
                lineModStart = datStrLoc{1} + 5;
                lineModEnd = datStrLoc{2}(1:2:end) - 3;
                % transform and store the displacement outputs.
                disAllStore = cell(length(lineModStart), 1);
                for iDis = 1:length(lineModStart)
                    
                    dis_ = rawDatStr{1}(lineModStart(iDis) : lineModEnd(iDis));
                    dis_ = str2num(cell2mat(dis_));
                    % fill non-exist spots with 0s.
                    if size(dis_, 1) ~= obj.no.node.all
                        
                        disAllDof = zeros(obj.no.node.all, 3);
                        disAllDof(dis_(:, 1), :) = dis_;
                        disAllDof(:, 1) = (1:obj.no.node.all);
                    end
                    disAllStore(iDis) = {disAllDof};
                    
                end
                % reshape these u1 u2 displacements to standard space-time vectors,
                % extract displacements without indices.
                disValStore = cellfun(@(v) v(:, 2:3), disAllStore, 'un', 0);
                disVecStore = cellfun(@(v) v', disValStore, 'un', 0);
                disVecStore = cellfun(@(v) v(:), disVecStore, 'un', 0);
                
                obj.dis.full = cell2mat(disVecStore');
                obj.dis.full = [zeros(obj.no.dof, 1) obj.dis.full];
            end
            
        end
        %%
        obj = resptoErrPreCompSVDpartTimeImprovised(obj);
        obj = readINPgeo(obj);
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