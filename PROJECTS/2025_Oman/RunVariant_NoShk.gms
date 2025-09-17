$OnEolCom
*$OffListing


* Choose the type of simulation: SimType={"Baseline","variant","CompStat"}

$SetGlobal SimType "Variant"

* Preamble read various folders location (including load "a_ProjectOptions.gms")

$include "..\..\a_FolderPath.gms"

* Select folder containing output files:

$SetGlobal oDir   "Output_%DateSim%"


*------------------------------------------------------------------------------*
*                               Variant choices                                *
*------------------------------------------------------------------------------*

*   1.) Choose a policy file

*$SetGlobal PolicyFile "Policy_NGFS"


*   2.) choose a variant scenario and its corresponding VarFlag

*   2.a) Baseline scenarios in variant mode

$SetGlobal simName "NoShk"
$SetGlobal VarFlag "0"


$setglobal recycling "kappah"
*   5.) choose an alternative Baseline

* 5.a.) Change location of the baseline simulation [default is %oDir]

$SetGlobal BauDir "Output_%DateSim%"

* 5.b.) Select a baseline name [default is "baseline"]

*$SetGlobal BauName "Baseline"

*---    Load instructions

$SetGlobal VarFlag "0"

*   Standard Mode

$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%"

$SHOW

