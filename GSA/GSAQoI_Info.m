function [qoi_seq, no_qoi_node, qoi_dof, no_qoi_dof] = GSAQoI_Info(node, l, r, u, d)
%% compute information for QoI, 
qoi_seq = QOIRectangularRange(node, l, r, u, d);
no_qoi_node = length(qoi_seq);
qoi_dof = zeros(2*no_qoi_node, 1);
for i_qoi_dof = 1:no_qoi_node
    qoi_dof(i_qoi_dof*2-1:i_qoi_dof*2) = qoi_dof(i_qoi_dof*2-1:i_qoi_dof*2)+...
        [2*qoi_seq(i_qoi_dof)-1; 2*qoi_seq(i_qoi_dof)];
end
no_qoi_dof = length(qoi_dof);