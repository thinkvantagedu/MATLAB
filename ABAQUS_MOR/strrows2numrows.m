function [numrows]=strrows2numrows(strrows, node_no)


numrows=zeros(size(strrows, 1), 3*node_no+1);
for i_resultdata=1:size(strrows, 1)
    
    selected_rows_str2num=str2num(strrows(i_resultdata, :));
    numrows(i_resultdata, :)=numrows(i_resultdata, :)+...
        selected_rows_str2num;
    
end