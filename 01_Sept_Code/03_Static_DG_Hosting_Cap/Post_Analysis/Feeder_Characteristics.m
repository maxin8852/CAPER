%Feeder Characteristics subplots:
addpath('C:\Users\jlavall\Documents\GitHub\CAPER\04_DSCADA\Feeder_Data');
%Characteristics:
feeder_Name={'Bell','Common','Flay','Rox','Holly','E_Raleigh'};
feeder_Volt=[12.47,12.47,12.47,22.87,22.87,12.47];
feeder_PeakMW=zeros(1,6);%[9.529,7.9254,6.3586,0,0,0];
feeder_ValleyMW=zeros(1,6);
feeder_LTC_VREG=[1,1,1,6,1,1];
feeder_CAP_Fixed=zeros(1,6);
feeder_CAP_Switch=zeros(1,6);
feeder_length_mi=zeros(1,6);
feeder_length_ohm=zeros(1,6);
feeder_volt_peak_head=zeros(1,6);
feeder_volt_min_head=zeros(1,6);
feeder_conductor=zeros(1,6);
Load_Center_Resistance=zeros(1,6);




%subplot(4,4,1)
%1 - Bellhaven
n = 1;
load Annual_ls_BELL.mat
BELL_LS=MAX;
feeder_PeakMW(1,n)=(BELL_LS.YEAR.KW.A+BELL_LS.YEAR.KW.B+BELL_LS.YEAR.KW.C)/1000;
feeder_CAP_Fixed(1,n)=900;
feeder_CAP_Switch(1,n)=1800;
feeder_length_mi(1,n)=5.79*0.621371;
feeder_length_ohm(1,n)=1.38; %ohm
feeder_volt_peak_head(1,n)=0.053;
feeder_volt_min_head(1,n)=0.02;

feeder_conductor(1,n)=20.515; %mi
Load_Center_Resistance(1,n)=0.303; %ohm

load Annual_daytime_load_BELL.mat   %WINDOW.DAYTIME.KW.A
KW_3PH=WINDOW.DAYTIME.KW.A(:,1)+WINDOW.DAYTIME.KW.B(:,1)+WINDOW.DAYTIME.KW.C(:,1);
KW_3PH_MAX=0;
KW_3PH_MIN=100e6;
for i=1:1:length(KW_3PH)
    if KW_3PH(i,1) < KW_3PH_MIN
        KW_3PH_MIN = KW_3PH(i,1);
    end
    if KW_3PH(i,1) > KW_3PH_MAX
        KW_3PH_MAX = KW_3PH(i,1);
    end
end
feeder_ValleyMW(1,n)=KW_3PH_MIN/1e3;
conn_KVA(:,n) = [12508.900,12352.900,13176.900];
conn_KVA_P(:,n) = [32.885,32.475,34.641];
conn_CUST(:,n) = [85.33,14.67];
%{
Connected kVA:
 A:12508.900
 B:12352.900
 C:13176.900
Connected kVA(PU):
 A:32.885
 B:32.475
 C:34.641
R=85.330 % and C=14.670 %
%}


%%
%2 - Commonwealth
n = n + 1;
load Annual_ls_CMNWLTH.mat
CMN_LS=MAX;
feeder_PeakMW(1,n)=(CMN_LS.YEAR.KW.A+CMN_LS.YEAR.KW.B+CMN_LS.YEAR.KW.C)/1000;
feeder_CAP_Fixed(1,n)=300+600;
feeder_CAP_Switch(1,n)=0;
feeder_length_mi(1,n)=5.505*0.621371;
feeder_length_ohm(1,n)=2.3899; %ohm
feeder_volt_peak_head(1,n)=0.042;
feeder_volt_min_head(1,n)=0.026;
feeder_conductor(1,n)=16.055; %mi
Load_Center_Resistance(1,n)=0.658; %ohm

load Annual_daytime_load_CMNWLTH.mat   %WINDOW.DAYTIME.KW.A
KW_3PH=WINDOW.DAYTIME.KW.A(:,1)+WINDOW.DAYTIME.KW.B(:,1)+WINDOW.DAYTIME.KW.C(:,1);
KW_3PH_MAX=0;
KW_3PH_MIN=100e6;
for i=1:1:length(KW_3PH)
    if KW_3PH(i,1) < KW_3PH_MIN
        KW_3PH_MIN = KW_3PH(i,1);
    end
    if KW_3PH(i,1) > KW_3PH_MAX
        KW_3PH_MAX = KW_3PH(i,1);
    end
end
feeder_ValleyMW(1,n)=KW_3PH_MIN/1e3;
conn_KVA(:,n) = [6772.700,7520.700,6852.700];
conn_KVA_P(:,n) = [32.028,35.565,32.406];
conn_CUST(:,n) = [89.415,10.585];
%{
Connected kVA:
 A:6772.700
 B:7520.700
 C:6852.700
Connected kVA(PU):
 A:32.028
 B:35.565
 C:32.406
R=89.415 % and C=10.585 %
%}
%%
%3 - Flay
n = n + 1;
load Annual_ls_FLAY.mat
FLAY_LS=MAX;
feeder_PeakMW(1,n)=(FLAY_LS.YEAR.KW.A+FLAY_LS.YEAR.KW.B+FLAY_LS.YEAR.KW.C)/1000;
feeder_CAP_Fixed(1,n)=600;
feeder_CAP_Switch(1,n)=450;
feeder_length_mi(1,n)=13.4747*0.621371;
feeder_length_ohm(1,n)=11.1166;
feeder_volt_peak_head(1,n)=0.048;
feeder_volt_min_head(1,n)=0.014;
feeder_conductor(1,n)=55.876; %mi
Load_Center_Resistance(1,n)=1.008; %ohm 3.153

load Annual_daytime_load_FLAY.mat   %WINDOW.DAYTIME.KW.A
KW_3PH=WINDOW.DAYTIME.KW.A(:,1)+WINDOW.DAYTIME.KW.B(:,1)+WINDOW.DAYTIME.KW.C(:,1);
KW_3PH_MAX=0;
KW_3PH_MIN=100e6;
for i=1:1:length(KW_3PH)
    if KW_3PH(i,1) < KW_3PH_MIN
        KW_3PH_MIN = KW_3PH(i,1);
    end
    if KW_3PH(i,1) > KW_3PH_MAX
        KW_3PH_MAX = KW_3PH(i,1);
    end
end
%feeder_ValleyMW(1,n)=KW_3PH_MIN/1e3;
feeder_ValleyMW(1,n)=1200/1e3;
conn_KVA(:,n) = [5116.700,4839.200,6919.200];
conn_KVA_P(:,n) = [30.321,28.677,41.002];
conn_CUST(:,n) = [99.493,0.507];
%{
Connected kVA:
 A:5116.700
 B:4839.200
 C:6919.200
Connected kVA(PU):
 A:30.321
 B:28.677
 C:41.002
R=99.493 % and C=0.507 %
%}
%%
%4 - Roxboro
n = n + 1;
load Annual_ls_ROX.mat
%feeder_PeakMW(1,n)=9.763; %MW
feeder_PeakMW(1,n)=(MAX.YEAR.KW.A+MAX.YEAR.KW.B+MAX.YEAR.KW.C)/1000;
feeder_CAP_Fixed(1,n)=1200*3;
feeder_CAP_Switch(1,n)=0;
feeder_length_mi(1,n)=18.9893*0.621371;
feeder_length_ohm(1,n)=17.372;
feeder_volt_peak_head(1,n)=.037;
feeder_volt_min_head(1,n)=0.024;
feeder_conductor(1,n)=87.416; %mi
Load_Center_Resistance(1,n)=0.691; %ohm

load Annual_daytime_load_ROX.mat   %WINDOW.DAYTIME.KW.A
KW_3PH=WINDOW.DAYTIME.KW.A(:,1)+WINDOW.DAYTIME.KW.B(:,1)+WINDOW.DAYTIME.KW.C(:,1);
KW_3PH_MAX=0;
KW_3PH_MIN=100e6;
for i=1:1:length(KW_3PH)
    if KW_3PH(i,1) < KW_3PH_MIN
        KW_3PH_MIN = KW_3PH(i,1);
    end
    if KW_3PH(i,1) > KW_3PH_MAX
        KW_3PH_MAX = KW_3PH(i,1);
    end
end
feeder_ValleyMW(1,n)=KW_3PH_MIN/1e3;
conn_KVA(:,n) = [11547.333,12424.833,12044.833];
conn_KVA_P(:,n) = [32.061,34.497,33.442];
conn_CUST(:,n) = [97.421,2.579];
%{
Connected kVA:
 A:11547.333
 B:12424.833
 C:12044.833
Connected kVA(PU):
 A:32.061
 B:34.497
 C:33.442
R=97.421 % and C=2.579 %
%}

%%
%5 - Hollysprings
n = n + 1;
load Annual_ls_HOLLY.mat
%feeder_PeakMW(1,n)=10.35; %MW
feeder_PeakMW(1,n)=(MAX.YEAR.KW.A+MAX.YEAR.KW.B+MAX.YEAR.KW.C)/1000;
feeder_CAP_Fixed(1,n)=1200*2;
feeder_CAP_Switch(1,n)=0;
feeder_length_mi(1,n)=8.202*0.621371;
feeder_length_ohm(1,n)=8; %4.211
feeder_volt_peak_head(1,n)=0.026;
feeder_volt_min_head(1,n)=0.018;
Load_Center_Resistance(1,n)=0.915; %ohm (this is not correct)

load Annual_daytime_load_HOLLY.mat   %WINDOW.DAYTIME.KW.A
KW_3PH=WINDOW.DAYTIME.KW.A(:,1)+WINDOW.DAYTIME.KW.B(:,1)+WINDOW.DAYTIME.KW.C(:,1);
KW_3PH_MAX=0;
KW_3PH_MIN=100e6;
for i=1:1:length(KW_3PH)
    if KW_3PH(i,1) < KW_3PH_MIN
        KW_3PH_MIN = KW_3PH(i,1);
    end
    if KW_3PH(i,1) > KW_3PH_MAX
        KW_3PH_MAX = KW_3PH(i,1);
    end
end
feeder_ValleyMW(1,n)=KW_3PH_MIN/1e3;
conn_KVA(:,n) = [11684.500,6700.000,10412.500];
conn_KVA_P(:,n) = [40.575,23.266,36.158];
conn_CUST(:,n) = [97.153,2.847];
%{
Connected kVA:
 A:11684.500
 B:6700.000
 C:10412.500
Connected kVA(PU):
 A:40.575
 B:23.266
 C:36.158
R=97.153 % and C=2.847 %
%}


feeder_conductor(1,n)=60.358; %mi
%%
%6 - East Raleigh
n = n + 1;
load Annual_ls_ERALEIGH.mat
feeder_PeakMW(1,n)=(MAX.YEAR.KW.A+MAX.YEAR.KW.B+MAX.YEAR.KW.C)/1000;
feeder_CAP_Fixed(1,n)=200;
feeder_CAP_Switch(1,n)=0;
feeder_length_mi(1,n)=1.753*0.621371;
feeder_length_ohm(1,n)=0.308; %ohms
feeder_volt_peak_head(1,n)=0.022;
feeder_volt_min_head(1,n)=0.015;

Load_Center_Resistance(1,n)=0.1454; %ohms

load Annual_daytime_load_ERALEIGH.mat   %WINDOW.DAYTIME.KW.A
KW_3PH=WINDOW.DAYTIME.KW.A(:,1)+WINDOW.DAYTIME.KW.B(:,1)+WINDOW.DAYTIME.KW.C(:,1);
KW_3PH_MAX=0;
KW_3PH_MIN=100e6;
for i=1:1:length(KW_3PH)
    if KW_3PH(i,1) < KW_3PH_MIN
        KW_3PH_MIN = KW_3PH(i,1);
    end
    if KW_3PH(i,1) > KW_3PH_MAX
        KW_3PH_MAX = KW_3PH(i,1);
    end
end
feeder_ValleyMW(1,n)=KW_3PH_MIN/1e3;
conn_KVA(:,n) = [6258.333,6525.333,6133.333];
conn_KVA_P(:,n) = [33.083,34.495,32.422];
conn_CUST(:,n) = [39.344,60.656];
%{
Connected kVA:
 A:6258.333
 B:6525.333
 C:6133.333
Connected kVA(PU):
 A:33.083
 B:34.495
 C:32.422
R=39.344 % and C=60.656 %
%}
feeder_conductor(1,n)=1.531; %mi

%%
Labels={'Bellhaven','Commonwealth','Flay','Roxboro','Holly Springs','E.Raleigh'};
figure(1);
%-----------------------------
subplot(3,4,1);
ax = gca;
barh(feeder_Volt);
axis([0 40 0 7]);
ax.XTick = [0 10 20 30 40];
ax.YTickLabel = Labels;
set(gca,'FontWeight','bold');
xlabel('Voltage Class (kV)','FontWeight','bold');
ylabel('Feeder','FontSize',16);
%-----------------------------
subplot(3,4,2);
ax = gca;
barh(feeder_LTC_VREG);
axis([0 8 0 7]);
set(gca,'FontWeight','bold');
ax.XTick = [0 2 4 6 8];
ax.YTickLabel = Labels;
xlabel('LTC & Line Regulators','FontWeight','bold');
%-----------------------------
subplot(3,4,3);
barh(feeder_PeakMW);
axis([0 15 0 7]);
set(gca,'FontWeight','bold');
xlabel('Peak Load (MW)','FontWeight','bold');
%-----------------------------
subplot(3,4,4);
ax = gca;
barh(feeder_ValleyMW);
axis([0 5 0 7]);
set(gca,'FontWeight','bold');
ax.XTick = [0 1 2 3 4 5];
xlabel('Valley Day Load (MW)','FontWeight','bold');
%-----------------------------
subplot(3,4,5);
ax = gca;
barh(feeder_CAP_Fixed);
axis([0 4000 0 7]);
set(gca,'FontWeight','bold');
ax.XTick = [0 1000 2000 3000 4000];
xlabel('Fixed Caps (kVAR)','FontWeight','bold');
ylabel('Feeder','FontSize',16);
%-----------------------------
subplot(3,4,6);
barh(feeder_CAP_Switch);
axis([0 4000 0 7]);
set(gca,'FontWeight','bold');
xlabel('Swtch Caps (kVAR)','FontWeight','bold');
%-----------------------------
subplot(3,4,7);
ax = gca;
barh(feeder_volt_peak_head);
axis([0 0.125 0 7]);
set(gca,'FontWeight','bold');
ax.XTick = [0 0.025 0.05 0.075 0.100 0.125];
xlabel('Peak Load Headroom (Vpu)','FontWeight','bold');
%-----------------------------
subplot(3,4,8);
ax = gca;
barh(feeder_volt_min_head);
axis([0 0.125 0 7]);
set(gca,'FontWeight','bold');
ax.XTick = [0 0.025 0.05 0.075 0.100 0.125];
xlabel('Valley Load Headroom (Vpu)','FontWeight','bold');
%-----------------------------
subplot(3,4,9);
ax = gca;
barh(feeder_length_mi);
axis([0 15 0 7]);
set(gca,'FontWeight','bold');
ax.YTickLabel = Labels;
xlabel('End Distance (mi)','FontWeight','bold');
ylabel('Feeder','FontSize',16);
%-----------------------------
subplot(3,4,10);
barh(feeder_length_ohm);
axis([0 20 0 7]);
set(gca,'FontWeight','bold');
xlabel('End Resistance (ohm)','FontWeight','bold');
%-----------------------------
subplot(3,4,11);
barh(feeder_conductor);
axis([0 100 0 7]);
set(gca,'FontWeight','bold');
xlabel('Feeder Conductor (mi)','FontWeight','bold');
%-----------------------------
subplot(3,4,12);
barh(Load_Center_Resistance);
axis([0 3 0 7]);
set(gca,'FontWeight','bold');
xlabel('Load Center Resistance (ohm)','FontWeight','bold');
%%
figure(2)
%{
conn_KVA(:,n) = [6258.333,6525.333,6133.333];
conn_KVA_P(:,n) = [33.083,34.495,32.422];
conn_CUST(:,n) = [39.344,60.656];
%}
b = [1,2,3,4,5,6];
bar(b,conn_KVA_P','grouped');
Bb=ones(1,8)*33.33;
hold on
plot([0,1,2,3,4,5,6,7],Bb,'k--','LineWidth',3);
legend('Phase A','Phase B','Phase C');
xlabel('Feeder Number','FontWeight','bold','FontSize',12);
ylabel('Percent of Total kVA Capacity [%]','FontWeight','bold','FontSize',12);
axis([0 7 20 50]);
grid on
set(gca,'FontWeight','bold');

figure(3)
bar(b,conn_CUST','stacked');
xlabel('Feeder Number','FontWeight','bold','FontSize',12);
ylabel('Percent of Single Phase Loads [%]','FontWeight','bold','FontSize',12);
axis([0 7 0 120]);
grid on
set(gca,'FontWeight','bold');
legend('Residential','Commercial')
%%
figure(4)
AMP=zeros(6,7);
b = [0,200,400,600,800,1000];
AMP(1,1:6) = [2.61478509139000,3.96475087115000,4.94568441401000,0.0705815318900000,0,0];
AMP(2,1:6) = [2.35654951750000,1.64945417434000,2.77824294665000,0.104073428790000,0,0];
AMP(3,1:6) = [10.4713938016800,6.00718492073000,1.71739487948000,0,0,0];
AMP(4,1:6) = [6.80965130234758,1.34931346448420,0,4.52746072052400,1.89518155000000e-07,0];
AMP(5,1:6) = [0.897575479887360,0.0148394610546550,2.18165462807851,4.76185648134089,0,0];
AMP(6,1:6) = [0.326982853384776,2.17479850000000e-05,0.545888088691032,0.511174084279200,3.79036310000000e-06,0];

sum = 0;
for j=1:1:6
    for i=1:1:6
        sum = sum + AMP(j,i);
    end
    REACH(1,j)=sum;
    AMP(j,:)=AMP(j,:)/sum;
    sum = 0;
    AMP(j,7)=REACH(1,j);
end


    
    
%{
b = [1,2,3,4,5,6];
bar_handle = bar(b,AMP','grouped');
set(bar_handle(1),'FaceColor','b');
set(bar_handle(2),'FaceColor','g');
set(bar_handle(3),'FaceColor','r');
set(bar_handle(4),'FaceColor','c');
set(bar_handle(5),'FaceColor','m');
set(bar_handle(6),'FaceColor','k');
axis
%}



