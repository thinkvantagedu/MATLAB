function [node, elem, cons, exfc, line_cons]=ABAQUSReadINP(INPfilename)
%% Notes
% INPfilename=...
%     'C:\Temp\L9H4_3616.inp';
%%
line_node=[];
line_elem=[];
line_cons=[];
line_exfc=[];
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
        %strncmpi(string,string,n) compares the 1st n characters.
    end
      
    if strncmpi(tline, '*Element', 8)==1||...
            strncmpi(tline, '*Nset', 5)==1
        line_elem=[line_elem; line_NO];
        
    end
    
    if strncmpi(tline, '*Nset, nset=Set-lc', 18)==1||...
            strncmpi(tline, '*Nset, nset=Set-ef', 18)==1
        line_cons=[line_cons; line_NO];
        
    end
    
    if strncmpi(tline, '*Nset, nset=Set-ef', 18)==1||...
            strncmpi(tline, '*End Assembly', 13)==1
        line_exfc=[line_exfc; line_NO];
        
    end
    
%     if strncmpi(tline, '*Cload', 6)==1||...
%             strncmpi(tline, '** OUTPUT REQUESTS', 18)==1
%         line_exfc_info=[line_exfc_info; line_NO];
%         
%     end
    
end

strtext=char(celltext(2:(length(celltext)-1)));

fclose(fid);

%%
% Extract all info
% safe for node and elem, unsafe for cons and exfc, thus 'if' needed for
% cons and exfc.
% safe
text_node1=strtext((line_node(1):line_node(2)-2), :);
% safe
text_elem1=strtext((line_elem(1):line_elem(2)-2), :); 
% unsafe
if line_cons(2)-line_cons(1)>2
    
    content=strtext(line_cons(1):line_cons(1)+1, :);
    [text_cons1]=AlignRows(content);

else
    text_cons1=strtext((line_cons(1):line_cons(2)-2), :);
end
% unsafe
if line_exfc(2)-line_exfc(1)>2
    
    content=strtext(line_exfc(1):line_exfc(1)+1, :);
    [text_exfc1]=AlignRows(content);

else
    text_exfc1=strtext((line_exfc(1):line_exfc(2)-2), :);
end

% text_exfc_info1=strtext((line_exfc_info(1):line_exfc_info(2)-2), :);
trim_node=strtrim(text_node1);%delete spaces in heads and tails
trim_elem=strtrim(text_elem1);
trim_cons=strtrim(text_cons1);
trim_exfc=strtrim(text_exfc1);
% trim_exfc_info=strtrim(text_exfc_info1);
node=str2num(trim_node);
elem=str2num(trim_elem);
cons=str2num(trim_cons)';
exfc=str2num(trim_exfc)';
% exfc_info=str2num(trim_exfc_info)';
%%
% % Generate elem_cds
% elem_cds=zeros(size(elem, 1), 4);
% for i_elem_cds=1:size(node,1)
% %     from 1:(size of elem), generate size of elem*4 matrix 
%     
%     a1=find(elem(:, 2)==i_elem_cds);
% %     find out the location where node matches elem in the first column of elem
%     b1=find(elem(:, 3)==i_elem_cds);
% %     find out the location where node matches elem in the second column of elem
%     
%     elem_cds(a1, 1)=elem_cds(a1, 1)+node(i_elem_cds);
% %     give the CORRESPONDING coords to the first column of elem_cd
%     elem_cds(b1, 3)=elem_cds(b1, 3)+node(i_elem_cds);
% %     give the CORRESPONDING coords to the third column of elem_cd
%  
% end
% 
% for i_elem_cds=(size(node, 1)+1):(2*size(node, 1))
% %     i from the 1st one of second column of node to the last one of second column
%     
%     a1=find(elem(:, 2)==i_elem_cds-size(node, 1));
% %     find out the location where node matches elem in the first column of elem
%     b1=find(elem(:, 3)==i_elem_cds-size(node, 1));
% %     find out the location where node matches elem in the second column of elem
% 
%     
%     elem_cds(a1, 2)=elem_cds(a1, 2)+node(i_elem_cds);
% %     give the CORRESPONDING coords to the second column of elem_cd, track index
%     elem_cds(b1, 4)=elem_cds(b1, 4)+node(i_elem_cds);
% %     give the CORRESPONDING coords to the fourth column of elem_cd, track index
%         
% end








