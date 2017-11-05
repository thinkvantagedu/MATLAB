% clear variables; clc;
%
% fh=figure;
% for k = 1:16
% plot(fft(eye(k+16)))
% axis equal
% M(k) = getframe(fh);
% end
% VideoWriter(M,'1.avi');


% for i = 1:no.t_step
%     PlotDeformedStruct(node, cons.dof, elem, Dis.trial.exact(:, i), deform_factor, label_switch);
%     f(i) = getframe;
% end
% 
% vid = VideoWriter('dis.avi');
% open(vid)

% Prepare the new file.
FrameRate = 10;
Dis.video = VideoWriter('dis.avi');
Dis.video.FrameRate = 15;  % Default 30
Dis.video.Quality = 75;    % Default 75
open(Dis.video);

deform_factor = 1;
label_switch = 0;

for k = 1:no.t_step
    PlotDeformedStruct(node, cons.dof, elem, Dis.trial.exact(:, k), deform_factor, label_switch);
    axis([-10 100 -5 25])
    % Write each frame to the file.
    currFrame = getframe(gcf);
    writeVideo(Dis.video,currFrame);
end

% Close the file.
close(Dis.video);