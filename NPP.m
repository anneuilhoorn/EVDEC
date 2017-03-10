function [ NPP ] = NPP( TotalGPP, Rm )
%% Metadata

% Name: NPP.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 20-02-2017
% Date last changes: 20-02-2017
% Description: NPP for carbon in gC m-2 soil day-1

%% NPP

NPP = TotalGPP - Rm;



end

