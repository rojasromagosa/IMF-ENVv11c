$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   GAMS file    : "GlobalVar_and_Flag_values.gms"
   purpose      : Create a set GlobalVariable_List that contains all the value
				  of global variables
   Created by   : Jean Chateau
   Created date : 17 Septembre 2021
   called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
   $URL:file:///C:/Dropbox/SVNDepot/ENV10/trunk/tools/debug/GlobalVar_and_Flag_values.gms $
   last changed revision:	$Rev: 518 $
   last changed date    :   $Date: 2024-02-29 16:28:02 +0100 (Thu, 29 Feb 2024) $
   last changed by      :   $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

SETS
	globcat "Group GLobal Variables by category" /

		"Model Features"
		"Remarkable Years"
		"Model specification"
		"Running Options"
		"Folder Locations"
		"Remarkable Files"
		"Simulation details"
		"Modules"
		"Policy"
		"Dynamic Calibration"
		"Auxilliary choices"

	/

	GlobalVariable_List(globcat,*,*)  "Global variable list and assigned values" /

*	Category: "Simulation details"

    "Simulation details".BaseName  ."%BaseName%"		"Name of the project"
    "Simulation details".SystemDate."%system.DATE%"		"Date of the simulation"
    "Simulation details".SimType   ."%SimType%" 		"Type of the simulation"
    "Simulation details".SimName   ."%SimName%" 		"Name of the simulation"
    "Simulation details"."GTAP version"."V%gtap_ver%Y%YearGTAP%" "Version of GTAP data base (e.g. gtap_ver)"

*	Category: "Remarkable Files"

    $$IF SET InputScenario "Remarkable Files".InputScenario."%InputScenario%" 	"Macro-economic scenario used for BAU construction"
    "Remarkable Files".iFile_GrowthScen."Name of ENV-Growth Scenario:" 			"%iFile_GrowthScen%"
    "Remarkable Files".BauName."%BauName%" 										"Underlying Dynamic Baseline simulation"
    $$IF SET BauFile    "Remarkable Files".BauFile   ."%BauFile%"				"gdx-file containing baseline simulation"
    $$IF SET NrgBauFile "Remarkable Files".NrgBauFile."%NrgBauFile%"			"gdx-file containing Energy base simulation"
    $$IF SET AgrBauFile "Remarkable Files".AgrBauFile."%AgrBauFile%"			"gdx-file containing Agriculture base simulation"
    $$IF     SET iGdxDir_ImportedScen "Remarkable Files".iFile_ImportedScen."Name of imported scenario:" "%iFile_ImportedScen%"
    $$IF NOT SET iGdxDir_ImportedScen "Remarkable Files".iFile_ImportedScen."Name of imported scenario:" "NONE"

*    "Remarkable Files".ENV_LinkagesV3_sim_file."%ENV_LinkagesV3_sim_file%" 		"Name of a reference simulation from ENV_Linkages V3"


*	Category: "Running" Options

    $$Ifi %SimType%=="variant"  "Running Options".ModelName."coreDyn"
    $$Ifi %SimType%=="Baseline" "Running Options".ModelName."coreBau"
    $$Ifi %SimType%=="CompStat" "Running Options".ModelName.""
    $$IF     SET BatchMode      "Running Options".BatchMode."%BatchMode%"
    $$IF NOT SET BatchMode      "Running Options".BatchMode."NA"

    "Running Options".dateout       ."%dateout%"
    "Running Options".MultiRun      ."%MultiRun%"
    "Running Options".IfScaleEq     ."%IfScaleEq%"	"Activating equation scaling"
    "Running Options".devtobau      ."%devtobau%"
*    "Running Options".fillHist      ."%fillHist%"
    "Running Options".systemDATE    ."%systemDATE%"

*	Category: Remarkable Years

    "Remarkable Years".YearStart       ."%YearStart%"       "Base year (default GTAP year)"
    "Remarkable Years".YearEnd         ."%YearEnd%"         "Last year of the project"
    "Remarkable Years".YearEndofSim    ."%YearEndofSim%"    "Date to stop simulations (lower than YearEnd)"
    "Remarkable Years".YearPolicyStart ."%YearPolicyStart%" "Date to start policy"
    "Remarkable Years".YearAntePolicy  ."%YearAntePolicy%"  "Year before the policy starts"
    "Remarkable Years".YearHist        ."%YearHist%"        "First year when we fill output with historical data"
    "Remarkable Years".YearRef         ."%YearRef%"			"Reference year for output"
    "Remarkable Years".YearBasePPP     ."%YearBasePPP%"     "Base year for PPP calculation in real terms"
    "Remarkable Years".YearBaseMER     ."%YearBaseMER%"     "Base year for MER calculation in real terms"
    "Remarkable Years".YearUSDCT       ."%YearUSDCT%"       "Year for valuing policy nominal value"
    "Remarkable Years".YearGTAP        ."%YearGTAP%"        "GTAP First year"
    "Remarkable Years".StartTimeLoop   ."%StartTimeLoop%"   "Starting year of the time loop"
    "Remarkable Years".EndTimeLoop     ."%EndTimeLoop%"     "Ending year of the time loop"

*	Category: Model specifications

    "Model specification" . utility     ."%utility%"		"Type of Utility function"
    "Model specification" . TASS        ."%TASS%"			"Type of Land Supply function"
    "Model specification" . WASS        ."%WASS%"			"Type of Water Supply function"
    "Model specification" . split_skill ."%split_skill%"	"Number of occupation/skill"
    "Model specification" . nb_vintage  ."%nb_vintage%"		"Number of vintages"
    "Model specification" . savfFlag    ."%savfFlag%"		"Current account formulation"
    "Model specification" . DataType    ."%DataType%" 		"Memo: DataType = {agg,Alt,Flt}"
	"Model specification" . LandBndNest ."%LandBndNest%"	"Land bundle nesting specification"
$IF %IfPower%=="ON"	"Model specification" . ElyBndNest  ."%ElyBndNest%"		"Power bundle nesting specification"

*	Category: folder structure

    "Folder Locations".RootDir        ."pathway:"     "%RootDir%"
    "Folder Locations".DataDir        ."pathway:"     "%DataDir%"
    "Folder Locations".SetsDir        ."pathway:"     "%SetsDir%"
    "Folder Locations".ModelDir       ."pathway:"     "%ModelDir%"
    "Folder Locations".CalDir         ."pathway:"     "%CalDir%"
    "Folder Locations".ToolsDir       ."pathway:"     "%ToolsDir%"
    "Folder Locations".ExtDir         ."pathway:"     "%ExtDir%"
    "Folder Locations".DirCheck       ."pathway:"     "%DirCheck%"
    "Folder Locations".ProjectDir     ."pathway:"     "%ProjectDir%"
    "Folder Locations".iFilesDir      ."pathway:"     "%iFilesDir%"
    "Folder Locations".iDataDir       ."pathway:"     "%iDataDir%"
    "Folder Locations".iGdxDir_GtapDB ."pathway:"     "%iGdxDir_GtapDB%"
    "Folder Locations".FolderGTAP     ."pathway:"     "%FolderGTAP%"
    "Folder Locations".DebugDir       ."pathway:"     "%DebugDir%"
    "Folder Locations".OutMngtDir     ."pathway:"     "%OutMngtDir%"
    "Folder Locations".gtpSatDir      ."pathway:"     "%gtpSatDir%"
    "Folder Locations".oDir           ."pathway:"     "%oDir%"
    "Folder Locations".wDir           ."pathway:"     "%wDir%"
    "Folder Locations".iGdxDir_GrowthScen."pathway:" "%iGdxDir_GrowthScen%"
    $$IF     SET iGdxDir_ImportedScen "Folder Locations".iGdxDir_ImportedScen."pathway:" "%iGdxDir_ImportedScen%"
    $$IF NOT SET iGdxDir_ImportedScen "Folder Locations".iGdxDir_ImportedScen."pathway:" "NONE"
    $$Ifi %Simtype%=="variant" "Folder Locations".BauDir."pathway:" "%BauDir%"

*	Category: Calibration informations

    $$IfTheni.calibration %SimType%=="Baseline"

		"Dynamic Calibration".DynCalMethod."%DynCalMethod%"	"Method of Calibration"
        "Dynamic Calibration".SourceProjection."%SourceProjection%"
        $$IFi %SourceProjection%=="ENV-Growth"   "Dynamic Calibration".iFile_GrowthScen  ."%iFile_GrowthScen%"
        $$IFi %SourceProjection%=="ENV-Linkages" "Dynamic Calibration".iFile_ImportedScen."%iFile_ImportedScen%"

        "Dynamic Calibration".cal_preference."%cal_preference%"
        "Dynamic Calibration".cal_TFP."%cal_TFP%"
        "Dynamic Calibration".cal_NRG."%cal_NRG%" "Energy Calibration"
        "Dynamic Calibration".cal_AGR."%cal_AGR%" "Agriculture Calibration"
        "Dynamic Calibration".cal_IOs."%cal_IOs%"
        "Dynamic Calibration".cal_TRD."%cal_TRD%"
        "Dynamic Calibration".cal_GHG."%cal_GHG%"
        "Dynamic Calibration".cal_OAP."%cal_OAP%"

		$$IFi %DynCalMethod%=="ENVISAGE" "Dynamic Calibration".SSPSCEN."%SSPSCEN%" "Chosen SSP0 scenario for GDP (ENV-Growth FOR SSP0)"
		$$IFi %DynCalMethod%=="ENVISAGE" "Dynamic Calibration".POPSCEN."%POPSCEN%" "Chosen SSP0 scenario for POP (ENV-Growth FOR SSP0)"

        $$IFi %cal_AGR%=="ON" "Dynamic Calibration".ImpactScen."%ImpactScen%"
        $$IFi %cal_AGR%=="ON" "Dynamic Calibration".bau_impact."%bau_impact%"

        $$IFi %cal_NRG%=="ON" "Dynamic Calibration".IEAWEOVer   ."%IEAWEOVer%"
        $$IFi %cal_NRG%=="ON" "Dynamic Calibration".ActWeoSc    ."%ActWeoSc%"
        $$IFi %cal_NRG%=="ON" "Remarkable Years"   .YearTransWeo."%YearTransWeo%"
        $$IFi %cal_NRG%=="ON" "Remarkable Years"   .YearEndWEO  ."%YearEndWEO%"

        "Model specification".UseIMPACT."%UseIMPACT%"

        $$IF SET ifWater "Model specification".ifWater."%ifWater%"
        $$IF SET ifPower "Model specification".ifPower."%ifPower%"

		"Dynamic Calibration".BaseYearCW."%BaseYearCW%"

		$$IF EXIST "%iFilesDir%\DYNAMIC_CALIBRATION_Specific_Scenario.gms" "Dynamic Calibration"."Use a specific scenario" ."YES"

    $$EndIf.calibration

*	Category: Policy settings

    $$IfTheni.PolicyOption SET PolicyFile

        "Policy".PolicyFile."%PolicyFile%"	"Name of the policy file loaded"
        "Policy".VarFlag   ."%VarFlag%"     "Policy number (e.g. VarFlag)"

        "Folder Locations".PolicyPrgDir."pathway:" "%PolicyPrgDir%"

    $$Else.PolicyOption

        "Policy".PolicyFile."no file"	"Name of the policy file loaded"

    $$Endif.PolicyOption

    $$IfTheni.BCApolicy %BCA_policy%=="ON"
        "Policy".BCA_type         ."%BCA_type%"
        "Policy".BCA_CarbonContent."%BCA_CarbonContent%"
        "Policy".BCA_EmiCoverage  ."%BCA_EmiCoverage%"
        "Policy".BCA_Good         ."%BCA_Good%"
        "Policy".BCA_sources      ."%BCA_sources%"
        "Policy".BCA_revenue      ."%BCA_revenue%"
    $$EndIf.BCApolicy

*	Category: Auxilliary informations

    $$IfTheni.aux %IfAuxi%=="ON"

        "Auxilliary choices".aux_expenses_composition."%aux_expenses_composition%"
        "Auxilliary choices".aux_growth_accounting."%aux_growth_accounting%"
        "Auxilliary choices".aux_trade_output."%aux_trade_output%"
        "Auxilliary choices".aux_Energy_Output."%aux_Energy_Output%"
        "Auxilliary choices".aux_GroupSmallCategory."%aux_GroupSmallCategory%"
        "Auxilliary choices".aux_outType."%aux_outType%"
        "Auxilliary choices".aux_PriceIndex."%aux_PriceIndex%"
        "Auxilliary choices".AuxiFile."%AuxiFile%"
        "Auxilliary choices".IfAuxiByCty."%IfAuxiByCty%"

    $$EndIf.aux
	/
;

* [TBU]
$onText
IF(smax(r,ifLandSupply(r)) eq 0,
    GlobalVariable_List("Model specification","ifLandSupply","Land Supply is Fixed (calibration mode)") = YES;
ELSE
    GlobalVariable_List("Model specification","ifLandSupply","Land Supply is Endogenous") = YES;
);
$offText

*------------------------------------------------------------------------------*
*                                                                              *
*                   Filling Flags Information                                  *
*                                                                              *
*------------------------------------------------------------------------------*

Parameter IfFlags(*,*);

IfFlags("Scale factor for input data","inscale")           = inscale	;
IfFlags("Scale factor for output data","outscale")         = outscale	;
IfFlags("Scale factor for population","popscale")          = popscale	;
IfFlags("Scale factor for labor volumes","lscale")         = lscale		;
IfFlags("Scale factor for energy","escale")                = escale		;
IfFlags("Scale factor for water","watscale")               = watscale	;
IfFlags("Scale factor for emissions","cscale")             = cscale		;
IfFlags("Scale factor for Power generation","Powscale")    = Powscale	;
IfFlags("Scale factor for Air Pollutant","apscale")        = apscale   	;
IfFlags("Maximum scale factor for Equations","MaxEqScale") = MaxEqScale	;

*	CSV output options

IfFlags("Flag for SAM CSV file","ifSAM")    = ifSAM;
IfFlags("Flag to append to existing SAM CSV file","ifSAMAppend") = ifSAMAppend;
IfFlags("Aggregate trade in SAM","ifAggTrade") = ifAggTrade;

*	Running/Solving options

IfFlags("Dynamic simulation","ifDyn")                    = ifDyn;
IfFlags("Calibration mode","ifCal")                      = ifCal;
IfFlags("Solver used: 1 for MCP - 2 for CNS","ifMCP")    = ifMCP;
IfFlags("Saving simulation of a given year","IfSaveYr")  = IfSaveYr;
IfFlags("Loading simulation of a given year","IfLoadYr") = IfLoadYr;
IfFlags("Initialization Flag","IfInitVar")               = IfInitVar;
IfFlags("rerun with alternative Solver","IfReRun")       = IfReRun;
IfFlags("Prices lower bound","LowerBound")               = LowerBound;
IfFlags("rerun with alternative Solver","IfReRun")       = IfReRun;
IfFlags("Initializate new vintage (as pct of old) in first year","InitVintage")
    = InitVintage;
IfFlags("Dynamic Scaling","IfDynScaling")                = IfDynScaling;

*	Options on model specification

IfFlags("Erase sectors lower than IfCleanXP millions","IfCleanXP") = IfCleanXP ;
IfFlags("Use price equations (= 0) or macro (=1)","IfSub")         = IfSub     ;
IfFlags("recalibrate functional form","IfRecal")                   = IfRecal   ;
IfFlags("Convert emissions to CEq","IfCEQ")                        = IfCEQ     ;
IfFlags("Specify agent-based Armington","IfArmFlag")               = IfArmFlag ;
IfFlags("Using energy volumes","IfNrgVol")                         = IfNrgVol  ;
IfFlags("Using CET for land allocation","IfLandCET")               = IfLandCET ;
IfFlags("Activating power module","IfPower")                       = IfPower   ;
IfFlags("Activating Water module","IFWATER")                       = IFWATER   ;
IfFlags("Consider Power in TWh","IfPowerVol")                      = IfPowerVol;
IfFlags("Normalize --> sum of CES-coefficient = 1","IfCoeffCes")   = IfCoeffCes;
IfFlags("Using CES for Power allocation","IfElyCES")               = IfElyCES  ;
IfFlags("[TBD]","skLabgrwgt")                                      = skLabgrwgt;
IfFlags("Capital vintages","ifVint")                               = ifVint    ;
IfFlags("Endogenous MAC curve for process emissions","ifEndoMAC")  = ifEndoMAC ;
IfFlags("Group together F-gases","IfGroupFGas")  				   = IfGroupFGas ;
IfFlags("Choice of a set of parmater values","IfENVLPrm")  		   = IfENVLPrm ;
IfFlags("Exogenous/Endogenous elasticity of natres supply","IfEndoEtanrf") = IfEndoEtanrf ;

IF( sum((r,l) $ migrFlag(r,l), 1),
    IfFlags("Migration","migrFlag") = 1 ;
ELSE
    IfFlags("Migration","migrFlag") = 0 ;
) ;

$IfTheni.PolicyOption SET PolicyFile
    IfFlags("Nb of parts to cut Policy","IfCutInpart") = IfCutInpart ;
    IfFlags("Number used for the policy","VarFlag")    = VarFlag ;
$Endif.PolicyOption

$IfTheni.BCApolicy %BCA_policy%=="ON"

    IfFlags("Set to 0 (1) to rebate carbon revenues to domestic (exporter)","IfBCA_revenue")
		= IfBCA_revenue;
    IfFlags("Set to 0 (1) for direct BCA (to include electricity)","IfBCA_EmiCoverage")
		= IfBCA_EmiCoverage;
    IfFlags("Set to 1 for tarrifs, 2 for full bca, 3 for export" ,"IfBCA_type") = IfBCA_type;
    IfFlags("Set to 1 (0) for tariffs on domestic (exporter) carbon content","IfBCA_CarbonContent")
		= IfBCA_CarbonContent;
    IfFlags("Set to 1 for BCA calculated on CT differential","IfBCA_taxdiff")
		= IfBCA_taxdiff;
    IfFlags("If 1 to Do not consider negative carbon-tariff/Export Subsidies","IfBCA_nonneg")
		= IfBCA_nonneg;

$EndIf.BCApolicy

EXECUTE_UNLOAD "%cfile%_GlobalVarFlag.gdx", GlobalVariable_List, etat_statut, IfFlags, xpFlagT, IfNrgNest;
$IFi %DynCalMethod%=="OECD-ENV" $Ifi %SimType%=="Baseline" EXECUTE_UNLOAD "%cBaseFile%_Calibration_Details.gdx", IfCalMacro, IfCalSect, SectoralTarget;

option GlobalVariable_List:0:0:2 display "Settings of global variables at end of program", GlobalVariable_List;

$goto notActive

* file InfoTxt / '%cFile%_Resume.txt' /;
* Write global variables to text file so it can be included in e.g. reporting
* or variant simulations (we can expand later what needs to be in here)
$onecho > "%Folderoutputs%\glob_var_%1.gms"
$SetGlobal YearStart                   %YearStart%
$SetGlobal YearEnd                     %YearEnd%
$SetGlobal YearEndofSim                %YearEndofSim%
$SetGlobal YearBaseMER                 %YearBaseMER%
$SetGlobal YearBasePPP                 %YearBasePPP%
$SetGlobal YearGTAP                    %YearGTAP%
$SetGlobal ActWeoSc                    %ActWeoSc%
$IF %dynamic_calibration%=="ON" $SetGlobal weoUSD  %weoUSD%
$SetGlobal module_auxilliary_variables %module_auxilliary_variables%
$SetGlobal cal_GHG                    %cal_GHG%
$offecho
$label  notActive

