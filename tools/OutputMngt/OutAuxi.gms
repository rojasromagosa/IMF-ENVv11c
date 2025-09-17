$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
   Name of the File: "%OutMngtDir\OutAuxi.gms"
   purpose         : This is a module that create output from model simulations
                     - Some output may be desactivated
                     - Results are saved in separate file if %AuxiFile%=="[NameAuxiFile]"s
   created date    : 2021-03-18 (from ENV-Linkages auxilliary_variables.gms)
   created by      : Jean Chateau
   called by       : Any %SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutAuxi.gms $
   last changed revision: $Rev: 347 $
   last changed date    : $Date:: 2023-07-10 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal AuxPrgDir "%OutMngtDir%\AuxiPrg"
file SaveAuxOutput;

$OnText
*------------------------------------------------------------------------------*
*       Set the extra calculus you want (global value = "ON")                  *
*------------------------------------------------------------------------------*
aux_growth_accounting    = GDP Solow decomposition
aux_expenses_composition = Calculate budget shares, Costs shares, Value added shares
$OffText

*	These modules are calculated at the end of the program auxilliary

$If Not SET aux_expenses_composition $SetGlobal aux_expenses_composition "ON"
$If Not SET aux_Energy_Output        $SetGlobal aux_Energy_Output        "ON"
$If Not SET aux_NewEnergy_Output     $SetGlobal aux_NewEnergy_Output     "OFF"
$If Not SET aux_Labour_Output        $SetGlobal aux_Labour_Output        "ON"
$If Not SET aux_Environment_Output   $SetGlobal aux_Environment_Output   "ON"
$If Not SET aux_Agriculture_Output   $SetGlobal aux_Agriculture_Output   "OFF"
$If Not SET aux_SDG                  $SetGlobal aux_SDG                  "OFF"
$If Not SET aux_Capital_Output       $SetGlobal aux_Capital_Output       "ON"
$If Not SET aux_growth_accounting    $SetGlobal aux_growth_accounting    "OFF"
$If Not SET aux_trade_output         $SetGlobal aux_trade_output         "ON"

*	Global Variable "aux_outType" = option to reduce size of the reporting files

$OnText
   %aux_outType% == {"FULL","AbsValueOnly","RESUME" (default)}
   �   "FULL"   : Unload all results
   �   "RESUME"(default):  the variables "out_expenses_composition"
   and "out_GrossOutput_structure" shown a limited number of years
   and are not computed for "not abstype(typevar)"
   �   "AbsValueOnly": calculate only "abstype(typevar)"
$OffText

$If Not SET aux_outType $SetGlobal aux_outType "RESUME"

*	By default for sectoral structure all small categories are grouped

$If Not SET aux_GroupSmallCategory   $SetGlobal aux_GroupSmallCategory   "ON"

* Method to weight price (default "Paashe" vs alternative "Laspeyres")

$If Not SET aux_PriceIndex $SetGlobal aux_PriceIndex "Paashe"

* By default auxilliary variables are stored in a specific file %AuxiFile%
* to store in %SimName%.gdx put $SetGlobal AuxiFile "OFF"

$If Not SET AuxiFile    $SetGlobal AuxiFile "auxi"

* If an %AuxiFile% has been declared by default store these files in a specific folder
* !!! WARNING this folder cannot be name "aux"
* To keep these files with other output : $SetGlobal oAuxiDir "OFF"

$IfTheni.auxiFiles NOT %AuxiFile%=="OFF"
    $$If Not SET oAuxiDir        $SetGlobal oAuxiDir "%oDir%\auxi"
    $$IF Not DEXIST "%oAuxiDir%" $call 'mkdir %oAuxiDir%'
$EndIf.auxiFiles

* By default: Auxilliary files country by country are not generated

$If Not SET IfAuxiByCty $SetGlobal IfAuxiByCty "OFF"

acronyms FULL, RESUME, SMALL, AbsValueOnly, Paashe, Laspeyres;

*   Create file for selecting individuals country when %IfAuxiByCty%=="ON"

$IfThen.CreateTmpFile NOT EXIST "%iFilesDir%\tmpFile.gms"

    file OutCtyFile / %iFilesDir%\tmpFile.gms /;
    put OutCtyFile;

    IF(0,

* Save all "typevar" for country files

        loop(r,
            put '$batinclude "%AuxPrgDir%\sub-cty_fill.gms" ', r.tl:0, '  typevar' /;
        ) ;

    ELSE

* Save only "typevar" = "absolute" [default]

        loop(r,
			put '$batinclude "%AuxPrgDir%\sub-cty_fill.gms" ', r.tl:0, '  abstype' / ;
        ) ;
    ) ;

    putclose OutCtyFile;

$EndIf.CreateTmpFile

*   Define additional sets for auxi outputs

$INCLUDE "%AuxPrgDir%\AuxiSets.gms"

*------------------------------------------------------------------------------*
*               Additional parameters declaration                              *
*------------------------------------------------------------------------------*
PARAMETERS
    out_GDP(typevar,gdp_definition,units,ra,t)                  "GDP different valuation, by region, by year (billions of units)"
    out_Ratios(typevar,ratioslist,units,ra,agents,t)            "Set of Remarkable ratios"
    out_Prices(typevar,Pricelist,regions,commodities,agents,t)  "Prices variables for good i or total"
    ratwork(ra,t)

    $$Ifi %aux_Energy_Output%      =="ON" out_Energy(typevar,nrglist,envunits,ra,agents,t)           "Energy variables"
    $$Ifi %aux_NewEnergy_Output%   =="ON" out_NewEnergy(typevar,nrglist,nrgtype,nrgitem,ra,t)        "Energy variables (ruben test)"
    $$Ifi %aux_Labour_Output%      =="ON" out_Labour(typevar,labourlist,units,ra,skills,agents,t)    "Labour market variable, by region, by skill, by sector by year"
    $$Ifi %aux_Capital_Output%     =="ON" out_Capital(typevar,CapitalList,units,ra,agents,t)         "Capital market variable, by region, by sector by year"
    $$Ifi %aux_Capital_Output%     =="ON" s_capital(units,r,a,t)  "Sectoral Capital"
    $$Ifi %aux_Agriculture_Output% =="ON" out_Agriculture(typevar,aglist,units,ra,agents,t)          "Agriculture variables, by region, by sector by year"
    $$Ifi %aux_SDG%                =="ON" out_SDG(sdgTargets,sdgIndicators,ra,tt)                    "SDG Indicators"
    $$Ifi %aux_Environment_Output% =="ON" out_Environment(typevar,envlist,envunits,ra,agents,t)      "Environmental variables"

    $$IfThenI.trade %aux_trade_output%=="ON"
        out_Trade(typevar,tradelist,units,origin,destination,ia,t) "Trade Flows variables"
        out_External(typevar,tradelist,units,ra,ia,t) "External accounts variables"
    $$ENDIF.trade

    $$IfThenI.ExpComp %aux_expenses_composition%=="ON"
        out_GrossOutput_structure(typevar,units,ra,items,agents,t) "Cost structure of gross output (at Basic/Agent's Price)"
        out_ValueAdded_structure(typevar,units,ra,items,agents,t)  "Cost structure of value added  (at Basic/Agent's Price)"
        out_Final_Demands(typevar,units,ra,ia,agents,t)            "Final Demands structures (at Basic/Agent's Price)"
        out_Intermediary_Demands(typevar,units,ra,ia,agents,t)     "Intermediate Demands structures (at Basic/Agent's Price)"
        out_Total_Demands(typevar,units,ra,ia,agents,t)            "Total Demands structures (at Basic/Agent's Price)"

* Market Prices not the common unit [Save this information in the Full_simulation.gdx]

        out_expenses_composition_mp(typevar,expenses_type,units,ra,ia,agents,t)  "Demand structure (at Market Price)"
    $$ENDIF.ExpComp

    $$IfThenI.gacc %aux_growth_accounting%=="ON"
        out_Solow_decomposition(growth_accounting,regions,fp,agents,t) "Solow Decomposition"
        tmp_Solow_decomposition(growth_accounting,regions,fp,agents,t)
        tmp_fp(regions,fp)
    $$ENDIF.gacc
;

Parameter EEBauxi(*,r,a,t), stepa(r,i,fd,t), step1(r,is,js,t);

$Ifi %IfAuxiByCty%=="ON" $BATINCLUDE "%AuxPrgDir%\10-Output_by_country.gms" "parameters"

* Define Bau Variables for calculation of "devtobau"

$IfThenI.devtoBAU %devtobau%=="ON"

   PARAMETERS
       bau_Gross_output(typevar,units,regions,agents,t)
       bau_Environment(typevar,envlist,envunits,ra,agents,t)
       bau_Labour(typevar,labourlist,units,ra,skills,agents,t)   ;

$EndIf.devtoBAU

*------------------------------------------------------------------------------*
*                                                                              *
*               Generation of auxilliary output Data                           *
*                                                                              *
*------------------------------------------------------------------------------*
$ONDOTL

*------------------------------------------------------------------------------*
*     GDP, Value Added (various definitions) and Output calculations           *
*------------------------------------------------------------------------------*

$INCLUDE "%AuxPrgDir%\01-GDP.gms"

*------------------------------------------------------------------------------*
*                   Labour Variables                                           *
*------------------------------------------------------------------------------*

$IFI %aux_Labour_Output%=="ON" $BATINCLUDE "%AuxPrgDir%\02-labour_market.gms" "base"

*------------------------------------------------------------------------------*
*                   Prices Variables                                           *
*------------------------------------------------------------------------------*

$INCLUDE "%AuxPrgDir%\03-Prices.gms"

*------------------------------------------------------------------------------*
*                   Agriculture                                                *
*------------------------------------------------------------------------------*

$IFI %aux_Agriculture_Output%=="ON" $INCLUDE "%AuxPrgDir%\04-agriculture.gms"

*------------------------------------------------------------------------------*
*                   GHGs Emissions                                             *
*------------------------------------------------------------------------------*

$IFI %aux_Environment_Output%=="ON" $INCLUDE "%AuxPrgDir%\05-Environment.gms"

*------------------------------------------------------------------------------*
*                   Energy Demands                                             *
*------------------------------------------------------------------------------*

$IFI %aux_Energy_Output%=="ON"    $INCLUDE "%AuxPrgDir%\06-energy.gms"
$IFI %aux_NewEnergy_Output%=="ON" $INCLUDE "%AuxPrgDir%\06-newEnergy.gms"
*$IFI %Check_cal_NRG%=="ON"        $BATINCLUDE "%FolderPersoFiles%\Check_Energy_calibration.gms" "%step_module%"

*------------------------------------------------------------------------------*
*                           Trade                                              *
*------------------------------------------------------------------------------*

$IFI %aux_trade_output%=="ON" $INCLUDE "%AuxPrgDir%\07-trade.gms"

*------------------------------------------------------------------------------*
*     Households Budget and Firm Production Costs Decompositions               *
*------------------------------------------------------------------------------*

$IFI %aux_expenses_composition%=="ON" $INCLUDE "%AuxPrgDir%\08-expenses_composition.gms"

*------------------------------------------------------------------------------*
*                   Growth Accounting                                          *
*------------------------------------------------------------------------------*

$IFI %aux_growth_accounting%=="ON" $INCLUDE "%AuxPrgDir%\09-Growth_Accounting.gms"

*------------------------------------------------------------------------------*
*                   SDG Indicators                                             *
*------------------------------------------------------------------------------*

$IFI %aux_SDG%=="ON" $INCLUDE "%AuxPrgDir%\12-SDG.gms"

*------------------------------------------------------------------------------*
*                   Capital market                                             *
*------------------------------------------------------------------------------*

$IFI %aux_Capital_Output%=="ON" $INCLUDE "%AuxPrgDir%\13-capital_market.gms"

$OFFDOTL

*------------------------------------------------------------------------------*
*                                                                              *
*  translate GDP, Value Added and Output in billions of %YearGTAP% USD         *
*                                                                              *
*------------------------------------------------------------------------------*
work = 0.001;
out_GDP(abstype,gdp_definition,notvol,ra,t)
    = out_GDP(abstype,gdp_definition,notvol,ra,t) * work;

* total (e.g. "ttot-a")
out_Value_Added(typevar,gdp_definition,notvol,ra,tota,t) = 0;
out_Gross_output(typevar,notvol,ra,tota,t)               = 0;

out_Value_Added(abstype,gdp_definition,notvol,ra,aga,t)
    = out_Value_Added(abstype,gdp_definition,notvol,ra,aga,t) * work;
out_Gross_output(abstype,notvol,ra,aga,t)
    = out_Gross_output(abstype,notvol,ra,aga,t) * work;

*------------------------------------------------------------------------------*
*			Calculate deviation to Baseline/Bau simulation                     *
*------------------------------------------------------------------------------*

* [TBU] for more output ?

$IfThen.BauVar EXIST "%oDir%\Bau.gdx"

	$$Ifi %AuxiFile%=="ON"  $SetGlobal loadFi "%oDir%\auxi\aux_%BauName%"
	$$Ifi %AuxiFile%=="OFF" $SetGlobal loadFi "%oDir%\Bau"

$Else.BauVar

	$$Ifi %AuxiFile%=="ON"  $SetGlobal loadFi "%BauDir%\auxi\aux_%BauName%"
	$$Ifi %AuxiFile%=="OFF" $SetGlobal loadFi "%BauFile%"

$EndIf.BauVar


$IfThenI.CalcDevToBauV %devtobau%=="ON"

   $$IfThenI.loadFi EXIST "%loadFi%.gdx"

       EXECUTE_LOAD "%loadFi%.gdx",

       $$Ifi      %aux_Labour_Output%=="ON" bau_Labour = out_Labour,
       $$Ifi %aux_Environment_Output%=="ON" bau_Environment= out_Environment,
           bau_Gross_output = out_Gross_output;

       out_Gross_output("devtoBau",notvol,ra,aga,t)
           $(bau_Gross_output("abs",notvol,ra,aga,t) and out_Gross_output("abs",notvol,ra,aga,t))
           = [ out_Gross_output("abs",notvol,ra,aga,t)
                   / bau_Gross_output("abs",notvol,ra,aga,t) - 1];

       $$IfThenI.EnvOutput %aux_Environment_Output%=="ON"
           out_Environment("devtoBau","Material use",envunits,ra,"Primary",t)
               $ ( out_Environment("abs","Material use",envunits,ra,"Primary",t)
                   AND bau_Environment("abs","Material use",envunits,ra,"Primary",t))
               =  [ out_Environment("abs","Material use",envunits,ra,"Primary",t)
               / bau_Environment("abs","Material use",envunits,ra,"Primary",t)
               - 1] ;
           OPTION clear=bau_Environment;
       $$ENDIF.EnvOutput

       $$IfThenI.labOutput %aux_Labour_Output%=="ON"
           $$If NOT SET IfPostProcedure $$BATINCLUDE "%AuxPrgDir%\02-labour_market.gms" "deviation"
       $$ENDIF.labOutput

       OPTION clear=bau_Gross_output;

   $$ENDIF.loadFi

$EndIf.CalcDevToBauV

*   Cleaning after %YearEndofSim%

$IfTheni.NotComp NOT %SimType%=="CompStat"

    out_GDP(typevar,gdp_definition,units,ra,t) $ after(t,"%YearEndofSim%") = 0;
    out_Value_Added(typevar,gdp_definition,units,regions,agents,t) $after(t,"%YearEndofSim%") = 0;
    out_Gross_output(typevar,units,regions,agents,t) $ after(t,"%YearEndofSim%") = 0;
    out_Ratios(typevar,ratioslist,units,ra,agents,t) $ after(t,"%YearEndofSim%") = 0;

    $$IFI %aux_Environment_Output%=="ON" out_Environment(typevar,envlist,envunits,ra,agents,t) $ after(t,"%YearEndofSim%") = 0;

$EndIf.NotComp

*******************************************************************************************************************************************************************
*******************************************************************************************************************************************************************
*******************************************************************************************************************************************************************
***HRR: output variables for MainOutput.gdx

Parameters
    gva_real(r,aa,t)
    gva_nominal(r,aa,t)
    gross_output_real(r,a,t)
    gross_output_nominal(r,a,t)
    exports_real(ra,ia,t)
    exports_nominal(ra,ia,t)
    gross_investment_real(ra,ia,t)
    gross_investment_nominal(ra,ia,t)
    Kstock_real(ra,agents,t)
    Kstock_nominal(ra,agents,t)
    gross_wage(ra,a,t)
    employment(ra,a,t)
    emi_tot(r,t)                        "Overall emissions incl. LULUCF"
    emi_source(ra,agents,t)             "Emissions by source, excl. LULUCF"
    ely_generation(ra,agents,t)
    ely_price_source(ra,agents,t)
    ely_price_consumer(r,t)
    carbon_tax(r,t)
    GDP_real(ra,t)
    GDP_nominal(ra,t)
    elymix2(r,elyantd,t)
;

    gva_real(r,aa,t)                    = out_Value_Added("abs","Basic Prices","real",r,aa,t) ;
    gva_nominal(r,aa,t)                 = out_Value_Added("abs","Basic Prices","nominal",r,aa,t) ;
    gross_output_real(r,a,t)            = out_Gross_output("abs","real",r,a,t) ;
    gross_output_nominal(r,a,t)         = out_Gross_output("abs","nominal",r,a,t) ;
    exports_real(ra,ia,t)               = out_Trade("abs","Trade Flows (FOB)","real",ra,"WORLD",ia,t) ;
    exports_nominal(ra,ia,t)            = out_Trade("abs","Trade Flows (FOB)","nominal",ra,"WORLD",ia,t) ;
    gross_investment_real(ra,ia,t)      = out_Final_Demands("abs","real",ra,ia,"inv",t) ;
    gross_investment_nominal(ra,ia,t)   = out_Final_Demands("abs","nominal",ra,ia,"inv",t) ;
    gross_wage(ra,a,t)                  = out_Labour("abs","Gross wage","real",ra,"Labour",a,t) * 1000000;
    employment(ra,a,t)                  = out_Labour("abs","Employment","volume",ra,"Labour",a,t) ;
*    emissions(ra,t)                     = out_Environment("abs","Emission all sources (incl. CO2 LULUCF)","GHG (Mt CO2eq)",ra,"Total",t) ;
    emi_tot(r,t)                        = emiTot.l(r,"GHG",t) ;
    emi_source(ra,agents,t)             = out_Environment("abs","Emission all sources","GHG (Mt CO2eq)",ra,agents,t) ;
    ely_generation(ra,agents,t)         = out_Energy("abs","Electricity Generation","TWh",ra,agents,t) ;
    ely_price_source(ra,agents,t)       = out_Energy("abs","Electricity Price","TWh",ra,agents,t) ;
    ely_price_consumer(r,t)             = out_Prices("abs","Consumer",r,"ely-c","hhd",t) ;
    carbon_tax(r,t)                     = emiTax.l(r,"co2",t) / cscale;
    GDP_real(ra,t)                      = out_GDP("abs","Market Prices","real",ra,t) ;
    GDP_nominal(ra,t)                   = out_GDP("abs","Market Prices","real",ra,t) ;
    Kstock_real(ra,agents,t)            = out_Capital("abs","Capital stock","real",ra,agents,t) ;
    Kstock_nominal(ra,agents,t)         = out_Capital("abs","Capital stock","nominal",ra,agents,t) ;


elyMix2(r,elyantd,t)$x0(r,elyantd,"ELY-c",t) = (x.l(r,elyantd,"ELY-c",t)  * x0(r,elyantd,"ELY-c",t) ) 
                               / sum(elyantd2, (x.l(r,elyantd2,"ELY-c",t) * x0(r,elyantd2,"ELY-c",t))) ;

EXECUTE_UNLOAD "%oDir%\MainOutput\%simName%_outAuxi.gdx", gva_real, gva_nominal, gross_output_real, gross_output_nominal, exports_real, exports_nominal,
                                                        gross_investment_real, gross_investment_nominal, gross_wage, employment, emi_tot, emi_source, 
                                                        ely_generation, ely_price_source, ely_price_consumer, carbon_tax, GDP_real, GDP_nominal,elymix2, 
                                                        Kstock_real, Kstock_nominal ;
*******************************************************************************************************************************************************************
*******************************************************************************************************************************************************************
*******************************************************************************************************************************************************************




*------------------------------------------------------------------------------*
*           Country Files (if activated, by default is not )                   *
*------------------------------------------------------------------------------*

$IFI %IfAuxiByCty%=="ON" $BATINCLUDE "%AuxPrgDir%\10-Output_by_country.gms" "run"

*------------------------------------------------------------------------------*
*    Final step = save all auxilliary variables in a specific output file      *
*               	Default: %AuxiFile%=="ON"         			               *
*------------------------------------------------------------------------------*

* [TBU]: pour le moment pas de multi-sim
* LOOP(sim,

$IfThenI.savespec NOT %AuxiFile%=="OFF"

* Limit the number of year for NOT abstype(typevar) for some variable

    IF(%aux_outType% ne FULL,
        $$IfThen.exp %aux_expenses_composition%=="ON"
            out_GrossOutput_structure(typevar,units,ra,items,agents,t)
                $ (NOT ReportYr(t) AND (NOT abstype(typevar)) ) = 0;
            out_ValueAdded_structure(typevar,units,ra,items,agents,t)
                $ (NOT ReportYr(t) AND (NOT abstype(typevar)) ) = 0;
            out_expenses_composition_mp(typevar,expenses_type,units,ra,ia,agents,t)
                $ (NOT ReportYr(t) AND NOT abstype(typevar)) = 0;
        $$ENDIF.exp
        $$IF %aux_trade_output%=="ON" out_Trade(typevar,tradelist,units,origin,destination,ia,t) $ (NOT ReportYr(t) AND NOT abstype(typevar)) = 0;
    ) ;

* Unload the file

*    $$If Not SET FileDet PUT_UTILITY SaveAuxOutput 'gdxout' / '%oAuxiDir%\%AuxiFile%_'          sim.tl:0 '.gdx';
*    $$IF     SET FileDet PUT_UTILITY SaveAuxOutput 'gdxout' / '%oAuxiDir%\%AuxiFile%_%FileDet%' sim.tl:0 '.gdx';

    PUT_UTILITY SaveAuxOutput 'gdxout' / '%oAuxiDir%\%AuxiFile%_%SimName%.gdx';

    EXECUTE_UNLOAD
            $$IFI %aux_Energy_Output%     =="ON" out_Energy,
            $$IFI %aux_NewEnergy_Output%  =="ON" out_NewEnergy,
            $$IfThenI.AuxExp %aux_expenses_composition%=="ON"
                out_GrossOutput_structure, out_ValueAdded_structure,
                out_Total_Demands, out_Final_Demands, out_Intermediary_Demands,
*                out_expenses_composition_mp,
            $$EndIf.AuxExp
            $$IFI %aux_growth_accounting% =="ON" out_Solow_decomposition,
            $$IFI %aux_trade_output%      =="ON" out_Trade, out_External,
            $$IFI %Module_OAP%            =="ON" out_Emi_LAP,
            $$IFI %Module_materials%      =="ON" out_Materials,
            $$IFI %aux_Environment_Output%=="ON" out_Environment,
            $$IFI %aux_Agriculture_Output%=="ON" out_Agriculture,
            $$IFI %aux_materials_output%  =="ON" out_materials_output, out_test,
            $$IFI %aux_Labour_Output%     =="ON" out_labour,
            $$IFI %aux_Capital_Output%    =="ON" out_Capital,
            $$IFI %aux_SDG%               =="ON" out_SDG,

            out_GDP, out_Value_Added, out_Ratios, out_Prices, out_Gross_output
        ;

* Clear all the auxilliary variables to reduce size of "%SimName%.gdx"

    $$BATINCLUDE "%AuxPrgDir%\sub-clear_auxi.gms" "out"
    $$IfI %aux_Labour_Output%=="ON" OPTION clear=out_labour;
    $$IfI %aux_trade_output% =="ON" OPTION clear=out_External;

    $$IfTheni.ClearTmpVar %IfAuxiByCty%=="ON"
        $$BATINCLUDE "%AuxPrgDir%\sub-clear_auxi.gms" "tmp"
        $$IfI %aux_Labour_Output%=="ON" OPTION clear=tmp_labour;
        $$IfI %aux_trade_output% =="ON" OPTION clear=tmp_External;
        OPTION clear=tmp_Gross_output, clear=tmp_Macroeconomic;
    $$Endif.ClearTmpVar

$ENDIF.savespec

* ) ; !! End loop on Sim

OPTION clear=stepa, clear=step1, clear=ratwork;









