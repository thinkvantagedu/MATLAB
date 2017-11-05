% Program EStiff to test element stiffness matrix formation

%-------------------------------------------------------------------------

% Clear All variables from memory

clear ; clc ; pause on ;

% Set number of dimensions, nodes per element etc.

ndime=2; nstre=3; ndofn=2; nnode=4; nevab=nnode*ndofn; ngaus=4;

% Main controol data. nelem, npoin

nelem=2 ; npoin=6;

% Element topology

lnods(1,:)=[1 3 4 2] ; %Element 1 topology

lnods(2,:)=[3 5 6 4] ; %Element 2 topology

disp('lnods') ; disp(lnods);

% Nodal point coordinates

coord(1,:) = [0 0];

coord(2,:) = [0 200];

coord(3,:) = [200 0];

coord(4,:) = [200 200];

coord(5,:) = [400 0];

coord(6,:) = [400 200];

disp('coordinates') ; disp(coord);

% Material properties

young=200000.0 ; poiss=0.3; thick=10.0 ;

% Loop elements and form stiffness marix for each

for ielem=1:nelem
    
    [xi, eta, posgp, weigp, elcod, shape, deriv, dmatx, bmatx, dvolu, dbmat, bdbmt, estif] = ...
        stiffps(nnode,ndime,nevab,ngaus,ielem,lnods,coord, young,poiss,thick);
    
    disp(['Stiffness matrix for Element ', num2str(ielem)]);
    
    disp(estif);
    
%     % Check for element 1
%     
%     if ielem==1
%         
%         udisp=[0.0 ; 0.0 ; 0.1 ; 0.0 ;0.1 ; -0.08*poiss ];
%         
%         pforce=estif*udisp ;
%         
%         disp('pforce ' ); disp(pforce);
%         
%     end
    
end