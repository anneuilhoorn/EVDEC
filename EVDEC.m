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
    ValuePhoto_poss = zeros (0,365);
    ValuePCm = zeros (0,365);
    for day=1:365
        if treedeath == 0
            %Temperature
            T(day);
            
            %Photoinhibition in evergreen trees // Budburst in deciduous trees
            if Tree==0
                [ Photo_poss,sumT4,sumT5 ] = PhotoinhibEV( T(day),sumT5,sumT4,Tth,Ttc,Photo_poss );
            else
                [ Photo_poss,Sf,Sc,CD ] = BudBurst( T(day),Sf,Sc,Tth1,Tth2,Photo_poss );
            end
            
            ValuePhoto_poss(day) = Photo_poss;
            
            
            %Budburst --> Make an evolutionary rule for this. Budburst is
            %now for DEC as well as EV, for temperate climates           
           
            [ NSCm, LDMCm, PCm, FRm, NSNm, LNm, PNm, FRNm ] = BudBurstMass( day, ValuePhoto_poss, NSCm, LDMCm, PCm, FRm, NSNm, LNm, PNm, FRNm);
           
            
            %Stop photosynthesis in Deciduous. Start leaf fall in deciduous trees when Days of photosynthesis ==
            %LLS --> catch this in evo rule
            if (Tree==1) && (Photo_poss==100);
                Fall=Fall+1;
            end
            
            if Fall>=LLS
                Photo_poss = 0;
            end
            
            %Photosynthesis & Carbon maintenance
            TotalC=WCRm+NSCm+FRm+LDMCm+PCm;
            LAI=TotalC.*(1/LMA).*(1/Cfraction); %LAI is wayyyyyy high (correct pool sizes? LMA & C fraction are averages from Kattge et al., 2011). Normal values of LAI will only exist with ~50gC/m2 soil total Carbon
            if Photo_poss == 100;
                [TotalGPP, Av, Aj] = Photosynthesis(Na, T(day), pCO2, Tree, LAI); %in gC m-2 soil day-1
                [ Rm ] = Rmc ( Na, LAI );
                [ NPP ] = NPPfunctie ( TotalGPP, Rm );
            else
                TotalGPP=0;
                Av=0;
                Aj=0;
                [ Rm ] = Rmc( Na, LAI );
                [ NPP ] = NPPfunctie( TotalGPP, Rm );
            end
            
            %Nitrogen uptake & Nitrogen maintenance
            [ Nuptake ] = NitrogenUptake( Nsoil,FRm,RC,RootN,SRL );
            [ Ngrowth, Nmaintenance ] = NitrogenMaintenance( Nuptake, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm );
            
            %Mortality
            [ treedeath, NSCm, LDMCm, PCm, NSNm, LNm, PNm, NPP, Ngrowth  ] = Mortality( TotalGPP, Rm, NSCm, LDMCm, PCm, Nuptake, Nmaintenance, NSNm, LNm, PNm, Ngrowth, NPP );
            if treedeath==0                     
            
            %Fitness based allocation of C and N
            %[ aL, aR, aS, aG ] = FitnessBasedAllocation( NPP, Rm, WCRm, NSCm, FRm, LDMCm, PCm, Reprm, WCRNm, NSNm, FRNm, LNm, PNm, ReprNm );
            [ fWCR, fNSC, fRepr, fPC, fLDMC, fFR, fWCRN, fNSN, fReprN, fPN, fLN, fFRN ] = Allocation( NPP, Nuptake, Tree, LLS, Fall, Rm );
            
            %Biomass added by allocation C & N
            [ WCRm, Reprm, NSCm, LDMCm, PCm, FRm, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm ] = Biomass_allocation( NPP, Ngrowth, fWCR, fRepr, fNSC, fLDMC, fPC, fFR, fWCRN, fReprN, fNSN, fLN, fPN, fFRN, WCRm, Reprm, NSCm, LDMCm, PCm, FRm, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm );
            
            % Environmental losses C & N
            [ WCRm, WCRNm, Reprm, ReprNm, NSCm, NSNm, LDMCm, LNm, PCm, PNm, FRm, FRNm ] = EnvLosses( WCRm, WCRNm, Reprm, ReprNm, NSCm, NSNm, LDMCm, LNm, PCm, PNm, FRm, FRNm );
            
            %Resorption
            if (Tree==1) && (Fall==LLS);
                LDMCout = 0.4 * LDMCm;
                PCout = 0.4 * PCm;
                FRout = 0.4 * FRm;
                LDMCm = LDMCm - LDMCout;
                PCm = PCm - PCout;
                FRm = FRm - FRout;
                NSCm = (NSCm + LDMCout + PCout + FRout)*0.9; %10% conversion cost sugar to starch
            end
            
            
            
            end
            
        end
        
        
        %         TotalGPP = [1:365];
        %
        %         apple = zeros(size(banana));
        %         apple(1) = banana(1);
        %
        %         for i = 2:size(banana,2)
        % 	    apple(i) = apple(i-1)+banana(i);
        %         end
        %
        %         for i = 1:size(apple,2)
        % 	    apple(i)
        %         end
        
    ValueAv(day) = Av;
    ValueAj(day) = Aj;
    ValuePhoto_poss(day) = Photo_poss;
    ValueTotalGPP(day) = TotalGPP;
    ValueLDMCm(day) = LDMCm;
    ValueWCRm(day) = WCRm;
    ValuePCm(day)=PCm;
    ValueNSCm(day)=NSCm;
    ValueFRm(day)=FRm;
 
    end
    
end

x=1:365;
figure(1)
plot(x, ValueTotalGPP)

figure(2)
plot(x, ValueLDMCm)
hold on
plot(x, ValueWCRm)
plot(x, ValuePCm)
plot(x, ValueNSCm)
plot(x, ValueFRm)
plot(x,ValuePhoto_poss)
legend('LDMC','WCR','PC','NSC','FR','Photosynthesis')








