%% Table of records written for any element file output request
% Find the record key, the output variable identifier and the function
% associated with each of the possible element result types, sorted in
% alphabetical order. The following 46 different element result types can
% be used with <Documentation.html Abaqus2Matlab> toolbox.
%
% <html>
% <table border=1>
% <tr><td>ELEMENT RECORD TYPE</td><td>RECORD KEY</td><td>OUTPUT VARIABLE IDENTIFIER</td><td>FUNCTION</td></tr>
% <tr><td>Average Shell Section Stress</td><td>83</td><td>SSAVG</td><td>Rec83.m</td></tr>
% <tr><td>Concrete Failure</td><td>31</td><td>CONF</td><td>Rec31.m</td></tr>
% <tr><td>Coordinates</td><td>8</td><td>COORD</td><td>Rec8.m</td></tr>
% <tr><td>Creep Strain (Including Swelling)</td><td>23</td><td>CE</td><td>Rec23.m</td></tr>
% <tr><td>Element Status</td><td>61</td><td>STATUS</td><td>Rec61.m</td></tr>
% <tr><td>Energy (Summed over Element)</td><td>19</td><td>ELEN</td><td>Rec19.m</td></tr>
% <tr><td>Energy Density</td><td>14</td><td>ENER</td><td>Rec14.m</td></tr>
% <tr><td>Equivalent plastic strain components</td><td>45</td><td>PEQC</td><td>Rec45.m</td></tr>
% <tr><td>Film</td><td>33</td><td>FILM</td><td>Rec33.m</td></tr>
% <tr><td>Gel (Pore Pressure Analysis)</td><td>40</td><td>GELVR</td><td>Rec40.m</td></tr>
% <tr><td>Heat Flux Vector</td><td>28</td><td>HFL</td><td>Rec28.m</td></tr>
% <tr><td>J-integral</td><td>1991</td><td>SP</td><td>Rec1991.m</td></tr>
% <tr><td>Logarithmic Strain</td><td>89</td><td>LE</td><td>Rec89.m</td></tr>
% <tr><td>Mass Concentration (Mass Diffusion Analysis)</td><td>38</td><td>CONC</td><td>Rec38.m</td></tr>
% <tr><td>Mechanical Strain Rate</td><td>91</td><td>ER</td><td>Rec91.m</td></tr>
% <tr><td>Nodal Flux Caused by Heat</td><td>10</td><td>NFLUX</td><td>Rec10.m</td></tr>
% <tr><td>Nominal Strain</td><td>90</td><td>NE</td><td>Rec90.m</td></tr>
% <tr><td>Plastic Strain</td><td>22</td><td>PE</td><td>Rec22.m</td></tr>
% <tr><td>Pore Fluid Effective Velocity Vector</td><td>97</td><td>FLVEL</td><td>Rec97.m</td></tr>
% <tr><td>Pore or Acoustic Pressure</td><td>18</td><td>POR</td><td>Rec18.m</td></tr>
% <tr><td>Principal elastic strains</td><td>408</td><td>EEP</td><td>Rec408.m</td></tr>
% <tr><td>Principal inelastic strains</td><td>409</td><td>IEP</td><td>Rec409.m</td></tr>
% <tr><td>Principal logarithmic strains</td><td>405</td><td>LEP</td><td>Rec405.m</td></tr>
% <tr><td>Principal mechanical strain rates</td><td>406</td><td>ERP</td><td>Rec406.m</td></tr>
% <tr><td>Principal nominal strains</td><td>404</td><td>NEP</td><td>Rec404.m</td></tr>
% <tr><td>Principal plastic strains</td><td>411</td><td>PEP</td><td>Rec411.m</td></tr>
% <tr><td>Principal strains</td><td>403</td><td>EP</td><td>Rec403.m</td></tr>
% <tr><td>Principal stresses</td><td>401</td><td>SP</td><td>Rec401.m</td></tr>
% <tr><td>Principal thermal strains</td><td>410</td><td>THEP</td><td>Rec410.m</td></tr>
% <tr><td>Principal values of backstress tensor for kinematic hardening plasticity</td><td>402</td><td>ALPHAP</td><td>Rec402.m</td></tr>
% <tr><td>Principal values of deformation gradient</td><td>407</td><td>DGP</td><td>Rec407.m</td></tr>
% <tr><td>Radiation</td><td>34</td><td>RAD</td><td>Rec34.m</td></tr>
% <tr><td>Saturation (Pore Pressure Analysis)</td><td>35</td><td>SAT</td><td>Rec35.m</td></tr>
% <tr><td>Section Force and Moment</td><td>13</td><td>SF</td><td>Rec13.m</td></tr>
% <tr><td>Section Strain and Curvature</td><td>29</td><td>SE</td><td>Rec29.m</td></tr>
% <tr><td>Section Thickness</td><td>27</td><td>STH</td><td>Rec27.m</td></tr>
% <tr><td>Strain Jump at Nodes</td><td>32</td><td>SJP</td><td>Rec32.m</td></tr>
% <tr><td>Stress</td><td>11</td><td>S</td><td>Rec11.m</td></tr>
% <tr><td>Stress Invariant</td><td>12</td><td>SINV</td><td>Rec12.m</td></tr>
% <tr><td>Thermal Strain</td><td>88</td><td>THE</td><td>Rec88.m</td></tr>
% <tr><td>Total Elastic Strain</td><td>25</td><td>EE</td><td>Rec25.m</td></tr>
% <tr><td>Total Fluid Volume Ratio</td><td>43</td><td>FLUVR</td><td>Rec43.m</td></tr>
% <tr><td>Total Inelastic Strain</td><td>24</td><td>IE</td><td>Rec24.m</td></tr>
% <tr><td>Total Strain</td><td>21</td><td>E</td><td>Rec21.m</td></tr>
% <tr><td>Unit Normal to Crack in Concrete</td><td>26</td><td>CRACK</td><td>Rec26.m</td></tr>
% <tr><td>Whole Element Volume</td><td>78</td><td>EVOL</td><td>Rec78.m</td></tr>
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
