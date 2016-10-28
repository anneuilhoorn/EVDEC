%% Metadata

% Name: MassParameters.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 07-09-2016
% Date last changes: 07-09-2016
% Description: Holds all the parameters necessary for Carbon_mass.m

%% C Allocation fractions

fwcr=0.3; %fraction of C allocation allocated to stemwood and coarse roots (structural)
fnsc=0.15; %fraction of C allocation allocated to Non Structural Carbon in the stem and roots (storage)
fp=0.05; %fraction of C allocation allocated to photosynthetic carbon (photosynthesis)
flsc=0.25; %fraction of C allocation allocated to the Leaf Dry Matter Content (leaf structure)
ffr=0.2; %fraction of C allocation allocated to the fine roots and mycorrhiza (N/water uptake)
fr=0.05; %fraction of C allocation allocated to reproduction

%% N Allocation fractions

fwcrn=0.3; %fraction of N allocation allocated to stemwood and coarse roots (structural)
fnsn=0.15; %fraction of N allocation allocated to Non Structural Nitrogen in the stem and roots (storage)
fpn=0.05; %fraction of N allocation allocated to photosynthetic nitrogen (photosynthesis)
fln=0.3; %fraction of N allocation allocated to the leaf (leaf structure)
ffrn=0.2; %fraction of N allocation allocated to the fine roots and mycorrhiza (N/water uptake)


%% Turnover

WCRturnoverrate=0.025/365; %Turnoverrate of wood per day (after Whittaker et al., 1974)
%CRturnoverrate=(0.08.*CRm)/365; %Gill & Jackson, 2000
TObase = 0.789; %basic turnover rate (Hikosaka, 2005)
TOnitro = 0.191; %turnover rate influenced by root N (Hikosaka, 2005)
WCRNturnoverrate=0.025/365; %Same as Carbon

%% Canopy parameters

% LAI=1; %Leaf area index (m2 leaf/m2 soil)
% y = 0.7; %carbon efficiency (Choudhury, 2001) (no units)
% LMA=150; % in kgC m-2
Nc=0.05; %THIS IS A RANDOM VALUE FOR TESTING!
RootN=0.05; %THIS IS A RANDOM VALUE FOR TESTING!
SRL=15; %Guestimate, in m root g-1 root
RC=0.5; %Fraction of root carbon content