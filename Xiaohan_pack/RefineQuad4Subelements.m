function [refined] = RefineQuad4Subelements(coordinates_initial, connectivity_initial, neighbours, nsubelemx)

% [refined] = RefineQuad4Subelements(coordinates_initial, connectivity_initial, neighbours, nsubelemx)
% From ANY Quad4 initial mesh, and neighbour matrix, generates a refined
% mesh of  nsubelemX x nsubelemX subelements per element
% 
% Input:
%   coordinates_initial  : matrix containing the coordinates of the mesh
%   connectivity_initial : matrix(n_elem*4) containing the connectivity of
%                          coarse mesh (anticlockwise)
%   neighbours : matrix(n_elem*4) containing the neighbour IN THE SAME
%                ORDER as the connectivity
% Output:
%   refined.coordinates      = matrix with connectivity of the refined mesh
%   refined.connectivities   = matrix with coordinates of nodes in ref mesh
%   refined.subelements      = matrix with subelement per original element
%   refined.subnodes_ordered = matrix subnodes per element left-right down-up
%   refined.edges_elem       = cell{n_elem,4} contains the nodes of edges
%                                same order as connectivity (l-r, d-u)
%   refined.edges_elem_all   = matrix with all the nodes in the boundary 
%
%
% implementation notes
%   for the squeme below, IF element 1 CONNECTIVITY(1,:) is [1 2 5 4]
%   NEIGHBOURS(1,:) must be  [0 2 0 0], since element 2 is on the 2nd edge
%        in concordance with the order of the  
%   if CONNECTIVITY(1,:) is [5 4 1 2], then NEIGHBOURS(1,:) must be  [0 0 0 2]
% elements              
%                   the shared edges where X must be dictated is    2 - 5
%  4-----5-----6    on the origin element we find 2 first          [2]- 5
%  |     |     |    on the destination element we find 2 last       5 -[2] 
%  |     X     |    instead of using  [1 2 3 4]' to multiply by boolean vector element2==2
%  |     |     |    we can use        [4 1 2 3]' and we will get directly the right position 
%  1-----2-----3      (element2==2) =[1 0 0 0]*[4 1 2 3]'= 4 
%
%

 
% % FIRST I CHECK IF IT IS COMPUTED
% 
% addpath(genpath('/home/p/codes/matlab/data_matlab/ErrorEstimation'));

% Needed values
[n_nodes_initial,n_dimensions_per_node]=size(coordinates_initial);
[n_elem_initial,n_nodes_element]=size(connectivity_initial);
nsubelem=nsubelemx^2;
nsubpx=nsubelemx+1;
nsubp=nsubpx^2;
max_np_total=n_elem_initial*nsubp;
% extra_nodes_element=nsubp-n_nodes_element;
extra_nodes_per_edge=nsubpx-2;
extra_nodes_interior=extra_nodes_per_edge^2;
n_nodes_boundary=n_nodes_element+n_nodes_element*extra_nodes_per_edge;
last_node=max(max(connectivity_initial)); % To initialize the loop is the last existent , not the next
exterior_counter=0;
[~,n_edges]=size(neighbours);
% n_dictated_nodes=n_edges*(nsubpx-2); % only valid for linear 
% n_nodes_boundary=n_edges*(nsubpx-1); % only valid for linear 
[ ~, connectivity_subelements_local ] = MeshQuad4(nsubelemx);
aux_avoid_find=[n_nodes_element, 1:(n_nodes_element-1)]'; 

% Preallocation
coordinates_refined=[coordinates_initial; zeros(max_np_total-n_nodes_initial, n_dimensions_per_node)]; % Maximum size possible.
connectivity_refined=zeros(nsubelem*n_elem_initial, n_nodes_element);
connectivity_dictated_by_neighbours=cell(n_elem_initial, n_edges);
subelements_per_element=zeros(n_elem_initial,nsubelem);
edges_element=cell(n_elem_initial,n_edges);
edges_element_all=zeros(n_elem_initial,n_edges*(extra_nodes_per_edge+1));
corners=zeros(n_elem_initial,n_edges);
subnodes_element_structured=zeros(n_elem_initial,nsubp);
subnodes_element_corner_edge_int=zeros(n_elem_initial,nsubp);
external_edge=zeros(((n_elem_initial+2)*nsubpx),1);

% Local edge Indexes
index_edge1_local_full=(1:nsubpx)';                         % Usually down
index_edge2_local_full=(nsubpx:nsubpx:nsubp)';              % Usually right
index_edge3_local_full=flipud(((nsubp-nsubpx+1):nsubp)');   % Usually up
index_edge4_local_full=flipud((1:nsubpx:nsubp)');           % Usually left

index_edges_local_full=[index_edge1_local_full; index_edge2_local_full; index_edge3_local_full; index_edge4_local_full];

index_corners_local=[1; nsubpx; nsubp; nsubp-nsubpx+1];  % anticlockwise
index_interior_local=setdiff(unique(connectivity_subelements_local), [index_corners_local ; index_edges_local_full]);

% index_edges_local_reduced{1}=1:(nsubpx-2);                               % Usually down
% index_edges_local_reduced{2}=((nsubp-4)-(nsubpx-3)):(nsubp-4);           % Usually up
% index_edges_local_reduced{3}=(nsubpx-1):nsubpx:((nsubp-4)-(nsubpx-2));   % Usually left
% index_edges_local_reduced{4}=(2*nsubpx-2):nsubpx:((nsubp-4)-(nsubpx-2)); % Usually right
index_edges_local_no_corners{1}=index_edge1_local_full(2:(end-1));        % Usually down
index_edges_local_no_corners{2}=index_edge2_local_full(2:(end-1));        % Usually right
index_edges_local_no_corners{3}=index_edge3_local_full(2:(end-1));        % Usually up
index_edges_local_no_corners{4}=index_edge4_local_full(2:(end-1));        % Usually left
index_edges_global_no_corners=index_edges_local_no_corners;               % Just preallocation
index_local_for_substitution=[index_corners_local ; index_edges_local_no_corners{1}; ...
                              index_edges_local_no_corners{2}; index_edges_local_no_corners{3}; ...
                              index_edges_local_no_corners{4}; index_interior_local ];

% Create reference coordinates & Shape functions.
vector_reference=linspace(-1,1,nsubpx);
[y_matrix,x_matrix]=meshgrid(vector_reference,vector_reference); % OK, left-right, down-up
% y_matrix_interior=y_matrix;
% y_matrix_interior(1,:)=[]; y_matrix_interior(end,:)=[]; y_matrix_interior(:,1)=[]; y_matrix_interior(:,end)=[];
% x_matrix_interior=x_matrix;
% x_matrix_interior(1,:)=[]; x_matrix_interior(end,:)=[]; x_matrix_interior(:,1)=[]; x_matrix_interior(:,end)=[];
xy_reference_all= [reshape( x_matrix, numel(x_matrix),1), reshape( y_matrix, numel(y_matrix),1)];
xy_reference_interior=xy_reference_all;
xy_reference_interior(index_edges_local_full,:)=[];
N_all = ShapeFunc('Quad4',xy_reference_all);
N_interior = ShapeFunc('Quad4',xy_reference_interior);
N_edge{1} = ShapeFunc('Quad4',xy_reference_all(index_edge1_local_full(2:end-1),:));
N_edge{2} = ShapeFunc('Quad4',xy_reference_all(index_edge2_local_full(2:end-1),:));
N_edge{3} = ShapeFunc('Quad4',xy_reference_all(index_edge3_local_full(2:end-1),:));
N_edge{4} = ShapeFunc('Quad4',xy_reference_all(index_edge4_local_full(2:end-1),:));

% LOOP OVER ELEMENTS, TO DEFINE NEW SUBELEMENTS, NODES AND COORDINATES
for ne=1:n_elem_initial
%     fprintf('--------- element number %i ------------- \n',ne)
    index_corners_global=(connectivity_initial(ne,:))'; 
    ind_c_extended=[index_corners_global; index_corners_global(1)]; % just add the 1st at the end
    coordinates_corners=coordinates_initial(index_corners_global,:); % To use with shape functions
    dictated_nodes=connectivity_dictated_by_neighbours(ne,:); % This is a cell{1 x n_elem} of vectors
    for i=1:n_edges % Loop edges of the element.
        dict_n=dictated_nodes{i}; % This is the vector of imposed nodes if any.
        if isempty(dict_n) % NOT IMPOSED SO THEY ARE NEW NODES TO IMPLEMENT.
            next_nodes=((last_node+1):(last_node+extra_nodes_per_edge))'; % new nodes on the edge 
            index_edges_global_no_corners{i}=next_nodes; % Store for later use
            
            % ADDING THE NEW COORDINATES
            coordinates_refined(next_nodes,:)=N_edge{i}*coordinates_corners;
            
            % IMPOSING THE NEW NODE TO THE NEIGHBOURS IF ANY
            neighbour_elem=neighbours(ne,i);
            if neighbour_elem==0 % no neighbour
                ind=(1:nsubpx)+exterior_counter*nsubpx;
                external_edge(ind)=[ind_c_extended(i) ;next_nodes; ind_c_extended(i+1)];
                exterior_counter=exterior_counter+1;
            else % find which the neighbour and position of the edge there and store for imposing later
                n1_on_edge_origin=connectivity_initial(ne,i);  % Defines the edge
                connectivity_in_destination_element=connectivity_initial(neighbour_elem,:);
                position_n1_destination=(connectivity_in_destination_element==n1_on_edge_origin)*aux_avoid_find;
                connectivity_dictated_by_neighbours{neighbour_elem,position_n1_destination}=flipud(next_nodes);
            end
            last_node=last_node+extra_nodes_per_edge;
        else
            index_edges_global_no_corners{i}=dict_n;
        end  
        edges_element{ne,i}=[ind_c_extended(i); index_edges_global_no_corners{i} ; ind_c_extended(i+1)];

    end
    edges_element_all(ne,:)=[ind_c_extended(1); index_edges_global_no_corners{1} ; ind_c_extended(2); index_edges_global_no_corners{2} ; ...
                             ind_c_extended(3); index_edges_global_no_corners{3} ; ind_c_extended(4); index_edges_global_no_corners{4}]';
    corners(ne,:)=index_corners_global(1:n_edges);
    % INTERIOR NODES.
    next_nodes=((last_node+1):(last_node+extra_nodes_interior))';
    index_interior_global=next_nodes;
    % ADDING THE NEW COORDINATES
    coordinates_refined(next_nodes,:)=N_interior*coordinates_corners;
    last_node=last_node+extra_nodes_interior;
    
    % INDEX FOR SUBSTITUTION
    index_global_for_substitution=[index_corners_global ; index_edges_global_no_corners{1}; ...
                              index_edges_global_no_corners{2}; index_edges_global_no_corners{3}; ...
                              index_edges_global_no_corners{4}; index_interior_global ];
    % BLOCK OF REFINED CONNECTIVITIES.
    connectivity_subelements_global=RenumberMatrix( connectivity_subelements_local, index_local_for_substitution ,index_global_for_substitution);
    % FILLING THE WHOLE CONNECTIVITY MATRIX
    index_in_full=(1:nsubelem)+nsubelem*(ne-1);
    connectivity_refined(index_in_full,:)=connectivity_subelements_global;
    
    % OTHER VALUES
    subelements_per_element(ne,:)=(1:nsubelem)+(ne-1)*nsubelem;
    subnodes_element_structured(ne,:)=RenumberMatrix(1:nsubp , index_local_for_substitution , index_global_for_substitution);
    subnodes_element_corner_edge_int(ne,:)=index_global_for_substitution';
end
% processing external_edge
external_edge=unique(external_edge,'stable');
external_edge(external_edge==0)=[];


% STORING VALUES TO OUTPUT
refined.coordinates=coordinates_refined(1:last_node,:); % Getting rid of excess of preallocation.
refined.connectivities=connectivity_refined;
refined.subelements=subelements_per_element;
refined.edges_elem=edges_element;
refined.edges_elem_all=edges_element_all;
refined.edges_full_domain=external_edge;
refined.corners=corners;
refined.subnodes_structured=subnodes_element_structured;
refined.subnodes_corner_edge_int=subnodes_element_corner_edge_int;
refined.subnodes_corners=subnodes_element_corner_edge_int( : , (1:n_nodes_element) );
refined.subnodes_edges=subnodes_element_corner_edge_int( : , ((n_nodes_element+1):n_nodes_boundary) );
refined.subnodes_int=subnodes_element_corner_edge_int( : , ( (n_nodes_boundary+1):end) );
refined.shape_functions_structured=N_all;
refined.shape_functions_corner_edge_int=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; N_edge{1} ; N_edge{2} ; N_edge{3} ; N_edge{4} ; N_interior];
refined.shape_functions_corners=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
refined.shape_functions_edges=[ N_edge{1} ; N_edge{2} ; N_edge{3} ; N_edge{4} ];
refined.shape_functions_int=[ N_interior];






