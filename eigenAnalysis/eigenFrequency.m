K.eigen = ABAQUSReadMTX2DOF(MTX_K.file.I1020S1);

K.eigen = full(K.eigen);

M.eigen = full(MTX_M.mtx);

[eigen.mode, eigen.freq] = eig(K.eigen, M.eigen);

eigen.freq_diag = sort(diag(eigen.freq));

