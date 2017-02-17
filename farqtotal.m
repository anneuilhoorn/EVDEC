function [A,TotalGPP,Ra,NPP]=farqtotal(Na, T, pCO2, Tree, rw, y, LAI)
%% Metadata

% Name: farqtotal.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 01-06-2016
% Date last changes: 14-02-2017
% Description: Photosynthesis 

%% inputs

% T temperature (C)
Tk=T+273;


%% model constants --> Sharkey parameters

% CO2 compensation point in the absence of mitochondrial respiration (Pa)
%G_star=3.69+0.188.*(T-25)+0.0036.*(T-25).^2; %Matt Smith (equals 2.84) -->
%NOTE: in de Pury?? Ask Matt how he got this function
G_star=36.939667; %Sharkey
% activation energy for V (kJ/mol)
Ev=64800;
% universal gas consant (J/mol/K)
R=8.314;
% Solar irradiance (W/m2)
Sdir_theta=848.227;
% Epar (kJ/mol photon)
Epar=217.5;
% Jmax (umol C/m2 leaf/s, guestimate)
Jmax=65.11;
% Km (Sharkey)
Km=613.7629739;
% Rd (umol/m2/s)
Rd=0.34045;
%Constants for N per area dependency of photosynthesis (What was the reference???)
 if Tree==0
        a=34.05;
        b=9.71;
    else
        a=5.4;
        b=30.38;
 end
 
%% Loop of both (umol/m2/s)

fapar=[0.02519841;0.02458263;0.02400978;0.02342295;0.02277834;0.02220777;0.02163307;0.02105804;0.02051128;0.01994453;0.0194084;0.01888417;0.0183538;0.01784758;0.01736269;0.01686159;0.01637312;0.0158765;0.01540293;0.0149179];

TotalGPP=0;
layeramount=20;

for layer = 1:layeramount
    V25=a+b*Na; %umol C/m2 leaf/s, maximum Rubisco rate of carboxylation at 25C NOTE: later Na layer specific, vector
    Vcmax=V25*exp(((Tk-298)*Ev)/(R*Tk*298)); %umol C/m2 leaf/s
    Vcmax=Vcmax.*(LAI/layeramount); %Vcmax per layer 
    Av=max(0, Vcmax.*((pCO2-G_star)/(pCO2+Km))-Rd); %pCO2 in ppm
    
    
    aparsoil=fapar(layer).*Sdir_theta; %apar in W/m2 soil
    aparleaf=aparsoil/(LAI/layeramount); %apar in W/m2 leaf
    apar=aparleaf./Epar.*1000; %apar in umol photon/m2 leaf/s.
    J=(Jmax*0.28*apar)/sqrt(Jmax^2+0.28^2*apar^2); %(JSBach) J in umol C/m2 leaf/s
    Aj=max(0,J.*(pCO2-G_star)/(4.*(pCO2+2.*G_star))-Rd); %%Aj in umol C/m2 leaf/s NOTE: units van pCO2 en G_Star (Pa or ppm), gaswet (temp correctie)
        
    Alayer=min(Av,Aj); %umol C/m2 leaf/s
    
    Aumol = Alayer.*86400; %umol C/m2 leaf/s to umol C/m2 leaf/day (86400 sec in 1 day)
    
    A = Aumol*0.0000120107; %umol C/m2 leaf/day to g C/m2 leaf/day
    
     
    GPPlayer = A.*(layeramount./LAI); %in gC m-2 soil day-1
    
    TotalGPP = TotalGPP+GPPlayer;
    
    Nc=Na.*LAI; %gN/m2 soil/day = gN/m2 leaf/day .* m2 leaf/m2 soil
    Rm = rw.*Nc; %Maintenance respiration, after Ryan et al. 1996)
    %Rg = (1-y).*(TotalGPP-Rm); %Growth respiration
    %Ra = Rm + Rg; %All Respiration
    NPP = TotalGPP - Rm;
end
end