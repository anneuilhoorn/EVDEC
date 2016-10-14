%% Metadata

% Name: Parameters.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 07-09-2016
% Date last changes: 28-09-2016
% Description: Holds all the parameters necessary for EVDEC.m

%% Pools

%Carbon pools
Wm = 300000; %Initial stemwood C mass (g/m2 soil)
NSCsm = 100000;  %Initial Non Structural Carbon in stem mass (g/m2 soil)  --> Only use slow reserves (starch)
CRm = 100000; %Initial Coarse roots C mass (g/m2 soil)
NSCrm = 10000; %Initial Non Structural Carbon in roots, or root storage mass (g/m2 soil)
FRm = 50000; %Intitial Fine roots and mycorrhiza C mass (g/m2 soil)
LDMCm = 150000; %Initial Leaf Dry Matter Content (g/m2 soil)
PCm = 20000; %Initial Leaf Photoactive C mass (g/m2 soil)
Reprm = 10000; %Initial Carbon in reproductive organs (g/m2 soil)

Totalbiomassinit=740e3;

Lm=LDMCm+PCm; %total leaf mass (g/m2 soil)

%Nitrogen pools
WNm = 50000; %Initial stemwood N mass (g/m2 soil)
NSNsm = 10000; %Initial Non Structural Nitrogen in stem mass (g/m2 soil)
CRNm = 10000; %Initial Coarse roots N mass (g/m2 soil)
NSNrm = 5000; %Initial Non Structural Nitrogen in roots, or root storage mass (g/m2 soil)
FRNm = 2500; %Intitial Fine roots and mycorrhiza N mass (g/m2 soil)
LNm = 3000; %Initial Leaf N (non-photosynthetic) (g/m2 soil)
PNm = 1500; %Initial Leaf Photoactive N mass (g/m2 soil)
ReprNm = 500; %Initial nitrogen in reproductive organs (g/m2 soil)

%Nc=LNm+PNm; %total leaf mass (g/m2 soil)

%Soil pools
Nsoil = 1000; % in gN/m2 soil/day RANDOM NUMBER, LOOK UP BETTER INFO

%% Photosynthesis

Ca=402.24; %in ppm. Change this to Pa for Boyle/Gay-Lussac temp dependence, incl all the corresponding equations. The partial pressure of CO2 is 402.24 µmol/mol x 101.325 kPa = 40.76 Pa
pCO2=0.78.*Ca; %Should I make this a gradient: [0.1:0.01:0.8]


%% Nitrogen 
Na=75; %We want to optimize this through the canopy
%Na=(1.5+8.*LMA)./1000; %THIS IS A RANDOM VALUE FOR TESTING! Nitrogen per area --> function of LMA (in gN m-2) loskoppelen

%% Respiration

r = 0.031; %basic respiration rate per unit N (g C g-1 N day-1) (roughly after Reich et al., 2008)
qr = 1.2; %factor to compensate higher respiration per N in fine roots (Ryan et al., 1996)
fs = 0.6; %Nsapwood:Ncanopy ratio (look for number)
fr = 0.35; %Nfineroot:Ncanopy ratio (look for number)
rw = r.*(1+qr.*fr+fs); %Maintenance respiration per unit N in the canopy (g C g-1 N day-1)

%% Turnover

Wturnoverrate=0.025/365; %Turnoverrate of wood per day (after Whittaker et al., 1974)
CRturnoverrate=0.025/365; %Same as wood for now
%CRturnoverrate=(0.08.*CRm)/365; %Gill & Jackson, 2000
TObase = 0.789; %basic turnover rate (Hikosaka, 2005)
TOnitro = 0.191; %turnover rate influenced by root N (Hikosaka, 2005)
CRNturnoverrate=0.025/365; %Same as Carbon

%%

%Canopy parameters
LMA=150; % in g/m2 leaf Poorter et al 2009: 30-300g/m2 --> this should become emergent
%LMA=LeafThickness.*LeafDensity
%LAI=LDMCm./LMA; %Leaf area index (m2 leaf/m2 soil)
LAI=1;
y = 0.7; %carbon efficiency (Choudhury, 2001) (no units)

RootN=0.05; %THIS IS A RANDOM VALUE FOR TESTING!
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

