function [Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, Inserted_INPfilename)
%%
% example
% clear all;
% clc;
% INPfilename='C:\Temp\L9H2_dynamics.inp';
% Inserted_INPfilename='C:\Temp\L9H2_dynamics.inp';
%%
fid=fopen(INPfilename);
line_NO=0;
tline='a';
line_node=[];
while ischar(tline)
    tline=fgetl(fid);
    line_NO=line_NO+1;
 
    celltext{line_NO}=tline;
    
    if strncmpi(tline, '** -----------------', 20)==1
        line_node=[line_node; line_NO];
        %strncmpi compares the 1st n characters of 2 strings for equality
        %strncmpi(string,string,n) compares the 1st n characters.
    end
    
end
%%
TextInsert={'*STEP, name=exportmatrix ';
'*MATRIX GENERATE, STIFFNESS, MASS';
'*MATRIX OUTPUT, STIFFNESS, MASS, FORMAT=MATRIX INPUT';
'*END STEP '};
%%
strtext=char(celltext(1:(length(celltext)-1)));

text_part_1=cellstr(strtext(1:line_node, :));
text_part_2=cellstr(strtext(line_node: size(strtext, 1), :));

text_part_assemble=[text_part_1; TextInsert; text_part_2];
Inserted_INP=char(text_part_assemble);

fid=fopen(Inserted_INPfilename,'w');
    
    for i_insertINP=1:length(Inserted_INP)
    
        fprintf(fid, '%s\n', Inserted_INP(i_insertINP, :));
    
    end

fclose(fid);


