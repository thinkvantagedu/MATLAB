function out = Rec45(Rec)
%
% ABAQUS equivalent plastic strain components output to MATLAB
% 
% Syntax
%     #Rec# = Fil2str('*.fil');
%     #out# = Rec45(#Rec#)
%
% Description
%     Read equivalent plastic strain components output from the results
%     (*.fil) file generated from the ABAQUS finite element software. The
%     asterisk (*) is replaced by the name of the results file. The record
%     key for equivalent plastic strain components output is 45. See
%     section < < Results file output format > > in ABAQUS Analysis User's manual
%     for more details.
%     The following options with parameters have to be specified in the
%     ABAQUS input file for the results (*.fil) file to be created and to
%     contain equivalent plastic strain component results:
%         ...
%         *FILE FORMAT, ASCII
%         *EL FILE
%         PEQC
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
%     #out# ([#n# x 8]) is a double array containing the attributes of
%         the record key 45 as follows:
%         Column  1�����Equivalent plastic strain for Drucker-Prager
%         failure surface.
%         Column  2�����Actively yielding flag (yes or no, A8�format) for
%         Drucker-Prager failure surface.
%         Column  3�����Equivalent plastic strain for cap surface.
%         Column  4�����Actively yielding flag (yes or no, A8 format) for
%         cap surface.
%         Column  5�����Equivalent plastic strain for transition surface.
%         Column  6�����Actively yielding flag (yes or no, A8 format) for
%         transition surface.
%         Column  7�����Total volumetric inelastic strain.
%         Column  8�����Actively yielding flag (yes or no, A8 format).
%         (See < < Elements > > in Abaqus Analysis User's Manual for a
%         definition of the number and type of the components for the
%         element type), where #n# is the number of elements multiplied by
%         the number of integration points multiplied by the number of
%         section points (for shell, beam, or layered solid elements)
%         multiplied by the number of increments. If the results file does
%         not contain the desired output, #out# will be an empty array.
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

ind = strfind(Rec,'I 245D'); % record key for element equivalent plastic strain components output (45)
if isempty(ind)
    out=[];
    return;
end
nextpos=numel('I 345')+1;
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
% remove ind and NW values which do not correspond to output
NW(isnan(ind))=[]; 
ind(isnan(ind))=[];
% Initialize
EleOut=zeros(numel(ind),max(NW)-2);
for i=1:numel(ind)
    ind2=ind(i)+nextpos-2;
    % Element equivalent plastic strain components
    for j=1:NW(i)-2
        % equivalent plastic strain component
        ind1=ind2+1+1; % +1 character+1
        ind2=ind2+1+22; % +1 character +22 floating point digits
        % check if the actively yielding flag is encountered
        if isempty(str2num(Rec(ind1:ind2)))
            % update the upper index so that it includes only the A8 format
            ind2=ind2-14;
            % if AC=YES, then assign unity (true)
            if strcmp(Rec(ind1:ind1+2),'YES')
                EleOut(i,j)=1;
            end
        else
            EleOut(i,j)=str2num(Rec(ind1:ind2));
        end
    end
end
% Assembly of matrices for output
out=EleOut;

end

