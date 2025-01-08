%% Laura Ellwein Fix - Richard Foster
% The following code simulates nominal outputs for a model of preterm infant pulmonary mechanics

close all
clear
clc

% Number of breathing periods
NP=10;

% ODE tolerance
ODE_TOL=1e-8;

% Lung health scenario
simID='treated';
%simID='deficient';

% Airway opening pressure (CPAP) scenario, units cmH2O
paoID=0;
% paoID=2;
% paoID=4;
% paoID=6;
% paoID=8;

% Get nominal parameter values
[pars,par_names,Init]=load_pars(simID,paoID);

% Create structure with data and initial conditions
data.Init=Init;
data.NP=NP;
data.ODE_TOL=ODE_TOL;
data.sim=simID;
data.pao=paoID;

%%% ------ Solution w/ Nominal parameter values -----------------------
[sols] = model_sol(pars,data);
