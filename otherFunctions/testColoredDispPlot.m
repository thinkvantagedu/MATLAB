% deform_factor = 3;
% label_switch = 0;
% 
% PlotDeformedStruct(node, cons.dof, elem, Dis.trial.exact(:, 30), deform_factor, label_switch);

x=1:0.1:4;
y=1:0.1:4;
[X,Y]=meshgrid(x,y);
Z=sin(X).^2+cos(Y).^2;
surf(X,Y,Z);
view(2)