clear; clc;

% the cells.
bl = {1 2};
br = {3 4};

e1 = bl{1} * br{1}';
e2 = bl{2} * br{2}';
e = [e1 e2];
ete = e' * e;

% element 1.
l1 = bl{1, 1};
l2 = bl{1, 1};
r1 = br{1, 1};
r2 = br{1, 1};

otpt11 = r2' * r1 * l1' * l2;

% element 2.
l1 = bl{1, 2};
l2 = bl{1, 1};
r1 = br{1, 2};
r2 = br{1, 1};

otpt12 = r2' * r1 * l1' * l2;

% element 3.
l1 = bl{1, 1};
l2 = bl{1, 2};
r1 = br{1, 1};
r2 = br{1, 2};

otpt21 = r2' * r1 * l1' * l2;

% element 4.
l1 = bl{1, 2};
l2 = bl{1, 2};
r1 = br{1, 2};
r2 = br{1, 2};

otpt22 = r2' * r1 * l1' * l2;

% put all ements together.
% otpt = [otpt11 otpt12; otpt21 otpt22];
otpt = zeros(2, 2);
for i = 1:2
    for j = 1:2
        
        l1 = bl{1, j};
        l2 = bl{1, i};
        r1 = br{1, j};
        r2 = br{1, i};
        
        otpt(i, j) = otpt(i, j) + r2' * r1 * l1' * l2;
        
    end
end
        
a = [3 8];
aTa = a' * a;

al = {1 2};
ar = {3 4};

ata1 = cellfun(@(l1, l2, r1, r2) r2' * r1 * l1' * l2, al, al, ar, ar, 'un', 0);