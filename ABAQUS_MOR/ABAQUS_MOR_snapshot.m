function [snap]=ABAQUS_MOR_snapshot(filename, NSnap, snap_E)

%%
% INPUT: filename.trim, filename.new, NSnap, snap_E
% OUTPUT: snapshot matrix

%%
% NOTES:
% 
% 1. If working dir is not C:/Temp, then odb path has to be modified to the
% new path, otherwise ABAQUS will load odb in C:/Temp, and snapshot will not
% change.
% 
% 2. 2nd for loop needs to be modified.
% 
% 3. loc_start and loc_end needs to be modified.
% 
% 4. node NO changes with structure.

%%
% trim the spaces before text file.
delete(filename.new);
[textfile1]=TrimString(filename.trim, filename.new);

%%
% import .py file as char.
filename=filename.new;
textfile_py=char(importdata(filename, 's'));

%%
% remove row: 'def L9H4_9th_att();'
for i_rmv=1:length(textfile_py)
    
   if strncmpi(textfile_py(i_rmv,:), 'def ', 4)==1
      %identify line location of required text.
      line_node_rmv=i_rmv;
      break
    end
   
end

textfile_py(line_node_rmv, :)=[];
% keyboard
%%
% locate the specified strings.

for i_text=1:length(textfile_py)
    % strncmpi compares the 1st n characters of 2 strings for equality
        % strncmpi(string,string,n) compares the 1st n characters.
    if strncmpi(textfile_py(i_text,:),...
            'mdb.models[''Model-1''].materials[''Material-I'']', 45)==1
%             'dependencies=0, table=((',24)==1
      %identify line location of required text.
      line_node=i_text;
      break
    end

end
% keyboard
%%
% modify the parameter

test_E1=snap_E';
% strfind find one string within another, returns location.
loc_start=strfind(textfile_py(line_node,:), 'table=((');
% find out the end location of required text.
loc_end=strfind(textfile_py(line_node,:), '), ))');
% transform number string to double.
parameters=str2double(textfile_py(line_node, loc_start+8:loc_end-6));
% align doubles together.
test_E=[parameters; test_E1];
% doubles back to string.
str_E0=num2str(test_E);
% keyboard
%%
% loop and run modified .py in ABAQUS.
% nd_no=length(node);
% snap=zeros(3*nd_no, NSnap);

for i_applied_E=1:NSnap
    % trim starting blanks in original string.
    str_E=strtrim(str_E0(i_applied_E, :));
    % ensure no overloop, match matrix dimensions. 
    if i_applied_E+1==length(test_E)+1
        break
    end
    % trim starting blanks in replaced string.
    str_E_1=strtrim(str_E0(i_applied_E+1, :));
    % replace corresponding strings with new.
    applied_E=strrep(textfile_py(line_node,:), ...
        str_E, str_E_1);
    rep_str=strrep(textfile_py(line_node, :), ...
        textfile_py(line_node, :), applied_E);
    % string 2 cell with text file.
    textfile_py_1=cellstr(textfile_py);
    % store required text into text file. 
    textfile_py_1(line_node, :)={rep_str};
    % keyboard
    % cell 2 char
    textfile_py=char(textfile_py_1);
    textfile_py(line_node, :);
%     define the edited Python file running in ABAQUS
    delete('C:\Temp\connection.py');
    fid=fopen('C:\Temp\connection.py','wt');
    
    for i_readpy=1:length(textfile_py)
    
        fprintf(fid, '%s\n', textfile_py(i_readpy, :));
   
    end
    
    fclose(fid);

    system('abaqus cae noGUI=C:\Temp\connection.py')
%     delete('abaqus.rpt');
    [result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
    result_data_col_1=str2num(result_data(size(result_data, 1), :))';
    result_data_col=result_data_col_1(2:size(result_data_col_1, 1));
    snap(:, i_applied_E)=snap(:, i_applied_E)+result_data_col;
    
end

%%
% system('abaqus cae script=???.py')
% system('abaqus cae noGUI=abaqusMacros.py')

%%
% snap=zeros(3*19, 1);
% system('abaqus cae noGUI=L5H2_edited1.py')
% [result_data]=char(importdata('abaqus.rpt', 's'));
% result_data_col_1=str2num(result_data(size(result_data, 1), :))';
% result_data_col=result_data_col_1(2:size(result_data_col_1, 1));
% snap(:, 1)=snap(:, 1)+result_data_col;

























