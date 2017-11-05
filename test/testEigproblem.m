K = full(MTX_K.trial.exact);

M = full(MTX_M.mtx);

[mod, fre] = eig(K, M);