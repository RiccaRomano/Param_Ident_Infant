function [pars,par_names,Init]=load_pars(simID,paoID) %

Vdot0=0;
Pel0=0.954; % Pel0 for low Cw is 2.015; GETS REWRITTEN DURING THE SOLVER CODE, TO GET BETTER IC BASED ON P_FRC
Vc0 = 0.0001; %9e-4/10;
Pve0 = 0;

Init=[Vdot0 Pel0 Vc0 Pve0]; 

switch simID
    case 'treated'
        cF = 0.1; % Mean opening lung pressure
        dF = 0.4; % Range opening lung pressure
        k=0.07; % Elastic lung coefficient
        TLC=0.001*63; % Total lung capacity
        RV=0.001*23; % Residual volume
        RR=60; % Respiratory rate
        nu=0.25; %
        cw=0; % Chest wall break point pressure coefficient
        dw=0.48; % Chest wall compliance coefficient
        Amus  = 1.85; %Amplitude of diaphragm pressure
        Rum    = 20; % Upper airway resistance
        Ku      =60;
        Kc    = 0.1; % Compressible airway resistance
        Rsm    = 12; % Small airway resistance
        Rsd   = 20;
        Ks    =-15;
        Iu     = 0.33; % Upper airway inductance
        cc    = 4.4; %
        dc    = 4.4;
        Vcmax = 0.0025; % Maximum compressible airway volume 
        Cve   = 0.005; % Viscoelastic compliance
        Rve   = 20; % Viscoelastic resistance
    case 'deficient'
        cF=8; % Mean opening lung pressure, cmH2O, IN MU VARY
        dF=3; % Range of lung pressure constitutive equation, IN MU VARY
        k=0.04; % Elastic lung coefficient, IN MU VARY
        TLC=0.001*53; % Total lung capacity, in L, IN MU VARY
        RV=0.001*23; % Residual volume, in L
        RR=60; % Respiratory rate, br/min
        nu=0.25; % IN MU VARY
        cw=0; % Chest wall break point pressure coefficient
        dw=0.48; % Chest wall compliance coefficient, IN MU VARY
        Amus=1.85; %Amplitude of diaphragm pressure, IN MU VARY
        Rum=20; % Upper airway resistance
        Ku=60;
        Kc=0.1; % Compressible airway resistance
        Rsm=12; % Small airway resistance
        Rsd=20;
        Ks=-15;
        Iu=0.33; % Upper airway inductance
        cc=4.4; %
        dc=4.4;
        Vcmax=0.0025; % Maximum compressible airway volume, IN MU VARY
        Cve=0.005; % Viscoelastic compliance
        Rve=20; % Viscoelastic resistance, IN MU VARY
end

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
pars=[cF dF k TLC RV RR nu cw dw Amus Rum Ku Kc Rsm Rsd Ks Iu cc dc Vcmax Cve Rve Pao]';

par_names={'$c_F$';'$d_F$';'$k$';'$TLC$';'$RV$';'$RR$';'$\nu$';'$c_{cw}$';'$d_{cw}$';'$A_{mus}$';...  %1-10
    '$R_{um}$';'$K_u$';'$K_c$';'$R_{sm}$';'$R_{sd}$';'$K_s$';'$I_u$';'$c_c$';'$d_c$';'$V_{c,max}$';... %11-20
    '$C_{ve}$';'$R_{ve}$';'$P_{ao}$'}; %21-23
