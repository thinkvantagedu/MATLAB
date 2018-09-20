model = createpde;
importGeometry(model,'Tetrahedron.stl');
mesh = generateMesh(model,'Hmax',20,'GeometricOrder','linear');
node = mesh.Nodes;
elem = mesh.Elements;
elem(5, :) = zeros(1, 64);
pdeplot3D(node, elem)