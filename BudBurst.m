function [ Photo_poss,Sf,Sc,CD ] = BudBurst( Td,Sf,Sc,Tth1,Tth2,Photo_poss)

%% Metadata

% Name: BudBurst.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 22-05-2016
% Date last changes: 28-06-2016

%% Summary: BudBurst in deciduous trees. Model modified after Chuine (2000) and Murray et al. (1989)% BudBurst calculates when budburst happens and the amount of C going from NSCs and NSCr to LDMC and PC
%   BudBurst happens once every year when cooling and forcing thresholds
%   have been reached. This is species specific.

%% Timing of budburst

% Parameters
w=40; %species specific parameter
k=-1e-8; %species specific parameter


%Rate of chilling
if Td < Tth1
    CD=1;
else CD=0;
end

% State of chilling
Sc = Sc + CD; %Daily cumulative rate of chilling


%Rate of forcing

if Td < Tth2
    GDD=0;
else GDD=Td-Tth2;
end

% State of forcing
Sf = Sf + GDD; %Daily cumulative rate of forcing

F_star = w*exp(k*Sc); %NOTE: this is species specific! (in Chuine, 2000 is was between 15-80). w>0, k<0

if Sf > F_star
    Photo_poss=1;
end








