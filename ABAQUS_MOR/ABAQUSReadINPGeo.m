function [node, elem]=ABAQUSReadINPGeo(INPfilename)
%% Notes
% INPfilename=...
%     'C:\Temp\L9H4_3616.inp';
%%
line_node=[];
line_elem=[];

% line_exfc_info=[];
%%
% Read INP file line by line
fid=fopen(INPfilename);
tline=fgetl(fid);
line_NO=1;
% celltext=cell(100,1);
while ischar(tline)
    line_NO=line_NO+1;
    tline=fgetl(fid);
    celltext{line_NO}=tline;
    
    if strncmpi(tline, '*Node', 5)==1||...
            strncmpi(tline, '*Element', 8)==1
        line_node=[line_node; line_NO];
        %strncmpi compares the 1st n characters of 2 strings for equality
        %strncmpi(string, string, n) compares the 1st n characters.
    end
      
    if strncmpi(tline, '*Element', 8)==1||...
            strncmpi(tline, '*Nset', 5)==1
        line_elem=[line_elem; line_NO];
        
    end
    
end

strtext=char(celltext(2:(length(celltext)-1)));

fclose(fid);

% safe
text_node1=strtext((line_node(1):line_node(2)-2), :);
% safe
text_elem1=strtext((line_elem(1):line_elem(2)-2), :); 

trim_node=strtrim(text_node1);%delete spaces in heads and tails
trim_elem=strtrim(text_elem1);
node=str2num(trim_node);
elem=str2num(trim_elem);
