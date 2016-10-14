function [ Ra, NPP ] = RespirationC( Nc, rw, A, LAI, y )
%% Metadata

% Name: RespirationC.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 08-09-2016
% Date last changes: 12-09-2016
% Description: Calculates carbon respiration, GPP and NPP

%% Summary
%  This function calculates respiration, GPP and NPP given the
%  photosynthesis and LAI. NPP can then be used for the mass balance.

%% Function

Rm = rw.*Nc; %Maintenance respiration, after Ryan et al. 1996)
GPP = A.*LAI;
Rg = (1-y).*(GPP-Rm); %Growth respiration
Ra = Rm + Rg; %All Respiration
NPP = GPP - Ra;

end

