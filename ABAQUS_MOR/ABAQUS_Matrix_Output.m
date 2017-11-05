% function [Mtx_Mass_full, Mtx_Stiffness_full]=...
%     ABAQUS_Matrix_Output(filename, NSnap, snap_E)
clear all; clc;
addpath('C:\Temp\MATLAB');
addpath('C:\Temp\MATLAB\ABAQUS_MOR');
filename.new='C:\Temp\trimed_textfile.py';
filename.trim='C:\Temp\abaqusMacros_L5H3_dynamics.py';
NSnap=2;
snap_E=logspace(-1, 1.5, NSnap);

delete(filename.new);
TrimString(filename.trim, filename.new);

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
% locate the specified strings-parameter to be replaced.

for i_text=1:length(textfile_py)
    % strncmpi compares the 1st n characters of 2 strings for equality
        % strncmpi(string,string,n) compares the 1st n characters.
    if strncmpi(textfile_py(i_text,:),...
            'mdb.models[''Model-1''].materials[''Material-I''].Elastic', 53)==1
%             'dependencies=0, table=((',24)==1
      %identify line location of required text.
      line_node=i_text;
      break
    end

end
% keyboard
%%
% locate the specified strings-1st part of connection.

for i_text_1=1:length(textfile_py)
    % strncmpi compares the 1st n characters of 2 strings for equality
        % strncmpi(string,string,n) compares the 1st n characters.
    if strncmpi(textfile_py(i_text_1,:),...
            'mdb.jobs[''L5H3_dynamics''].submit(consistencyChecking=OFF)', 57)==1
%             'dependencies=0, table=((',24)==1
      %identify line location of required text.
      line_node_seperate=i_text_1;
      break
    end

end
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
%     textfile_py(line_node, :);
%     define the edited Python file running in ABAQUS


    %%
    % job submission part 1
    delete('C:\Temp\connection_part1.py');
    fid=fopen('C:\Temp\connection_part1.py','w');
    
    for i_readpy=1:line_node_seperate
    
        fprintf(fid, '%s\n', textfile_py(i_readpy, :));
   
    end
    
    fclose(fid);
    
    system('abaqus cae noGUI=C:\Temp\connection_part1.py')

    %%
    % job submission part 2
    
    INPfilename='C:\Temp\L5H3_dynamics.inp';
    delete('C:\Temp\L5H3_dynamics_mtx.inp');
    Inserted_INPfilename='C:\Temp\L5H3_dynamics_mtx.inp';
    [Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, Inserted_INPfilename);

    
    %%
    delete('C:\Temp\connection_part2_noheading.py');
    fid=fopen('C:\Temp\connection_part2_noheading.py','w');
    
    for i_readpy1=(line_node_seperate+1:length(textfile_py))
    
        fprintf(fid, '%s\n', textfile_py(i_readpy1, :));
   
    end
    
    fclose(fid);
    
    heading={'# -*- coding: mbcs -*-';                                                            
        '# Do not delete the following import lines';                                      
        'from abaqus import *'                                                             
        'from abaqusConstants import *'                                                     
        'import __main__'                                                                                                                                        
        'import section'                                                                    
        'import regionToolset'                                                              
        'import displayGroupMdbToolset as dgm'                                              
        'import part'                                                                       
        'import material'                                                                   
        'import assembly'                                                                   
        'import step'                                                                       
        'import interaction'                                                                
        'import load'                                                                       
        'import mesh'                                                                       
        'import optimization'                                                               
        'import job'                                                                        
        'import sketch'                                                                     
        'import visualization'                                                              
        'import xyPlot'                                                                     
        'import displayGroupOdbToolset as dgo'                                              
        'import connectorBehavior'};
    filename='C:\Temp\connection_part2_noheading.py';
    Inserted_filename='C:\Temp\connection_part2.py';
    [inserted_file]=InsertTextBeforeLoc(filename, Inserted_filename, heading);

    system('abaqus cae noGUI=C:\Temp\connection_part2.py');
    
%     Mtx_MassFile='C:\Temp\MATLAB\L3H2_dynamics-1_MASS1.mtx';

    Mtx_StiffnessFile='C:\Temp\MATLAB\L5H3_dynamics_mtx_job_STIF1.mtx';

%     [Mtx_Mass_full]=ABAQUSReadMTX(Mtx_MassFile);

    [Mtx_Stiffness_full]=ABAQUSReadMTX(Mtx_StiffnessFile);
    
    full(vpa(Mtx_Stiffness_full, 4))
    
end