clear; clc;clf;
% nsh = 2;
% a = [];
% for i = 1:2
%     for j = i:2
%         for k=1:2
%             for l=k:2
%                 a = [a; (i-1)*3+k,(j-1)*3+l];
%             end
%         end
%     end
% end
% x = a(:, 1); y = a(:, 2); scatter(x, y, 'filled');

for i = 1:2
    for j = 1:2
        for k = 1:2
            for l = 1:2
                disp([i+k, j+l])
            end
        end
    end
end