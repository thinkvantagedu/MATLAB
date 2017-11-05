function [constraints,free_nd,constrained_nd]=RectangleConstraints(bcconstraints,nd)

%%=========================================================================

% xywh=[bcconstraints.x,bcconstraints.y,bcconstraints.w,bcconstraints.h];

% rectangle('position',xywh);%rectangle('position',[x,y,w,h]),begin at x,y, 
% width w, height h
% corner a,b,c,d are in anti-clock wise direction for the rectangle
corner_a=[bcconstraints.x,bcconstraints.y];
corner_b=[bcconstraints.x+bcconstraints.w,bcconstraints.y];
corner_c=[bcconstraints.x+bcconstraints.w,bcconstraints.y+bcconstraints.h];
corner_d=[bcconstraints.x,bcconstraints.y+bcconstraints.h];
rec_a=find(corner_a(1)<nd(:,1)&corner_a(2)<nd(:,2));
rec_b=find(corner_b(1)>nd(:,1)&corner_b(2)<nd(:,2));
rec_c=find(corner_c(1)>nd(:,1)&corner_c(2)>nd(:,2));
rec_d=find(corner_d(1)<nd(:,1)&corner_d(2)>nd(:,2));
rec_i_a=intersect(rec_a,rec_b);
rec_i_b=intersect(rec_i_a,rec_c);
constrained_nd_number=intersect(rec_i_b,rec_d);

constrained_nd=constrained_nd_number;
constraints=sparse(3*size(nd,1),1);

all_nd=1:size(nd(:,1));
free_nd=setdiff(all_nd,constrained_nd);

for i_rst=1:size(nd,1)
    
    j_rst=any(i_rst==constrained_nd);
    
    if j_rst==1
        
%       constraints((i_rst-1)*3+1,1)=input('input nodal constraint in x:');
%       constraints((i_rst-1)*3+1,1)=input('input nodal constraint in y:');
%       constraints((i_rst-1)*3+1,1)=input('input nodal constraint in z:');
        constraints((i_rst-1)*3+1,1)=1;
        constraints((i_rst-1)*3+2,1)=1;
        constraints((i_rst-1)*3+3,1)=1;
    
    end
    
end
