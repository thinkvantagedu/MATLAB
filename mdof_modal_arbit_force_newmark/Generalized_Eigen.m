function[fn,omega,ModeShapes,MST]=Generalized_Eigen(S2,M2,ijk)
%
%  Generalized_Eigen.m  ver 2.2  May 3, 2010
%  by Tom Irvine
%
[ModeShapes,Eigenvalues]=eig(S2,M2);
%
clear EEE;
clear max;
szz=max(size(Eigenvalues));
for(i=1:szz)
    EEE(i,1)=abs(Eigenvalues(i,i));
end
EEE(:,2:szz+1)=ModeShapes';
EEE=sortrows(EEE);
Eigenvalues=EEE(:,1);
ModeShapes=EEE(:,2:szz+1)';
%
omega = sqrt(Eigenvalues);
dof=max(size(omega));
%
if(ijk==1 || ijk==3)
	disp(' Natural Frequencies ');
    disp(' No.      f(Hz)');
end
for(i=1:dof)
    fn(i)=omega(i)/(2*pi);
    if(ijk==1 || ijk==3)
       out1=sprintf('%d.  %12.5g ',i,fn(i));
       disp(out1);
    end
end
%
clear MST;
clear temp;
clear QTMQ;
%
MST=ModeShapes';
temp=zeros(dof,dof);
temp=M2*ModeShapes;
QTMQ=MST*temp;
%   
clear scale;
for(i=1:dof)
    scale(i)=1./sqrt(QTMQ(i,i));
    if(sum(ModeShapes(:,i))<0)
        scale=-scale;
    end
    ModeShapes(:,i) = ModeShapes(:,i)*scale(i);    
end
%
MST=ModeShapes';
%
if(ijk==1)
   disp(' ');
   disp('  Modes Shapes (column format)');
   ModeShapes
end