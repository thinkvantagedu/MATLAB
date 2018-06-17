C = cf * pm * Ki;
K = Ki * pm + Ks * 1;

m = phi' * M * phi;
c = phi' * C * phi;
k = phi' * K * phi;
f = phi' * F;
u0 = zeros(1);
v0 = zeros(1);

[km, cm, am, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dt, mt, u0, v0);

% create rv and pm columns.
rvCol = [am; cm; km; km];
rvCol = num2cell([1; rvCol(:)]);

pmCol = num2cell([1; repmat([1; cf * pm; pm; 1], nt, 1)]);

% compute impulse responses.
phiI = eye(nd);
[~, ~, ~, UM1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impM1, 'average', dt, mt, U0, V0);
[~, ~, ~, UM2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impM2, 'average', dt, mt, U0, V0);
[~, ~, ~, UC1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impC1, 'average', dt, mt, U0, V0);
[~, ~, ~, UC2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impC2, 'average', dt, mt, U0, V0);
[~, ~, ~, UKi1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKi1, 'average', dt, mt, U0, V0);
[~, ~, ~, UKi2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKi2, 'average', dt, mt, U0, V0);
[~, ~, ~, UKs1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKs1, 'average', dt, mt, U0, V0);
[~, ~, ~, UKs2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKs2, 'average', dt, mt, U0, V0);

% shift impulse responses.
usStore = cell(4, nt);
for it = 1:nt
    if it == 1
        usStore{1, it} = UM1;
        usStore{2, it} = UC1;
        usStore{3, it} = UKi1;
        usStore{4, it} = UKs1;
    else
        usz = zeros(nd, it - 2);
        usm = [usz UM2(:, 1:nt - it + 2)];
        usc = [usz UC2(:, 1:nt - it + 2)];
        uski = [usz UKi2(:, 1:nt - it + 2)];
        usks = [usz UKs2(:, 1:nt - it + 2)];
        
        usStore{1, it} = usm;
        usStore{2, it} = usc;
        usStore{3, it} = uski;
        usStore{4, it} = usks;
    end
end
usStore = usStore(:);

usStore = cellfun(@(v) -v, usStore, 'un', 0);

% compute force responses.
[~, ~, ~, Uf, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, F, 'average', dt, mt, U0, V0);

% combine force and impulse responses.
usStore = [{Uf}; usStore];
usStore = cellfun(@(u) u(qd, qt), usStore, 'un', 0);

uColcell = (cellfun(@(v) v(:), usStore, 'un', 0))';

uiTui = (cell2mat(uColcell))' * cell2mat(uColcell);
%% this is a test of summing all pre-computed responses and obtain the response.
ucell = cellfun(@(u, v, w) u * v * w, usStore, rvCol, pmCol, 'un', 0);

U = zeros(length(qd), length(qt));
for iu = 1:length(ucell)
    
    U = U + ucell{iu};
    
end

enm = norm(U, 'fro') / norm(fixie.dis.qoi.trial, 'fro');