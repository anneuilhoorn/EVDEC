function [ Photo_poss,sumT4,sumT5 ] = PhotoinhibEV( Td,sumT5,sumT4,Tth,Ttc,Photo_poss )
%% Metadata

% Name: PhotoinhibEV.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 26-05-2016
% Date last changes: 13-06-2016
% Description: Calculates when photoinhibition is stopped(after Suni Tanja et al., 2003)

%% Summary
%   Mean temperature above temperature threshold for 5 days (sumT5)
%   Threshold varies per species and per area
%   T5 works less in temperate areas, since there is a little bit of
%   photosynthesis in evergreen trees if winter is less harsh

%% Parameters



%% Calculation

%Read in daily temp file (same as for BudBurst.m)

if sumT5 < 5
    if Td > Tth
        sumT5 = sumT5 + 1;
    else
        sumT5 = 0;
    end
else
    Photo_poss=100;
end

if Photo_poss==100
    sumT5 = 0;
end

%Stop Photosynthesis
if sumT4 < 4
    if Td < Ttc
        sumT4 = sumT4 + 1;
    else
        sumT4 = 0;
    end
else
    Photo_poss=0;
end

if Photo_poss==0
    sumT4 = 0;
end
end



