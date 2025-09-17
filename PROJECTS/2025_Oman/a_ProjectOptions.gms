*------------------------------------------------------------------------------*
* Option file "a_ProjectOptions.gms" for the project "2023_G20"              *
*------------------------------------------------------------------------------*

$IF NOT SET BaseName $SetGlobal BaseName "2025_Oman"

$SetGlobal GroupName "2024_MCD"

*   Details about the GTAP Data used

* GTAP_DBType = {GTAP,GTAP-Power,GTAP-E,GDyn, GTAP-APT, GTAP-MRIO}

$SetGlobal GTAP_DBType "GTAP-Power"

* GTAP_ver = {10a,92,10.1}

$SetGlobal GTAP_ver    "11c"

* YearGTAP = {04,07,11,14}

$SetGlobal YearGTAP    "17"

$SetGlobal GTAPBASE    "GSDF"

*------------------------------------------------------------------------------*
* The following instructions are manually added for project "2023_G20"         *
*------------------------------------------------------------------------------*

*   Aggregation choices [Default]

$SetGlobal Prefix              ""
$SetGlobal BundleChoiceInModel "ON"
$SetGlobal IfAddTotalSets      "ON"
$SetGlobal ifAirPol            "OFF"
***HRR: switch off and change to SSP 
$SetGlobal BuildScenarioInAgg  "OFF"
*$SetGlobal YearHist           "1990"
$SetGlobal YearHist            "1950"
$SetGlobal IEAWEOVer           "2018"

*   Define Name and Location of external simulations/scenarios [optional]

* OPTIONS: Name and Location of an imported scenario/simulation (built with a CGE)

*$SetGlobal iGdxDir_ImportedScen "%FolderPROJECTS%\2022_CPE\InputData\ExternalScenarios"
*$SetGlobal iFile_ImportedScen   "IMF_input_rebalance_CPS_2021Aug"

* Name and Location of a macro scenario trends (built during aggregation procedure)

***HRR: $SetGlobal iGdxDir_GrowthScen "%iDataDir%\ExternalScenarios"
$SetGlobal iGdxDir_GrowthScen "%ExtDir%\ExternalScenarios"
**$SetGlobal iFile_GrowthScen   "2022_12_02_ENV-Growth_OECD-LTM_Data"

* OPTIONS: Other Locations

*$SetGlobal iGdxDir_IEAScen "%iGdxDir_ImportedScen%"

*   Some Model Choices

$SetGlobal UseIMPACT "ON"

*   Choose some predermined mapping [Optional]
* predefined regional aggregation: %RegionalAgg% = {EU,G20,Small,OECD}
* predefined sectoral aggregation: %SectorAgg%   = {Large,Small}

$SetGlobal RegionalAgg "MCD"
$SetGlobal SectorAgg "MCD"
*$SetGlobal SectorAgg   "Small"

* OPTION: Change folder where is located the bridge file: "Map.gms"

***HRR: use project-specific map file: $SetGlobal iMapDir "%RootDir%\IMF_PROJECTS\2022_CPE\InputFiles"

*   Changes default regional aggregation: %RegionalAgg%

*   Changes default sectoral aggregation: %SectorAgg%
*   (for SectorAgg=="Large" all global variable below are "ON")

*$SetGlobal split_gas "ON"
*$SetGlobal split_lvs "ON"
*$SetGlobal split_acr "ON"
*$SetGlobal split_oma "ON"
*$SetGlobal split_ser "ON"

**Added in MCD sectoral agg
$$SetGlobal split_eim "OFF"

*   If the following folders are not declared some instructions are not read

$SetGlobal DebugDir   "%ToolsDir%\debug"
$SetGlobal OutMngtDir "%ToolsDir%\OutputMngt"
