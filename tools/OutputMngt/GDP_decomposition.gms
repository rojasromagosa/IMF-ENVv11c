$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model - V.1 - Reporting procedure
   GAMS file    : "%ToolsDir%\OutputMngt\GDP_decomposition.gms"
   purpose      : GDP, Welfare and Demand decomposition of a policy wrt Bau
   Created by   : Jean Chateau
   Created date : 7 Juillet 2022
   called by    : stand alone procedure
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/GDP_decomposition.gms $
   last changed revision: $Rev: 338 $
   last changed date    : $Date:: 2023-06-22 #$
   last changed by      : $Author: chateau_j $
--------------------------------------------------------------------------------
$OffText

$OnEolCom
$OffListing

*   Select Project & Simulation sets

$SetGlobal BaseName "2022_OECD_OEW"
$SetGlobal SimRuns  "2023_01_02_Variant"
$SetGlobal DateOut  "2023_01_05"

* Include main folder paths

$include "..\..\a_FolderPath.gms"

* Selected policy & baseline scenario and corresponding folders where stored

$SetGlobal SimName  "CarbonTax_400"
$SetGlobal BauName  "Bau"
$SetGlobal SimDir 	"%ProjectDir%\%SimRuns%"
* $SetGlobal SimDir   "V:\CLIMATE_MODELLING\archives\CGE_PROJECTS_ARC\%BaseName%\%SimRuns%"
$SetGlobal BauDir 	"%ProjectDir%\%SimRuns%"

* temporary folder and resulting output folder

$IfThenI DEXIST C:\MODELS

	$$SetGlobal tmpDir "C:\MODELS\TmpDir\CGE\%BaseName%\%SimRuns%"
	$$SetGlobal oDir   "%ProjectDir%\%SimRuns%"
$Else

	$$SetGlobal tmpDir "V:\CLIMATE_MODELLING\sandbox\CGE\%BaseName%\%SimRuns%"
	$$SetGlobal oDir   "V:\CLIMATE_MODELLING\results\CGE\PROJECTS\%BaseName%\%SimRuns%"

$Endif

$IF NOT DEXIST "%tmpDir%"   $call "mkdir %tmpDir%"
$IF NOT DEXIST "%oDir%"     $call "mkdir %oDir%"

* Working Global variables

$setGlobal SimFile "%SimDir%\%SimName%"
$setGlobal BauFile "%BauDir%\%BauName%"

* name of the resulting output file

$SetGlobal oFile "%DateOut%_%SimName%_GdpAndWelfare_Analysis"

*	Load sets

SCALARS
    inScale     "Scale factor for input data"  / 1e-6 /
    outScale    "Scale factor for output data" / 1e6  /
    popScale    "Scale factor for population"  / 1e-6 /
;

Sets r, fd, i, t, k, aa ;
$Gdxin "%SimFile%.gdx"
$Load r, fd, i, t, k, aa
$Gdxin
alias(r,rp) ;

SETS
    var /

* Macro analysis

        C, I, G, IM, EX, GDP, check

* Welfare analysis

        "direct utility (per capita)"
        "subsistence bundle (per capita)"
        "utility price index"
        "Disposable income (per capita)"
        "Expenditure Function (per capita)"
        "Equivalent variation in income (per capita)"
        "Household consumption (per capita)"
        "Household savings (per capita)"

        "Household demand"
    /

    FinDem(var) / C, I, G, IM, EX /
    unit        / nominal, real /
    sim         / %BauName%, %SimName%, pct /
    pct(sim)    / pct /
    h(fd)       / hhd /

    AnaType     "Type of analysis" /
        "Macro analysis"
        "Welfare analysis"
        "Demand analysis"
    /
;

*	1.) Build GDP component

PARAMETER GDP_component(sim,var,unit,r,t) ;

PARAMETER
    xfd0(r,fd)           "Volume of aggregate final demand expenditures"
    pdt0(r,i)            "Producer price of goods sold on domestic markets"
    pwe0(r,i,rp)         "FOB price of exports"
    pwm0(r,i,rp)         "CIF price of imports"
    xtt0(r,i)            "Supply of m by region r"
    pfd0(r,fd)           "Final demand expenditure price index"
    xw0(r,i,rp)          "Volume of bilateral trade"
    lambdaw(r,i,rp,t)    "Iceberg parameter"
    yd0(r)               "Disposable household income"

    pdt(r,i,t)           "Producer price of goods sold on domestic markets"
    pwe(r,i,rp,t)        "FOB price of exports"
    pwm(r,i,rp,t)        "CIF price of imports"
    xtt(r,i,t)           "Supply of m by region r"
    xfd(r,fd,t)          "Volume of aggregate final demand expenditures"
    pfd(r,fd,t)          "Final demand expenditure price index"
    xw(r,i,rp,t)         "Volume of bilateral trade"
    yd(r,t)              "Disposable household income"

;

*	2.) Build Welfare component

PARAMETER Welf_component(sim,var,unit,r,t) ;

PARAMETER
    supy0(r,h)          "Per capita supernumerary income"
    muc0(r,k,h)         "Marginal budget shares"
    theta0(r,k,h)       "Consumption auxiliary variable"
    xc0(r,k,h)          "Household consumption of consumer good k"
    pc0(r,k,h)
    pop0(r)             "Population"
    savh0(r,h)

    supy(r,h,t)         "Per capita supernumerary income"
    muc(r,k,h,t)        "Marginal propensity to consume"
    mus(r,h,t)          "Marginal propensity to save"
    theta(r,k,h,t)      "Subsistence minima"
    xc(r,k,h,t)         "Household consumption of consumer good k"
    pc(r,k,h,t)         "Household price of consumption of consumer good k"
    pop(r,t)            "Population"
    savh(r,h,t)

;

*	3.) Build Demand component

PARAMETER
    Demand_component(sim,var,i,unit,r,t) "Demand analysis"
    xa(r,i,aa,t)
    xa0(r,i,aa,t)
    pa(r,i,aa,t)
    pa0(r,i,aa)
;

*   Load baseline --> GDP_component("%BauName%") & Welf_component("%BauName%")

$batinclude "%system.fp%\SubPrg\sub-GDP_decomposition.gms" "%BauName%" "%BauFile%"

*   Load Simulation --> GDP_component("%SIMName%") & Welf_component("%SIMName%")

$batinclude "%system.fp%\SubPrg\sub-GDP_decomposition.gms" "%SimName%" "%SIMFile%"

Parameter ExpVariable(sim,AnaType,var,unit,r,t) ;

LOOP(t $ (t.val ge 2022 and t.val le 2060),
    ExpVariable(sim,"Macro analysis",var,unit,r,t)
        = GDP_component(sim,var,unit,r,t) ;
    ExpVariable(sim,"Welfare analysis",var,unit,r,t)
        = Welf_component(sim,var,unit,r,t) ;
) ;
LOOP(t $ ((t.val lt 2022) or (t.val gt 2060)),
    Demand_component(sim,var,i,unit,r,t) = 0 ;
) ;

Execute_Unload "%tmpDir%\%oFile%.gdx", ExpVariable, Demand_component ;
EXECUTE 'gdxdump %tmpDir%\%oFile%.gdx format=CSV output=%oDir%\%oFile%.csv symb=ExpVariable'
EXECUTE 'gdxdump %tmpDir%\%oFile%.gdx format=CSV output=%oDir%\%oFile%_demand.csv symb=Demand_component'
