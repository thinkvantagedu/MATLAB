elem = canti.elem.all;
nd1 = canti.node.inc1;
nd = canti.no.node.all;

nelem = canti.no.elem;

connSwitch = zeros(nd, 1);

noNd1 = nd1(:, 1);

connSwitch(noNd1) = 1;

elemInc1 = [];

for i = 1:nelem
    
    ind = (connSwitch(elem(i, 2:4)))';
    if isequal(ind, ones(1, 3)) == 1
        elemInc1 = [elemInc1; elem(i, 1)];
    end
    
end