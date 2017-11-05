function [AlignedRows]=AlignRows(content)

% give line 2 NO, line 1 NO, content
AlignedRows=[];
for i_align=1:size(content, 1)
    
    AlignedRows=[AlignedRows, content(i_align, :)];
    
end
    
