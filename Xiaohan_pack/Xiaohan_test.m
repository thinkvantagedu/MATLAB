clear; clc;

corners=[0 0 ; 1 0 ; 1 1 ; 0 1];
nex=2;
ney=nex;

nsubelemx=4;

[ coordinates_initial, connectivity_initial, edges, neighbours4, mids, ...
    neighbours8, edgEcell ] = MeshQuad4(nex, ney, corners);
[refined] = RefineQuad4Subelements(coordinates_initial, connectivity_initial, ...
    neighbours4, nsubelemx);