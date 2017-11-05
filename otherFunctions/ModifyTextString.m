clear all; clc;
addpath('C:\Temp\MATLAB');
addpath('C:\Temp\MATLAB\ABAQUS_MOR');
%%
Textfilename='C:\Temp\L5H3_dynamics_mtx.inp';
[strtext]=DisplayText(Textfilename);
Strtofind='*Elastic';
[line_node]=FindTextRowNO(Textfilename, Strtofind);
elastic_parameter=str2num(strtext(line_node(1)+1, :));
YoungsM=elastic_parameter(:, 1);
% applied_E=strrep(textfile_py(line_node,:), str_E, str_E_1);

%%
NSnap=3;
snap_E=(logspace(-1, 1.5, NSnap))';
test_E=[YoungsM; snap_E];
str_E0=num2str(test_E);

%%

FiletoBeInserted='C:\Temp\L5H3_dynamics_mtx.inp';

%%
for i_applied_E=1:NSnap
%     i_applied_E
%     trim starting blanks in original string.
    str_E=strtrim(str_E0(i_applied_E, :));
%     ensure no overloop, match matrix dimensions. 
    if i_applied_E+1==length(test_E)+1
        break
    end
%     trim starting blanks in replaced string.
    str_E_1=strtrim(str_E0(i_applied_E+1, :));  
%     replace corresponding strings with new.
    applied_E=strrep(strtext(line_node(1, :)+1, :), str_E, str_E_1);
    rep_str=strrep(strtext(line_node(1, :)+1, :), strtext(line_node(1, :)+1, :), applied_E);
    strtext_1=cellstr(strtext);
%     store required text into text file. 
    strtext_1(line_node(1, :)+1, :)={rep_str};
%     strtext_1(line_node(1, :)+1, :);
    strtext=char(strtext_1);
    
    ExistingFilename=strtext;

    [ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeInserted);
    
    
    
    
end