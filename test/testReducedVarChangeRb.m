phi = canti.phi.val;
mas = canti.mas.mtx;
dam = canti.dam.mtx;
sti1 = canti.sti.mtxCell{1};
sti2 = canti.sti.mtxCell{2};
sti3 = canti.sti.mtxCell{3};
fce = canti.fce.val;
pm1 = canti.pmVal.iter{1};
pm2 = canti.pmVal.iter{2};
pm3 = canti.pmVal.iter{3};
nr = size(phi, 2);

sti = sti1 * pm1 + sti2 * pm2 + sti3 * pm3;

masr = phi' * mas * phi;
damr = phi' * dam * phi;
stir = phi' * sti * phi;
fcer = phi' * fce;

u0 = zeros(nr, 1);
v0 = zeros(nr, 1);

acce = 'average';
[ur, vr, ar, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, masr, damr, stir, fcer, acce, canti.time.step, canti.time.max, u0, v0);


u01 = zeros(1, 1);
v01 = zeros(1, 1);

ursingle = [];
vrsingle = [];
arsingle = [];
for i = 1:nr
    
    phii = phi(:, i);
    masri = phii' * mas * phii;
    damri = phii' * dam * phii;
    stiri = phii' * sti * phii;
    fceri = phii' * fce;
    [uri, vri, ari, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phii, masri, damri, stiri, fceri, acce, canti.time.step, canti.time.max, u01, v01);
    ursingle = [ursingle; uri];
    vrsingle = [vrsingle; vri];
    arsingle = [arsingle; ari];
    
end


fcestatic = (1:12)';
fcerandr = phi' * fcestatic;
al = stir \ fcerandr;

al1 = stiri \ (phii' * fcestatic);