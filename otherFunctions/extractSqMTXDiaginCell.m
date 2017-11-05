function [otpt] = extractSqMTXDiaginCell(inpt)

n = length(inpt) * 2 - 1;

otpt = cell(n, 1);

for i_diag = 1:n
    
   otpt(i_diag) = {diag(inpt, (i_diag - length(inpt)))};
    
end