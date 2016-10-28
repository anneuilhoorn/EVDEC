function [ Nuptake, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm ] = Nitrogen_mass( Nuptake, LLS, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm)
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
WCRNturnover=WCRNm.*WCRNturnoverrate; %Wood. NOTE: same turnover rate as for carbon?
Mwcr = 1e-6.*WCRNm;  %defineer als variabele bovenin (unit meegeven)
WCRNall=fwcrn.*Nuptake;
WCRNin = WCRNall; %all in grams
WCRNout = WCRNturnover + Mwcr; %all in grams
dWCRNdt = WCRNin - WCRNout; %dWdt in grams per day
WCRNm=WCRNm+dWCRNdt; %Wm in grams total,dWdt in grams per day

Mortnsn=1e-6.*NSNm; %Non Structural Nitrogen in stem.
NSNall=fnsn.*Nuptake;
NSNout=Mortnsn;
NSNin=NSNall;
dNSNdt=NSNin-NSNout;
NSNm=NSNm+dNSNdt;

Mfrn=1e-6.*FRNm; %Fine roots and mycorrhiza N
FRNturnoverrate=TObase+(TOnitro.*RootN); %(Hikosaka, 2005) --> CHECK THIS
%FRturnoverrate=(0.65.*FRm)/365; %Gill & Jackson, 2000
FRNturnover=FRNm.*FRNturnoverrate;
FRNall=ffr.*Nuptake;
FRNin=FRNall;
FRNout=FRNturnover+Mfrn;
dFRNdt=FRNin-FRNout;
FRNm=FRNm+dFRNdt;

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

ReprNall=fr.*Nuptake;
ReprNin=ReprNall;
ReprNout=ReprNall; %All reproductive biomass leaves the tree in the end, but some is subject to herbivory.
%This influences the reproductive efficiency of the tree, but not its
%biomass
dReprNdt=ReprNin-ReprNout;
ReprNm=ReprNm+dReprNdt;

TotalbiomassN=WCRNm+NSNm+FRNm+LNm+PNm+ReprNm;


end

