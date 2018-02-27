function plotDeformedStruct(node, elem, dis, deformFactor, labelSwitch)
% input displacement and structure info, plot deformed structure, 
% for triangular elements.

%% deform factor decides how much the deformation is enlarged.
% dis = Dis.OR.otpt.trial.exact(:, 2);
% label_switch = 0;
% deform_factor = 1;
% dis = zeros(canti.no.node.all * 2, 1);
% node = canti.node.all;
% elem = canti.elem.all;
%% get number info.
ndof = size(dis, 1);
nnode = size(node, 1);
%% node number without indices.
enode = elem(:, 2:4);

%% reshape free node displacements to no.dof*2 size.
disFreeRow = reshape(dis, [2, ndof/2]);
disFreeRow = disFreeRow';


%% add deformation to coordinates, obtain deformed structure.
defNode = node(:, 2:3) + disFreeRow * deformFactor;

%% plot deformed triangular elements.
triplot(enode, defNode(:, 1), defNode(:, 2), 'color', [0.5 0.5 0.5]);

%% label each node.
if labelSwitch == 1
    for i3 = 1:nnode
        node_str = num2str(node(i3, 1));
        text(node(i3, 2), node(i3, 3), node_str);
    end
end

% axis([-10 100 -5 25]);

axis equal