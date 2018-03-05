clear; clc;

jobPath = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
% inpName = 'l9h2SingleInc';
% inpPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/fixBeam/';
inpName = 'L2H1_dynamics';
inpPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/cantileverBeam/';

otptPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/modified/';

% read the entire .inp file.
inpText = fopen(strcat(inpPath, inpName, '.inp'));
rawStrCell = textscan(inpText, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(inpText);

runStr = strcat(jobPath, inpName, ' inp=', inpPath, ...
    inpName, '.inp interactive ask_delete=OFF');
system(runStr);
    
% % locate the string to be modified.
% pmStr = '*Material, name=Material-I1';
% for iStr = 1:length(rawStrCell{1})
%     if strcmp(rawStrCell{1}{iStr}, pmStr) == 1
%         lineStr = iStr;
%     end
% end
% lineMod = lineStr + 4;
% 
% % split the strings, find the num str to be
% % modified. 
% splitStr = strsplit(rawStrCell{:}{lineMod});
% posRatio = splitStr{2};
% 
% % define the logarithm input.
% pmInp = 0.00000001;
% % set the text file to be written.
% 
% otptStrCell = rawStrCell;
% 
% for iIter = 1:length(pmInp)
%     
%     inpNameIter = [otptPath, inpName, '_PmIter.inp'];
%     fid = fopen(inpNameIter, 'wt');
%     pmIter = pmInp(iIter);
%     strIter = [num2str(pmIter), ', ', posRatio];
%     otptStrCell{:}(lineMod) = {strIter};
%     fprintf(fid, '%s\n', string(otptStrCell{:}));
%     fclose(fid);
%     % run Abaqus for each pm value.
%     runStr = strcat(jobPath, inpName, ' inp=', inpPath, ...
%         inpName, '.inp interactive ask_delete=OFF');
%     system(runStr);
%     
%     
%     [resData]=importdata...
%         ('/home/xiaohan/Desktop/Temp/AbaqusModels/l9h2SingleInc.dat');
%     
% end