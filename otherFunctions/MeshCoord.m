% clear all;
% clc;
% 
% coord.a=[0, 0];
% coord.b=[6, 0];
% coord.c=[5, 3];
% coord.d=[1, 3];
% 
% % LR=left to right, TB=top to bottom.
% LR=4;
% TB=3;
% 
% vec.ab=[coord.a; coord.b];
% vec.bc=[coord.b; coord.c];
% vec.cd=[coord.c; coord.d];
% vec.da=[coord.d; coord.a];
% 
% dist.ab=pdist(vec.ab, 'euclidean');
% dist.bc=pdist(vec.bc, 'euclidean');
% dist.cd=pdist(vec.cd, 'euclidean');
% dist.da=pdist(vec.da, 'euclidean');
% 
% piece.ab=(0:(dist.ab/LR):dist.ab);
% piece.bc=(0:(dist.bc/TB):dist.bc);
% piece.cd=(0:(dist.cd/LR):dist.cd);
% piece.da=(0:(dist.da/TB):dist.da);
% 
close all, clear all, clc

x = [0 1 2 2 1 1 0 0];
y = [0 0 0 1 1 2 2 1];
for i = 1 : length(x)
    text(x(i)+0.1,y(i)+0.1,sprintf('%d',i))
    hold on
end
quad = [1 2 5 8;
    2 3 4 5;
    8 5 6 7];

plot(x,y,'k.-')
axis off

z = sin(pi*x).*cos(pi*y);
c = z;
figure

ax=newplot;
fc = get(gcf,'Color');
h = patch('faces',quad,'vertices',[x(:) y(:) z(:)],'facevertexcdata',c(:),...
    'facecolor',fc,'edgecolor',get(ax,'defaultsurfacefacecolor'),...
    'facelighting', 'none', 'edgelighting', 'flat',...
    'parent',ax);