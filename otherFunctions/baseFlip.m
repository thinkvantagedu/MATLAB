function[a] = baseFlip(k, b) % reversed base-b expansion of positive integer k
j = fix(log(k) / log(b)) + 1;
a = zeros(1, j);
q = b ^ (j - 1);
for i = 1 : j
   a(i) = floor(k / q);
   k = k - q * a(i);
   q = q / b;
end
a = fliplr(a);