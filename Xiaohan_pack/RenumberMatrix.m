function [ M2 ] = RenumberMatrix( M1, varargin )
% [ M2 ] = RenumberMatrix( M1, varargin )
% Transform the values of M1 to M2 through correspondence vectors.
% Inputs:
%   M1        : origin matrix
%   varargin  :
%      1 vector  => the unique(M1','stable') values will be substituted by its components
%      empty     => as 1 vector using 1:(1:length(unique(M1)))' 
%      2 vectors => the values of vector 1 substituted by vector 2
%      matrix    => as 2 vectors.

n_nodes=numel(M1);
l_input=length(varargin);

if l_input==0
%     v1=unique(M1);
        v1=unique(M1', 'stable');
    v2=(1:length(v1))';
elseif l_input==2
    v1=varargin{1};
    v2=varargin{2};
    if length(v1)~=length(v2)
        error('RenumberMatrix: The correspondece vectors introduced have different size)')
    end
elseif l_input==1
    if isvector(varargin{1});
%     v1=unique(M1);
        v1=unique(M1', 'stable');
        v2=varargin{1};
        if length(v1)~=length(v2)
            error('RenumberMatrix: The correspondece vector, has different size than the unique noces in M1)')
        end
    else
        Mc=varargin{1};
        [~,ncol]=size(Mc);
        if ncol==2
            v1=Mc(:,1);
            v2=Mc(:,2);
        else 
            v1=Mc(1,:);
            v2=Mc(2,:);
        end
    end
    
else
    error('RenumberMatrix: Wrong number of input arguments)')
end

M2=M1;
n_changes=numel(v1);
group=100000;
if n_changes>group
    t=datestr(now);   fprintf(t);    fprintf('   RenumberMatrix has %i elements to change it may be slow \n', n_changes); 
    n_loops=floor(n_changes/group);
    for l=1:n_loops
        for i=((1:group)+group*(l-1))
            M2(M1(:)==v1(i))=v2(i);
        end
        t=datestr(now);   fprintf(t);    fprintf('   %i changes of %i performed \n',group*l, n_changes);
    end
    for i=(n_loops*group+1):n_changes
        M2(M1(:)==v1(i))=v2(i);
    end
else
    for i=1:n_changes
        M2(M1(:)==v1(i))=v2(i);
    end
end

end

