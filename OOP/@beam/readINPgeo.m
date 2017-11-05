function obj = readINPgeo(obj)
% read INP file and extract node and element informations. 
%%
lineNode = [];
lineElem = [];
lineInc1 = [];
lineInc2 = [];

%%
% Read INP file line by line
fid = fopen(obj.INPname);
tline = fgetl(fid);
lineNo = 1;

while ischar(tline)
    lineNo = lineNo + 1;
    tline = fgetl(fid);
    celltext{lineNo} = tline;
    
    if strncmpi(tline, '*Node', 5) == 1 || ...
            strncmpi(tline, '*Element', 8) == 1
        lineNode = [lineNode; lineNo];
        %strncmpi compares the 1st n characters of 2 strings for equality
        %strncmpi(string, string, n) compares the 1st n characters.
    end
      
    if strncmpi(tline, '*Element', 8) == 1 || ...
            strncmpi(tline, '*Nset', 5) == 1
        lineElem = [lineElem; lineNo];
        
    end
    
    if strncmpi(tline, '*Nset, nset=Set-I1', 18) == 1 || ...
            strncmpi(tline, '*Elset, elset=Set-I1', 20) == 1
        lineInc1 = [lineInc1; lineNo];
    end
    
    if strncmpi(tline, '*Nset, nset=Set-I2', 18) == 1 || ...
            strncmpi(tline, '*Elset, elset=Set-I2', 20) == 1
        lineInc2 = [lineInc2; lineNo];
    end
end
% element may contains multiple locations, but only takes the first 2
% locations. 
lineElem = lineElem(1:2);
strtext = char(celltext(2:(length(celltext) - 1)));

fclose(fid);

% node
txtNode = strtext((lineNode(1) : lineNode(2) - 2), :);
trimNode = strtrim(txtNode);%delete spaces in heads and tails
obj.node.all = str2num(trimNode);
obj.no.node.all = size(obj.node.all, 1);

% element
txtElem = strtext((lineElem(1):lineElem(2) - 2), :); 
trimElem = strtrim(txtElem);
obj.elem.all = str2num(trimElem);
obj.no.elem = size(obj.elem.all, 1);

% inclusions
lineInc = [lineInc1 lineInc2];
nodeIncCell = cell(obj.no.inc - 1, 1);
nNodeInc = zeros(obj.no.inc - 1, 1);

incConn = cell(obj.no.inc - 1, 1);

for i = 1:obj.no.inc - 1
    % nodal info of inclusions
    txtInc = strtext((lineInc(1, i):lineInc(2, i) - 2), :);
    trimInc = strtrim(txtInc);
    nodeInc = str2num(trimInc);
    
    nodeInc = nodeInc';
    nodeInc = obj.node.all(nodeInc, :);
    nInc = size(nodeInc, 1);
    nodeIncCell(i) = {nodeInc};
    nNodeInc(i) = nInc;
    % connectivities of inclusions
    connSwitch = zeros(obj.no.node.all, 1);
    connSwitch(nodeIncCell{i}(:, 1)) = 1;
    elemInc = [];
    for j = 1:obj.no.elem
        
        ind = (connSwitch(obj.elem.all(j, 2:4)))';
        if isequal(ind, ones(1, 3)) == 1
            elemInc = [elemInc; obj.elem.all(j, 1)];
        end
        
    end
    incConn(i) = {elemInc};
    
end
obj.elem.inc = incConn;
obj.node.incAll = nodeIncCell;

% inclusion 1
obj.node.inc1 = nodeIncCell{1};
obj.no.node.inc1 = nNodeInc(1);
obj.elem.inc1 = obj.elem.all(incConn{1}, :);

% inclusion 2
obj.node.inc2 = nodeIncCell{2};
obj.no.node.inc2 = nNodeInc(2);
obj.elem.inc2 = obj.elem.all(incConn{2}, :);

% sort inclusions in ascending order.
incAll = [obj.node.inc1; obj.node.inc2];
[~, incSeq] = sort(incAll(:, 1));
obj.node.inc = incAll(incSeq, :);
obj.no.node.inc = obj.no.node.inc1 + obj.no.node.inc2;
obj.no.node.mtx = obj.no.dof - obj.no.node.inc;