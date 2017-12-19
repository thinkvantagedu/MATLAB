% this script plot the fixed end beam with rectangular inclusion in the
% middle, no mesh is needed, l = 90, h = 20.
hold on
% matrix
rectangle('Position', [0 0 90 20], 'FaceColor', [0.84706 0.84706 0.84706])

% inclusion
rectangle('Position', [35.8 0 18.4 20], 'FaceColor', [0.41176 0.8 0.67059])

axis([0 90 -15 35])

axis off