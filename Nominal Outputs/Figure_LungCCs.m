%% FIGURE WITHOUT LABELS
clear
close all
clc

f1=figure('Position',[100,100,1450,400]);%,'InnerPosition',[100,100,984,407],'OuterPosition',[100,100,984,407])
pl=tiledlayout(1,3);
pl.Padding='loose';
pl.TileSpacing='compact';

%TREATED RESULTS
cF = 0.1; % Mean opening lung pressure
dF = 0.4; % Range opening lung pressure
k=0.07; % Elastic lung coefficient
TLC=0.001*63; % Total lung capacity
RV=0.001*23; % Residual volume
nu=0.25; %
cw=0; % Chest wall break point pressure coefficient
dw=0.48; % Chest wall compliance coefficient
PVcurve_pars=[TLC RV dw cF dF k nu cw]';
test_curves_preterm_CCs(PVcurve_pars); % Updates PVcurves.mat automatically, constructs lung/chest wall compliance relations
load PVcurves.mat

n1=nexttile(1);
hold on
grid on
box on
plot(Pel_range,Vel_range*1000,'-k','LineWidth',3);
set(gca,'FontSize',18);
ylabel('$\mathbf{V_{el}}$, \textbf{ml}','Interpreter','latex','FontWeight','bold','FontSize',20);
xlim([-20 30]);
ylim([0 60]);
xticks([-20 -10 0 10 20 30]);

n2=nexttile(2);
hold on
grid on
box on
plot(Pel_range,Frec_range,'-k','LineWidth',3);
set(gca,'FontSize',18);
ylabel('$\mathbf{F_{rec}}$','Interpreter','latex','FontWeight','bold','FontSize',20);
xlim([-20 30]);
xticks([-20 -10 0 10 20 30]);

n3=nexttile(3);
hold on
grid on
box on
plot(Pel_range,VA_range*1000,'-k','LineWidth',3);
set(gca,'FontSize',18);
ylabel('$\mathbf{V_A}$, \textbf{ml}','Interpreter','latex','FontWeight','bold','FontSize',20);
xlim([-20 30]);
xticks([-20 -10 0 10 20 30]);

% DEFICIENT RESULTS

cF=8; % Mean opening lung pressure, cmH2O, IN MU VARY
dF=3; % Range of lung pressure constitutive equation, IN MU VARY
k=0.04; % Elastic lung coefficient, IN MU VARY
TLC=0.001*53; % Total lung capacity, in L, IN MU VARY
RV=0.001*23; % Residual volume, in L
nu=0.25; % IN MU VARY
cw=0; % Chest wall break point pressure coefficient
dw=0.48; % Chest wall compliance coefficient, IN MU VARY
PVcurve_pars=[TLC RV dw cF dF k nu cw]';
test_curves_preterm_CCs(PVcurve_pars); % Updates PVcurves.mat automatically, constructs lung/chest wall compliance relations
load PVcurves.mat

nexttile(1);
plot(Pel_range,Vel_range*1000,'-r','LineWidth',3);

nexttile(2);
plot(Pel_range,Frec_range,'-r','LineWidth',3);

nexttile(3);
plot(Pel_range,VA_range*1000,'-r','LineWidth',3);


xlabel(pl,'$\mathbf{P_{el}}$, \textbf{cmH}$\mathbf{_2}$\textbf{O}','Interpreter','latex','FontWeight','bold','FontSize',20);
leg=legend('Treated','Deficient','Location','eastoutside','Orientation','vertical','Interpreter','latex','FontSize',20);

saveas(f1,'LungCCs_nolabels.eps','epsc');
saveas(f1,'LungCCs_nolabels.png');
saveas(f1,'LungCCs_nolabels.fig');
saveas(f1,'LungCCs_nolabels.svg');
