function [pars,par_names,Init]=load_pars(simID,paoID)
% Provides initial conditions and starting parameter values

% Inputs:
    % simID: lung health scenario (either 'treated' or 'deficient') 
    % paoID: CPAP administation level, between 0 and 8 cmH2O

% Outputs:
    % pars: Vector of parameter values
    % par_names: Cell array of parameter names
    % Init: Vector of ODE initial conditions

% Initial conditions for the ODEs
Vdot0=0; %Units, L
Pel0=0; % THIS INITIAL CONDITION GETS OVERWRITTEN DURING MODEL SOLVING
Vc0 = 0.0001; % Units, L
Pve0 = 0; % Units, cmH2O

Init=[Vdot0 Pel0 Vc0 Pve0]; 

% Parameter values based on lung health scenario
switch simID
    case 'treated'
        cF=0.1; % Mean opening lung pressure, in cmH2O
        dF=0.4; % Lung pressure range parameter, in cmH2O
        k=0.07; % Elastic lung coefficient
        TLC=0.001*63; % Total lung capacity, in L
        RV=0.001*23; % Residual volume, in L
        RR=60; % Respiratory rate, breaths/min
        nu=0.25; % Chest wall relaxation volume, unitless
        cw=0; % Chest wall break point pressure coefficient
        dw=0.48; % Chest wall compliance coefficient
        Amus=1.85; % Diaphragm pressure amplitude
        Rum=20; % Baseline upper airway resistance
        Ku=60; % Flow-dependent upper airway resistance parameter
        Kc=0.1; % Compressible airway resistance
        Rsm=12; % Minimum small airway resistance
        Rsd=20; % Small airway resistance parameter
        Ks=-15; % Volume-dependent small resistance parameter
        Iu=0.33; % Upper airway inductance
        cc=4.4; % Collapsible airway pressure at maximum compliance, in cmH2O
        dc=4.4; % Collapsible airway pressure range parameter, in cmH2O
        Vcmax=0.0025; % Maximum compressible airway volume, in L
        Cve=0.005; % Viscoelastic compliance
        Rve=20; % Viscoelastic resistance
    case 'deficient'
        cF=8;
        dF=3;
        k=0.04;
        TLC=0.001*53;
        RV=0.001*23;
        RR=60; 
        nu=0.25; 
        cw=0; 
        dw=0.48; 
        Amus=1.85;
        Rum=20; 
        Ku=60; 
        Kc=0.1; 
        Rsm=12; 
        Rsd=20; 
        Ks=-15;
        Iu=0.33; 
        cc=4.4; 
        dc=4.4;
        Vcmax=0.0025; 
        Cve=0.005; 
        Rve=20;
end

% Airway opening pressure, or CPAP parameter
switch paoID
    case 0
        Pao=0;
    case 2
        Pao=2;
    case 4
        Pao=4;
    case 6
        Pao=6;
    case 8
        Pao=8;
end

% Parameter vector
pars=[cF dF k TLC RV RR nu cw dw Amus Rum Ku Kc Rsm Rsd Ks Iu cc dc Vcmax Cve Rve Pao]';

% Parameter names
par_names={'$c_F$';'$d_F$';'$k$';'$TLC$';'$RV$';'$RR$';'$\nu$';'$c_{cw}$';'$d_{cw}$';'$A_{mus}$';...  %1-10
    '$R_{um}$';'$K_u$';'$K_c$';'$R_{sm}$';'$R_{sd}$';'$K_s$';'$I_u$';'$c_c$';'$d_c$';'$V_{c,max}$';... %11-20
    '$C_{ve}$';'$R_{ve}$';'$P_{ao}$'}; %21-23
