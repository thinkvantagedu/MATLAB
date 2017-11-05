clear variables; clc;
format long;

% core_num=4;

% pool=parpool(core_num);

%%
%%{
addpath('C:\Temp\MATLAB');
addpath('C:\Temp\MATLAB\ABAQUS_MOR');
filename.new='C:\Temp\trimed_textfile_gre.py';
filename.trim='C:\Temp\abaqusMacros_L7H2_dynamics.py';
% trim spaces in macros
delete(filename.new);
TrimString(filename.trim, filename.new);
% read macros into MATLAB as char
filename=filename.new;
textfile_py=char(importdata(filename, 's'));
% remove 'def' row in macros
str_rmv='def';
textfile_origin=textfile_py;
[textfile]=RemoveOneStringRowinText(textfile_origin, str_rmv);
% write text into file
ConnectionFile='C:\Temp\connection_gre.py';
WrittenFile=textfile;
delete(ConnectionFile);
[WrittenFile]=WriteTextIntoDisk(WrittenFile, ConnectionFile);
% define INP input and output
INPfilename='C:\Temp\L7H2_dynamics.inp';
FiletoBeInserted='C:\Temp\L7H2_dynamics.inp';
loc_string='nset=Set-lc';
% write EXPORTMATRIX in INP
[Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, FiletoBeInserted);
% extract geo info.
[cons]=ABAQUSReadINPCons(INPfilename, loc_string);
[node, elem]=ABAQUSReadINPGeo(INPfilename);
node_no=node(size(node, 1), 1);
% import INP.
[strtext]=DisplayText(INPfilename);
%}

%%
%%{
% define distance between '*Material, name=Material-I' and 'pm' (parameter).
pm_dist=4;
% find pm location I1.
Strtofind.I1='*Material, name=Material-I1';
[line_node.I1]=FindTextRowNO(INPfilename, Strtofind.I1);
elastic_pm.I1=str2num(strtext(line_node.I1(1)+pm_dist, :));
% pm in INP file has to be exactly the same as YoungsM!
YoungsM.I1=elastic_pm.I1(:, 1);
% find pm location I2.
Strtofind.I2='*Material, name=Material-I2';
[line_node.I2]=FindTextRowNO(INPfilename, Strtofind.I2);
elastic_pm.I2=str2num(strtext(line_node.I2(1)+pm_dist, :));
YoungsM.I2=elastic_pm.I2(:, 1);
% find pm location S.
Strtofind.S='*Material, name=Material-S';
[line_node.S]=FindTextRowNO(INPfilename, Strtofind.S);
elastic_pm.S=str2num(strtext(line_node.S(1)+pm_dist, :));
YoungsM.S=elastic_pm.S(:, 1);
%}

%%
%%{
% form pm domain (2D).
domainLength.I1=50;
domainLength.I2=50;
domainLength.S=50;
domainBondL.I1=-2;
domainBondR.I1=2;
domainBondL.I2=-3;
domainBondR.I2=3;
pm.I1=logspace(domainBondL.I1, domainBondR.I1, domainLength.I1);
pm.I2=logspace(domainBondL.I2, domainBondR.I2, domainLength.I2);
% repmat gengrate a vector with same value.
pm.S=repmat(domainLength.S, 1, domainLength.I1*domainLength.I2);
% combvec gives all combinations of vectors.
pm.comb=zeros(3, domainLength.I1*domainLength.I2);
pm.comb(1:2, :)=combvec(pm.I1, pm.I2);
pm.comb(3, :)=pm.S;
pm.comb=pm.comb';
%}

%%
%%{
% define trial point.
trial_NO=[1, 1];
if trial_NO(1, 1)>domainLength.I1||trial_NO(1, 2)>domainLength.I2
    error('trial point exceeds pm domain.')
end
pm_trial.I1=pm.I1(trial_NO(1, 1));
pm_trial.I2=pm.I2(trial_NO(1, 2));
pm_trial.S=pm.S(1);
Insert_E.I1=[YoungsM.I1; pm_trial.I1];
Insert_E.I2=[YoungsM.I2; pm_trial.I2];
Insert_E.S=[YoungsM.S; pm_trial.S];
str_E0.I1=num2str(Insert_E.I1, 6);% num2str(a, b), b defines precision.
str_E0.I2=num2str(Insert_E.I2, 6);
str_E0.S=num2str(Insert_E.S, 6);
%}

%%
%%(
% Initial iteration begins=================================================
% compute first solution.
time=20;
t_step=0.1;
iteratives=time/t_step;
ABA_t=0:t_step:time;
i_applied_E=1;
%     modify pm I1, 2, S
[strtext]=ModifyParameter(str_E0.I1, strtext, line_node.I1, pm_dist);
[strtext]=ModifyParameter(str_E0.I2, strtext, line_node.I2, pm_dist);
[strtext]=ModifyParameter(str_E0.S, strtext, line_node.S, pm_dist);
%     finalise the INP file.
ExistingFilename=strtext;
%     create INP in disk.
delete('C:\Temp\abaqus.rpt');
[ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeInserted);

system('abaqus cae noGUI=C:\Temp\connection_gre.py'); %#################################
[Cleared_INP]=ABAQUSClearFromINP(INPfilename, INPfilename);
[result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
%     rearrange result data, import as num row by row.
selected_rows_str=result_data(size(result_data, 1)-iteratives+1:size(result_data, 1), :);
%     transform str rows to num rows.
[selected_rows_num]=strrows2numrows(selected_rows_str, node_no);
% rearrange nums to U1, U2, UR3 in column matrix. t=0 row IS NOT INCLUDED!
[re_se_rows_num]=DisplacementRows2Cols(selected_rows_num, node_no);
%     store result columns in snap_storage
[snap_store]=StoreResultCols(re_se_rows_num, i_applied_E, iteratives);
% Initial iteration ends===================================================
% clear EXPORTMATRIX in INP for following use
[U_exact_ini]=ABAQUSDeleteBCRowsinMTX(snap_store, cons, node);

% create initial snapshot.
NPhi=21;
[X, Phi.iter, Sigma]=SVD(snap_store, NPhi);
Phi.iter_free=ABAQUSDeleteBCRowsinMTX(Phi.iter, cons, node);
%}

%%
%%{
% generate basic matrices, such as 01 K and M.
MTX_file_M.I10_I21='C:\Temp\L7H2_dynamics_matrices_I10_I21_MASS1.mtx';
MTX_file_K.I10_I21='C:\Temp\L7H2_dynamics_matrices_I10_I21_STIF1.mtx';
MTX_file_M.I11_I20='C:\Temp\L7H2_dynamics_matrices_I11_I20_MASS1.mtx';
MTX_file_K.I11_I20='C:\Temp\L7H2_dynamics_matrices_I11_I20_STIF1.mtx';
[MTX_M.I10_I21]=ABAQUSReadMTX(MTX_file_M.I10_I21);
[MTX_K.I10_I21]=ABAQUSReadMTX(MTX_file_K.I10_I21);
[MTX_M.I11_I20]=ABAQUSReadMTX(MTX_file_M.I11_I20);
[MTX_K.I11_I20]=ABAQUSReadMTX(MTX_file_K.I11_I20);
MTX_M_free.I10_I21=ABAQUSDeleteBCinMTX(MTX_M.I10_I21, cons, node);
MTX_K_free.I10_I21=ABAQUSDeleteBCinMTX(MTX_K.I10_I21, cons, node);
MTX_M_free.I11_I20=ABAQUSDeleteBCinMTX(MTX_M.I11_I20, cons, node);
MTX_K_free.I11_I20=ABAQUSDeleteBCinMTX(MTX_K.I11_I20, cons, node);
% project MTX_I10_I21 and MTX_I11_I20 using Phi_init_free.
MTX_M_free_R.I10_I21=Phi.iter_free'*MTX_M_free.I10_I21*Phi.iter_free;
MTX_K_free_R.I10_I21=Phi.iter_free'*MTX_K_free.I10_I21*Phi.iter_free;
MTX_M_free_R.I11_I20=Phi.iter_free'*MTX_M_free.I11_I20*Phi.iter_free;
MTX_K_free_R.I11_I20=Phi.iter_free'*MTX_K_free.I11_I20*Phi.iter_free;
% define nodal force matrix.
MaxT=20;
deltaT=0.1;
f_node=2;
f_dof=3*f_node-1;
force_t=4;
f_amp=zeros(3*length(node), MaxT/deltaT);
f_amp_t=(0:deltaT:force_t);
% half sine force.
f_amp_value=-sin(pi/4*f_amp_t);
f_amp(f_dof, 1:length(f_amp_t))=f_amp(f_dof, 1:length(f_amp_t))+f_amp_value;
f_amp_free=ABAQUSDeleteBCRowsinMTX(f_amp, cons, node);
f_amp_free_R=Phi.iter_free'*f_amp_free;
% extract hat matrices.
% MTX_file_AHat.M='C:\Temp\L7H2_dynamics_MASS1.mtx';
% MTX_file_AHat.K='C:\Temp\L7H2_dynamics_STIF1.mtx';
% [MTX_AHat.M]=ABAQUSReadMTX(MTX_file_AHat.M);
% [MTX_AHat.K]=ABAQUSReadMTX(MTX_file_AHat.K);
% MTX_AHat_free.M=ABAQUSDeleteBCinMTX(MTX_AHat.M, cons, node);
% MTX_AHat_free.K=ABAQUSDeleteBCinMTX(MTX_AHat.K, cons, node);
% MTX_AHat_free.C=zeros(length(MTX_AHat_free.M));
id_phi=eye(length(MTX_M_free.I10_I21));
acce='average';
err_store=zeros(length(pm.I1), length(pm.I2));
err_store_log=zeros(length(pm.I1), length(pm.I2));
res_store=zeros(length(pm.I1), length(pm.I2));
resfr_store=zeros(length(pm.I1), length(pm.I2));
%}

%%
%{
% set the coefficients.
al=1/4; delta=1/2;
a0=1/(al*deltaT^2);
a1=delta/(al*deltaT);
a2=1/(al*deltaT);
a3=1/(2*al)-1;
a4=delta/al-1;
a5=deltaT/2*(delta/al-2);
a6=deltaT*(1-delta);
a7=delta*deltaT;
MTX_hat=MTX_AHat_free.K+a0*MTX_AHat_free.M+a1*MTX_AHat_free.C;
inv_MTX_hat=inv(MTX_hat);
%}

%%
%%{
% main loop for initial iteration.
tic
MTX_file_iter.M='C:\Temp\L7H2_dynamics_MASS1.mtx';
MTX_file_iter.K='C:\Temp\L7H2_dynamics_STIF1.mtx';
[MTX_iter.M]=ABAQUSReadMTX(MTX_file_iter.M);
[MTX_iter.K]=ABAQUSReadMTX(MTX_file_iter.K);
MTX_iter_free.M=ABAQUSDeleteBCinMTX(MTX_iter.M, cons, node);
MTX_iter_free.K=ABAQUSDeleteBCinMTX(MTX_iter.K, cons, node);
MTX_iter_free.C=zeros(length(MTX_iter_free.M));
U0_iter=zeros(size(MTX_iter_free.M, 1), 1);
V0_iter=zeros(size(MTX_iter_free.M, 1), 1);
A0_iter=zeros(size(MTX_iter_free.M, 1), 1);
i_cnt_iter=1;
for i_ini=1:size(pm.comb, 1)
    
    % first sample point:
    M_ini_R=MTX_M_free_R.I11_I20*0.01+MTX_M_free_R.I10_I21*0.01;
    K_ini_R=MTX_K_free_R.I11_I20*pm.comb(i_ini, 1)+MTX_K_free_R.I10_I21*pm.comb(i_ini, 2);
    C_ini_R=zeros(length(M_ini_R));
    
    M_ini=MTX_M_free.I11_I20*0.01+MTX_M_free.I10_I21*0.01;
    K_ini=MTX_K_free.I11_I20*pm.comb(i_ini, 1)+MTX_K_free.I10_I21*pm.comb(i_ini, 2);
    C_ini=zeros(length(M_ini));
    
    U0_ini_R=zeros(size(M_ini_R, 1), 1);
    V0_ini_R=zeros(size(M_ini_R, 1), 1);
    A0_ini_R=zeros(size(M_ini_R, 1), 1);
    
    U0_ini=zeros(size(M_ini, 1), 1);
    V0_ini=zeros(size(M_ini, 1), 1);
    A0_ini=zeros(size(M_ini, 1), 1);
    
    [U_ini_R, V_ini_R, A_ini_R, U_ini, V_ini, A_ini, t_ini, time_step_NO_ini]=...
        NewmarkBetaReducedMethod...
        (Phi.iter_free, M_ini_R, C_ini_R, K_ini_R, ...
        f_amp_free_R, acce, deltaT, MaxT, U0_ini_R, V0_ini_R, A0_ini_R);
    
    %%
    % compute the first residual.
    Res_FR=M_ini*Phi.iter_free*A_ini_R+K_ini*Phi.iter_free*U_ini_R;
    Res=f_amp_free(:, 1:size(Res_FR, 2))-Res_FR;
    %     PR=Phi.iter_free'*Res;
    %     disp(max(PR(:)))
    [U_err_R, V_err_R, A_err_R, U_err, V_err, A_err, t_err, time_step_NO_err]=...
        NewmarkBetaReducedMethod...
        (id_phi, M_ini, C_ini, K_ini, Res, ...
        acce, deltaT, MaxT, U0_iter, V0_iter, A0_iter);
    %%
    % from residual to equavilent displacement, use fixed inv_MTX.
    %     [U_err_R1, V_err_R1, A_err_R1, U_err, V_err, A_err, t_err, time_step_NO_err]=...
    %         NewmarkBetaReducedMethodwithINVMTX...
    %         (id_phi, inv_MTX_hat, MTX_AHat_free.M, MTX_AHat_free.C, ...
    %         Res, deltaT, MaxT-deltaT, U0_ini, V0_ini, A0_ini, a0, a1, a2, a3, a4, a5, a6, a7, al, delta);
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %         err=norm(U_err, 'fro');                                   % +
    err=norm(U_err, 'fro')/norm(U_exact_ini, 'fro');                     % +
    err_log=log10(err);                                                 % +
    err_store(i_ini)=err_store(i_ini)+err;                              % +
    err_store_log(i_ini)=err_store_log(i_ini)+err_log;                  % +
    res_store(i_ini)=res_store(i_ini)+norm(Res, 'fro');
    resfr_store(i_ini)=resfr_store(i_ini)+norm(Res_FR, 'fro');
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
end
%%
subplot(1, 1, i_cnt_iter)
surf(linspace(domainBondL.I1, domainBondR.I1, domainLength.I1), ...
    linspace(domainBondL.I2, domainBondR.I2, domainLength.I2), err_store);
axis([-2 2 -3 3])
view(3)
% subplot(2, 2, 2)
% surf(linspace(domainBondL.I1, domainBondR.I1, domainLength.I1), ...
%     linspace(domainBondL.I2, domainBondR.I2, domainLength.I2), err_store_log);
disp('iteration')
disp(i_cnt_iter);
% =========================================================================
toc
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[err_max_log, err_max_log_loc]=max(err_store_log(:));                   % +
[err_max, err_max_loc]=max(err_store(:));                               % +
legendInfo{i_cnt_iter}=['Iteration = ' num2str(i_cnt_iter) ' Max error = ' num2str(err_max_loc)];
legend(legendInfo)
set(legend,'FontSize',8);
disp('max err=')                                                        % +
disp(err_max)                                                           % +
disp('max err loc=')
disp(err_max_loc)                                                       % +
% disp('max err log=')
% disp(err_max_log)                                                       % +
% disp('max err log loc=')
% disp(err_max_log_loc)                                                   % +
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%}

%%
%%{
snap=[];
snap_store_comb=zeros(size(re_se_rows_num, 1), size(re_se_rows_num, 2)+NPhi);

err_bd=1e-4;
while abs(err_max)>err_bd
    tic
    err_max_prev_loc=err_max_loc;
    %     err_max_log_prev_loc=err_max_log_loc;
    
    err_store=zeros(length(pm.I1), length(pm.I2));
    err_store_log=zeros(length(pm.I1), length(pm.I2));
    
    elastic_pm.I1=str2num(strtext(line_node.I1(1)+pm_dist, :));
    elastic_pm.I2=str2num(strtext(line_node.I2(1)+pm_dist, :));
    elastic_pm.S=str2num(strtext(line_node.S(1)+pm_dist, :));
    
    num_iterE.I1(1, :)=elastic_pm.I1(:, 1);
    num_iterE.I2(1, :)=elastic_pm.I2(:, 1);
    num_iterE.S(1, :)=elastic_pm.S(:, 1);
    
    num_iterE.I1(2, :)=pm.comb(err_max_loc, 1);
    num_iterE.I2(2, :)=pm.comb(err_max_loc, 2);
    num_iterE.S(2, :)=pm.comb(err_max_loc, 3);
    
    str_iterE.I1=num2str(num_iterE.I1, 6);
    str_iterE.I2=num2str(num_iterE.I2, 6);
    str_iterE.S=num2str(num_iterE.S, 6);
    
    [strtext]=ModifyParameter(str_iterE.I1, strtext, line_node.I1, pm_dist);
    [strtext]=ModifyParameter(str_iterE.I2, strtext, line_node.I2, pm_dist);
    [strtext]=ModifyParameter(str_iterE.S, strtext, line_node.S, pm_dist);
    
    delete('C:\Temp\abaqus.rpt');
    [ExistingFilename]=WriteTextIntoDisk(strtext, FiletoBeInserted);
    
    % write EXPORTMATRIX in INP
    system('abaqus cae noGUI=C:\Temp\connection_gre.py');% ###################################
    [Cleared_INP]=ABAQUSClearFromINP(INPfilename, INPfilename);
    [result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
    
    selected_rows_str=result_data(size(result_data, 1)-iteratives+1:size(result_data, 1), :);
    
    [selected_rows_num]=strrows2numrows(selected_rows_str, node_no);
    
    [re_se_rows_num]=DisplacementRows2Cols(selected_rows_num, node_no);
    
    [snap_store_iter]=StoreResultCols(re_se_rows_num, i_applied_E, iteratives);
    
    [U_exact]=ABAQUSDeleteBCRowsinMTX(snap_store_iter, cons, node);
    
    snap_store_comb(:, 1:NPhi)=snap_store_comb(:, 1:NPhi)+Phi.iter;
    snap_store_comb(:, (NPhi+1):size(snap_store_comb, 2))=...
        snap_store_comb(:, (NPhi+1):size(snap_store_comb, 2))+snap_store_iter;
    
    [X1, Phi.iter, Sigma1]=SVD(snap_store_comb, NPhi);
    
    Phi.iter_free=ABAQUSDeleteBCRowsinMTX(Phi.iter, cons, node);
    
    MTX_M_free_R.I10_I21=Phi.iter_free'*MTX_M_free.I10_I21*Phi.iter_free;
    MTX_K_free_R.I10_I21=Phi.iter_free'*MTX_K_free.I10_I21*Phi.iter_free;
    MTX_M_free_R.I11_I20=Phi.iter_free'*MTX_M_free.I11_I20*Phi.iter_free;
    MTX_K_free_R.I11_I20=Phi.iter_free'*MTX_K_free.I11_I20*Phi.iter_free;
    f_amp_free_R=Phi.iter_free'*f_amp_free;
    tic
    MTX_file_iter.M='C:\Temp\L7H2_dynamics_MASS1.mtx';
    MTX_file_iter.K='C:\Temp\L7H2_dynamics_STIF1.mtx';
    [MTX_iter.M]=ABAQUSReadMTX(MTX_file_iter.M);
    [MTX_iter.K]=ABAQUSReadMTX(MTX_file_iter.K);
    MTX_iter_free.M=ABAQUSDeleteBCinMTX(MTX_iter.M, cons, node);
    MTX_iter_free.K=ABAQUSDeleteBCinMTX(MTX_iter.K, cons, node);
    MTX_iter_free.C=zeros(length(MTX_iter_free.M));
    for i_iter=1:size(pm.comb, 1)
        
        M_iter_R=MTX_M_free_R.I11_I20*0.01+MTX_M_free_R.I10_I21*0.01;
        K_iter_R=MTX_K_free_R.I11_I20*pm.comb(i_iter, 1)+MTX_K_free_R.I10_I21*pm.comb(i_iter, 2);
        C_iter_R=zeros(length(M_iter_R));
        
        M_iter=MTX_M_free.I11_I20*0.01+MTX_M_free.I10_I21*0.01;
        K_iter=MTX_K_free.I11_I20*pm.comb(i_iter, 1)+MTX_K_free.I10_I21*pm.comb(i_iter, 2);
        C_iter=zeros(length(M_iter));
        
        U0_iter_R=zeros(size(M_iter_R, 1), 1);
        V0_iter_R=zeros(size(M_iter_R, 1), 1);
        A0_iter_R=zeros(size(M_iter_R, 1), 1);
        
        U0_iter=zeros(size(M_iter, 1), 1);
        V0_iter=zeros(size(M_iter, 1), 1);
        A0_iter=zeros(size(M_iter, 1), 1);
        
        [U_iter_R, V_iter_R, A_iter_R, U_iter, V_iter, A_iter, t_iter, time_step_NO_iter]=...
            NewmarkBetaReducedMethod...
            (Phi.iter_free, M_iter_R, C_iter_R, K_iter_R, f_amp_free_R, ...
            acce, deltaT, MaxT, U0_iter_R, V0_iter_R, A0_iter_R);
        
        Res_FR_iter=M_iter*Phi.iter_free*A_iter_R+K_iter*Phi.iter_free*U_iter_R;
        
        Res_iter=f_amp_free-Res_FR_iter;
        PR=Phi.iter_free'*Res_iter;
        
        [U_err_R, V_err_R, A_err_R, U_err, V_err, A_err, t_err, time_step_NO_err]=...
            NewmarkBetaReducedMethod...
            (id_phi, M_iter, C_iter, K_iter, Res_iter, ...
            acce, deltaT, MaxT, U0_iter, V0_iter, A0_iter);
        %         disp(max(PR(:)))
        %         [U_err_R1, V_err_R1, A_err_R1, U_err, V_err, A_err, t_err, time_step_NO_err]=NewmarkBetaReducedMethodwithINVMTX...
        %             (id_phi, inv_MTX_hat, MTX_AHat_free.M, MTX_AHat_free.C, ...
        %             Res_iter, deltaT, 19.9, U0_iter, V0_iter, A0_iter, a0, a1, a2, a3, a4, a5, a6, a7, al, delta);
        
        
        % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        %         err=norm(U_err, 'fro');                               % +
        err=norm(U_err, 'fro')/norm(U_exact_ini, 'fro');                 % +
        err_log=log10(err);                                             % +
        err_store(i_iter)=err_store(i_iter)+err;                        % +
        err_store_log(i_iter)=err_store_log(i_iter)+err_log;            % +
        % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    end
    toc
    
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    err_store_col=err_store(:);
    err_store_log_col=err_store_log(:);
    [err_max, err_max_loc]=max(err_store_col);                          % +
    [err_max_log, err_max_log_loc]=max(err_store_log_col);              % +
    
    err_max_prev=err_store_col(err_max_prev_loc);
    %     err_max_log_prev=err_store_log(err_max_log_prev_loc);
    disp('prev err reduce to=')
    disp(err_max_prev)
    %     disp('prev err log reduce to=')
    %     disp(err_max_log_prev)
    
    disp('max err=')                                                    % +
    disp(err_max)                                                       % +
    disp('max err loc=')
    disp(err_max_loc)                                                   % +
    %         disp('max err log=')
    %         disp(err_max_log)                                             % +
    %         disp('max err log loc=')
    %         disp(err_max_log_loc)                                         % +
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    %     hold all
    hold on
    grid on
    i_cnt_iter=i_cnt_iter+1;
    %     subplot(2, 3, i_cnt_iter)
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    subplot(1, 2, i_cnt_iter)
    surf(linspace(domainBondL.I1, domainBondR.I1, domainLength.I1), ...
        linspace(domainBondL.I2, domainBondR.I2, domainLength.I2), err_store);
    %     subplot(2, 2, 4)
    %     surf(linspace(domainBondL.I1, domainBondR.I1, domainLength.I1), ...
    %         linspace(domainBondL.I2, domainBondR.I2, domainLength.I2), err_store_log);
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    axis([-2 2 -3 3])
    view(3)
    
    legendInfo{1}=['Iteration = ' num2str(i_cnt_iter) ' Max error = ' num2str(err_max_loc)];
    %     legendInfo{i_cnt_iter}=['Max error = ' num2str(err_max_loc)];
    %     legendInfo=num2str(err_max_loc);
    legend(legendInfo)
    set(legend,'FontSize',8);
    %     xlabel('10e-3 < parameter 1 < 10e3')
    %     ylabel('10e-2 < parameter 1 < 10e2')
    disp('iteration')
    disp(i_cnt_iter);
    toc
    if i_cnt_iter>=2
        break
    end
    
end
%}

%%
% suptitle('tp=[20, 20], NPhi=30, I1=-3:3, I2=-2:2, log scale')









