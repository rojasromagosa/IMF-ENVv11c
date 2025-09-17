$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
   Name of the File : "%OutMngtDir%\OutMacro.gms"
   purpose          : output for macroeconomic variables
                        (e.g. no sectoral or product detail)
   created date     : 2021-03-10 (from ENV-Linkages out_macroeconomic.gms)
   created by       : Jean Chateau
   called by        : %ModelDir%\10-PostSimInstructions.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacro.gms $
   last changed revision: $Rev: 388 $
   last changed date    : $Date:: 2023-09-01 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

file SaveMacroOut;

$setglobal OutMacroPrgDir "%OutMngtDir%\OutMacroPrg"

$Ontext
* [EditJean]: pim = mark_up(r,a,t)] dans EL (non-scaled)

            Remarque sur les macros de Prix
D'abord     IfSub  = IfPrxEq    dans ENV-L

*--> m_PP   (ENV-L) = true producer price (ie not normalized)
*--> PP_SUB (here) = normalized producer price : pp.l
*--> m_PP(r,a,t) = pp0(r,a) * PP_SUB(r,a,t)
* En fait au niveau des Outputs les macros ne jouent plus vraiment
* on met m_true2(pp,r,a,t) et on se moque de la valeur IfSub

pa.l(r,i,aa,tsim) = PA_SUB(r,i,aa,tsim) : prix agent normalises
m_PAA(r,i,aa,t) (ENV-L)   = true agent price (ie not normalized)
                          = pa0(r,i,aa) * PA_SUB(r,i,aa,t)
                          = pa0(r,i,aa) * pa(r,i,aa,t)
                          = m_true3(pa,r,i,aa,t)

m_PWE(r,i,rp,t) (ENV-L)  = m_true3(pwe,r,i,rp,tsim)
                         = PWE_SUB(r,i,rp,tsim) * pwe0(r,i,rp)
                         = pwe.l(r,i,rp,tsim)   * pwe0(r,i,rp)

m_PWM(r,i,rp,t) (ENV-L)  = m_true3(pwm,r,i,rp,t)
                         = pwm.l(r,i,rp,tsim)   * pwm0(r,i,rp)
                         = PWM_SUB(r,i,rp,tsim) * pwm0(r,i,rp)

*---    Bilateral unscaled prices
m_PDM(r,i,rp,t) (ENV-L)  = m_true3(pdm,r,i,rp,tsim)
                         = pdm.l(r,i,rp,tsim)   * pdm0(r,i,rp)
                         = PDM_SUB(r,i,rp,tsim) * pdm0(r,i,rp)

*---    Margin quantities (incl. margin efficiency)
m_XWMG(r,i,rp,t)        = m_true3(xwmg,r,i,rp,tsim)
                        = xwmg0(r,i,rp) * XWMG_SUB(r,i,rp,tsim)
                        = xwmg0(r,i,rp) * xwmg(r,i,rp,tsim)

m_XMGM(img,r,i,rp,t)    = m_true4(xmgm,img,r,i,rp,t)
                        = xmgm0(img,r,i,rp) * xmgm.l(img,r,i,rp,tsim)
                        = xmgm0(img,r,i,rp) * XMGM_SUB(img,r,i,rp,tsim)

m_PWMG(r,i,rp,t)        = m_true3(pwmg,r,i,rp,t)
                        = pwmg.l(r,i,rp,tsim)   * pwmg0(r,i,rp)
                        = PWMG_SUB(r,i,rp,tsim) * pwmg0(r,i,rp)

$macro m_plandp(r,a,t) \
    [ {(1 + sum(lnd.local, m_netTaxfp(r,a,lnd,t))) * m_true(pland(r,a,t)) \
        + sum(lnd.local,m_Permisfp(r,lnd,a,t)) } $ IfSub \
    + {scale_pland(r,a,t) * plandp(r,a,t)     } $ {not IfSub} ]   \

$macro m_pnrfp(r,a,t) \
    [ {(1 + sum(nrs.local,m_netTaxfp(r,a,nrs,t))) * m_true(pnrf(r,a,t)) }$IfSub \
    + {scale_pnrf(r,a,t) * pnrfp(r,a,t)}${not IfSub} ] \

$macro m_ph2op(r,a,t) \
    [ {(1 + sum(wat.local,m_netTaxfp(r,a,wat,t))) * m_true(ph2o(r,a,t)) }$IfSub \
    + {scale_ph2o(r,a,t) * ph2op(r,a,t)}${not IfSub} ]\

$Offtext

*------------------------------------------------------------------------------*
*       Change the reference year for out_variables calculation [Optional]     *
*------------------------------------------------------------------------------*

PARAMETERS
    To%YearBasePPP%PPP(r) "Coefficient to convert unit of the model (e.g. %YearGTAP% USD) into %YearBasePPP%-PPP"
    To%YearBaseMER%MER(r) "Coefficient to convert unit of the model (e.g. %YearGTAP% USD) into %YearBaseMER%-USD, constant %YearBaseMER% MER"
    woap(ra,oap,t)        "working variable"
;

* Default

To%YearBaseMER%MER(r) = 1;
To%YearBasePPP%PPP(r) = 1;

IF(ifDyn,

    To%YearBasePPP%PPP(r) $ ypc("cst_usd",r,"%YearBaseMER%")
        = ypc("cur_itl",r,"%YearBaseMER%") / ypc("cst_usd",r,"%YearBaseMER%") ;

    To%YearBaseMER%MER(r) $ ypc("cst_usd",r,"%YearBaseMER%")
        = ypc("cur_usd",r,"%YearBaseMER%") / ypc("cst_usd",r,"%YearBaseMER%") ;
) ;

*------------------------------------------------------------------------------*
*               New sets for "out_Macroeconomic"                               *
*------------------------------------------------------------------------------*

SETS
    macrocat    "Category for out_Macroeconomic" /
        "GDP"
        "Emissions"
        "Air pollutants"
        "Energy"
        "Government budget"
        "Demographic"
        "Prices"
        "GDP Expenditures"
        "Credit Market"
        "Labor Market"
        "Trade"
        "Remarkable Ratios"
        "welfare"
    /
    macrolist   "list of main macroeconomic variables" /

        "GDP"                       "(at %YearBaseMER% market prices, millions of USD)"
        "GDP (cst PPP)"             "(at %YearBasePPP% market prices, millions of international USD)"
        "GDP per capita"            "at %YearBaseMER% USD market prices per habitant"
        "GDP per capita (cst PPP)"  "at %YearBasePPP% international USD per habitant"
        "Land Supply"

* "Prices":

        "CPI (Laspeyre)"
        "CPI (Paashe)"  "Consumer Price Index (Paashe)"
        "API (Paashe)"  "Armington Price Index (Paashe)"
        "PPI"           "Production Price Index (Paashe)"
        "Service prices to CPI (Laspeyre)"
        "Service prices to CPI (Paashe)"
        "GDP Deflator"
        "Crude Oil price (Itl. CIF price of import)"
        "Natural Gas price (Itl. CIF price of import)"
        "Coal price (Itl. CIF price of import)"

* [TBU] : add imports & exports

        "Exchange rate (PPP)"  "PPP vis-a-vis US, Index"
        "Exchange rate (MER)"  "MER vis-a-vis US, Index"
        "Capital to GDP ratio"
        "Capital to efficient labour ratio"
        "Terms of trade"
        "Disposable income per capita"           "constant %YearBaseMER% USD per habitant"
        "Disposable income per capita (cst PPP)" "constant %YearBasePPP% USD per habitant"
        "Government Consumption"
        "Government Consumption to GDP (pct)"
        "Household Consumption"
        "Household Consumption to GDP (pct)"
        "Gross Investment"
        "Gross Investment to GDP (pct)"
        "Household Consumption per capita"

* "Credit Market":

        "Household Saving"          "Net (e.g. without depreciation)"
        "Household Saving to GDP"
        "Saving rate (Household)"
        "Government Saving"
        "Government Saving to GDP"
        "Depreciation"
        "Net Investment"
        "Net Investment to GDP (pct)"
        "Foreign Saving"
        "Current account"          		 "Counterpart of Foreign Saving"
        "Current account to GDP (pct)"
        "Trade Balance"
        "Trade Balance to GDP (pct)"
        "Trade openness to GDP (pct)"  "In nominal terms"
        "Lump sum transfert"

* "Demographic":

        "Population"              "nb of persons (millions)"
        "Working-age population"  "nb of persons (millions): age 15-74"
        "Children population"     "nb of persons (millions): age 0-14"
        "Senior population"       "nb of persons (millions): age 75 and older"
        "Dependency Ratio: old"   "individuals 65+ relative to the population 15 to 64"
        "Dependency Ratio: young" "individuals 0 to 14 relative to the population 15 to 64"

* "Labor Market":

        "Active population"           "nb of persons (millions)"
        "Employment"                  "nb of persons employed (millions)"
        "Participation rate"          "Active population as percentage of working age population"
        "Unemployment rate"           "Unemployment as percentage of active age population"
        "wage rate"                   "Nominal Net-of-social contribution wage rate"
        "wage rate (relative to CPI)" "Real    Net-of-social contribution wage rate"
        "net-of-tax wage rate"        "Net-of-income tax wage rate received by households"
        "gross wage rate"             "Gross-of-social contribution wage rate paid by firms"
        "Job creations"
        "Job destructions"
        "Total job reallocation"
        "Net employment growth"
        "Excess worker reallocation"

* "Emissions" of GHG:

* memo: emissions are reported in Mt CO2eq.
*	(ie Million tonnes of carbon‐dioxide equivalent) - as in IEA WEO reports

        "CO2 from fossil fuel combustion"   	"Mt CO2eq."
        "CO2 All sources (excl. CO2 LULUCF)"	"Mt CO2eq. (excl. CO2 LULUCF)"
        "CO2 All sources"    					"Mt CO2eq. (excl. CO2 LULUCF)"
        "CH4 All sources"                   	"Mt CO2eq."
        "N2O All sources"                   	"Mt CO2eq."
        "PFC All sources"                   	"Mt CO2eq."
        "HFC All sources"                   	"Mt CO2eq."
        "SF6 All sources"                   	"Mt CO2eq."
		"FGAS All sources"                   	"Mt CO2eq."
        "GHG All sources (excl. CO2 LULUCF)"	"Mt CO2eq. (excl. CO2 LULUCF)"
        "GHG All sources" 						"Mt CO2eq. (excl. CO2 LULUCF)"
        "CO2 LULUCF"  "CO2 emissions from land use, land‐use change and forestry (Mt CO2eq.)"

        "CO2 (excl. CO2 LULUCF) per GDP"			"kg per 1000 %YearBaseMER% USD, Thousands  (excl. CO2 LULUCF)"
        "CO2 per GDP"           					"kg per 1000 %YearBaseMER% USD, Thousands  (excl. CO2 LULUCF)"
        "GHG (excl. CO2 LULUCF) per GDP"        	"kg per 1000 %YearBaseMER% USD, Thousands  (excl. CO2 LULUCF)"
        "GHG per GDP" 								"kg per 1000 %YearBaseMER% USD, Thousands"
        "CO2 from fossil fuel combustion per GDP"	"kg per 1000 %YearBaseMER% USD, Thousands"

        "CO2 per capita"        					 "metric tons per capita"
        "GHG per capita"        					 "metric tons per capita"
        "CO2 from fossil fuel combustion per capita" "metric tons per capita"

        "Carbon Price"                    "Average on all GHG (%YearUSDCT% USD, per tCO2 eq.)"
        "CO2 Price"                       "Average on CO2 (%YearUSDCT% USD, per tCO2)"
        "CO2 Price (on Active Sources)"   "Average on CO2 on Active Sources (%YearUSDCT% USD, per tCO2)"

* "Emissions" of Air pollutants: (1000 t)

        "BC (1000 t)"       "Black carbon"
        "CO (1000 t)"       "Carbon monoxide"
        "NH3 (1000 t)"      "Ammonia"
        "NOX (1000 t)"      "Nitrogen Oxide"
        "OC (1000 t)"       "Organic Carbon"
        "PM (1000 t)"       "Particulate Matter"
        "SO2 (1000 t)"      "Sulfur dioxide"
        "PM10 (1000 t)"     "Ultrafine particulate matter"
        "PM25 (1000 t)"     "Fine particulate matter"
        "NMVOC (1000 t)"    "Non-methane volatile organic compounds"
        "SOX (1000 t)"      "Sulfur oxide"

* "Energy":

        "Electricity Generation (TWh)" "TWh"
        "Electricity renewable (share)" "(percentage of total generation)"
        "Electricity Fossil (share)"    "(percentage of total generation)"
        "Total energy supply"			"Million tonnes of oil equivalent (Mtoe)"
        "Total energy supply (TFC calc.)"
        "Total final consumption of energy"
        "Total energy supply per capita"
        "Energy Intensity"				  "Total Energy Supply to Real GDP (toe per thousand of %YearBaseMER% USD)"
        "Energy Intensity (cst PPP)"
		"Energy Intensity (TFC calc.)"
        "Imported energy share"

*	Sector composition

        "Labour Productivity"    "Gross domestic product (GDP) at market prices per person employed"
        "Labour Income Share"    "Total gross labour income as GDP percentage"
        "Service share (BP)"     "percentage of total value added at Basic Price"
        "Industry share (BP)"    "percentage of total value added at Basic Price"
        "Agriculture share (BP)" "percentage of total value added at Basic Price"

* "Government budget":

        "Indirect taxes"
        "Production taxes"
        "Factor taxes"
        "Import taxes"
        "Export taxes"
        "Carbon taxes"
        "Direct taxes"
        "Consumption subsidies"
        "Production subsidies"
        "Factor subsidies"
        "Import subsidies"
        "Export subsidies"
        "Income subsidies"
        "Total Taxes"
        "Total Subsidies"

* Welfare analysis

        "subsistence bundle"
        "utility price index"
        "indirect utility"
        "direct utility"
        "supernumary income"

        "indirect utility (from model)"
        "utility price index (2.)"

        "Expenditure Function e(p.u)"
        "Expenditure Function e(pbau.ubau)"
        "Expenditure Function e(p.ubau)"
        "Expenditure Function e(pbau.u)"
        "Equivalent variation in income"
        "Compensating variation in income"
    /

    labmacrolist(macrolist) /
        "Job creations"
        "Job destructions"
        "Total job reallocation"
        "Net employment growth"
        "Excess worker reallocation"
    /
;

PARAMETER
    out_Macroeconomic(typevar,macrocat,macrolist,units,ra,tt) "Remarkable Macro-economic variables grouped in one single variable"
    out_Utility(macrolist,r,t)   "Utility outputs by individual regions"
    $$Ifi %devtobau%=="ON" bau_Macroeconomic(typevar,macrocat,macrolist,units,ra,t)
;

* [TBU]: $IFI %fillHist%=="ON" PARAMETER tHist(macrolist,units,ra,tt);

*   Population and Working-age population

$OnDotL
out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%2)
    = sum(mapr(ra,r), m_true1(POP,r,%2)) / popScale;
out_Macroeconomic(abstype,"Demographic","Working-age population","volume",ra,%2)
    = sum((r,l,z) $ mapr(ra,r), m_true3(popWA,r,l,z,%2)) / popScale ;
$OffDotL

*   GDP measures and Final Demands

$batinclude "%OutMacroPrgDir%\01-final_demands.gms" "%2"

*   Trade Balance and External accounts

$batinclude "%OutMacroPrgDir%\02-Trade_and_External_accounts.gms" "%2"

*   Income and Savings market (incl. capital ratio)

$batinclude "%OutMacroPrgDir%\03-Income.gms" "%2"

*   GHG & OAP emissions

$batinclude "%OutMacroPrgDir%\04-Emissions.gms" "%2"

*   Energy

$batinclude "%OutMacroPrgDir%\06-Energy.gms" "%2"

*   Prices and Exchanges rates

$batinclude "%OutMacroPrgDir%\07-Prices_Index.gms" "%2"

*   Labour Market

$batinclude "%OutMacroPrgDir%\08-Labour_market.gms" "%2"

*   Sectoral shares at Basic Prices (e.g. AP or brut like World Bank)

$batinclude "%OutMacroPrgDir%\09-Sector_Shares.gms" "%2"

*   Governement Revenues (millions of %YearGTAP% USD)

$batinclude "%OutMacroPrgDir%\10-Gov_Revenues.gms" "%2"

*   Credit Market

$batinclude "%OutMacroPrgDir%\11-Credit_Market.gms" "%2"

*   Welfare Analysis

$batinclude "%OutMacroPrgDir%\12-Welfare.gms" "%2" "welf1"

*------------------------------------------------------------------------------*
*       Population variables (exogenous so can be calculated at "atEoF")       *
*------------------------------------------------------------------------------*

$IfThenI.CalMode "%SimType%"=="baselineTBU"
   out_Macroeconomic(abstype,"Demographic","Population","volume",ra,t)
       = sum(mapr(ra,r), POPvar("Total",r,t));
   out_Macroeconomic(abstype,"Demographic","Children population","volume",ra,t)
       = sum(mapr(ra,r), POPvar("Total",r,t)-POPvar("15Plus",r,t));
   out_Macroeconomic(abstype,"Demographic","Senior population","volume",ra,t)
       = sum(mapr(ra,r), POPvar("75plus",r,t));
   out_Macroeconomic(abstype,"Demographic","Working-age population","volume",ra,t)
       = out_Macroeconomic(abstype,"Demographic","Population","volume",ra,t)
       - out_Macroeconomic(abstype,"Demographic","Children population","volume",ra,t);
   out_Macroeconomic(abstype,"Demographic","Dependency Ratio: old","volume",ra,t)
       $ sum(mapr(ra,r), POPvar("15plus",r,t) - POPvar("65plus",r,t))
       = sum(mapr(ra,r), POPvar("65plus",r,t))
       / sum(mapr(ra,r), POPvar("15plus",r,t) - POPvar("65plus",r,t));
   out_Macroeconomic(abstype,"Demographic","Dependency Ratio: young","volume",ra,t)
       $ sum(mapr(ra,r), POPvar("15plus",r,t) - POPvar("65plus",r,t))
       = out_Macroeconomic(abstype,"Demographic","Children population","volume",ra,t)
       / sum(mapr(ra,r), POPvar("15plus",r,t) - POPvar("65plus",r,t));
$EndIf.CalMode

*------------------------------------------------------------------------------*
*       Calculate "g_dev", "ratio_to_%YearRef%" and  "devtoBau"                *
*------------------------------------------------------------------------------*

LOOP(abstype,

* Growth rate between two year

$Ifi NOT %SimType%=="CompStat" out_Macroeconomic("g_dev",macrocat,macrolist,units,ra,t) $ (beforeOrEQ(t,"%YearEndofSim%") and out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t-1))
$Ifi     %SimType%=="CompStat" out_Macroeconomic("g_dev",macrocat,macrolist,units,ra,t) $ (out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t-1))
        = [  out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t)
        / out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t-1) - 1];

* Ratio to %YearRef%

    IF(IfDyn,
        out_Macroeconomic("ratio_to_%YearRef%",macrocat,macrolist,units,ra,t)
            $ (beforeOrEQ(t,"%YearEndofSim%")
                and out_Macroeconomic(abstype,macrocat,macrolist,units,ra,"%YearRef%"))
            = out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t)
            / out_Macroeconomic(abstype,macrocat,macrolist,units,ra,"%YearRef%");
	) ;
) ;

*   Percentage deviation to the baseline [Option: %devtobau%=="ON"]

* security

$Ifi %SimType%=="Baseline" $SetGlobal devtobau "OFF"

$IfTheni.CalDevToBau %devtobau%=="ON"

    $$IfThen.BauVar EXIST "%oDir%\Bau.gdx"
        $$SetGlobal vBau "%oDir%\Bau"
    $$Else.BauVar
        $$SetGlobal vBau "%BauFile%"
    $$EndIf.BauVar

    $$IfThen.bau EXIST "%vBau%.gdx"

* [TBC] Domain check does not work if you have historical on in baselines but off in variants

* [EditJean] remettre EXECUTE_LOADDC quand errreur utilite corrigee
        EXECUTE_LOAD "%BauFile%.gdx", bau_Macroeconomic=out_Macroeconomic;

        LOOP(abstype,
            out_Macroeconomic("devtoBau",macrocat,macrolist,units,ra,t)
                $(bau_Macroeconomic(abstype,macrocat,macrolist,units,ra,t)
                    and out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t)
                    and not labmacrolist(macrolist))
                = [ out_Macroeconomic(abstype,macrocat,macrolist,units,ra,t)
                / bau_Macroeconomic(abstype,macrocat,macrolist,units,ra,t)-1];
        ) ;

        $$batinclude "%OutMacroPrgDir%\12-Welfare.gms" "t" "welf2"

        OPTION clear=bau_Macroeconomic;

    $$EndIf.bau

$EndIf.CalDevToBau

*	Fill backward with historical variables

* #TODO: This overwrites projections for e.g. Working Age Population!!!
*    $$IFI.fillHist %fillHist%=="ON" $include "%OutMacroPrgDir%\fill_historical_variables.gms"


*	Unload out_Macroeconomic in a specific file [Option: and folder]

IF(Ifdyn,
	out_Macroeconomic(typevar,macrocat,macrolist,units,ra,tt)
		$ after(tt,"%YearEndofSim%") = 0 ;
) ;

* No Multi-sim for now

$IFi     %oGdxDir_Macro%=="ON" PUT_UTILITY SaveMacroOut 'gdxout' / '%oDir%\outMacro\outMacro_%simName%.gdx';
$IFi NOT %oGdxDir_Macro%=="ON" PUT_UTILITY SaveMacroOut 'gdxout' / '%oDir%\outMacro_%simName%.gdx';
EXECUTE_UNLOAD out_Macroeconomic;

$OnText
* [TBU]: multi-sim Cases
$IfThen.StdCases NOT SET FileDet
*       Standard Cases
    $$IF     DEXIST "%oDir%\outMacro" PUT_UTILITY SaveMacroOut 'gdxout' / '%oDir%\outMacro\outMacro_' sim.tl:0 '.gdx';
    $$IF NOT DEXIST "%oDir%\outMacro" PUT_UTILITY SaveMacroOut 'gdxout' / '%oDir%\outMacro_' sim.tl:0 '.gdx';
$Else.StdCases
*       For multi-run cases
    LOOP(sim,
        PUT_UTILITY SaveMacroOut 'gdxout' / '%Folderoutputs%\out_Macroeconomic\%FileDet%_' sim.tl:0 '.gdx';
    );
$EndIf.StdCases
EXECUTE_UNLOAD out_Macroeconomic;
$OffText

* Clear total (e.g. "ttot-a")

out_Value_Added(typevar,gdp_definition,notvol,ra,tota,t) = 0;
out_Gross_output(typevar,notvol,ra,tota,t)               = 0;

* convert in billion USD if OutAuxi not done or inactive
* because this is done at the end of OutAuxi.gms, after manipulations

$IfTheni.STD NOT SET IfPostProcedure

    $$IfTheni.NotAuxi NOT %IfAuxi%=="ON"
        work = 0.001;
        out_Value_Added(abstype,gdp_definition,notvol,ra,aga,t)
            = out_Value_Added(abstype,gdp_definition,notvol,ra,aga,t) * work;
        out_Gross_output(abstype,notvol,ra,aga,t)
            = out_Gross_output(abstype,notvol,ra,aga,t) * work;
    $$Endif.NotAuxi

$EndIf.STD

$Label OnGoing
