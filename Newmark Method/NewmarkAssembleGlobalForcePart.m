function [part1, part2, part3, part4] = NewmarkAssembleGlobalForcePart(fce, no_dof, no_t_step, cp1, cp2, cp3, cp4)

part1 = sparse(3*no_dof*(no_t_step-1), 1);
part2 = sparse(3*no_dof*(no_t_step-1), 1);
part3 = sparse(3*no_dof*(no_t_step-1), 1);
part4 = sparse(3*no_dof*(no_t_step-1), 1);

coeff1 = sparse(2*no_dof, 1);
coeff2 = sparse(3*no_dof, 1);

part1(1:3*no_dof) = part1(1:3*no_dof)+cp1;
part2(1:3*no_dof) = part2(1:3*no_dof)+cp2;
part3(1:3*no_dof) = part3(1:3*no_dof)+cp3;
part4(1:3*no_dof) = part4(1:3*no_dof)+cp4;

for i_p1 = 2:no_t_step-1
    
    part1((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :) = part1((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :)+...
        [fce(:, i_p1+1); coeff1];
    part2((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :) = part2((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :)+...
        coeff2;
    part3((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :) = part3((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :)+...
        coeff2;
    part4((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :) = part4((i_p1-1)*3*no_dof+1:i_p1*3*no_dof, :)+...
        coeff2;
    
end