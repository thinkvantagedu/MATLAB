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
            obj.no.dof = length(obj.sti.mtxCell{1});
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
            nodeNoInc = obj.node.inc{:}(:, 1);
            dofInc = [nodeNoInc * 2 - 1 nodeNoInc * 2];
            obj.node.dof.inc = sort(dofInc(:));
        end
        %%
        function obj = generatePmSpaceMultiDim(obj)
            % generate n-D parameter space, n = number of inclusions.
            
            for ipm = 1:obj.no.inc
                
                pmValIspace(ipm) = {logspace(obj.domBond.i{ipm}(1), ...
                    obj.domBond.i{ipm}(2), obj.domLeng.i(ipm))};
                pmValIspace{ipm} = ...
                    [(1:length(pmValIspace{ipm})); pmValIspace{ipm}];
                
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
        function obj = generateDampingSpace(obj)
            for ipm = 1:obj.no.inc
                obj.pmVal.damp.space = (logspace(obj.domBond.i{ipm}(1), ...
                    obj.domBond.i{ipm}(2), obj.domLeng.i(ipm)))';
                %                 obj.pmVal.damp.space = zeros(129, 1);
            end
        end
        
        %%
        function obj = rbEnrichmentStatic(obj)
            obj.countGreedy = obj.countGreedy + 1;
            % this method add a new basis vector to current basis. New basis
            % vector = current exact solution -  previous approximation).
            % GramSchmidt is applied to the basis to ensure orthogonality.
            
            % new basis from error (phi * phi' * response).
            rbErrFull = obj.dis.rbEnrich - ...
                obj.phi.val * obj.phi.val' * obj.dis.rbEnrich;
            nRbOld = obj.no.rb;
            % rbErrFull = obj.dis.rbEnrich; % this is wrong as singularity
            % happens when enrich.
            phi_ = [obj.phi.val rbErrFull];
            obj.GramSchmidt(phi_);
            obj.phi.val = obj.phi.otpt;
            
            eMaxPre = obj.err.store.max(obj.countGreedy - 1);
            eMaxLoc = obj.err.max.loc;
            
            redInfo = {eMaxLoc obj.pmVal.max ...
                size(obj.phi.val, 2)};
            obj.err.store.redInfo(obj.countGreedy + 1, :) = redInfo;
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.store.rb = [obj.no.store.rb; obj.no.rb];
            obj.no.rbAdd = obj.no.rb - nRbOld;
            obj.no.store.rbAdd = [obj.no.store.rbAdd; obj.no.rbAdd];
            
            obj.indicator.enrich = 1;
            
        end
        
        %%
        function obj = rbEnrichment(obj, nEnrich, redRatio, ratioSwitch, ...
                errType, damSwitch)
            obj.countGreedy = obj.countGreedy + 1;
            % this method add a new basis vector to current basis. New basis
            % vector = SVD(current exact solution -  previous approximation).
            % GramSchmidt is applied to the basis to ensure orthogonality.
            
            % new basis from error (phi * phi' * response).
            rbErrFull = obj.dis.rbEnrich - ...
                obj.phi.val * obj.phi.val' * obj.dis.rbEnrich;
            nRbOld = obj.no.rb;
            % rbErrFull = obj.dis.rbEnrich; % this is wrong as singularity
            % happens when enrich.
            pmValMax = obj.pmVal.max;
            disMax = obj.dis.rbEnrich;
            % import system inputs.
            M = obj.mas.mtx;
            if damSwitch == 0
                C = obj.dam.mtx;
            elseif damSwitch == 1
                % here damping is the coefficient, not matrix.
                C = obj.pmVal.damp.space(obj.pmLoc.max);
            end
            K = obj.sti.mtxCell;
            F = obj.fce.val;
            if ratioSwitch == 0
                [leftVecAll, ~, ~] = svd(rbErrFull, 0);
                phiEnrich = leftVecAll(:, 1:nEnrich);
                phi_ = [obj.phi.val phiEnrich];
                obj.GramSchmidt(phi_);
                obj.phi.val = obj.phi.otpt;
                obj.basisCompressionFixNoRedRatio(pmValMax, disMax, ...
                    obj.phi.val, M, C, K, F, damSwitch);
                
            elseif ratioSwitch == 1
                phiInpt = obj.phi.val;
                % generate initial projection error.
                rbErrFull = disMax - phiInpt * phiInpt' * disMax;
                [phiEnrich, ~, ~] = svd(rbErrFull, 0);
                % iteratively enrich basis until RB error tolerance is
                % satisfied. Output is obj.phi.val and obj.err.rbRedRemain.
                obj.basisCompressionRvIterate(pmValMax, disMax, ...
                    phiInpt, phiEnrich, M, C, K, F, redRatio, 0, errType, ...
                    damSwitch);
                
            end
            switch errType
                case 'original'
                    eMaxPre = obj.err.store.max(obj.countGreedy - 1);
                    eMaxLoc = obj.err.max.loc;
                case 'hhat'
                    eMaxPre = obj.err.store.max.hhat(obj.countGreedy - 1);
                    eMaxLoc = obj.err.max.loc.hhat;
            end
            eMaxCur = obj.err.rbRedRemain;
            redRatioOtpt = (eMaxPre - eMaxCur) / eMaxPre;
            
            redInfo = {eMaxLoc obj.pmVal.max ...
                size(obj.phi.val, 2) redRatioOtpt eMaxPre eMaxCur};
            obj.err.store.redInfo(obj.countGreedy + 1, :) = redInfo;
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.store.rb = [obj.no.store.rb; obj.no.rb];
            obj.no.rbAdd = obj.no.rb - nRbOld;
            obj.no.store.rbAdd = [obj.no.store.rbAdd; obj.no.rbAdd];
            
            obj.indicator.refine = 0;
            obj.indicator.enrich = 1;
            
            
            obj.vel.re.inpt = sparse(obj.no.rb, 1);
            obj.dis.re.inpt = sparse(obj.no.rb, 1);
        end
        %%
        function obj = rbInitial(obj, nInit, redRatio, ratioSwitch, ...
                errType, damSwitch)
            % initialize reduced basis, take n SVD vectors from initial
            % solution, nPhi is chosen by user.
            obj.no.store.rbAdd = [];
            obj.no.store.rb = [];
            disTrial = obj.dis.trial;
            pmTrial = obj.pmVal.i.trial;
            [u, ~, ~] = svd(disTrial, 0);
            % construct system inputs.
            M = obj.mas.mtx;
            if damSwitch == 0
                C = obj.dam.mtx;
            elseif damSwitch == 1
                % here C is the coefficient, not matrix.
                C = obj.pmVal.damp.space(obj.pmVal.comb.trial);
            end
            K = obj.sti.mtxCell;
            F = obj.fce.val;
            if ratioSwitch == 0
                phiInpt = u(:, 1:nInit);
                obj.phi.val = phiInpt;
                obj.basisCompressionFixNoRedRatio(pmTrial, disTrial, ...
                    phiInpt, M, C, K, F, damSwitch);
            elseif ratioSwitch == 1
                % compute obj.phi.val;
                obj.basisCompressionRvIterate(pmTrial, disTrial, ...
                    [], u, M, C, K, F, redRatio, 1, errType, damSwitch);
            end
            
            reductionInfo = {obj.pmVal.comb.trial obj.pmVal.i.trial ...
                size(obj.phi.val, 2) 1 - obj.err.rbRedRemain ...
                1 obj.err.rbRedRemain};
            obj.err.store.redInfo(2, :) = reductionInfo;
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.rbAdd = obj.no.rb;
            obj.no.store.rbAdd = [obj.no.store.rbAdd; obj.no.rb];
            obj.no.store.rb = [obj.no.store.rb; obj.no.rb];
            obj.dis.re.inpt = sparse(obj.no.rb, 1);
            obj.vel.re.inpt = sparse(obj.no.rb, 1);
        end
        %%
        function obj = basisCompressionFixNoRedRatio(obj, ...
                pmInpt, disInpt, phiInpt, M, C, K, F, damSwitch)
            % this method compute the error reduction ratio at the magic point
            % when a fixed number of basis vectors is used.
            disQoiInpt = disInpt(obj.qoi.dof, obj.qoi.t);
            
            m = phiInpt' * M * phiInpt;
            k = phiInpt' * (K{1} * pmInpt + K{2} * obj.pmVal.s.fix) * phiInpt;
            if damSwitch == 0
                c = phiInpt' * C * phiInpt;
            elseif damSwitch == 1
                % here C is the damping coefficient, not matrix.
                c = C * k;
            end
            f = phiInpt' * F;
            dT = obj.time.step;
            maxT = obj.time.max;
            U0 = zeros(size(m, 1), 1);
            V0 = zeros(size(m, 1), 1);
            [rv, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phiInpt, m, c, k, f, 'average', dT, maxT, U0, V0);
            ur = phiInpt * rv;
            urQoi = ur(obj.qoi.dof, obj.qoi.t);
            obj.err.rbRedRemain = norm(disQoiInpt - urQoi, 'fro') / ...
                norm(obj.dis.qoi.trial, 'fro');
        end
        
        %%
        function obj = basisCompressionRvIterate...
                (obj, pmInpt, disInpt, phiInpt, phiEnrich, M, C, K, F, ...
                redRatio, initSwitch, errType, damSwitch)
            % this method generates reduced basis iteratively with
            % evaluating RB errorat the magic point. Output is obj.phi.val and
            % obj.err.rbRedRemain.
            nEnrich = 1;
            disQoiInpt = disInpt(obj.qoi.dof, obj.qoi.t);
            % iteratively add basis vectors based on errRb.
            for i = 1:obj.no.dof
                if initSwitch == 1
                    % if initial enrichment, phiEnrich is the input
                    % displacement.
                    phiOtpt = phiEnrich(:, 1:nEnrich);
                    errPre = 1;
                elseif initSwitch == 0
                    phiOtpt = [phiInpt phiEnrich(:, 1:nEnrich)];
                    % if not initial iteration, the enriched basis needs to
                    % be orthogonalized.
                    obj.GramSchmidt(phiOtpt);
                    phiOtpt = obj.phi.otpt;
                    switch errType
                        case 'original'
                            errPre = obj.err.store.max(obj.countGreedy - 1);
                        case 'hhat'
                            errPre = ...
                                obj.err.store.max.hhat(obj.countGreedy - 1);
                    end
                end
                m = phiOtpt' * M * phiOtpt;
                k = phiOtpt' * (K{1} * pmInpt + K{2} * obj.pmVal.s.fix) * ...
                    phiOtpt;
                if damSwitch == 0
                    c = phiOtpt' * C * phiOtpt;
                elseif damSwitch == 1
                    % here C is the damping coefficient, not matrix.
                    c = C * k;
                end
                f = phiOtpt' * F;
                dT = obj.time.step;
                maxT = obj.time.max;
                U0 = zeros(size(m, 1), 1);
                V0 = zeros(size(m, 1), 1);
                [rv, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                    (phiOtpt, m, c, k, f, 'average', dT, maxT, U0, V0);
                ur = phiOtpt * rv;
                
                urQoi = ur(obj.qoi.dof, obj.qoi.t);
                errRb = norm(disQoiInpt - urQoi, 'fro') / ...
                    norm(obj.dis.qoi.trial, 'fro');
                if errRb >= (1 - redRatio) * errPre
                    nEnrich = nEnrich + 1;
                elseif errRb < (1 - redRatio) * errPre
                    break
                end
            end
            
            obj.phi.val = phiOtpt;
            obj.err.rbRedRemain = errRb;
        end
        
        %%
        function obj = rbInitialStatic(obj)
            % initialize reduced basis, take the entire displacement vector
            % as the basis vector.
            obj.no.store.rbAdd = [];
            obj.no.store.rb = [];
            obj.phi.val = obj.dis.trial;
            reductionInfo = {obj.pmVal.comb.trial obj.pmVal.i.trial ...
                size(obj.phi.val, 2)};
            obj.err.store.redInfo(2, :) = reductionInfo;
            
            obj.no.rb = size(obj.phi.val, 2);
            obj.no.rbAdd = obj.no.rb;
            obj.no.store.rbAdd = [obj.no.store.rbAdd; obj.no.rb];
            obj.no.store.rb = [obj.no.store.rb; obj.no.rb];
        end
        %%
        function obj = exactSolutionDynamic(obj, type, AbaqusSwitch, ...
                trialName, damSwitch)
            % this method computes exact solution at maximum error points.
            switch type
                case 'initial'
                    pmValcell = [obj.pmVal.i.trial'; obj.pmVal.s.fix];
                case 'Greedy'
                    pmValcell = [obj.pmVal.max'; obj.pmVal.s.fix];
                case 'verify'
                    pmValcell = cell2mat(obj.pmVal.iter);
            end
            if AbaqusSwitch == 0
                % use MATLAB Newmark code to obtain exact solutions.
                stiPre = sparse(obj.no.dof, obj.no.dof);
                for iSti = 1:obj.no.inc + 1
                    stiPre = stiPre + obj.sti.mtxCell{iSti} * pmValcell(iSti);
                end
                % compute trial solution
                M = obj.mas.mtx;
                if damSwitch == 0
                    C = obj.dam.mtx;
                elseif damSwitch == 1
                    switch type
                        case 'initial'
                            dcInp = obj.pmVal.damp.space(obj.pmVal.comb.trial);
                        case 'Greedy'
                            dcInp = obj.pmVal.damp.space(obj.pmLoc.max);
                    end
                    C = dcInp * stiPre;
                end
                K = stiPre;
                F = obj.fce.val;
                obj.NewmarkBetaReducedMethodOOP(M, C, K, F);
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
                    obj.dis.qoi.trial = obj.dis.trial(obj.qoi.dof, ...
                        obj.qoi.t);
                case 'Greedy'
                    obj.dis.rbEnrich = obj.dis.full;
                case 'verify'
                    obj.dis.verify = obj.dis.full;
            end
            
        end
        %%
        function obj = exactSolutionStatic(obj, type)
            % this method computes exact solution at maximum error points.
            switch type
                case 'initial'
                    pmValcell = [obj.pmVal.i.trial'; obj.pmVal.s.fix];
                case 'Greedy'
                    pmValcell = [obj.pmVal.max'; obj.pmVal.s.fix];
            end
            % use MATLAB Newmark code to obtain exact solutions.
            stiPre = sparse(obj.no.dof, obj.no.dof);
            for iSti = 1:obj.no.inc + 1
                stiPre = stiPre + obj.sti.mtxCell{iSti} * pmValcell(iSti);
            end
            % compute trial solution
            obj.sti.full = stiPre;
            obj.fce.pass = obj.fce.val;
            obj.dis.full = obj.sti.full \ obj.fce.val;
            
            switch type
                case 'initial'
                    obj.dis.trial = obj.dis.full;
                    obj.dis.qoi.trial = obj.dis.trial(obj.qoi.dof);
                case 'Greedy'
                    obj.dis.rbEnrich = obj.dis.full;
                    
            end
            
        end
        %%
        function obj = pmTrial(obj)
            % extract parameter information for trial point.
            pmPointCombIdx = obj.pmVal.comb.space(:, 1:obj.no.inc);
            for i = 1:length(pmPointCombIdx)
                pmCombComp = isequal(obj.pmVal.comb.trial, pmPointCombIdx(i, :));
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
            % prepare other essential storages.
            obj.no.respSVD = nSVD;
            obj.indicator.refine = 0;
            obj.indicator.enrich = 1;
            obj.resp.rv.store = cell(1, prod(obj.domLeng.i));
            obj.resp.rv.dis.store = cell(1);
            
        end
        %%
        function obj = errPrepareRemainProp(obj)
            obj.err.store.max.hhat = [];
            obj.err.store.max.hat = [];
            obj.err.store.max.diff = [];
            obj.err.store.loc.hhat = [];
            obj.err.store.loc.hat = [];
            obj.err.store.loc.diff = [];
            obj.err.store.allSurf.hhat = {};
            obj.err.store.allSurf.hat = {};
            obj.err.store.allSurf.diff = {};
            obj.err.pre.hhat = cell(obj.no.pre.hhat, 4); % 4 cols in total,
            % when POD on RV is applied, will add 2 columns to store full
            % eTe informations.
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
            obj.err.store.redInfo = cell(1, 6);
            reductionText = {'magic point' 'parameter value' ...
                'no of vectors' 'reduction ratio' ...
                'error before' 'error after'};
            obj.err.store.redInfo(1, :) = reductionText;
            
        end
        %%
        function obj = errPrepareRemainOriginal(obj)
            
            obj.err.store.max = [];
            obj.err.store.loc = [];
            obj.err.store.allSurf = {};
            obj.err.store.redInfo = cell(1, 6);
            reductionText = {'magic point' 'parameter value' ...
                'no of vectors' 'reduction ratio' 'error before' 'error after'};
            obj.err.store.redInfo(1, :) = reductionText;
            
        end
        %%
        function obj = errPrepareRemainStatic(obj)
            
            obj.err.store.max = [];
            obj.err.store.loc = [];
            obj.err.store.allSurf = {};
            obj.err.store.redInfo = cell(1, 3);
            reductionText = {'magic point' 'parameter value' 'no of vectors'};
            obj.err.store.redInfo(1, :) = reductionText;
            
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
        function obj = respStorePrepareRemain(obj, timeType)
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
                        for iRb = obj.no.rb - obj.no.rbAdd + 1:obj.no.rb
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
        function obj = respfromFce(obj, respSVDswitch, AbaqusSwitch, trialName)
            % this method compute exact solutions regarding external force.
            if obj.indicator.refine == 0 && obj.indicator.enrich == 1
                % if no refinement, only enrich, force related responses does
                % not change since it's not related to new basis vectors.
                nPre = obj.no.pre.hhat;
                pmIval = obj.pmVal.hhat;
                nEx = 0;
            elseif obj.indicator.refine == 1 && obj.indicator.enrich == 0
                % if refine, no enrichment, only compute force related
                % responses regarding the new interpolation samples.
                nPre = obj.no.itplAdd;
                pmIval = obj.pmVal.add;
                nEx = obj.no.itplEx;
            end
            
            for iPre = 1:nPre
                
                pmValCell = [pmIval(iPre, 2:obj.no.inc + 1) obj.pmVal.s.fix];
                if AbaqusSwitch == 0
                    % use MATLAB Newmark code to obtain exact solutions.
                    stiPre = sparse(obj.no.dof, obj.no.dof);
                    for iSti = 1:obj.no.inc + 1
                        stiPre = stiPre + obj.sti.mtxCell{iSti} * ...
                            pmValCell(iSti);
                    end
                    M = obj.mas.mtx;
                    C = obj.dam.mtx;
                    K = stiPre;
                    F = obj.fce.val;
                    obj = NewmarkBetaReducedMethodOOP(obj, M, C, K, F);
                elseif AbaqusSwitch == 1
                    % use Abaqus to obtain exact solutions.
                    pmI = pmIval(iPre, 2:obj.no.inc + 1);
                    pmS = obj.pmVal.s.fix;
                    % input parameter 0 indicates the force is not modified
                    % thus stick to original external force (if not
                    % modifying force, use original inp file).
                    obj.abaqusJob(trialName, pmI, pmS, 0, 0);
                    obj.abaqusOtpt;
                end
                if respSVDswitch == 0
                    dis_ = obj.dis.full(obj.qoi.dof, obj.qoi.t);
                    obj.resp.store.fce.hhat{nEx + iPre} = {dis_(:)};
                elseif respSVDswitch == 1
                    % if SVD is not on-the-fly, comment this.
                    [uFcel, uFceSig, uFcer] = svd(obj.dis.full, 0);
                    uFcel = uFcel(:, 1:obj.no.respSVD);
                    uFceSig = uFceSig(1:obj.no.respSVD, 1:obj.no.respSVD);
                    uFcer = uFcer(:, 1:obj.no.respSVD);
                    uFcel = uFcel(obj.qoi.dof, :);
                    uFcer = uFcer(obj.qoi.t, :);
                    obj.resp.store.fce.hhat{nEx + iPre} = ...
                        [{uFcel}; {uFceSig}; {uFcer}];
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
            for i_tdiff = 1:2
                
                impPass = obj.asemb.imp.apply{i_tdiff};
                M = obj.mas.mtx;
                C = obj.dam.mtx;
                K = stiPre;
                F = impPass;
                obj = NewmarkBetaReducedMethodOOP(obj, M, C, K, F);
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
                M = obj.mas.mtx;
                C = obj.dam.mtx;
                K = obj.sti.pre;
                F = impPass;
                obj = NewmarkBetaReducedMethodOOP(obj, M, C, K, F);
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
        function obj = respTdiffComputation(obj, respSVDswitch, ...
                AbaqusSwitch, trialName)
            % this method compute 2 responses for each interpolation
            % sample, each affine term, each basis vector.
            % only compute responses regarding newly added basis vectors,
            % but store all responses regarding all basis vectors.
            if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                % if no refinement, enrich basis: compute the new exact
                % solutions regarding the newly added basis vectors.
                nPre = obj.no.pre.hhat;
                nRbInit = obj.no.rb - obj.no.rbAdd + 1;
            elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                % if refine, no enrichment, compute exact solutions
                % regarding all basis vectors but only for the newly added
                % interpolation samples.
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
                            if AbaqusSwitch == 0
                                stiPre = sparse(obj.no.dof, obj.no.dof);
                                for iSti = 1:obj.no.inc + 1
                                    stiPre = stiPre + ...
                                        obj.sti.mtxCell{iSti} * ...
                                        pmValCell(iSti);
                                end
                                M = obj.mas.mtx;
                                C = obj.dam.mtx;
                                K = stiPre;
                                F = impPass;
                                obj = NewmarkBetaReducedMethodOOP...
                                    (obj, M, C, K, F);
                                
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
                                disSVD = full(obj.dis.full);
                                [ul, usig, ur] = svd(disSVD, 0);
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
        function obj = respTimeShift(obj, respSVDswitch)
            % this method shifts the responses in time.
            for iPre = 1:obj.no.pre.hhat
                for iPhy = 1:obj.no.phy
                    for iT = 1:obj.no.t_step
                        for iRb = 1:obj.no.rb
                            if iT == 1
                                % conditions for quantity of interest
                                if respSVDswitch == 0
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb}...
                                        (obj.qoi.dof, obj.qoi.t);
                                elseif respSVDswitch == 1
                                    respQoi = obj.resp.store.tDiff...
                                        {iPre, iPhy, 1, iRb};
                                    respQoi{1} = respQoi{1}(obj.qoi.dof, :);
                                    respQoi{3} = respQoi{3}(obj.qoi.t, :);
                                end
                                
                                respQoi = respQoi(:);
                                if respSVDswitch == 0
                                    obj.resp.store.pm.hhat...
                                        (iPre, iPhy, 1, iRb) = {{respQoi}};
                                elseif respSVDswitch == 1
                                    obj.resp.store.pm.hhat...
                                        (iPre, iPhy, 1, iRb) = {respQoi};
                                end
                            else
                                
                                if respSVDswitch == 0
                                    storePmZeros = zeros(obj.no.dof, iT - 2);
                                    storePmNonZeros = ...
                                        obj.resp.store.tDiff...
                                        {iPre, iPhy, 2, iRb}...
                                        (:, 1:obj.no.t_step - iT + 2);
                                    storePmAsemb = ...
                                        [storePmZeros storePmNonZeros];
                                    
                                    storePmQoi = storePmAsemb...
                                        (obj.qoi.dof, obj.qoi.t);
                                    
                                    obj.resp.store.pm.hhat...
                                        (iPre, iPhy, iT, iRb)...
                                        = {{storePmQoi(:)}};
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
                                    
                                    storePmL = storePmL(obj.qoi.dof, :);
                                    storePmR = storePmR(obj.qoi.t, :);
                                    
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
                    M = obj.mas.mtx;
                    C = obj.dam.mtx;
                    K = stiPre;
                    F = impPass;
                    obj = NewmarkBetaReducedMethodOOP(obj, M, C, K, F);
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
        function obj = uiTujSort(obj, respStoreInpt, rvSVDswitch, respSVDswitch)
            % sort stored displacements, perform uiTui+1, then sort back to
            % previous order, put in the last column of obj.err.pre.hhat,
            % to be ready to be interpolated.
            
            % sort according to the 2nd col of element, which is pm exp value.
            respStoreSort = sortrows(respStoreInpt, 2);
            % a temp cell to store uiTui+1, should contain a void
            % after filling.
            respStoreCell_ = cell(size(respStoreSort, 1), 4);
            for iPre = 1:size(respStoreSort, 1)
                % respStoreSort_ should contain n-1 uiTui+1 matrix element
                %  and 1 void element.
                if iPre < size(respStoreSort, 1)
                    if respSVDswitch == 0
                        respExt = cell2mat(cellfun(@(v) cell2mat(v), ...
                            respStoreSort{iPre, 3}, 'un', 0));
                        respExtp = cell2mat(cellfun(@(v) cell2mat(v), ...
                            respStoreSort{iPre + 1, 3}, 'un', 0));
                        respTrans = respExt' * respExtp;
                        if rvSVDswitch == 0
                            respTransSorttoStore = respTrans;
                        elseif rvSVDswitch == 1
                            respTransSorttoStore = ...
                                obj.resp.rv.L' * respTrans * obj.resp.rv.L;
                        end
                    elseif respSVDswitch == 1
                        respExt = respStoreSort{iPre, 3};
                        respExtp = respStoreSort{iPre + 1, 3};
                        respTrans = zeros(numel(respExt));
                        % tr(uiTuj) = tr(vri*sigi*vliT*vlj*sigj*vrjT).
                        % here j cannot start from i, because respTrans is
                        % not symmetric.
                        for iTr = 1:numel(respExt)
                            u1 = respExt{iTr};
                            for jTr = 1:numel(respExt)
                                u2 = respExtp{jTr};
                                respTrans(iTr, jTr) = ...
                                    trace((u2{3}' * u1{3}) * u1{2}' * ...
                                    (u1{1}' * u2{1}) * u2{2});
                            end
                        end
                        if rvSVDswitch == 0
                            respTransSorttoStore = respTrans;
                        elseif rvSVDswitch == 1
                            respTransSorttoStore = obj.resp.rv.L' * ...
                                respTrans * obj.resp.rv.L;
                        end
                    end
                elseif iPre == size(respStoreSort, 1)
                    respTrans = [];
                    respTransSorttoStore = [];
                end
                respStoreCell_(iPre, 1) = {respStoreSort{iPre, 1}};
                respStoreCell_(iPre, 2) = {respStoreSort{iPre, 2}};
                respStoreCell_(iPre, 3) = {respTransSorttoStore};
                if rvSVDswitch == 1
                    % full scale eTe needs to be stored if POD on RV.
                    respStoreCell_(iPre, 4) = {respTrans};
                end
            end
            % 3rd and 4th columns are associated with 4th and 6th columns of
            % obj.err.pre.hhat
            obj.err.pre.trans = sortrows(respStoreCell_, 1);
        end
        %%
        function obj = resptoErrPreCompPartTime(obj)
            obj.err.pre.blk = cell(obj.no.pre.hhat, 1);
            nVecShift = obj.no.phy;
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
                
                respFce_ = reshape(respFce_, ...
                    [obj.no.dof, length(obj.qoi.t)]);
                for i = 1:length(obj.qoi.t)
                    respFce(:, obj.qoi.t(i)) = ...
                        respFce(:, obj.qoi.t(i)) + respFce_(:, i);
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
                                    respT1(obj.qoi.vecIndSetdiff, :) = 0;
                                    respT2(obj.qoi.vecIndSetdiff, :) = 0;
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
                                    respT1(obj.qoi.vecIndSetdiff, :) = 0;
                                    respT2(obj.qoi.vecIndSetdiff, :) = 0;
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
                obj.err.pre.hhat(iPre, 3) = {eTe};
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
        function obj = reducedVar(obj, damSwitch)
            % compute reduced variables for each pm value.
            phiInpt = obj.phi.val;
            stiReIter = ...
                cellfun(@(v, w) full(v) * w, ...
                obj.sti.re.mtxCell, obj.pmVal.iter, 'un', 0);
            k = sum(cat(3, stiReIter{:}), 3);
            m = obj.mas.re.mtx;
            
            c = obj.dam.re.mtx;
            f = phiInpt' * obj.fce.val;
            dT = obj.time.step;
            maxT = obj.time.max;
            u0 = zeros(obj.no.rb, 1);
            v0 = zeros(obj.no.rb, 1);
            [rvDis, rvVel, rvAcc, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phiInpt, m, c, k, f, 'average', dT, maxT, u0, v0);
            obj.acc.re.reVar = rvAcc;
            obj.vel.re.reVar = rvVel;
            obj.dis.re.reVar = rvDis;
            
        end
        %%
        function obj = reducedVarStatic(obj)
            % compute reduced variables for each pm value.
            phiInpt = obj.phi.val;
            stiReIter = ...
                cellfun(@(v, w) full(v) * w, ...
                obj.sti.re.mtxCell, obj.pmVal.iter, 'un', 0);
            k = sum(cat(3, stiReIter{:}), 3);
            f = phiInpt' * obj.fce.val;
            obj.dis.re.reVar = k \ f;
            
        end
        %%
        function obj = rvDisStore(obj, iIter)
            % this method stores dieplacement reduced variables for
            % verification purpose.
            obj.resp.rv.dis.store{iIter, obj.countGreedy} = obj.dis.re.reVar;
            
        end
        %%
        function obj = rvSVD(obj, rvSVDreRatio)
            % this method performs SVD on the stored reduced variables.
            rvStore = cell2mat(obj.resp.rv.store);
            [rvL, rvSig, rvR] = svd(rvStore, 0);
            
            [~, ~, nRvSVD] = basisCompressionSingularRatio(rvStore, ...
                rvSVDreRatio);
            
            % size(rvL) = ntnrnf * domain size, size(rvR) = domain size *
            % domain size. size(eTe) = ntnrnf * ntnrnf, therefore size(rvR *
            % rvL' * eTe * rvL * rvR') = domain size * domain size
            % (rvL * rvR' = origin), and truncation can be performed.
            % what's being interpolated here is: rvL' * eTe * rvL.
            rvL = rvL * rvSig;
            rvL = rvL(:, 1:nRvSVD);
            rvR = rvR(:, 1:nRvSVD);
            obj.resp.rv.sig = rvSig(1:nRvSVD, 1:nRvSVD);
            obj.resp.rv.L = rvL;
            obj.resp.rv.R = rvR;
            obj.no.nRvSVD = nRvSVD;
        end
        %%
        function obj = pmPrepare(obj, rvSVDswitch)
            % This method prepares parameter values to fit and multiply
            % related reduced variables.
            % The interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            % Repeat for nt times to fit length of pre-computed
            % responses.
            % if rvSVDswitch = 1, there is no need to find the nonzero
            % elements.
            pmPass = cell2mat(obj.pmVal.iter);
            pmSlct = repmat([1; 1; pmPass], obj.no.t_step * obj.no.rb, 1);
            pmSlct = [1; pmSlct];
            if rvSVDswitch == 0
                pmNonZeroCol = pmSlct;
                obj.pmVal.pmCol = pmNonZeroCol;
            elseif rvSVDswitch == 1
                obj.pmVal.pmCol = pmSlct;
            end
            
        end
        %%
        function obj = rvPrepare(obj, rvSVDswitch)
            % This method prepares reduced variables
            % to fit and multiply related reduced variables.
            % The interpolated responses need to be saved for each
            % iteration in order to multiply corresponding reduced
            % variable.
            % Repeat for nt times to fit length of pre-computed
            % responses.
            % size of original rv is nr * nt.
            % if rvSVDswitch = 1, there is no need to find the nonzero
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
            
            if rvSVDswitch == 0
                rvNonZeroCol = rvAllCol;
                obj.pmVal.rvCol = rvNonZeroCol;
            elseif rvSVDswitch == 1
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
                                uiTui = ehats(pmBlk{i}(:, 1), 3);
                                uiTuj = ehats(pmBlk{i}(1, 1), 4);
                            case 'hat'
                                uiTui = ehats(pmBlk{i}(:, 1), 3);
                                uiTuj = ehats(pmBlk{i}(1, 1), 4);
                            case 'add'
                                % pmBlk is the added block now, there are 2
                                % blocks in 1D case.
                                pmAdd = pmBlk{i};
                                uiTui = ehats(pmAdd(:, 1), 3);
                                uiTuj = ehats(pmAdd(1, 1), 4);
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
                                gridzVal = ehats(pmBlk{i}(:, 1), 3);
                            case 'hat'
                                gridzVal = ehats(pmBlk{i}(:, 1), 3);
                            case 'add'
                                % pmBlk is the added block now.
                                pmAdd = pmBlk{i};
                                gridzVal = ehats(pmAdd(:, 1), 3);
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
        function obj = conditionalItplProdRvPm(obj, iIter, rvSVDswitch)
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
                obj.rvPmErrProdSum('hhat', rvSVDswitch, iIter);
                obj.rvPmErrProdSum('hat', rvSVDswitch, iIter);
                obj.err.store.surf.hhat(iIter) = 0;
                obj.err.store.surf.hat(iIter) = 0;
                obj.errStoreSurfs('hhat');
                obj.errStoreSurfs('hat');
                
                % if enrich, interpolate ehat. For ehhat, only interpolate
                % the refined blocks, and modify ehat surface at new
                % blocks to get ehhat surface.
                % NO H-REF
            elseif obj.indicator.refine == 0 && obj.indicator.enrich == 1
                % hat surface needs to be interpolated everywhere.
                obj.err.store.surf.hat(iIter) = 0;
                obj.inpolyItpl('hat');
                
                obj.rvPmErrProdSum('hat', rvSVDswitch, iIter);
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
                    obj.rvPmErrProdSum('hhat', rvSVDswitch, iIter);
                    obj.errStoreSurfs('hhat');
                end
                
            elseif obj.indicator.refine == 1 && obj.indicator.enrich == 0
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
                    obj.rvPmErrProdSum('add', rvSVDswitch, iIter);
                    obj.errStoreSurfs('hhat');
                end
            end
        end
        %%
        function obj = rvPmErrProdSum(obj, type, rvSVDswitch, iIter)
            
            switch type
                case 'hhat'
                    e = obj.err.itpl.hhat;
                case 'hat'
                    e = obj.err.itpl.hat;
                case 'add'
                    e = obj.err.itpl.add;
            end
            if rvSVDswitch == 0
                
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
                
            elseif rvSVDswitch == 1
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
                        [obj.pmExpo.i{:} ...
                        abs(obj.err.store.surf.hhat - obj.err.store.surf.hat)];
                    
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
                    obj.err.store.allSurf.hhat = ...
                        [obj.err.store.allSurf.hhat; obj.err.store.surf.hhat];
                case 'hat'
                    obj.err.store.allSurf.hat = [obj.err.store.allSurf.hat; ...
                        obj.err.store.surf.hat];
                case 'diff'
                    obj.err.store.allSurf.diff = ...
                        [obj.err.store.allSurf.diff; ...
                        obj.err.store.surf.diff(:, 2)];
            end
        end
        %%
        function obj = verifyPrepare(obj)
            % this method prepares for the verification.
            obj.err.store.allSurf.verify = zeros(obj.countGreedy - 1, ...
                obj.domLeng.i);
            obj.err.store.max.verify = zeros(obj.countGreedy - 1, 1);
            obj.err.store.loc.verify = zeros(obj.countGreedy - 1, 2);
        end
        %%
        function obj = verifyExtractBasis(obj, iGre)
            % this method extracts the reduced basis history at each Greedy
            % iteration, output is used in method verifiExactError.
            rvStore = obj.resp.rv.dis.store;
            nphi = size(rvStore{1, iGre}, 1);
            obj.phi.verify = obj.phi.val(:, 1:nphi);
        end
        %%
        function obj = verifyExactError(obj, iGre, iIter)
            % this method verifies the proposed algorithm by computing
            % RB error e(\mu) = U(\mu) - \bPhi\alpha(\mu).
            % compute relative norm error at each iteration, then store in
            % variable: obj.err.store.allSurf.verify.
            rvmu = obj.resp.rv.dis.store{iIter, iGre};
            disErr = obj.dis.verify - obj.phi.verify * rvmu;
            disErrQoI = disErr(obj.qoi.dof, obj.qoi.t);
            errVerify = norm(disErrQoI, 'fro') / norm(obj.dis.qoi.trial, 'fro');
            obj.err.store.allSurf.verify(iGre, iIter) = errVerify;
            
        end
        %%
        function obj = verifyExtractMaxErr(obj, iGre)
            % this method extracts the maximum error for each Greedy
            % iteration for verification purpose.
            errSurfStore = obj.err.store.allSurf.verify(iGre, :);
            [eMval, eMloc] = max(errSurfStore);
            obj.err.store.max.verify(iGre) = eMval;
            obj.err.store.loc.verify(iGre, 1) = eMloc;
            obj.err.store.loc.verify(iGre, 2) = obj.pmVal.i.space{:}(eMloc, 2);
        end
        %%
        function obj = verifyPlotSurf(obj, iGre, plotColor)
            % this method plots the response surface for verification
            % purpose.
            xVal = obj.pmExpo.i{:};
            yVal = obj.err.store.allSurf.verify(iGre, :);
            semilogy(xVal, yVal, plotColor);
            hold on
            grid on
            
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
                
                case 'hats'
                    [eMaxValhhat, eMaxLocIdxhhat] = ...
                        max(obj.err.store.surf.hhat(:));
                    pmValRowhhat = obj.pmVal.comb.space(eMaxLocIdxhhat, :);
                    obj.err.max.loc.hhat = pmValRowhhat(:, 1:obj.no.inc);
                    obj.err.max.val.hhat = eMaxValhhat;
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
        function obj = storeErrorInfo(obj)
            % store error information for each Greedy iterations.
            obj.err.store.max.hhat = ...
                [obj.err.store.max.hhat; obj.err.max.val.hhat];
            obj.err.store.loc.hhat = ...
                [obj.err.store.loc.hhat; obj.err.max.loc.hhat];
            obj.err.store.max.hat = ...
                [obj.err.store.max.hat; obj.err.max.val.hat];
            obj.err.store.loc.hat = ...
                [obj.err.store.loc.hat; obj.err.max.loc.hat];
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
            % find where the maximum distance is between hhat and hat
            % surfaces.
            if obj.no.inc == 1
                obj.pmExpo.maxDist = {obj.pmExpo.i{:}(obj.err.max.diffLoc)};
            end
            disp(strcat('error in the error value', {' = '}, ...
                num2str(obj.refinement.condition), ...
                {' at sample '}, num2str(obj.err.max.diffLoc),...
                {', refine around value '}, num2str(obj.pmExpo.maxDist{:})));
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
            obj = refineGridLocalwithIdx(obj, 'iteration');
            obj.no.block.add = 2 ^ obj.no.inc - 1;
            
            % finds the information relates to newly added samples.
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
        function obj = residualfromForce(obj, normType, AbaqusSwitch, ...
                trialName, damSwitch)
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
            M = obj.mas.mtx;
            if damSwitch == 0
                C = obj.dam.mtx;
            elseif damSwitch == 1
                dcIter = obj.pmVal.damp.space(obj.pmLoc.iter);
                C = stiPre * dcIter;
            end
            K = stiPre;
            F = obj.fce.val - ...
                obj.mas.mtx * obj.phi.val * obj.acc.re.reVar - ...
                C * obj.phi.val * obj.vel.re.reVar - ...
                stiPre * obj.phi.val * obj.dis.re.reVar;
            if AbaqusSwitch == 0
                obj = NewmarkBetaReducedMethodOOP(obj, M, C, K, F);
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
            
            obj.dis.qoi.resi = obj.dis.resi(obj.qoi.dof, obj.qoi.t);
            
            obj.err.val = relativeErrSq(obj.dis.qoi.resi, obj.dis.qoi.trial);
            
        end
        %%
        function obj = residualfromForceStatic(obj)
            relativeErrSq = @(xNum, xInit) ...
                (norm(xNum, 'fro')) / (norm(xInit, 'fro'));
            
            pmValCell = obj.pmVal.iter;
            stiPre = sparse(obj.no.dof, obj.no.dof);
            for iSti = 1:obj.no.inc + 1
                stiPre = stiPre + obj.sti.mtxCell{iSti} * pmValCell{iSti};
            end
            obj.fce.pass = obj.fce.val - ...
                stiPre * obj.phi.val * obj.dis.re.reVar;
            
            obj.dis.resi = obj.sti.full \ obj.fce.pass;
            
            obj.dis.qoi.resi = obj.dis.resi(obj.qoi.dof);
            
            obj.err.val = relativeErrSq(obj.dis.qoi.resi, obj.dis.qoi.trial);
            
        end
        %%
        function obj = reducedMatricesStatic(obj)
            % this method constructs the reduced system after reduced basis
            % is computed.
            obj.sti.re.mtxCell = cell(obj.no.inc + 1, 1);
            
            for i = 1:obj.no.inc + 1
                
                obj.sti.re.mtxCell{i} = ...
                    obj.phi.val' * obj.sti.mtxCell{i} * obj.phi.val;
                
            end
            
        end
        %%
        function obj = reducedMatricesDynamic(obj)
            % this method constructs the reduced system after reduced basis
            % is computed.
            obj.mas.re.mtx = obj.phi.val' * obj.mas.mtx * obj.phi.val;
            obj.dam.re.mtx = obj.phi.val' * obj.dam.mtx * obj.phi.val;
            
        end
        %%
        function obj = refiCondition(obj, type, refCeaseSwitch)
            % this method computes the refinement condition. Max val and
            % loc of eDiff is evaluated at the interpolation block which
            % possesses the largest error.
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
                    if obj.indicator.refine == 1 && obj.indicator.enrich == 0
                        currentLoc = obj.err.max.diffLoc;
                    end
                    
                    % when seeking the maximum eine location, seek only in
                    % the block where the maximum error of eHhat is largest.
                    nBlk = obj.no.block.hhat;
                    hhatBlk = cell(nBlk, 1);
                    diffBlk = cell(nBlk, 1);
                    for iBlk = 1:nBlk
                        
                        pmExpoBlk = obj.pmExpo.block.hhat{iBlk}(:, 2);
                        lVal = pmExpoBlk(1);
                        rVal = pmExpoBlk(2);
                        pmIdxHhat = obj.pmExpo.i{:};
                        pmIdxBlk = pmIdxHhat >= lVal & pmIdxHhat <= rVal;
                        hhatBlk{iBlk} = obj.err.store.surf.hhat(pmIdxBlk, :);
                        diffBlk{iBlk} = obj.err.store.surf.diff(pmIdxBlk, :);
                        
                    end
                    
                    % find max values in each cell of hhatBlk, then find
                    % index of these max values. This index points which
                    % block to be measured with eine and to be refined (if
                    % eine exceeds the tolerance).
                    [~, mpIdx] = max(cell2mat(cellfun(@(v) max(v), hhatBlk, ...
                        'un', 0)));
                    blkToCheck = diffBlk{mpIdx};
                    % loc_ is not the maximum difference location.
                    [obj.err.max.diffVal, loc_] = max(blkToCheck(:, 2));
                    locPmExpo_ = blkToCheck(loc_, 1);
                    obj.err.max.diffLoc = find(obj.pmExpo.i{:} == locPmExpo_);
                    
                    obj.refinement.condition = abs(obj.err.max.diffVal / ...
                        norm(obj.dis.qoi.trial, 'fro'));
                    % if refine continue at a different point, cease
                    % refinement to prevent too many refinements.
                    if refCeaseSwitch == 1
                        newLoc = obj.err.max.diffLoc;
                        if obj.indicator.refine == 1 && ...
                                obj.indicator.enrich == 0
                            if currentLoc ~= newLoc
                                obj.refinement.condition = 0;
                                disp(strcat({'refine sample changes from '}, ...
                                    num2str(currentLoc), {' to '}, ...
                                    num2str(newLoc), {', cease refinement'}))
                            else
                                disp(strcat(...
                                    {'continue refinement at sample '}, ...
                                    num2str(currentLoc)))
                            end
                        end
                    end
            end
        end
        %%
        function obj = greedyInfoDisplay(obj, type)
            % this method displays maximum error value and
            % informations regarding Greedy iterations.
            
            switch type
                case 'original'
                    disp(strcat('magic point location', {' = '}, ...
                        num2str(obj.err.max.loc)));
                    disp(strcat('maximum relative error value', {' = '}, ...
                        num2str(obj.err.max.val)));
                case 'hhat'
                    disp(strcat('error in the error value', {' = '}, ...
                        num2str(obj.refinement.condition), {' at sample '}, ...
                        num2str(obj.err.max.diffLoc), ', Greedy'));
                    disp(strcat('magic point location', {' = '}, ...
                        num2str(obj.err.max.loc.hhat)));
                    disp(strcat('maximum relative error value', {' = '}, ...
                        num2str(obj.err.max.val.hhat)));
                    
                case 'hat'
                    disp(strcat('error in the error value', {' = '}, ...
                        num2str(obj.refinement.condition), {' at sample '}, ...
                        num2str(obj.err.max.diffLoc), ', Greedy'));
                    disp(strcat('magic point location', {' = '}, ...
                        num2str(obj.err.max.loc.hat)));
                    disp(strcat('maximum relative error value', {' = '}, ...
                        num2str(obj.err.max.val.hat)));
                    disp(strcat('error in the error value', {' = '}, ...
                        num2str(obj.refinement.condition), {' at sample '}, ...
                        num2str(obj.err.max.diffLoc), ', Greedy'));
            end
        end
        %%
        function obj = qoiSpaceTime(obj, qoiSwitchSpace, qoiSwitchTime)
            % this method choose equally spaced number of time steps, number
            % depends on nQoiT.
            qoiDof = obj.node.dof.inc';
            qoiT = [10 20 30 40 50]';
            if qoiSwitchSpace == 0 && qoiSwitchTime == 0
                obj.qoi.dof = (1:obj.no.dof)';
                obj.qoi.t = (1:obj.no.t_step)';
                
            elseif qoiSwitchSpace == 0 && qoiSwitchTime == 1
                obj.qoi.dof = (1:obj.no.dof)';
                obj.qoi.t = qoiT';
                
            elseif qoiSwitchSpace == 1 && qoiSwitchTime == 0
                obj.qoi.dof = qoiDof;
                obj.qoi.t = (1:obj.no.t_step)';
                
            elseif qoiSwitchSpace == 1 && qoiSwitchTime == 1
                obj.qoi.dof = qoiDof;
                obj.qoi.t = qoiT;
                
            end
            disp(strcat...
                ('time step number = ', {' '}, num2str(obj.no.t_step), ...
                ', qoi space = the inclusion, qoi time = ', ...
                {' '}, num2str(obj.qoi.t')))
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
        function obj = NewmarkBetaReducedMethodOOP(obj, M, C, K, fce)
            
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
            
            dis0 = obj.dis.inpt;
            vel0 = obj.vel.inpt;
            
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
            
            obj.acc.full = obj.acc.val;
            obj.vel.full = obj.vel.val;
            obj.dis.full = obj.dis.val;
            for iCons = 1:length(obj.no.cons)
                obj.acc.full(obj.cons.dof{iCons}, :) = 0;
                obj.vel.full(obj.cons.dof{iCons}, :) = 0;
                obj.dis.full(obj.cons.dof{iCons}, :) = 0;
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
                % reshape these u1 u2 displacements to standard space-time
                % vectors, extract displacements without indices.
                disValStore = cellfun(@(v) v(:, 2:3), disAllStore, 'un', 0);
                disVecStore = cellfun(@(v) v', disValStore, 'un', 0);
                disVecStore = cellfun(@(v) v(:), disVecStore, 'un', 0);
                
                obj.dis.full = cell2mat(disVecStore');
                obj.dis.full = [zeros(obj.no.dof, 1) obj.dis.full];
            end
            
        end
        %%
        obj = uiTujSort1(obj, respStoreInpt, rvSVDswitch, respSVDswitch);
        obj = resptoErrPreCompAllTimeMatrix(obj, respSVDswitch, rvSVDswitch);
        obj = resptoErrPreCompAllTimeMatrix2(obj, respSVDswitch, rvSVDswitch);
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
        obj = plotSurfGrid...
            (obj, type, drawRow, drawCol, viewX, viewY, gridSwitch, axisLim);
        obj = plotGrid(obj, type);
        obj = plotMaxErrorDecay(obj, plotName);
        
    end
    
end