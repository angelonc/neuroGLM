trialIndices = 1:3;

totalT = sum(ceil(expt.binfun([expt.trial(trialIndices).duration])));

dspec = struct();
dspec.expt = expt;

dspec.covar(1).cond = @(trial) trial.choice == 1;
dspec.covar(1).value = @(trial, nT) randn(nT, 2);
dspec.covar(1).edim = 2;

dspec.covar(2).value = @(trial, nT) trial.LFP;
dspec.covar(2).edim = 1;

dspec.covar(3).value = @(trial, nT) [zeros(expt.binfun(trial.dotson), 2); log(abs(trial.coh)) * [1 1]; zeros(nT - expt.binfun(trial.dotson) - 1, 2)];
dspec.covar(3).edim = 2;

bases = basisFactory.makeNonlinearRaisedCos(6, expt.binSize, [0 100], 0.1);

dspec.covar(4).value = @(trial, nT) [zeros(expt.binfun(trial.dotsoff), 1); 5; zeros(nT - expt.binfun(trial.dotsoff) - 1, 1)];
dspec.covar(4).basis = bases;
dspec.covar(4).offset = 0;
dspec.covar(4).edim = bases.edim;

dspec.covar(5).value = @(trial, nT) [zeros(expt.binfun(trial.dotsoff), 1); 5; zeros(nT - expt.binfun(trial.dotsoff) - 1, 1)];
dspec.covar(5).basis = bases;
dspec.covar(5).offset = -100;
dspec.covar(5).edim = bases.edim;

dspec.covar(6).value = @(trial, nT) [zeros(expt.binfun(trial.dotsoff), 1); 5; zeros(nT - expt.binfun(trial.dotsoff) - 1, 1)];
dspec.covar(6).basis = bases;
dspec.covar(6).offset = 12;
dspec.covar(6).edim = bases.edim;

dspec.edim = sum([dspec.covar(:).edim]);

dm = buildGLM.compileSparseDesignMatrix(dspec, trialIndices);

imagesc(dm.X);