%User Input:
%clear
%clc
%close all
addpath('C:\Users\jlavall\Documents\GitHub\CAPER\01_Sept_Code\Result_Analysis');
base_dir='C:\Users\jlavall\Documents\GitHub\CAPER\03_OpenDSS_Circuits';
%feeder_NUM=3;
%Declare Varaibles needed:
BESS = 1;
if Feeder == 2
    %COMMON WEALTH
    mainFile ='C:\Users\jlavall\Documents\GitHub\CAPER\03_OpenDSS_Circuits\Commonwealth_Circuit_Opendss\Master.DSS'; 
    peak_current = [345.492818586166,362.418979727275,291.727365549702];
    energy_line = '259355408';
    sim_type=1;
    %Buses to display:
    %POI_loc=[4,74,251]; 
    POI_loc=[183,120,27];
    load HOSTING_CAP_CMNW.mat
    %0)  258896321 -> [399] & 10.MW MHC (1.0093ohm) / 183
    %1)  258896578 -> [310] & 7.1MW MHC (1.6761ohm) / 120
    %2)  263682007 -> [501] & 3.2MW MHC (2.7947ohm) /
    %3)  258903925 -> [71 ] & 4.5MW MHC (2.4509ohm) / 27
    if BESS == 1
        legal_buses{1,1}=num2str(MAX_PV.SU_MIN(POI_loc(1),9));%'258903893';
        legal_buses{2,1}=num2str(MAX_PV.SU_MIN(POI_loc(2),9));
        legal_buses{3,1}=num2str(MAX_PV.SU_MIN(POI_loc(3),9));
    else
        legal_buses{1,1}=num2str(MAX_PV.SU_MIN(POI_loc(2),9));
        legal_buses{2,1}=num2str(MAX_PV.SU_MIN(POI_loc(3),9));
        legal_buses{3,1}='258903900'; %600 F.C.
        legal_buses{4,1}='258903785'; %300 S.C.
    end
    
elseif Feeder == 3
    %FLAY
    mainFile ='C:\Users\jlavall\Documents\GitHub\CAPER\03_OpenDSS_Circuits\Flay_Circuit_Opendss\Master.dss';
    peak_current = [196.597331353572,186.718068471483,238.090235458346];
    energy_line = '259363665';
    %Locations:
    %POI_loc=[183,120,27];
    POI_loc=[143,164,46]; %46 to 116
    load HOSTING_CAP_FLAY.mat
    %0)  699613275 -> [482] & 3.7MW MHC (2.7748ohm) / 143
    %1)  258425294 -> [259] & 0.4MW MHC (6.5394ohm) / 45
    %2)  260007367 -> [522] & 0.4MW MHC (5.7497ohm) / 163
    if BESS == 1
        legal_buses{1,1}=num2str(MAX_PV.WN_MIN(POI_loc(1),9));%'258903893';
        legal_buses{2,1}=num2str(MAX_PV.WN_MIN(POI_loc(2),9));
        legal_buses{3,1}=num2str(MAX_PV.WN_MIN(POI_loc(3),9));
        legal_buses{4,1}='258425776'; %600kVAR Fixed Cap
        legal_buses{5,1}='258406388'; %300kVAR Switch cap
    else
        legal_buses{1,1}=num2str(MAX_PV.WN_MIN(POI_loc(2),9));
        legal_buses{2,1}=num2str(MAX_PV.WN_MIN(POI_loc(3),9));
        legal_buses{3,1}='258425776'; %600kVAR Fixed Cap
        legal_buses{4,1}='258406388'; %300kVAR Switch cap
    end
        
        
    
elseif Feeder == 4
    mainFile =strcat(base_dir,'\Mocksville_2_Circuit_Opendss\Master.dss');
    peak_current = [478,466.728,440];
    energy_line = '254432411';
    %Locations:
    legal_buses{1,1}='179695371';
    legal_buses{2,1}='165933146';
    legal_buses{3,1}='379186018';
    
end
%DSS Open:
[DSSCircObj, DSSText, gridpvPath] = DSSStartup;
DSSText.command = ['Compile "',mainFile];
DSSText.command = sprintf('New EnergyMeter.CircuitMeter LINE.%s terminal=1 option=R PhaseVoltageReport=yes',energy_line);
DSSText.command = sprintf('EnergyMeter.CircuitMeter.peakcurrent=[  %s   %s   %s  ]',num2str(peak_current(1,1)),num2str(peak_current(1,2)),num2str(peak_current(1,3)));
DSSText.command = 'Disable Capacitor.*';
DSSText.command = 'AllocateLoad';
DSSText.command = 'AllocateLoad';
DSSText.command = 'AllocateLoad';
DSSText.command = 'Enable Capacitor.*';

%Run at desired Load Level:
DSSText.command ='solve loadmult=0.5';
Buses =getBusInfo(DSSCircObj);
addBuses=legal_buses;
Bus2add =getBusInfo(DSSCircObj,addBuses,1);
BusesCoords = reshape([Bus2add.coordinates],2,[])';

%Start to plot the Circuit:
hf1 = figure(fig);
ax1 = axes('Parent',hf1);
hold on;
gcf=plotCircuitLines(DSSCircObj,'Coloring','numPhases','MappingBackground','none','CapacitorMarker','off');

set(gca,'xtick',[]);
set(gca,'ytick',[]);
%%
%Select desired season results:
%{
if sim_type == 1
    max_PV_Select=MAX_PV.SU_MIN;
elseif sim_type == 2
    max_PV_Select=MAX_PV.WN_MIN;
elseif sim_type == 3
    max_PV_Select=MAX_PV.SU_AVG;
elseif sim_type == 4
    max_PV_Select=MAX_PV.WN_AVG;
end
%Collect needed parameters from general 'max_PV_Select':
max_PVkw(:,1)=max_PV_Select(:,1);
max_PVkw(:,2)=max_PV_Select(:,9);
%}
%%

for i=1:1:length(addBuses)
    circ_size = 10;
    if BESS == 1
        if i == 1
            h_2 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ko','MarkerSize',circ_size,'MarkerFaceColor','g','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 2
            h_1 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ko','MarkerSize',circ_size,'MarkerFaceColor','r','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 3
            h_3 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ko','MarkerSize',circ_size,'MarkerFaceColor','b','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 4
            h_4 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ks','MarkerSize',circ_size,'MarkerFaceColor','b','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 5
            h_5 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ks','MarkerSize',circ_size,'MarkerFaceColor','m','LineStyle','none','DisplayName','Bottleneck');
            hold on
        end
    else
        if i == 1
            h_1 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ko','MarkerSize',circ_size,'MarkerFaceColor','r','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 2
            h_2 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ko','MarkerSize',circ_size,'MarkerFaceColor','g','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 3
            h_3 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ks','MarkerSize',circ_size,'MarkerFaceColor','b','LineStyle','none','DisplayName','Bottleneck');
            hold on
        elseif i == 4
            h_4 = plot(repmat(BusesCoords(i,2)',2,1),repmat(BusesCoords(i,1)',2,1),'ks','MarkerSize',circ_size,'MarkerFaceColor','m','LineStyle','none','DisplayName','Bottleneck');
            hold on
        end
    end
        
end

if BESS == 1
    legend([gcf.legendHandles,h_5',h_4',h_1',h_3',h_2'],[gcf.legendText,'600kVAR F.C.','450kVAR S.C.','DER-PV 1 (3MW)','DER-PV 2 (0MW)','BESS'] )
else
    if Feeder == 3
        legend([gcf.legendHandles,h_3',h_4',h_1',h_2'],[gcf.legendText,'600kVAR F.C.','450kVAR S.C.','POI-1 (3.0 MW)','POI-2 (0.5 MW)'] )
    elseif Feeder == 2
        legend([gcf.legendHandles,h_3',h_4',h_1',h_2'],[gcf.legendText,'600kVAR F.C.','300kVAR S.C.','POI-1 (7.1 MW)','POI-2 (4.5 MW)'] )
    end
end
    
