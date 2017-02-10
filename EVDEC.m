clearvars
clc
close all

%% Metadata

% Name: EVDEC.m
% Evergreen Deciduous Trait-based Model
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 04-04-2016
% Date last changes: 24-01-2016
% Description: Models the daily net growth (C and N) of a single tree (evergreen (0) or deciduous (1))

%% Parameters

run('Parameters.m');

%% Variables



%Evergreen (0) or Deciduous (1) - for now, later replaced by emergent prop
Tree = 1;
if Tree == 1
    LLS=200; %NOTE: Weng et al. LLS proportionalto LMA (LLS=constant.*LMA)
else
    LLS=650;
end

%Climate

% Temperature: we need all possible ranges. How do we make these, how do we
%shape them?
T=xlsread('DeBilt2015_temperature.xlsx','C2:C366'); %Temperature in degrees Celsius, for 2015 De Bilt, The Netherlands


%% EVDEC


for year=1
    ValueofPhoto_poss=zeros(1,365);
    for day=1:365
        
        %Temperature
        T(day);
        
        %Photoinhibition in evergreen trees // Budburst in deciduous trees
        if Tree==0
            [ Photo_poss,sumT4,sumT5 ] = PhotoinhibEV( T(day),sumT5,sumT4,Tth,Ttc,Photo_poss );
        else
            [ Photo_poss,Sf,Sc,CD ] = BudBurst( T(day),Sf,Sc,Tth1,Tth2,Photo_poss );
        end
        
        ValuePhoto_poss(day) = Photo_poss;
        
        %Budburst --> Make an evolutionary rule for this
        
        if ValuePhoto_poss(day) == 1 && ValuePhoto_poss(day-1) == 0; %Include Tree == 1? 
            NSCleft = NSCm .* (1-BBout);
            BBgross = NSCm .* BBout; %BBout is fraction of Available NSC used for bud burst. NOTE: There is not a simple
            % %distinction between available and unavailable NSC (Dietze et al., 2014)
            NSCm = NSCleft;
            BBnet = BBout .* 0.9; %10% conversion cost starch to sugar
            LDMCm = LDMCm + (0.5.*BBnet);
            PCm = PCm + (0.15.*BBnet);
            FRm = FRm + (0.35.*BBnet);
            
            NSNleft = NSNm .* (1-BBNout);
            BBNgross = NSNm .* BBNout; %BBout is fraction of Available NSC used for bud burst. NOTE: There is not a simple
            % %distinction between available and unavailable NSC (Dietze et al., 2014)
            NSNm = NSNleft;
            BBNnet = BBNout .* 0.9; %10% conversion cost starch to sugar
            LNm = LNm + (0.5.*BBNnet);
            PNm = PNm + (0.15.*BBNnet);
            FRNm = FRNm + (0.35.*BBNnet);
            
        end        
        
        %Stop photosynthesis in Deciduous. Start leaf fall in deciduous trees when Days of photosynthesis ==
        %LLS --> catch this in evo rule
        if (Tree==1) && (Photo_poss==1);
            Fall=Fall+1;
        end
        
        if Fall>=LLS
            Photo_poss = 0;
        end
        
        %Photosynthesis
        TotalC=WCRm+NSCm+FRm+LDMCm+PCm;
        LAI=TotalC.*(1/LMA).*(1/Cfraction); %LAI is wayyyyyy high (correct pool sizes? LMA & C fraction are averages from Kattge et al., 2011). Normal values of LAI will only exist with ~50gC/m2 soil total Carbon
        if Photo_poss == 1;
            [A,SumA,GPP,Ra,NPP] = farqtotal(Na, T(day), pCO2, Tree, rw, y, LAI); %in gC m-2 soil day-1
        else
            A=0;
            SumA=0;
            Ra=0;
        end
        
        ValueofLAI(day)=LAI;
        ValueofSumA(day)=SumA;
        ValueofNPP(day)=NPP;
        
        %Nitrogen uptake
        [ Nuptake ] = NitrogenUptake( Nsoil,FRm,RC,RootN,SRL );
        
        %Fitness based allocation of C and N
        %[ aL, aR, aS, aG ] = FitnessBasedAllocation( NPP, Rm, WCRm, NSCm, FRm, LDMCm, PCm, Reprm, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm );
        [ dW, dNSC, dRepr, dPhotoC, dLDMC, dFR, dWN, dNSN, dReprN, dPhotoN, dLN, dFRN ] = Allocation( NPP, Nuptake, Tree, LLS, Fall, Ra );
        
        %Mass balance carbon
        [ NPP, LLS, WCRm, NSCm, FRm, LDMCm, PCm, Reprm ] = Carbon_mass( NPP, LLS, WCRm, NSCm, FRm, LDMCm, PCm, Reprm, dW, dNSC, dRepr, dPhotoC, dLDMC, dFR);
        ValueofNPP(day)=NPP; %PCm should feedback photosynthesis capacity
        
        %Mass balance nitrogen
        [ Nuptake, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm ] = Nitrogen_mass( Nuptake, LLS, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm);
        
        %Resorption
        if (Tree==1) && (Fall==LLS);
            %RESORPTION
        end
        
        
    end
    
end

x=1:365;
figure(1)
plot(x, ValueofSumA)




