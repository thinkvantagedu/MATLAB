clear variables; clc;
format short
% RB: reduced basis.
% MP: magic point.
% PP: parameter point.
tic
% core_num = 4;
% pool = parpool(core_num);

addpath('/home/xiaohan/Desktop/Temp');
addpath('/home/xiaohan/Desktop/Temp/FE_model');
addpath('/home/xiaohan/Desktop/Temp/MATLAB');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/GSA');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/ABAQUS_MOR');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/Newmark Method');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/Lagrange Interpolation');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/OtherFunctions');

INPfilename = '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics.inp';
loc_string_start = 'nset=Set-lc';
loc_string_end = 'Elset, elset=Set-lc';
[cons] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
[node, elem] = ABAQUSReadINPGeo(INPfilename);
MTX_M.file = '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_MASS1.mtx';
MTX_K.file.I1120S0 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I11_I20_IS0_STIF1.mtx';
MTX_K.file.I1021S0 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I10_I21_IS0_STIF1.mtx';
MTX_K.file.I1020S1 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I10_I20_IS1_STIF1.mtx';

time.max = 10;
time.step = 0.1;
no.t_step = length((0:time.step:time.max));
no.incl = 3; %no of inclusions

fce.time = 4;
fce.period = 2*fce.time;
fce.node = 4;
fce.dof = 2*fce.node;
fce.val = sparse(2*length(node),  no.t_step);
fce.t = (0:time.step:fce.time);
fce.trigo = -sin((2*pi/fce.period)*fce.t);
fce.val(fce.dof, 1:length(fce.t)) = fce.val(fce.dof, 1:length(fce.t))+fce.trigo;
fce.fre.OR.all = ABAQUSDeleteBCRowsinMTX2DOF(fce.val, cons, node);

%%
domain.length.I1 = 30;
domain.length.I2 = 30;
domain.length.S = 30;
domain.bond.L.I1 = 1;
domain.bond.R.I1 = 2;
domain.bond.L.I2 = 1;
domain.bond.R.I2 = 2;
pm.fix.I3 = 1000;
[pm.space.I1, pm.space.I2, pm.space.comb, pm.mg.I1, pm.mg.I2] = ...
    GSAParameterSpace...
    (domain.length.I1, domain.length.I2, ...
    domain.bond.L.I1, domain.bond.R.I1, domain.bond.L.I2, domain.bond.R.I2);

MTX_M.bd.mtx = ABAQUSReadMTX2DOF(MTX_M.file);
MTX_M.fre.OR.all = ABAQUSDeleteBCinMTX2DOF(MTX_M.bd.mtx, cons, node);
MTX_K.bd.I1120S0 = ABAQUSReadMTX2DOF(MTX_K.file.I1120S0);
MTX_K.bd.I1021S0 = ABAQUSReadMTX2DOF(MTX_K.file.I1021S0);
MTX_K.bd.I1020S1 = ABAQUSReadMTX2DOF(MTX_K.file.I1020S1);
MTX_K.fre.OR.I1120S0 = ABAQUSDeleteBCinMTX2DOF(MTX_K.bd.I1120S0, cons, node);
MTX_K.fre.OR.I1021S0 = ABAQUSDeleteBCinMTX2DOF(MTX_K.bd.I1021S0, cons, node);
MTX_K.fre.OR.I1020S1 = ABAQUSDeleteBCinMTX2DOF(MTX_K.bd.I1020S1, cons, node);
clear 'MTX_K.bd.I1120S0';
clear 'MTX_K.bd.I1021S0';
clear 'MTX_K.bd.I1020S1';
NMcoeff = 'average';
phi.ident = eye(size(MTX_M.fre.OR.all, 1));
phi.ident = sparse(phi.ident);
%%
pm.trial.val = [15, 10];
pm.trial.idx = (pm.trial.val(2)-1)*domain.length.I1+pm.trial.val(1);
pm.trial.row = pm.space.comb(pm.trial.idx, :);
pm.trial.I1 = pm.trial.row(:, 3);
pm.trial.I2 = pm.trial.row(:, 4);
Dis.OR.inpt.trial.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
Vel.OR.inpt.trial.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
MTX_K.fre.OR.trial.exact = MTX_K.fre.OR.I1120S0*pm.trial.I1+MTX_K.fre.OR.I1021S0*pm.trial.I2+...
    MTX_K.fre.OR.I1020S1*pm.fix.I3;
MTX_C.fre.OR.all = sparse(length(MTX_K.fre.OR.trial.exact), length(MTX_K.fre.OR.trial.exact));
[~, ~, ~, Dis.OR.otpt.trial.exact, Vel.OR.otpt.trial.exact, Acc.OR.otpt.trial.exact, ~, ~] = ...
    NewmarkBetaReducedMethod...
    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.all, MTX_K.fre.OR.trial.exact, ...
    fce.fre.OR.all, NMcoeff, time.step, time.max, ...
    Dis.OR.inpt.trial.exact, Vel.OR.inpt.trial.exact);

%%
% find phi.fre.all (RB for MP).
Nphi.trial = 1;
ERR.store_lag = zeros(length(MTX_M.fre.OR.all), 1);
ERR.log.store_lag = zeros(length(MTX_M.fre.OR.all), 1);
sigma.store_lag = [];

ERR.val = 1;
while ERR.val>0.01
    
    [phi.fre.u, ~, sigma.val] = SVD(Dis.OR.otpt.trial.exact, Nphi.trial);
    [phi.fre.v, ~, sigma.val] = SVD(Vel.OR.otpt.trial.exact, Nphi.trial);
    [phi.fre.a, ~, sigma.val] = SVD(Acc.OR.otpt.trial.exact, Nphi.trial);
    MTX_M.fre.RE.trial.svd = phi.fre.a'*MTX_M.fre.OR.all*phi.fre.a;
    MTX_K.fre.RE.trial.svd = phi.fre.u'*MTX_K.fre.OR.trial.exact*phi.fre.u;
    MTX_C.fre.RE.trial.svd = sparse(length(MTX_K.fre.RE.trial.svd), ...
        length(MTX_K.fre.RE.trial.svd));
    fce.fre.RE.trial.svd = phi.fre.u'*fce.fre.OR.all;
    Dis.RE.inpt.trial.svd = sparse(Nphi.trial, 1);
    Vel.RE.inpt.trial.svd = sparse(Nphi.trial, 1);
    
    [~, ~, ~, Dis.OR.otpt.trial.svd, Vel.OR.otpt.trial.svd, Acc.OR.otpt.trial.svd, ~, ~] = ...
        NewmarkBetaReducedMethodAVUPhi...
        (phi.fre.a, phi.fre.v, phi.fre.u, MTX_M.fre.RE.trial.svd, MTX_C.fre.RE.trial.svd, MTX_K.fre.RE.trial.svd, ...
        fce.fre.RE.trial.svd, NMcoeff, time.step, time.max, ...
        Dis.RE.inpt.trial.svd, Vel.RE.inpt.trial.svd);
    
    ERR.val = abs((norm(Dis.OR.otpt.trial.exact-Dis.OR.otpt.trial.svd, 'fro'))/...
        norm(Dis.OR.otpt.trial.exact, 'fro'));
    %     ERR.log.val = log10(ERR.val);
    ERR.store_lag(Nphi.trial) = ERR.store_lag(Nphi.trial)+ERR.val;
    %     ERR.log.store_lag(Nphi.trial) = ERR.log.store_lag(Nphi.trial)+ERR.log.val;
    if Nphi.trial >= length(MTX_M.fre.OR.all)/2
        warning('size of phi exceed half of DOF number');
    elseif Nphi.trial >= length(MTX_M.fre.OR.all)
        error('size of phi exceed DOF number')
    end
    Nphi.trial = Nphi.trial+1;
    
end

sigma.store_lag=[sigma.store_lag; nonzeros(sigma.val)];
Nphi.trial=Nphi.trial-1;
%%
% error response surface for MP.
MTX_K.fre.RE.I1120S0 = phi.fre.u'*MTX_K.fre.OR.I1120S0*phi.fre.u;
MTX_K.fre.RE.I1021S0 = phi.fre.u'*MTX_K.fre.OR.I1021S0*phi.fre.u;
MTX_K.fre.RE.I1020S1 = phi.fre.u'*MTX_K.fre.OR.I1020S1*phi.fre.u;

MTX_M.fre.RE.trial.loop = phi.fre.a'*MTX_M.fre.OR.all*phi.fre.a;
MTX_C.fre.RE.trial.loop = sparse(length(MTX_M.fre.RE.trial.loop), length(MTX_M.fre.RE.trial.loop));

Dis.RE.inpt.trial.loop = sparse(length(MTX_M.fre.RE.trial.loop), 1);
Vel.RE.inpt.trial.loop = sparse(length(MTX_M.fre.RE.trial.loop), 1);

Dis.OR.inpt.trial.loop = sparse(length(MTX_M.fre.OR.all), 1);
Vel.OR.inpt.trial.loop = sparse(length(MTX_M.fre.OR.all), 1);

fce.fre.RE.trial.loop = phi.fre.u'*fce.fre.OR.all;

err.max.store_lag=[];
err.max.log_store=[];
err.loc.store_lag=[];
err.store.lag = zeros(domain.length.I1, domain.length.I2);
err.log.store_lag = zeros(domain.length.I1, domain.length.I2);
h = waitbar(0,'Wait');
steps=size(pm.space.comb, 1);
% each iteration computes one norm error.
for i_trial = 1:size(pm.space.comb, 1)
    waitbar(i_trial / steps)
    %%
    % compute approximation at trial point.
    %%{
    if i_trial == pm.trial.idx
        MTX_K.fre.RE.all.appr = MTX_K.fre.RE.I1120S0*pm.space.comb(i_trial, 3)+...
            MTX_K.fre.RE.I1021S0*pm.space.comb(i_trial, 4)+...
            MTX_K.fre.RE.I1020S1*pm.fix.I3;
        
        [Dis.RE.otpt.all.appr, Vel.RE.otpt.all.appr, Acc.RE.otpt.all.appr, ...
            Dis.OR.otpt.all.appr, Vel.OR.otpt.all.appr, Acc.OR.otpt.all.appr, ...
            time.fre.OR.otpt.trial0, time_cnt.fre.OR.otpt.trial0] = ...
            NewmarkBetaReducedMethodAVUPhi...
            (phi.fre.a, phi.fre.v, phi.fre.u, MTX_M.fre.RE.trial.loop, MTX_C.fre.RE.trial.loop, MTX_K.fre.RE.all.appr, ...
            fce.fre.RE.trial.loop, NMcoeff, time.step, time.max, ...
            Dis.RE.inpt.trial.loop, Vel.RE.inpt.trial.loop);
        
    end
    %}
    %%
    % compute alpha and ddot_alpha for each PP.
    MTX_K.fre.RE.trial.loop = MTX_K.fre.RE.I1120S0*pm.space.comb(i_trial, 3)+...
        MTX_K.fre.RE.I1021S0*pm.space.comb(i_trial, 4)+...
        MTX_K.fre.RE.I1020S1*pm.fix.I3;
    MTX_K.fre.OR.trial.loop = MTX_K.fre.OR.I1120S0*pm.space.comb(i_trial, 3)+...
        MTX_K.fre.OR.I1021S0*pm.space.comb(i_trial, 4)+...
        MTX_K.fre.OR.I1020S1*pm.fix.I3;
    
    [Dis.RE.otpt.trial.loop, Vel.RE.otpt.trial.loop, Acc.RE.otpt.trial.loop, ~, ~, ~, ~, ~] = ...
        NewmarkBetaReducedMethodAVUPhi...
        (phi.fre.a, phi.fre.v, phi.fre.u, MTX_M.fre.RE.trial.loop, MTX_C.fre.RE.trial.loop, MTX_K.fre.RE.trial.loop, ...
        fce.fre.RE.trial.loop, NMcoeff, time.step, time.max, ...
        Dis.RE.inpt.trial.loop, Vel.RE.inpt.trial.loop);
    %%
    % compute residual and corresponding error for each PP.err.max.val
    res.inpt = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.a*Acc.RE.otpt.trial.loop...
        -MTX_K.fre.OR.trial.loop*phi.fre.u*Dis.RE.otpt.trial.loop;
    
    [~, ~, ~, Dis.OR.otpt.trial.res, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.all, MTX_K.fre.OR.trial.loop, ...
        res.inpt, NMcoeff, time.step, time.max, ...
        Dis.OR.inpt.trial.loop, Vel.OR.inpt.trial.loop);
    
    err.val = norm(Dis.OR.otpt.trial.res, 'fro')/norm(Dis.OR.otpt.trial.exact, 'fro');
    err.store.lag(i_trial) = err.store.lag(i_trial)+err.val;
    err.log.store_lag(i_trial) = err.log.store_lag(i_trial)+log10(err.val);
    
    
end
close(h)
toc
%%
[err.max.val, err.loc.idx.max]=max(err.store.lag(:));
err.max.store_lag=[err.max.store_lag; err.max.val];
err.max.log_store=[err.max.log_store log10(err.max.val)];
pm.iter.row=pm.space.comb(err.loc.idx.max, :);
err.loc.val.max=pm.iter.row(:, 1:2);
err.loc.store_lag=[err.loc.store_lag; err.loc.val.max];

titl.err=sprintf('Error response surface, magic point = [%d %d]', ...
    pm.trial.val(1), pm.trial.val(2));
titl.log_err=sprintf('Log error response surface, magic point = [%d %d]', ...
    pm.trial.val(1), pm.trial.val(2));
%%
turnon = 0;
if turnon == 1
figure(1)
suptitle(titl.err)
subplot(3, 4, 1)
surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.lag');
xlabel('parameter 1', 'FontSize', 10)
ylabel('parameter 2', 'FontSize', 10)
zlabel('error', 'FontSize', 10)
set(gca,'fontsize',10)
axi.err=sprintf('');
axis([1 2 1 2])
axi.lim = [0 0.15];
% zlim(axi.lim)
axis square
view([120 30])
set(legend,'FontSize',8);
figure(2)
suptitle(titl.log_err)
subplot(3, 4, 1)
surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.store_lag');
xlabel('parameter 1', 'FontSize', 10)
ylabel('parameter 2', 'FontSize', 10)
zlabel('log error', 'FontSize', 10)
set(gca,'fontsize',10)
axis([1 2 1 2])
axi.log_lim = [-4 0];
% zlim(axi.log_lim)
axis square
view([120 30])
set(legend,'FontSize',8);
disp(err.max.val)
disp(err.loc.val.max)

end