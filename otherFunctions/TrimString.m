function [textfile1]=TrimString(filename_trim, filename_new)
% filename_new='C:\Temp\trimed_textfile_gre.py';
% filename_trim='C:\Temp\abaqusMacros_L7H2_dynamics.py';
%%
textfile_import=char(importdata(filename_trim,'s'));

%%
delete(filename_new);
fid=fopen(filename_new,'wt');
for i_trimstring=1:size(textfile_import, 1)
    
%     these two lines remove all spaces before code
    textfile1=strtrim(textfile_import(i_trimstring, :));
    fprintf(fid, '%s\n', textfile1);
    
end

fclose(fid);    