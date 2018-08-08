function [INPname, mas, sti, locStartCons, locEndCons, noIncl] = ...
    trialCaseSelect(trialName, lin)
% Define the different cases. 
% Input: 
% trialName: includes l2h1, l9h2Coarse, l9h2MultiInc, airfoilSim, 
% airfoilMedium, airfoilLarge, l9h2SingleInc. 
% lin: defines the directory, 0 for Mac and 1 for Linux.
% Output: 
% INPname: dir and name of the Abaqus inp file.
% mas, sti: dir and name of Abaqus mass and stiffness files.
% locStartCons, locEndCons: start and end string of the constraints, to
% know where to look for. 
% noIncl: number of inclusions. 
if lin == 0
    route = '/Users/kevin/GoogleDrive/AbaqusModels/cantileverBeam/';
elseif lin == 1
    route = '/home/xiaohan/Desktop/Temp/AbaqusModels/cantileverBeam/';
end
switch trialName
    case 'l2h1'
        
        INPname = strcat(route, 'L2H1_dynamics.inp');
        mas = strcat(route, 'L2H1_dynamics_mtx_MASS1.mtx');
        sti1 = strcat(route, 'L2H1_dynamics_1120S0_STIF1.mtx');
        sti2 = strcat(route, 'L2H1_dynamics_1021S0_STIF1.mtx');
        stis = strcat(route, 'L2H1_dynamics_1020S1_STIF1.mtx');
        locStartCons = {'nset=Set-lc'};
        locEndCons = {'End Assembly'};
        sti = {sti1; sti2; stis};
        noIncl = 2;
        
    case 'l9h2Coarse'
        
        INPname = strcat(route, 'FE_L9H2_coarse.inp');
        mas = strcat(route, 'FE_L9H2_coarse_MASS1.mtx');
        sti1 = strcat(route, 'FE_L9H2_coarse_1120S0_STIF1.mtx');
        sti2 = strcat(route, 'FE_L9H2_coarse_1021S0_STIF1.mtx');
        stis = strcat(route, 'FE_L9H2_coarse_1020S1_STIF1.mtx');
        locStartCons = {'nset=Set-lc'};
        locEndCons = {'Elset, elset=Set-lc'};
        sti = {sti1; sti2; stis};
        noIncl = 2;
        
    case 'l9h2MultiInc'
        % 9 inclusions, for plot purpose
        INPname = strcat(route, 'l9h2_multiInc.inp');
        mas = strcat(route, 'l9h2_multiIncMtx_MASS1.mtx');
        sti1 = nan(1);
        sti2 = nan(1);
        stis = strcat(route, 'l9h2_multiIncMtx_STIF1.mtx');
        locStartCons = {nan(1)};
        locEndCons = {nan(1)};
        sti = {sti1; sti2; stis};
        noIncl = 9;
        
    case 'airfoilSim'
        airfoilstr = 'airfoil/';
        INPname = strcat(route, airfoilstr, 'airfoilSim.inp');
        mas = strcat(route, airfoilstr, 'airfoilSim_MASS1.mtx');
        sti1 = strcat(route, airfoilstr, 'airfoilSimI1120s0_STIF1.mtx');
        sti2 = strcat(route, airfoilstr, 'airfoilSimI1021s0_STIF1.mtx');
        stis = strcat(route, airfoilstr, 'airfoilSimI1020s1_STIF1.mtx');
        locStartCons = {'nset=Set-lc'};
        locEndCons = {'Elset, elset=Set-lc'};
        sti = {sti1; sti2; stis};
        noIncl = 2;
        
    case 'airfoilMedium'
        airfoilstr = 'airfoil/';
        INPname = strcat(route, airfoilstr, 'airfoilMedium.inp');
        mas = strcat(route, airfoilstr, 'airfoilMedium_MASS1.mtx');
        sti1 = strcat(route, airfoilstr, 'airfoilMediumI1120s0_STIF1.mtx');
        sti2 = strcat(route, airfoilstr, 'airfoilMediumI1021s0_STIF1.mtx');
        stis = strcat(route, airfoilstr, 'airfoilMediumI1020s1_STIF1.mtx');
        locStartCons = {'nset=Set-lc'};
        locEndCons = {'Elset, elset=Set-lc'};
        sti = {sti1; sti2; stis};
        noIncl = 2;
        
    case 'airfoilLarge'
        airfoilstr = 'airfoil/';
        INPname = strcat(route, airfoilstr, 'airfoilLarge.inp');
        mas = strcat(route, airfoilstr, 'airfoilLarge_MASS1.mtx');
        sti1 = strcat(route, airfoilstr, 'airfoilLargeI1120s0_STIF1.mtx');
        sti2 = strcat(route, airfoilstr, 'airfoilLargeI1021s0_STIF1.mtx');
        stis = strcat(route, airfoilstr, 'airfoilLargeI1020s1_STIF1.mtx');
        locStartCons = {'nset=Set-lc'};
        locEndCons = {'Elset, elset=Set-lc'};
        sti = {sti1; sti2; stis};
        noIncl = 2;
        
    case 'l9h2SingleInc'
        % l = 90, h = 20, li = 35.8, ri = 54.2
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/fixBeam/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/fixBeam/';
        end
        INPname = strcat(route, 'l9h2SingleInc.inp');
        mas = strcat(route, 'l9h2SingleInc_MASS1.mtx');
        sti1 = strcat(route, 'l9h2SingleIncI1S0_STIF1.mtx');
        stis = strcat(route, 'l9h2SingleIncI0S1_STIF1.mtx');
        locStartConsLc = 'nset=Set-lc';
        locEndConsLc = 'elset=Set-lc';
        locStartConsRc = 'nset=Set-rc';
        locEndConsRc = 'elset=Set-rc';
        sti = {sti1; stis};
        locStartCons = {locStartConsLc; locStartConsRc};
        locEndCons = {locEndConsLc; locEndConsRc};
        noIncl = 1;
        
    case 'ONERA_M6'
        % l = 90, h = 20, li = 35.8, ri = 54.2
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/airfoil/';
        end
        INPname = strcat(route, 'ONERA_M6.inp');
        mas = strcat(route, 'ONERA_M6_MASS1.mtx');
        sti1 = strcat(route, 'ONERA_M6_I1S0_STIF1.mtx');
        stis = strcat(route, 'ONERA_M6_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
        
    case 'ONERA_M6_142nodes'
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/142nodes_seed35/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/airfoil/142nodes_seed35/';
        end
        INPname = strcat(route, 'ONERA_M6_142nodes.inp');
        mas = strcat(route, 'ONERA_M6_142nodes_MASS1.mtx');
        sti1 = strcat(route, 'ONERA_M6_142nodes_I1S0_STIF1.mtx');
        stis = strcat(route, 'ONERA_M6_142nodes_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
        
    case 'ONERA_M6_3683nodes'
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/3683nodes_seed6/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/airfoil/3683nodes_seed6/';
        end
        INPname = strcat(route, 'ONERA_M6_3683nodes.inp');
        mas = strcat(route, 'ONERA_M6_3683nodes_MASS1.mtx');
        sti1 = strcat(route, 'ONERA_M6_3683nodes_I1S0_STIF1.mtx');
        stis = strcat(route, 'ONERA_M6_3683nodes_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
        
    case 'ONERA_M6_6317nodes'
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/6317nodes_seed5/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/airfoil/6317nodes_seed5/';
        end
        INPname = strcat(route, 'ONERA_M6_6317nodes.inp');
        mas = strcat(route, 'ONERA_M6_6317nodes_MASS1.mtx');
        sti1 = strcat(route, 'ONERA_M6_6317nodes_I1S0_STIF1.mtx');
        stis = strcat(route, 'ONERA_M6_6317nodes_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
    case 'Ibeam_882nodes'
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/Ibeam/882nodes_seed60/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/Ibeam/882nodes_seed60/';
        end
        INPname = strcat(route, '882nodes_seed60.inp');
        mas = strcat(route, '882nodes_seed60_MASS1.mtx');
        sti1 = strcat(route, '882nodes_seed60_I1S0_STIF1.mtx');
        stis = strcat(route, '882nodes_seed60_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
    case 'Ibeam_3146nodes'
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/Ibeam/3146nodes_seed25/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/Ibeam/3146nodes_seed25/';
        end
        INPname = strcat(route, '3146nodes_seed25.inp');
        mas = strcat(route, '3146nodes_seed25_MASS1.mtx');
        sti1 = strcat(route, '3146nodes_seed25_I1S0_STIF1.mtx');
        stis = strcat(route, '3146nodes_seed25_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
    case 'Ibeam_8295nodes'
        if lin == 1
            route = '/home/xiaohan/Desktop/Temp/AbaqusModels/Ibeam/8295nodes_seed15/';
        elseif lin == 0
            route = '/Users/kevin/GoogleDrive/AbaqusModels/Ibeam/8295nodes_seed15/';
        end
        INPname = strcat(route, '8295nodes_seed15.inp');
        mas = strcat(route, '8295nodes_seed15_MASS1.mtx');
        sti1 = strcat(route, '8295nodes_seed15_I1S0_STIF1.mtx');
        stis = strcat(route, '8295nodes_seed15_I0S1_STIF1.mtx');
        sti = {sti1; stis};
        locStartCons = {'nset=Set-root'};
        locEndCons = {'elset=Set-root'};
        noIncl = 1;
end
end