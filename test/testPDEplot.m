% % 2d
% model = createpde;
% geometryFromEdges(model,@lshapeg);
% mesh = generateMesh(model);
% pdeplot(model)


% 3d
clf
structuralmodel = createpde('structural','static-solid');
importGeometry(structuralmodel,'SquareBeam.STL');
structuralProperties(structuralmodel,'PoissonsRatio',0.3, ...
    'YoungsModulus',210E3);
structuralBC(structuralmodel,'Face',6,'Constraint','fixed');
structuralBoundaryLoad(structuralmodel,'Face',5,'SurfaceTraction',[0;0;-2]);
generateMesh(structuralmodel);
structuralresults = solve(structuralmodel);

% pdeplot3D(structuralmodel,'ColorMapData',structuralresults.VonMisesStress, ...
%     'Deformation',structuralresults.Displacement)


nodes = structuralmodel.Mesh.Nodes;
elems = [structuralmodel.Mesh.Elements; zeros(1, length(structuralmodel.Mesh.Elements))];

disT.x = structuralresults.Displacement.ux;
disT.y = structuralresults.Displacement.uy;
disT.z = structuralresults.Displacement.uz;
disT.mag = structuralresults.Displacement.Magnitude;
%%
pdeplot3D(nodes, elems,'ColorMapData',disT.y, 'Deformation',structuralresults.Displacement, ...
    'DeformationScaleFactor', 100)