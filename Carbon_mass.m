function [ NPP, LLS, WCRm, NSCm, FRm, LDMCm, PCm, Reprm ] = Biomass_allocation( TotalGPP, fWCR, fRepr, fNSC, fLDMC, fPC, fFR, fWCRN, fReprN, fNSN, fLN, fPN, fFRN, WCRm, Reprm, NSCm, LDMCm, PCm, FRm, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm )
%% Metadata

% Name: Biomass_allocation.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 06-09-2016
% Date last changes: 12-09-2016
% Description: Calculates carbon biomass after allocation


%% Parameters

run('MassParameters.m');
% %Cfc & Cfn differ per organ/leafing strategy --> find good values in
% %literature, also this is not per m2 soil!!!!!
% if Tree==1 
%     Cfcroot = 9.42; %g C/g root (Martinez et al., 2002)
%     Cfcleaf = 8.76; %g C/g leaf (Villar & Merino, 2001)
% else Cfcroot = 10.68; %g C/g root (Martinez et al., 2002)
%      Cfcleaf = 9.3; %g C/g leaf (Villar & Merino, 2001)
% end
% Cfcwood=15; %guestimate
% Cfcstarch=9; %guestimate
% Cfcfruit=9; %guestimate
% 
% 
% if Tree==1 
%     Cfnroot = 9.42; %g C/g root (Martinez et al., 2002)
%     Cfnleaf = 8.76; %g C/g leaf (Villar & Merino, 2001)
% else Cfnroot = 10.68; %g C/g root (Martinez et al., 2002)
%      Cfnleaf = 9.3; %g C/g leaf (Villar & Merino, 2001)
% end
% Cfnwood=15; %guestimate
% Cfnstarch=9; %guestimate
% Cfnfruit=9; %guestimate

dWCRm = 0;
dReprm = 0;
dNSCm = 0;
dLDMCm = 0;
dPCm = 0;
dFRm = 0;

dWCRNm = 0;
dReprNm = 0;
dNSNm = 0;
dLNm = 0;
dPNm = 0;
dFRNm = 0;

Cfcroot = 0.1; %these are guestimate fractions!
Cfcleaf = 0.15;
Cfcwood = 0.3;
Cfcstarch = 0.1;
Cfcfruit = 0.1;

Cfnroot = 0.1;
Cfnleaf = 0.15;
Cfnwood = 0.3;
Cfnstarch = 0.1;
Cfnfruit = 0.1;

%% Fractions to biomass (g C,N/m2 soil/day)

dWCRm = TotalGPP * fWCR;
dNSCm = TotalGPP * fNSC;
dReprm = TotalGPP * fRepr;
dLDMCm = TotalGPP * fLDMC;
dPCm = TotalGPP * fPC;
dFRm = TotalGPP * fFR;

dWCRNm = Nuptake * fWCRN;
dNSNm = Nuptake * fNSN;
dReprNm = Nuptake * fReprN;
dLNm = Nuptake * fLN;
dPNm = Nuptake * fPN;
dFRNm = Nuptake * fFRN;

%% Minus growth respiration (g C,N/m2 soil)

dWCRm = dWCRm * (1-Cfcwood);
dNSCm = dNSCm * (1-Cfcstarch);
dReprm = dReprm * (1-Cfcfruit);
dLDMCm = dLDMCm * (1-Cfcleaf);
dPCm = dPCm * (1-Cfcleaf);
dFRm = dFRm * (1-Cfcroot);

dWCRNm = dWCRNm * (1-Cfnwood);
dNSNm = dNSNm * (1-Cfnstarch);
dReprNm = dReprNm * (1-Cfnfruit);
dLNm = dLNm * (1-Cfnleaf);
dPNm = dPNm * (1-Cfnleaf);
dFRNm = dFRNm * (1-Cfnroot);

%% Mass balance (g C,N/m2 soil)

% Wood and coarse roots
WCRm = WCRm + dWCRm;
WCRNm = WCRNm + dWCRNm;

% Storage
NSCm = NSCm + dNSCm;
NSNm = NSNm + dNSNm;

% Reproduction
Reprm = Reprm + dReprm;
ReprNm = ReprNm + dReprNm;

% Leaves
LDMCm = LDMCm + dLDMCm;
PCm = PCm + dPCm;

LNm = LNm + dLNm;
PNm = PNm + dPNm;

% Fine roots
FRm = FRm + dFRm;
FRNm = FRNm + dFRNm;
  
    WCRin = dWCRm; %all in grams
    WCRout = WCRturnover;% + Mwcr; %all in grams
    dWCRdt = WCRin - WCRout; %dWdt in grams per day
    WCRm=WCRm+dWCRdt; %Wm in grams total,dWdt in grams per day 
    
   % Mortnsc=1e-6.*NSCm; %Non Structural Carbon in stem. A yearly cycle should be added for the leaf/root resorption into the NSCs at the end of the favourable season and the...
    %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
    NSCout=0;%Mortnsc;
    NSCin=dNSCm;
    dNSCdt=NSCin-NSCout;
    NSCm=NSCm+dNSCdt;
          
    %Mfr=1e-6.*FRm; %Fine roots and mycorrhiza
    FRturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
    %FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
    FRturnover=FRm.*FRturnoverrate;
    FRin=dFRm;
    FRout=FRturnover;%+Mfr;
    dFRdt=FRin-FRout;
    FRm=FRm+dFRdt;
    
     
    %Mldmc=1e-6.*LDMCm; %Leaf Dry Matter Content
    a=1; %?????
    b=2; %?????
    LDMCherb=-a.*(LDMCm/(PCm+LDMCm))+b; %what are a and b??? Herbivory per day in g/m2 soil.
    LDMCturnoverrate=1/LLS; %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    LDMCturnover=LDMCm.*LDMCturnoverrate;
    LDMCherbivory=LDMCm.*LDMCherb;
    LDMCin=dLDMCm;
    LDMCout=LDMCturnover+LDMCherbivory;%Mldmc+ %add a yearly layer of resorption out of the system // add relative herbivory
    dLDMCdt=LDMCin-LDMCout;
    LDMCm=LDMCm+dLDMCdt;
    
    %Mpc=1e-6.*PCm; %Photosynthetic carbon
    PCherbrate=0.3/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
    PCturnoverrate=(1/LLS); %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    PCherbivory=PCm.*PCherbrate;
    PCturnover=PCm.*PCturnoverrate;
    PCin = dPhotoC; %Bud burst added on a yearly basis at beginning of fav season
    PCout = PCturnover+PCherbivory;%Mpc+ %Resorption added to out on a yearly basis at the end of fav season
    dPCdt=PCin-PCout;
    PCm=PCm+dPCdt;
    
    Totalcanopy=LDMCm+PCm;
    
    Reprin=dReprm;
    Reprout=dReprm; %All reproductive biomass leaves the tree in the end, but some is subject to herbivory.
    %This influences the reproductive efficiency of the tree, but not its
    %biomass
    dReprdt=Reprin-Reprout;
    Reprm=Reprm+dReprdt;
    
    Totalbiomass=WCRm+NSCm+FRm+LDMCm+PCm+Reprm;

end

