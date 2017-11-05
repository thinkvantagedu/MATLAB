function [global_K]=GlobalStiffnessMatrix(x1,y1,x2,y2,E,A,I)


% dp=[];
% dp=[y2-y1;x2-x1];

% L=[];
L=sqrt((y2-y1)^2+(x2-x1)^2);


Cx=(x2-x1)/L;
Cy=(y2-y1)/L;

% R=[Cx Cy 0;-Cy Cx 0;0 0 1];

part1=E*A/L;
part2=4*E*I/L;
part3=1.5*part2/L;
part4=2*part3/L;

c1=part1*Cx*Cx+part4*Cy*Cy;
c2=(part1-part4)*Cx*Cy;
c3=-part3*Cy;
c4=part1*Cy*Cy+part4*Cx*Cx;
c5=part3*Cx;

global_K_1=[c1 c2 c3 -c1 -c2 c3;...
    c2 c4 c5 -c2 -c4 c5;...
    c3 c5 part2 -c3 -c5 part2/2;...
    -c1 -c2 -c3 c1 c2 -c3;...
    -c2 -c4 -c5 c2 c4 -c5;...
    c3 c5 part2/2 -c3 -c5 part2];

global_K=sparse(global_K_1);
