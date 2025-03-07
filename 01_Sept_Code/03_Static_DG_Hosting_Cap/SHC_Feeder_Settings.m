%Feeder traits for Hosting_Cap_stream:
if feeder_NUM == 0
    %Bellhaven Hosting Cap---
    
    %1) Select load level:
    if SHC_LoadLVL == 1
        %Summer mean
        pu_load = 0.70;
        cir_name='_BELL_070.mat';
    elseif SHC_LoadLVL == 2
        %summer mean-2s
        pu_load = 0.48;
        cir_name='_BELL_048.mat';
    elseif SHC_LoadLVL == 3
        %winter mean
        pu_load = 0.62;
        cir_name='_BELL_062.mat';
    elseif SHC_LoadLVL == 4
        %winter mean-2s
        pu_load = 0.43;
        cir_name='_BELL_043.mat';
    end
    
    %2) Declare Energy meter settings:
    peak_current = [424.489787369243,385.714277946091,446.938766508963];
    peak_kW = 2940.857+2699.883+3092.130;
    energy_line = '258839833';
elseif feeder_NUM == 1
    %Commonwealth Hosting Cap---
    
    %1) Select load level:
    if SHC_LoadLVL == 1
        %Summer mean
        pu_load = 0.65;
        cir_name='_CMNW_065.mat';
    elseif SHC_LoadLVL == 2
        %summer mean-2s
        pu_load = 0.45;
        cir_name='_CMNW_045.mat';
    elseif SHC_LoadLVL == 3
        %winter mean
        pu_load = 0.55;
        cir_name='_CMNW_055.mat';
    elseif SHC_LoadLVL == 4
        %winter mean-2s
        pu_load = 0.40;
        cir_name='_CMNW_040.mat';
    end
    %2) Declare Energy meter settings:
    peak_current = [345.492818586166,362.418979727275,291.727365549702];
    peak_kW = 2473.691+2609.370+2099.989;
    energy_line = '259355408';
elseif feeder_NUM == 2
    %Flay Hosting Cap--
    
    %1) Select load level:
    if SHC_LoadLVL == 1
        %Summer mean
        pu_load = 0.50;
        cir_name='_FLAY_050.mat';
    elseif SHC_LoadLVL == 2
        %summer mean-2s
        pu_load = 0.30;
        cir_name='_FLAY_030.mat';
    elseif SHC_LoadLVL == 3
        %winter mean
        pu_load = 0.40;
        cir_name='_FLAY_040.mat';
    elseif SHC_LoadLVL == 4
        %winter mean-2s
        pu_load = 0.25;
        cir_name='_FLAY_025.mat';
    end
    %2) Declare Energy meter settings:
    peak_current = [196.597331353572,186.718068471483,238.090235458346];
    peak_kW = 1343.768+1276.852+1653.2766;
    energy_line = '259363665';
    
elseif feeder_NUM == 3
    %Roxboro 23kV--
    
    %1) Select load level:
    if SHC_LoadLVL == 1
        %Summer mean
        pu_load = 0.62;
        cir_name='_ROX_062.mat';
    elseif SHC_LoadLVL == 2
        %summer mean-2s
        pu_load = 0.42;
        cir_name='_ROX_042.mat';
    elseif SHC_LoadLVL == 3
        %winter mean
        pu_load = 0.50;
        cir_name='_ROX_050.mat';
    elseif SHC_LoadLVL == 4
        %winter mean-2s
        pu_load = 0.40;
        cir_name='_ROX_040.mat';
    end
    %2) Declare Energy meter settings:
    peak_current = [232.766663065503,242.994085721044,238.029663479192];
    peak_kW = 3189.476+3319.354+3254.487;
    energy_line = 'PH997__2571841';
elseif feeder_NUM == 4
    %Hollysprings 23kV
    
    %1) Select Load Level:
    if SHC_LoadLVL == 1
        %Summer mean
        pu_load = 0.54;
        cir_name='_HLLY_054.mat';
    elseif SHC_LoadLVL == 2
        %summer mean-2s
        pu_load = 0.25;
        cir_name='_HLLY_025.mat';
    elseif SHC_LoadLVL == 3
        %winter mean
        pu_load = 0.30;
        cir_name='_HLLY_030.mat';
    elseif SHC_LoadLVL == 4
        %winter mean-2s
        pu_load = 0.20;
        cir_name='_HLLY_020.mat';
    end
    %2) Declare Energy meter settings:
    peak_current = [263.73641240095,296.245661392728,201.389207853812];
    peak_kW=3189.476+3319.354+3254.488;
    energy_line = '10EF34__2663676';
elseif feeder_NUM == 5
    %E Raleigh 12.47kV
    
        %1) Select Load Level:
    if SHC_LoadLVL == 1
        %Summer mean
        pu_load = 0.75;
        cir_name='_ERAL_075.mat';
    elseif SHC_LoadLVL == 2
        %summer mean-2s
        pu_load = 0.56;
        cir_name='_ERAL_056.mat';
    elseif SHC_LoadLVL == 3
        %winter mean
        pu_load = 0.70;
        cir_name='_ERAL_070.mat';
    elseif SHC_LoadLVL == 4
        %winter mean-2s
        pu_load = 0.50;
        cir_name='_ERAL_050.mat';
    end
    %2) Declare Energy meter settings:
    peak_current = [214.80136594272,223.211693408696,217.825750072964];
    peak_kW=(1545.687+1606.278+1569.691);
    energy_line = 'PDP28__2843462';
end
    
        