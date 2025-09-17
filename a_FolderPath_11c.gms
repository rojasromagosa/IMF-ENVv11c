*------------------------------------------------------------------------------*
* This file "a_FolderPath".gms is generated automatically by 00a-getPath.bat   *
*------------------------------------------------------------------------------*

$OnGlobal

*   Specify the main drive
$SetGlobal iDrive "C:\Mac\Home\Documents"

*   Main Folders:
$SetGlobal RootDir    "C:\Mac\Home\Documents\IMF-ENVv11.1-main"
$SetGlobal DataDir    "%RootDir%\Data"
$SetGlobal SetsDir    "%DataDir%\common_sets"
$SetGlobal ModelDir   "%RootDir%\model"
$SetGlobal CalDir     "%RootDir%\calibration"
$SetGlobal ToolsDir   "%RootDir%\tools"
$SetGlobal CommonDir  "%RootDir%"

*       Default external Folder with generic Data (can be modified)
$SetGlobal ExtDir "C:\Mac\Home\Documents\IMF-ENV_external"
$SetGlobal SatDataDir "%ExtDir%\SatData"

*------------   Folders for any %BaseName% project   --------------------------*

$SetGlobal FolderPROJECTS "%RootDir%\PROJECTS"
$IF SET BaseName $SetGlobal ProjectDir  "%FolderPROJECTS%\%BaseName%"
$IF SET BaseName $SetGlobal iFilesDir   "%ProjectDir%\InputFiles"
$IF SET BaseName $SetGlobal iDataDir    "%ProjectDir%\InputData"
$IF SET BaseName $SetGlobal GenericSets "%FolderPROJECTS%\GenericSets"
$IF SET BaseName $SetGlobal GenericCal  "%FolderPROJECTS%\CommonPolicyFiles"


*   Default folder to store temporary checking files (can be modified)
$SetGlobal oDirCheck "%iDataDir%\Checks"
$If NOT DEXIST "%oDirCheck%" $call "mkdir %oDirCheck%"

*   Load File with specific options of a project  [%GTAP_DBType%, %GTAP_ver%, %YearGTAP%,...]

$IF     EXIST "%ProjectDir%\a_ProjectOptions.gms" $include "%ProjectDir%\a_ProjectOptions.gms"
***HRR$IF NOT EXIST "%ProjectDir%\a_ProjectOptions.gms" $include "%ToolsDir%\a_ProjectOptions.gms"

*   Folders with data needed for agregation procedure
$SetGlobal FolderGTAP      "%ExtDir%\GTAP\GTAP_Data\V%GTAP_ver%\20%YearGTAP%"
$SetGlobal iGdxDir_GtapDB  "%FolderGTAP%\%GTAP_DBType%"

*   [ENVISAGE] Satellite Account data

$SetGlobal gtpSatDir   "%SatDataDir%\GTAPSatAcct"
***HRR: using new SSP file for GTAPv11
$SetGlobal SSPFile     "%ExtDir%\SatData\SSPv3\DIST02FEB2024\SSP_GTAP02FEB.gdx"

$SetGlobal giddLab     "%gtpSatDir%\giddLab.gdx"
$SetGlobal giddProj    "%gtpSatDir%\giddProj.gdx"
$SetGlobal EnvElastOld "%gtpSatDir%\EnvLinkElast.gdx"
$SetGlobal EnvElastNew "%gtpSatDir%\EnvLinkElast.gdx"
*$SetGlobal EnvElastNew "%gtpSatDir%\EnvLinkElast11P4POW.gdx"

*       Actualize the global variable %dateout% to the current date

* Generate the file "date.txt"

$call 'gams dateout --RootDir=%RootDir% -idir=%ToolsDir%'

* Read %dateout%

$include "%RootDir%\date.txt"
