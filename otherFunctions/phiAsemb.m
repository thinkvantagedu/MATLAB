% clear; clc;
% this script generate the assembled reduced basis matrix (the giant one,
% size = 3nrnt * 3nrnt). 
nd = 2;
nt = 11;
nr = 2;
%% generate reduced basis.
phi = rand(nd, nr);

psi = cell(3, 3);

for i = 1:3
    for j = 1:3
        if i == j
            psi(i, j) = {phi};
        else
            psi(i, j) = {zeros(nd, nr)};
        end
    end
end

psi = cell2mat(psi);

Psi = cell(nt, nt);

for i = 1:nt
    for j = 1:nt
        if i == j
            Psi(i, j) = {psi};
        else
            Psi(i, j) = {zeros(3 * nd, 3 * nr)};
        end
    end
end

Psi = cell2mat(Psi);

figure(1);
spy(Psi);
set(get(gca,'children'),'color','k')
set(gca,'xticklabel',{[]})
set(gca,'yticklabel',{[]})
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
axis square
