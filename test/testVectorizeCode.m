clear variables; clc;

vec_type = 'sum_3d';

switch vec_type
    
    case 'num2cell'
        %% var1 is 6*3, divide it into 6 vectors and find all
        %% the permutations and combinations of these 6 vectors. (a'*a)
        var.a = [1 2 3; 4 5 6; 7 8 9; 10 11 12];
        % no will divide each column of var1 into 2.
        no = 2;
        % for num2cell, 2nd input decides arrangement of rows, 3rd input decides
        % arrangement of cols.
        numcell = mat2cell(var.a, size(var.a, 1)/no*ones(1, no), ones(1, 3));
        
        % concatenates cols of numcell in DIM 2.
        a = cat(2, numcell{:});
        M = a'*a;
        out = M(:);
        res = sum(out(:));
    case 'sum_square'
        var.r1.t1 = [1 2 3; 4 5 6];
        var.r1.t2 = [2 3 4; 5 6 7];
        var.r1.t3 = [3 4 5; 6 7 8];
        var.r2.t1 = [2 1 4; 7 5 6];
        var.r2.t2 = [3 2 5; 6 5 8];
        var.r2.t3 = [4 3 6; 7 6 9];
        no.t_step = size(var.r1.t1, 2);
        var.sm = var.r1.t1+var.r1.t2+var.r1.t3+var.r2.t1+var.r2.t2+var.r2.t3;
        var.sq = sum(var.sm(:).^2);
        
        var.col.r1.t1 = var.r1.t1(:);
        var.col.r1.t2 = var.r1.t2(:);
        var.col.r1.t3 = var.r1.t3(:);
        var.col.r2.t1 = var.r2.t1(:);
        var.col.r2.t2 = var.r2.t2(:);
        var.col.r2.t3 = var.r2.t3(:);
        var.col.store = [var.col.r1.t1 var.col.r2.t1; var.col.r1.t2 var.col.r2.t2; var.col.r1.t3 var.col.r2.t3];
        var.cel.store = mat2cell(var.col.store, size(var.col.store, 1)/no.t_step*ones(1, no.t_step), ones(1, 2));
        var.col.all = cat(2, var.cel.store{:});
        var.final.mtx = var.col.all'*var.col.all;
        var.final.sm = sum(var.final.mtx(:));

    case 'sum_minus_square'
        var.f = [1 2 3; 4 5 6];
        var.t1 = [2 3 4; 5 6 7];
        var.t2 = [3 4 5; 6 7 8];
        var.sm = var.f-var.t1-var.t2;
        var.sq = sumsqr(var.sm);
        
        var.col.f = var.f(:);
        var.col.t1 = -var.t1(:);
        var.col.t2 = -var.t2(:);
        var.col.store = [var.col.f var.col.t1 var.col.t2];
        var.cel.store = mat2cell(var.col.store, [6], [1 1 1]);
        var.col.all = cat(2, var.cel.store{:});
        var.final.mtx = var.col.all'*var.col.all;
        var.final.sm = sum(var.final.mtx(:));
        
    case 'sum_3d'
        
        var.f.val = [3; 7];
        
        var.M.r1.t1 = [1; 2];
        var.M.r1.t2 = [3; 4];
        var.C.r1.t1 = [2; 3];
        var.C.r1.t2 = [4; 5];
        var.K.r1.t1 = [1; 4];
        var.K.r1.t2 = [2; 5];
        
        var.M.r2.t1 = [1; 3];
        var.M.r2.t2 = [2; 4];
        var.C.r2.t1 = [2; 5];
        var.C.r2.t2 = [1; 5];
        var.K.r2.t1 = [1; 8];
        var.K.r2.t2 = [2; 8];
        
        var.sm = var.f.val-var.M.r1.t1-var.M.r1.t2-var.C.r1.t1-var.C.r1.t2-var.K.r1.t1-var.K.r1.t2-...
            var.M.r2.t1-var.M.r2.t2-var.C.r2.t1-var.C.r2.t2-var.K.r2.t1-var.K.r2.t2;
        var.sq =sumsqr(var.sm);
        
        var.M.store = [-var.M.r1.t1 -var.M.r2.t1; -var.M.r1.t2 -var.M.r2.t2];
        var.C.store = [-var.C.r1.t1 -var.C.r2.t1; -var.C.r1.t2 -var.C.r2.t2];
        var.K.store = [-var.K.r1.t1 -var.K.r2.t1; -var.K.r1.t2 -var.K.r2.t2];
        
        var.col.all = cat(3, var.M.store, var.C.store, var.K.store);
        
        var.cel = mat2cell(var.col.all, [2 2], [1 1], [1 1 1]);
        
        var.cell_col = cat(2, var.cel{:});
        
        var.cell_col = [var.f.val var.cell_col];
        
        var.trans = var.cell_col'*var.cell_col;
        
        var.asemb = sum(var.trans(:));
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
end