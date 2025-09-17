$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Project specific Options
   name        : "%iFilesDir%\ModelOption.gms"
   purpose     :  Overrides default options for the project: "2023_G20"
   created date: 2023-01-11
   created by  : Jean Chateau
   called by   : core files "%ModelDir%\variant" or "%ModelDir%\baseline"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/2023_G20/InputFiles/ModelOption.gms $
   last changed revision: $Rev: 501 $
   last changed date    : $Date:: 2024-02-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	This file overrides default options from %ModelDir%\1-default_option.gms
    Inactive or active instructions below are alternative values to default
	Memo this is read before "%CalDir%\1-0-dynamic_calibration_declaration.gms"
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*                   Changes in global variables                                *
*------------------------------------------------------------------------------*

*   Options on Data

$Ifi NOT %SimType%=="CompStat" $SetGlobal OVERLAYPOP "1"
$SetGlobal DataType "Flt"

*   Options on model specification

$SetGlobal TASS             "KELAS"
*$SetGlobal utility          "ELES"
$SetGlobal utility          "CDE"
$SetGlobal IfPower          "ON"
***HRR: activated these lines to use simple ENVISAGE calibration
$SetGlobal DynCalMethod     "ENVISAGE"
* Option "SSP0" indicates that we Load ENVISAGE-Growth Scenario pop & GDP
$SetGlobal SSPSCEN          "SSP2"
$SetGlobal POPSCEN          "SSP2"
$setGlobal ifRD_Module      "OFF"
$IFi %DynCalMethod%=="ENVISAGE" Powscale = 1e-4 ;


$SetGlobal ifElyMixCal        "ON"
$SetGlobal ifEmiTotCal        "ON"
$SetGlobal ifWEOsavCal        "ON"

*   Remarkable years

*$SetGlobal YearStart        "2016"
$SetGlobal YearEndofSim     "2040"
*$SetGlobal YearPolicyStart  "2024"
*$SetGlobal YearAntePolicy   "2021"
*$SetGlobal YearHist         "1990"
$SetGlobal YearHist         "1950"
$SetGlobal YearUSDCT        "2018"
*$SetGlobal YearRef          "2017"
*$SetGlobal YearBasePPP      "2017"
*$SetGlobal YearBaseMER      "2017"

*   Running/Solving options

$SetGlobal IfScaleEq        "ON"

*   Output Options

$SetGlobal IfAuxi        "OFF"

*   Project specific calibration Options

* Override default calibration choices

$IfTheni.Calib %SimType%=="baseline"

	$$SetGlobal cal_preference "OFF"
	$$SetGlobal cal_TFP        "OFF"
	$$SetGlobal cal_AGR        "OFF"
	$$SetGlobal cal_IOs        "OFF"
	$$SetGlobal cal_GHG        "OFF"
	$$SetGlobal cal_NRG        "OFF"

$Endif.Calib

* This Global variable "BaseYearCW" also activate NDC calculation if not "OFF"

$SetGlobal BaseYearCW "OFF"

*   Project specific Global variable

$IF NOT SET Acting $SetGlobal Acting "3groups"

*------------------------------------------------------------------------------*
*                       Changes in Scalar Flags                                *
*------------------------------------------------------------------------------*

* CSV output options & Running/Solving options

ifSAM       = 0 ;
ifMCP       = 1 ;
*IfSaveYr    = 1 ;
*IfLoadYr    = 1 ;
*IfDebug     = 1 ;

* Options on model specification

IfArmFlag   = 0 ;
IfNrgVol    = 0 ;
IfLandCet   = 1 ;
IfPower     = 1 ;
IfPowerVol  = 1 ;
$iftheni NOT "%simType%" == "CompStat"
   IfCoeffCes  = 1 ;
$endif
IfElyCES $ (ifDyn and ifCal)       = 0 ;
IfElyCES $ (ifDyn and (not ifCal)) = 1 ; !!check again
$iftheni NOT "%simType%" == "CompStat"
***new Oman
*   ifEndoMAC   = 1 ;
   ifEndoMAC   = 0 ;
***endnew Oman   
$endif
*IfGroupFGas = 1;
IfENVLPrm = 2 ; !! Set 2 to use IMF-ENV param. or Set 0 for ENVISAGE param.

***HRR: commented out these changes
$ontext
$IFi %DynCalMethod%=="ENVISAGE" IfENVLPrm = 0 ;

*   Change SimName

$IFi %DynCalMethod%=="ENVISAGE" $SetGlobal SimName "ENVISAGE_%SimName%"
$IFi %DynCalMethod%=="ENVISAGE" $SetGlobal BauName "ENVISAGE_%BauName%"
$offtext
***endHRR

*	Change folder with checking procedures [default is %oDirCheck%\%BaseName%\%oDir%]

*$SetGlobal DirCheck "%oDir%\Check"

*	Change some default Locations

*$SetGlobal iFile_SpecificSets "[]"
*$SetGlobal iFile_SpecificPrm  "[]"

*------------------------------------------------------------------------------*
*                       Use a resume output file                               *
*------------------------------------------------------------------------------*

***HRR: took this away to reduce output files
*$SetGlobal ResOutFile "%FolderPROJECTS%\CommonPolicyFiles\ResumeOutput.gms"

*------------------------------------------------------------------------------*
*       Define a simulation-file to initialize the trajectory instead of Bau   *
*------------------------------------------------------------------------------*

*$SetGlobal InitFile "%oDir%\%SimName%"


