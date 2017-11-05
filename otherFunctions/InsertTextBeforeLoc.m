function [inserted_file]=InsertTextBeforeLoc...
    (filename, inserted_filename, loc_str)
% clear all; clc;
% filename='C:\Temp\connection_part2_noheading.py';
% inserted_filename='C:\Temp\connection_part2.py';
% 
% loc_str={'# -*- coding: mbcs -*-';                                                            
%         '# Do not delete the following import lines';                                      
%         'from abaqus import *'                                                             
%         'from abaqusConstants import *'                                                     
%         'import __main__'                                                                                                                                        
%         'import section'                                                                    
%         'import regionToolset'                                                              
%         'import displayGroupMdbToolset as dgm'                                              
%         'import part'                                                                       
%         'import material'                                                                   
%         'import assembly'                                                                   
%         'import step'                                                                       
%         'import interaction'                                                                
%         'import load'                                                                       
%         'import mesh'                                                                       
%         'import optimization'                                                               
%         'import job'                                                                        
%         'import sketch'                                                                     
%         'import visualization'                                                              
%         'import xyPlot'                                                                     
%         'import displayGroupOdbToolset as dgo'                                              
%         'import connectorBehavior'};

fid=fopen(filename);

line_NO=0;
tline='a';
while ischar(tline)
    tline=fgetl(fid);
    line_NO=line_NO+1;
    
    celltext{line_NO}=tline;
    
end

strtext=char(celltext(1:(length(celltext)-1)));

text_part=cellstr(strtext);

text_part_assemble=[loc_str; text_part];

inserted_file=char(text_part_assemble);

fid=fopen(inserted_filename,'w');
    
    for i_insert=1:size(inserted_file, 1)
    
        fprintf(fid, '%s\n', inserted_file(i_insert, :));
    
    end

fclose(fid);