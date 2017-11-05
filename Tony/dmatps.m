function dmatx = dmatps(young,poiss)

%--------------------------------------------------------------------------

% Form elastic plane stress d-matrix

%--------------------------------------------------------------------------

dmatx(1:3,1:3)=0 ;

const=young/(1.0-poiss*poiss) ;

dmatx(1,1)=const ;

dmatx(2,2)=const ;

dmatx(1,2)=const*poiss ;

dmatx(2,1)=const*poiss ;

dmatx(3,3)=(1.0-poiss)*const/2.0 ;