function [Inserted_file]=InsertTextAfterText...
    (filename, inserted_filename, loc_str, text_insert)
%%

%     filename='C:\Temp\L3H2_dynamics1.inp';
%     inserted_filename='C:\Temp\Inserted_INP.inp';
%     loc_str='** -----------------';
% 
%     text_insert={'** ';
%         '*STEP, name=exportmatrix ';
%         '*MATRIX GENERATE, STIFFNESS, MASS';
%         '*MATRIX OUTPUT, STIFFNESS, MASS, FORMAT=MATRIX INPUT';
%         '*END STEP '};

%%
fid=fopen(filename);
line_NO=1; 
line_node=[];
tline='a';
while ischar(tline)
    tline=fgetl(fid);
    line_NO=line_NO+1;

    celltext{line_NO}=tline;
    
    if strncmpi(tline, loc_str, length(loc_str))==1
        line_node=[line_node; line_NO];
        %strncmpi compares the 1st n characters of 2 strings for equality
        %strncmpi(string,string,n) compares the 1st n characters.
    end
    
end
%%

% Heading={'*Heading'};
%%
strtext=char(celltext(2:(length(celltext)-1)));

text_part_1=cellstr(strtext(1:line_node, :));
text_part_2=cellstr(strtext(line_node: length(strtext), :));

text_part_assemble=[text_part_1; text_insert; text_part_2];
Inserted_file=char(text_part_assemble);

delete(inserted_filename);

fid=fopen(inserted_filename,'w');
    
    for i_insert=1:size(Inserted_file, 1)
    
        fprintf(fid, '%s\n', Inserted_file(i_insert, :));
    
    end

fclose(fid);


