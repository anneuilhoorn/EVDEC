function [ WCRm, Reprm, NSCm, LDMCm, PCm, FRm, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm ] = Biomass_allocation( NPP, Ngrowth, fWCR, fRepr, fNSC, fLDMC, fPC, fFR, fWCRN, fReprN, fNSN, fLN, fPN, fFRN, WCRm, Reprm, NSCm, LDMCm, PCm, FRm, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm )
%% Metadata

% Name: Biomass_allocation.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 06-09-2016
% Date last changes: 12-09-2016
% Description: Calculates carbon biomass after allocation


%% Parameters

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

Cfcroot = 0.3; %these are guestimate fractions! (Choudhury, 2001)
Cfcleaf = 0.2;
Cfcwood = 0.4;
Cfcstarch = 0.1;
Cfcfruit = 0.3;

Cfnroot = 0.3;
Cfnleaf = 0.2;
Cfnwood = 0.4;
Cfnstarch = 0.1;
Cfnfruit = 0.3;

%% Fractions to biomass (g C,N/m2 soil/day)

dWCRm = NPP * fWCR;
dNSCm = NPP * fNSC;
dReprm = NPP * fRepr;
dLDMCm = NPP * fLDMC;
dPCm = NPP * fPC;
dFRm = NPP * fFR;

dWCRNm = Ngrowth * fWCRN;
dNSNm = Ngrowth * fNSN;
dReprNm = Ngrowth * fReprN;
dLNm = Ngrowth * fLN;
dPNm = Ngrowth * fPN;
dFRNm = Ngrowth * fFRN;

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
  
    
end

