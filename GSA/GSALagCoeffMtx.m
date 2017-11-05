function [Dis_coeff_asemb] = GSALagCoeffMtx(no_rb, no_pre, no_dof, no_t_step, pm_block, Dis_store_glob)
% for each (no.pre) numbers of (no.rb*no.dof, no.t_step) displacement
% blocks, compute corresponding (no.pre) numbers of (no.rb*no.dof,
% no.t_step) coefficients for Lagrange interpolation. 
Dis_coeff_asemb  = zeros(no_rb*no_pre*no_dof, no_t_step);
for i_pre = 1:no_rb
    Dis_part_glob = ...
        Dis_store_glob((i_pre-1)*no_pre*no_dof+1:i_pre*no_pre*no_dof, :);
    Dis_coeff_glob = ...
        LagInterpolationCoeff(pm_block, Dis_part_glob);
    Dis_coeff_asemb((i_pre-1)*no_pre*no_dof+1:i_pre*no_pre*no_dof, :) = ...
        Dis_coeff_asemb((i_pre-1)*no_pre*no_dof+1:i_pre*no_pre*no_dof, :)+...
        Dis_coeff_glob;
end