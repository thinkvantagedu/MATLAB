function bmatx= bmatps(ndime,nnode,cartd)

%--------------------------------------------------------------------------

% Form strain-displacement matrix (B matrix) for plane stress

%-------------------------------------------------------------------------

for in=1:nnode

i=(in-1)*2+1 ; j=i+1 ;

bmatx(1,i)=cartd(1,in);

bmatx(1,j)=0.0;

bmatx(2,i)=0.0;

bmatx(2,j)=cartd(2,in);

bmatx(3,i)=cartd(2,in);

bmatx(3,j)=cartd(1,in);

end

