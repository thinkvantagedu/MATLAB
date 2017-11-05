% Program TStrain

% Program to compute strains and stresses at a point xi,eta

% to test shapoe function, jacobian, B matrix and D matrix routines

%-------------------------------------------------------------------------

clear ; clc ; % Clear memory

nnode=3; % Number of nodes per element

ndime=2; % Number of corodinate dimensions

% Set local coords where shape functions are to be evaluated

xi=0.5; eta=0.5;

%

% Set elastic properties

%

young=200000.0 ; poiss=0.2;

%

% Set Element local coordinates:

% elcod = [x1 y1 ; x2 y2 ; x3 y3 ]

%

elcod=[0 0 ;100 0 ;0 100];

%

% Set nodal displacements:

% tdisp=[ux1; uy1; ux2; uy2; ux3; uy3]

%

tdisp=[0.0; 0.0; 0.1; 0.0; 0.0; -0.02];

%

% Evaluate shape functions and derivatives

%

[shape,deriv]=shap3N(xi,eta);

%

% Evaluate Jacobian terms

%

[detJ,cartd] = jacob(elcod,deriv);

%

% Form D matrix

%

dmatx=dmatps(young,poiss);

%

% Form B Matrix

%

bmatx=bmatps(ndime,nnode,cartd);

% Compute strains from b matrix and the element displacement vector

strain=bmatx*tdisp;

% Compute stresses from D Matrix and strains

stres=dmatx*strain;

% Output stresses and strains

fprintf(' xx-strain yy-strain xy-strain\n');

fprintf(' %10.8f %10.8f %10.8f \n',strain(1:3));

fprintf('\n\n xx-stress yy-stress xy-stress\n');

fprintf('%10.3f %10.3f %10.3f \n',stres(1:3));