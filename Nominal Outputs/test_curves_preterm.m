function [Vcw_range, Pel_range, VA_range, FRC, P_FRC, Ptot, VolN]=test_curves_preterm(pars)

TLC=pars(1);
RV=pars(2);
dw=pars(3);
cF=pars(4);
dF=pars(5);
k=pars(6);
nu=pars(7);
cw=pars(8);

VC=(TLC-RV);

aw=RV;
bw=nu*VC/(log(1+exp(-cw/dw)));

Pel=transpose(-20:.01:35);
Pcw=transpose(-20:.01:35);

Frec=1./(1+exp(-(Pel-cF)/dF));
Vel=VC*(1-exp(-k*Pel));
VA=Frec.*Vel+RV;

Vcw=aw+bw*log(1+exp((Pcw-cw)/dw));

itemp_start=find(Pcw==-15);
iVcw_start=find(abs(Vcw-Vcw(itemp_start))<1e-5, 1, 'last' ); %volume Vcw at that index
iVA_start=find(abs(VA-Vcw(itemp_start))<1e-5, 1, 'last' ); %volume VA at the same index

itemp_end=find(abs(Vcw-TLC)<0.02,1, 'last');
iVcw_end=find(abs(Vcw-Vcw(itemp_end))<0.01, 1, 'last' );
iVA_end=find(abs(VA-Vcw(itemp_end))<1, 1, 'last' );

pcwt=Pcw(iVcw_start:iVcw_end);
vcwt=Vcw(iVcw_start:iVcw_end);
pelt=Pel(iVA_start:iVA_end);
vat=VA(iVA_start:iVA_end);

VolN=linspace(min(vat),max(vat),3000);
PelN=interp1(vat,pelt,VolN);
PcwN=interp1(vcwt,pcwt,VolN);
Ptot=PelN+PcwN;

[~,index]=min(abs(Ptot));
FRC=VolN(index);
P_FRC=PelN(index);

if isempty(P_FRC)
    idx=find(abs(vat-RV)<0.0001,1, 'last');
    P_FRC=PelN(idx);
end
Pel_range=Pel;
Vcw_range=Vcw;
VA_range=VA;
Vel_range=Vel;
Frec_range=Frec;
save PVcurves.mat Pel_range Vcw_range VA_range Ptot VolN FRC P_FRC Vel_range Frec_range

% figure
% plot(Pcw,Vcw,'b',Pel,VA,'r',Ptot,VolN,'m');%Pel,Vel+RV,'g',
% hold on
% plot(PcwN(index),FRC,'k*',PelN(index),FRC,'k*')
% axis([-10 35 RV TLC])
% line([0 0],[0 TLC],'Color',[.7 .7 .7])
% line([-10 35],[RV RV],'Color',[.4 .4 .4],'Linestyle','--')
% line([-10 35],[FRC FRC],'Color',[.4 .4 .4],'Linestyle',':')
% xlabel('Pressure')
% ylabel('Volume, ml')
% legend('Chest wall','Lung','Total (chest plus lung)','FRC','Location','best')



