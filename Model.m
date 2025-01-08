function [dpdt] = Model(t,p,T,tprev,pars)
% Constructs model states and contitutive relations to be solved forward in time

% Inputs:
    % t: Time instance
    % p: State solution at previous time step
    % T: Breathing period
    % tprev: % Time when breath cycle started
    % pars: Vector of parameter values

% Outputs:
    % dpdt: Vector of ODE values at specific times

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

% ODE states
Vdot = p(1);
Pel = p(2);
Vc = p(3);
Pve = p(4);

f=1/T; % Breathing frequency
Pmus = Amus*cos(2*pi*f*(t-tprev))-Amus; % Diaphragm muscle pressure

VC=TLC-RV; % Vital capacity
aw=RV;
bw=nu*VC/(log(exp(-cw/dw)+1));

Frec=1/(1+exp(-(Pel-cF)/dF)); % Lung recruitment function
Vel=VC*(1-exp(-k*Pel)); % Lung elastic recoil volume
VA=Frec*Vel+RV; % Alveolar volume
% Alveolar compliance
CA=(VC*k*exp(-Pel*k))/(exp(-(Pel - cF)/dF) + 1) - (VC*exp(-(Pel - cF)/dF)*(exp(-Pel*k) - 1))/(dF*(exp(-(Pel - cF)/dF) + 1)^2);

Vcw=VA+Vc; % Chest wall volume
Pcw=cw+dw*log(exp((Vcw-aw)/bw)-1); % Chest wall volume
Ptm=cc-dc*log(Vcmax./Vc-1); % Transmural pressure across collapsible airways

Pl=Pel+Pve; % Total pulmonary pressure
Ppl=Pcw+Pmus; % Pleural pressure
PA=Pl+Ppl; % Alveolar pressure
Pc=Ptm+Ppl; % Collapsible airway pressure

Rc =  Kc*(Vcmax/Vc)^2; % Collapsible airway resistance
Rs =  Rsd*exp(Ks*(VA-RV)/(TLC-RV))+Rsm; % Small airway resistance
Ru = Rum+ Ku*abs(Vdot); % Upper airway resistance

Pu=Vdot*Rc+Pc; % Upper airway pressure
VAdot=(Pc-PA)/Rs; %Alveolar flow
Vcdot=Vdot-VAdot; % Collapsible airway flow

dpdt =  [(Pao-Pu-Ru*Vdot)/I;  % d/dt(Vdot)
        (VAdot)/CA;           % d/dt(Pel)      
        Vcdot;                % d/dt(Vc)
        (VAdot-Pve/Rve)/Cve]; % d/dt(Pve)