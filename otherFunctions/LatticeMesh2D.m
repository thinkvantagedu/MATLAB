function [elem_mp,node,elem_coords]=LatticeMesh2D(geometry, Em, parameterm)

global elem
%INPUT: number of beams in x&y; horizontal and vertical length; Young's
%modulus
%OUTPUT: node coords, elem connectivity, coords in order of connectivity,
%Young's modulus in whole struct
node=[];
elem=[];
elem_mp=[];
elem_coords=[];
material_parameters=[];

%%-------------------------------------------------------------------------

%%-------------------------------------------------------------------------

lengthx=geometry.lx/geometry.bx;
lengthy=geometry.ly/geometry.by;%length of triangle edges
halflengthx=lengthx/2;%length of special triangle edges (half)

%%-------------------------------------------------------------------------

%%-------------------------------------------------------------------------

%% i and j are nodes, not beams
for i=1:geometry.by+1 %i=1:number of nodes in vertical
    
    if floor(i/2)-i/2~=0%ODD ROWS in struct, i=1 3 5 7...when odd, go on; 
        %even, execute else
        
        for j=1:geometry.bx+1 %j=1:number of nodes in horizontal
            
            node=[node;(j-1)*lengthx (i-1)*lengthy];%i=1;j=1,2,3,4
            
            if i<geometry.by+1 %ie i=1,3,...,geometry.by+1
                
                elem=[elem;size(node,1) size(node,1)+geometry.bx+1];%size of 
                %(node,1) equals to 1:geometry.bx+1 here
                
                elem=[elem;size(node,1) size(node,1)+geometry.bx+2];
                %create connectivity for nodes 1,5 1,6 2,6 2,7 ...
          
            end
            
            if (j>1)
                
                elem=[elem;size(node,1)-1 size(node,1)];%create 
                %connectivity for nodes 1,2 2,3 3,4 ...
                
            end
            
        end
       
    else %even ROWS in struct,i=2 4 6 8...
        
        for j=1:geometry.bx+2 %even rows contain 1 more node than odd rows, 
            %thus geometry.bx+2
            
            if j==1 %the first node of even row
                
                node=[node; 0 (i-1)*lengthy];%display node number
                
                if i<geometry.by+1
                    
                    elem=[elem;size(node,1) size(node,1)+geometry.bx+2];
                    
                end
                
            elseif j~=geometry.bx+2 %nodes except first and last ones
                
                node=[node; (j-1)*lengthx-halflengthx (i-1)*lengthy];
                
                if i<geometry.by+1
                    
                    elem=[elem;size(node,1) size(node,1)+geometry.bx+1];
                    elem=[elem;size(node,1) size(node,1)+geometry.bx+2];
                    
                end
                
                elem=[elem;size(node,1)-1 size(node,1)];
                
            else %last node
                
                node=[node; (j-2)*lengthx (i-1)*lengthy];
                
                if i<geometry.by+1
                    
                    elem=[elem;size(node,1) size(node,1)+geometry.bx+1];
                    
                end
                
                elem=[elem;size(node,1)-1 size(node,1)];
                
            end

        end
        
    end
        
end

%%-------------------------------------------------------------------------

%%-------------------------------------------------------------------------

elem_coords=zeros(size(elem,1),4);

for i=1:size(node,1)%from 1:(size of elem), generate size of elem*4 matrix 
    
    a=find(elem(:,1)==i);%find out the location where node matches elem in 
    %the first column of elem
    b=find(elem(:,2)==i);%find out the location where node matches elem in 
    %the second column of elem
    
    elem_coords(a,1)=elem_coords(a,1)+node(i);%give the CORRESPONDING coords 
    %to the first column of elem_coords
    elem_coords(b,3)=elem_coords(b,3)+node(i);%give the CORRESPONDING coords 
    %to the third column of elem_coords
 
end


for i=(size(node,1)+1):(2*size(node,1))%i from the 1st one of second column 
    %of node to the last one of second column
    
    a=find(elem(:,1)==i-size(node,1));%find out the location where node 
    %matches elem in the first column of elem
    b=find(elem(:,2)==i-size(node,1));%find out the location where node 
    %matches elem in the second column of elem

    
    elem_coords(a,2)=elem_coords(a,2)+node(i);%give the CORRESPONDING coords to 
    %the second column of elem_coords
    elem_coords(b,4)=elem_coords(b,4)+node(i);%give the CORRESPONDING coords to 
    %the fourth column of elem_coords
        
end

Ecolumn=[];
for i=1:size(elem(:,1))
Ecolumn=[Ecolumn Em];
end
Acolumn=[];
for i=1:size(elem(:,1))
Acolumn=[Acolumn parameterm.Am];
end
Icolumn=[];
for i=1:size(elem(:,1))
Icolumn=[Icolumn parameterm.Im];
end
material_parameters=[Ecolumn' Acolumn' Icolumn'];
elem_mp=[elem material_parameters];
%%-------------------------------------------------------------------------
