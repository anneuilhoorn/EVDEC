clearvars
clc
close all

%% Metadata

% Name: Daily_model.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 04-04-2016
% Date last changes: 14-06-2016
% Description: Models the daily net growth (C and N) of a single tree (evergreen (0) or deciduous (1))

%% Climate file

%Temperature


%% Evergreen or deciduous

%Evergreen = 0, Deciduous = 1

Tree = 0;

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

%% Variables and parameters

%Allocation fractions
fw=0.2; %fraction of C allocation allocated to stemwood (structural)
fnscs=0.1; %fraction of C allocation allocated to Non Structural Carbon in the stem (storage)
fp=0.05; %fraction of C allocation allocated to photosynthetic carbon (photosynthesis)
fldmc=0.3; %fraction of C allocation allocated to the Leaf Dry Matter Content (leaf structure)
fcr=0.1; %fraction of C allocation allocated to the coarse roots (structural)
ffr=0.2; %fraction of C allocation allocated to the fine roots and mycorrhiza (N/water uptake)
fnscr=0.05; %fraction of C allocation allocated to Non Structural Carbon in the roots (storage)

fwn=0.2; %fraction of N allocation allocated to stemwood (structural)
fnsns=0.1; %fraction of N allocation allocated to Non Structural Nitrogen in the stem (storage)
fpn=0.05; %fraction of N allocation allocated to photosynthetic nitrogen (photosynthesis)
fln=0.3; %fraction of N allocation allocated to the leaf (leaf structure)
fcrn=0.1; %fraction of N allocation allocated to the coarse roots (structural)
ffrn=0.2; %fraction of N allocation allocated to the fine roots and mycorrhiza (N/water uptake)
fnsnr=0.05; %fraction of N allocation allocated to Non Structural Nitrogen in the roots (storage)

%Canopy parameters
LAI=1; %Leaf area index (m2 leaf/m2 soil)
y = 0.7; %carbon efficiency (Choudhury, 2001) (no units)

%Respiration parameters
r = 0.031; %basic respiration rate per unit N (g C g-1 N day-1) (roughly after Reich et al., 2008)
qr = 1.2; %factor to compensate higher respiration per N in fine roots (Ryan et al., 1996)
fs = 1; %Nsapwood:Ncanopy ratio (look for number)
fr = 0.35; %Nfineroot:Ncanopy ratio (look for number)
rw = r.*(1+qr.*fr+fs); %Maintenance respiration per unit N in the canopy

%Turnover parameters
Wturnoverrate=0.025/365; %Turnoverrate of wood per day (after Whittaker et al., 1974)
CRturnoverrate=0.025/365; %Same as wood for now
%CRturnoverrate=(0.08.*CRm)/365; %Gill & Jackson, 2000
TObase = 0.789; %basic turnover rate (Hikosaka, 2005)
TOnitro = 0.191; %turnover rate influenced by root N (Hikosaka, 2005)
CRNturnoverrate=0.025/365; %Same as Carbon

%Variables
Nc=0.05; %THIS IS A RANDOM VALUE FOR TESTING!
Na=2; %THIS IS A RANDOM VALUE FOR TESTING!
RootN=0.05; %THIS IS A RANDOM VALUE FOR TESTING!
SRL=15; %Guestimate, in m root g-1 root
RC=0.5; %Fraction of root carbon content

%% Length of photosynthetic season

%Start of photosynthesis
% if Tree ==0
%     [ output_args ] = PhotoinhibEV( Td ); %output: starting day of photosynthesis
% else [ output_args ] = BudBurst( Td, NSCsm, NSCrm ); %from day of budburst until leaf dropping. NOTE: make a function for this?
% end

%End of photosynthesis
%Tree==1 --> when leaves fall of (gradient?)
%Tree==0 --> when photoinhibition is commenced (when is it too cold? Very
%species specific


%% Photosynthesis (Farquhar, 1980) --> Dependent on LAI and Na

%Ca=35; %The partial pressure of CO2 is 385 µmol/mol x 101.325 kPa
%(standard atm pressure at 25C) = 39 Pa --> temp correction
%pCO2=365*0.87; %intercellular partial pressure of CO2 (Pa) --> Excel Peter
V25=1; %Random

        
[A, SumAv, SumAj] = farqtotal(Na,20,pCO2,1,Tree);
               
 
%[A, SumAv, SumAj]=farq(Na, T, pCO2, V25, LAI) Matt


%% Nitrogen uptake --> NOTE: work on this in week 3 of June

relNuptake = 1; %??? Fixed value? Very different for different species, relNuptake in gN/m root/day
RL=(FRm./RC).*SRL; %RL in m root m-2 soil, FRm in gram C m-2 soil, SRL in m root g-1 root. NOTE: This should be in the loop for it to change with time. 
Nuptake = relNuptake.*RL; %Nuptake in gN/m2 soil/day, relNuptake in gN/m root/day, RL in m root/m2 soil

%% Model
 

for year=1:100
    for day=1:365 
        if Tree == 1
            LLS=150;
        else LLS=650;
        end
        
        %CARBON
        
        %[Td] = BudBurst(NSCsm, NSCrm);
        
        if day==90 && Tree==1 %BUDBURST --> Read in climate file and note          

            Mpc=1e-6.*PCm; %Photosynthetic carbon
            PCherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
            PCturnoverrate=(1/LLS); %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
            PCherbivory=PCm.*PCherbrate;
            PCturnover=PCm.*PCturnoverrate;
            PCin = fp.*NPP+(0.1.*BB); %Bud burst added on a yearly basis at beginning of fav season
            PCout = PCturnover+Mpc+PCherbivory; %Resorption added to out on a yearly basis at the end of fav season
            dPCdt=PCin-PCout;
            PCm=PCm+dPCdt;
            
            Mldmc=1e-6.*LDMCm; %Leaf Dry Matter Content
            LDMCherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
            LDMCturnoverrate=1/LLS; %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
            LDMCturnover=LDMCm.*LDMCturnoverrate;
            LDMCherbivory=LDMCm.*LDMCherbrate;
            LDMCall=fldmc.*NPP;
            LDMCin=LDMCall+(0.5.*BB);
            LDMCout=LDMCturnover+Mldmc+LDMCherbivory;%add a yearly layer of resorption out of the system // add relative herbivory
            dLDMCdt=LDMCin-LDMCout;
            LDMCm=LDMCm+dLDMCdt;
            
            Mfr=1e-6.*FRm; %Fine roots and mycorrhiza
            FRturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
            %FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
            FRturnover=FRm.*FRturnoverrate;
            FRall=ffr.*NPP;
            FRin=FRall+(0.4.*BB);
            FRout=FRturnover+Mfr;
            dFRdt=FRin-FRout;
            FRm=FRm+dFRdt;
            
            Mortnscs=1e-6.*NSCsm; %Non Structural Carbon in stem. A yearly cycle should be added for the leaf/root resorption into the NSCs at the end of the favourable season and the...
            %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
            NSCsall=fnscs.*NPP;
            NSCsout=Mortnscs+ADDS;
            NSCsin=NSCsall;
            dNSCsdt=NSCsin-NSCsout;
            NSCsm=NSCsm+dNSCsdt;
                        
            Mnscr=1e-6.*NSCrm; %Non Structural Carbon in roots. A yearly cycle should be added for the leaf/fine root resorption into the NSCs at the end of the favourable season and the...
            %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
            NSCrall=fnscr.*NPP;
            NSCrout=Mnscr+ADDR;
            NSCrin=NSCrall;
            dNSCrdt=NSCrin-NSCrout;
            NSCrm=NSCrm+dNSCrdt;
        end
                
        if day==270 && Tree==1 %RESORPTION
            FrR=0.7; %Fraction of Available NSC used for bud burst. NOTE: There is not a simple
            %distinction between available and unavailable NSC (Dietze et al., 2014)

            RESL=FrR.*LDMCm;
            RESPC=FrR.*PCm; %Resorption of leaf
            RESR=FrR.*FRm; %Resorption of root
            COST=(RESL+RESPC+RESR).*0.1; %10 percent cost of sugar to starch. NOTE: this is a fictional number, look up how much ATP this costs.

            TOTALR=(RESL+RESPC+RESR)-COST;

            Mpc=1e-6.*PCm; %Photosynthetic carbon
            PCherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
            PCturnoverrate=(1/LLS); %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
            PCherbivory=PCm.*PCherbrate;
            PCturnover=PCm.*PCturnoverrate;
            PCin = fp.*NPP; %Bud burst added on a yearly basis at beginning of fav season
            PCout = PCturnover+Mpc+PCherbivory+RESPC; %Resorption added to out on a yearly basis at the end of fav season
            dPCdt=PCin-PCout;
            PCm=PCm+dPCdt;
            
            Mldmc=1e-6.*LDMCm; %Leaf Dry Matter Content
            LDMCherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
            LDMCturnoverrate=1/LLS; %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
            LDMCturnover=LDMCm.*LDMCturnoverrate;
            LDMCherbivory=LDMCm.*LDMCherbrate;
            LDMCall=fldmc.*NPP;
            LDMCin=LDMCall;
            LDMCout=LDMCturnover+Mldmc+LDMCherbivory+RESL;%add a yearly layer of resorption out of the system // add relative herbivory
            dLDMCdt=LDMCin-LDMCout;
            LDMCm=LDMCm+dLDMCdt;
            
            Mfr=1e-6.*FRm; %Fine roots and mycorrhiza
            FRturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
            %FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
            FRturnover=FRm.*FRturnoverrate;
            FRall=ffr.*NPP;
            FRin=FRall;
            FRout=FRturnover+Mfr+RESR;
            dFRdt=FRin-FRout;
            FRm=FRm+dFRdt;
            
            Mortnscs=1e-6.*NSCsm; %Non Structural Carbon in stem. A yearly cycle should be added for the leaf/root resorption into the NSCs at the end of the favourable season and the...
            %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
            NSCsall=fnscs.*NPP;
            NSCsout=Mortnscs+ADDS;
            NSCsin=NSCsall+0.5.*TOTALR;
            dNSCsdt=NSCsin-NSCsout;
            NSCsm=NSCsm+dNSCsdt;
                        
            Mnscr=1e-6.*NSCrm; %Non Structural Carbon in roots. A yearly cycle should be added for the leaf/fine root resorption into the NSCs at the end of the favourable season and the...
            %bud burst at the beginning of the favourable season for deciduous species. I have to find out how resorption works in evergreen trees
            NSCrall=fnscr.*NPP;
            NSCrout=Mnscr+ADDR;
            NSCrin=NSCrall+0.5.*TOTALR;
            dNSCrdt=NSCrin-NSCrout;
            NSCrm=NSCrm+dNSCrdt;
        end
            
    Rm = rw.*Nc; %after Ryan et al., 1996
    GPP=A*LAI;
    Rg = (1-y).*(GPP-Rm);
    Ra=Rm+Rg;
    NPP=GPP-Ra;
    
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
    
    Totalstem=Wm+NSCsm; %Total C in stem
    
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
    PCherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
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
    
    %NITROGEN
    
    %Wturnoverrate=(Wm.*0.025)/365; %Turnoverrate of wood per day (after
    %Whittaker et al., 1974) -->becomes incredibly small
    WNturnover=WNm.*Wturnoverrate; %Wood. NOTE: same turnover rate as for carbon?
    Mw = 1e-6.*WNm;  %defineer als variabele bovenin (unit meegeven)
    WNall=fwn.*Nuptake; 
    WNin = WNall; %all in grams
    WNout = WNturnover + Mw; %all in grams
    dWNdt = WNin - WNout; %dWdt in grams per day
    WNm=WNm+dWNdt; %Wm in grams total,dWdt in grams per day 
    
    Mortnsns=1e-6.*NSCsm; %Non Structural Nitrogen in stem. 
    NSNsall=fnsns.*Nuptake;
    NSNsout=Mortnsns;
    NSNsin=NSNsall;
    dNSNsdt=NSNsin-NSNsout;
    NSNsm=NSNsm+dNSNsdt;
    
    TotalstemN=WNm+NSNsm; %Total N in stem
    
    Mcr=1e-6.*CRNm; %Coarse roots N
    CRNturnover=CRNm.*CRNturnoverrate;
    CRNall=fcrn.*Nuptake;
    CRNin=CRNall;
    CRNout=CRNturnover+Mcr;
    dCRNdt=CRNin-CRNout;
    CRNm=CRNm+dCRNdt;
    
    Mnsnr=1e-6.*NSNrm; %Non Structural N in roots. 
    NSNrall=fnsnr.*Nuptake;
    NSNrout=Mnsnr;
    NSNrin=NSNrall;
    dNSNrdt=NSNrin-NSNrout;
    NSNrm=NSNrm+dNSNrdt;
        
    Mfrn=1e-6.*FRNm; %Fine roots and mycorrhiza N
    FRNturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
    %FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
    FRNturnover=FRNm.*FRNturnoverrate;
    FRNall=ffr.*Nuptake;
    FRNin=FRNall;
    FRNout=FRNturnover+Mfrn;
    dFRNdt=FRNin-FRNout;
    FRNm=FRNm+dFRNdt;
    
    TotalrootsN=CRNm+NSNrm+FRNm; %Total N in roots
    
    Mln=1e-6.*LNm; %Leaf Dry Matter Content
    LNherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
    LNturnoverrate=1/LLS; %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    LNturnover=LNm.*LNturnoverrate;
    LNherbivory=LNm.*LNherbrate;
    LNall=fln.*NPP;
    LNin=LNall;
    LNout=LNturnover+Mln+LNherbivory;%add a yearly layer of resorption out of the system // add relative herbivory
    dLNdt=LNin-LNout;
    LNm=LNm+dLNdt;
    
    Mpn=1e-6.*PNm; %Photosynthetic carbon
    PNherbrate=0.003/365; %probability of 0.3 per year --> make function of LDMC/LeafC --> probability is not same as fraction
    PNturnoverrate=(1/LLS); %inverse of leaf life span --> make dependent on LDMC, Leaf C:N/Leaf N...;
    PNherbivory=PNm.*PNherbrate;
    PNturnover=PNm.*PNturnoverrate;
    PNin = fpn.*Nuptake; %Bud burst added on a yearly basis at beginning of fav season
    PNout = PNturnover+Mpn+PNherbivory; %Resorption added to out on a yearly basis at the end of fav season
    dPNdt=PNin-PNout;
    PNm=PNm+dPNdt;
    
    TotalcanopyN=LNm+PNm;
    
    ReprNall=fr.*Nuptake;
    ReprNin=ReprNall;
    ReprNout=ReprNall; %All reproductive biomass leaves the tree in the end, but some is subject to herbivory.
    %This influences the reproductive efficiency of the tree, but not its
    %biomass
    dReprNdt=ReprNin-ReprNout;
    ReprNm=ReprNm+dReprNdt;
    
    TotalbiomassN=WNm+NSNsm+CRNm+NSNrm+FRNm+LNm+PNm+ReprNm;
    
    
    end
    
end

figure(1);
x=[Totalbiomassinit Totalbiomass];
bar(x);
ylabel 'grams'
xlabel 'Totalbiomass start (1) and end (2)'



