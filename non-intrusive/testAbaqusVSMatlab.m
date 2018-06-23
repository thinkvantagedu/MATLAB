load('/home/xiaohan/Desktop/Temp/MATLAB/non-intrusive/disAbaqus.mat', ...
    'disAbaqus');
load('/home/xiaohan/Desktop/Temp/MATLAB/non-intrusive/disMatlab.mat', ...
    'disMatlab');
clf;
x = 1:491;

testDof = 20;
plot(x, disMatlab(testDof, :), 'b');
hold on
plot(x, disAbaqus(testDof, :), 'k');