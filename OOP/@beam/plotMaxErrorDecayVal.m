function obj = plotMaxErrorDecayVal(obj, errType, color, width, randomSwitch)
errx = obj.no.store.rb;

switch errType
    case 'original'
        erry = obj.err.store.max;
    case 'hhat'
        erry = obj.err.store.max.hhat;
    case 'verify'
        erry = obj.err.store.max.verify;
end

figure
semilogy(errx, erry, color, 'lineWidth', width);
hold on
axis([0 inf 0 erry(1)])

if randomSwitch == 0
    xticks(errx);
elseif randomSwitch == 1
    
end

xlabel('N')
ylabel('Maximum error')

grid on
set(gca, 'FontSize', 20)
axis square

end