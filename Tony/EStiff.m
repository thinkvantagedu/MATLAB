% Program EStiff to test element stiffness matrix formation

%-------------------------------------------------------------------------

% Clear All variables from memory

clear ; clc ; pause on ;

% Set number of dimensions, nodes per element etc.

ndime=2; nstre=3; ndofn=2; nnode=3; nevab=nnode*ndofn; ngaus=1;

% Main controol data. nelem, npoin

nelem=2 ; npoin=4;

% Element topology

lnods(1,:)=[1 2 4] ; %Element 1 topology

lnods(2,:)=[1 4 3] ; %Element 2 topology

disp('lnods') ; disp(lnods);

% Nodal point coordinates

coord(1,:) = [ 0.0 0.0];

coord(2,:) = [100.0 0.0];

coord(3,:) = [ 0.0 80.0];

coord(4,:) = [100.0 80.0];

disp('coordinates') ; disp(coord);

% Material properties

young=200000.0 ; poiss=0.3; thick=10.0 ;

% Loop elements and form stiffness marix for each

for ielem=1:nelem

estif= stiffps(nnode,ndime,nevab,ngaus,ielem,lnods,coord, young,poiss,thick);

disp(['Stiffness matrix for Element ', num2str(ielem)]);

disp(estif);

% Check for element 1

if ielem==1

udisp=[0.0 ; 0.0 ; 0.1 ; 0.0 ;0.1 ; -0.08*poiss ];

pforce=estif*udisp ;

disp('pforce ' ); disp(pforce);

end

end