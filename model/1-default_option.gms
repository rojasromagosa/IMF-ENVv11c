$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file   : "%ModelDir%\1-default_option.gms"
	purpose     : Select default options (Global variables and If-type scalar)
	Created by  : Jean Chateau from original ENVISAGE codes
	Created date: Fall 2021
	called by   : "%ModelDir%\%SimType%.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/1-default_option.gms $
	last changed revision:    $Rev: 518 $
	last changed date    :    $Date:: 2024-02-29 #$
	last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------

 Define a first set of global options

    wdir        Active directory (normally not changed)
    SSPMOD      Either OECD or IIASA
    SSPSCEN     SSP1, SSP2, SSP3, SSP4, or SSP5
    POPSCEN     SSP1, SSP2, SSP3, SSP4, SSP5, UNMED2010, UNMED2012, UNMED2015, GIDD
    OVERLAYPOP  0=keep GTAP base year pop level, 1=use SSP pop level for 2011
    TASS        Aggregate land supply function: KELAS, LOGIST, HYPERB, INFTY
    WASS        Aggregate water supply function: KELAS, LOGIST, HYPERB, INFTY
    utility     LES, ELES, AIDADS, CDE
    NRITER      Best to keep 0 for the moment
    savfFlag    Set to capFix for fixed foreign savings, set to capFlex for endogenous savf

	OECD-ENV : remove $SetGlobal NRITER --> keep only scalar NRITER

--------------------------------------------------------------------------------
$OffText


*------------------------------------------------------------------------------*
*                          SOLVER CHOICES                                      *
*------------------------------------------------------------------------------*
* [EditJean]: add-ons
*OPTION CNS    = CONOPT;
OPTION CNS    = CONOPT4;
*OPTION CNS    = IPOPT;
*OPTION CNS    = PATH;

OPTION MCP    = PATH;
*OPTION MCP    = MILES;
*OPTION MCP    = NLPEC;
*OPTION MCP    = CONVERT

OPTION DNLP   = CONOPT4;
*OPTION DNLP   = CONOPT;
*OPTION DNLP   = MINOS;
*OPTION DNLP   = PATHNLP;
*OPTION DNLP   = PATHNLP;

OPTION RMINLP = CONOPT;
*OPTION NLP    = CONOPT;

*------------------------------------------------------------------------------*
*                           Global Variables                                   *
*------------------------------------------------------------------------------*

$SetGlobal systemDATE "%system.DATE%"

$IF NOT SET BauName $SetGlobal BauName "Baseline"
$If NOT SET SimName $SetGlobal SimName "%SimType%"

*	Additional Folder Locations

$If Not Set wDir    $SetGlobal wDir     "%system.fp%"

* Default folder where full simulation and other output are stored

$If Not Set oDir    $SetGlobal oDir     "output"

*	Options on Data

$If Not Set OVERLAYPOP  $SetGlobal OVERLAYPOP   "0"

* %DataType% = {agg,Alt,Flt} : use raw data, or filtered or modify by AlterTax
* [TBU]: for Now "Flt" only contains: dat.gdx, emiss.gdx, nco2.gdx, vole.gdx

$If Not Set DataType    $SetGlobal  DataType    "agg"

*	Options on model specification (ENVISAGE default)

$If Not Set TASS        $SetGlobal TASS         "LOGIST"
$If Not Set WASS        $SetGlobal WASS         "LOGIST"
$If Not Set utility     $SetGlobal utility      "CDE"

*	ENV-Linkages

*$SetGlobal TASS    "KELAS"
*$SetGlobal utility "ELES"

*   Set to capFix for fixed foreign savings, set to capFlex for endogenous savf
* savfFlag = {capFix,capFLex,capShrFix,capFlexGTAP,capFlexUSAGE}
* only if also ifSavfEQ(r) ne 0

$If Not Set savfFlag    $SetGlobal savfFlag     "capFix"
$If Not Set split_skill $SetGlobal split_skill  "1"
$If Not Set ifAirPol    $SetGlobal ifAirPol     "OFF"
$If Not Set nb_vintage  $SetGlobal nb_vintage   "2"
$If Not Set IfPower     $SetGlobal IfPower      "OFF"

* Default nesting for Power bundles

$SetGlobal ElyBndNest "4Bundles"

* Default nesting for Land bundles

$SetGlobal LandBndNest "OneBundle"

*	Select a dynamic calibration procedure : DynCalMethod = {OECD-ENV,ENVISAGE}

$SetGlobal DynCalMethod "OECD-ENV"

* Use parameters values for [OECD-ENV] model

$If Not Set UseIMFPrm $SetGlobal UseIMFPrm "ON"

* Options for %DynCalMethod%=="ENVISAGE"
* put SSP0 to do ENVISAGE baseline procedure but with ENV-Growth Projections

$If Not Set SSPMOD  $SetGlobal SSPMOD  "OECD"
$If Not Set SSPSCEN $SetGlobal SSPSCEN "SSP2"
$If Not Set POPSCEN $SetGlobal POPSCEN "SSP2"

*   Remarkable years

$If Not Set YearStart       $SetGlobal YearStart       "20%YearGTAP%"
$If Not Set YearEnd         $SetGlobal YearEnd         "2100"
$If Not Set YearEndLTM      $SetGlobal YearEndLTM      "2060"
$If Not Set YearEndofSim    $SetGlobal YearEndofSim    "%YearEndLTM%"
$If Not Set YearPolicyStart $SetGlobal YearPolicyStart "2023"
$If Not Set YearAntePolicy  $SetGlobal YearAntePolicy  "2022"
*$If Not Set YearHist        $SetGlobal YearHist        "1990"
$SetGlobal YearHist         "1950"
$If Not Set YearRef         $SetGlobal YearRef         "%YearStart%"
$IFi %SimType%=="CompStat"  $SetGlobal YearRef         "base"

* Reference yr to calculated constant monetary units in PPP

$If Not Set YearBasePPP     $SetGlobal YearBasePPP "%YearStart%"

* Reference yr to calculated constant monetary units in MER

$If Not Set YearBaseMER     $SetGlobal YearBaseMER "%YearStart%"

* Carbon Price is expressed on USD of year %YearUSDCT%

$If Not Set YearUSDCT       $SetGlobal YearUSDCT "%YearAntePolicy%"

*   Running/Solving options

* Activate Equation scaling (only some equations)

$If Not Set IfScaleEq $SetGlobal IfScaleEq "OFF"

$If Not Set MultiRun  $SetGlobal MultiRun  "OFF"

*   Output Options

* By default put "out_Macroeconomic" in a dedicated folder %oDir%\OutMacro
*   --> if %oGdxDir_Macro%== "OFF" put "out_Macroeconomic" in "%oDir%"

$SetGlobal oGdxDir_Macro "ON"

* IfAuxi: Set to "ON" to extract some auxilliary outputs - by default inactive

$If Not Set IfAuxi $SetGlobal IfAuxi "OFF"

* By default we do not save auxilliary file country by country

$If Not Set IfAuxiByCty $SetGlobal IfAuxiByCty "OFF"

* Calculate deviation wrt BAU --> OutMacro & auxilliary
*   --> activated by default in variant Mode "ON"

$SetGlobal devtobau "OFF"
$Ifi %SimType%=="variant" $SetGlobal devtobau "ON"

* Read (or not) instructions for Jean Foure's slicing module

$If Not Set IfSlicing $SetGlobal IfSlicing "OFF"

* Set "ON" to refine .lo and .up bounds on prices (option)

$If Not Set IfDotLoUp $SetGlobal IfDotLoUp "OFF"

*------------------------------------------------------------------------------*
*                           Flag parameters (ie scalar)                        *
*------------------------------------------------------------------------------*

SCALARS

	MaxStrLen

*	Scaling input data

    inScale     "Scale factor for input data"                / 1e-6  /
    outScale    "Scale factor for output data"               / 1e6   /
    popScale    "Scale factor for population"                / 1e-6  /
    lScale      "Scale factor for labor volumes"             / 1e-9  /
    eScale      "Scale factor for energy"                    / 1e-3  /
    watScale    "Scale factor for water"                     / 1e-12 /
    cScale      "Scale factor for emissions"                 / 1e-3  /
    Powscale    "Scale factor for Power generation (Twh)"    / 1e-4  /
    MaxEqScale  "Maximum scale factor for Equations"         / 1e3   /
    apscale     "Scale factor for Air Pollutant emissions"   / 1e-6  /

*	CSV output options

    ifSAM       "Flag for SAM CSV file"                     / 1 /
    ifSAMAppend "Flag to append to existing SAM CSV file"   / 0 /
    ifAggTrade  "Set to 1 to aggregate trade in SAM"        / 0 /
    ifCsvMAC    "Flag for MAC CSV file"                     / 0 /

*	Running/Solving options

    ifGbl    "Set to 1 to run the model in global mode (default)" 		  / 1 /
    ifMCP    "Set to 1 (2) for MCP (CNS)"                        		  / 1 /
    IfSaveYr "Set to 1 (2) to save simulated year in iDataDir (SimDir)"   / 0 /
    IfLoadYr "Set to 1 (2) to load simulated year from iDataDir (SimDir)" / 0 /
    IfReRun  "Set to 1 to rerun with alternative Solver debbuging"        / 0 /
    LowerBound  "Price lower bound" / 0.001 /
    InitVintage "Initialize new vintage (as pct of old) in first year" / 0.01 /

*	Additional OECD-ENV Running/Solving options

	IfSlicing	"Set 1 to activate slicing procedure (if corresponding global variable in ON)" / 0 /

* Values for "IfDynScaling" (Flag for dynamic scaling)

$OnText
	IfDynScaling = 0: No dynamic scaling
	[TBU] IfDynScaling = 1: Calibration mode: load time-dependent scales from another baseline
	IfDynScaling = 2: Dynamic scaling for calibration or variant mode
	IfDynScaling = 3: Variant Mode: load time-dependent scales from a baseline
$OffText

    IfDynScaling "Dynamic scaling (default = 0 --> no dynamic scaling)" / 0 /

* Values for "IfInitVar" (OECD-ENV: Flag to control equilibrium initialisation)

$OnText
	 IfInitVar = 0 --> use a given (baseline) trajectory to initialize
					   default for dynamic variants for t > %YearPolicyStart%
	 IfInitVar = 1 --> use previous values to initialize + apply exo growth rate
					   default for for dynamic baseline calibration
					   default for for dynamic variants up to %YearPolicyStart%
	 IfInitVar = 2 --> use previous values to initialize (also for "slicing")
$offtext

    IfInitVar   "Initialization Flag: Set to 0 to initialize on baseline" / 1 /

*	OECD-ENV Debbuging options

    IfDebug  "Set to positive number to activate debugging options"	    / 0 /
    IfUnLoadBeforeSim  "Set to 1 to save full gdx before a simulation"  / 0 /

*	Options on model specification

    ifCEQ       "Convert emissions to CEq"           / 0 /
    IfArmFlag   "Set to 1 for agent-based Armington" / 1 /
    IfNrgVol    "Set to 1 to use energy volumes"     / 0 /
    IfLandCet   "Set to 1(0) to use CET for land allocation (for Land conservation)" / 0 /
    IfSub       "Set to 1(0) to use price macro (equations) " / 1 /
    IfPower     "Set to 1 for power module"          / 0 / !! dans ENV-L IFPOWER = IfPowerNest
    IfWater     "Set to 1 for water module"          / 0 /
    IfPowerVol  "Set to 1 to consider Power in TWh"  / 0 /
    skLabgrwgt  "Set to between 0 and 1"             / 0 /

*	Additional OECD-ENV Options on model specification

    IfCoeffCes  "Set to 1 for sum of CES-coefficient equals to one" / 0 /
    IfElyCES    "Set to 1 (0) to use CES (to keep volume) for Power Allocation" / 0 /
    IfCleanXP   "Set to any positive number x to erase sectors lower than x millions"  / 0 /
    IfRecal     "Set to 1 to recal functional form"  / 1 /
    IfEndoMAC   "Set to 1 to endogenous MAC curves (in top Nest of Gross output) - Set 0 for fixed coefficients" / 0 /
    IfGroupFGas "Set to 1 keep FGAS together" / 0 /
	IfENVLPrm	"Set to 1 to use ENV-Linkages parameter values, set 0 to use ENVISAGE, set 2 to use IMF-ENV" / 1 /
	IfEndoEtanrf / 0 /
    IfNco2      "Flag to determine if we have non-CO2 gases" !! value of the Flag determined by existence of data
	IfMergeTaxAndSubfp	"Set to 1 to not isolate primary factor subsidies" / 0 /

*	OECD-ENV Policy Flags

    VarFlag       "Flag corresponding to a variant number" / 0 /
    IfProjectFlag "Some project specific Flag" 			   / 0 /

* For now only For Carbon Tax & Caps policy

    IfCutInpart "Cut Policy in IfCutInpart nb of parts"    / 0 /
    IfEmiaEq    "Set to 1 to activate equation emiaeq"     / 0 /

;

*------------------------------------------------------------------------------*
*				OECD-ENV: Specify some folder locations					   	   *
*------------------------------------------------------------------------------*

* Folder with generic codes for policy variant

$SetGlobal PolicyPrgDir "%ModelDir%\PolicyPrg"

* Default folder where are stored solution-year :
* ie files mcp_%ModName%_tsim.l & cns_%ModName%_year_tsim.l

$If Not Set SimDir $SetGlobal SimDir "%iDataDir%"

* Default check directory (oDirCheck is defined in "%RootDir%\a_FolderPath.gms")

$SetGlobal DirCheck "%oDirCheck%\%BaseName%\%oDir%"

*	Macro for years

* For t = simu --> Comparative Static Case

$IFI "%SimType%"=="compStat"     $macro m_PUTYEAR t.tl

* For t = year --> Dynamic simulation

$IFI NOT "%SimType%"=="compStat" $macro m_PUTYEAR years(t):4:0

