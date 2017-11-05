function [ X, T, edges, Nb4, mids, Nb8, edgEcell ] = MeshQuad4(nex, ney, corners)
% function [ X, T, edges, Nb4, mids, Nb8, edgEcell ] = MeshQuad4(nex, ney, corners)
%   Generates regular quadrilateral mesh from 2 vectors.
%   Without "corners" the coordinate are in the reference domain (-1,1)x(-1,1) 
%   Inputs:  nex=number of elements in x   ;   ney=number of elements in x
%            corners = 4x2 array cointaining x and y corner coordinates
%                      following the ordering of THE SHAPE FUNCTIONS !!!!!.
%                      Rotating the corners will rotate the mesh and edges
%
%      WARNING, shape functions ARE ANTICLOCKWISE, so Corners MUST BE ALSO
%
%   Outputs: X (npx2) coordinates x and y   ;   T connectivities (nex4).
%            edges.d = points in position DOWN (without rotation of corners)
%            edges.u = points in position UP   (without rotation of corners)
%            edges.l = points in position LEFT (without rotation of corners)
%            edges.r = points in position RIGHT (without rotation of corners)% 
%            Nb = Matrix(ne*8) containing the neighbour elements
%                    anticlockwise strating from down-left
%            mids.h = Mid points in the horizontal direction
%            mids.v = Mid points in the vertical direction
%            edgEcell = Cell {ne x nsides} with nodes in the edges
%
%   Ordering                            T Ordering
%    . ----  . --- ... - npy*npx        1               2             npx+2    npx+1
%    .       .             .            2               3             npx+3    npx+2
%    .       .             .                ...
%  npx+1 - npx+2 - ... - 2*npx         npx-1           npx           2*npx    2*npx-1
%    |       |             |           npx+1           npx+2         2*npx+2  2*npx+1
%    1 ----- 2 --- ... -- npx          npx+2           npx+3         2*npx+3  2*npx+2
%                                           ...
%                                      2*npx-1         2*npx         3*npx    3*npx-1
%                                           ...
%                                           ...
%                                      (npy-1)*npx-1  (npy-1)*npx    npy*npx  npy*npx-1

if nargin==1
    ney=nex;
end

vx=-1:2/nex:1;
vy=-1:2/ney:1;
npx=nex+1;
npy=ney+1;
np=npx*npy;
ne=nex*ney;

[a,b]=meshgrid(vy,vx);

X=[reshape(b,np,1), reshape(a,np,1)];
if nargin==3
    N = ShapeFunc('Quad4',X);
    X=N*corners;
end

edges.d = 1:npx;
edges.u = edges.d + npx*ney;
edges.l = 1:npx:np;
edges.r = edges.l + nex;
edges.all = unique([edges.d, edges.l, edges.r, edges.u]);

if mod(ney,2)==0 % enevn number of elements in y
mids.h=edges.d + npx*ney/2; 
end
if mod(nex,2)==0  % enevn number of elements in x
mids.v=edges.l + nex/2;
end
if mod(ney,2)==0 || mod(nex,2)==0
    if mod(ney,2)==0 && mod(nex,2)==0
        mids.all=unique([mids.h,mids.v]);
    elseif mod(ney,2)~=0
        mids.all=mids.v;
    elseif mod(nex,2)~=0
        mids.all=mids.h;
    end
else
    mids=[];
    disp('function MeshQuad: since both nex & ney are odd, mid output is empty')
end
% %%%%%%%%%%%%%  CONNECTIVITIES %%%%%%%%%%%%%%%%%%%%%%%%%%
% allocation full connectivity matrix
T=zeros(ne,4);
% Connectivity of 1st element
aux=[1 2 npx+2 npx+1];
% Connectivity of all elements in 1st row (lower one)
aux2=zeros(nex,4);
for i=1:nex
    aux2(i,:)=aux+i-1;
end
% index matrix rows in a lower row of elements.
ind=1:nex;
% fill the matrix with all the rows.
for j=1:ney
    T(ind,:)=aux2;
    ind=ind+nex;
    aux2=aux2+npx;
end
%%%% LOOP ELEMENTS EDGES %%%%%%%%%%%%%
edgEcell=cell(ne,4);
for iE=1:ne
    edgEcell{iE,1}=T(iE,[1 2]);
    edgEcell{iE,2}=T(iE,[2 3]);
    edgEcell{iE,3}=T(iE,[3 4]);
    edgEcell{iE,4}=T(iE,[4 1]);
end

% %%%%%%%%%%%%%   NEIGHBOURS    %%%%%%%%%%%%%%%%%%%%%%%%%%
Nb8=zeros(ne,8);
if nex==1 && ney==1
elseif nex==1 && ney~=1
    for ne=1:(ney-1)
        Nb8(ne,6)=ne+1;
        Nb8(ne+1,2)=ne;
    end
elseif ney==1 && nex~=1
    for ne=1:(nex-1)
        Nb8(ne,4)=ne+1;
        Nb8(ne+1,8)=ne;
    end
else
    % Corners
    % Down-Left
    Nb8(1,4)=2; Nb8(1,5)=nex+2; Nb8(1,6)=nex+1;
    % Down-Right
    Nb8(nex,8)=nex-1; Nb8(nex,7)=2*nex-1; Nb8(nex,6)=2*nex;
    % Up-Right
    Nb8(ne,1)=ne-nex-1; Nb8(ne,2)=ne-nex; Nb8(ne,8)=ne-1;
    % Up-Left
    ieUL=ne-nex+1;
    Nb8(ieUL,2)=ieUL-nex; Nb8(ieUL,3)=ieUL-nex+1; Nb8(ieUL,4)=ieUL+1;
    
    if nex >2
        for i_D=2:(nex-1)
            i_U=i_D+ne-nex;
            % Down edge elements
            Nb8(i_D,4)=i_D+1; Nb8(i_D,5)=i_D+nex+1; Nb8(i_D,6)=i_D+nex; Nb8(i_D,7)=i_D+nex-1; Nb8(i_D,8)=i_D-1;
            % Up edge elements
            Nb8(i_U,1)=i_U-nex-1; Nb8(i_U,2)=i_U-nex; Nb8(i_U,3)=i_U-nex+1; Nb8(i_U,4)=i_U+1; Nb8(i_U,8)=i_U-1;
        end
    end
    
    if ney >2
        for kk=2:(ney-1)
            i_L=kk*nex-nex+1;
            i_R=kk*nex;
            % Left edge elements
            Nb8(i_L,2)=i_L-nex; Nb8(i_L,3)=i_L-nex+1; Nb8(i_L,4)=i_L+1; Nb8(i_L,5)=i_L+nex+1; Nb8(i_L,6)=i_L+nex;
            % Right edge elements
            Nb8(i_R,1)=i_R-nex-1; Nb8(i_R,2)=i_R-nex; Nb8(i_R,6)=i_R+nex; Nb8(i_R,7)=i_R+nex-1; Nb8(i_R,8)=i_R-1;
        end
    end
    
    if nex >2 && ney >2
        % Interiore elements
        for ie=1:ne
            if sum(Nb8(ie,:))==0 % if not is on a corner or an edge
                Nb8(ie,1)=ie-nex-1; Nb8(ie,2)=ie-nex; Nb8(ie,3)=ie-nex+1; Nb8(ie,4)=ie+1;
                Nb8(ie,5)=ie+nex+1; Nb8(ie,6)=ie+nex; Nb8(ie,7)=ie+nex-1; Nb8(ie,8)=ie-1;
            end
        end
    end
end
Nb4=Nb8(:,[2 4 6 8]);
end

