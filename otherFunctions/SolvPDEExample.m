model = createpde();
geometryFromEdges(model,@circleg);
applyBoundaryCondition(model,'Edge',1:model.Geometry.NumEdges,'u',0);
c = 1;
a = 0;
f = 1;
specifyCoefficients(model,'m',0,'d',0,'c',c,'a',a,'f',f);
hmax = 1;
generateMesh(model,'Hmax',hmax);
error = []; err = 1;
while err > 0.001, % run until error <= 0.001
    hmax = hmax/2;
    generateMesh(model,'Hmax',hmax);% refine mesh
    results = solvepde(model);
    u = results.NodalSolution;
    p = model.Mesh.Nodes;
    exact = -(p(1,:).^2+p(2,:).^2-1)/4;
    err = norm(u-exact',inf); % compare with exact solution
    error = [error err]; % keep history of err
end
plot(error,'rx','MarkerSize',12);
ax = gca;
ax.XTick = 1:numel(error);
title('Error History');
xlabel('Iteration');
ylabel('Norm of Error');
figure
pdeplot(model,'xydata',u-exact') % plot error
title('Final Error');
xlabel('x')
ylabel('y')