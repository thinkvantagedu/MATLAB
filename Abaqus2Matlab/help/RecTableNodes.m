%% Table of records written for any node file output request
% Find the record key, the output variable identifier and the function
% associated with each of the possible nodal result types, sorted in
% alphabetical order. The following 24 different nodal result types can be
% used with <Documentation.html Abaqus2Matlab> toolbox.
%
% <html>
% <table border=1>
% <tr><td>NODAL RECORD TYPE</td><td>RECORD KEY</td><td>OUTPUT VARIABLE IDENTIFIER</td><td>FUNCTION</td></tr>
% <tr><td>Concentrated Electrical Nodal Charge</td><td>120</td><td>CECHG</td><td>Rec120.m</td></tr>
% <tr><td>Concentrated Electrical Nodal Current</td><td>139</td><td>CECUR</td><td>Rec139.m</td></tr>
% <tr><td>Concentrated Flux</td><td>206</td><td>CFL</td><td>Rec206.m</td></tr>
% <tr><td>Electrical Potential</td><td>105</td><td>EPOT</td><td>Rec105.m</td></tr>
% <tr><td>Electrical Reaction Charge</td><td>119</td><td>RCHG</td><td>Rec119.m</td></tr>
% <tr><td>Electrical Reaction Current</td><td>138</td><td>RECUR</td><td>Rec138.m</td></tr>
% <tr><td>Fluid Cavity Pressure</td><td>136</td><td>PCAV</td><td>Rec136.m</td></tr>
% <tr><td>Fluid Cavity Volume</td><td>137</td><td>CVOL</td><td>Rec137.m</td></tr>
% <tr><td>Internal Flux</td><td>214</td><td>RFLE</td><td>Rec214.m</td></tr>
% <tr><td>Motions (in Cavity Radiation Analysis)</td><td>237</td><td>MOT</td><td>Rec237.m</td></tr>
% <tr><td>Nodal Acceleration</td><td>103</td><td>A</td><td>Rec103.m</td></tr>
% <tr><td>Nodal Coordinate</td><td>107</td><td>COORD</td><td>Rec107.m</td></tr>
% <tr><td>Nodal Displacement</td><td>101</td><td>U</td><td>Rec101.m</td></tr>
% <tr><td>Nodal Point Load</td><td>106</td><td>CF</td><td>Rec106.m</td></tr>
% <tr><td>Nodal Reaction Force</td><td>104</td><td>RF</td><td>Rec104.m</td></tr>
% <tr><td>Nodal Velocity</td><td>102</td><td>V</td><td>Rec102.m</td></tr>
% <tr><td>Normalized Concentration (Mass Diffusion Analysis)</td><td>221</td><td>NNC</td><td>Rec221.m</td></tr>
% <tr><td>Pore or Acoustic Pressure</td><td>108</td><td>POR</td><td>Rec108.m</td></tr>
% <tr><td>Reactive Fluid Total Volume</td><td>110</td><td>RVT</td><td>Rec110.m</td></tr>
% <tr><td>Reactive Fluid Volume Flux</td><td>109</td><td>RVF</td><td>Rec109.m</td></tr>
% <tr><td>Residual Flux</td><td>204</td><td>RFL</td><td>Rec204.m</td></tr>
% <tr><td>Temperature</td><td>201</td><td>NT</td><td>Rec201.m</td></tr>
% <tr><td>Total Force</td><td>146</td><td>TF</td><td>Rec146.m</td></tr>
% <tr><td>Viscous Forces Due to Static Stabilization</td><td>145</td><td>VF</td><td>Rec145.m</td></tr>
% </table>
% </html>
% 
%
%%
%  ________________________________________________________________________
%
%  Abaqus2Matlab - www.abaqus2matlab.com
%  Copyright (c) 2016 by George Papazafeiropoulos
%
%
%  If using this toolbox for research or industrial purposes, please cite:
%  G. Papazafeiropoulos, M. Muniz-Calvente, E. Martinez-Paneda.
%  Abaqus2Matlab: a suitable tool for finite element post-processing
%  (submitted)
