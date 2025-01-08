function [sols]=model_sol(pars,data)
% Runs ODE solver and obtains state and constitutive relation outputs

% Inputs:
    % pars: Vector of parameter values
    % data: Data structure that contains the following:
        % Init: ODE initial conditions
        % NP: Number of breathing periods
        % ODE_TOL: ODE tolerance
        % simID: Lung health scenario ('treated' or 'deficient')
        % paoID: CPAP administration level

% Outputs:
    % sols: Matrix of ODE solutions

% Outputs:
% Load parameters
cF=pars(1);
dF=pars(2);
k=pars(3);
TLC=pars(4);
RV=pars(5);
RR=pars(6);
nu=pars(7);
cw=pars(8);
dw=pars(9);
Amus=pars(10);
Rum=pars(11);
Ku=pars(12);
Kc=pars(13);
Rsm=pars(14);
Rsd=pars(15);
Ks=pars(16);
I=pars(17); 
cc=pars(18);
dc=pars(19);
Vcmax=pars(20);
Cve=pars(21);
Rve=pars(22);
Pao=pars(23);

VC=TLC-RV; %Vital capacity, in L
f=RR/60; % Breathing frequency
T=1/f; % Breathing period

Init=data.Init; % Initial conditions
ODE_TOL=data.ODE_TOL; % ODE tolerance
NP=data.NP; % Number of breathing periods

PVcurve_pars=[TLC RV dw cF dF k nu cw]';
[Vcw_range,Pel_range,VA_Range,FRC,P_FRC,Ptot,VolN]=test_curves_preterm(PVcurve_pars); % Constructs lung/chest wall compliance relations
Init(2)=P_FRC; % Initial condition for Pel state

% Time span during one breath cycle
tprev=0;
tnext=tprev+T;
tstep=0.01;
tspan = tprev:tstep:tnext; %Creates timespan over which to solve DEs
t=0;

% Initialize solution matrix
sols=Init;

% Initialize scalar model outputs
Pmussave=0;
VT=zeros(NP,1); % Tidal volume, in L
VE=zeros(NP,1); % Minute ventilation, in L
Cdyn=zeros(NP,1); % Dynamic breath-to-breath lung compliance
Cwdyn=zeros(NP,1); % Dynamic breath-to-breath chest wall compliance

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL);

% For-loop across individual breaths
for ii=1:NP
        % Solve system during one breath
        [time,sol]=ode15s(@Model,tspan,Init,options,T,tprev,pars);
        t=[t;time(2:end)]; % Time vector
        sols=[sols; sol(2:end,:)]; % Solution vector
        Init=[sol(end,1:4)]; % Overwrite initial condition to last observed outputs
        
        Peltemp=sol(2:end,2); % Lung elastic recoil pressure during individual breath
        maxPel=max(Peltemp); % Maximum lung elastic recoil pressure
        minPel=min(Peltemp); % Minimum lung elastic recoil pressure
        endPel=Peltemp(end);

        Frectemp=1./(1+exp(-(Peltemp-cF)/dF)); % Lung recruitment during individual breath
        fracOpen=max(Frectemp); % Maximum recruitment
        minFrec=min(Frectemp); % Minimum recruitment
        endFrec=Frectemp(end);
        Veltemp=VC*(1-exp(-k*Peltemp)); % Lung elastic recoil volume during one breath
        VAtemp=Frectemp.*Veltemp+RV; % Alveolar volume
        VAmax=max(VAtemp); % Maximum alveolar volume
        VAmin=min(VAtemp); % Minimum alveolar volume
        Cdyn(ii)=(VAmax-VAmin)/(maxPel-minPel); % Dynamic breath-to-breath lung compliance

        Vcwtemp=VAtemp+sol(2:end,3); % Chest wall volume during individual breath
        Vcwmax=max(Vcwtemp); % Maximum chest wall volume
        Vcwmin=min(Vcwtemp); % Minimum chest wall volume
        imaxPcw=find(abs(Vcw_range-Vcwmax)<0.0001, 1, 'last' );
        iminPcw=find(abs(Vcw_range-Vcwmin)<0.0001, 1, 'last' );
        maxPcw=Pel_range(imaxPcw);
        minPcw=Pel_range(iminPcw);
        Cwdyn(ii)=(Vcwmax-Vcwmin)/(maxPcw-minPcw); % Dynamic breath-to-breath chest wall compliance

        VT(ii)=VAmax-VAmin; % Tidal volume
        VE(ii)=VT(ii)*f*60; % Minute ventilation
        Pmustemp=(Amus*cos(2*pi*f*(tspan-tprev))-Amus)';
        Pmussave=[Pmussave; Pmustemp(2:end)];
        
        % Restart for-loop at a new breathing cycle
        tprev = tnext;
        tnext=tprev+T;
        tspan = tprev:tstep:tnext;
end
% Extract system states from solution
Vdot=sols(:,1);  Pel=sols(:,2);  Vc=sols(:,3); Pve=sols(:,4);

% Obtain time-varying consitutive relation solutions
Frec=1./(1+exp(-(Pel-cF)/dF));
Vel=VC*(1-exp(-k*Pel));
VA=Frec.*Vel+RV;
Vcw=VA+Vc;

aw=RV;
bw=nu*VC/(log(exp(-cw/dw)+1));
Pcw=cw+dw*log(exp((Vcw-aw)/bw)-1);
Ptm=cc-dc*log(Vcmax./Vc-1);

Pmus=Pmussave;
Pl=Pel+Pve;
Ppl=Pcw+Pmus;
PA=Pl+Ppl;
Pc=Ptm+Ppl;

Rc =  Kc*(Vcmax./Vc).^2;
Rs =  Rsd*exp(Ks*(VA-RV)/(TLC-RV))+Rsm;
Ru = Rum+ Ku*abs(Vdot);

Pu=Vdot.*Rc+Pc;
VAdot=(Pc-PA)./Rs;
Vcdot=Vdot-VAdot;

% Save results
switch data.sim
    case 'treated'
        savename='treatedResults';
    case 'deficient'
        savename='deficientResults';
end

switch data.pao
    case 0
        savename=[savename '_0CPAP.mat'];
    case 2
        savename=[savename '_2CPAP.mat'];
    case 4
        savename=[savename '_4CPAP.mat'];
    case 6
        savename=[savename '_6CPAP.mat'];
    case 8
        savename=[savename '_8CPAP.mat'];
end

save(savename);
end
