function [sols]=model_sol(pars,data)

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

VC=TLC-RV;
f=RR/60;  
T=1/f;

Init=data.Init;
ODE_TOL=data.ODE_TOL;
NP=data.NP;

PVcurve_pars=[TLC RV dw cF dF k nu cw]';
[Vcw_range,Pel_range,VA_Range,FRC,P_FRC,Ptot,VolN]=test_curves_preterm(PVcurve_pars); % Updates PVcurves.mat automatically, constructs lung/chest wall compliance relations

% Time span during one breath cycle
tprev=0;
tnext=tprev+T;
tstep=0.01;
tspan = tprev:tstep:tnext; %Creates timespan over which to solve DEs
t=0;

%Initialize solution
sols=Init;

Pmussave=0;
VT=zeros(NP,1);
VE=zeros(NP,1);
Cdyn=zeros(NP,1);
Cwdyn=zeros(NP,1);

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL);

for ii=1:NP
        [time,sol]=ode15s(@Model,tspan,Init,options,T,tprev,pars);
        t=[t;time(2:end)];
        sols=[sols; sol(2:end,:)];
        Init=[sol(end,1:4)];
        Peltemp=sol(2:end,2);
        maxPel=max(Peltemp);
        minPel=min(Peltemp);
        endPel=Peltemp(end);

        Frectemp=1./(1+exp(-(Peltemp-cF)/dF));
        fracOpen=max(Frectemp);
        minFrec=min(Frectemp);
        endFrec=Frectemp(end);
        Veltemp=VC*(1-exp(-k*Peltemp));
        VAtemp=Frectemp.*Veltemp+RV;
        VAmax=max(VAtemp);
        VAmin=min(VAtemp);
        Cdyn(ii)=(VAmax-VAmin)/(maxPel-minPel); % Dynamic lung compliance

        Vcwtemp=VAtemp+sol(2:end,3);
        Vcwmax=max(Vcwtemp);
        Vcwmin=min(Vcwtemp);
        imaxPcw=find(abs(Vcw_range-Vcwmax)<0.0001, 1, 'last' );
        iminPcw=find(abs(Vcw_range-Vcwmin)<0.0001, 1, 'last' );
        maxPcw=Pel_range(imaxPcw);
        minPcw=Pel_range(iminPcw);
        Cwdyn(ii)=(Vcwmax-Vcwmin)/(maxPcw-minPcw); % Dynamic chest wall compliance

        VT(ii)=VAmax-VAmin;
        VE(ii)=VT(ii)*f*60;
        Pmustemp=(Amus*cos(2*pi*f*(tspan-tprev))-Amus)';
        Pmussave=[Pmussave; Pmustemp(2:end)];

        tprev = tnext;
        tnext=tprev+T;
        tspan = tprev:tstep:tnext;
end
Vdot=sols(:,1);  Pel=sols(:,2);  Vc=sols(:,3); Pve=sols(:,4);

Frec=1./(1+exp(-(Pel-cF)/dF));
Vel=VC*(1-exp(-k*Pel));
VA=Frec.*Vel+RV;
Vcw=VA+Vc;

aw=RV;
bw=nu*VC/(log(exp(-cw/dw)+1));
Pcw=cw+dw*log(exp((Vcw-aw)/bw)-1);
Ptm=cc-dc*log(Vcmax./Vc-1);

Pmus=Pmussave;
Pldyn=Pel+Pve;
Ppl=Pcw+Pmus;
PA=Pldyn+Ppl;
Pc=Ptm+Ppl;

Rc =  Kc*(Vcmax./Vc).^2;
Rs =  Rsd*exp(Ks*(VA-RV)/(TLC-RV))+Rsm;
Ru = Rum+ Ku*abs(Vdot);

Pu=Vdot*Rc+Pc;
VAdot=(Pc-PA)./Rs;
Vcdot=Vdot-VAdot;


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

% start=101;
% figure(99)
% load PVcurves.mat
% plot(Pel_range,Vcw_range*1000,'b',Pel_range(2001:end),VA_range(2001:end)*1000,'r',Ptot(start:end),VolN(start:end)*1000,'m'); %,Pldyn(start:end)+Pcw(start:end),VA(start:end),'.'
% hold on
% plot(Pldyn(start:end),VA(start:end)*1000,'k','LineWidth',2)%'Color',[.6 .6 .6],
% plot(P_FRC,FRC*1000,-P_FRC,FRC*1000,'Color',[.4 .4 .4],'Linestyle',':')
% title('V'); legend('Tidal loop, normal R_u','Location','Southeast');%,,'Ptot v. VA',
% xlabel('Pressure')
% ylabel('Volume, ml')
% axis([-5 35 RV*1000 60])%TLC0*1000
% line([0 0],[0 60],'Color',[.7 .7 .7])
% line([-5 35],[FRC*1000 FRC*1000],'Color',[.4 .4 .4],'Linestyle',':')

% figure
% plot(t,Vc*1000,'.-',t,VA*1000,'.-',t,Vdot*1000,'.-',t,Vcw*1000,'.-')
% title('Volumes')
% legend('Vc','VA','Vdot','Vcw')
% 
% figure
% plot(t,Pmussave,'.',t,Pcw,'.',t,Ppl,'.',t,Pel,'.',t,PA,'.',t,Pldyn,'.')
% legend('Pmuss','Pcw','Ppl','Pel','PA','Pldyn')
% 
% Rc =  Kc*(Vcmax./Vc).^2;
% for k=1:length(Vdot)
%     if Vdot(k)<0
%         Ru(k) = (Rum+ Ku*abs(Vdot(k)))*10;%
%     else
%         Ru(k) = Rum+ Ku*abs(Vdot(k));
%     end
% end
% Ru=Ru';
% Rs =  Rsd*exp(Ks*(VA-RV)./(Vstarsave-RV))+Rsm;
% Rs=-1.4*(VA*1000-30)+14.5;
% Pu=Vdot.*Rc+Pc;
% Rtot=Rc+Ru+Rs;


% figure(100)
% subplot(511)
% plot(t,Pmussave); ylabel('P_{mus} (cmH_2O)'); %xlabel('time (s)')
% subplot(512)
% plot(t,Ppl); ylabel('P_{pl} (cmH_2O)'); %xlabel('time (s)')
% subplot(513)
% plot(t,PA); ylabel('P_A (cmH_2O)'); %xlabel('time (s)')
% subplot(514)
% plot(t,VA*1000); ylabel('V_A (ml)'); %xlabel('time (s)')
% subplot(515)
% plot(t,Vdot*1000); ylabel('Air flow (ml/s)'); xlabel('time (s)')
% % saveas(gcf,'States_highCw','png')

% 
% save states_highCw_normRu_0Pao.mat t Pmussave Ppl PA VA Vdot Pldyn

end
