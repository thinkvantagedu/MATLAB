function [QOI,QOI_number]=RectangleQOI(qoirow, nd, free_dof)
%quantity of interest
%%=========================================================================

xywh=[qoirow.x,qoirow.y,qoirow.w,qoirow.h];

% rectangle('position',xywh);%rectangle('position',[x,y,w,h]),begin at x,y, 
%width w, height h
%corner a,b,c,d are in anti-clock wise direction for the rectangle
corner_a=[qoirow.x,qoirow.y];
corner_b=[qoirow.x+qoirow.w,qoirow.y];
corner_c=[qoirow.x+qoirow.w,qoirow.y+qoirow.h];
corner_d=[qoirow.x,qoirow.y+qoirow.h];
rec_a=find(corner_a(1)<nd(:,1)&corner_a(2)<nd(:,2));
rec_b=find(corner_b(1)>nd(:,1)&corner_b(2)<nd(:,2));
rec_c=find(corner_c(1)>nd(:,1)&corner_c(2)>nd(:,2));
rec_d=find(corner_d(1)<nd(:,1)&corner_d(2)>nd(:,2));
rec_i_a=intersect(rec_a,rec_b);
rec_i_b=intersect(rec_i_a,rec_c);
QOI_number=intersect(rec_i_b,rec_d);
%%-------------------------------------------------------------------------
QOI_1=zeros(size(nd,1)*3,1);
for i_qoi=1:size(QOI_1,1)
    j_qoi=any(i_qoi==QOI_number);
    if j_qoi==1
        QOI_1((i_qoi-1)*3+1,1)=1;
        QOI_1((i_qoi-1)*3+2,1)=1;
        QOI_1((i_qoi-1)*3+3,1)=1;    
    end
end
QOI=QOI_1(free_dof);
