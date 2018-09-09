% Post processing the Finite Element Results
% Plotting the profile of components on Finite Element mesh / deformed mesh
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%          http://sites.google.com/site/kolukulasivasrinivas/            |
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
% Variable descriptions 
%      coordinates.dat - data file of nodal coordinates of the nodes
%      nodes.dat       - data file of elemental nodal connectivity
%      displacements   - displacement results obtained from FEA
%      factor          - amplication factor for deformed mesh 
%
% NOTE : Please note that in coordinates ,displacements first column is 
%        node number and in nodes forst column is element number .
%--------------------------------------------------------------------------
      
% clear; clc; close all;
%--------------------------------------------------------------------------
%  input data 
%--------------------------------------------------------------------------
% load coordinates.dat ; coordinates = coordinates(:, 2:end) ;
% load nodes.dat ; nodes = nodes(:,2:end) ;
% load displacements.dat ;
coordinates = canti.node.all(:, 2:end);
nodes = canti.elem.all(:, 2:5);
%--------------------------------------------------------------------------
% Sorting the values accordingly
%--------------------------------------------------------------------------
% UX = displacements(:,2) ;
% UY = displacements(:,3) ;
% UZ = displacements(:,4) ;
% U  = sqrt(UX.^2+UY.^2+UZ.^2) ;
% RX = displacements(:,5) ;
% RY = displacements(:,6) ;
% RZ = displacements(:,7) ;
UX = canti.dis.trial(:, 2);
%--------------------------------------------------------------------------
% Plotting the mesh and profiles
%--------------------------------------------------------------------------
% PlotMesh(coordinates,nodes,0) ;   %  Plot the FEM mesh
%
component = UX;
PlotFieldonMesh(coordinates,nodes,component) ; % Plot the component profile on mesh
% %
% depl = [UX UY UZ] ;
% factor = 90 ;                % Plot the component profile on deformed mesh
% PlotFieldonDefoMesh(coordinates,nodes,factor,depl,component) ;