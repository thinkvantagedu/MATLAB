clear; clc; clf

nIter = 10;
pmStruct = cell(nIter, 1);

pmStruct{1} = 0;
y = 1;
scatter(10 .^ pmStruct{1}, y, 60, 'filled', 'k')
hold on
for iS = 2:nIter
    
    y = (iS) * ones(1, iS);
    pmStruct{iS} = 10 .^ linspace(-1, 1, iS);
    scatter(pmStruct{iS}, y, 60, 'filled', 'k')
    
end

grid on
set(gca, 'XScale', 'log')
xlabel('Young''s modulus', 'FontSize', 20);
ylabel('Iterations', 'FontSize', 20);
set(gca,'fontsize',20)
