function [Dis] = GSAApproSolution(MTX_M, MTX_C, MTX_K, ...
    fce, pmVal, NMcoef, time, Dis, Vel, phi, type)

switch type
    
    case 'init'
        
        MTX_KRe = ...
            MTX_K.RE.I1120S0 * pmVal.trial.I1 + ...
            MTX_K.RE.I1021S0 * pmVal.trial.I2 + ...
            MTX_K.RE.I1020S1 * pmVal.fix.I3;
        
    case 'iter'
        
        MTX_KRe = ...
            MTX_K.RE.I1120S0 * pmVal.max.I1 + ...
            MTX_K.RE.I1021S0 * pmVal.max.I2 + ...
            MTX_K.RE.I1020S1 * pmVal.fix.I3;
        
end

[~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi.fre.all, MTX_M.RE.iter, MTX_C.RE.iter, MTX_KRe, fce.RE.iter.loop, ...
    NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
