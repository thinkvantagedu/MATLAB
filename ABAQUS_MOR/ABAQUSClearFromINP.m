function [Cleared_INP]=ABAQUSClearFromINP(Cleared_INPfilename, INPfilename)
% clear all;
% clc;
% %%
% INPfilename='C:\Temp\L9H2_dynamics.inp';
% Cleared_INPfilename='C:\Temp\L9H2_dynamics.inp';

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
TexttoClear={'*STEP, name=exportmatrix ';
'*MATRIX GENERATE, STIFFNESS, MASS';
'*MATRIX OUTPUT, STIFFNESS, MASS, FORMAT=MATRIX INPUT';
'*END STEP '};
ClearLength=length(TexttoClear);
strtext=char(celltext(1:(length(celltext)-1)));

text_part_1=cellstr(strtext(1:line_node, :));
text_part_2=cellstr(strtext(line_node+ClearLength+2: size(strtext, 1), :));

text_part_assemble=[text_part_1; text_part_2];

Cleared_INP=char(text_part_assemble);

fid=fopen(Cleared_INPfilename,'w');
    
    for i_clearINP=1:length(Cleared_INP)
    
        fprintf(fid, '%s\n', Cleared_INP(i_clearINP, :));
    
    end

fclose(fid);