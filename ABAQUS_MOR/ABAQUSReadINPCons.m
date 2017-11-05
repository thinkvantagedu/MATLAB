function [cons]=ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end)
%%
% clear variables;
% clc;
% INPfilename='C:\Temp\L7H2_dynamics.inp';
% INPfilename='C:\Temp\3D models\airfoil_vcs.inp';
% loc_string_start='Nset, nset=Set-rc';
% loc_string_end='Elset, elset=Set-rc';
%%
line_cons_start=[];
line_cons_end=[];
fid=fopen(INPfilename);
tline=fgetl(fid);
line_NO=1;

while ischar(tline)
    line_NO=line_NO+1;
    tline=fgetl(fid);
    celltext{line_NO}=tline;
    
    line_cons1=strfind(tline, loc_string_start);
    location=isempty(line_cons1);
    if location==0;
        line_cons_start=[line_cons_start; line_NO];
    end
    
    line_cons2=strfind(tline, loc_string_end);
    location=isempty(line_cons2);
    if location==0;
        line_cons_end=[line_cons_end; line_NO];
    end
    
end

%%
strtext=char(celltext(2:(length(celltext)-1)));

fclose(fid);

text_cons1=strtext((line_cons_start(1):line_cons_end(1)-2), :);
trim_cons=strtrim(text_cons1);
cons=[];
for i_cons=1:size(trim_cons, 1)
    
    cons0=str2num(trim_cons(i_cons, :));
    cons=[cons; cons0']; 
    
end
