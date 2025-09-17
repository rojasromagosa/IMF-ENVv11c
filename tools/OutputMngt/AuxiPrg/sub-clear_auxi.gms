OPTION clear=%1_GDP, clear=%1_Prices, clear=%1_Ratios, clear=%1_Value_Added;

$IFI %aux_trade_output%      =="ON" OPTION clear=%1_Trade;
$IFI %aux_Environment_Output%=="ON" OPTION clear=%1_Environment
$IFI %aux_Energy_Output%     =="ON" OPTION clear=%1_Energy;
$IFI %aux_Agriculture_Output%=="ON" OPTION clear=%1_Agriculture;
$IFI %aux_Capital_Output%    =="ON" OPTION clear=%1_Capital;

$IfThenI.ExpComp %aux_expenses_composition%=="ON"
    OPTION clear=%1_expenses_composition_mp, clear=%1_ValueAdded_structure;
    OPTION clear=%1_GrossOutput_structure,   clear=%1_Total_Demands;
    OPTION clear=%1_Final_Demands,           clear=%1_Intermediary_Demands;
$ENDIF.ExpComp

$IFI %aux_growth_accounting%=="ON" OPTION clear=%1_Solow_decomposition;

*---    These are not cleared below because they need to be stored in main file

*$IFI %aux_Labour_Output%  =="ON" OPTION clear=%1_labour;
*$IFI %aux_trade_output%   =="ON" OPTION clear=%1_External;

*OPTION clear=%1_Gross_output, clear=%1_Macroeconomic;

