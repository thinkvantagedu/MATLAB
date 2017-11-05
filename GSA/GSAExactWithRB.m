function [errExactwRB] = GSAExactWithRB(summation, relativeErrSq, ...
    MTX_M, MTX_C, MTX_K, pmVal, phi, fce, NMcoef, ...
    time, Dis, Vel)

% compute exact error with the enriched RB, which is U^h - \phi *
% \alpha. Requires exact solution in pm domain.

KLoop = summation(MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
    pmVal.loop.I1, pmVal.loop.I2, pmVal.fix.I3);

[disExactwRB, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi.ident, MTX_M.mtx, MTX_C.mtx, KLoop, fce.val, NMcoef, ...
    time.step, time.max, Dis.inpt, Vel.inpt);

respRecons = phi.fre.all * Dis.RE.otpt;

errExactwRB = relativeErrSq(disExactwRB - respRecons, Dis.trial.exact);
