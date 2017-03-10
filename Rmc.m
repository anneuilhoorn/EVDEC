function [ Rm ] = Rmc( Na, LAI )
%% Metadata

% Name: Rmc.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 16-02-2016
% Date last changes: 16-02-2017
% Description: Maintenance respiration for carbon

%% Constants

r = 0.031; %basic respiration rate per unit N (g C g-1 N day-1) (roughly after Reich et al., 2008)
qr = 1.2; %factor to compensate higher respiration per N in fine roots (Ryan et al., 1996)
fs = 0.6; %Nsapwood:Ncanopy ratio (look for number)
fr = 0.35; %Nfineroot:Ncanopy ratio (look for number)
rw = r.*(1+qr.*fr+fs); %Maintenance respiration per unit N in the canopy (g C g-1 N day-1)

%% Maintenance respiration Carbon

Nc=Na.*LAI; %gN/m2 soil/day = gN/m2 leaf/day .* m2 leaf/m2 soil
Rm = rw.*Nc; %Maintenance respiration, after Ryan et al. 1996)


end

