% Laura Ellwein Fix - Richard Foster
% Optimization of Chest Wall Model against Data from Abbasi/Bhutani1990 (gives Ppl, Vdot, and VA data)
close all
clear
clc

% Number of periods
NP=10;

% ODE tolerance
ODE_TOL=1e-8;

simID='treated';
%simID='deficient';

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
