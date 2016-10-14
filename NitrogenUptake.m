function [ Nuptake ] = NitrogenUptake( Nsoil,FRm,RC,RootN,SRL )
%% Metadata

% Name: NitrogenUptake.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 26-09-2016
% Date last changes: 28-09-2016
% Description: Nitrogen uptake

%% Nitrogen uptake

uptakespeed=0.5.*RootN; %in gN/m root/day. Function of root nitrogen, tbt. Nroot in gN/m2 soil/day
RL=(FRm./RC).*SRL; %in m root/m2 soil (FRm in gC/m2 soil/day, RC is fraction, SRL in m root/g root)
Nrootuptake=uptakespeed.*RL; %in gN/m2 soil/day
Nuptake=min(Nsoil,Nrootuptake); %in gN/m2 soil/day

%% Costs of active uptake and myccorhiza (lumped)

% To take x gN/m2 soil out of the soil it costs x gC/m2 soil
% Cost estimation?

end

