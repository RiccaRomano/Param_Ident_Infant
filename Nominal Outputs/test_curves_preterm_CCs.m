function [Vcw_range, Pel_range, VA_range, FRC, P_FRC, Ptot, VolN]=test_curves_preterm_CCs(pars)

TLC=pars(1);
RV=pars(2);
dw=pars(3);
cF=pars(4);
dF=pars(5);
k=pars(6);
nu=pars(7);
cw=pars(8);

VC=(TLC-RV);

Pel=transpose(-20:.01:35);

Frec=1./(1+exp(-(Pel-cF)/dF));
Vel=VC*(1-exp(-k*Pel));
VA=Frec.*Vel+RV;

Pel_range=Pel;
VA_range=VA;
Vel_range=Vel;
Frec_range=Frec;
save PVcurves.mat Pel_range VA_range Vel_range Frec_range



