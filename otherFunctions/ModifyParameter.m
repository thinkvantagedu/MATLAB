function [strtext]=ModifyParameter(str_E_input, strtext, line_node_input, para_dist)

% replaced location=line_node_input+para_dist. replace str_E with str_E_1.

% str_E and str_E_1 are 1 and 2 element of str_E_input. Hence the first
% element of str_E_input has to be the same as original string to be
% replaced.

% example

% INPfilename='C:\Temp\L7H2_dynamics.inp';
% 
% [strtext]=DisplayText(INPfilename);
% 
% str_E_input=[];

str_E=strtrim(str_E_input(1, :));

str_E_1=strtrim(str_E_input(2, :));

applied_E=strrep(strtext(line_node_input(1, :)+para_dist, :), str_E, str_E_1);

rep_str=strrep(strtext(line_node_input(1, :)+para_dist, :), strtext(line_node_input(1, :)+...
    para_dist, :), applied_E);

strtext=cellstr(strtext);

strtext(line_node_input(1, :)+para_dist, :)={rep_str};

strtext=char(strtext);