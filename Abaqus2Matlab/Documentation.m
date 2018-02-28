%% DOCUMENTATION Abaqus2Matlab

%% 1. Introduction
% Abaqus2Matlab is a Matlab toolbox which is used to retrieve the results
% of an Abaqus analysis in an easy to handle form. It is developed by
% George Papazafeiropoulos (gpapazafeiropoulos@yahoo.gr) in an effort to
% facilitate the process of coupling between Abaqus and Matlab. It is
% written in MATLAB programming language and is available as source code
% distributed under a BSD-style license (see License.txt which is included
% in the toolbox folder).
%
%% 2. Main features and characteristics
% Abaqus2Matlab is an effective tool with the following features:
%
% *2.1.* It provides linking between Abaqus and Matlab. Abaqus analysis can
% be conducted through Matlab, without interacting with Abaqus/CAE
% interface, or even Abaqus/Command.
%
% *2.2.* It transfers efficiently results from Abaqus to Matlab, in an
% error-proof way, since every contained external function is verified by
% its application in reading the results of a corresponding Abaqus
% analysis. The results of the verification of each function are presented
% in this toolbox in the form of html files.
%
% *2.3.* It provides the requested results in a form that enables the user
% to easily manipulate the data for further postprocessing.
%
% *2.4.* It can read 24 different kinds of nodal results (results at
% nodes), 35 different kinds of elemental results (results at the element
% integration points or results regarding whole elements) and 3 different
% kinds of analysis results (e.g. node definitions, element connectivity,
% eigenfrequencies and eigenvalues, etc.)
%
% *2.5.* A complete documentation package is provided along with the source
% code in this toolbox.
%
% *2.6.* It covers most types of Abaqus analyses and results. A sufficient
% number of functions is included in the toolbox to capture the most
% usually requested Abaqus results.
%
%% 3. Setup all files and folders
% All files and folders of Abaqus2Matlab toolbox have to be setup in the
% current folder of Matlab, which must be the folder of the toolbox. This
% folder should be placed in the Abaqus working directory, although this is
% not mandatory. In any case, the files generated in Abaqus runs will be
% placed one level up (outside) from the toolbox folder.
%
%%
% *3.1.* Find the directory containing this file
S = mfilename('fullpath');
namelength=numel('Documentation');
S=S(1:end-1-namelength);
%%
% *3.2.* Setup all files and folders inside the directory where
% Abaqus2Matlab toolbox is found
addpath(genpath(S));
cd(S);
savepath
%% 4. Source code files
% The source code files and folders used in this toolbox are the following:
%
% *4.1.* A function named <HelpFil2str.html Fil2str> that converts the
% contents of the results file into a one-row string to be further used in
% Matlab. This conversion is necessary because the results file is written
% as a sequential file, i.e. all words in the results file are of the same
% length (all rows in the file have the same length). <HelpFil2str.html
% Details>
%
% *4.2.* A folder named *OutputAnalysis* which contains the functions for
% the processing of the analysis results (e.g. node definitions, element
% connectivity, eigenfrequencies and eigenvalues, etc). See
% <RecTableAnalysis.html Analysis result types> to find which record key
% and which function is associated with each of the possible analysis
% result type and <RecFunctionsAnalysis.html List of functions used for any
% file output request>
%
% *4.3.* A folder named *OutputNodes* which contains the functions for the
% processing of the nodal results. See <RecTableNodes.html Node result
% types> to find which record key, which output variable identifier and
% which function is associated with each of the possible nodal result types
% and <RecFunctionsNodes.html List of functions used for any node file
% output request>
%
% *4.4.* A folder named *OutputElements* which contains the functions for
% the processing of the element results (results at the element integration
% points or results regarding whole elements). See <RecTableElements.html
% Element result types> to find which record key, which output variable
% identifier and which function is associated with each of the possible
% element result types and <RecFunctionsElements.html List of functions
% used for any element file output request>.
%
% *4.5.* This script (Documentation.m).
%
%% 5. Verification files
% All the functions provided with this toolbox and associated with
% obtaining analysis, element or node results are verified to ensure that
% they work correctly and they are not error-prone. In the verification
% process a suitable <RecFunctionsAbaqusInputFiles.html Abaqus input file>,
% in which the option for the extraction of the desired results in an ascii
% results file (.fil) is specified, is run by Abaqus, after being copied
% from the *AbaqusInputFiles* folder outside the folder of this toolbox (no
% matter where it is placed), which must be the Abaqus working directory.
% After the Abaqus analysis terminates and the results file is created in
% the Abaqus working directory, it is processed appropriately by Matlab to
% obtain the requested results. Finally, the results are presented and
% checked with regard to their class and size. See
% <RecFunctionsVerification.html here> for a complete list of the functions
% verified and the verification results for each function. The verification
% source codes are contained in the folder named *Verification*.
%
% The verification of this toolbox was made using Abaqus 6.13.
%
%% 6. Supplementary files
% Except for the source code files and folders used in this toolbox other
% supplementary files and folders are provided, which are the following:
%
% *6.1.* A folder named *AbaqusInputFiles* which contains the
% <RecFunctionsAbaqusInputFiles.html input files> which are run by Abaqus.
% These Abaqus files can be run by opening Abaqus/Command and typing
% < < abaqus job=X > > where X is the name of the
% <RecFunctionsAbaqusInputFiles.html Abaqus input file> without the
% extension (*.inp). Each <RecFunctionsAbaqusInputFiles.html Abaqus input
% file> is named with a number, let it be Y, which is the record key of the
% output variable identifier. The <RecFunctionsAbaqusInputFiles.html Abaqus
% input file> Y.inp is run by Abaqus and produces results which are
% obtained after Abaqus completes the analysis by the function RecY.m. The
% <RecFunctionsAbaqusInputFiles.html Abaqus input files> can be opened in
% any simple text editor, to view the various options specified in them.
%
% *6.2.* A folder named *help* which contains all the source files which
% are published in the documentation, and do not include any verification
% examples. Such source files include the record key tables, function
% lists, etc.
%
% *6.3.* A folder named *html* which contains all the html files of the
% documentation of this toolbox, including all the html files produced by
% publishing the verification examples of this toolbox. All the
% verification examples contained in the folder *Verification* and the
% editing files of the external functions and the
% <RecFunctionsAbaqusInputFiles.html Abaqus input files> contained in the
% folder *help* are published by Matlab in this folder and are accessible
% through the documentation.
%
%% 7. Demonstration of Abaqus2Matlab toolbox
% Follow the instructions below to watch step by step an example
% verification procedure of the toolbox:
%
% *7.1.* Ensure that Abaqus license server has started successfully.
%
% *7.2.* Place the folder of the toolbox in the Abaqus working directory
% (usually C:\Temp)
%
% *7.3.* Open the file named < < Documentation.m > > in Matlab and run it (press
% F5)
%
% *7.4.* Type in the command window of Matlab the name of the file to be
% executed (it will be one of the verification files in the
% *Verification* folder) without its extension. The name of the file is
% of the form <RecFunctionsVerification.html VerifyX>, where X is the name
% of the <RecFunctionsAbaqusInputFiles.html Abaqus input file> (X.inp)
% which is run by Abaqus to produce the corresponding results file X.fil in
% the Abaqus working directory. The information contained in X.fil is
% processed by the external Matlab function RecX.m, to give the requested
% output. For example by typing Verify8 in the command window of Matlab,
% the file 8.inp is run by Abaqus, after the analysis the file 8.fil is
% created in the Abaqus working directory, and the function Rec8.m obtains
% the requested results.
%
% *7.5.* After the source code in the file <RecFunctionsVerification.html
% VerifyX.m> has run, the results of the Abaqus results file X.fil will
% appear in the command window. The results of the run can be viewed in the
% documentation which accompanies this toolbox. A complete list of the
% verification results for all Abaqus results postprocessing functions can
% be found <RecFunctionsVerification.html here>.
%
%% 8. Instructions for use of Abaqus2Matlab toolbox
% Follow the instructions below to run and use the toolbox:
%
% *8.1.* Ensure that Abaqus license server has started successfully.
%
% *8.2.* Place the folder of the toolbox in the Abaqus working directory
% (usually C:\Temp). Usually, this step is not necessary, since Abaqus can
% run from any directory. This action is suggested, however, to avoid
% confusion with the large number of files which are created in each Abaqus
% run.
%
% *8.3.* Open the file named < < Documentation.m > > in Matlab and run it (press
% F5)
%
% *8.4.* The source codes in the matlab verification files
% (<RecFunctionsVerification.html VerifyX.m>) can be followed to extract
% the results of an arbitrary <RecFunctionsAbaqusInputFiles.html Abaqus
% input file>.
%
% *8.5.* To extract an arbitrary Abaqus analysis result from an Abaqus
% results file, initially the record key and the output variable identifier
% have to be specified. These can be obtained from <RecTableAnalysis.html
% Analysis result types> for an analysis-type output,
% <RecTableElements.html Element result types> for an element-type output,
% and from <RecTableNodes.html Node result types> for a node-type output.
%
% *8.6.* To view the instructions for use of each function, type < < doc RecX > >
% or < < help RecX > > (where X is the record key found in step 8.5 above) in the
% Matlab command window. the first option shows the function manual in a
% matlab browser, whereas the second option shows the function manual in
% the matlab command window. In the manual of each function the necessary
% options to be included in the <RecFunctionsAbaqusInputFiles.html Abaqus
% input file> are shown.
%
% *8.7.* Construct the relative <RecFunctionsAbaqusInputFiles.html Abaqus
% input file>, and place it in the Abaqus working directory. It is supposed
% that until here, the <RecFunctionsAbaqusInputFiles.html Abaqus input
% file> is ready to be run by Abaqus.
%
% *8.8.* Run the <RecFunctionsAbaqusInputFiles.html Abaqus input file> in
% Abaqus, either by opening Abaqus/Command and typing < < abaqus job=X > >, then
% enter, or by typing in the Matlab command window < < !abaqus job=X > >, then
% enter. After the analysis terminates, the results file X.fil is
% automatically generated. This file is then read by Matlab to extract the
% requested results.
%
% *8.9.* Place the file X.fil in the same directory with function
% <HelpFil2str.html Fil2str>. Type in the Matlab command window < < Rec=
% <HelpFil2str.html Fil2str> ('X.fil') > >. The variable Rec is a one-row
% string containing the information contained in the X.fil file.
%
% *8.10.* Type in the Matlab command window < < out=RecX(Rec) > >. The variable
% out contains the requested results, extracted from the X.fil results
% file. It will be generally a double or cell array. For more information
% about the identity and/or physical meaning of each element contained in
% this array, one can refer to the manual of the function RecX.m (mentioned
% in section 8.6 above) or section 5.1.2 (Results file output format) of
% the <http://127.0.0.1:2080/v6.13/books/usb/default.htm Abaqus Analysis
% User's Guide>
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
