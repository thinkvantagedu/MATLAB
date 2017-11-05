% clear variables; clc;
format short
% RB: reduced basis.
% MP: magic point.
% PP: parameter point.
tic
% core_num = 4;
% pool = parpool(core_num);

addpath('/home/xiaohan/Desktop/Temp');
addpath('/home/xiaohan/Desktop/Temp/MATLAB');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/ABAQUS_MOR');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/Newmark Method');

INPfilename = '/home/xiaohan/Desktop/Temp/L7H2_dynamics.inp';
loc_string_start = 'nset=Set-lc';
loc_string_end = 'End Assembly';
[cons] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
[node, elem] = ABAQUSReadINPGeo(INPfilename);
MTX_M.file = '/home/xiaohan/Desktop/Temp/L7H2_dynamics_MASS1.mtx';
MTX_K.file.I11_I20_IS0 = ...
    '/home/xiaohan/Desktop/Temp/L7H2_dynamics_matrices_I11_I20_IS0_STIF1.mtx';
MTX_K.file.I10_I21_IS0 = ...
    '/home/xiaohan/Desktop/Temp/L7H2_dynamics_matrices_I10_I21_IS0_STIF1.mtx';
MTX_K.file.I10_I20_IS1 = ...
    '/home/xiaohan/Desktop/Temp/L7H2_dynamics_matrices_I10_I20_IS1_STIF1.mtx';

time.max = 20;
time.step = 0.1;
time.no.step = length((0:time.step:time.max));
time.force = 2;

fce.node = 2;
fce.dof = 3*fce.node-1;
fce.val = sparse(3*length(node),  time.no.step);
fce.t = (time.step:time.step:time.force);
fce.trigo = -sin(pi/4*fce.t);
fce.val(fce.dof, 1:length(fce.t)) = fce.val(fce.dof, 1:length(fce.t))+fce.trigo;
fce.fre.OR.all = ABAQUSDeleteBCRowsinMTX(fce.val, cons, node);



%%
domain.length.I1 = 50;
domain.length.I2 = 50;
domain.length.S = 50;
domain.bond.L.I1 = -1;
domain.bond.R.I1 = 1;
domain.bond.L.I2 = -1;
domain.bond.R.I2 = 1;
pm.space.I1 = logspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1);
pm.space.I1 = [(1:length(pm.space.I1)); pm.space.I1];
pm.space.I2 = logspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2);
pm.space.I2 = [(1:length(pm.space.I2)); pm.space.I2];
pm.space.comb = combvec(pm.space.I1, pm.space.I2);
pm.space.comb = pm.space.comb';
pm.space.comb(:, [2, 3]) = pm.space.comb(:, [3, 2]);
pm.space.comb(:, 5) = (1:length(pm.space.comb));
pm.space.I1 = pm.space.I1';
pm.space.I2 = pm.space.I2';

MTX_M.bd.mtx = ABAQUSReadMTX(MTX_M.file);
MTX_M.fre.OR.all = ABAQUSDeleteBCinMTX(MTX_M.bd.mtx, cons, node);
MTX_K.bd.I11_I20_IS0 = ABAQUSReadMTX(MTX_K.file.I11_I20_IS0);
MTX_K.bd.I10_I21_IS0 = ABAQUSReadMTX(MTX_K.file.I10_I21_IS0);
MTX_K.bd.I10_I20_IS1 = ABAQUSReadMTX(MTX_K.file.I10_I20_IS1);
MTX_K.fre.OR.I11_I20_IS0 = ABAQUSDeleteBCinMTX(MTX_K.bd.I11_I20_IS0, cons, node);
MTX_K.fre.OR.I10_I21_IS0 = ABAQUSDeleteBCinMTX(MTX_K.bd.I10_I21_IS0, cons, node);
MTX_K.fre.OR.I10_I20_IS1 = ABAQUSDeleteBCinMTX(MTX_K.bd.I10_I20_IS1, cons, node);
clear 'MTX_K.bd.I11_I20_IS0';
clear 'MTX_K.bd.I10_I21_IS0';
clear 'MTX_K.bd.I10_I20_IS1';
NMcoeff = 'average';
phi.ident = eye(size(MTX_M.fre.OR.all, 1));
phi.ident = sparse(phi.ident);
%%
pm.trial.val = [50, 1];
pm.trial.idx = (pm.trial.val(2)-1)*domain.length.I1+pm.trial.val(1);
pm.trial.row = pm.space.comb(pm.trial.idx, :);
pm.trial.I1 = pm.trial.row(:, 3);
pm.trial.I2 = pm.trial.row(:, 4);
Dis.fre.OR.inpt.trial.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
Vel.fre.OR.inpt.trial.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
MTX_K.fre.OR.trial.exact = MTX_K.fre.OR.I11_I20_IS0*pm.trial.I1+MTX_K.fre.OR.I10_I21_IS0*pm.trial.I2+...
    MTX_K.fre.OR.I10_I20_IS1*0.01;
MTX_C.fre.OR.trial.exact = sparse(length(MTX_K.fre.OR.trial.exact), length(MTX_K.fre.OR.trial.exact));
[Dis.fre.OR.otpt.trial.exact, Vel.fre.OR.otpt.trial.exact, Acc.fre.OR.otpt.trial.exact, ...
    Dis.fre.OR.otpt.trial.exact, Vel.fre.OR.otpt.trial.exact, Acc.fre.OR.otpt.trial.exact, ...
    time.fre.OR.otpt.trial, time_cnt.fre.OR.otpt.trial] = ...
    NewmarkBetaReducedMethod...
    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.trial.exact, MTX_K.fre.OR.trial.exact, ...
    fce.fre.OR.all, NMcoeff, time.step, time.max, ...
    Dis.fre.OR.inpt.trial.exact, Vel.fre.OR.inpt.trial.exact);
%%
% find phi.fre.all (RB for MP).
Nphi.trial = 1;
ERR.store_lag = zeros(length(MTX_M.fre.OR.all), 1);
ERR.log.store_lag = zeros(length(MTX_M.fre.OR.all), 1);
sigma.store_lag = [];

ERR.val = 1;
while ERR.val>1e-3
    
    [phi.fre.all, ~, sigma.val] = SVD(Dis.fre.OR.otpt.trial.exact, Nphi.trial);
    MTX_M.fre.RE.trial.svd = phi.fre.all'*MTX_M.fre.OR.all*phi.fre.all;
    MTX_K.fre.RE.trial.svd = phi.fre.all'*MTX_K.fre.OR.trial.exact*phi.fre.all;
    MTX_C.fre.RE.trial.svd = sparse(length(MTX_K.fre.RE.trial.svd), ...
        length(MTX_K.fre.RE.trial.svd));
    fce.fre.RE.trial.svd = phi.fre.all'*fce.fre.OR.all;
    Dis.fre.RE.inpt.trial.svd = sparse(Nphi.trial, 1);
    Vel.fre.RE.inpt.trial.svd = sparse(Nphi.trial, 1);
    
    [Dis.fre.RE.otpt.trial.svd, Vel.fre.RE.otpt.trial.svd, Acc.fre.OR.otpt.trial.svd, ...
        Dis.fre.OR.otpt.trial.svd, Vel.fre.OR.otpt.trial.svd, Acc.fre.OR.otpt.trial.svd, ...
        time.fre.OR.otpt.svd, time_cnt.fre.OR.otpt.svd] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.fre.RE.trial.svd, MTX_C.fre.RE.trial.svd, MTX_K.fre.RE.trial.svd, ...
        fce.fre.RE.trial.svd, NMcoeff, time.step, time.max, ...
        Dis.fre.RE.inpt.trial.svd, Vel.fre.RE.inpt.trial.svd);
    ERR.val = abs((norm(Dis.fre.OR.otpt.trial.exact-Dis.fre.OR.otpt.trial.svd, 'fro'))/...
        norm(Dis.fre.OR.otpt.trial.exact, 'fro'));
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
MTX_K.fre.RE.I11_I20_IS0 = phi.fre.all'*MTX_K.fre.OR.I11_I20_IS0*phi.fre.all;
MTX_K.fre.RE.I10_I21_IS0 = phi.fre.all'*MTX_K.fre.OR.I10_I21_IS0*phi.fre.all;
MTX_K.fre.RE.I10_I20_IS1 = phi.fre.all'*MTX_K.fre.OR.I10_I20_IS1*phi.fre.all;

MTX_M.fre.RE.trial.loop = phi.fre.all'*MTX_M.fre.OR.all*phi.fre.all;
MTX_C.fre.RE.trial.loop = sparse(length(MTX_M.fre.RE.trial.loop), length(MTX_M.fre.RE.trial.loop));

MTX_C.fre.OR.trial.loop = sparse(length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
Dis.fre.RE.inpt.trial.loop = sparse(length(MTX_M.fre.RE.trial.loop), 1);
Vel.fre.RE.inpt.trial.loop = sparse(length(MTX_M.fre.RE.trial.loop), 1);

Dis.fre.OR.inpt.trial.loop = sparse(length(MTX_M.fre.OR.all), 1);
Vel.fre.OR.inpt.trial.loop = sparse(length(MTX_M.fre.OR.all), 1);

fce.fre.RE.trial.loop = phi.fre.all'*fce.fre.OR.all;

err.max.store_lag=[];
err.max.log_store=[];
err.loc.store_lag=[];
err.store_lag = zeros(domain.length.I1, domain.length.I2);
err.log.store_lag = zeros(domain.length.I1, domain.length.I2);
h = waitbar(0,'Please wait when iterations being processed...');
steps=size(pm.space.comb, 1);
% each iteration computes one norm error.
for i_trial = 1:size(pm.space.comb, 1)
    waitbar(i_trial / steps)
    %%
    % compute approximation at trial point.
    %%{
    if i_trial == pm.trial.idx
        MTX_K.fre.RE.all.appr = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(i_trial, 3)+...
            MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(i_trial, 4)+...
            MTX_K.fre.RE.I10_I20_IS1*0.01;
        
        [Dis.fre.RE.otpt.all.appr, Vel.fre.RE.otpt.all.appr, Acc.fre.RE.otpt.all.appr, ...
            Dis.fre.OR.otpt.all.appr, Vel.fre.OR.otpt.all.appr, Acc.fre.OR.otpt.all.appr, ...
            time.fre.OR.otpt.trial0, time_cnt.fre.OR.otpt.trial0] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.fre.RE.trial.loop, MTX_C.fre.RE.trial.loop, MTX_K.fre.RE.all.appr, ...
            fce.fre.RE.trial.loop, NMcoeff, time.step, time.max, ...
            Dis.fre.RE.inpt.trial.loop, Vel.fre.RE.inpt.trial.loop);
        
    end
    %}
    %%
    % compute alpha and ddot_alpha for each PP.
    MTX_K.fre.RE.trial.loop = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(i_trial, 3)+...
        MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(i_trial, 4)+...
        MTX_K.fre.RE.I10_I20_IS1*0.01;
    MTX_K.fre.OR.trial.loop = MTX_K.fre.OR.I11_I20_IS0*pm.space.comb(i_trial, 3)+...
        MTX_K.fre.OR.I10_I21_IS0*pm.space.comb(i_trial, 4)+...
        MTX_K.fre.OR.I10_I20_IS1*0.01;
    
    [Dis.fre.RE.otpt.trial.loop, Vel.fre.RE.otpt.trial.loop, Acc.fre.RE.otpt.trial.loop, ...
        Dis.fre.OR.otpt.trial.loop, Vel.fre.OR.otpt.trial.loop, Acc.fre.OR.otpt.trial.loop, ...
        time.fre.OR.otpt.iter_trial, time_cnt.fre.OR.otpt.iter_trial] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.fre.RE.trial.loop, MTX_C.fre.RE.trial.loop, MTX_K.fre.RE.trial.loop, ...
        fce.fre.RE.trial.loop, NMcoeff, time.step, time.max, ...
        Dis.fre.RE.inpt.trial.loop, Vel.fre.RE.inpt.trial.loop);
    %%
    % compute residual and corresponding error for each PP.
    res_store.inpt = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.trial.loop...
        -MTX_K.fre.OR.trial.loop*phi.fre.all*Dis.fre.RE.otpt.trial.loop;
    
    [Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
        Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
        time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
        NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.trial.loop, MTX_K.fre.OR.trial.loop, ...
        res_store.inpt, NMcoeff, time.step, time.max, ...
        Dis.fre.OR.inpt.trial.loop, Vel.fre.OR.inpt.trial.loop);
    
    err.val = norm(Dis.fre.OR.otpt.trial.res, 'fro')/norm(Dis.fre.OR.otpt.trial.exact, 'fro');
    err.store_lag(i_trial) = err.store_lag(i_trial)+err.val;
    err.log.store_lag(i_trial) = err.log.store_lag(i_trial)+log10(err.val);
    
    
end
close(h)
toc
%%
[err.max.val, err.loc.idx.max]=max(err.store_lag(:));
err.max.store_lag=[err.max.store_lag; err.max.val];
err.max.log_store=[err.max.log_store log10(err.max.val)];
pm.iter.row=pm.space.comb(err.loc.idx.max, :);
err.loc.val.max=pm.iter.row(:, 1:2);
err.loc.store_lag=[err.loc.store_lag; err.loc.val.max];
titl.err=sprintf('Error response surface, magic point = [%d %d]', ...
    pm.trial.val(1), pm.trial.val(2));
titl.log_err=sprintf('Log error response surface, magic point = [%d %d]', ...
    pm.trial.val(1), pm.trial.val(2));
a=0;
if a==1
figure(1)
suptitle(titl.err)
subplot(3, 4, 1)
surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store_lag');
xlabel('parameter 1', 'FontSize', 10)
ylabel('parameter 2', 'FontSize', 10)
zlabel('error', 'FontSize', 10)
set(gca,'fontsize',10)
axi.err=sprintf('');
axis([-1 1 -1 1])
axi.lim = [0 0.15];
zlim(axi.lim)
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
axis([-1 1 -1 1])
axi.log_lim = [-4 0];
zlim(axi.log_lim)
axis square
view([120 30])
set(legend,'FontSize',8);
disp(err.max.val)
disp(err.loc.val.max)
end
%%
i_cnt=1;
err.match = abs(err.max.val);
err.bd=0.01;
gamma = 1/2; beta = 1/4;
a1 = gamma/(beta*time.step);
a2 = 1/(beta*time.step^2);
lag.order = 'linear';
switch lag.order
    case 'linear'
        % 4 corner points:
        pm.int.num = 4;
        %         pm.int.scale = length(pm.space.I1)/sqrt(pm.int.num);
        %         for i_lag_ord = 1:sqrt(pm.int.num)
        %             for j_lag_ord = 1:sqrt(pm.int.num)
        %             pm.int.pre = [pm.int.pre; [pm.space.I1(i_lag_ord, :) pm.sapce.I2(j_lag_ord, :)]];
        %
        %             end
        %         end
        pm.int.pre.rect = [pm.space.comb(1, :); pm.space.comb(50, :); pm.space.comb(2451, :); pm.space.comb(2500, :)];
        pm.int.pre.lu = [pm.space.comb(1, :); pm.space.comb(25, :); pm.space.comb(1201, :); pm.space.comb(1225, :)];
        pm.int.pre.ru = [pm.space.comb(25, :); pm.space.comb(50, :); pm.space.comb(1225, :); pm.space.comb(1250, :)];
        pm.int.pre.ld = [pm.space.comb(1201, :); pm.space.comb(1225, :); pm.space.comb(2451, :); pm.space.comb(2475, :)];
        pm.int.pre.rd = [pm.space.comb(1225, :); pm.space.comb(1250, :); pm.space.comb(2475, :); pm.space.comb(2500, :)];
    case 'quadratic6'
        % bad condition number
        pm.int.num = 6;
        pm.int.pre = [pm.space.comb(1, :); pm.space.comb(50, :); pm.space.comb(1201, :);...
            pm.space.comb(1250, :); pm.space.comb(2451, :); pm.space.comb(2500, :)];
        
    case 'quadratic8'
        pm.int.num = 8;
        pm.int.pre = [pm.space.comb(1, :); pm.space.comb(25, :); pm.space.comb(50, :); pm.space.comb(1201, :); ...
            pm.space.comb(1250, :); pm.space.comb(2451, :); pm.space.comb(2475, :); ...
            pm.space.comb(2500, :)];
        
    case 'quadratic9'
        pm.int.num = 9;
        pm.int.pre.rect = [pm.space.comb(1, :); pm.space.comb(25, :); pm.space.comb(50, :); pm.space.comb(1201, :); ...
            pm.space.comb(1225, :); pm.space.comb(1250, :); pm.space.comb(2451, :); pm.space.comb(2475, :); ...
            pm.space.comb(2500, :)];
        pm.int.pre.lu = [pm.space.comb(1, :); pm.space.comb(13, :); pm.space.comb(25, :); pm.space.comb(601, :); ...
            pm.space.comb(613, :); pm.space.comb(625, :); pm.space.comb(1201, :); pm.space.comb(1213, :); ...
            pm.space.comb(1225, :)];
        pm.int.pre.ru = [pm.space.comb(25, :); pm.space.comb(37, :); pm.space.comb(50, :); pm.space.comb(625, :); ...
            pm.space.comb(637, :); pm.space.comb(650, :); pm.space.comb(1225, :); pm.space.comb(1237, :); ...
            pm.space.comb(1250, :)];
        pm.int.pre.ld = [pm.space.comb(1201, :); pm.space.comb(1213, :); pm.space.comb(1225, :); pm.space.comb(1801, :); ...
            pm.space.comb(1813, :); pm.space.comb(1825, :); pm.space.comb(2451, :); pm.space.comb(2463, :); ...
            pm.space.comb(2475, :)];
        pm.int.pre.rd = [pm.space.comb(1225, :); pm.space.comb(1237, :); pm.space.comb(1250, :); pm.space.comb(1825, :); ...
            pm.space.comb(1837, :); pm.space.comb(1850, :); pm.space.comb(2475, :); pm.space.comb(2487, :); ...
            pm.space.comb(2500, :)];
        
end
MTX.hat.ori_asmbl.rect = zeros(pm.int.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.lu = zeros(pm.int.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.ru = zeros(pm.int.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.ld = zeros(pm.int.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
MTX.hat.ori_asmbl.rd = zeros(pm.int.num*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
a=0;

for i_hat = 1:pm.int.num
    if a==0
        
        MTX_K.fre.OR.iter.hat =  MTX_K.fre.OR.I11_I20_IS0*pm.int.pre.rect(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.int.pre.rect(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        
        MTX.hat.ori = MTX_K.fre.OR.iter.hat+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        
        MTX.hat.inv = inv(MTX.hat.ori);
        
        MTX.hat.ori_asmbl.rect((i_hat*length(MTX.hat.ori)-length(MTX.hat.ori)+1):i_hat*length(MTX.hat.ori), :)...
            = MTX.hat.ori_asmbl.rect((i_hat*length(MTX.hat.ori)-length(MTX.hat.ori)+1):i_hat*length(MTX.hat.ori), :)...
            +MTX.hat.inv;
        
    elseif a==1
        MTX_K.fre.OR.iter.hat.lu =  MTX_K.fre.OR.I11_I20_IS0*pm.int.pre.lu(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.int.pre.lu(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.lu = MTX_K.fre.OR.iter.hat.lu+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.lu = inv(MTX.hat.ori.lu);
        MTX.hat.ori_asmbl.lu((i_hat*length(MTX.hat.ori.lu)-length(MTX.hat.ori.lu)+1):i_hat*length(MTX.hat.ori.lu), :)...
            = MTX.hat.ori_asmbl.lu((i_hat*length(MTX.hat.ori.lu)-length(MTX.hat.ori.lu)+1):i_hat*length(MTX.hat.ori.lu), :)...
            +MTX.hat.inv.lu;
        
        MTX_K.fre.OR.iter.hat.ru =  MTX_K.fre.OR.I11_I20_IS0*pm.int.pre.ru(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.int.pre.ru(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.ru = MTX_K.fre.OR.iter.hat.ru+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.ru = inv(MTX.hat.ori.ru);
        MTX.hat.ori_asmbl.ru((i_hat*length(MTX.hat.ori.ru)-length(MTX.hat.ori.ru)+1):i_hat*length(MTX.hat.ori.ru), :)...
            = MTX.hat.ori_asmbl.ru((i_hat*length(MTX.hat.ori.ru)-length(MTX.hat.ori.ru)+1):i_hat*length(MTX.hat.ori.ru), :)...
            +MTX.hat.inv.ru;
        
        MTX_K.fre.OR.iter.hat.ld =  MTX_K.fre.OR.I11_I20_IS0*pm.int.pre.ld(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.int.pre.ld(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.ld = MTX_K.fre.OR.iter.hat.ld+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.ld = inv(MTX.hat.ori.ld);
        MTX.hat.ori_asmbl.ld((i_hat*length(MTX.hat.ori.ld)-length(MTX.hat.ori.ld)+1):i_hat*length(MTX.hat.ori.ld), :)...
            = MTX.hat.ori_asmbl.ld((i_hat*length(MTX.hat.ori.ld)-length(MTX.hat.ori.ld)+1):i_hat*length(MTX.hat.ori.ld), :)...
            +MTX.hat.inv.ld;
        
        MTX_K.fre.OR.iter.hat.rd =  MTX_K.fre.OR.I11_I20_IS0*pm.int.pre.rd(i_hat, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.int.pre.rd(i_hat, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        MTX.hat.ori.rd = MTX_K.fre.OR.iter.hat.rd+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
        MTX.hat.inv.rd = inv(MTX.hat.ori.rd);
        MTX.hat.ori_asmbl.rd((i_hat*length(MTX.hat.ori.rd)-length(MTX.hat.ori.rd)+1):i_hat*length(MTX.hat.ori.rd), :)...
            = MTX.hat.ori_asmbl.rd((i_hat*length(MTX.hat.ori.rd)-length(MTX.hat.ori.rd)+1):i_hat*length(MTX.hat.ori.rd), :)...
            +MTX.hat.inv.rd;
    end
end

% while err.match > err.bd 
    %%
    % compute the next exact solution.
    
    pm.iter.I1 = pm.space.I1(err.loc.val.max(1, 1));
    pm.iter.I2 = pm.space.I2(err.loc.val.max(1, 2));
    
    Dis.fre.OR.inpt.iter.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
    Vel.fre.OR.inpt.iter.exact = sparse(size(MTX_M.fre.OR.all, 1), 1);
    MTX_K.fre.OR.iter.exact = MTX_K.fre.OR.I11_I20_IS0*pm.iter.I1+...
        MTX_K.fre.OR.I10_I21_IS0*pm.iter.I2+...
        MTX_K.fre.OR.I10_I20_IS1*0.01;
    MTX_C.fre.OR.iter.exact = sparse(length(MTX_K.fre.OR.iter.exact), ...
        length(MTX_K.fre.OR.iter.exact));
    [~, ~, ~, Dis.fre.OR.otpt.iter.exact, Vel.fre.OR.otpt.iter.exact, Acc.fre.OR.otpt.iter.exact, ...
        time.fre.OR.otpt.iter, time_cnt.fre.OR.otpt.iter] = ...
        NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.exact, MTX_K.fre.OR.iter.exact, ...
        fce.fre.OR.all, NMcoeff, time.step, time.max, ...
        Dis.fre.OR.inpt.iter.exact, Vel.fre.OR.inpt.iter.exact);
    
    %%
    % compute new phi
    
    %%
    % works well
    % ERROR = current exact solution - previous approximation.
    ERR.iter.store_lag = Dis.fre.OR.otpt.iter.exact-Dis.fre.OR.otpt.all.appr;
    Nphi.iter = 2;
    [phi.fre.ERR, ~, sigma.val] = SVD(ERR.iter.store_lag, Nphi.iter);
    sigma.store_lag=[sigma.store_lag; nonzeros(sigma.val)];
    phi.fre.all = [phi.fre.all phi.fre.ERR];
    phi.fre.all = GramSchmidtNew(phi.fre.all);
    
    %%
    MTX_K.fre.RE.I11_I20_IS0 = phi.fre.all'*MTX_K.fre.OR.I11_I20_IS0*phi.fre.all;
    MTX_K.fre.RE.I10_I21_IS0 = phi.fre.all'*MTX_K.fre.OR.I10_I21_IS0*phi.fre.all;
    MTX_K.fre.RE.I10_I20_IS1 = phi.fre.all'*MTX_K.fre.OR.I10_I20_IS1*phi.fre.all;
    MTX_M.fre.RE.iter.loop = phi.fre.all'*MTX_M.fre.OR.all*phi.fre.all;
    MTX_C.fre.RE.iter.loop = sparse(length(MTX_M.fre.RE.iter.loop), ...
        length(MTX_M.fre.RE.iter.loop));
    
    MTX_C.fre.OR.iter.loop = sparse(length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
    Dis.fre.RE.inpt.iter.loop = sparse(length(MTX_M.fre.RE.iter.loop), 1);
    Vel.fre.RE.inpt.iter.loop = sparse(length(MTX_M.fre.RE.iter.loop), 1);
    Dis.fre.OR.inpt.iter.loop = sparse(length(MTX_M.fre.OR.all), 1);
    Vel.fre.OR.inpt.iter.loop = sparse(length(MTX_M.fre.OR.all), 1);
    fce.fre.RE.iter.loop = phi.fre.all'*fce.fre.OR.all;
    
    err.store_lag = zeros(domain.length.I1, domain.length.I2);
    err.log.store_lag = zeros(domain.length.I1, domain.length.I2);
    
    h = waitbar(0,'Please wait when iterations being processed...');
    
    for i_iter = 1:size(pm.space.comb, 1)
        waitbar(i_iter / steps)
        
        %%
        % compute alpha and ddot alpha for each PP.
        MTX_K.fre.RE.iter.loop = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(i_iter, 3)+...
            MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(i_iter, 4)+...
            MTX_K.fre.RE.I10_I20_IS1*0.01;
        MTX_K.fre.OR.iter.loop = MTX_K.fre.OR.I11_I20_IS0*pm.space.comb(i_iter, 3)+...
            MTX_K.fre.OR.I10_I21_IS0*pm.space.comb(i_iter, 4)+...
            MTX_K.fre.OR.I10_I20_IS1*0.01;
        
        [Dis.fre.RE.otpt.iter.loop, Vel.fre.RE.otpt.iter.loop, Acc.fre.RE.otpt.iter.loop, ...
            Dis.fre.OR.otpt.iter.loop, Vel.fre.OR.otpt.iter.loop, Acc.fre.OR.otpt.iter.loop, ...
            time.fre.OR.otpt.iter_iter, time_cnt.fre.OR.otpt.iter_iter] = ...
            NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.iter.loop, ...
            fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
            Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
        %%
        % compute residual and corresponding error for each PP.
        
        res_store.inpt = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.iter.loop...
            -MTX_K.fre.OR.iter.loop*phi.fre.all*Dis.fre.RE.otpt.iter.loop;
        pm.space.x = pm.space.comb(i_iter, 1);
        pm.space.y = pm.space.comb(i_iter, 2);
        if a==0
            pm.iter.intplt = pm.int.pre.rect(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.rect);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
        elseif a==1
            if 1<=pm.space.x&&pm.space.x<=25&&1<=pm.space.y&&pm.space.y<=25
                pm.iter.intplt = pm.int.pre.lu(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.lu);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            elseif 25<=pm.space.x&&pm.space.x<=50&&1<=pm.space.y&&pm.space.y<=25
                pm.iter.intplt = pm.int.pre.ru(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.ru);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            elseif 1<=pm.space.x&&pm.space.x<=25&&25<=pm.space.y&&pm.space.y<=50
                pm.iter.intplt = pm.int.pre.ld(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.ld);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            elseif 25<=pm.space.x&&pm.space.x<=50&&25<=pm.space.y&&pm.space.y<=50
                pm.iter.intplt = pm.int.pre.rd(:, 3:4);
                [coeff]=LagInterpolationCoeff(pm.iter.intplt, MTX.hat.ori_asmbl.rd);
                [MTX.hat.inv] = LagInterpolationOtptSingle(coeff, ...
                    pm.space.comb(i_iter, 3), pm.space.comb(i_iter, 4));
            end
            
        end

        [Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
            Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
            time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
            NewmarkBetaReducedMethodwithINVMTX...
            (phi.ident, MTX.hat.inv, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, MTX_K.fre.OR.iter.loop, ...
            res_store.inpt, NMcoeff, time.step, time.max, ...
            Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop, a1, a2);
        
        err.val = norm(Dis.fre.OR.otpt.trial.res, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
        err.store_lag(i_iter) = err.store_lag(i_iter)+err.val;
        err.log.store_lag(i_iter) = err.log.store_lag(i_iter)+log10(err.val);
        
        % adaptivity
%         if err.val > 0.15
%             
%             
%             
%         end
        
    end
    close(h)
    
    i_cnt=i_cnt+1;
    
    toc
    %%
    [err.max.val, err.loc.idx.max]=max(err.store_lag(:));
    pm.iter.row=pm.space.comb(err.loc.idx.max, :);
    err.loc.val.max=pm.iter.row(:, 1:2);
    err.loc.store_lag=[err.loc.store_lag; err.loc.val.max];
    MTX_K.fre.RE.all.appr = MTX_K.fre.RE.I11_I20_IS0*pm.space.comb(err.loc.idx.max, 3)+...
        MTX_K.fre.RE.I10_I21_IS0*pm.space.comb(err.loc.idx.max, 4)+...
        MTX_K.fre.RE.I10_I20_IS1*0.01;
    [Dis.fre.RE.otpt.all.appr, Vel.fre.RE.otpt.all.appr, Acc.fre.RE.otpt.all.appr, ...
        Dis.fre.OR.otpt.all.appr, Vel.fre.OR.otpt.all.appr, Acc.fre.OR.otpt.all.appr, ...
        time.fre.OR.otpt.trial0, time_cnt.fre.OR.otpt.trial0] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.fre.RE.iter.loop, MTX_C.fre.RE.iter.loop, MTX_K.fre.RE.all.appr, ...
        fce.fre.RE.iter.loop, NMcoeff, time.step, time.max, ...
        Dis.fre.RE.inpt.iter.loop, Vel.fre.RE.inpt.iter.loop);
    err.max.store_lag=[err.max.store_lag; err.max.val];
    err.max.log_store=[err.max.log_store log10(err.max.val)];
    a=0;
    if a==1
    figure(1)
    subplot(3, 4, i_cnt)
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store_lag');
    xlabel('parameter 1', 'FontSize', 10)
    ylabel('parameter 2', 'FontSize', 10)
    zlabel('error', 'FontSize', 10)
    set(gca,'fontsize',10)
    axis([-1 1 -1 1])
    zlim(axi.lim)
    axis square
    view([120 30])
    set(legend,'FontSize',8);
    
    figure(2)
    subplot(3, 4, i_cnt)
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.store_lag');
    xlabel('parameter 1', 'FontSize', 10)
    ylabel('parameter 2', 'FontSize', 10)
    zlabel('log error', 'FontSize', 10)
    set(gca,'fontsize',10)
    axis([-1 1 -1 1])
    zlim(axi.log_lim)
    axis square
    view([120 30])
    set(legend,'FontSize',8);
    disp(err.max.val)
    disp(err.loc.val.max)
    disp(i_cnt)
    end
%     if i_cnt>=12
%         disp('iterations reach maximum plot number')
%         break
%     end
% end
err.loc.store_lag=[err.loc.store_lag err.max.store_lag];