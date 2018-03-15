function out = Rec1921(Rec)
%
% ABAQUS analysis information output to MATLAB
%
% Syntax
%     #Rec# = Fil2str('*.fil');
%     #out# = Rec1921(#Rec#)
%
% Description
%     Read analysis information output from the results (*.fil) file
%     generated from the ABAQUS finite element software. The asterisk (*)
%     is replaced by the name of the results file. The record key for
%     analysis information output is 1921. See section < < Results file output
%     format > > in ABAQUS Analysis User's manual for more details.
%     The following option with parameter has to be specified in the ABAQUS
%     input file for the results (*.fil) file to be created:
%         ...
%         *FILE FORMAT, ASCII
%         ...
%     NOTE: The results file (*.fil) must be placed in the same directory
%     with the MATLAB source files in order to be processed.
%
% Input parameters
%     #Rec# (string) is an one-row string containing the ASCII code of the
%         ABAQUS results (*.fil) file. It is generated by the function
%         Fil2str.m.
%
% Output parameters
%     #out# ([1 x #m#]) is a cell array containing the attributes of
%         the record key 1921 as follows:
%         Column  1�����Abaqus release number (A8 format).
%         Column  2�����Date (2A8 format).
%         Column  3�����Date continued.
%         Column  4�����Time (A8 format).
%         Column  5�����Number of elements in the model.
%         Column  6�����Number of nodes in the model.
%         Column  7�����Typical element length in the model.
%         where #m# is the length of the record.
%
% _________________________________________________________________________
% Abaqus2Matlab - www.abaqus2matlab.com
% Copyright (c) 2016 by George Papazafeiropoulos
%
% If using this toolbox for research or industrial purposes, please cite:
% G. Papazafeiropoulos, M. Muniz-Calvente, E. Martinez-Paneda.
% Abaqus2Matlab: a suitable tool for finite element post-processing (submitted)
%
%

ind = strfind(Rec,'I 41921'); % record key for analysis information (1921)
if isempty(ind)
    out=[];
    return;
end
nextpos=numel('I 41921')+1;
% find the record length (NW)
Rec2=Rec(ind(1)-5:ind(1));
% number of digits of record length
ind1=1+2; % 1st digit of 2-digit integer of 1st data item
ind2=1+2+1; % 2nd digit of 2-digit integer of 1st data item
a1=str2num(Rec2(ind1:ind2));
% Record length (NW)
ind1=ind1+2; % +2 digits
ind2=ind2+a1; % +2-digit integer
NW=str2num(Rec2(ind1:ind2));
% Initialize output
Release=char(zeros(1,8));
Date=char(zeros(1,16));
DateCont=char(zeros(1,8*(NW-9)));
Time=char(zeros(1,8));
Out2=zeros(1,2);
% Abaqus release number
ind1=6+nextpos; % 1st position of 8-character string of 3rd data item
ind2=6+nextpos+7; % last position of 8-character string of 3rd data item
Release(1,:)=Rec(ind1:ind2);
% Date
for i=1:2
ind1=ind2+1+1; % +1 character+1
ind2=ind2+8+1; % +8-character string+1
Date(1,1+8*(i-1):8+8*(i-1))=Rec(ind1:ind2);
end
% Date continued
for i=1:NW-9
    ind1=ind2+1+1; % +1 character+1
    ind2=ind2+8+1; % +8-character string+1
    DateCont(1,1+8*(i-1):8+8*(i-1))=Rec(ind1:ind2);
end
% Time
ind1=ind2+1+1; % +1 character+1
ind2=ind2+8+1; % +8-character string+1
Time(1,:)=Rec(ind1:ind2);
% number of elements and number of nodes in the model
for i=1:2
    % number of digits
    ind1=ind2+1+1; % +1 character+1
    ind2=ind2+2+1; % +2 digits+1
    a2=str2num(Rec(ind1:ind2));
    % number
    ind1=ind1+2; % +2 digits
    ind2=ind2+a2; % +2-digit integer
    Out2(1,i)=str2num(Rec(ind1:ind2));
end
% typical element length in the model
ind1=ind2+1+1; % +1 character+1
ind2=ind2+1+22; % +1 character +22 floating point digits
EleLength=str2num(Rec(ind1:ind2));

% Assemply of matrices for output
out=[cellstr(Release) cellstr([Date DateCont]) cellstr(Time) num2cell(Out2) num2cell(EleLength)];

end
