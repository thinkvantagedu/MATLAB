clear; clc;

pmEXP_maxLoc10 = 10;
pmEXP_maxLoc20 = 10;
pmEXPnoIdx_inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 50 25; 25 50];
no_inpt0 = length(pmEXPnoIdx_inpt(:, 1));
pmEXP_inptVal = [(1:no_inpt0)' pmEXPnoIdx_inpt];

%% test: coarse refinement.

pmEXP_inpt0 = GSAGridtoBlockwithIndx(pmEXP_inptVal);

[pmEXP_otpt0, pmEXP_otptRaw0] = GSARefineGridLocalwithIdx...
    (pmEXP_inpt0, pmEXP_maxLoc10, pmEXP_maxLoc20);


no = 50:10:100;

for i = 1:length(no)
    
    a = rand(no(i));
    
    x = 1:no(i);
    
    y = 1:no(i);
    
    g1 = subplot(3, 4, 2 * i - 1);
    
    pos = get(g1, 'position');
    
    pos(1) = pos(1) + 0.03 ;
    
    pos(2) = pos(2) ;
    
    pos(3) = pos(3) * 1.1;
    
    pos(4) = pos(4) * 1.1;
    
    set(g1, 'position', pos);
    
    surf(x, y, a);
    

    
    
    g2 = subplot(3, 4, 2 * i);
    
    pos = get(g2, 'position');
    
    pos(1) = pos(1) + 0.03;
    
    pos(2) = pos(2) + 0.15;
    
    pos(3) = pos(3) * 0.5;
    
    pos(4) = pos(4) * 0.5;
        
    set(g2, 'position', pos);
    
    PlotLocalRefiGridwithIndex(pmEXP_inpt0)
    
end