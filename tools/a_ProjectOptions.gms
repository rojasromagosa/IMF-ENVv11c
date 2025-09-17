*------------------------------------------------------------------------------*
*  This is the option file "a_ProjectOptions.gms" for "GenericProject"         *
*------------------------------------------------------------------------------*

$IF NOT SET BaseName $SetGlobal BaseName "GenericProject"
*   Details about the GTAP Data used

* GTAP_DBType = {GTAP,GTAP-Power,GTAP-E,GDyn, GTAP-APT, GTAP-MRIO}

$SetGlobal GTAP_DBType "GTAP-Power"

* GTAP_ver = {10a,92}

$SetGlobal GTAP_ver    "10a"

* YearGTAP = {04,07,11,14}

$SetGlobal YearGTAP    "14"

$SetGlobal GTAPBASE    "GSD"

*------------------------------------------------------------------------------*
* The following instructions are manually added for project "2022_OECD_Base"   *
*------------------------------------------------------------------------------*

*$IF NOT SET ifFilter $SetGlobal ifFilter "OFF"
*$IF NOT SET ifAlt    $SetGlobal ifAlt    "OFF"


*   Aggregation choices [Default]

$SetGlobal Prefix               ""
$SetGlobal BundleChoiceInModel "ON"
$SetGlobal IfAddTotalSets      "OFF"
$SetGlobal ifAirPol            "OFF"
$SetGlobal BuildScenarioInAgg      "OFF"
$SetGlobal YearHist            "1970"

*   Define Name and Location of an external scenario [optional]

*$SetGlobal iFile_ImportedScen "[]"

*   Or Load a macroeconomic scenario built with "AggGTAP.gms"

$SetGlobal iFile_GrowthScen "2021_08_18_IMF_ENV-Growth_2014_PPP"

*   Some Model Choices

$SetGlobal UseIMPACT "OFF"

*   If the following folders are not declared some instructions are not read

*$SetGlobal DebugDir   "%ToolsDir%\debug"
*$SetGlobal OutMngtDir "%ToolsDir%\OutputMngt"

