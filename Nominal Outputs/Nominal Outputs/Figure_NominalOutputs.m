% Richard Foster
% Code that creates a figure for nominal model output tracings

clear
close all
clc

f1=figure('Position',[100 50 850 700]);
pl=tiledlayout(4,3);
pl.Padding="tight";
pl.TileSpacing="loose";

CC=hsv(3);

%% Panel with Muscle Pressure Tracings
n1=nexttile(1);
hold on
box on
grid on
load treatedResults_0CPAP.mat
start_idx=round(length(t)/2);
plot(t(start_idx:end)-5,Pmus(start_idx:end),'-k','LineWidth',2,'DisplayName','Treated');
load deficientResults_0CPAP.mat
plot(t(start_idx:end)-5,Pmus(start_idx:end),'Color',CC(1,:),'LineWidth',2,'LineStyle','--','DisplayName','Deficient');
set(gca,'FontSize',11);
ylabel('$\mathbf{P_{mus}}$\textbf{, cmH}$\mathbf{_2}$\textbf{O}','Interpreter','latex','FontWeight','bold','FontSize',14);

xlim([0 5]);

[leg,obj]=legend('show','Orientation','Vertical','Location','northoutside','Interpreter','latex','FontSize',14);
lineh = findobj(obj,'type','line');
set(lineh,'LineStyle','-');

%% Panel with Airflow Tracings
n2=nexttile(4);
hold on
box on
grid on
load treatedResults_0CPAP.mat
plot(t(start_idx:end)-5,Vdot(start_idx:end)*1000,'-k','LineWidth',2,'DisplayName','Treated');
load deficientResults_0CPAP.mat
plot(t(start_idx:end)-5,Vdot(start_idx:end)*1000,'Color',CC(1,:),'LineWidth',2,'DisplayName','Deficient');
set(gca,'FontSize',11);
ylabel('$\mathbf{\dot{V}}$\textbf{, ml/s}','Interpreter','latex','FontWeight','bold','FontSize',14);
xlim([0 5]);



%% Panel with Pleural Pressure Tracings
n3=nexttile(7);
hold on
box on
grid on
load treatedResults_0CPAP.mat
plot(t(start_idx:end)-5,Ppl(start_idx:end),'-k','LineWidth',2);
load deficientResults_0CPAP.mat
plot(t(start_idx:end)-5,Ppl(start_idx:end),'Color',CC(1,:),'LineWidth',2);
set(gca,'FontSize',11);
ylabel('$\mathbf{P_{pl}}$\textbf{, cmH}$\mathbf{_2}$\textbf{O}','Interpreter','latex','FontWeight','bold','FontSize',14);
xlim([0 5]);


%% Panel with Alveolar Volume Tracings
n4=nexttile(10);
hold on
box on
grid on
load treatedResults_0CPAP.mat
plot(t(start_idx:end)-5,VA(start_idx:end)*1000,'-k','LineWidth',2);
load deficientResults_0CPAP.mat
plot(t(start_idx:end)-5,VA(start_idx:end)*1000,'Color',CC(1,:),'LineWidth',2);
set(gca,'FontSize',11);
ylabel('$\mathbf{V_A}$\textbf{, ml}','Interpreter','latex','FontWeight','bold','FontSize',14);
xlim([0 5]);
xlabel('\textbf{Period, }$\mathbf{T}$','Interpreter','latex','FontWeight','bold','FontSize',14)







%% Panel with Treated Lung PV Curves
n5=nexttile(2,[2 2]);
hold on
box on
grid on
load treatedResults_0CPAP.mat
h(7)=line([0 0],[0 60],'Color',[.7 .7 .7],'HandleVisibility','off');
h(6)=plot(-P_FRC,FRC*1000,'Color',[.4 .4 .4],'Marker','*','HandleVisibility','off');
h(5)=plot(P_FRC,FRC*1000,'Color',[.4 .4 .4],'Marker','*','HandleVisibility','off');

h(8)=line([-5 35],[FRC*1000 FRC*1000],'Color',[.4 .4 .4],'Linestyle','--','DisplayName','FRC'); %Plot FRC

h(2)=plot(Pel_range,VA_Range*1000,'Color',[0.7 0.7 0.7],'LineWidth',2,'DisplayName','Lung, $V_A(P_{el})$'); %Plot Alveolar CC
h(3)=plot(Ptot,VolN*1000,'-.k','LineWidth',2,'DisplayName','Total Respiratory'); %Plot Total Respiratory System CC
h(4)=plot(Pldyn(start_idx:end),VA(start_idx:end)*1000,'Color',CC(2,:),'LineWidth',2,'DisplayName','$P_{ao}=0$ Tidal Loop'); %Plot Tidal Loop
h(1)=plot(Pel_range,Vcw_range*1000,'k','LineWidth',2,'DisplayName','Chest Wall, $V_{cw}(P_{cw})$'); %Plot Chest Wall CC

axis([-5 20 20 50]);
title('\textbf{Treated Lung}','Interpreter','latex');
ylabel('\textbf{Volume, ml}','Interpreter','latex');
set(gca,'FontSize',14);
load treatedResults_8CPAP.mat
h(9)=plot(Pldyn(start_idx:end),VA(start_idx:end)*1000,'Color',CC(3,:),'LineWidth',2,'DisplayName','$P_{ao}=8$ Tidal Loop');
legend([h(1) h(2) h(3) h(4) h(9) h(8)],'Interpreter','latex','Location','southeast')

%% Panel with Deficient Lung PV Curves
n6=nexttile(8,[2 2]);
load deficientResults_0CPAP.mat
hold on
box on
grid on
h(7)=line([0 0],[0 60],'Color',[.7 .7 .7],'HandleVisibility','off');
h(6)=plot(-P_FRC,FRC*1000,'Color',[.4 .4 .4],'Marker','*','HandleVisibility','off'); %Plot FRC
h(5)=plot(P_FRC,FRC*1000,'Color',[.4 .4 .4],'Marker','*','HandleVisibility','off');
h(8)=line([-5 35],[FRC*1000 FRC*1000],'Color',[.4 .4 .4],'Linestyle','--','DisplayName','FRC');

h(2)=plot(Pel_range,VA_Range*1000,'Color',[0.7 0.7 0.7],'LineWidth',2,'DisplayName','Lung'); %Plot Alveolar CC
h(3)=plot(Ptot,VolN*1000,'-.k','LineWidth',2,'DisplayName','Respiratory'); %Plot Total Respiratory System CC
h(4)=plot(Pldyn(start_idx:end),VA(start_idx:end)*1000,'Color',CC(2,:),'LineWidth',2,'DisplayName','Tidal Loop'); %Plot Tidal Loop
h(1)=plot(Pel_range,Vcw_range*1000,'k','LineWidth',2,'DisplayName','Chest Wall'); %Plot Chest Wall CC
axis([-5 20 20 50]);
title('\textbf{Deficient Lung}','Interpreter','latex');

xlabel('\textbf{Pressure, cmH}$\mathbf{_2}$\textbf{O}','Interpreter','latex')
ylabel('\textbf{Volume, ml}','Interpreter','latex');
load deficientResults_8CPAP.mat
plot(Pldyn(start_idx:end),VA(start_idx:end)*1000,'Color',CC(3,:),'LineWidth',2,'DisplayName','Tidal Loop');
set(gca,'FontSize',14)


pos=get(n1,'InnerPosition');
loc=[pos(1)-0.02 pos(2)+0.08 pos(3) pos(4)];
tex=annotation('textbox',loc,'String','A','FitBoxToText','on');
tex.LineStyle='none';
tex.FontSize=30;
tex.FontWeight='bold';

pos=get(n2,'InnerPosition');
loc=[pos(1)-0.02 pos(2)+0.08 pos(3) pos(4)];
tex=annotation('textbox',loc,'String','B','FitBoxToText','on');
tex.LineStyle='none';
tex.FontSize=30;
tex.FontWeight='bold';

pos=get(n3,'InnerPosition');
loc=[pos(1)-0.02 pos(2)+0.08 pos(3) pos(4)];
tex=annotation('textbox',loc,'String','C','FitBoxToText','on');
tex.LineStyle='none';
tex.FontSize=30;
tex.FontWeight='bold';

pos=get(n4,'InnerPosition');
loc=[pos(1)-0.02 pos(2)+0.08 pos(3) pos(4)];
tex=annotation('textbox',loc,'String','D','FitBoxToText','on');
tex.LineStyle='none';
tex.FontSize=30;
tex.FontWeight='bold';

pos=get(n5,'InnerPosition');
loc=[pos(1)-0.02 pos(2)+0.08 pos(3) pos(4)];
tex=annotation('textbox',loc,'String','E','FitBoxToText','on');
tex.LineStyle='none';
tex.FontSize=30;
tex.FontWeight='bold';

pos=get(n6,'InnerPosition');
loc=[pos(1)-0.02 pos(2)+0.08 pos(3) pos(4)];
tex=annotation('textbox',loc,'String','F','FitBoxToText','on');
tex.LineStyle='none';
tex.FontSize=30;
tex.FontWeight='bold';


saveas(f1,'NominalTracings.eps','epsc');
saveas(f1,'NominalTracings.png');
saveas(f1,'NominalTracings.fig');
saveas(f1,'NominalTracings.svg');