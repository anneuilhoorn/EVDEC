function [ dW, dNSC, dRepr, dPhotoC, dLDMC, dFR, dWN, dNSN, dReprN, dPhotoN, dLN, dFRN ] = Allocation( Cfixed, Nuptake, Tree, LLS, Fall, Rm )

%% Metadata

% Name: Allocation.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 14-01-2016
% Date last changes: 30-01-2016
% Description: Calculates the allocation amounts to the different organs

%% Summary
%  function to calculate allocation priority and amounts for all organs
%  (leaves, fine roots & mycorrhiza, storage, stem & coarse roots

%Input variables are all pools (both C and N)

%% Constants & Variables

%NC ratios (Sitch et al., 2003)
NCratiostem = 0.003;
NCratioroot = 0.034;
NCratiofruit = 0.034;
NCratioleaf = 0.034;
Call = 0.2;
Nall = 0.2;

%Cfc & Cfn differ per organ/leafing strategy --> find good values in literature
if Tree==1 
    Cfcroot = 9.42; %g C/g root (Martinez et al., 2002)
    Cfcleaf = 8.76; %g C/g leaf (Villar & Merino, 2001)
else Cfcroot = 10.68; %g C/g root (Martinez et al., 2002)
     Cfcleaf = 9.3; %g C/g leaf (Villar & Merino, 2001)
end
Cfcwood=15; %guestimate
Cfcstarch=9; %guestimate
Cfcfruit=9; %guestimate


if Tree==1 
    Cfnroot = 9.42; %g C/g root (Martinez et al., 2002)
    Cfnleaf = 8.76; %g C/g leaf (Villar & Merino, 2001)
else Cfnroot = 10.68; %g C/g root (Martinez et al., 2002)
     Cfnleaf = 9.3; %g C/g leaf (Villar & Merino, 2001)
end
Cfnwood=15; %guestimate
Cfnstarch=9; %guestimate
Cfnfruit=9; %guestimate

%LLS left
LLSleft = LLS - Fall;

%% Overall

%Take Cfixed (GPP) and Nuptake values from main model

% Cfixed = dWm + dNSCm + dFRm + dLDMCm + dPCm + dReprm
% Nuptake = dWNm + dNSNm + dFRNm + dLNm + dPNm + dReprNm

if Cfixed > Rm %What is X?
    NSCtreshold = 0.1;
else NSCtreshold = 0;
end
    
dW = 0.3.*Cfixed; %in g C m-2 soil
dNSC= max(0,NSCtreshold).*Cfixed; %in g C m-2 soil
dRepr = 0; %in g C m-2 soil
dLDMC = (0.002.*LLSleft-0.1).*Cfixed; %Linear function of relation LDMC allocation and LLS left %in g C m-2 soil
dPhotoC = Call.*Cfixed; %Optimization %in g C m-2 soil
dFR = Cfixed - dW - dNSC - dLDMC - dRepr; %in g C m-2 soil

%Allocation to fine roots is moslty dependent on the amount of nitrogen uptake. So
%the function of C allocation to FRm is dependent on Nuptake. If Nuptake is
%big enough to keep up with C then there will be less allocation to roots.
% Negative relationship with FRNm 

dWN = NCratiostem * dW * (1-Cfcwood) / (1 - Cfnwood); %in g N m-2 soil
dFRN = NCratioroot * dFR * (1-Cfcroot) / (1-Cfnroot); %in g N m-2 soil
dReprN = NCratiofruit * dRepr * (1-Cfcfruit) / (1-Cfnfruit); %always 0 for now, %in g N m-2 soil
dLN = NCratioleaf * dLDMC * (1-Cfcleaf) / (1 - Cfnleaf); %in g N m-2 soil
dPhotoN = Nall; %Optimization %in g N m-2 soil
dNSN = Nuptake - dWN - dFRN - dLN - dReprN; %in g N m-2 soil

%% Construction costs

dWcc = dW * (1-Cfcwood);
dNSCcc = dNSC * (1-Cfcstarch);
dReprcc = dRepr * (1-Cfcfruit);
dLDMCcc = dLDMC * (1-Cfcleaf);
dPhotoCcc = dPhotoC * (1-Cfcleaf);
dFRcc = dFR * (1-Cfcroot);

dWNcc = dWN * (1-Cfnwood);
dNSNcc = dNSN * (1-Cfnstarch);
dReprNcc = dReprN * (1-Cfnfruit);
dLNcc = dLN * (1-Cfnleaf);
dPhotoNcc = dPhotoN * (1-Cfnleaf);
dFRNcc = dFRN * (1-Cfnroot);

%% Total allocation

dWN = dWN - dWNcc;
dNSN = dNSN - dNSNcc;
dReprN = dReprN - dReprNcc;
dLN = dLN - dLNcc;
dPhotoN = dPhotoN - dPhotoNcc;
dFRN = dFRN - dFRNcc;

dW = dW - dWcc;
dNSC = dNSC - dNSCcc;
dRepr = dRepr - dReprcc;
dLDMC = dLDMC - dLDMCcc;
dPhotoC = dPhotoC - dPhotoCcc;
dFR = dFR - dFRcc;


