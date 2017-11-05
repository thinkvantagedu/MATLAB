





elastic_pm.I=str2num(strtext(line_node.I(1)+pm_dist, :));
YoungsM.I=elastic_pm.I(:, 1);
elastic_pm.S=str2num(strtext(line_node.S(1)+pm_dist, :));
YoungsM.S=elastic_pm.S(:, 1);
pm_test.I=pm.comb(i_ini, 1);
pm_test.S=pm.comb(i_ini, 2);
Insert_E_test.I=[YoungsM.I; pm_test.I];
Insert_E_test.S=[YoungsM.S; pm_test.S];
str_E0_test.I=num2str(Insert_E_test.I, 6);
str_E0_test.S=num2str(Insert_E_test.S, 6);
[strtext]=ModifyParameter(str_E0_test.I, strtext, line_node.I, pm_dist);
[strtext]=ModifyParameter(str_E0_test.S, strtext, line_node.S, pm_dist);
ExistingFilename=strtext;
delete('C:\Temp\abaqus.rpt');
[ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeInserted);
system('abaqus cae noGUI=C:\Temp\connection_gre.py');
[result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
selected_rows_str=result_data(size(result_data, 1)-iteratives+1:size(result_data, 1), :);
[selected_rows_num]=strrows2numrows(selected_rows_str, node_no);
[re_se_rows_num]=DisplacementRows2Cols(selected_rows_num, node_no);
[snap_store]=StoreResultCols(re_se_rows_num, i_applied_E, iteratives);
[U_exact_test]=ABAQUSDeleteBCRowsinMTX(snap_store, cons, node);
[Cleared_INP]=ABAQUSClearFromINP(INPfilename, INPfilename);
%%
% subplot(1, 2, 1)
hold on
plot(x, U_exact_test(6, :))
% axis([0 200 -150 150])
legend('exact')
% subplot(1, 2, 2)
plot(x, U_ini(6, :))
% axis([0 200 -150 150])
legend('MOR')
hold off