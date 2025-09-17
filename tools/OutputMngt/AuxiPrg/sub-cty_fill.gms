* Flags
* %1 : name of the variable
* %2 : dimension of the variable

$BATINCLUDE "%AuxPrgDir%\sub-clear_auxi.gms" "tmp"

*---    These are not cleared below because they need to be stored in main file
$IfI %aux_Labour_Output%=="ON" OPTION clear=tmp_labour;
$IfI %aux_trade_output% =="ON" OPTION clear=tmp_External;
OPTION clear=tmp_Gross_output, clear=tmp_Macroeconomic;

tmp_GDP(%2,gdp_definition,units,"%1",t)
    = out_GDP(%2,gdp_definition,units,"%1",t);
tmp_ratios(%2,ratioslist,units,"%1",agents,t)
    = out_ratios(%2,ratioslist,units,"%1",agents,t);
tmp_Prices(%2,Pricelist,"%1",commodities,agents,t)
    = out_Prices(%2,Pricelist,"%1",commodities,agents,t);
tmp_Value_Added(%2,gdp_definition,units,"%1",agents,t)
     = out_Value_Added(%2,gdp_definition,units,"%1",agents,t);
tmp_Gross_output(%2,units,"%1",agents,t)
     = out_Gross_output(%2,units,"%1",agents,t);
tmp_Macroeconomic(%2,macrocat,macrolist,units,"%1",tt)
    = out_Macroeconomic(%2,macrocat,macrolist,units,"%1",tt);

$IFI %aux_Environment_Output%=="ON" tmp_Environment(%2,envlist,envunits,"%1",agents,t)   = out_Environment(%2,envlist,envunits,"%1",agents,t);
$IFI %aux_Energy_Output%     =="ON" tmp_Energy(%2,nrglist,envunits,"%1",agents,t)        = out_Energy(%2,nrglist,envunits,"%1",agents,t);
$IFI %aux_Labour_Output%     =="ON" tmp_Labour(%2,labourlist,units,"%1",skills,agents,t) = out_Labour(%2,labourlist,units,"%1",skills,agents,t);
$IFI %aux_Agriculture_Output%=="ON" tmp_Agriculture(%2,aglist,units,"%1",agents,t)       = out_Agriculture(%2,aglist,units,"%1",agents,t);
$IFI %aux_Capital_Output%    =="ON" tmp_Capital(%2,CapitalList,units,"%1",agents,t)      = out_Capital(%2,CapitalList,units,"%1",agents,t);

$IfTheni.trade %aux_trade_output%=="ON"
    tmp_Trade(%2,tradelist,units,"%1",destination,ia,t)
        = out_Trade(%2,tradelist,units,"%1",destination,ia,t);
    tmp_Trade(%2,tradelist,units,origin,"%1",ia,t)
        = out_Trade(%2,tradelist,units,origin,"%1",ia,t);
    tmp_External(%2,tradelist,units,"%1",ia,t)
        = out_External(%2,tradelist,units,"%1",ia,t);
$ENDIF.trade

$IfThenI.ExpComp %aux_expenses_composition%=="ON"
    tmp_expenses_composition_mp(%2,expenses_type,units,"%1",ia,agents,t)
        = out_expenses_composition_mp(%2,expenses_type,units,"%1",ia,agents,t);
    tmp_ValueAdded_structure(%2,units,"%1",items,agents,t)
        = out_ValueAdded_structure(%2,units,"%1",items,agents,t);
    tmp_GrossOutput_structure(%2,units,"%1",items,agents,t)
        = out_GrossOutput_structure(%2,units,"%1",items,agents,t);
    tmp_Total_Demands(%2,units,"%1",ia,agents,t)
        = out_Total_Demands(%2,units,"%1",ia,agents,t);
    tmp_Final_Demands(%2,units,"%1",ia,agents,t)
        = out_Final_Demands(%2,units,"%1",ia,agents,t);
    tmp_Intermediary_Demands(%2,units,"%1",ia,agents,t)
        = out_Intermediary_Demands(%2,units,"%1",ia,agents,t);
$ENDIF.ExpComp

$IfThenI.gacc %aux_growth_accounting%=="ON"
    tmp_Solow_decomposition(growth_accounting,"%1",fp,agents,t)
        = out_Solow_decomposition(growth_accounting,"%1",fp,agents,t);
$ENDIF.gacc

PUT_UTILITY saveCty 'gdxout' / '%oAuxiDir%\auxiCty\%1_' sim.tl:0 '.gdx';

EXECUTE_UNLOAD
    tmp_GDP=out_GDP,
    tmp_ratios=out_ratios,
    tmp_Prices=out_Prices,
    tmp_Macroeconomic=out_Macroeconomic,
    tmp_Value_Added=out_Value_Added,
    $$IFI %aux_Environment_Output%=="ON" tmp_Environment=out_Environment,
    $$IFI %aux_Energy_Output%     =="ON" tmp_Energy=out_Energy,
    $$IFI %aux_Labour_Output%     =="ON" tmp_Labour=out_Labour,
    $$IFI %aux_Capital_Output%    =="ON" tmp_Capital=out_Capital,
    $$IFI %aux_Agriculture_Output%=="ON" tmp_Agriculture=out_Agriculture,
    $$IFI %aux_trade_output%      =="ON" tmp_Trade=out_Trade, tmp_External=out_External,
    $$IfThenI.ExpComp %aux_expenses_composition%=="ON"
        tmp_expenses_composition_mp = out_expenses_composition_mp,
        tmp_GrossOutput_structure   = out_GrossOutput_structure,
        tmp_ValueAdded_structure    = out_ValueAdded_structure,
        tmp_Final_Demands           = out_Final_Demands,
        tmp_Intermediary_Demands    = out_Intermediary_Demands,
        tmp_Total_Demands           = out_Total_Demands,
    $$ENDIF.ExpComp
    $$IFI %aux_growth_accounting%=="ON" tmp_Solow_decomposition=out_Solow_decomposition,
    tmp_Gross_output=out_Gross_output
;
