clear; clc;
% atamtx is aTa by space-time response matrices.
% atacol is aTa by space and time response vectors.
% atas is aTa by discretised space vector only.
ndof = 5;
nt = 4;

a = 4:23;

a = reshape(a, [ndof, nt]);

aCellCol = cell(nt, 1);

aCellMtx = cell(nt, 1);

for i = 1:nt
    
    ashift = [zeros(ndof, i - 1) a(:, 1:nt - i + 1)];
    aCellMtx(i) = {ashift};
    
    ashift = ashift(:);
    aCellCol(i) = {ashift};
    
end
%% the matrix case
atamtx = [aCellMtx{:}]' * [aCellMtx{:}];

atamtx = mat2cell(atamtx, nt * ones(nt, 1), nt * ones(nt, 1));

atamtx = cellfun(@(v) trace(v), atamtx, 'UniformOutput',false);

atamtx = cell2mat(atamtx);
%% the column vector case
atacol = [aCellCol{:}]' * [aCellCol{:}];
%% the discretised space vector case
% separate space time response into space vectors.
acell = mat2cell(a, ndof, ones(1, nt));

atas = zeros(nt, nt);

for i = 1:nt
    for j = i:nt
        
        elem = [acell{1:(nt - i + 1)}]' * [acell{1:(nt - j + 1)}];
        elemz = zeros(size(elem, 1), j - i);
        elem = [elemz elem];
        elem = trace(elem);
        atas(i, j) = atas(i, j) + elem;
        
    end
    
end

%% recast SVD vector with time shift.
[aL, aSig, aR] = cellfun(@(v) svd(v, 'econ'), aCellMtx, 'UniformOutput', false);

aSVDcell = cell(nt, nt);
nSVD = nt;
ataSVD = zeros(nt);
for i = 1:nt
    for j = 1:nSVD
        
        x = aL{i}(:, j) * aSig{i}(j, j);
        y = aR{i}(:, j);
        aSVDcell{i, j} = {x; y};
        
    end
end

% if aSVDcell is not 2d, there should be a reshape.

for i = 1:nt
    for j = 1:nt
        aSVDpass = 0;
        for k = 1:nSVD
            
            aSVDpass = aSVDpass + ...
                aSVDcell{i, k}{2}' * aSVDcell{j, k}{2} * ...
                aSVDcell{i, k}{1}' * aSVDcell{j, k}{1};
            
        end
        ataSVD(i, j) = ataSVD(i, j) + aSVDpass;
    end
end

%% test shift with SVD vectors, only use space vectors, not really shifting in time.

[bL, bSig, bR] = svd(a, 'econ');

bLs = bL * bSig;

bLsCell = mat2cell(bLs, ndof, ones(1, nt));

bCell = mat2cell(bR, nt, ones(1, nt));

bSVD = cell(nt, nt);

for i = 1:nt
    for j = 1:nt
        bSVD{i, j} = bLsCell{i} * bCell{i}(j);
    end
end

btb = zeros(nt, nt);

for i = 1:nt
    for j = 1:nt
        
        pass = [bSVD{1:i}]' * [bSVD{1:j}];
        btb(i, j) = btb(i, j) + sum(pass(:));
        
    end
end







