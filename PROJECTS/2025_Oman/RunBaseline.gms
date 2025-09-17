$OnEolCom
*$OffListing

$SetGlobal BaseName "2025_Oman"

* Select underlying NRG scenario (for Baseline)

$SetGlobal ActWeoSc "CPS"

* Choose the type of simulation: SimType={"Baseline","variant","CompStat"}

$SetGlobal SimType "Baseline"
***$SetGlobal SimType "CompStat"

***HRR: set number of vintages to 1 for CompStat
$if %SimType%=="CompStat" $setGlobal nb_vintage 1

* Preamble read various folders location (including load "a_ProjectOptions.gms")

$include "..\..\a_FolderPath.gms"

* Select folder containing output files:

$SetGlobal oDir "Output_%dateSim%"

* Default name for baseline

$SetGlobal BauName "Baseline"
$Ifi %SimType%=="CompStat" $SetGlobal BauName "BauComp"

* default SimName

$SetGlobal SimName "%BauName%"

* Folder where are stored year by year simulation [Option]

*$SetGlobal SimDir  "Data_%SimName%"

*   Load instructions

*---    Load instructions

*   Standard Mode

$include "%ModelDir%\%SimType%.gms"



$SHOW

