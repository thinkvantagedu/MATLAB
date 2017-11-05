function [nodal_force]=NodalForce(nd, nodalforce)
% INPUT: location of the nodal force
% nd=node array
% nodalforce.nf_nd=force node
% nodalforce.nd_force=force value
% OUTPUT: nodal force array

nodal_force=sparse(3*size(nd,1),1);
nf_node=nodalforce.nf_nd';%number of nds: (bx+1)*(by/2+1)+(bx+2)*by/2
for i_nf_node=1:size(nd,1)
    
    j_nf_node=any(i_nf_node==nf_node);
    
    if j_nf_node==1
        
% nodal_force((i_nf_nds-1)*3+1,1)=input('input nf_nodes force in x:');
% nodal_force((i_nf_nds-1)*3+2,1)=input('input nf_nodes force in y:');
% nodal_force((i_nf_nds-1)*3+3,1)=input('input nf_nodes moment in z:');
    nodal_force((i_nf_node-1)*3+1,1)=0;
    nodal_force((i_nf_node-1)*3+2,1)=nodalforce.nd_force;
    nodal_force((i_nf_node-1)*3+3,1)=0;
    
    end
    
end
