function [obj] = testStructInpt(obj, inptname, otptname)

inpt = sth.(inptname);

obj.(otptname) = randi(inpt);