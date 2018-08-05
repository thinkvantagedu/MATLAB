% this script test ONERA_M60 wing exact error.

ki = canti.sti.mtxCell{1};
ks = canti.sti.mtxCell{2};

pmi = canti.pmVal.trial(1);
pms = canti.pmVal.trial(2);