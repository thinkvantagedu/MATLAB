function out = Rec1900(Rec)
%
% ABAQUS element definitions output to MATLAB
% 
% Syntax
%     #Rec# = Fil2str('*.fil');
%     #out# = Rec1900(#Rec#)
%
% Description
%     Read element definitions output from the results (*.fil) file
%     generated from the ABAQUS finite element software. The asterisk (*)
%     is replaced by the name of the results file. The record key for
%     element definitions output is 1900. See section < < Results file output
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
%     #out# ([#n# x #m#]) is a cell array containing the attributes of
%         the record key 1900 as follows:
%         Column  1�����Element number.
%         Column  2�����Element type (characters, A8 format, left
%         justified).
%         Column  3�����First node on the element.
%         Column  4�����Second node on the element.
%         Column  5�����Etc.
%         where #n# is the number of elements and #m#-2 is the number of
%         nodes per element.
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

ind = strfind(Rec,'I 41900'); % record key for element definitions output (1900)
if isempty(ind)
    out=[];
    return;
end
nextpos=numel('I 41900')+1;
% Initialize record length matrix
NW=zeros(numel(ind),1);
for i=1:numel(ind)
    % find the record length (NW)
    Rec2=Rec(ind(i)-7:ind(i));
    indNW=strfind(Rec2,'*'); % record starting position
    % ensure that the record exists and that the record type key is at
    % location 2
    if isempty(indNW) || indNW>3
        ind(i)=NaN;
        continue;
    end
    % number of digits of record length
    ind1=indNW+2; % 1st digit of 2-digit integer of 1st data item
    ind2=indNW+2+1; % 2nd digit of 2-digit integer of 1st data item
    a1=str2num(Rec2(ind1:ind2));
    % Record length (NW)
    ind1=ind1+2; % +2 digits
    ind2=ind2+a1; % +2-digit integer
    NW(i)=str2num(Rec2(ind1:ind2));
end
ind=ind(~isnan(ind));
EleNodes=zeros(numel(ind),max(NW)-4);
EleNum=zeros(numel(ind),1);
EleType=char(zeros(numel(ind),8));
for i=1:numel(ind)
    % number of digits of element number
    ind1=ind(i)+nextpos; % 1st digit of 2-digit integer of 3rd data item
    ind2=ind(i)+nextpos+1; % 2nd digit of 2-digit integer of 3rd data item
    a1=str2num(Rec(ind1:ind2));
    % Element number
    ind1=ind1+2; % +2 digits
    ind2=ind2+a1; % +2-digit integer
    EleNum(i)=str2num(Rec(ind1:ind2));
    % Element type
    ind1=ind1+a1+1; % +2-digit integer+1 character
    ind2=ind2+8+1; % +8-character string+1
    EleType(i,:)=Rec(ind1:ind2);
    % Element connectivity
    for j=1:NW(i)-4
        % number of digits of Element node
        ind1=ind2+1+1; % +1 character+1
        ind2=ind2+2+1; % +2 digits+1
        a2=str2num(Rec(ind1:ind2));
        % Element node
        ind1=ind1+2; % +2 digits
        ind2=ind2+a2; % +2-digit integer
        EleNodes(i,j)=str2num(Rec(ind1:ind2));
    end
end
% Assemply of matrices for output
out=[num2cell(EleNum) cellstr(EleType) num2cell(EleNodes)];

end
