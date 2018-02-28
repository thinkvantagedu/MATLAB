%% DISPLACEMENT output from Abaqus to Matlab (Record key 101)
% In this example a simple Abaqus model is analysed and results are
% retrieved by postprocessing the results *.fil file generated by Abaqus
% using Matlab. For more information please see the <Documentation.html
% Documentation of Abaqus2Matlab toolbox>.
%% Run Abaqus model
S = which('Documentation.m');
% Change current directory to Abaqus working directory
a = strfind(S,'\');
cd(S(1:a(end)-1))
%%
% Copy the input file to be run by Abaqus into the Abaqus working directory
copyfile([S(1:a(end)-1),'\AbaqusInputFiles\101.inp'],[S(1:a(end)-1),'\101.inp'],'f')
%%
% Run the input file 101.inp with Abaqus
!abaqus job=101
%%
% Pause Matlab execution to give Abaqus enough time to create the lck file
pause(10)
%%
% If the lck file exists then halt Matlab execution
while exist('101.lck','file')==2
    pause(0.1)
end
%% Postprocess Abaqus results file with Matlab
% Assign all lines of the fil file in an one-row string (after Abaqus
% analysis terminates)
Rec = Fil2str('101.fil');
%%
% Obtain the desired output data
out = Rec101(Rec)
%% Verify output
% Check number of attributes
nAttr=size(out,2)
%%
% Check the number of entries
nEntr=size(out,1)
%%
% Check class of output
cOut=class(out)

%%
%
%  ________________________________________________________________________
%  Abaqus2Matlab - www.abaqus2matlab.com
%  Copyright (c) 2016 by George Papazafeiropoulos
%
%  If using this toolbox for research or industrial purposes, please cite:
%  G. Papazafeiropoulos, M. Muniz-Calvente, E. Martinez-Paneda.
%  Abaqus2Matlab: a suitable tool for finite element post-processing 
%  (submitted)

