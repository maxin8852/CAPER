%fix file sizes
clear
clc
addpath('C:\Users\jlavall\Documents\GitHub\CAPER\01_Sept_Code\04_QSTS_Solar_Coeff\03_FLAY\Three_Month_Runs\POI_1_Avg');
%load YR_SIM_CAPOP_FLAY_00.mat
%load YR_SIM_PQ_FLAY_00.mat
%load YR_SIM_LTC_FLAY_00.mat
%YEAR_SIM_V=YEAR_SIM_LTC.DSS_LTC_V;
%hold=YEAR_SIM_LTC.DSS_LTC_OP;
%clear YEAR_SIM_LTC
%YEAR_SIM_LTC_OP=hold;
load YR_SIM_Q_FLAY_010.mat

for DOY=1:1:120
    if DOY <= 60
        YEAR_SIM_Q_1(DOY).DSS_SUB=YEAR_SIM_Q(DOY).DSS_SUB;
    else
        YEAR_SIM_Q_2(DOY).DSS_SUB=YEAR_SIM_Q(DOY).DSS_SUB;
    end
end
%%
%{
YEAR_P(1).headers={'A','B','C'};
YEAR_Q(1).headers={'A','B','C'};
for DOY=1:1:364
    YEAR_P(DOY).P=YEAR_SIM_PQ(DOY).DSS_SUB_P;
    YEAR_Q(DOY).Q=YEAR_SIM_PQ(DOY).DSS_SUB_Q;
end
%}
YEAR_LTCV(1).headers={'A','B','C'};
YEAR_LTCOP(1).headers={'A','B','C'};
YEAR_CAPSTATUS(1).headers={'Cap position','Reactive Power Contributed'}';
YEAR_CAPCNTRL(1).headers={'Substation average PF','PF lead=1 & lag=0'}';
for DOY=1:1:364
    YEAR_SUB(DOY).V=YEAR_SIM_LTC(DOY).DSS_LTC_V; %YR_SIM_SUBV_FLAY_00
    YEAR_LTC(DOY).OP=YEAR_SIM_LTC(DOY).DSS_LTC_OP;
    YEAR_CAPSTATUS(DOY).CAP_POS=CAP_OPS_DSS(DOY).CAP_POS; %YR_SIM_CAP1_FLAY_00
    YEAR_CAPSTATUS(DOY).Q_CAP=CAP_OPS_DSS(DOY).Q_CAP;
    YEAR_CAPCNTRL(DOY).CTL_PF=CAP_OPS_DSS(DOY).CTL_PF; %YR_SIM_CAP2_FLAY_00
    YEAR_CAPCNTRL(DOY).LD_LG=CAP_OPS_DSS(DOY).LD_LG;
end
%YEAR_SIM(:).P=[YEAR_SIM_PQ(1:364).DSS_SUB_P];
%YEAR_SIM_Q=YEAR_SIM_PQ.DSS_SUB_Q;