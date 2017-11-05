function [phi, Nphi] = GSAErrorControlledRB(err, Dis, ...
    MTX_M, MTX_K, fce, NMcoef, time, no, projection)
%% 
% this function compute the first rb with an adaptive error-controlled scheme.  
% Error is the norm distance between exact solution and approximation at
% the initial pm point.
errControl = 1;
Nphi.trial = 1;
errStore = zeros(no.dof, 1);
err.control.thres = 0.01;
while errControl > err.control.thres
    
    [phi.fre.all, ~, ~] = SVDmod(Dis.trial.exact, Nphi.trial);
    
    MTX_MReSvd = projection(phi.fre.all, MTX_M.mtx);
    
    MTX_KReSvd = projection(phi.fre.all, MTX_K.trial.exact);
    
    MTX_CReSvd = ...
        sparse(length(MTX_KReSvd), length(MTX_KReSvd));
    
    fceReSvd = phi.fre.all' * fce.val;
    
    DisReInpt = sparse(Nphi.trial, 1);
    
    VelReInpt = sparse(Nphi.trial, 1);
    
    [~, ~, ~, DisSvd, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_MReSvd, MTX_CReSvd, MTX_KReSvd, fceReSvd, NMcoef, ...
        time.step, time.max, DisReInpt, VelReInpt);
    
    errControl = (norm(Dis.trial.exact - DisSvd, 'fro')) / ...
        norm(Dis.trial.exact, 'fro');
    
    errStore(Nphi.trial) = errStore(Nphi.trial) + errControl;
    
    if Nphi.trial >= no.dof / 2
        warning('number of rb vectors exceeds half of DOF number');
    elseif Nphi.trial >= no.dof
        error('number of rb vectors exceeds DOF number')
    end
    
    Nphi.trial = Nphi.trial + 1;
    
end
phi.ident = sparse(eye(no.dof));
Nphi.trial = Nphi.trial - 1;