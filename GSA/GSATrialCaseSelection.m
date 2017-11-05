function [INPfilename, MTX_M, MTX_K, loc_string_start, loc_string_end] = ...
    GSATrialCaseSelection(trialName, lin)

switch trialName
    case 'l2h1'
        if lin == 0
            route = '/Users/kevin/GoogleDrive/Temp/FE_model/';
        else
            route = '/home/xiaohan/Desktop/Temp/FE_model/';
        end
        INPfilename = strcat(route, 'L2H1_dynamics.inp');
        MTX_M.file = strcat(route, 'L2H1_dynamics_mtx_MASS1.mtx');
        MTX_K.file.I1120S0 = strcat(route, 'L2H1_dynamics_1120S0_STIF1.mtx');
        MTX_K.file.I1021S0 = strcat(route, 'L2H1_dynamics_1021S0_STIF1.mtx');
        MTX_K.file.I1020S1 = strcat(route, 'L2H1_dynamics_1020S1_STIF1.mtx');
        loc_string_start = 'nset=Set-lc';
        loc_string_end = 'End Assembly';
        
    case 'l9h2Coarse'
        if lin == 0
            route = '/Users/kevin/GoogleDrive/Temp/FE_model/';
        else
            route = '/home/xiaohan/Desktop/Temp/FE_model/';
        end
        INPfilename = strcat(route, 'FE_L9H2_coarse.inp');
        MTX_M.file = strcat(route, 'FE_L9H2_coarse_MASS1.mtx');
        MTX_K.file.I1120S0 = strcat(route, 'FE_L9H2_coarse_1120S0_STIF1.mtx');
        MTX_K.file.I1021S0 = strcat(route, 'FE_L9H2_coarse_1021S0_STIF1.mtx');
        MTX_K.file.I1020S1 = strcat(route, 'FE_L9H2_coarse_1020S1_STIF1.mtx');
        loc_string_start = 'nset=Set-lc';
        loc_string_end = 'Elset, elset=Set-lc';
        
end