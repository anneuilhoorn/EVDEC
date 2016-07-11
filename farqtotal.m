function [A, Av, Aj]=farqtotal(Na, T, pCO2, LAI, Tree)
%% Metadata

% Name: farq_ev.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 01-06-2016
% Date last changes: 14-06-2016
% Description: Photosynthesis in evergreen trees

%% inputs
% T temperature (C)
Tk=T+273;
% pCO2 intercellular partial pressure of CO2 (Pa)
% V25 photosynthetic Rubisco capacity per unit leaf area at 25C (umol/m2/s)

%% model constants --> haal alles uit Sharkey qua parameters

% CO2 compensation point in the absence of mitochondrial respiration (Pa)
%G_star=3.69+0.188.*(T-25)+0.0036.*(T-25).^2; %Matt Smith (equals 2.84) -->
%NOTE: in de Pury?? Ask Matt how he got this function
G_Star=42.5; %JSBACH
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
% Km (JSBACH)
Km=752.7273;
% Rd (umol/m2/s)
Rd=0.34045;
% Intercept of Na for V25 (CONIFEROUS TREES)
%a=34.05;
% Slope of Na for V25 (CONIFEROUS TREES)
%b=9.71;

% Nitrogen per area;
%Na=1;

 if Tree==0
        a=34.05;
        b=9.71;
    else
        a=5.4;
        b=30.38;
 end

%% Rubisco limited photosynthesis rate (umol/m2/s)
% V dependency on temperature
SumAv = 0;

for layer=1:20
    V25=a+b*Na; %Per unit leaf area
    Vcmax=V25*exp(((Tk-298)*Ev)/(R*Tk*298)); %umol C/m2 leaf/s
    Vcmax=Vcmax.*LAI;
    Av=max(0, Vcmax.*((pCO2-G_Star)/(pCO2+Km))-Rd); %pCO2 in Pa of ppm? MS: Pa, PvB: ppm
    SumAv = SumAv + Av;
end



%% electron transport limited

fapar=[0.02519841;0.02458263;0.02400978;0.02342295;0.02277834;0.02220777;0.02163307;0.02105804;0.02051128;0.01994453;0.0194084;0.01888417;0.0183538;0.01784758;0.01736269;0.01686159;0.01637312;0.0158765;0.01540293;0.0149179];
SumAj=0;

for layer=1:20 
    %aparW (W/m2 leaf)
    aparsoil=fapar(layer).*Sdir_theta;
    %aparleaf
    aparleaf=aparsoil/0.05;
    %apar in umol photon/m2 leaf/s.
    apar=aparleaf./Epar.*1000;
    %J in umol C/m2 leaf/s
    J=(Jmax*0.28*apar)/sqrt(Jmax^2+0.28^2*apar^2); %(JSBach)
    %Aj in umol C/m2 leaf/s
    Aj=max(0,J.*(365.*0.87-G_Star)/(4.*(365.*0.87+2.*G_Star))-Rd); %NOTE: units van pCO2 en G_Star (Pa or ppm), gaswet (temp correctie)
    
    SumAj = SumAj + Aj;
    
end



%% overall photosynthesis rate (in umol/m2/s)
Ay=min(SumAv, SumAj);
A = ((Ay.*31.5E6).*12E-6)/365; %umol/m2/s to g/m2/da

end