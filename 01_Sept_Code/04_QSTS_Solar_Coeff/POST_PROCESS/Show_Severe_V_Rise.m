%Show_Severe_V_Rise
if Feeder == 2
    DAY_SRT = 97; %4/7 (mon)
    DAY_FIN = 103; %4/13 (sun)
elseif Feeder == 3
    DAY_SRT = 97; %4/7 (mon)
    DAY_FIN = 103; %4/13 (sun)
end
%-----------------------
n = 1;
addpath(path1);
if Feeder == 2
    load YR_SIM_P_CMNW_00.mat       %YEAR_SIM_P
    load YR_SIM_SUBV_CMNW_00.mat    %YEAR_SUB
    
elseif Feeder == 3
    load YR_SIM_P_FLAY_00.mat       %YEAR_SIM_P
    load YR_SIM_SUBV_FLAY_00.mat    %YEAR_SUB
    
end
RUN(n).WK_P(1:7) = YEAR_SIM_P(DAY_SRT:DAY_FIN);
RUN(n).WK_V(1:7) = YEAR_SUB(DAY_SRT:DAY_FIN);
clear YEAR_SIM_P YEAR_SUB 
n = 2;
addpath(path2);
if Feeder == 2
    load YR_SIM_P_CMNW_025.mat       %YEAR_SIM_P
    load YR_SIM_SUBV_CMNW_025.mat    %YEAR_SUB
    
elseif Feeder == 3
    load YR_SIM_P_FLAY_010.mat       %YEAR_SIM_P
    load YR_SIM_SUBV_FLAY_010.mat    %YEAR_SUB
    
end
RUN(n).WK_P(1:7) = YEAR_SIM_P(DAY_SRT:DAY_FIN);
RUN(n).WK_V(1:7) = YEAR_SUB(DAY_SRT:DAY_FIN);
clear YEAR_SIM_P YEAR_SUB 
n = 3;
addpath(path3);
if Feeder == 2
    load YR_SIM_P_CMNW_050.mat       %YEAR_SIM_P
    load YR_SIM_SUBV_CMNW_050.mat    %YEAR_SUB
    
elseif Feeder == 3
    load YR_SIM_P_FLAY_025.mat       %YEAR_SIM_P
    load YR_SIM_SUBV_FLAY_025.mat    %YEAR_SUB
    
end
RUN(n).WK_P(1:7) = YEAR_SIM_P(DAY_SRT:DAY_FIN);
RUN(n).WK_V(1:7) = YEAR_SUB(DAY_SRT:DAY_FIN);
clear YEAR_SIM_P YEAR_SUB 
%%
%Now lets plot just load:
fig = 0;
fig = fig + 1;
figure(fig);
i = 1;
SHIFT = 86399;
X=1/86400:1/86400:1;
for j=1:1:7
    %make 3ph MW & put in one column:
    FDR_3PH(i:i+SHIFT,1)=X+(j-1);
    
    FDR_3PH(i:i+SHIFT,2)=(RUN(1).WK_P(j).DSS_SUB(:,1)+RUN(1).WK_P(j).DSS_SUB(:,2)+RUN(1).WK_P(j).DSS_SUB(:,3))/1000;
    FDR_3PH(i:i+SHIFT,3)=(RUN(2).WK_P(j).DSS_SUB(:,1)+RUN(2).WK_P(j).DSS_SUB(:,2)+RUN(2).WK_P(j).DSS_SUB(:,3))/1000;
    FDR_3PH(i:i+SHIFT,4)=(RUN(3).WK_P(j).DSS_SUB(:,1)+RUN(3).WK_P(j).DSS_SUB(:,2)+RUN(3).WK_P(j).DSS_SUB(:,3))/1000;
    i = i + SHIFT;
end

h1=plot(FDR_3PH(:,1),FDR_3PH(:,2),'b-','LineWidth',5);
hold on
h3=plot(FDR_3PH(:,1),FDR_3PH(:,3),'g-','LineWidth',2);
hold on
h2=plot(FDR_3PH(:,1),FDR_3PH(:,4),'r-','LineWidth',1.5);


hold on
X_POS = 0.2;
Y1_POS = -2.5;
Y2_POS = -2.8;
for j=1:1:7
    text(X_POS,Y1_POS,sprintf('VI=%0.1f',M_PVSITE_SC(DAY_SRT+j-1,4)),'HorizontalAlignment','left','FontWeight','bold')
    hold on
    text(X_POS,Y2_POS,sprintf('CI=%0.1f',M_PVSITE_SC(DAY_SRT+j-1,5)),'HorizontalAlignment','left')
    hold on
    X_POS=X_POS+1;
end
X_POS = 0.2;
txt1= '\downarrow Overcast';
text(X_POS,2.75,txt1,'Color','b');
hold on
txt1= '\downarrow High Variability';
text(X_POS+1.15,2.4,txt1,'Color','b');
hold on
txt1= '\downarrow Clear';
text(X_POS+3.3,2.3,txt1,'Color','b');


axis([0 7 -3 5])
days={'4/7','4/8','4/9','4/10','4/11','4/12','4/13'};
set(gca,'XTick',[0:1:6],'XTickLabel',days);
if Feeder == 2
    legend('7.1MW @ POI1','4.5MW @ POI2','Location','SouthEast');
elseif Feeder == 3
    legend('No DER-PV','3.0MW @ POI1','0.5MW @ POI2','Location','NorthEast');
end
set(gca,'FontWeight','bold','FontSize',13);
grid on
ylabel('Three Phase Real Power (MW)','FontSize',14,'FontWeight','bold');
xlabel('Date','FontSize',12,'FontWeight','bold');
%-----------------------------------------------------
%%
fig = fig + 1;
figure(fig);
i = 1;
SHIFT = 4319;
X=1/4320:1/4320:1;
for j=1:1:7
    %make 3ph MW & put in one column:
    FDR_MAX(i:i+SHIFT,1)=X+(j-1);
    
    FDR_MAX(i:i+SHIFT,2)=(RUN(1).WK_V(j).max_V)';
    FDR_MAX(i:i+SHIFT,3)=(RUN(2).WK_V(j).max_V)';
    FDR_MAX(i:i+SHIFT,4)=(RUN(3).WK_V(j).max_V)';
    %   minimum voltage:
    FDR_MIN(i:i+SHIFT,2)=(RUN(1).WK_V(j).min_V)';
    FDR_MIN(i:i+SHIFT,3)=(RUN(2).WK_V(j).min_V)';
    FDR_MIN(i:i+SHIFT,4)=(RUN(3).WK_V(j).min_V)';
    i = i + SHIFT;
end
h1=plot(FDR_MAX(:,1),FDR_MAX(:,2),'b-','LineWidth',5);
hold on
h2=plot(FDR_MAX(:,1),FDR_MAX(:,3),'g-','LineWidth',1.5);
hold on
h3=plot(FDR_MAX(:,1),FDR_MAX(:,4),'r-','LineWidth',2);
hold on
h4=plot(FDR_MAX(:,1),FDR_MIN(:,2),'b--','LineWidth',2);
hold on
h5=plot(FDR_MAX(:,1),FDR_MIN(:,3),'g--','LineWidth',1.5);
hold on
h6=plot(FDR_MAX(:,1),FDR_MIN(:,4),'r--','LineWidth',1.5);
%   Settings:
if Feeder == 2
    legend('7.1MW @ POI1','4.5MW @ POI2','Location','SouthEast');
elseif Feeder == 3
    legend('No DER-PV (MaxV)','3.0MW @ POI1 (MaxV)','0.5MW @ POI2 (MaxV)','Location','NorthEast');
end
set(gca,'FontWeight','bold','FontSize',13);
grid on
ylabel('Min./Max. Observed Voltage (PU)','FontSize',14,'FontWeight','bold');
xlabel('kth Daytime Interval','FontSize',12,'FontWeight','bold');
axis([0 7 .99 1.10]);