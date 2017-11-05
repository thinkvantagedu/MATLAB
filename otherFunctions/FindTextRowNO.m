function [line_node]=FindTextRowNO(Textfilename, Strtofind)

%%
% INPfilename='C:\Temp\L3H2_dynamics1.inp';
fid=fopen(Textfilename);
line_NO=0;
tline='a';
line_node=[];
while ischar(tline)
    tline=fgetl(fid);
    line_NO=line_NO+1;
 
    celltext{line_NO}=tline;
    
    if strncmpi(tline, Strtofind, size(Strtofind, 2))==1
        line_node=[line_node; line_NO];
        %strncmpi compares the 1st n characters of 2 strings for equality
        %strncmpi(string,string,n) compares the 1st n characters.
    end
    
end