function estif= stiffps(nnode,ndime,nevab,ngaus,ielem,lnods,coord, young,poiss,thick)

%-------------------------------------------------------------------------

% form element stiffness matrix for plane stress 3 noded triangle

%-------------------------------------------------------------------------

% Set counters to loop over nodes (1:4) and dimensions 1:2

% Initialise stiffness matrix

estif(1:nevab,1:nevab)=0 ;

% Set integration postions and wieghts

[posgp,weigp] = gaussq;

% Set element local coords

for in=1:nnode;

elcod(in,1:ndime)=coord(lnods(ielem,in),1:ndime);

end

% Enter Gauss integration loop

for igaus=1:ngaus;

% Shape functions, derivatives, jacobian, elemental volume

xi=posgp(igaus,1) ; eta = posgp(igaus,2);

[shape,deriv]=shap3N(xi,eta);

[detJ,cartd] = jacob(elcod,deriv);

dvolu=detJ*weigp(igaus)*thick;

% B and D matrices

dmatx=dmatps(young,poiss);

bmatx=bmatps(ndime,nnode,cartd);

% Form DB matrix and element stiffness matrix

dbmat=dmatx*bmatx;

bdbmt=bmatx'*dbmat;

estif=estif+bdbmt*dvolu;

end