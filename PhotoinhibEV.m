function [ output_args ] = PhotoinhibEV( Td )
%% Metadata

% Name: PhotoinhibEV.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 26-05-2016
% Date last changes: 13-06-2016
% Description: Calculates when photoinhibition is stopped and
% photosynthesis begins again (after Suni Tanja et al., 2003)

%% Summary
%   Mean temperature above temperature threshold for 5 days (sumT5)
%   Threshold varies per species and per area
%   T5 works less in temperate areas, since there is a little bit of
%   photosynthesis in evergreen trees if winter is less harsh

%% Calculation

%Read in Td file (same as for BudBurst.m)

Tth=5; %Temperature threshold for photoinhibition (in degrees Celsius). This threshold varies per species and location. --> functie van temperatuur ipv locatieafhankelijk

sumT5 = 0;
for day = 1:365
    if sumT5 <5
        if Td > Tth
            sumT5 = sumT5 + 1;
        else
            sumT5 = 0;
        end
    else
%         fotosynthese
    end
end    
end



