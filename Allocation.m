function [ fW, fNSC, fRepr, fPhotoC, fLDMC, fFR, fWN, fNSN, fReprN, fPhotoN, fLN, fFRN ] = Allocation( Cfixed, Nuptake, Tree, LLS, Fall, Rm )

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

Call = 0.2; %for now, to be optimized
Nall = 0.2;

% %Cfc & Cfn differ per organ/leafing strategy --> find good values in literature
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

fW = 0.3; %in g C m-2 soil
fNSC= NSCtreshold; %in g C m-2 soil
fRepr = 0; %in g C m-2 soil
fLDMC = (0.002.*LLSleft-0.1); %Linear function of relation LDMC allocation and LLS left %in g C m-2 soil
fPhotoC = Call; %Optimization %in g C m-2 soil
fFR = 1 - fW - fNSC - fLDMC - fRepr; %in g C m-2 soil

%Allocation to fine roots is moslty dependent on the amount of nitrogen uptake. So
%the function of C allocation to FRm is dependent on Nuptake. If Nuptake is
%big enough to keep up with C then there will be less allocation to roots.
% Negative relationship with FRNm 

fWN = NCratiostem * fW * (1-Cfcwood) / (1 - Cfnwood); %in g N m-2 soil
fFRN = NCratioroot * fFR * (1-Cfcroot) / (1-Cfnroot); %in g N m-2 soil
fReprN = NCratiofruit * fRepr * (1-Cfcfruit) / (1-Cfnfruit); %always 0 for now, %in g N m-2 soil
fLN = NCratioleaf * fLDMC * (1-Cfcleaf) / (1 - Cfnleaf); %in g N m-2 soil
fPhotoN = Nall; %Optimization %in g N m-2 soil
fNSN = 1 - fWN - fFRN - fLN - fReprN; %in g N m-2 soil
end


% %% Growth respiration
% 
% dWcc = fW * (1-Cfcwood);
% dNSCcc = fNSC * (1-Cfcstarch);
% dReprcc = fRepr * (1-Cfcfruit);
% dLDMCcc = fLDMC * (1-Cfcleaf);
% dPhotoCcc = fPhotoC * (1-Cfcleaf);
% dFRcc = fFR * (1-Cfcroot);
% 
% dWNcc = fWN * (1-Cfnwood);
% dNSNcc = fNSN * (1-Cfnstarch);
% dReprNcc = fReprN * (1-Cfnfruit);
% dLNcc = fLN * (1-Cfnleaf);
% dPhotoNcc = fPhotoN * (1-Cfnleaf);
% dFRNcc = fFRN * (1-Cfnroot);
% 
% %% Actual allocation to pools
% 
% fW = fW - dWcc;
% fNSC = fNSC - dNSCcc;
% fRepr = fRepr - dReprcc;
% fLDMC = fLDMC - dLDMCcc;
% fPhotoC = fPhotoC - dPhotoCcc;
% fFR = fFR - dFRcc;
% 
% fWN = fWN - dWNcc;
% fNSN = fNSN - dNSNcc;
% fReprN = fReprN - dReprNcc;
% fLN = fLN - dLNcc;
% fPhotoN = fPhotoN - dPhotoNcc;
% fFRN = fFRN - dFRNcc;




