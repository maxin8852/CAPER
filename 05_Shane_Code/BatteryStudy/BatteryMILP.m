% Driving Script for Battery MILP
clear
clc
%close all

global NODE SECTION PV BESS PARAM

tic
disp('Reading in Historical Data...')
%% Read in Historical Data

% Load Data
load('FlayLoad.mat');
% Data Characteristics
start = DATA(1).Date; % Date at which data starts
[nstp,~] = size(DATA(1).kW); % Number of Data points per row in struct
step = 24*60*60*(datenum(DATA(2).Date)-datenum(start))/nstp; % [s] - Resolution of data

% Dates to Simulate
%  2/3   - variable solar day, winter loadshape, light loading conditions
date1 = '2/3/2014';
DATA1 = DATA(datenum(date2)-datenum(start)+1);
%  10/15 - variable solar day, winter loadshape, light loading conditions
date3 = '10/15/2014';
DATA3 = DATA(datenum(date2)-datenum(start)+1);

%  5/24  - clear sky solar day, summer loadshape, light loading conditions
date2 = '5/24/2014';
DATA2 = DATA(datenum(date2)-datenum(start)+1);

%  11/23 - low irradiance solar day, winter loadshape, heavy loading conditions
date4 = '11/23/2014';
DATA4 = DATA(datenum(date2)-datenum(start)+1);

clear DATA

% PV Data
load('FlayPV.mat')
PVShape = mean(reshape(DATA(106).PV1,30,[]),1)';
figure;
plot(0:.5:24-.5,PVShape,'-k','LineWidth',2.5)
grid on;
xlim([0,24])
set(gca,'FontSize',10,'FontWeight','bold')
set(gca,'XTick',0:4:24)
xlabel(gca,'One Day [hrs]','FontSize',12,'FontWeight','bold')
ylabel(gca,'Load [pu]','FontSize',12,'FontWeight','bold')
title('High Penetratino PV Shape','FontWeight','bold','FontSize',12);

% PV Specifications
PV(1).Bus1 = '260007367';
PV(1).kW = 3000;
PV(1).pf = 1;

PV(2).Bus1 = '258406388';
PV(2).kW = 500;
PV(2).pf = 1;

% BESS Data
BESS.PR=1000;
BESS.ER=12121; %4000kWh
BESS.Er=0.67*BESS.ER;
BESS.etad=.967;
BESS.etac=.93;

toc
disp('Reading in Circuit Data...')
%% Read in Circuit Data
fid = fopen('pathdef.m');
rootlocation = textscan(fid,'%c')';
rootlocation = regexp(rootlocation{1}','C:[^.]*?CAPER\\','match','once');
fclose(fid);
fullfilename = [rootlocation,'07_CYME\Flay_ret_16271201.sxst'];

[NODE,SECTION,~,~,PARAM,~] = sxstRead(fullfilename);
% Removed Unnecessary Fields
NODE = rmfield(NODE,{'DSS','Capacitors','CapCtrl'});
SECTION = rmfield(SECTION,{'Recloser','Switch','Fuse','FuseCode',...
    'LineCode','DSS','Spacing','Wires','ReclCode','SwitchCode'});
% Remove Open points
SECTION = SECTION([SECTION.NormalStatus]);
% Remove End of feeder Nodes
[~,~,ic] = unique([{'264487210','264487418'},{NODE.ID}],'stable');
NODE(ic(3:end)<=2) = [];
% Load in positive sequence impedance data

% Loadshapes
PARAM.LoadTotal = sum([NODE.kW]);
PARAM.beta = [SumAVG;WinAVG]/PARAM.LoadTotal;
PARAM.gamma = PVShape;
PARAM.dt = 0.5; % hours
PARAM.kV = 12.47;

PARAM.SubBus = 'FLAY_RET_16271201';

toc
disp('Pre-Processing Data...')
%% Pre-Process Circuit Data
BatteryPreProcessing();

% Plot Reduced Graph
N = length(NODE);
S = length(SECTION);
MaxLoad = max([NODE.kW]);

fig = figure;
hold on

for i = 1:S
    index = [find(ismember({NODE.ID},SECTION(i).FROM)),find(ismember({NODE.ID},SECTION(i).TO))];
    plot([NODE(index).XCoord],[NODE(index).YCoord],'-k','LineWidth',2.5)
    hold on
end

for i = 1:N
    if NODE(i).kW>0
        h(3) = plot(NODE(i).XCoord,NODE(i).YCoord,'ko','MarkerSize',5*10^(NODE(i).kW/MaxLoad),...
            'MarkerFaceColor','w','LineStyle','none');
    end
end

% PV
[~,~,ic] = unique([{NODE.ID},{PV.Bus1}],'stable');
h(2) = plot([NODE(ic(end-1:end)).XCoord],[NODE(ic(end-1:end)).YCoord],'-y*',...
    'LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',[1 0.55 0],'LineStyle','none');

% Substation
index = ismember({NODE.ID},PARAM.SubBus);
h(1) = plot(NODE(index).XCoord,NODE(index).YCoord,'kh','MarkerSize',15,...
    'MarkerFaceColor',[0,0.5,1],'LineStyle','none');

set(gca,'YTick',[])
set(gca,'XTick',[])

legend(h,'Substation','PV','Loads')







toc
disp('Formulating Problem...')
%% Formulate Problem
[H,f,A,rl,ru,lb,ub,xint] = BatteryMILPForm();
%load('BaseCase.mat');

toc
disp('Solving LP...')
%% Solve Problem

[X,fval,exitflag,info] = opti_cplex(H,f,A,rl,ru,lb,ub,xint);
%load('BaseCase.mat')
disp(info)
disp(fval)

%% Parse out solution data
if exitflag==1
    toc
    disp('Parcing out Solution Data...')
    
    % Let x = [a;c;d;E;P;Pbar;r]
    
    n = length(NODE);
    s = length(SECTION);
    pv = length(PV);
    t = length(PARAM.beta);
    
    % Define starting indicies
    a       = 0;
    b       = a+n;
    c       = b+n*t;
    d       = c+n*t;
    E       = d+n*t;
    P       = E+n*(t+2);
    Pbar    = P+(s+1)*t;
    r       = Pbar+s*t;
    
    bat = find(X(a+1:a+n)>0.5);
    for i = 1:n
        NODE(i).a = X(a+i);
        NODE(i).c = X(c+t*(i-1)+(1:t));
        NODE(i).d = X(d+t*(i-1)+(1:t));
        NODE(i).E = X(E+(t+2)*(i-1)+(1:t+2));
    end
    
    for i = 1:s
        SECTION(i).P = X(P+t*(i-1)+(1:t));
        SECTION(i).Pbar = X(Pbar+t*(i-1)+(1:t));
        SECTION(i).r = X(r+t*(i-1)+(1:t));
    end
    
    Pg = X(P+s*t+(1:t));
    
    toc
    disp('Plotting Results...')
    %% Plot Results
    %PlotResults
    plot([NODE(bat).XCoord],[NODE(bat).YCoord],'-ko','MarkerSize',10,'MarkerFaceColor','c','LineStyle','none');
    
    figure;
    plot(0:.5:24,NODE(bat).E(1:t/2+1),'-k','LineWidth',2.5)
    hold on
    plot(0:.5:24,NODE(bat).E(t/2+2:end),'--k','LineWidth',2.5)
    grid on;
    xlim([0,24])
    set(gca,'FontSize',10,'FontWeight','bold')
    set(gca,'XTick',0:4:24)
    xlabel(gca,'One Day [hrs]','FontSize',12,'FontWeight','bold')
    ylabel(gca,'BESS State of Charge [kWh]','FontSize',12,'FontWeight','bold')
    title('BESS State of Charge','FontWeight','bold','FontSize',12);
    
    legend('Summer','Winter')
    
end    

toc