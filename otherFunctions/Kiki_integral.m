clc;
syms x
a = 40.394;
upper_part = 1 / 2 * (3 * x ^ 2 - 1) * exp(a * x ^ 2);
lower_part = exp(a * x ^ 2);
% output_ = upper_part / lower_part
output1 = int(upper_part, x, -1, 1);
output2 = int(lower_part, x, -1, 1);
output = output1 / output2;