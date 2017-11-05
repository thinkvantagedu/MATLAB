function [deformed_elem_cd]=LatticeMesh2DDeformedCoords(free_nd, nd, Ur, constrained_nd, elem_mp)


free_dof=zeros(size(free_nd,2),2);

for i_free_nodes=1:size(free_nd,2)
    
    free_dof(i_free_nodes,:)=nd(free_nd(i_free_nodes),:);
    
end
%%
free_dof_in_row=zeros(1,2*size(free_nd,2));

tr_free_dof=free_dof';

for i_fd=1:size(free_dof(:,1))
    
    free_dof_in_row(2*i_fd-1:2*i_fd)=tr_free_dof(:,i_fd);

end
%%
j_free_nodes=1:size(Ur,1);

x_y_position=mod(j_free_nodes,3)~=0;%mod: Modulus after division

Ur_x_y=zeros(2*size(free_nd,2),1);

k_free_nodes=find(x_y_position==1);

for i_ur_x_y=1:size(k_free_nodes,2)
    
    Ur_x_y(i_ur_x_y)=Ur(k_free_nodes(i_ur_x_y));
    
end

deformed_cd=Ur_x_y+free_dof_in_row';
%%
tr_deformed_cd=[];

for i_tr_deformed_cd=1:size(deformed_cd,1)/2
            
    x1=deformed_cd(2*i_tr_deformed_cd-1);
    y1=deformed_cd(2*i_tr_deformed_cd);
    tr_deformed_cd=[tr_deformed_cd;[x1 y1]];

end

%%
full_tr_deformed_cd=zeros(size(nd,1),2);

full_tr_deformed_cd(free_nd,:)=...
    full_tr_deformed_cd(free_nd,:)+tr_deformed_cd;
full_tr_deformed_cd(constrained_nd,:)=...
    full_tr_deformed_cd(constrained_nd,:)+nd(constrained_nd,:);
%for deformed cds, +tr_deformed_coords; for fixed coords, +node
%%
deformed_elem_cd=zeros(size(elem_mp,1),4);
for i_dec=1:size(nd,1) 
    
    a=find(elem_mp(:,1)==i_dec);
    b=find(elem_mp(:,2)==i_dec);
    
    deformed_elem_cd(a,1)=deformed_elem_cd(a,1)+...
        full_tr_deformed_cd(i_dec);
    deformed_elem_cd(b,3)=deformed_elem_cd(b,3)+...
        full_tr_deformed_cd(i_dec);
 
end

for i_dec=(size(nd,1)+1):(2*size(nd,1))
    
    a=find(elem_mp(:,1)==i_dec-size(nd,1));
    b=find(elem_mp(:,2)==i_dec-size(nd,1));

    deformed_elem_cd(a,2)=deformed_elem_cd(a,2)+...
        full_tr_deformed_cd(i_dec);
    deformed_elem_cd(b,4)=deformed_elem_cd(b,4)+...
        full_tr_deformed_cd(i_dec);
        
end
