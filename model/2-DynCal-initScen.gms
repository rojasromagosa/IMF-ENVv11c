$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
        GAMS file    : "%ModelDir%\2-DynCal-initScen.gms"
        purpose      : Exogenous assumptions dynamic baseline
                                        Only for dynamic calibration mode
        Created from : Dominique van der Mensbrugghe for [ENVISAGE] model
                                        + add-ons by Jean Chateau for [OECD-ENV] model
        Created date :
        called by    : %ModelDir%\Baseline.gms
--------------------------------------------------------------------------------
        $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/2-DynCal-initScen.gms $
        last changed revision: $Rev: 518 $
        last changed date    : $Date:: 2024-02-29 #$
        last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*       Preamble:  Folder to store checking files for a dynamic calibration scenario
* should be declared after DirCheck in "%ModelDir%\2-CommonIns.gms"

$SetGlobal DirCheckCal  "%DirCheck%\Calibration"
$IF NOT DEXIST "%DirCheckCal%" $call "mkdir %DirCheckCal%"
* $SetGlobal CheckCalFile "%DirCheckCal%\%simName%"
$SetGlobal CheckCalFile "%DirCheckCal%\check"

*------------------------------------------------------------------------------*
*       ENVISAGE Model assumptions for dynamic baseline (from SSP)             *
*------------------------------------------------------------------------------*

*   Default: Load SSPs data from DvM

***HRR: for now we are only using Pop and GDP from SSP. For educScen we'll need add.adjs.
Execute_loaddc "%iDataDir%\agg\%Prefix%Scn.gdx", popScen, gdpScen, educScen ;

*   Option: "SSP0" indicates that we Load ENV-Growth Scenario pop & GDP

***HRR: changes to read the specific SSP scenario chosen in ModelOption.gms

***old using OECD gdx file
$IfTheni.ENVGpop %POPSCEN%=="SSP0"

    Set SetMacroTgt / "pop", "pop15", "pop1564", "UNR", "ERT" / ;
    PARAMETER MacroENVG(SetMacroTgt,r,tt), POPdet(Setdemog,r,tt);
    EXECUTE_LOAD "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx",
                MacroENVG, POPdet;
    popScen("SSP0",r,"PLT15",tt)
                = [MacroENVG("pop",r,tt) - MacroENVG("pop15",r,tt)] / popScale;
    popScen("SSP0",r,"P65UP",tt) $ POPdet("Total",r,tt)
        = [POPdet("65Plus",r,tt) / POPdet("Total",r,tt)]
                * MacroENVG("pop",r,tt) / popScale;
    popScen("SSP0",r,"P1564",tt)
        = [  MacroENVG("pop",r,tt)
           - MacroENVG("pop15",r,tt) - popScen("SSP0",r,"P65UP",tt)] / popScale;
    popScen("SSP0",r,"P1574",tt) = MacroENVG("pop1574",r,tt) / popScale;
    popScen("SSP0",r,"PTOTL",tt) = MacroENVG("pop",r,tt)     / popScale;
$Endif.ENVGpop


$IfTheni.ENVGgdp %SSPSCEN%=="SSP0"

    PARAMETER ENVGrowth_GDP(gdp_unit,r,tt);
    $$IFi NOT %POPSCEN%=="SSP0" Set SetMacroTgt / "pop", "UNR", "ERT" / ; PARAMETER MacroENVG(SetMacroTgt,r,tt);
    $$IFi NOT %POPSCEN%=="SSP0" EXECUTE_LOAD "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx", MacroENVG, ENVGrowth_GDP, ypc;
    $$IFi     %POPSCEN%=="SSP0" EXECUTE_LOAD "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx", ENVGrowth_GDP, ypc;

    gdpScen("%SSPMOD%","%SSPSCEN%","gdppc",r,t) $ MacroENVG("pop",r,t)
        = ENVGrowth_GDP("cst_usd",r,t) /  MacroENVG("pop",r,t) ;

$Else.ENVGgdp

***HRR: Old code based on OECD gdx file
*    $$IF     EXIST "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx" EXECUTE_LOAD "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx", ypc;
*    $$IF NOT EXIST "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx" ypc(gdp_unit,r,tt) = 0 ;
***new
ypc("cst_itl",r,tt) = gdpScen("OECD","SSP2","GDP_per_capita|PPP",r,tt) ;
***endHRR

$Endif.ENVGgdp


*   Use/Not use GTAP database population

IF(%OVERLAYPOP% eq 1,
   popg(r) = sum(t0, popScen("%POPSCEN%",r,"PTOTL",t0)) ;
ELSE
   execute_loaddc "%iDataDir%\%DataType%\%Prefix%Dat.gdx", popg=pop ;
) ;

*  Calculate the growth in total population

popT(r,"PTOTL",t0) = popScale * popg(r) ;

loop(t $ (not t0(t)),

    popT(r,"PTOTL", t) $ popScen("%POPSCEN%",r,"PTOTL",t-1)
        = popT(r,"PTOTL",t-1)
        * popScen("%POPSCEN%",r,"PTOTL",t)
        / popScen("%POPSCEN%",r,"PTOTL",t-1) ;

) ;

* OECD-ENV model: Add pop15T dynamic+ [2022-11-24] Labor force is now pop1574T

Parameter pop15T(r,t) ;

pop15T(r,t0) $ popScen("%POPSCEN%",r,"PTOTL",t0)
    = popT(r,"PTOTL",t0)
    * [popScen("%POPSCEN%",r,"PTOTL",t0) - popScen("%POPSCEN%",r,"PLT15",t0)]
    /  popScen("%POPSCEN%",r,"PTOTL",t0) ;

loop(t $ (not t0(t)),

    pop15T(r,t)
                $ [popScen("%POPSCEN%",r,"PTOTL",t-1) - popScen("%POPSCEN%",r,"PLT15",t-1)]
        = pop15T(r,t-1)
        * [popScen("%POPSCEN%",r,"PTOTL",t)   - popScen("%POPSCEN%",r,"PLT15",t)]
        / [popScen("%POPSCEN%",r,"PTOTL",t-1) - popScen("%POPSCEN%",r,"PLT15",t-1)] ;
) ;

* Update the tranches according to the structure in popScen

popT(r,tranche,t) $ popScen("%POPSCEN%",r,"PTOTL",t)
    = popT(r,"PTOTL", t)
    * popScen("%POPSCEN%",r,tranche,t) / popScen("%POPSCEN%",r,"PTOTL",t) ;

pop.fx(r,t) = popT(r,"PTOTL",t) ;

*   Calculate GDP trend, assuming per capita growth rates are as given by scenario
**HRR: changed
*** old rgdppcT(r,t) = gdpScen("%SSPMOD%","%SSPSCEN%","gdppc",r,t) ;
rgdppcT(r,t) = gdpScen("OECD","SSP2","GDP_per_capita|PPP",r,t) ;
***endHRR

* Assumptions about labor force participation rates

lfpr_envisage(r,l,"PLT15",t) = 0 ;
lfpr_envisage(r,l,"P1564",t) = 2 / 3 ;
lfpr_envisage(r,l,"P65UP",t) = 0 ;

*   Adapt to model LF market variables

$IfTheni.cal %DynCalMethod%=="ENVISAGE"

* Pas tout a fait la methode de DvM car on a change lszEQ(r,l,z,t)

    $$IfThen.ENVG NOT %SSPSCEN%=="SSP0"

* use SSP projection --> active year 15 year and older (should update SSPPOP with 1574)

        popWA.l(r,l,rur,t) = popT(r,"P1564",t) * 0.5;
        popWA.l(r,l,urb,t) = popT(r,"P1564",t)-sum(rur,popWA.l(r,l,rur,t));
        popWA.l(r,l,nsg,t) $ (NOT ifLSeg(r,l)) = sum(z,popWA.l(r,l,z,t));
        popWA.l(r,l,z,t)   $ (NOT ifLSeg(r,l) and NOT nsg(z)) = 0 ;
        LFPR.l(r,l,z,t)    = lfpr_envisage(r,l,"P1564",t) ;
        UNR.l(r,l,z,t) = 0 ;

    $$Else.ENVG

* use ENV-Growth projection --> active year 15-74

        popWA.l(r,l,rur,t) = pop1574T(r,t) * 0.5;
        popWA.l(r,l,urb,t) = pop1574T(r,t) - sum(rur,popWA.l(r,l,rur,t));
        popWA.l(r,l,nsg,t) $ (NOT ifLSeg(r,l)) = sum(z,popWA.l(r,l,z,t));
        popWA.l(r,l,z,t)   $ (NOT ifLSeg(r,l) and NOT nsg(z)) = 0 ;
        UNR.l(r,l,z,t)     = MacroENVG("UNR",r,t) ;
        LFPR.l(r,l,z,t)
            = 0.01 * MacroENVG("ERT",r,t) / (1 - 0.01 * UNR.l(r,l,z,t)) ;

    $$Endif.ENVG

    ETPT(r,l,z,t) $ popWA.l(r,l,z,t)
        = LFPR.l(r,l,z,t) * [1 - 0.01 * UNR.l(r,l,z,t)] * popWA.l(r,l,z,t) ;

$EndIf.cal

*  Calculate education-based growth rates of labor
*  Size of labor by skill based on education and lfpr
*  Needs modification if using UN population profile (for aggregate labor growth)

educ(r,l,t)
    = sum(trs,  lfpr_envisage(r,l,trs,t)
              * sum(educMap(r,l,edx), educScen("GIDD", r, trs, edx, t)) ) ;

***HRR: we have old GIDDProj.gdx file without new v11 countries,
* so we use SSP pop projections for educ (doesn't matter with only one labour-type)
*** Need the new GIDDproj.gdx file
educ(r,l,t) $ (educ(r,l,t) eq 0)
    =   lfpr_envisage(r,l,"P1564",t) * popScen("%POPSCEN%",r,"P1564",t) * outscale ;
***endHRR



loop(t0,
    gLabT(r,l,t) $ ( years(t) gt years(t0) )
    $$IFi NOT %SSPSCEN%=="SSP0"  = 100 * [ (educ(r,l,t) / educ(r,l,t-1))**(1/gap(t)) - 1] ;
    $$IFi     %SSPSCEN%=="SSP0"  = 100 * [ (ETPT(r,l,"nsg",t) / ETPT(r,l,"nsg",t-1))**(1/gap(t)) - 1] ;

* initialization

   glab.l(r,l,t)    $ (years(t) gt years(t0)) = gLabT(r,l,t) ;
   gLabz.l(r,l,z,t) $ (years(t) gt years(t0)) = gLabT(r,l,t) ;
   gtlab.l(r,t)     $ (years(t) gt years(t0))
        $$IFi NOT %SSPSCEN%=="SSP0" = 100 * [ {sum(l, educ(r,l,t)) / sum(l, educ(r,l,t-1))}**(1/gap(t))-1] ;
        $$IFi     %SSPSCEN%=="SSP0" = sum(l,gLabT(r,l,t)) / card(l) ;
) ;

*  Exogenous assumptions about labor productivity

glMltShft(r,l,a,t) = 1 ;

glAddShft(r,l,a,t)    = 0 ;
glAddShft(r,l,agra,t) = 0.02 ;
glAddShft(r,l,mana,t) = 0.02 ;

glMltShft(r,l,a,t) $ tot(a) = 0 ;
glAddShft(r,l,a,t) $ tot(a) = 0 ;

*  AEEI assumptions (in percent)

aeei(r,e,a,v,t)  = 1 ;
aeeic(r,e,k,h,t) = 1 ;
aeei(r,e,a,v,t) $ tot(a) = 0 ;

* [2022-12-01] --> Make no sense to assume high efficiency in oil use for refining

aeei(r,e,Roila,v,t) $ COILi(e) = 0.25 ;

*  Exogenous yield assumptions (in percent)

yexo(r,agra,v,t) = 1 ;

*  Exogenous assumption on improvement in trading margins (in percent)

tteff(r,i,rp,t) = - 1 ;

$IfTheni.cal %DynCalMethod%=="ENVISAGE"

    IF(IfDebug,
        EXECUTE_UNLOAD "%CheckCalFile%_%system.fn%_SSP%SSPSCEN%.gdx",
            popT, pop, rgdppcT, popg, gLabT, gLabz, gtlab, glMltShft, aeei,
                        aeeic, yexo, tteff ;
    ) ;

$EndIf.cal

*------------------------------------------------------------------------------*
*                       OECD-ENV default assumptions for new parameters                    *
*------------------------------------------------------------------------------*

* Exogenous improvement in Gross output-excluding emiAct emissions
* (rate of growth of TFP_xpx in pct)

g_xpx(r,a,v,t) = 0 ;

* Exogenous improvement TFP_xs (in percent)

g_xs(r,i,t) = 0 ;

* Exogenous improvement TFP_fp : not growth rate

g_fp(r,a,t) = 0 ;

* Exogenous physical capital stock efficiency improvement (in percent)

g_kt(r,a,v,t) = 0 ;

* Exogenous improvement in potential supply of natural resource (rate of growth of chinrf in percent)

g_natr(r,natra,t) = 0 ;

* Exogenous improvement in Natural Resources (rate of gtowth of lambdanrf in percent)

g_nrf(r,natra,v,t) = 0 ;

* Exogenous improvement in intermediate demands  (rate of gtowth of lambdaio in percent)

g_io(r,i,a,t)  = 0 ;

***************************************************************************************************************************
***************************************************************************************************************************
***HRR: new code (taken from 2-0-Dyn*.gms) to calibrate projections for:
* macroeconomic variables (real GDP, savf), total emissions and the electricity mix

**ST
PARAMETER WEO_gdp(r,t)           "WEO 2022- GDP forecasts"
          WEO_savf(r,t)          "WEO 2022- savf forecasts- nominal"
          WEO_unr(r,t)           "Unemployment rate from 2022 ENV-GRowth projections from JC"
          WEO_etr(r,t)
          proj_GHG_lulucf(r,t)   "GHG_lulucf emission projections"
          proj_GHG(r,t)          "GHG_lulucf emission projections"
          proj_CO2(r,t)          "GHG_lulucf emission projections"
          proj_lulucf(r,t)       "GHG_lulucf emission projections"
          BaUely_clp(r,t)        "Historical electricity generation - coal"
          BaUely_gsp(r,t)        "Historical electricity generation - gas"
          BaUely_olp(r,t)        "Historical electricity generation - oil"
          BaUely_nuc(r,t)        "Historical electricity generation - nuclear"
          BaUely_sol(r,t)        "Historical electricity generation - solar"
          BaUely_wnd(r,t)        "Historical electricity generation - wind"
          BaUely_hyd(r,t)        "Historical electricity generation - hydro"
          BaUely_xel(r,t)        "Historical electricity generation - rest ely"
          PowerMix(r,a,t)        "Parameter with all ElyMix projections"

          WEO2022capct(r,t)      "WEO 2022- savf forecasts- (nominal) share of gdp"
          WEO2022elymix25(r,a)   "GECO 2021- 2025 elymix forecasts in TwH"
          WEO2022elymix30(r,a)   "GECO 2021- 2030 elymix forecasts in TwH"
          CPAT2022elymix30(r,a)  "CPAT 2022- 2030 elymix forecasts in TwH"
          CPAT2022emi30(r,*)     "CPAT Dec 2022- 2030 GHG forecasts based on IEA energy balances"
          CPAT2022emi20(r,*)     "CPAT Dec 2022- 2020 GHG historical data "
          envgr2030unr(r,t)      "Unemployment rate from 2022 ENV-GRowth projections from JC"
          envgr2030etr(r,t)
          UNFCCC_GHG_lulucf(r,t) "Historical GHG_lulucf emissions"
          UNFCCC_GHG(r,t)        "Historical GHG_lulucf emissions"
          UNFCCC_CO2(r,t)        "Historical GHG_lulucf emissions"
          UNFCCC_lulucf(r,t)     "Historical GHG_lulucf emissions"
          IDN_sbsdy(*,t)         "Subsidy rates ptax and patax values based on inputs from country desk"
;

PowerMix(r,a,t) = 0 ;


****************************************************************************************************************
*HRR: calibratin savf and savg using Jan-2024 WEO data

$iftheni.weosavcal %ifWEOsavCal%=="ON"

parameter
WEO_cab(r,tt)            "CAB from WEO"
WEO_gbal(r,tt)           "Government budget balance from WEO"
WEO_cab_res(tt)          "Sum (residual) of region-specific CAB"
savf_weo(r,t)            "savf from new WEO (Jan 2024)"
;
EXECUTE_LOADDC "%iDataDir%\WEO_data.gdx", WEO_cab, WEO_gbal, WEO_cab_res ;

**there is a jump in 2029 residual, so I use data until 2028
    $$setGlobal YrEndWEO "2028"
    loop(t $ (t.val le %YrEndWEO%),
        savf_weo(r,t) = - WEO_cab(r,t) / 1000 ;
    );

**************************************************************************************************************
* Calibrating model using SAVG (Gov balance)
***Defining the savg targets
$setGlobal YrEndWEO "2029"
***Make savg after 2029 equal to last WEO value
loop(t $ (t.val gt %YrEndWEO%),
     WEO_gbal(r,t) =  WEO_gbal(r,t-1) ;
);

$IFi %DynCalMethod%=="ENVISAGE" savg.l(r,t) = WEO_gbal(r,t) / 1000;

**************************************************************************************************************
* Calibrating model using SAVF (CAB)
loop(t $ (t.val gt %YrEndWEO%),
     savf_weo(r,t) = savf_weo(r,"%YrEndWEO%") ;
);
$endif.weosavcal

************************************************************************************************************
* Uploading IEA energy values to convert model volumes to TWh and mtoe
Parameter
ely_GWh_agg(r)  "IEA: Total electricity output in GWh for 2020 for model aggregation"
nrg_TJ_agg(r)   "IEA: Total final consumption of heat in TJ for 2020 for model aggregation"
;

   EXECUTE_LOADDC "%iDataDir%\IEA_nrg_values.gdx", ely_GWh_agg, nrg_TJ_agg ;

******************************************************************************************************************************************
***HRR: include the group-specific calibration files
$IF EXIST "%GenericCal%\CalGroup_%GroupName%.gms" $include "%GenericCal%\CalGroup_%GroupName%.gms"

***HRR: include the project-specific calibration files
$IF EXIST "%iFilesDir%\Cal_%BaseName%.gms" $include "%iFilesDir%\Cal_%BaseName%.gms"

****************************************************************************************************************


