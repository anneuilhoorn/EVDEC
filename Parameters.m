%% Metadata

% Name: Parameters.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 07-09-2016
% Date last changes: 28-09-2016
% Description: Holds all the parameters necessary for EVDEC.m

%% Pools

%Carbon pools (Check pool sizes
WCRm = 500; %Initial stemwood and coarse roots C mass (g/m2 soil)
NSCm = 100;  %Initial Non Structural Carbon in stem and root mass (g/m2 soil)  --> Only use slow reserves (starch)
FRm = 50; %Intitial Fine roots and mycorrhiza C mass (g/m2 soil)
LSCm = 100; %Initial Leaf Structural Carbon (g/m2 soil)
PCm = 30; %Initial Leaf Photoactive C mass (g/m2 soil)
Reprm = 20; %Initial Carbon in reproductive organs (g/m2 soil)

Lm=LSCm+PCm; %total leaf mass (g/m2 soil)

%Nitrogen pools
WCRNm = 60; %Initial stemwood N mass (g/m2 soil)
NSNm = 15; %Initial Non Structural Nitrogen in stem and root mass (g/m2 soil)
FRNm = 25; %Intitial Fine roots and mycorrhiza N mass (g/m2 soil)
LNm = 30; %Initial Leaf N (non-photosynthetic) (g/m2 soil)
PNm = 15; %Initial Leaf Photoactive N mass (g/m2 soil)
ReprNm = 5; %Initial nitrogen in reproductive organs (g/m2 soil)

%Nc=LNm+PNm; %total leaf mass (g/m2 soil)

%Soil pools
Nsoil = 6000; % in gN/m2 soil/day 

%% Photosynthesis

Ca=402.24; %in ppm. Change this to Pa for Boyle/Gay-Lussac temp dependence, incl all the corresponding equations. The partial pressure of CO2 is 402.24 µmol/mol x 101.325 kPa = 40.76 Pa
pCO2=0.78.*Ca; %Should I make this a gradient: [0.1:0.01:0.8]


%% Nitrogen 
Na=1.59; %Leaf N content per area (g m-2) (average value in Try database, Kattge et al. 2011) %We want to optimize this through the canopy
Nm=17.4; %Leaf N content per dry mass (mg g-1) (average value in Try database, Kattge et al. 2011)
CNratio=23.4; % Leaf carbon/nitrogen ratio (g g-1) (average value in Try database, Kattge et al. 2011)

%% Respiration

r = 0.031; %basic respiration rate per unit N (g C g-1 N day-1) (roughly after Reich et al., 2008)
qr = 1.2; %factor to compensate higher respiration per N in fine roots (Ryan et al., 1996)
fs = 0.6; %Nsapwood:Ncanopy ratio (look for number)
fr = 0.35; %Nfineroot:Ncanopy ratio (look for number)
rw = r.*(1+qr.*fr+fs); %Maintenance respiration per unit N in the canopy (g C g-1 N day-1)

%% Turnover

WCRturnoverrate=0.025/365; %Turnoverrate of wood per day (after Whittaker et al., 1974)
%CRturnoverrate=(0.08.*CRm)/365; %Gill & Jackson, 2000
TObase = 0.789; %basic turnover rate (Hikosaka, 2005)
TOnitro = 0.191; %turnover rate influenced by root N (Hikosaka, 2005)
WCRNturnoverrate=0.025/365; %Same as Carbon

%%

%Canopy parameters
SLA=16.6; %in mm2 mg-1 (average value in Try database, Kattge et al. 2011)
LMA=(1./SLA).*1000; % in g/m2 leaf. (.*1000 is to convert from mg/mm2 to g/m2). Poorter et al 2009: 30-300g/m2 --> this should become emergent
Cfraction=0.476; %Average Leaf C content per dry mass (g g-1) (average value in Try database, Kattge et al. 2011)

y = 0.7; %carbon efficiency (Choudhury, 2001) (no units)

RootN=0.00967; %Root nitrogen content per dry mass (g g-1) (average value in Try database, Kattge et al. 2011)
SRL=15; %Guestimate, in m root g-1 root
RC=0.5; %Fraction of root carbon content



%% Photoinhib/Budburst (mainly just counters)

Photo_poss=0; %Photosynthesis possible (1=Y, 0=N)
Tth=5; %Temperature threshold for photoinhibition (in degrees Celsius). This threshold varies per species and location. --> functie van temperatuur ipv locatieafhankelijk
Ttc=5; %Temperature threshold for photosynthesis (in degrees Celsius)
sumT5 = 0; %Photoinhibition off Counter
sumT4 = 0; %Photoinhibition on Counter
Tth1 = 0; %Cooling temperature threshold (in degrees Celsius)
Tth2 = 5; %Forcing temperature threshold (in degrees Celsius)
Sf=0; %State of forcing counter
Sc=0; %State of chilling counter
CD=0; %Chilling Days counter
GGD=0; %Starting point
Fall=0; %Leaf fall counter
NPP=0; %Starting point

