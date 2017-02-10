function [ NPP, LLS, WCRm, NSCm, FRm, LDMCm, PCm, Reprm ] = Carbon_mass( NPP, LLS, WCRm, NSCm, FRm, LDMCm, PCm, Reprm, dW, dNSC, dRepr, dPhotoC, dLDMC, dFR )
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

run('MassParameters.m');

%% Mass balance

 %Wturnoverrate=(Wm.*0.025)/365; %Turnoverrate of wood per day (after
    %Whittaker et al., 1974) -->becomes incredibly small
    WCRturnover=WCRm.*WCRturnoverrate; %Wood
    Mwcr = 1e-6.*WCRm;  %defineer als variabele bovenin (unit meegeven) --> Mortaliteit klopt nog steeds niet.  
    WCRin = dW; %all in grams
    WCRout = WCRturnover + Mwcr; %all in grams
    dWCRdt = WCRin - WCRout; %dWdt in grams per day
    WCRm=WCRm+dWCRdt; %Wm in grams total,dWdt in grams per day 
    
    Mortnsc=1e-6.*NSCm; %Non Structural Carbon in stem. A yearly cycle should be added for the leaf/root resorption into the NSCs at the end of the favourable season and the...
    %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
    NSCout=Mortnsc;
    NSCin=dNSC;
    dNSCdt=NSCin-NSCout;
    NSCm=NSCm+dNSCdt;
          
    Mfr=1e-6.*FRm; %Fine roots and mycorrhiza
    FRturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
    %FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
    FRturnover=FRm.*FRturnoverrate;
    FRin=dFR;
    FRout=FRturnover+Mfr;
    dFRdt=FRin-FRout;
    FRm=FRm+dFRdt;
    
     
    Mldmc=1e-6.*LDMCm; %Leaf Dry Matter Content
    a=1; %?????
    b=2; %?????
    LDMCherb=-a.*(LDMCm/(PCm+LDMCm))+b; %what are a and b??? Herbivory per day in g/m2 soil.
    LDMCturnoverrate=1/LLS; %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    LDMCturnover=LDMCm.*LDMCturnoverrate;
    LDMCherbivory=LDMCm.*LDMCherb;
    LDMCin=dLDMC;
    LDMCout=LDMCturnover+Mldmc+LDMCherbivory; %add a yearly layer of resorption out of the system // add relative herbivory
    dLDMCdt=LDMCin-LDMCout;
    LDMCm=LDMCm+dLDMCdt;
    
    Mpc=1e-6.*PCm; %Photosynthetic carbon
    PCherbrate=0.3/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
    PCturnoverrate=(1/LLS); %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    PCherbivory=PCm.*PCherbrate;
    PCturnover=PCm.*PCturnoverrate;
    PCin = dPhotoC; %Bud burst added on a yearly basis at beginning of fav season
    PCout = PCturnover+Mpc+PCherbivory; %Resorption added to out on a yearly basis at the end of fav season
    dPCdt=PCin-PCout;
    PCm=PCm+dPCdt;
    
    Totalcanopy=LDMCm+PCm;
    
    Reprin=dRepr;
    Reprout=dRepr; %All reproductive biomass leaves the tree in the end, but some is subject to herbivory.
    %This influences the reproductive efficiency of the tree, but not its
    %biomass
    dReprdt=Reprin-Reprout;
    Reprm=Reprm+dReprdt;
    
    Totalbiomass=WCRm+NSCm+FRm+LDMCm+PCm+Reprm;

end

