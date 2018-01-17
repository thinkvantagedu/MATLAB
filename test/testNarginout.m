function [otptx, otpty] = testNarginout(inpx, inpy, inpz)

if nargin == 2
    otptx = inpx * inpy;
elseif nargin == 3
    otpty = inpx * inpy * inpz;
end

end