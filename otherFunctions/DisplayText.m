function [strtext]=DisplayText(Textfilename)


fid=fopen(Textfilename);
line_NO=0;
tline='a';
while ischar(tline)
    tline=fgetl(fid);
    line_NO=line_NO+1;
 
    celltext{line_NO}=tline;
        
end

strtext=char(celltext(1:(length(celltext)-1)));