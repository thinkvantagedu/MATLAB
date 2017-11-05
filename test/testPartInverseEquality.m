clear variables; clc;

a = randIntSymMTX(3);

a1 = randIntSymMTX(3);

b = randIntSymMTX(3);

z = zeros(3);

c = [a1 z z z; b a z z; z b a z; z z b a];

inva1 = inv(a1);

inva = inv(a);

invb = inv(b);

invc = inv(c);