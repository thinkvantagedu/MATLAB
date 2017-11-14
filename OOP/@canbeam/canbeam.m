classdef canbeam < beam
    
    properties
        
        cons
        fce
        
    end
    
    methods
        
        function obj = canbeam(mas, dam, sti, ...
                locStartCons, locEndCons, INPname, domLengi, ...
                domLengs, domBondi, domMid, trial, noIncl, ...
                noStruct, noMas, noDam, tMax, tStep, ...
                errLowBond, errMaxValInit, errRbCtrl, ...
                errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
                drawRow, drawCol, fNode, ftime, nConsEnd)
            
            obj = obj@beam(mas, dam, sti, locStartCons, ...
                locEndCons, INPname, domLengi, domLengs, domBondi, domMid, ...
                trial, noIncl, noStruct, noMas, noDam, ...
                tMax, tStep, errLowBond, errMaxValInit, errRbCtrl, ...
                errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
                drawRow, drawCol); % only base class properties
            
            obj.fce.time = ftime;
            obj.fce.node = fNode;
            obj.no.consEnd = nConsEnd;
            
        end
        %%
        function obj = gaussian(obj, shift, sig, unit_amp, debugMode)
            
            % generate Gaussian function. x is the x-axis, which contains 
            % length of gap; shift is the length shift to left or right; 
            % sig is the coefficient sigma; unit_amp decides whether the 
            % amplitude is normalized or not.
            % - shift moves the curve to right.
            % small sig = small width.
            
            if debugMode == 1
                % if in debug mode, use xaxis of fce with shift to generate
                % efunc.
                efunc = - (obj.fce.xaxis - shift) .^ 2 / 2 / sig ^ 2;
                obj.fce.gaus = 1 / sqrt(2 * pi * sig ^ 2) * exp(efunc);
            elseif debugMode == 0
                % if not in debug mode, use a wide range without shift to
                % generate efunc. 
                xRange = linspace(-1, 1, obj.no.t_step);
                efunc = - xRange .^ 2 / 2 / sig ^ 2;
                obj.fce.gaus = 1 / sqrt(2 * pi * sig ^ 2) * exp(efunc);
                idx = obj.fce.gaus > 1e-5;
                obj.fce.gaus = obj.fce.gaus(idx);
                obj.fce.gaus = obj.fce.gaus - obj.fce.gaus(1);
            end
            
            if unit_amp == 1
                obj.fce.gaus = obj.fce.gaus / max(obj.fce.gaus);
            end
            
        end
        
        %%
        function obj = generateNodalFce(obj, ndofPerNode, sig, debugMode)
            % works for both 2d and 3d.
            obj.fce.dof = ndofPerNode * obj.fce.node;
            obj.fce.val = sparse(obj.no.dof,  obj.no.t_step);
            obj.fce.xaxis = (0 : obj.time.step : obj.fce.time);
            % gaussian(obj, shift, sig, unit_amp)
            obj = gaussian(obj, 0.03, sig, 1, debugMode);
            
            obj.fce.val(obj.fce.dof, 1:length(obj.fce.gaus)) = ...
                obj.fce.val(obj.fce.dof, 1:length(obj.fce.gaus)) + ...
                obj.fce.gaus;
            
        end
        %%
        function obj = readINPconsCanti(obj, dim)
            % read constraint information from INP file.
            
            lineConsStart = [];
            lineConsEnd = [];
            fid = fopen(obj.INPname);
            tline = fgetl(fid);
            lineNo = 1;
            
            while ischar(tline)
                lineNo = lineNo + 1;
                tline = fgetl(fid);
                celltext{lineNo} = tline;
                for i = 1:obj.no.consEnd
                    line_cons1 = strfind(tline, obj.str.locStart{i});
                    location = isempty(line_cons1);
                    if location == 0
                        lineConsStart = [lineConsStart; lineNo];
                    end
                    
                    line_cons2 = strfind(tline, obj.str.locEnd{i});
                    location = isempty(line_cons2);
                    if location == 0
                        lineConsEnd = [lineConsEnd; lineNo];
                    end
                end
            end
            
            %
            strtext = char(celltext(2:(length(celltext)-1)));
            
            fclose(fid);
            
            txtCons = strtext((lineConsStart(1) : lineConsEnd(1) - 2), :);
            trimCons = strtrim(txtCons);
            obj.cons.node=[];
            for iCons = 1 : size(trimCons, 1)
                
                cons0 = str2num(trimCons(iCons, :));
                obj.cons.node = [obj.cons.node; cons0'];
                
            end
            obj.no.cons = length(obj.cons.node);
            
            obj.cons.dof = zeros(dim * obj.no.cons, 1);
            
            for i = 1:obj.no.cons
                obj.cons.dof(i * dim - (dim - 1) : i * dim) = ...
                    obj.cons.dof(i * dim - (dim - 1) : i * dim) + ...
                    (dim * obj.cons.node(i) - (dim - 1): ...
                    dim * obj.cons.node(i))';
            end
            obj.cons.dof = {obj.cons.dof};
            obj.cons.node = {obj.cons.node};
        end
        
        
    end
end