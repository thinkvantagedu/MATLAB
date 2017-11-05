clear variables; clc;
format long;
addpath('C:\Temp\MATLAB');
addpath('C:\Temp\MATLAB\ABAQUS_MOR');
filename.new='C:\Temp\trimed_textfile_gre_L9H2.py';
filename.trim='C:\Temp\abaqusMacros_L9H2_dynamics.py';
delete(filename.new);
TrimString(filename.trim, filename.new);
filename=filename.new;
textfile_py=char(importdata(filename, 's'));
str_rmv='def';
textfile_origin=textfile_py;
[textfile]=RemoveOneStringRowinText(textfile_origin, str_rmv);
ConnectionFile='C:\Temp\connection_gre.py';
WrittenFile=textfile;
delete(ConnectionFile);
[WrittenFile]=WriteTextIntoDisk(WrittenFile, ConnectionFile);
INPfilename='C:\Temp\L9H2_dynamics.inp';
FiletoBeInserted='C:\Temp\L9H2_dynamics.inp';
loc_string='instance=Part-1-1';
[Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, FiletoBeInserted);
[cons]=ABAQUSReadINPCons(INPfilename, loc_string);
[node, elem]=ABAQUSReadINPGeo(INPfilename);
node_no=node(size(node, 1), 1);
[strtext]=DisplayText(INPfilename);
pm_dist=4;
Strtofind.I='*Material, name=Material-I';
[line_node.I]=FindTextRowNO(INPfilename, Strtofind.I);
elastic_pm.I=str2num(strtext(line_node.I(1)+pm_dist, :));
YoungsM.I=elastic_pm.I(:, 1);
Strtofind.S='*Material, name=Material-S';
[line_node.S]=FindTextRowNO(INPfilename, Strtofind.S);
elastic_pm.S=str2num(strtext(line_node.S(1)+pm_dist, :));
YoungsM.S=elastic_pm.S(:, 1);
domainLength.I=50;
domainLength.S=50;
domainBondL.I=-2;
domainBondR.I=2;
domainBondL.S=-3;
domainBondR.S=3;
pm.I=logspace(domainBondL.I, domainBondR.I, domainLength.I);
pm.S=logspace(domainBondL.S, domainBondR.S, domainLength.S);
pm.comb=zeros(2, domainLength.I*domainLength.S);
pm.comb(1:2, :)=combvec(pm.I, pm.S);
pm.comb=pm.comb';
MaxT=20;
deltaT=0.1;
f_node=2;
f_dof=3*f_node-1;
force_t=4;
f_amp=zeros(3*length(node), MaxT/deltaT);
f_amp_t=(deltaT:deltaT:force_t);
f_amp_value=-sin(pi/4*f_amp_t);
f_amp(f_dof, 1:length(f_amp_t))=f_amp(f_dof, 1:length(f_amp_t))+f_amp_value;
f_amp_free=ABAQUSDeleteBCRowsinMTX(f_amp, cons, node);
MTX_file_M.I0_S1='C:\Temp\L9H2_dynamics_matrices_I0S1_MASS1.mtx';
MTX_file_K.I0_S1='C:\Temp\L9H2_dynamics_matrices_I0S1_STIF1.mtx';
MTX_file_M.I1_S0='C:\Temp\L9H2_dynamics_matrices_I1S0_MASS1.mtx';
MTX_file_K.I1_S0='C:\Temp\L9H2_dynamics_matrices_I1S0_STIF1.mtx';
[MTX_M.I0_S1]=ABAQUSReadMTX(MTX_file_M.I0_S1);
[MTX_K.I0_S1]=ABAQUSReadMTX(MTX_file_K.I0_S1);
[MTX_M.I1_S0]=ABAQUSReadMTX(MTX_file_M.I1_S0);
[MTX_K.I1_S0]=ABAQUSReadMTX(MTX_file_K.I1_S0);
MTX_M_free.I0_S1=ABAQUSDeleteBCinMTX(MTX_M.I0_S1, cons, node);
MTX_K_free.I0_S1=ABAQUSDeleteBCinMTX(MTX_K.I0_S1, cons, node);
MTX_M_free.I1_S0=ABAQUSDeleteBCinMTX(MTX_M.I1_S0, cons, node);
MTX_K_free.I1_S0=ABAQUSDeleteBCinMTX(MTX_K.I1_S0, cons, node);
id_phi=eye(length(MTX_M_free.I0_S1));
acce='average';
trial_NO=[20, 20];
if trial_NO(1, 1)>domainLength.I||trial_NO(1, 2)>domainLength.S
    error('trial point exceeds pm domain.')
end
pm_trial.I=pm.I(trial_NO(1, 1));
pm_trial.S=pm.S(trial_NO(1, 2));
Insert_E.I=[YoungsM.I; pm_trial.I];
Insert_E.S=[YoungsM.S; pm_trial.S];
str_E0.I=num2str(Insert_E.I, 6);
str_E0.S=num2str(Insert_E.S, 6);
time=20;
t_step=0.1;
iteratives=time/t_step;
ABA_t=0:t_step:time;
i_applied_E=1;
[strtext]=ModifyParameter(str_E0.I, strtext, line_node.I, pm_dist);
[strtext]=ModifyParameter(str_E0.S, strtext, line_node.S, pm_dist);
ExistingFilename=strtext;
delete('C:\Temp\abaqus.rpt');
[ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeInserted);
system('abaqus cae noGUI=C:\Temp\connection_gre.py');
[result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
selected_rows_str=result_data(size(result_data, 1)-iteratives+1:size(result_data, 1), :);
[selected_rows_num]=strrows2numrows(selected_rows_str, node_no);
[re_se_rows_num]=DisplacementRows2Cols(selected_rows_num, node_no);
[snap_store]=StoreResultCols(re_se_rows_num, i_applied_E, iteratives);
[U_exact_ini]=ABAQUSDeleteBCRowsinMTX(snap_store, cons, node);
[Cleared_INP]=ABAQUSClearFromINP(INPfilename, INPfilename);
NPhi=1;
ERR=1;
x=(1:1:200);

MTX_file_iter.M='C:\Temp\L9H2_dynamics_MASS1.mtx';
MTX_file_iter.K='C:\Temp\L9H2_dynamics_STIF1.mtx';
[MTX_iter.M]=ABAQUSReadMTX(MTX_file_iter.M);
[MTX_iter.K]=ABAQUSReadMTX(MTX_file_iter.K);
MTX_iter_free.M=ABAQUSDeleteBCinMTX(MTX_iter.M, cons, node);
MTX_iter_free.K=ABAQUSDeleteBCinMTX(MTX_iter.K, cons, node);
MTX_iter_free.C=zeros(length(MTX_iter_free.M));

while ERR>0.012
    [X, Phi.iter, Sigma]=SVD(snap_store, NPhi);
    Phi.iter_free=ABAQUSDeleteBCRowsinMTX(Phi.iter, cons, node);
    MTX_svd.M=Phi.iter_free'*MTX_iter_free.M*Phi.iter_free;
    MTX_svd.K=Phi.iter_free'*MTX_iter_free.K*Phi.iter_free;
    MTX_svd.C=zeros(length(MTX_svd.K));
    f_amp_free_R=Phi.iter_free'*f_amp_free;
    U0.svd=zeros(NPhi, 1);
    V0.svd=zeros(NPhi, 1);
    A0.svd=zeros(NPhi, 1);
    [U_svd_R, V_svd_R, A_svd_R, U_svd, V_svd, A_svd, t_svd, time_step_NO_svd]=...
        NewmarkBetaReducedMethod...
        (Phi.iter_free, MTX_svd.M, MTX_svd.C, MTX_svd.K, ...
        f_amp_free_R, acce, deltaT, MaxT, U0.svd, V0.svd, A0.svd);
    ERR=abs((norm(U_exact_ini-U_svd, 'fro'))/norm(U_exact_ini, 'fro'));
    NPhi=NPhi+1;
    disp(ERR)
    disp(NPhi)
end

MTX_M_free_R.I0_S1=Phi.iter_free'*MTX_M_free.I0_S1*Phi.iter_free;
MTX_K_free_R.I0_S1=Phi.iter_free'*MTX_K_free.I0_S1*Phi.iter_free;
MTX_M_free_R.I1_S0=Phi.iter_free'*MTX_M_free.I1_S0*Phi.iter_free;
MTX_K_free_R.I1_S0=Phi.iter_free'*MTX_K_free.I1_S0*Phi.iter_free;
i_cnt_iter=1;
err_store=zeros(length(pm.I), length(pm.S));
err_store_log=zeros(length(pm.I), length(pm.S));
res_store=zeros(length(pm.I), length(pm.S));
resfr_store=zeros(length(pm.I), length(pm.S));
%%
% for i_ini=1:size(pm.comb, 1)
for i_ini=1
    M_ini_R=MTX_M_free_R.I1_S0*0.01+MTX_M_free_R.I0_S1*0.01;
    K_ini_R=MTX_K_free_R.I1_S0*pm.comb(i_ini, 1)+MTX_K_free_R.I0_S1*pm.comb(i_ini, 2);
    C_ini_R=zeros(length(M_ini_R));
    M_ini=MTX_M_free.I1_S0*0.01+MTX_M_free.I0_S1*0.01;
    K_ini=MTX_K_free.I1_S0*pm.comb(i_ini, 1)+MTX_K_free.I0_S1*pm.comb(i_ini, 2);
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
    Res_FR=M_ini*Phi.iter_free*A_ini_R+K_ini*Phi.iter_free*U_ini_R;
    Res=f_amp_free-Res_FR;
    [U_err_R, V_err_R, A_err_R, U_err, V_err, A_err, t_err, time_step_NO_err]=...
        NewmarkBetaReducedMethod...
        (id_phi, M_ini, C_ini, K_ini, Res, ...
        acce, deltaT, MaxT, U0_ini, V0_ini, A0_ini);
    err=norm(U_err, 'fro')/norm(U_exact_ini, 'fro');
    err_log=log10(err);
    err_store(i_ini)=err_store(i_ini)+err;
    err_store_log(i_ini)=err_store_log(i_ini)+err_log;
    res_store(i_ini)=res_store(i_ini)+norm(Res, 'fro');
    resfr_store(i_ini)=resfr_store(i_ini)+norm(Res_FR, 'fro');
end
%{
%%
% subplot(1, 2, 1)
surf(linspace(domainBondL.I, domainBondR.I, domainLength.I), ...
    linspace(domainBondL.S, domainBondR.S, domainLength.S), res_store);
disp('iteration')
disp(i_cnt_iter);
[err_max_log, err_max_log_loc]=max(err_store_log(:));                   
[err_max, err_max_loc]=max(err_store(:));                               
legendInfo{1}=['Iteration = ' num2str(1) ' Max error = ' num2str(err_max) ...
    ' Max err location = ' num2str(err_max_loc)];
legend(legendInfo)
set(legend,'FontSize',8);
disp('max err=')                                                        
disp(err_max)                                                           
disp('max err loc=')
disp(err_max_loc)                                                       
%}
%%
%{
snap=[];
% snap_store_comb=zeros(size(re_se_rows_num, 1), size(re_se_rows_num, 2)+NPhi);
snap_store_comb=[];
err_bd=1e-4;

while abs(err_max)>err_bd
    
    % write EXPORTMATRIX in INP
    [Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, FiletoBeInserted);
    tic
    err_max_prev_loc=err_max_loc;
    %     err_max_log_prev_loc=err_max_log_loc;
    
    err_store=zeros(length(pm.I), length(pm.S));
    err_store_log=zeros(length(pm.I), length(pm.S));
    
    elastic_pm.I=str2num(strtext(line_node.I(1)+pm_dist, :));
    elastic_pm.S=str2num(strtext(line_node.S(1)+pm_dist, :));
    
    num_iterE.I(1, :)=elastic_pm.I(:, 1);
    num_iterE.S(1, :)=elastic_pm.S(:, 1);
    
    num_iterE.I(2, :)=pm.comb(err_max_loc, 1);
    num_iterE.S(2, :)=pm.comb(err_max_loc, 2);
    
    str_iterE.I=num2str(num_iterE.I, 6);
    str_iterE.S=num2str(num_iterE.S, 6);
    
    [strtext]=ModifyParameter(str_iterE.I, strtext, line_node.I, pm_dist);
    [strtext]=ModifyParameter(str_iterE.S, strtext, line_node.S, pm_dist);
    
    delete('C:\Temp\abaqus.rpt');
    [ExistingFilename]=WriteTextIntoDisk(strtext, FiletoBeInserted);
    
    system('abaqus cae noGUI=C:\Temp\connection_gre.py');
    
    MTX_M_file.svd_iter='C:\Temp\L9H2_dynamics_MASS1.mtx';
    MTX_K_file.svd_iter='C:\Temp\L9H2_dynamics_STIF1.mtx';
    [MTX_M.svd_iter]=ABAQUSReadMTX(MTX_M_file.svd_iter);
    [MTX_K.svd_iter]=ABAQUSReadMTX(MTX_K_file.svd_iter);
    MTX_M.svd_iter_free=ABAQUSDeleteBCinMTX(MTX_M.svd_iter, cons, node);
    MTX_K.svd_iter_free=ABAQUSDeleteBCinMTX(MTX_K.svd_iter, cons, node);
    MTX_C.svd_iter_free=zeros(length(MTX_K.svd_iter_free));
    
    [result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
    [Cleared_INP]=ABAQUSClearFromINP(INPfilename, INPfilename);
    selected_rows_str=result_data(size(result_data, 1)-iteratives+1:size(result_data, 1), :);
    
    [selected_rows_num]=strrows2numrows(selected_rows_str, node_no);
    
    [re_se_rows_num]=DisplacementRows2Cols(selected_rows_num, node_no);
    
    [snap_store_iter]=StoreResultCols(re_se_rows_num, i_applied_E, iteratives);
    
    [U_exact]=ABAQUSDeleteBCRowsinMTX(snap_store_iter, cons, node);
    
%     snap_store_comb(:, 1:NPhi)=snap_store_comb(:, 1:NPhi)+Phi.iter;
%     snap_store_comb(:, (NPhi+1):size(snap_store_comb, 2))=...
%         snap_store_comb(:, (NPhi+1):size(snap_store_comb, 2))+snap_store_iter;
    snap_store_comb=[snap_store_iter Phi.iter];


    NPhi=1;
    ERR=1;
    while ERR>20e-4
        
        [X1, Phi.iter, Sigma1]=SVD(snap_store_comb, NPhi);
        Phi.iter_free=ABAQUSDeleteBCRowsinMTX(Phi.iter, cons, node);
        MTX_svd.M=Phi.iter_free'*MTX_M.svd_iter_free*Phi.iter_free;
        MTX_svd.K=Phi.iter_free'*MTX_K.svd_iter_free*Phi.iter_free;
        MTX_svd.C=zeros(length(MTX_svd.K));
        f_amp_free_R=Phi.iter_free'*f_amp_free;
        U0.svd=zeros(NPhi, 1);
        V0.svd=zeros(NPhi, 1);
        A0.svd=zeros(NPhi, 1);
        [U_svd_R, V_svd_R, A_svd_R, U_svd, V_svd, A_svd, t_svd, time_step_NO_svd]=...
            NewmarkBetaReducedMethod...
            (Phi.iter_free, MTX_svd.M, MTX_svd.C, MTX_svd.K, ...
            f_amp_free_R, acce, deltaT, MaxT, U0.svd, V0.svd, A0.svd);
        
        ERR=abs((norm(U_exact, 'fro')-norm(U_svd, 'fro'))/norm(U_exact, 'fro'));
        disp(ERR)
        NPhi=NPhi+1;
        keyboard
        
    end
    
    Phi.iter_free=ABAQUSDeleteBCRowsinMTX(Phi.iter, cons, node);
    
    MTX_M_free_R.I0_S1=Phi.iter_free'*MTX_M_free.I0_S1*Phi.iter_free;
    MTX_K_free_R.I0_S1=Phi.iter_free'*MTX_K_free.I0_S1*Phi.iter_free;
    MTX_M_free_R.I1_S0=Phi.iter_free'*MTX_M_free.I1_S0*Phi.iter_free;
    MTX_K_free_R.I1_S0=Phi.iter_free'*MTX_K_free.I1_S0*Phi.iter_free;
    f_amp_free_R=Phi.iter_free'*f_amp_free;
    tic
    for i_iter=1:size(pm.comb, 1)
        
        M_iter_R=MTX_M_free_R.I1_S0*pm.comb(i_iter, 1)+MTX_M_free_R.I0_S1*pm.comb(i_iter, 2);
        K_iter_R=MTX_K_free_R.I1_S0*pm.comb(i_iter, 1)+MTX_K_free_R.I0_S1*pm.comb(i_iter, 2);
        C_iter_R=zeros(length(M_iter_R));
        
        M_iter=MTX_M_free.I1_S0*pm.comb(i_iter, 1)+MTX_M_free.I0_S1*pm.comb(i_iter, 2);
        K_iter=MTX_K_free.I1_S0*pm.comb(i_iter, 1)+MTX_K_free.I0_S1*pm.comb(i_iter, 2);
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
        
        Res_iter=f_amp_free(:, 1:size(Res_FR_iter, 2))-Res_FR_iter;
        PR=Phi.iter_free'*Res_iter;
        %         disp(max(PR(:)))
        [U_err_R1, V_err_R1, A_err_R1, U_err, V_err, A_err, t_err, time_step_NO_err]=...
            NewmarkBetaReducedMethodwithINVMTX...
            (id_phi, inv_MTX_hat, MTX_AHat_free.M, MTX_AHat_free.C, ...
            Res_iter, deltaT, 19.9, U0_iter, V0_iter, A0_iter, ...
            a0, a1, a2, a3, a4, a5, a6, a7, al, delta);
        % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        %         err=norm(U_err, 'fro');                               % +
        err=norm(U_err, 'fro')/norm(U_exact, 'fro');                 % +
        %         err_log=log10(err);                                             % +
        err_store(i_iter)=err_store(i_iter)+err;                        % +
        %         err_store_log(i_iter)=err_store_log(i_iter)+err_log;            % +
        % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    end
    toc
    
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    err_store_col=err_store(:);
    %     err_store_log_col=err_store_log(:);
    [err_max, err_max_loc]=max(err_store_col);                          % +
    %     [err_max_log, err_max_log_loc]=max(err_store_log_col);              % +
    
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
    %     disp('max err log=')
    %     disp(err_max_log)                                             % +
    %     disp('max err log loc=')
    %     disp(err_max_log_loc)                                         % +
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    %     hold all
    hold on
    grid on
    %     subplot(2, 3, i_cnt_iter)
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %     subplot(2, 2, 3)
    surf(linspace(domainBondL.I, domainBondR.I, domainLength.I), ...
        linspace(domainBondL.S, domainBondR.S, domainLength.S), err_store);
    %     subplot(2, 2, 4)
    %     surf(linspace(domainBondL.I, domainBondR.I, domainLength.I), ...
    %         linspace(domainBondL.S, domainBondR.S, domainLength.S), err_store_log);
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    axis([-2 2 -3 3])
    view(3)
    i_cnt_iter=i_cnt_iter+1;
    legendInfo{i_cnt_iter}=['Iteration = ' num2str(i_cnt_iter) ' Max error = ' num2str(err_max_loc)];
    %     legendInfo{i_cnt_iter}=['Max error = ' num2str(err_max_loc)];
    %     legendInfo=num2str(err_max_loc);
    legend(legendInfo)
    set(legend,'FontSize',8);
    %     xlabel('10e-3 < parameter 1 < 10e3')
    %     ylabel('10e-2 < parameter 1 < 10e2')
    disp('iteration')
    disp(i_cnt_iter);
    toc
    
end
%}

%%
% suptitle('tp=[20, 20], NPhi=30, I1=-2:2, S=-3:3, log scale')









