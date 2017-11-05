function [otpt_up] = GSARvPmUpTriangular(a, b, c, d, cond)
% if cond == 1, work for reduced variables; else if cond == 0, works for
% parameter.
switch cond
    case 'rv'
        asemb = [a; b; c; c; c];
    case 'pm'
        asemb = [a; a; b; c; d]; 
end

otpt_col = [1; asemb(:)];

otpt_trans = otpt_col * otpt_col';

otpt_up = sparse(triu(otpt_trans));
