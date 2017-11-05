function [rv_vec] = NewmarkAssembleReducedVariableVector(dd_rv, d_rv, rv, no_t_step)

%% assemble reduced variable vector from ddot{alpha}, dot{alpha}, alpha. 

no_rb = size(dd_rv, 1);

rv_vec = zeros(3*no_t_step*no_rb, 1);

%% every section has 3*i_rv*no_rb of scalers, start from the third section, 
%% confirm 3*i_rv*no_rb, then minus all the way back.

for i_rv = 1:no_t_step
        
        rv_vec(3*i_rv*no_rb-3*no_rb+1:3*i_rv*no_rb-2*no_rb, :) = ...
            rv_vec(3*i_rv*no_rb-3*no_rb+1:3*i_rv*no_rb-2*no_rb, :)+dd_rv(:, i_rv);
        
        rv_vec(3*i_rv*no_rb-2*no_rb+1:3*i_rv*no_rb-no_rb, :) = ...
            rv_vec(3*i_rv*no_rb-2*no_rb+1:3*i_rv*no_rb-no_rb, :)+d_rv(:, i_rv);
        
        rv_vec(3*i_rv*no_rb-no_rb+1:3*i_rv*no_rb, :) = ...
            rv_vec(3*i_rv*no_rb-no_rb+1:3*i_rv*no_rb, :)+rv(:, i_rv);
    
end
