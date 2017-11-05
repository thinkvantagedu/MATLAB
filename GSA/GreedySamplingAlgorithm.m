% clear variables; clc;
format short
% RB: reduced basis.
% MP: magic point.
% PP: parameter point.
tic
% core_num = 4;
% pool = parpool(core_num);
os = 'linux';
inp = 'L7H2';
switch os
    case 'linux'
        addpath('/home/xiaohan/Desktop/Temp');
        addpath('/home/xiaohan/Desktop/Temp/MATLAB');
        addpath('/home/xiaohan/Desktop/Temp/MATLAB/ABAQUS_MOR');
        addpath('/home/xiaohan/Desktop/Temp/MATLAB/Newmark Method');
        
        switch inp
            
            case 'L7H2'
                
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
                
            case 'airfoil_vcs'
                
                INPfilename='/home/xiaohan/Desktop/Temp/3D models/airfoil_vcs.inp';
                loc_string_start = 'Nset, nset=Set-rc';
                loc_string_end='Elset, elset=Set-rc';
                [cons] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
                [node, elem] = ABAQUSReadINPGeo(INPfilename);
                elem = sparse(elem);
                MTX_M.file = '/home/xiaohan/Desktop/Temp/3D models/airfoil_vcs_MTX_MASS1.mtx';
                MTX_K.file.I11_I20_IS0 = ...
                    '/home/xiaohan/Desktop/Temp/3D models/airfoil_vcs_MTX_I11_I20_IS0_STIF1.mtx';
                MTX_K.file.I10_I21_IS0 = ...
                    '/home/xiaohan/Desktop/Temp/3D models/airfoil_vcs_MTX_I10_I21_IS0_STIF1.mtx';
                MTX_K.file.I10_I20_IS1 = ...
                    '/home/xiaohan/Desktop/Temp/3D models/airfoil_vcs_MTX_I10_I20_IS1_STIF1.mtx';
                
                time.max = 20;
                time.step = 0.1;
                time.no.step = length((0:time.step:time.max));
                time.force = 4;
                
                fce.node = 41;
                fce.dof = 3*fce.node-2;
                fce.val = sparse(3*length(node),  time.no.step);
                fce.t = (time.step:time.step:time.force);
                fce.trigo = -10*sin(pi/4*fce.t);
                fce.val(fce.dof, 1:length(fce.t)) = fce.val(fce.dof, 1:length(fce.t))+fce.trigo;
                fce.fre.OR.all = ABAQUSDeleteBCRowsinMTX(fce.val, cons, node);
                
                
                
                
        end
        
    case 'win'
        
        addpath('C:\Temp\MATLAB');
        addpath('C:\Temp\MATLAB\ABAQUS_MOR');
        addpath('C:\Temp\MATLAB\Newmark Method');
        
        switch inp
            
            case 'L7H2'
                
                INPfilename = 'C:\Temp\L7H2_dynamics.inp';
                loc_string_start = 'nset=Set-lc';
                loc_string_end = 'End Assembly';
                [cons] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
                [node, elem] = ABAQUSReadINPGeo(INPfilename);
                elem = sparse(elem);
                MTX_M.file = 'C:\Temp\L7H2_dynamics_MASS1.mtx';
                MTX_K.file.I11_I20_IS0 = 'C:\Temp\L7H2_dynamics_matrices_I11_I20_IS0_STIF1.mtx';
                MTX_K.file.I10_I21_IS0 = 'C:\Temp\L7H2_dynamics_matrices_I10_I21_IS0_STIF1.mtx';
                MTX_K.file.I10_I20_IS1 = 'C:\Temp\L7H2_dynamics_matrices_I10_I20_IS1_STIF1.mtx';
                
                time.max = 20;
                time.step = 0.1;
                time.no.step = length((0:time.step:time.max));
                time.force = 2;
                
                fce.node = 4;
                fce.dof = 3*fce.node-1;
                fce.val = sparse(3*length(node),  time.no.step);
                fce.t = (time.step:time.step:time.force);
                fce.trigo = -sin(pi/4*fce.t);
                fce.val(fce.dof, 1:length(fce.t)) = fce.val(fce.dof, 1:length(fce.t))+fce.trigo;
                fce.fre.OR.all = ABAQUSDeleteBCRowsinMTX(fce.val, cons, node);
                
            case 'airfoil_vcs'
                
                INPfilename='C:\Temp\3D models\airfoil_vcs.inp';
                loc_string_start = 'Nset, nset=Set-rc';
                loc_string_end='Elset, elset=Set-rc';
                [cons] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
                [node, elem] = ABAQUSReadINPGeo(INPfilename);
                elem = sparse(elem);
                MTX_M.file = 'C:\Temp\3D models\airfoil_vcs_MTX_MASS1.mtx';
                MTX_K.file.I11_I20_IS0 = 'C:\Temp\3D models\airfoil_vcs_MTX_I11_I20_IS0_STIF1.mtx';
                MTX_K.file.I10_I21_IS0 = 'C:\Temp\3D models\airfoil_vcs_MTX_I10_I21_IS0_STIF1.mtx';
                MTX_K.file.I10_I20_IS1 = 'C:\Temp\3D models\airfoil_vcs_MTX_I10_I20_IS1_STIF1.mtx';
                
                time.max = 20;
                time.step = 0.1;
                time.no.step = length((0:time.step:time.max));
                time.force = 4;
                
                fce.node = 41;
                fce.dof = 3*fce.node-2;
                fce.val = sparse(3*length(node),  time.no.step);
                fce.t = (time.step:time.step:time.force);
                fce.trigo = -10*sin(pi/4*fce.t);
                fce.val(fce.dof, 1:length(fce.t)) = fce.val(fce.dof, 1:length(fce.t))+fce.trigo;
                fce.fre.OR.all = ABAQUSDeleteBCRowsinMTX(fce.val, cons, node);
                
        end
        
end
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
% keyboard
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
% keyboard
%%
%%{
% find phi.fre.all (RB for MP).
Nphi.trial = 1;
ERR.store = zeros(length(MTX_M.fre.OR.all), 1);
ERR.log.store = zeros(length(MTX_M.fre.OR.all), 1);
sigma.store = [];
switch inp
    
    case 'airfoil_vcs'
        
        [~, ~, sigma.val] = SVD(Dis.fre.OR.otpt.trial.exact, Nphi.trial);
        sigma.lim = 0.9;
        [Nphi.trial] = SVDSigmaProp(sigma.val, sigma.lim);
        [phi.fre.all, ~, ~] = SVD(Dis.fre.OR.otpt.trial.exact, Nphi.trial);
        
    case 'L7H2'
        
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
            ERR.store(Nphi.trial) = ERR.store(Nphi.trial)+ERR.val;
            %     ERR.log.store(Nphi.trial) = ERR.log.store(Nphi.trial)+ERR.log.val;
            if Nphi.trial >= length(MTX_M.fre.OR.all)/2
                warning('size of phi exceed half of DOF number');
            elseif Nphi.trial >= length(MTX_M.fre.OR.all)
                error('size of phi exceed DOF number')
            end
            Nphi.trial = Nphi.trial+1;
            %             keyboard
        end
        sigma.store=[sigma.store; nonzeros(sigma.val)];
        Nphi.trial=Nphi.trial-1;
        
end
% keyboard
%%
%%{
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

err.max.store=[];
err.max.log_store=[];
err.loc.store=[];
err.store = zeros(domain.length.I1, domain.length.I2);
err.log.store = zeros(domain.length.I1, domain.length.I2);
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
    err.def = 'residual';
    switch err.def
        
        case 'residual'
            
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
            
        case 'displacement'
            
            [Dis.fre.OR.otpt.exact, Vel.fre.OR.otpt.exact, Acc.fre.OR.otpt.exact, ...
                Dis.fre.OR.otpt.exact, Vel.fre.OR.otpt.exact, Acc.fre.OR.otpt.exact, ...
                time.fre.OR.otpt.exact, time_cnt.fre.OR.otpt.exact] = ...
                NewmarkBetaReducedMethod...
                (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.trial.loop, MTX_K.fre.OR.trial.loop, ...
                fce.fre.OR.all, NMcoeff, time.step, time.max, ...
                Dis.fre.OR.inpt.trial.loop, Vel.fre.OR.inpt.trial.loop);
            
            err.test = Dis.fre.OR.otpt.exact-Dis.fre.OR.otpt.trial.loop;
            
            err.val = norm(err.test, 'fro')/norm(Dis.fre.OR.otpt.trial.exact, 'fro');
            
    end
    
    err.store(i_trial) = err.store(i_trial)+err.val;
    err.log.store(i_trial) = err.log.store(i_trial)+log10(err.val);
    
    %     keyboard
end
close(h)

toc
%%

axi.lim=[0 0.15];
axi.log_lim=[-4 0];

[err.max.val, err.loc.idx.max]=max(err.store(:));
err.max.store=[err.max.store; err.max.val];
err.max.log_store=[err.max.log_store log10(err.max.val)];
pm.iter.row=pm.space.comb(err.loc.idx.max, :);
err.loc.val.max=pm.iter.row(:, 1:2);
err.loc.store=[err.loc.store; err.loc.val.max];
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
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store');
xlabel('parameter 1', 'FontSize', 10)
ylabel('parameter 2', 'FontSize', 10)
zlabel('error', 'FontSize', 10)
set(gca,'fontsize',10)
axi.err=sprintf('');
axis([-1 1 -1 1])
zlim(axi.lim)
axis square
view([120 30])
set(legend,'FontSize',8);
%%
figure(2)
suptitle(titl.log_err)
subplot(3, 4, 1)
surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
    linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.store');
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
end
% keyboard
% ===========================================================================================
%%
i_cnt=1;

err.mtd='error';

% switch err.otpt
%     case 'exact'
err.match = abs(err.max.val);
err.bd=1e-4;
%     case 'residual'
%         err.match = abs(err.max.val);
%         err.bd=1;
%         gamma = 1/2; beta = 1/4;
%         a1 = gamma/(beta*time.step);
%         a2 = 1/(beta*time.step^2);
%         pm.corner = [pm.space.comb(1, :); pm.space.comb(50, :); pm.space.comb(2451, :); pm.space.comb(2500, :)];
%         lag.pre.ori = zeros(4*length(MTX_M.fre.OR.all), length(MTX_M.fre.OR.all));
%         for i_hat = 1:4
%
%             MTX_K.fre.OR.iter.hat =  MTX_K.fre.OR.I11_I20_IS0*pm.corner(i_hat, 3)+...
%                 MTX_K.fre.OR.I10_I21_IS0*pm.corner(i_hat, 4)+...
%                 MTX_K.fre.OR.I10_I20_IS1*0.01;
%
%             MTX.hat.ori = MTX_K.fre.OR.iter.hat+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
%
%             MTX.hat.inv = inv(MTX.hat.ori);
%
%             lag.pre.ori((i_hat*length(MTX.hat.ori)-length(MTX.hat.ori)+1):i_hat*length(MTX.hat.ori), :)...
%                 = lag.pre.ori((i_hat*length(MTX.hat.ori)-length(MTX.hat.ori)+1):i_hat*length(MTX.hat.ori), :)...
%                 +MTX.hat.inv;
%
%
%         end
%         %         MTX.hat.ori = MTX_K.fre.OR.trial.exact+a1*MTX_C.fre.OR.trial.loop+a2*MTX_M.fre.OR.all;
%         %         MTX.hat.inv = inv(MTX.hat.ori);
% end
% keyboard
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
    switch err.mtd
        
        case 'error_prev'
            MTX_M.fre.RE.iter.exact = phi.fre.all'*MTX_M.fre.OR.all*phi.fre.all;
            MTX_K.fre.RE.iter.exact = phi.fre.all'*MTX_K.fre.OR.iter.exact*phi.fre.all;
            MTX_C.fre.RE.iter.exact = sparse(length(MTX_K.fre.RE.iter.exact), ...
                length(MTX_K.fre.RE.iter.exact));
            fce.fre.RE.exact = phi.fre.all'*fce.fre.OR.all;
            Dis.fre.RE.inpt.iter.exact = sparse(size(MTX_M.fre.RE.iter.exact, 1), 1);
            Vel.fre.RE.inpt.iter.exact = Dis.fre.RE.inpt.iter.exact;
            [~, ~, ~, Dis.fre.RE.otpt.iter.exact, Vel.fre.RE.otpt.iter.exact, Acc.fre.RE.otpt.iter.exact, ...
                time.fre.RE.otpt.iter, time_cnt.fre.RE.otpt.iter] = ...
                NewmarkBetaReducedMethod...
                (phi.fre.all, MTX_M.fre.RE.iter.exact, MTX_C.fre.RE.iter.exact, MTX_K.fre.RE.iter.exact, ...
                fce.fre.RE.exact, NMcoeff, time.step, time.max, ...
                Dis.fre.RE.inpt.iter.exact, Vel.fre.RE.inpt.iter.exact);
            ERR.iter.store = Dis.fre.OR.otpt.iter.exact-Dis.fre.RE.otpt.iter.exact;
            Nphi.iter = 1;
            [phi.fre.ERR, ~, ~] = SVD(ERR.iter.store, Nphi.iter);
            phi.fre.all = [phi.fre.all phi.fre.ERR];
            
            phi.fre.all = GramSchmidtNew(phi.fre.all);
            
        case 'error'
            %%
            % works well
            % ERROR = current exact solution - previous approximation.
            ERR.iter.store = Dis.fre.OR.otpt.iter.exact-Dis.fre.OR.otpt.all.appr;
            Nphi.iter = 2;
            [phi.fre.ERR, ~, sigma.val] = SVD(ERR.iter.store, Nphi.iter);
            sigma.store=[sigma.store; nonzeros(sigma.val)];
            phi.fre.all = [phi.fre.all phi.fre.ERR];
            phi.fre.all = GramSchmidtNew(phi.fre.all);
            
        case 'phi_disp'
            %
            ERR.iter.store = [phi.fre.all Dis.fre.OR.otpt.iter.exact];
            Nphi.iter = 15;
            [phi.fre.all, ~, ~] = SVD(ERR.iter.store, Nphi.iter);
            
            %         case 'disp'
            %             %
            %             ERR.iter.store_0 = [Dis.fre.OR.otpt.trial.exact Dis.fre.OR.otpt.iter.exact];
            %             ERR.iter.store
            %             Nphi.iter = 10;
            %             [phi.fre.all, ~, ~] = SVD(ERR.iter.store, Nphi.iter);
            
    end
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
    
    err.store = zeros(domain.length.I1, domain.length.I2);
    err.log.store = zeros(domain.length.I1, domain.length.I2);
    
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
        err.def = 'residual';
        % error comes from residual.
        % error comes from displacement.
        switch err.def
            case 'residual'
                res_store.inpt = fce.fre.OR.all-MTX_M.fre.OR.all*phi.fre.all*Acc.fre.RE.otpt.iter.loop...
                    -MTX_K.fre.OR.iter.loop*phi.fre.all*Dis.fre.RE.otpt.iter.loop;
                
                [Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
                    Dis.fre.OR.otpt.trial.res, Vel.fre.OR.otpt.trial.res, Acc.fre.OR.otpt.trial.res, ...
                    time.fre.OR.otpt.err, time_cnt.fre.OR.otpt.err] = ...
                    NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, MTX_K.fre.OR.iter.loop, ...
                    res_store.inpt, NMcoeff, time.step, time.max, ...
                    Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop);
                
                err.val = norm(Dis.fre.OR.otpt.trial.res, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
                
            case 'displacement'
                [Dis.fre.OR.otpt.exact, Vel.fre.OR.otpt.exact, Acc.fre.OR.otpt.exact, ...
                    Dis.fre.OR.otpt.exact, Vel.fre.OR.otpt.exact, Acc.fre.OR.otpt.exact, ...
                    time.fre.OR.otpt.exact, time_cnt.fre.OR.otpt.exact] = ...
                    NewmarkBetaReducedMethod...
                    (phi.ident, MTX_M.fre.OR.all, MTX_C.fre.OR.iter.loop, MTX_K.fre.OR.iter.loop, ...
                    fce.fre.OR.all, NMcoeff, time.step, time.max, ...
                    Dis.fre.OR.inpt.iter.loop, Vel.fre.OR.inpt.iter.loop);
                
                err.test = Dis.fre.OR.otpt.exact-Dis.fre.OR.otpt.iter.loop;
                err.val = norm(err.test, 'fro')/norm(Dis.fre.OR.otpt.iter.exact, 'fro');
        end
        err.store(i_iter) = err.store(i_iter)+err.val;
        err.log.store(i_iter) = err.log.store(i_iter)+log10(err.val);
    end
    close(h)
    i_cnt=i_cnt+1;
    
    toc
    %%
    
    [err.max.val, err.loc.idx.max]=max(err.store(:));
    pm.iter.row=pm.space.comb(err.loc.idx.max, :);
    err.loc.val.max=pm.iter.row(:, 1:2);
    err.loc.store=[err.loc.store; err.loc.val.max];
    
    %%
    % compute approximation at max error point.
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
    %%
    err.max.store=[err.max.store; err.max.val];
    err.max.log_store=[err.max.log_store log10(err.max.val)];
    a=0;
    if a==1
    figure(1)
    subplot(3, 4, i_cnt)
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store');
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
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log.store');
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
% % end

err.loc.store=[err.loc.store err.max.store];

%%
% figure(3);
% GreedySamplingAlgorithmPlotDecay(err.max.store, err.max.log_store, pm.trial.val);

%%
% figure(4);
% GreedySamplingAlgorithmPlotSigma(sigma.store, pm.trial.val);