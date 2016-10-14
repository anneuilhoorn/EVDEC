clearvars
clc
close all

%% Metadata

% Name: EVDEC.m
% Evergreen Deciduous Trait-based Model
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 04-04-2016
% Date last changes: 28-09-2016
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
T=xlsread('DeBilt2015_temperature.xlsx','C2:C366'); %Temperature in degrees Celsius, for 2015 De Bilt, The Netherlands




%% EVDEC


for year=1
    ValueofSumA=zeros(1,365);
    ValueofNPP=zeros(1,365);
    for day=1:365
        
        %Temperature
        T(day);
        
        %Photoinhibition in evergreen trees // Budburst in deciduous trees
        if Tree==0
            [ Photo_poss,sumT4,sumT5 ] = PhotoinhibEV( T(day),sumT5,sumT4,Tth,Ttc,Photo_poss );
        else
            [ Photo_poss,Sf,Sc,CD ] = BudBurst( T(day),Sf,Sc,Tth1,Tth2,Photo_poss );
        end
        
        %BUDBURST SHOULD RELEASE C FROM STORAGE TOWARDS LEAVES!
        
        %Start leaf fall in deciduous trees when Days of photosynthesis ==
        %LLS
        if (Tree==1) && (Photo_poss==1);
            Fall=Fall+1;
        end
        
        if Fall>=LLS
            Photo_poss = 0;
        end
            
        %Photosynthesis
        if Photo_poss == 1;
            [A,SumA,GPP,Ra,NPP] = farqtotal(Na, T(day), pCO2, LAI, Tree, rw, y); %in gC m-2 soil day-1
        else
            A=0;
            SumA=0;
        end
        
        ValueofSumA(day)=SumA; %PHOTOSYNTHESIS IS STILL WEIRD
        
        %Nitrogen uptake
        [ Nuptake ] = NitrogenUptake( Nsoil,FRm,RC,RootN,SRL );

        %Mass balance carbon
        [ NPP, Wm, NSCsm, CRm, NSCrm, FRm, LDMCm, PCm, Reprm ] = Carbon_mass( NPP, LLS, Wm, NSCsm, CRm, NSCrm, FRm, LDMCm, PCm, Reprm);
        ValueofNPP(day)=NPP; %PCm should feedback photosynthesis capacity
        
        %Mass balance nitrogen
        [ Nuptake, WNm, NSNsm, CRNm, NSNrm, FRNm, LNm, PNm, ReprNm ] = Nitrogen_mass( Nuptake, LLS, WNm, NSNsm, CRNm, NSNrm, FRNm, LNm, PNm, ReprNm);
         
        %Resorption        
        if (Tree==1) && (Fall==LLS); 
            %RESORPTION
        end
        
        
    end
    
end

x=1:365;
figure(1)
plot(x, ValueofSumA)



