clear; clc;

no.inpt = 5;

inpt.a1 = rand(no.inpt);

inpt.a2 = rand(no.inpt);

inpt.a3 = rand(no.inpt);

[otpt] = testPassStructuralVartoFuncfunction(inpt);

[otpt] = testPassStructuralVartoFuncfunction1(otpt);