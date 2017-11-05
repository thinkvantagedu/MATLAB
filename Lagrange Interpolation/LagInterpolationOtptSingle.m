function [lag_val] = LagInterpolationOtptSingle(coeff, x, y, no_pre)
% when coeff are not consisted of square blocks but rectangular blocks,
% goes to last case, where only 4 sample points linear case is considered.
m = size(coeff, 1);
% n = size(coeff, 2);

% if n == 1
%
%     if m == 3
%
%         lag_val = coeff(1)*x+coeff(2)*y+coeff(3)*x^0;
%
%     elseif m == 4
%
%         lag_val = coeff(1)*x*y+coeff(2)*x+coeff(3)*y+coeff(4)*x^0;
%
%     elseif m == 6
%
%         lag_val = coeff(1)*x^2+coeff(2)*x*y+coeff(3)*y^2+...
%             coeff(4)*x+coeff(5)*y+coeff(6)*x^0;
%
%     elseif m == 8
%
%         lag_val = coeff(1)*x^2*y+coeff(2)*x*y^2+...
%             coeff(3)*x^2+coeff(4)*y^2+coeff(5)*x*y+coeff(6)*x+coeff(7)*y+...
%             coeff(8)*x^0;
%
%     elseif m == 9
%
%         lag_val = coeff(1)*x^2*y^2+coeff(2)*x^2*y+coeff(3)*x*y^2+...
%             coeff(4)*x^2+coeff(5)*y^2+coeff(6)*x*y+coeff(7)*x+coeff(8)*y+...
%             coeff(9)*x^0;
%
%     end
%
% elseif n>1
%
%     ord = m/n;
%
%     if ord == 3
%
%         lag_val = coeff(1:n, :)*x+...
%             coeff(2*n-n+1:2*n, :)*y+...
%             coeff(3*n-n+1:3*n, :)*x^0;
%
%     elseif ord == 4
%
%         lag_val = coeff(1:n, :)*x*y+...
%             coeff(2*n-n+1:2*n, :)*x+...
%             coeff(3*n-n+1:3*n, :)*y+...
%             coeff(4*n-n+1:4*n, :)*x^0;
%
%     elseif ord == 6
%
%         lag_val = coeff(1:n, 1:n)*x^2+...
%             coeff(2*n-n+1:2*n, :)*x*y+...
%             coeff(3*n-n+1:3*n, :)*y^2+...
%             coeff(4*n-n+1:4*n, :)*x+...
%             coeff(5*n-n+1:5*n, :)*y+...
%             coeff(6*n-n+1:6*n, :)*x^0;
%
%     elseif ord == 8
%
%         lag_val = coeff(1:n, 1:n)*x^2*y+...
%             coeff(2*n-n+1:2*n, :)*x*y^2+...
%             coeff(3*n-n+1:3*n, :)*x^2+...
%             coeff(4*n-n+1:4*n, :)*y^2+...
%             coeff(5*n-n+1:5*n, :)*x*y+...
%             coeff(6*n-n+1:6*n, :)*x+...
%             coeff(7*n-n+1:7*n, :)*y+...
%             coeff(8*n-n+1:8*n, :)*x^0;
%
%
%     elseif ord == 9
%
%         lag_val = coeff(1:n, 1:n)*x^2*y^2+...
%             coeff(2*n-n+1:2*n, :)*x^2*y+...
%             coeff(3*n-n+1:3*n, :)*x*y^2+...
%             coeff(4*n-n+1:4*n, :)*x^2+...
%             coeff(5*n-n+1:5*n, :)*y^2+...
%             coeff(6*n-n+1:6*n, :)*x*y+...
%             coeff(7*n-n+1:7*n, :)*x+...
%             coeff(8*n-n+1:8*n, :)*y+...
%             coeff(9*n-n+1:9*n, :)*x^0;
%
%     else
%     end

if no_pre == 4
    no_dof = m/4;
    lag_val = coeff(1:no_dof, :)*x*y+...
        coeff(2*no_dof-no_dof+1:2*no_dof, :)*x+...
        coeff(3*no_dof-no_dof+1:3*no_dof, :)*y+...
        coeff(4*no_dof-no_dof+1:4*no_dof, :)*x^0;
elseif no_pre == 9
    no_dof = m/9;
    lag_val = coeff(1:no_dof, :)*x^2*y^2+...
        coeff(2*no_dof-no_dof+1:2*no_dof, :)*x^2*y+...
        coeff(3*no_dof-no_dof+1:3*no_dof, :)*x*y^2+...
        coeff(4*no_dof-no_dof+1:4*no_dof, :)*x^2+...
        coeff(5*no_dof-no_dof+1:5*no_dof, :)*y^2+...
        coeff(6*no_dof-no_dof+1:6*no_dof, :)*x*y+...
        coeff(7*no_dof-no_dof+1:7*no_dof, :)*x+...
        coeff(8*no_dof-no_dof+1:8*no_dof, :)*y+...
        coeff(9*no_dof-no_dof+1:9*no_dof, :)*x^0;
    
end
end