%% test case 1: use Newmark to test if trial solution is correct. 
% compare U with canti.dis.trial.

k = canti.sti.mtxCell{1} * canti.pmVal.I1.trial + ...
    canti.sti.mtxCell{2} * canti.pmVal.I2.trial + ...
    canti.sti.mtxCell{3} * canti.pmVal.s.fix;

m = canti.mas.mtx;

c = canti.dam.mtx;

f = canti.fce.val;

phi = eye(canti.no.dof);

dt = canti.time.step;

maxt = canti.time.max;

u0 = canti.dis.inpt;
v0 = canti.vel.inpt;

[~, ~, ~, u, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dt, maxt, u0, v0);

%% test case 2: [res, m, c, k(mu)] ---> e(mu) should == ue(mu) - ur(mu)
% pick sample point 2, 4, the 17th point for 5*5 grid.

kr = canti.sti.re.mtxCell{1} * canti.pmVal.iter{1} + ...
    canti.sti.re.mtxCell{2} * canti.pmVal.iter{2} + ...
    canti.sti.re.mtxCell{3} * canti.pmVal.iter{3};

mr = canti.mas.re.mtx;

cr = canti.dam.re.mtx;

fr = canti.phi.val' * canti.fce.val;

phir = eye(canti.no.rb);

u0r = canti.dis.re.inpt;
v0r = canti.vel.re.inpt;

[~, ~, ~, urval, vrval, arval, ~, ~] = NewmarkBetaReducedMethod...
    (phir, mr, cr, kr, fr, 'average', dt, maxt, u0r, v0r);

kiter = canti.sti.mtxCell{1} * canti.pmVal.iter{1} + ...
    canti.sti.mtxCell{2} * canti.pmVal.iter{2} + ...
    canti.sti.mtxCell{3} * canti.pmVal.iter{3};

r = canti.fce.val - canti.mas.mtx * canti.phi.val * arval - ...
    canti.dam.mtx * canti.phi.val * vrval - kiter * canti.phi.val * urval;

[~, ~, ~, e, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, kiter, r, 'average', dt, maxt, u0, v0);

[~, ~, ~, ue, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, kiter, f, 'average', dt, maxt, u0, v0);

ur = canti.phi.val * urval;

e1 = ue - ur;

erel = norm(e, 'fro') / norm(canti.dis.trial, 'fro');

erel1 = norm(e1, 'fro') / norm(canti.dis.trial, 'fro');