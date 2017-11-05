clear; clc;

ndime = 2; 
nstre = 3;
ndofn = 2;
nnode = 4;
nevab = nnode*ndofn;
ngaus = 4;

nelem = 2; 
npoin = 6;
ntotv = npoin*ndofn;

lnods = [1 3 4 2; 3 5 6 4];

coord = [0 0 ; 0 200; 200 0; 200 200; 400 0; 400 200];

young = 200000; 
poiss = 0.3; 
thick = 10;

nvfix = 2;
nofix = [1 2];
ifpre(1:nvfix, 1:2) = 0;
ifpre(1, 1) = 1;
ifpre(1, 2) = 1; 
ifpre(2, 1) = 1;

presc(1, 1) = 0;
presc(1, 2) = 0;
presc(2, 1) = 0;

force(1:ntotv) = 0;
force(9) = 1e6;
force(11) = 1.5e6;

[estif, gstif] = globstif(nnode, ndime, ndofn, nevab, ngaus, npoin, ntotv,...
    nelem, lnods, coord, young, poiss, thick);

rhs = force; 

[rhsmod, gstifmod] = boundarystif(ndofn, ntotv, nvfix, nofix, ifpre, presc, gstif, rhs);

tdisp = gstifmod\rhsmod';