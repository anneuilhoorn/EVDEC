function [ Ngrowth, Nmaintenance ] = NitrogenMaintenance( Nuptake, WCRNm, ReprNm, NSNm, LNm, PNm, FRNm )
%% Metadata

% Name: NitrogenGrowth.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 07-03-2017
% Date last changes: 07-03-2017
% Description: Nitrogen maintenance calculated per tissue, resulting in
% nitrogen available for growth

%% Nitrogen maintenance (gN/m2soil)

Nm_WCRN = WCRNm * 0.005; %dummy values
Nm_ReprN = ReprNm * 0;
Nm_NSN = NSNm * 0;
Nm_LN = LNm * 0.04;
Nm_PN = PNm * 0.05;
Nm_FRN = FRNm * 0.03;

Nmaintenance = Nm_WCRN + Nm_ReprN + Nm_NSN + Nm_LN + Nm_PN + Nm_FRN;
Ngrowth = Nuptake - Nmaintenance;

end

