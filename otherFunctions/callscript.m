
tic
mtx_file='L9H4_3616-1_0_STIF1.mtx'; ndof_per_node=3;
replace_M=[3, 6];   % replace the indices 3 to 6 in col 2 and 4

% This is only the lower triangle of the system matrix
MatK = import_ABAQUS_mat(mtx_file,ndof_per_node,replace_M);

% Full  matrix, only for viewing, retain and work with the sparse matrix MatK
MatKfull=full(MatK);
toc