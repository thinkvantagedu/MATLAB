function S = generatespheres(DIM,N)
% Generate N random spheres in a DIM x DIM grid; 
%
% Example: without output, it creates a graphical visualization: 
%          generatespheres(32,20);
% Example: with output, it return a structure with center coordinates, radii and color
%          S = generatespheres(32,20);

S.rgb = rand(N,3);
S.xyz = rand(N,3)*DIM-DIM/2;
S.radius = rand(N,1)*DIM/10+DIM/50;
S.N = N;
S.DIM = DIM;

% visualize
if nargout == 0
    [x,y,z] = sphere(50);
    hold on
    for idx = 1:N
        r = S.radius(idx);
        c = S.xyz(idx,:);
        surf(r*x+c(1),r*y+c(2),r*z+c(3),'FaceColor',S.rgb(idx,:))
    end
    shading interp
    alpha 0.5
    view(3)
    ax = gca;
    ax.Color = 'k';
    ax.PlotBoxAspectRatio = [1 1 1];
    ax.XColor = 'w';
    ax.YColor = 'w';
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.XTick = -DIM/2:DIM/2;
    ax.YTick = -DIM/2:DIM/2;
    ax.XTickLabel = '';
    ax.YTickLabel = '';
    axis([-DIM/2,DIM/2,-DIM/2,DIM/2])
    rotate3d on
end
