clear; clc;

% jobPath = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
% jobName = 'l9h2SingleInc';
inpPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/fixBeam/';
inpName = 'l9h2SingleInc';

% runStr = strcat(jobPath, jobName, ' inp=', inpPath, inpName, '.inp interactive');

% dos(runStr);

inpText = fopen(strcat(inpPath, inpName, '.inp'));
rawStrCell = textscan(inpText, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(inpText);
pmStr = '*Material, name=Material-I1';

for iStr = 1:length(rawStrCell{1})
    if strcmp(rawStrCell{1}{iStr}, pmStr) == 1
        lineStr = iStr;
    end
end

lineMod = lineStr + 4;