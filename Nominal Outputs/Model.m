function [dpdt] = Model(t,p,T,tprev,pars)

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

Vdot = p(1);
Pel = p(2);
Vc = p(3);
Pve = p(4);

f=1/T;
Pmus = Amus*cos(2*pi*f*(t-tprev))-Amus;

VC=TLC-RV;
aw=RV;
bw=nu*VC/(log(exp(-cw/dw)+1));

Frec=1/(1+exp(-(Pel-cF)/dF));
Vel=VC*(1-exp(-k*Pel));
VA=Frec*Vel+RV;
CA=(VC*k*exp(-Pel*k))/(exp(-(Pel - cF)/dF) + 1) - (VC*exp(-(Pel - cF)/dF)*(exp(-Pel*k) - 1))/(dF*(exp(-(Pel - cF)/dF) + 1)^2);

Vcw=VA+Vc;
Pcw=cw+dw*log(exp((Vcw-aw)/bw)-1);
Ptm=cc-dc*log(Vcmax./Vc-1);

Pldyn=Pel+Pve;
Ppl=Pcw+Pmus;
PA=Pldyn+Ppl;
Pc=Ptm+Ppl;

Rc =  Kc*(Vcmax/Vc)^2;
Rs =  Rsd*exp(Ks*(VA-RV)/(TLC-RV))+Rsm;
Ru = Rum+ Ku*abs(Vdot);

Pu=Vdot*Rc+Pc;
VAdot=(Pc-PA)/Rs;
Vcdot=Vdot-VAdot;

dpdt =  [(Pao-Pu-Ru*Vdot)/I;      %Vdot
    (VAdot)/CA;                %Pel
    Vcdot;                         %Vc
    (VAdot-Pve/Rve)/Cve];          %Pve