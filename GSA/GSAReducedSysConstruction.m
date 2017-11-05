function [MTX_K, MTX_M, MTX_C, fce] = GSAReducedSysConstruction...
    (projection, phi, MTX_K, MTX_M, MTX_C, fce)

%% build reduced system after obtaining phi.

MTX_K.RE.I1120S0 = projection(phi.fre.all, MTX_K.I1120S0);
MTX_K.RE.I1021S0 = projection(phi.fre.all, MTX_K.I1021S0);
MTX_K.RE.I1020S1 = projection(phi.fre.all, MTX_K.I1020S1);

MTX_M.RE.iter = projection(phi.fre.all, MTX_M.mtx);
MTX_C.RE.iter = projection(phi.fre.all, MTX_C.mtx);


fce.RE.iter.loop = phi.fre.all' * fce.val;