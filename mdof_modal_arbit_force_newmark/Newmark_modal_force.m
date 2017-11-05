%
%   Newmark_modal_force  ver 1.3  November 11, 2013
%
function[U,Ud,Udd]=...
   Newmark_modal_force(DI,VI,dt,NT,ndof,damp,omegan,FFI,force_dof,ModeShapes,M)
%
disp(' ');
out1=sprintf(' Select number of modes to include (max=%d) ',ndof);
num_modes=input(out1);
if(num_modes>ndof)
    num_modes=ndof;
end
%
MS=ModeShapes(:,1:num_modes);
clear ModeShapes;
ModeShapes=MS;
%
alpha=0.25;
beta=0.5;
a0=1/(alpha*(dt^2));
a1=beta/(alpha*dt);
a2=1/(alpha*dt);
a3=(1/(2*alpha))-1;
a4=(beta/alpha)-1;
a5=(dt/2)*((beta/alpha)-2);
a6=dt*(1-beta);
a7=beta*dt;
%
KH=zeros(num_modes,1);
%
mm=zeros(num_modes,1);
cc=zeros(num_modes,1);
kk=zeros(num_modes,1);
%
for j=1:num_modes
    mm(j)=1;
    cc(j)=2*damp(j)*omegan(j);
    kk(j)=(omegan(j))^2;
    KH(j)=kk(j)+a0*mm(j)+a1*cc(j);
end
%
U=zeros(ndof,NT);
Ud=zeros(ndof,NT);
Udd=zeros(ndof,NT); 
%
nU=zeros(num_modes,NT);
nUd=zeros(num_modes,NT);
nUdd=zeros(num_modes,NT); 
%
sz=size(DI);
if(sz(2)>sz(1))
    DI=DI';
end
%
sz=size(VI);
if(sz(2)>sz(1))
    VI=VI';
end
%
MST=ModeShapes';
nU(:,1)=MST*(M*DI);
nUd(:,1)=MST*(M*VI);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
for i=2:NT
%
    F=zeros(num_modes,1);
   nF=zeros(num_modes,1); 
%
   for j=1:ndof
      j_index=force_dof(j);
      if(j_index~=-999)
         F(j)=FFI(i,j_index);
      end
   end 
%
   nF=MST*F;
%
   for j=1:num_modes
      V1=(a1*nU(j,i-1)+a4*nUd(j,i-1)+a5*nUdd(j,i-1));
      V2=(a0*nU(j,i-1)+a2*nUd(j,i-1)+a3*nUdd(j,i-1));
%        
      CV=cc(j)*V1;
      MA=mm(j)*V2;
%
      FH=nF(j)+MA+CV;
%
%  solve for displacements
%   
      nUn= FH/KH(j);
%        
      nUddn=a0*(nUn-nU(j,i-1))-a2*nUd(j,i-1)-a3*nUdd(j,i-1);
      nUdn=nUd(j,i-1)+a6*nUdd(j,i-1)+a7*nUddn;
%
      nU(j,i)=nUn;
      nUd(j,i)=nUdn;
      nUdd(j,i)=nUddn;
%
   end
%
end
%     
for i=1:NT
      U(:,i)=ModeShapes*nU(:,i);
     Ud(:,i)=ModeShapes*nUd(:,i);
    Udd(:,i)=ModeShapes*nUdd(:,i);
end