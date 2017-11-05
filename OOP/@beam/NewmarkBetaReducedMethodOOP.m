function obj = NewmarkBetaReducedMethodOOP(obj, type)

beta = 1/4; gamma = 1/2; % al = alpha

%% pass struct to constants

t = 0 : obj.time.step : (obj.time.max);

a0 = 1 / (beta * obj.time.step ^ 2);
a1 = gamma / (beta * obj.time.step);
a2 = 1 / (beta * obj.time.step);
a3 = 1/(2 * beta) - 1;
a4 = gamma / beta - 1;
a5 = gamma * obj.time.step/(2 * beta) - obj.time.step;
a6 = obj.time.step - gamma * obj.time.step;
a7 = gamma * obj.time.step;

switch type
    
    case 'full'
        
        disInpt = obj.dis.inpt;
        velInpt = obj.vel.inpt;
        sti = obj.sti.full;
        mas = obj.mas.mtx;
        dam = obj.dam.mtx;
        fce = obj.fce.pass;
        
    case {'reduced', 'rewRb'}
        disInpt = obj.dis.re.inpt;
        velInpt = obj.vel.re.inpt;
        sti = obj.sti.reduce;
        mas = obj.mas.reduce;
        dam = obj.dam.reduce;
        fce = obj.phi.val' * obj.fce.pass;
        
end

obj.dis.val = zeros(length(sti), length(t));
obj.dis.val(:, 1) = obj.dis.val(:, 1) + disInpt;
obj.vel.val = zeros(length(sti), length(t));
obj.vel.val(:, 1) = obj.vel.val(:, 1) + velInpt;
obj.acc.val = zeros(length(sti), length(t));
obj.acc.val(:, 1) = obj.acc.val(:, 1) + mas \ (fce(:, 1) - ...
    dam * obj.vel.val(:, 1) - sti * obj.dis.val(:, 1));

Khat = sti + a0 * mas + a1 * dam;

for i_nm = 1 : length(t) - 1
    
    dFhat = fce(:, i_nm+1) + ...
        mas * (a0 * obj.dis.val(:, i_nm) + ...
        a2 * obj.vel.val(:, i_nm) + ...
        a3 * obj.acc.val(:, i_nm)) + ...
        dam * (a1 * obj.dis.val(:, i_nm) + ...
        a4 * obj.vel.val(:, i_nm) + ...
        a5 * obj.acc.val(:, i_nm));
    dU_r = Khat \ dFhat;
    dA_r = a0 * dU_r - a0 * obj.dis.val(:, i_nm) - ...
        a2 * obj.vel.val(:, i_nm) - a3 * obj.acc.val(:, i_nm);
    dV_r = obj.vel.val(:, i_nm) + ...
        a6 * obj.acc.val(:, i_nm) + a7 * dA_r;
    obj.acc.val(:, i_nm+1) = dA_r;
    obj.vel.val(:, i_nm+1) = dV_r;
    obj.dis.val(:, i_nm+1) = dU_r;
    
end

switch type
    
    case 'full'
        
        obj.acc.full = obj.acc.val;
        obj.vel.full = obj.vel.val;
        obj.dis.full = obj.dis.val;
        
    case 'reduced'
        
        obj.acc.reduce = obj.acc.val;
        obj.vel.reduce = obj.vel.val;
        obj.dis.reduce = obj.dis.val;
        
    case 'rewRb'
        obj.acc.full = obj.phi.val * obj.acc.val;
        obj.vel.full = obj.phi.val * obj.vel.val;
        obj.dis.full = obj.phi.val * obj.dis.val;

end