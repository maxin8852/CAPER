%Testing Cap_Ops Finder:
clear
clc
close all
UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 18);
%To be changed to user specific:
base_path = 'C:\Users\jlavall\Documents\GitHub\CAPER';
addpath(strcat(base_path,'\04_DSCADA\Feeder_Data'));
time_int = '1m';

%Menu to choose Feeder
feeder_NUM=menu('Which Feeder?','(BELL) Feeder 01','(CMNWH) Feeder 02','(FLAY) Feeder 03','(ROX) Feeder 04');
while feeder_NUM<1
    feeder_NUM=menu('Which Feeder?','(BELL) Feeder 01','(CMNWH) Feeder 02','(FLAY) Feeder 03','(ROX) Feeder 04');
end
plot_op=menu('Plot what?','none','base figures','Results of all derived Q','Chapter 4');
while plot_op<1
    plot_op=menu('Plot what?','none','base figures','Results of all derived Q','Chapter 4');
end

if feeder_NUM == 1
elseif feeder_NUM == 2
    cap_pos = 0; % Question??
    %   Select filtered annual dataset:
    load CMNWLTH.mat
    FEEDER = CMNWLTH;
    clearvars CMNWLTH
    kW_peak = [2.475021572579630e+03,2.609588847297235e+03,2.086659558753901e+03];
    Caps.Fixed(1)=600/3;
    Caps.Swtch(1)=300/3;
    %To be used for finding AllocationFactors for simulation:
    eff_KW(1,1) = 1;
    eff_KW(1,2) = 1;
    eff_KW(1,3) = 1;
    V_LTC = 124*60;
    polar = 1;
    root = 'CMNWLTH';
    root1 = 'CMNWLTH';
elseif feeder_NUM == 3
    cap_pos = 0; %used to be 1
    %   Select filtered annual dataset:
    load FLAY.mat
    FEEDER = FLAY;
    clearvars FLAY
    kW_peak = [1.424871573296857e+03,1.347528364235151e+03,1.716422704604557e+03];
    Caps.Fixed(1)=600/3;
    Caps.Swtch(1)=450/3;
    %To be used for finding AllocationFactors for simulation:
    eff_KW(1,1) = 0.9862;
    eff_KW(1,2) = 0.993;
    eff_KW(1,3) = 0.9894;
    V_LTC = 1.03*((12.47e3)/sqrt(3));
    polar = -1;
    % -- Flay 13.27km long --
    root = 'Flay';
    root1= 'Flay';
elseif feeder_NUM == 4
    cap_pos = 1;
    load ROX.mat
    FEEDER = ROX;
    clearvars ROX
    kW_peak = [3.189154306704542e+03,3.319270338767296e+03,3.254908188719974e+03];
    Caps.Fixed(1)=1200/3;
    Caps.Fixed(2)=1200/3;
    Caps.Fixed(3)=1200/3;
    eff_KW(1,1) = 1;
    eff_KW(1,2) = 1;
    eff_KW(1,3) = 1;
    V_LTC = 124*60;
    polar =1;
    root = 'ROX';
    root1 = 'ROX';
end
    
    
DAY_FIN=364;
if feeder_NUM < 4
    for DOY=1:1:DAY_FIN
        fprintf('\n%d DOY\n',DOY);

        %1] Declare duration & timestep:
        if strcmp(time_int,'1h') == 1
            t_int=0;
            s_step=3600;
            sim_num='24';
            fprintf('Sim. timestep=1hr\n');
        elseif strcmp(time_int,'1m') == 1
            t_int=1;
            s_step=60;
            sim_num='1440';
            %fprintf('Sim. timestep=60s\n');
        elseif strcmp(time_int,'30s') == 1
            t_int=2;
            s_step=30;
            sim_num='2880';
            fprintf('Sim. timestep=30s\n');
        elseif strcmp(time_int,'5s') == 1
            t_int=12;
            s_step=5;
            sim_num='17280';
            fprintf('Sim. timestep=5s\n');
        end
        [LOAD_ACTUAL,KVAR_ACTUAL]=Pull_DSCADA(DOY,FEEDER,t_int,sim_num,polar);
        [LOAD_ACTUAL_1,KVAR_ACTUAL_1]=Pull_DSCADA(DOY+1,FEEDER,t_int,sim_num,polar);
        %fprintf('%0.3f\n',KVAR_ACTUAL.data(1,1)/1000);
        %2]Find CAP ops:
        if feeder_NUM == 2
            [KVAR_ACTUAL,E,OPS]=Find_Cap_Ops_2(KVAR_ACTUAL,KVAR_ACTUAL_1,sim_num,s_step,Caps,LOAD_ACTUAL,LOAD_ACTUAL_1,cap_pos,DOY);
        elseif feeder_NUM == 3
            [KVAR_ACTUAL,E,OPS]=Find_Cap_Ops_1(KVAR_ACTUAL,KVAR_ACTUAL_1,sim_num,s_step,Caps,LOAD_ACTUAL,LOAD_ACTUAL_1,cap_pos);
        elseif feeder_NUM == 4
            [KVAR_ACTUAL,E,OPS]=Find_Cap_Ops_3(KVAR_ACTUAL,KVAR_ACTUAL_1,sim_num,s_step,Caps,LOAD_ACTUAL,LOAD_ACTUAL_1,cap_pos,DOY);
        end
        %3]Update capacitor position for next day:
        cap_pos = KVAR_ACTUAL.data(1440,4);

        %4]Save all results from Find_Cap_Ops in struct:
        CAP_OPS_STEP1(DOY).data = KVAR_ACTUAL.data; %CAP_Mult
        CAP_OPS_STEP1(1).datanames = KVAR_ACTUAL.datanames;
        CAP_OPS_STEP2(DOY).dP = KVAR_ACTUAL.dP;     %P_Mult
        CAP_OPS_STEP2(DOY).kW = LOAD_ACTUAL;
        CAP_OPS(DOY).error = E;                     %Q_Mult
        CAP_OPS(DOY).oper = OPS;
        CAP_OPS(DOY).PF = KVAR_ACTUAL.PF;
        CAP_OPS(DOY).DSS= KVAR_ACTUAL.DSS;

        %5]Capture the PF when operation occurs:
        PF=zeros(1,3);
        hold_PF = 1;
        for m=1:1:str2num(sim_num)-1
            if CAP_OPS(DOY).oper ~= 0
                if CAP_OPS_STEP1(DOY).data(m,4) ~= CAP_OPS_STEP1(DOY).data(m+1,4)
                    PF(1,hold_PF)=CAP_OPS_STEP1(DOY).data(m,6);
                    hold_PF = hold_PF + 1;
                end
            end
        end
        CAP_OPS(DOY).PF_op=PF;
    end
    CAP_OPS(1).datanames=KVAR_ACTUAL.datanames;
else
    DEP_Historical_CAP
    
        
end


%%
fig = 0;
if plot_op == 2
    figure(1)
    s = 1;
    for i=1:1:364
        Y = CAP_OPS_STEP1(i).data(1:1440,4);
        X = [s:1:1440+s-1]';
        X = X/1440;
        %plot(s+j,CAP_OPS(i).data(j,4));
        plot(X,Y)
        hold on
        s = s + 1440;
    end
    axis([0 365 -0.5 1.5])
    title('State of 450kVAR Swtch Cap');
    xlabel('Day of Year (DOY)');
    ylabel('1=Closed & 0=Opened');

    figure(2)
    s = 1;
    for i=1:1:50
        Y = CAP_OPS_STEP1(i).data(1:1440,7);
        X = [s:1:1440+s-1]';
        %plot(s+j,CAP_OPS(i).data(j,4));
        plot(X,Y)
        hold on
        s = s + 1440;
    end
    %
    figure(3)
    %Test DOY=51:
    T_DAY = 265;
    plot(CAP_OPS_STEP1(T_DAY).data(:,1),'r-')
    hold on
    plot(CAP_OPS_STEP1(T_DAY).data(:,2),'g-')
    hold on
    plot(CAP_OPS_STEP1(T_DAY).data(:,3),'b-')
    hold on
elseif plot_op == 3
    if feeder_NUM == 2 || feeder_NUM == 3
        plot(CAP_OPS_STEP1(T_DAY).data(:,4)*-1*Caps.Swtch,'k-','LineWidth',3);
        %
        figure(4)
        s = 1;
        for i=120:1:200
            Y = CAP_OPS_STEP1(i).data(1:1440,10);
            X = [s:1:1440+s-1]';
            %plot(s+j,CAP_OPS(i).data(j,4));
            plot(X,Y)
            hold on
            s = s + 1440;
        end
        fig = 4;
        %close all

        for i=1:1:10:341
            if CAP_OPS(i).oper ~= 0
                fig = fig + 1;
                figure(fig)
                T_DAY = i;
                plot(CAP_OPS_STEP1(T_DAY).data(:,1),'r-','LineWidth',3)
                hold on
                plot(CAP_OPS_STEP1(T_DAY).data(:,2),'g-','LineWidth',3)
                hold on
                plot(CAP_OPS_STEP1(T_DAY).data(:,3),'b-','LineWidth',3)
                hold on
                plot(CAP_OPS_STEP1(T_DAY).data(:,4)*-1*Caps.Swtch,'k-','LineWidth',3);
                hold on
                plot(CAP_OPS(T_DAY).DSS(:,1),'r--')
                hold on
                plot(CAP_OPS(T_DAY).DSS(:,2),'g--')
                hold on
                plot(CAP_OPS(T_DAY).DSS(:,3),'b--')
                hold on

                title(sprintf('DOY=%d',i));

            end
        end
    end
elseif plot_op == 4
    %This will be in Chapter 4
    T_DAY = 152;
    fig = fig + 1;
    figure(fig)
    plot(CAP_OPS_STEP1(T_DAY).data(:,10),'r-','LineWidth',3)
    hold on
    plot(CAP_OPS_STEP1(T_DAY).data(:,12),'b-','LineWidth',1.5)
    hold on
    X=1:1:1440;
    Y=202.5000*ones(1,1440);
    plot(X,Y,'k--','LineWidth',2);
    hold on
    plot(X,-1*Y,'k--','LineWidth',2);
    %Settings:
    legend('{\Delta}Q_{3{\phi}}','{\Delta}P_{3{\phi}}','Upper Q Bound','Lower Q Bound','Location','NorthWest');
    xlabel('Minute of Day','FontSize',12,'FontWeight','bold');
    ylabel('Derivative of Powers (P,Q) [kW & kVAR]','FontSize',12,'FontWeight','bold')
    axis([0 1440 -400 400])
    set(gca,'FontWeight','bold');
    
    fig = fig + 1;
    figure(fig)
    plot(CAP_OPS_STEP1(T_DAY).data(:,1),'r-','LineWidth',3)
    hold on
    plot(CAP_OPS_STEP1(T_DAY).data(:,2),'g-','LineWidth',3)
    hold on
    plot(CAP_OPS_STEP1(T_DAY).data(:,3),'b-','LineWidth',3)
    hold on
    plot(CAP_OPS(T_DAY).DSS(:,1),'r--','LineWidth',1.5)
    hold on
    plot(CAP_OPS(T_DAY).DSS(:,2),'g--','LineWidth',1.5)
    hold on
    plot(CAP_OPS(T_DAY).DSS(:,3),'b--','LineWidth',1.5)
    hold on
    plot(CAP_OPS_STEP1(T_DAY).data(:,4)*-1*Caps.Swtch,'k-','LineWidth',3);
    %Settings
    legend('DSCADA Qa','DSCADA Qb','DSCADA Qc','Derived Qa','Derived Qb','Derived Qc','Capacitor Q');
    xlabel('Minute of Day','FontSize',12,'FontWeight','bold');
    ylabel('Reactive Power (Q) [kVAR]','FontSize',12,'FontWeight','bold')
    axis([0 1440 -200 800]);
    set(gca,'FontWeight','bold');
    

    %1-min derivative of Q
end
%SAVE following structs as follows:
%{
CAP_Mult_60s_ = CAP_OPS
P_Mult_60s_ = CAP_OPS_STEP2
Q_Mult_60s_ = CAP_OPS_STEP1
%}
        
        
        

    
    