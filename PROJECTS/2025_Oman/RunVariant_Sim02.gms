$OnEolCom
*$OffListing

* Choose the type of simulation: SimType={"Baseline","variant","CompStat"}

$SetGlobal SimType "Variant"

* Preamble read various folders location (including load "a_ProjectOptions.gms")

$include "..\..\a_FolderPath.gms"

*   Level of the tax in HICs

$IF NOT SET BatchMode $SetGlobal icpfTaxGr1 "150"

* Select folder containing output files:

$SetGlobal oDir     "output_%DateSim%"

*------------------------------------------------------------------------------*
*                               Variant choices                                *
*------------------------------------------------------------------------------*

*   1.) Choose a policy file

$SetGlobal PolicyFile "Policy_MCD_OMN"


**Set to ON to start ctax in 2031 instead of 2023
$SetGlobal timeflag  "OFF"

*   2.) choose a variant scenario and its corresponding VarFlag

$SetGlobal simName "Sim02"
$SetGlobal VarFlag "102"


*   3.) Carbon Tax Policy [Options]

* 3.a.) Carbon Tax design
* (override values in %PolicyPrgDir%\Global_for_CarbonPolicy.gms)

***HRR
$ontext
$IF NOT SET rPol      $SetGlobal rPol       "r"
$IF NOT SET GhgTax    $SetGlobal GhgTax     "CO2"
$IF NOT SET SrcTax    $SetGlobal SrcTax     "emimainSource"
$IF NOT SET cTaxLevel $SetGlobal cTaxLevel  "450"
$IF NOT SET AgentTax  $SetGlobal AgentTax   "aa"
$IF NOT SET YrPhase1  $SetGlobal YrPhase1   "2030"
$IF NOT SET YrFinTgt  $SetGlobal YrFinTgt   "2030"
$IF NOT SET YrPhase2  $SetGlobal YrPhase2   "2000"

$IFi %simName%=="CarbonTax" $SetGlobal simName "CarbonTax_%cTaxLevel%"
$IFi NOT %rPol%=="r"        $SetGlobal simName "%rPol%_%cTaxLevel%"
$offtext
***endHRR
* 3.b.) Use a Fix Target

* 3.c.) Activate Base BCA (for non global action)

$OnText
   BCA_policy          = {"ON","OFF"}
   BCA_type            = {"NO"(default),"TARIFFS","FULLBCA","EXPORT"}
   BCA_sources         = {"CO2f"(default),"All","CO2"}
   BCA_EmiCoverage     = {"DIRECT","INDIRECT"(default)}
   BCA_CarbonContent   = {"Exporter","Domestic"(default)}
   BCA_revenue         = {"Exporter","Domestic"(default)}
   BCA_Good            = {"EITEi"(default),"i","sBCAi",[any subset of i]}
   BCA_cst             = {"YES","NO"(default)}
$OffText

$SetGlobal BCA_policy           "OFF"
$SetGlobal BCA_type             "TARIFFS"
$SetGlobal BCA_sources          "CO2"
$SetGlobal BCA_EmiCoverage      "INDIRECT"
$SetGlobal BCA_CarbonContent    "Exporter"
$SetGlobal BCA_Good             "EITEi"
*$SetGlobal BCA_Good             "i"

*$SetGlobal InitFile "%oDir%\ICPF_HIC%icpfTaxGr1%_BCA_EITE"

*   4.) Change recycling option: %Recycling% = {"wage"[default], "trg", "rsg", "kappah", "vat"}

$SetGlobal Recycling "wage"

*   5.) choose an alternative Baseline

* 5.a.) Change location of the baseline simulation [default is %oDir]

***HRR $SetGlobal BauDir "2023_09_05_Variant"
$SetGlobal BauDir "%oDir%"

*Baseline

* 5.b.) Select a baseline name [default is "baseline"]

$SetGlobal BauName "Baseline"

* 5.c.) Store year simulations in a dedicated folder

*$SetGlobal SimDir "Data_%SimName%"

*   6.) Override choices above in a specific file

*$SetGlobal VarFlag "[ ]"
*$include "AssignVarFlagToPolicy.gms"

***HRR $IF EXIST "currentRun.txt" $include "currentRun.txt"


*   Standard Mode

$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%"

*   Save and Restart Mode

* 1.) Put in IDE: s=SaveAndRestart\preamble

*$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%" "preamble"

* 2.) Put in IDE: r=SaveAndRestart\preamble s=SaveAndRestart\historic

*$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%" "Historic" "2024"

* 3.) Put in IDE: r=SaveAndRestart\historic

*$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%" "Projection" "2025" "2040"

$SHOW

