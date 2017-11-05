function [INPname, mas, sti1, sti2, stis, locStartConsLc, locEndConsLc, ...
    locStartConsRc, locEndConsRc] = trialCaseSelectionSingleInc(trialName, lin)

if lin == 0
    route = '/Users/kevin/GoogleDrive/Temp/FE_model/cantileverBeam/';
else
    route = '/home/xiaohan/Desktop/Temp/FE_model/fixBeam/';
end

switch trialName
    
    case 'l9h2SingleInc'
        
        INPname = strcat(route, 'l9h2SingleInc.inp');
        mas = strcat(route, 'l9h2SingleInc_MASS1.mtx');
        sti1 = strcat(route, 'l9h2SingleIncI1S0_STIF1.mtx');
        sti2 = nan(1);
        stis = strcat(route, 'l9h2SingleIncI0S1_STIF1.mtx');
        locStartConsLc = 'nset=Set-lc';
        locEndConsLc = 'elset=Set-lc';
        locStartConsRc = 'nset=Set-rc';
        locEndConsRc = 'elset=Set-rc';
        
end
end