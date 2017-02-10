function [ aL, aR, aS, aG ] = FitnessBasedAllocation( NPP, Rm, WCRm, NSCm, FRm, LDMCm, PCm, Reprm, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm )
%% Metadata

% Name: FitnessBasedAllocation.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 14-12-2016
% Date last changes: 19-12-2016
% Description: Calculates the allocation amounts to the different organs

%% Summary
%  function to calculate allocation priority and amounts for all organs
%  (leaves, fine roots & mycorrhiza, storage, stem & coarse roots

%Input variables are all pools (both C and N)

%% Constants/variables
layermax = 10; % maximum gC m-2 soil per layer of the canopy
Snc = 1/29; %N:C storage ratio
Gnc = ; % N:C growth ratio. Dependent on how much Nuptake and photosynthesis is possible and necessary.
CS = ;
CSo = ;
if Tree == 1 %Max LLS
    tlmax = 200; 
else tlmax=600;
end
fs = 0.2; %fraction of storage which can be used daily
Gmax = SumA+(fs.*NSCm)-(0.2.*NPP); %maximum potential growth rate. 20% of NPP goes to exudation through the rhizosphere.

%% Allocation priority leaves

%Introduce projected area of how much space can be taken by a crown/stand


for i=1:20 %insert fapar and layer array
    if layer(i)<layermax
        ss=(fapar(i)/fapar(1));
    end %does this stop after the loop found a solution?
end
if Tree == 1
    tl=LSS-daysofphotosynthesis;
else %tl=????-daysofphotosynthesis; leaves live longer than one season, so LLS is not a good indicator for the growing season. Standard growing season? But this differs per biome.
end
    
Ae = (A .* ss) .* tl; %photosynthesis for leaf. LAI of whole canopy * level of self shading.
Cl = LDMCleaf + PCleaf + Rm .* tl; %construction costs of leaf (in C) --> 1 function for C&N --> is this possible?
% Cl = LDMCleaf + PCleaf + LNleaf + PNleaf + Rm .* tl;
% CNl = Cl/CNratioleaf;
Cr = RootC + Rm .* tl; %construction costs of root (in C)


Lnet = Ae-Cl-Cr; %net benefit of new leaves (for C)

% Do I make different functions for N and C? C allocation is dependent on C
% and N functions, or just C functions and N follows?

apL = Lnet .* 1/Lnet(L=0); % allocation priority for leaves. What is Lnet(L=0)? 

%% Allocation priority fine roots and mycorrhiza

apR = max((1-Snc/Gnc), 0); %

%% Allocation priority storage

fetl = (tl/tlmax).*(fe)+1; %expected remaining LLS. factor extra
apS = max(1-(CS/CSo), 0) * fetl; 

%% Allocation priority stem

% needs optimization
apG = ;

%arbitrary ratio (typically 1/3), or make a range and play with it. Does
%the relationship between growth and allocation have a max?
%derive a solution mathematically (dybzinski)
%start with multiple simulations to find the best allocation ratio and
%assuma that is waht is optimised (if only 1-2 parameters are undecided).

%% Allocation amounts

Sumap = apL + apR + apS + apG;

aL = apL/Sumap * Gmax; %allocation amount leaves
aR = apR/Sumap * Gmax;
aS = apS/Sumap * Gmax;
aG = apG/Sumap * Gmax;

end

