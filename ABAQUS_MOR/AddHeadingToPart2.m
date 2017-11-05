delete('C:\Temp\connection_part2_noheading.py');
fid=fopen('C:\Temp\connection_part2_noheading.py','w');
for i_readpy1=(line_node_seperate+1:length(textfile_py))
    fprintf(fid, '%s\n', textfile_py(i_readpy1, :)); 
end
fclose(fid);
heading={'# -*- coding: mbcs -*-';                                                            
        '# Do not delete the following import lines';                                      
        'from abaqus import *'                                                             
        'from abaqusConstants import *'                                                     
        'import __main__'                                                                                                                                        
        'import section'                                                                    
        'import regionToolset'                                                              
        'import displayGroupMdbToolset as dgm'                                              
        'import part'                                                                       
        'import material'                                                                   
        'import assembly'                                                                   
        'import step'                                                                       
        'import interaction'                                                                
        'import load'                                                                       
        'import mesh'                                                                       
        'import optimization'                                                               
        'import job'                                                                        
        'import sketch'                                                                     
        'import visualization'                                                              
        'import xyPlot'                                                                     
        'import displayGroupOdbToolset as dgo'                                              
        'import connectorBehavior'};
filename='C:\Temp\connection_part2_noheading.py';
Inserted_filename='C:\Temp\connection_part2.py';
[inserted_file]=InsertTextBeforeLoc(filename, Inserted_filename, heading);