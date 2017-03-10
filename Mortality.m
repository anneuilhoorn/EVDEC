function [ death, NSCm, LDMCm, PCm, NSNm, LNm, PNm, NPP, Ngrowth  ] = Mortality( TotalGPP, Rm, NSCm, LDMCm, PCm, Nuptake, Nmaintenance, NSNm, LNm, PNm, Ngrowth, NPP )
%% Metadata

% Name: Mortality.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 20-02-2017
% Date last changes: 06-03-2017
% Description: Mortality for carbon starvation

%% Carbon mortality
death=0;
AvailableC = TotalGPP - Rm; 

if AvailableC < 0
    Change_NSC = -AvailableC;
    NSCm = NSCm - Change_NSC;
    MaintenanceDeficitC = -NSCm;
    
    if NSCm < 0
        NSCm = 0;
        LDMC_Loss= MaintenanceDeficitC.*0.5; %This could be changed to the ratio between LDMCm and PCm
        PC_Loss= MaintenanceDeficitC.*0.5;
        LDMCm = LDMCm-LDMC_Loss;
        PCm = PCm-PC_Loss;
        
        if LDMCm <= 0
            death=1;
        elseif PCm <= 0
            death=1;
        else
            NPP = 0;
            death=0;
        end
    end
    
    
end

%% Nitrogen mortality

AvailableN = Nuptake - Nmaintenance;

if AvailableN < 0
    Change_NSN = -AvailableN;
    NSNm = NSNm - Change_NSN;
    MaintenanceDeficitN = -NSNm;
    
    if NSNm < 0
        NSNm = 0;
        LN_Loss= MaintenanceDeficitN.*0.5; %This could be changed to the ratio between LNm and PNm
        PN_Loss= MaintenanceDeficitN.*0.5;
        LNm = LNm-LN_Loss;
        PNm = PNm-PN_Loss;
        if LNm <= 0
            death=1;
        elseif PNm <= 0
            death=1;
        else
            Ngrowth = 0;
            death=0;
        end
    end
    
    
end


%% Combination of C & N

% if AvailableC <0 && AvailableN >0
% 	Change_NSN = Ngrowth; %feed this back to allocation
% elseif AvailableC>0 && AvailableN <0
% 	Change_NSC = NPP; % feed this back to allocation
% elseif AvailableC<0 && AvailableN <0
% 	NPP=0;
% 	Ngrowth=0;
% end






end

