clear variables; clc;

pmEXP_maxLoc10 = 10;
pmEXP_maxLoc20 = 10;

pmEXPnoIdx_inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 50 25; 25 50];
no_inpt0 = length(pmEXPnoIdx_inpt(:, 1));
% pmEXP_inptVal = [(1:no_inpt0)' pmEXPnoIdx_inpt];
%% test: coarse refinement.

pmEXP_inpt0 = GSAGridtoBlockNoIndx(pmEXPnoIdx_inpt);