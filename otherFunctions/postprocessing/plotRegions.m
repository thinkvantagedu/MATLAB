% plot the data.mat file in otherFunction
% complete structure.
elem = canti.elem.all; 
coor = canti.node.all;
nelem = size(elem, 1);
nnode = size(coor, 1);
ninc = length(canti.node.inc1);
x = coor(:, 2); y = coor(:, 3);
cs = trisurf(elem(:,2:4), x, y, zeros(nnode, 1));
set(cs, 'FaceColor', 'y', 'CDataMapping', 'scaled');
view(2);
hold on
for i = 1:canti.no.inc - 1
    
    in = trisurf(elem(canti.elem.inc{i}, 2:4), x, y, zeros(nnode, 1));
    
end

axis equal