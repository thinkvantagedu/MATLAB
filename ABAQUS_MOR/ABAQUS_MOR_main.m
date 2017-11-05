clear all; clc;
cd('C:\Temp\MATLAB\ABAQUS_MOR');
addpath('C:\Temp\MATLAB');
% system('abaqus cae noGUI=abaqusMacros.py')

%%
% Extract gepmetry info from INP file
INPfilename='C:\Temp\L5H2_1.inp';
tic%1
[node, elem, cons, exfc]=ABAQUSReadINP(INPfilename);
toc
%%
% Generate constraints matrix
tic%2
dof=(1:3*length(node))';
cons_dof=zeros(3*length(cons), 1);
for i_cons=1:length(cons)
    
    cons_dof(3*i_cons-2:3*i_cons)=cons_dof(3*i_cons-2:3*i_cons)+...
        dof(cons(i_cons)*3-2:cons(i_cons)*3);
    
end

dof(cons_dof, :)=[];
toc
%%
% Generate force matrix
tic%3
exforc_nd_force=-1;
exforc=sparse(zeros(3*length(node), 1));
exforc(3*exfc-1, :)=exforc(3*exfc-1, :)+exforc_nd_force;
exforc(cons_dof, :)=[];
toc
%%
% Generate snapshot matrix
NSnap=3;
snap_E=logspace(-1, 1.5, NSnap);
filename.trim=...
    'C:\Temp\abaqusMacros_L5H2_1.py';
filename.new=...
    'C:\Temp\trimed_textfile.py';
tic%4-------------------------------------------------------slow
[snap]=ABAQUS_MOR_snapshot(filename, NSnap, snap_E);
toc
%%
% truncate snapshot matrix
snap(cons_dof, :)=[];
NPhi=3;
tic%5
[X, Phi, Sigma]=SVD(snap, NPhi);
toc
%%
% Assemble E=0 and E=1 stiffness matrices
tic%6
MTXfile.E0='C:\Temp\L5H2_1_mtx_0_STIF1.mtx';
MTXfile.E1='C:\Temp\L5H2_1_mtx_1_STIF1.mtx';

[K_E_0_1]=ABAQUSReadMTX(MTXfile.E0);
toc
[K_E_1_1]=ABAQUSReadMTX(MTXfile.E1);

K_E_0=K_E_0_1(dof, dof);
K_E_1=K_E_1_1(dof, dof);

%%
% 
tic%7
K_IR=Phi'*K_E_0*Phi;
K_mR=Phi'*K_E_1*Phi;
F_R=Phi'*exforc;
toc

