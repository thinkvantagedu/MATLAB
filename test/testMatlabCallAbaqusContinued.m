%% how to check the results obtained from invoking Abaqus?
% set the pm values for inclusion and matrix the same as the trial values of
% callFixieOriginal, run this test first, obtain norm(disValStore, 'fro'),
% then run callFixieOriginal, obtain norm(fixie.dis.trial, 'fro').

% read mas matrix.
masMtxFile = [abaqusPath, '/iterModels/', 'l9h2SingleInc_iter_MASS1.mtx'];
ASM = dlmread(masMtxFile);
indI = zeros(length(ASM), 1);
indJ = zeros(length(ASM), 1);
Node_n = max(ASM(:,1));    %or max(ASM(:,3))
ndof = Node_n * 2;
for ii = 1:size(ASM,1)
    indI(ii) = 2 * (ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = 2 * (ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI, indJ, ASM(:, 5), ndof, ndof);

masMtx = M' + M;

for i_tran = 1:length(M)
    masMtx(i_tran, i_tran) = masMtx(i_tran, i_tran) / 2;
end

% read stiffness matrix.
stiMtxFile = [abaqusPath, '/iterModels/', 'l9h2SingleInc_iter_STIF1.mtx'];
ASM = dlmread(stiMtxFile);

for ii=1:size(ASM, 1)
    indI(ii) = 2 * (ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = 2 * (ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI,indJ,ASM(:, 5),ndof, ndof);
stiMtx = M' + M;

for i_tran=1:length(M)
    stiMtx(i_tran, i_tran) = stiMtx(i_tran, i_tran) / 2;
end

diagindx = (dofFix - 1) * (ndof + 1) + 1;
stiMtx(dofFix, :) = 0;
stiMtx(:, dofFix) = 0;
stiMtx(diagindx) = 1;

% read force information.
fceCell = rawInpStr{1}(lineFceStart:lineFceEnd);
fce = [];
for iFce = 1:length(fceCell)
    
    fce_ = str2num(cell2mat(fceCell(iFce)));
    fce = [fce; fce_'];
    
end

fce = fce(2:2:end);
fceVal = sparse(nnode * 2, length(lineModStart));
fceVal(18, 1:length(fce)) = fceVal(18, 1:length(fce)) - fce';

u0 = zeros(nnode * 2, 1);
v0 = zeros(nnode * 2, 1);
phi = eye(nnode * 2);

dT = 0.1;
maxT = 9.8;

[~, ~, ~, u, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, masMtx, zeros(nnode * 2), stiMtx, fceVal, ...
    'average', dT, maxT, u0, v0);































