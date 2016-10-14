function [ NPP, Wm, NSCsm, CRm, NSCrm, FRm, LDMCm, PCm, Reprm ] = Carbon_mass( NPP, LLS, Wm, NSCsm, CRm, NSCrm, FRm, LDMCm, PCm, Reprm)
%% Metadata

% Name: Carbon_mass.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 06-09-2016
% Date last changes: 12-09-2016
% Description: Calculates carbon mass balance. This part is now non
% optimized. All pools should be optimized, except for stem. Stem should
% have a set allocation fraction of the carbon assimilated. Since there is
% no reason for the stem now (no competition), optimization will not take
% into account the importance of a stem.

%% Summary
%  This function calculates the carbon mass balance: allocation, turnover, herbivory,
%  mortality

%% Parameters

run('MassCParameters.m');

%% Mass balance

 %Wturnoverrate=(Wm.*0.025)/365; %Turnoverrate of wood per day (after
    %Whittaker et al., 1974) -->becomes incredibly small
    Wturnover=Wm.*Wturnoverrate; %Wood
    Mw = 1e-6.*Wm;  %defineer als variabele bovenin (unit meegeven) --> Mortaliteit klopt nog steeds niet. 
    Wall=fw.*NPP; 
    Win = Wall; %all in grams
    Wout = Wturnover + Mw; %all in grams
    dWdt = Win - Wout; %dWdt in grams per day
    Wm=Wm+dWdt; %Wm in grams total,dWdt in grams per day 
    
    Mortnscs=1e-6.*NSCsm; %Non Structural Carbon in stem. A yearly cycle should be added for the leaf/root resorption into the NSCs at the end of the favourable season and the...
    %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
    NSCsall=fnscs.*NPP;
    NSCsout=Mortnscs;
    NSCsin=NSCsall;
    dNSCsdt=NSCsin-NSCsout;
    NSCsm=NSCsm+dNSCsdt;
    
    Mcr=1e-6.*CRm; %Coarse roots
    CRturnover=CRm.*CRturnoverrate;
    CRall=fcr.*NPP;
    CRin=CRall;
    CRout=CRturnover+Mcr;
    dCRdt=CRin-CRout;
    CRm=CRm+dCRdt;
    
    Mnscr=1e-6.*NSCrm; %Non Structural Carbon in roots. A yearly cycle should be added for the leaf/fine root resorption into the NSCs at the end of the favourable season and the...
    %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
    NSCrall=fnscr.*NPP;
    NSCrout=Mnscr;
    NSCrin=NSCrall;
    dNSCrdt=NSCrin-NSCrout;
    NSCrm=NSCrm+dNSCrdt;
        
    Mfr=1e-6.*FRm; %Fine roots and mycorrhiza
    FRturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
    %FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
    FRturnover=FRm.*FRturnoverrate;
    FRall=ffr.*NPP;
    FRin=FRall;
    FRout=FRturnover+Mfr;
    dFRdt=FRin-FRout;
    FRm=FRm+dFRdt;
    
    Totalroots=CRm+NSCrm+FRm; %Total C in roots
    
    Mldmc=1e-6.*LDMCm; %Leaf Dry Matter Content
    LDMCherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
    LDMCturnoverrate=1/LLS; %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    LDMCturnover=LDMCm.*LDMCturnoverrate;
    LDMCherbivory=LDMCm.*LDMCherbrate;
    LDMCall=fldmc.*NPP;
    LDMCin=LDMCall;
    LDMCout=LDMCturnover+Mldmc+LDMCherbivory;%add a yearly layer of resorption out of the system // add relative herbivory
    dLDMCdt=LDMCin-LDMCout;
    LDMCm=LDMCm+dLDMCdt;
    
    Mpc=1e-6.*PCm; %Photosynthetic carbon
    PCherbrate=0.3/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
    PCturnoverrate=(1/LLS); %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    PCherbivory=PCm.*PCherbrate;
    PCturnover=PCm.*PCturnoverrate;
    PCin = fp.*NPP; %Bud burst added on a yearly basis at beginning of fav season
    PCout = PCturnover+Mpc+PCherbivory; %Resorption added to out on a yearly basis at the end of fav season
    dPCdt=PCin-PCout;
    PCm=PCm+dPCdt;
    
    Totalcanopy=LDMCm+PCm;
    
    Reprall=fr.*NPP;
    Reprin=Reprall;
    Reprout=Reprall; %All reproductive biomass leaves the tree in the end, but some is subject to herbivory.
    %This influences the reproductive efficiency of the tree, but not its
    %biomass
    dReprdt=Reprin-Reprout;
    Reprm=Reprm+dReprdt;
    
    Totalbiomass=Wm+NSCsm+CRm+NSCrm+FRm+LDMCm+PCm+Reprm;

end

