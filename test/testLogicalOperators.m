% this script check the use of logic operators && and ||.


if cg == 1 && en == 1 && re == 0
    disp('initial, enrich')
elseif cg ~= 1 && en == 1 && re == 0
    disp('successive, enrich')
elseif cg == 1 && en == 0 && re == 1
    disp('initial, refine')
elseif cg ~= 1 && en == 0 && re == 1
    disp('successive, refine')
end



if en == 1 && re == 0
    disp('===== enrich, compute')
elseif cg == 1 || en == 0 && re == 1
    disp('===== refine, inherit')
end