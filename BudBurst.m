function [ output_args ] = BudBurst( NSCsm, NSCrm )

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

%Constants
Tth1 = 0; %Cooling temperature threshold (in degrees Celsius)
Tth2 = 5; %Forcing temperature threshold (in degrees Celsius)

Sf=0;
Sc=0;

%Td is a climate file with mean temperatures per day --> this is location
%specific

%Chilling

for day = 1:365 %Chilling can happen from 1 Sept - 31 Dec (Julian day 244:365) --> 1st half of winter in year representing 2nd half of actual winter. If build over multiple year, build in reset function
    
    %Rate of chilling
    if Td < Tth1
        CD=1;
    else CD=0;
    end
    
    % State of chilling
    Sc= Sc + CD; %Daily cumulative rate of chilling
    
    C_star = Sc;
    
end

%Forcing

for day = 1:365 %Same as forcing for multiple years, reset after budburst (Sf=0, can procede when quiescence starts)
    
    %Rate of forcing
    
    if Td < Tth2
        GDD=0;
    else GDD=Td-Tth2;
    end
    
    % State of forcing
    Sf= Sf + GDD; %Daily cumulative rate of forcing
    
    F_star = w*exp(k*C_star); %NOTE: this is species specific! (in Chuine, 2000 is was between 15-80). w>0, k<0
    
    if Sf > F_star
        ThD=day;
        break
    end
end

%HOW: I want bud burst to happen on the day of 'break'. How do I continue
%with this number?

%% Allocation of

FrA=0.4; %Fraction of Available NSC used for bud burst. NOTE: There is not a simple
%distinction between available and unavailable NSC (Dietze et al., 2014)

AddforBB=(FrA.*NSCsm)+(FrA.*NSCrm);
CostConvergence=AddforBB.*0.1; %10 percent cost of starch to sugar. NOTE: this is a fictional number, look up how much ATP this costs.

TotalCforBB=AddforBB-CostConvergence;







