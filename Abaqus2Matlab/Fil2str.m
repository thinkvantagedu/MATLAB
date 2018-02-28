function Rec = Fil2str(ResultsFileName)
%
% Assembly of the information in the ABAQUS results file
%
% Syntax
%     #Rec# = Fil2str(#ResultsFileName#);
%
% Description
%     Assemble the information contained in an ABAQUS results (*.fil) file
%     in ASCII format into a string that has one row.
%     The following option with parameter has to be specified in the ABAQUS
%     input file for the results (*.fil) file to be created:
%         ...
%         *FILE FORMAT, ASCII
%         ...
%     NOTE: The results file (*.fil) must be placed in the same directory
%     with the MATLAB source files in order to be processed.
%
% Input parameters
%     #ResultsFileName# (string) is a string containing the name of the
%         ABAQUS results (*.fil) file, along with its extension. The
%         results file is generated by Abaqus after the analysis has been
%         completed.
%
% Output parameters
%     #Rec# ([1 x #m#]) is a string containing the information of the
%         Abaqus results file assembled in one row.
%
% _________________________________________________________________________
% Abaqus2Matlab - www.abaqus2matlab.com
% Copyright (c) 2016 by George Papazafeiropoulos
%
% If using this toolbox for research or industrial purposes, please cite:
% G. Papazafeiropoulos, M. Muniz-Calvente, E. Martinez-Paneda.
% Abaqus2Matlab: a suitable tool for finite element post-processing (submitted)
%
%


% Open the results file for reading
[fileID,errmsg] = fopen(ResultsFileName,'r');
if fileID < 0
    error(errmsg)
end
% Read data from results file as a string and assign them to a cell array
% Concatenate each line without specifying delimiter, whitespace or end of
% line characters
try
    C = textscan (fileID, '%s', 'CollectOutput', '1', 'delimiter', ...
        '','whitespace','','endofline','');
catch
    C = textscan (fileID, '%s', 'CollectOutput', 1, 'delimiter', ...
        '','whitespace','','endofline','');
end
% Close the results file
fclose(fileID);
% Assign A
A = C{1}{1};
% Remove newline characters
A1 = strrep(A,sprintf('\n'),'');
% Remove carriage return characters
Rec = strrep(A1,sprintf('\r'),'');


end

