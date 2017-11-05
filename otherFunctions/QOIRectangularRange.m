function no_qoi = QOIRectangularRange(node, qoi_left, qoi_right, qoi_up, qoi_down)
%% define rectangular range for quantity of interest_
% qoi_left = 70;
% qoi_right = 95;
% qoi_up = 0.5;
% qoi_down = -1;

no_qoi = [];
no_node = size(node, 1);

for i1 = 1:no_node
    
    if qoi_left < node(i1, 2) && node(i1, 2) < qoi_right && qoi_down < node(i1, 3) && node(i1, 3) < qoi_up
        no_qoi = [no_qoi; node(i1, 1)];
    end
    
end