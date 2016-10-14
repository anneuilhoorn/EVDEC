function [ Nuptake, WNm, NSNsm, CRNm, NSNrm, FRNm, LNm, PNm, ReprNm ] = Nitrogen_mass( Nuptake, LLS, WNm, NSNsm, CRNm, NSNrm, FRNm, LNm, PNm, ReprNm)
%% Metadata

% Name: Nitrogen_mass.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 06-09-2016
% Date last changes: 12-09-2016
% Description: Calculates nitrogen mass balance

%% Summary
%  This function calculates the nitrogen mass balance: allocation, turnover, herbivory,
%  mortality

%% Parameters

run('MassParameters.m');

%% Function

%Wturnoverrate=(WNm.*0.025)/365; %Turnoverrate of wood per day (after
%Whittaker et al., 1974) -->becomes incredibly small
WNturnover=WNm.*Wturnoverrate; %Wood. NOTE: same turnover rate as for carbon?
Mw = 1e-6.*WNm;  %defineer als variabele bovenin (unit meegeven)
WNall=fwn.*Nuptake;
WNin = WNall; %all in grams
WNout = WNturnover + Mw; %all in grams
dWNdt = WNin - WNout; %dWdt in grams per day
WNm=WNm+dWNdt; %Wm in grams total,dWdt in grams per day

Mortnsns=1e-6.*NSNsm; %Non Structural Nitrogen in stem.
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
LNall=fln.*Nuptake;
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

