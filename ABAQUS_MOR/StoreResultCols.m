function [snap_init_store]=StoreResultCols(re_rows_num, i_applied_E, iteratives)

snap_init_store=zeros(size(re_rows_num));

snap_init_store(:, (i_applied_E*iteratives-iteratives+1):(i_applied_E*iteratives))=...
    snap_init_store(:, (i_applied_E*iteratives-iteratives+1):(i_applied_E*iteratives))+...
    re_rows_num;