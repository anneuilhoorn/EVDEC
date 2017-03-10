function [ NSCm, LDMCm, PCm, FRm, NSNm, LNm, PNm, FRNm ] = BudBurstMass( day, ValuePhoto_poss, NSCm, LDMCm, PCm, FRm, NSNm, LNm, PNm, FRNm)
%% Metadata

% Name: BudBurstMass.m
% Creator: Anne Uilhoorn
% Affiliation: Institute of Environmental Sciences (CML), Leiden University
% Date Created: 03-03-2017
% Date last changes: 03-03-2017
% Description: function to descibe how much carbon and nitrogen goes from
% storage to leafs & fine roots at budburst.

%% Constants

BBout = 0.4;
BBNout = 0.4;
itcount = 0;

%% Function
        
if day == 1 && ValuePhoto_poss(day) == 1 && itcount==0;
        NSCleft = NSCm .* (1-BBout);
        BBgross = NSCm .* BBout; %BBout is fraction of Available NSC used for bud burst. NOTE: There is not a simple
        % %distinction between available and unavailable NSC (Dietze et al., 2014)
        NSCm = NSCleft;
        BBnet = BBgross .* 0.9; %10% conversion cost starch to sugar
        LDMCm = LDMCm + (0.5.*BBnet);
        PCm = PCm + (0.15.*BBnet);
        FRm = FRm + (0.35.*BBnet);
        
        NSNleft = NSNm .* (1-BBNout);
        BBNgross = NSNm .* BBNout; %BBout is fraction of Available NSC used for bud burst. NOTE: There is not a simple
        % %distinction between available and unavailable NSC (Dietze et al., 2014)
        NSNm = NSNleft;
        BBNnet = BBNgross .* 0.9; %10% conversion cost starch to sugar
        LNm = LNm + (0.5.*BBNnet);
        PNm = PNm + (0.15.*BBNnet);
        FRNm = FRNm + (0.35.*BBNnet);
        itcount = itcount + 1;
end

if day ~= 1 && ValuePhoto_poss(day) == 1 && ValuePhoto_poss(day-1) == 0 && itcount == 0; %Include Tree == 1?
        NSCleft = NSCm .* (1-BBout);
        BBgross = NSCm .* BBout; %BBout is fraction of Available NSC used for bud burst. NOTE: There is not a simple
        % %distinction between available and unavailable NSC (Dietze et al., 2014)
        NSCm = NSCleft;
        BBnet = BBgross .* 0.9; %10% conversion cost starch to sugar
        LDMCm = LDMCm + (0.5.*BBnet);
        PCm = PCm + (0.15.*BBnet);
        FRm = FRm + (0.35.*BBnet);
        
        NSNleft = NSNm .* (1-BBNout);
        BBNgross = NSNm .* BBNout; %BBout is fraction of Available NSC used for bud burst. NOTE: There is not a simple
        % %distinction between available and unavailable NSC (Dietze et al., 2014)
        NSNm = NSNleft;
        BBNnet = BBNgross .* 0.9; %10% conversion cost starch to sugar
        LNm = LNm + (0.5.*BBNnet);
        PNm = PNm + (0.15.*BBNnet);
        FRNm = FRNm + (0.35.*BBNnet);
        
        itcount = itcount + 1;
end

if day < (day-1);
    itcount = 0;
end

end

