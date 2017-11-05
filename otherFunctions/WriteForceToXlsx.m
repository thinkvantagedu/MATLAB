 x=(0:0.01:4);
 y=sin(pi/4*x);
 z=[x', y'];
 filename='impulse force.xlsx';
 xlswrite(filename, z);