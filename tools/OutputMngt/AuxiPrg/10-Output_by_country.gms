$setlocal stephere "%1"

$IfTheni.param %stephere%== "parameters"
    File saveCty;
    PARAMETERS
    tmp_GDP(typevar,gdp_definition,units,ra,t)
    tmp_Ratios(typevar,ratioslist,units,ra,agents,t)
    tmp_Prices(typevar,Pricelist,regions,commodities,agents,t)
    tmp_Macroeconomic(typevar,macrocat,macrolist,units,ra,tt)
    tmp_Value_Added(typevar,gdp_definition,units,regions,agents,t)
    tmp_Gross_output(typevar,units,regions,agents,t)

    $$IFI %aux_Environment_Output%=="ON" tmp_Environment(typevar,envlist,envunits,ra,agents,t)
    $$IFI %aux_Energy_Output%     =="ON" tmp_Energy(typevar,nrglist,envunits,ra,agents,t)
    $$IFI %aux_Labour_Output%     =="ON" tmp_Labour(typevar,labourlist,units,ra,skills,agents,t)
    $$IFI %aux_Agriculture_Output%=="ON" tmp_Agriculture(typevar,aglist,units,ra,agents,t)
    $$IFI %aux_Capital_Output%    =="ON" tmp_Capital(typevar,CapitalList,units,ra,agents,t)

    $$IfTheni.ExpComp %aux_expenses_composition%=="ON"
        tmp_expenses_composition_mp(typevar,expenses_type,units,ra,items,agents,t)
        tmp_GrossOutput_structure(typevar,units,ra,items,agents,t)
        tmp_ValueAdded_structure(typevar,units,ra,items,agents,t)
        tmp_Final_Demands(typevar,units,ra,ia,agents,t)
        tmp_Intermediary_Demands(typevar,units,ra,ia,agents,t)
        tmp_Total_Demands(typevar,units,ra,ia,agents,t)
    $$ENDIF.ExpComp
    $$IfTheni.trade %aux_trade_output%=="ON"
        tmp_Trade(typevar,tradelist,units,origin,destination,ia,t)
        tmp_External(typevar,tradelist,units,ra,ia,t)
    $$ENDIF.trade
   ;

*   create an output folder for auxilliary files by country

    $$IF NOT DEXIST "%oAuxiDir%\auxiCty" $call "mkdir %oAuxiDir%\auxiCty"

$ELSE.param

*   run each country output

    LOOP(sim,
        $$IF EXIST "%iFilesDir%\tmpFile.gms" $include "%iFilesDir%\tmpFile.gms"
    );

$ENDIF.param

$droplocal stephere




