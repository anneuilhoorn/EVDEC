function [ WCRm, WCRNm, Reprm, ReprNm, NSCm, NSNm, LDMCm, LNm, PCm, PNm, FRm, FRNm ] = EnvLosses( WCRm, WCRNm, Reprm, ReprNm, NSCm, NSNm, LDMCm, LNm, PCm, PNm, FRm, FRNm )
%% Metadata

% Name: EnvLosses.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 07-03-2017
% Date last changes: 07-03-2017
% Description: Calculates the environmental losses (herbivory, wind, fire,
% etc.) of different tissue biomass for both N and C

%% Environmental losses

Loss_WCR = 0.5; % Loss percentage per year for wood and coarse roots for C and N
%Loss_Repr = 0; % Loss percentage per year for reproduction for C and N
%Loss_Storage = 0; % Loss percentage per year for storage for C and N
Loss_StrucLeaves = 2; % Loss percentage per year for structural leaves for C and N
Loss_PhotoLeaves = 2; % Loss percentage per year for photosynthetic leaves for C and N
Loss_FineRoots = 1.6; % Loss percentage per year for fine roots for C and N

%% Calculation of new biomass

% Wood/coarse roots (WCRm, WCRNm)
WCRm=WCRm.*((100-(Loss_WCR/365))/100);
WCRNm=WCRNm.*((100-(Loss_WCR/365))/100);

% Reproduction (Reprm, ReprNm)
Reprm=Reprm.*1;
ReprNm=ReprNm.*1;

% Storage (NSCm, NSNm)
NSCm=NSCm.*1;
NSNm=NSNm.*1;

% Structural leaves (LDMCm, LNm)
LDMCm=LDMCm.*((100-(Loss_StrucLeaves/365))/100);
LNm=LNm.*((100-(Loss_StrucLeaves/365))/100);

% Photosynthetic leaves (PCm, PNm)
PCm=PCm.*((100-(Loss_PhotoLeaves/365))/100);
PNm=PNm.*((100-(Loss_PhotoLeaves/365))/100);

% Fine roots (FRm, FRNm)
FRm=FRm.*((100-(Loss_FineRoots/365))/100);
FRNm=FRNm.*((100-(Loss_FineRoots/365))/100);

end

