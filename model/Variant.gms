$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Driver program
   GAMS file    : "%ModelDir%\Variant.gms"
   purpose      : Run variant simulations
   Created by   : Jean Chateau
   Created date : 8 March 2021
   called by    : "%ProjectDir%\runSim.gms" with %SimType%=="variant"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/Variant.gms $
   last changed revision:    $Rev: 372 $
   last changed date    :    $Date:: 2023-08-28 #$
   last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal ModelName "coreDyn"

*------------------------------------------------------------------------------*
*               Instructions for the "Save and Restart Mode"                   *
*------------------------------------------------------------------------------*

$Ontext
    There are 3 steps in "Save and Restart Mode"
    loaded as options (in IDE or batch file)

    %StepSavRes% = {"preamble", "Historic", "Projection"},

    First Step : %StepSavRes%==preamble
        Option in IDE/Batch: s=SaveAndRestart\preamble
    Second Step: %StepSavRes%==Historic "2020"
        Option in IDE/Batch: r=SaveAndRestart\preamble s=SaveAndRestart\Historic
    Third Step : %StepSavRes%==Projection" "2021" "2030"
        Option in IDE/Batch: r=SaveAndRestart\Historic

$OffText

$SetGlobal StepSavRes %2

$IfTheni.StepPre %StepSavRes%=="preamble"
    $$IF NOT EXIST "%oDir%\SaveAndRestart" $call "mkdir %oDir%\SaveAndRestart"
$Endif.StepPre
***endHRR

*	Historical step: %YearStart% to 2020
$IfTheni.StepHist %StepSavRes%=="Historic"

***HRR: moved the mkdir command to runall

    $$SetGlobal StartTimeLoop "%YearStart%"
    $$SetGlobal EndTimeLoop "%3"

* Skip the preamble step

$Endif.StepHist
$ifi  %StepSavRes%=="Historic"  $$GOTO BOHist



*	Projection step: from %3 to %4

$IfTheni.StepProj %StepSavRes%=="Projection"

    $$SetGlobal StartTimeLoop "%3"
    $$SetGlobal EndTimeLoop   "%4"

* Skip the preamble and historical steps

$Endif.StepProj

$ifi  %StepSavRes%=="Projection"  $$GOTO BOProj



*------------------------------------------------------------------------------*
*       Define Model Set-up: data, parameter, equations + calibration          *
*------------------------------------------------------------------------------*

*   Define dynamic setup for a variant simulation

Scalars
    ifDyn  "Set to 1 for dynamic simulation"  / 1 /
    ifCal  "Set to 0 for variant"             / 0 /
;

*   Include default options

$Include "%ModelDir%\1-default_option.gms"

*   Override default options with project specific choices

$IF EXIST "%iFilesDir%\ModelOption.gms" $Include "%iFilesDir%\ModelOption.gms"

*   Define time sets for a dynamic simulation

sets
    tt    "Full time horizon"        / %YearHist%  * %YearEnd% /
    t(tt) "Simulation time horizon"  / %YearStart% * %YearEndofSim% /
;

Singleton Sets
    t0(t)   "Base year"                / %YearStart% /
    tlag(t) "Lag year"                 / %YearStart% /
;


*   Load common instructions (same for all %SimType%)
*       --> read macros, define sets, load parameters

$include "%ModelDir%\2-CommonIns.gms"

*   Define models

$include "%ModelDir%\3-ModelDefinition.gms"

*   Initialize the model

$include "%ModelDir%\4-init.gms"

*   calibrate model parameters

$include "%ModelDir%\5-cal.gms"

*   !!!!!!!!!!! END OF "preamble" step for the "Save and Restart Mode"

$IFi %StepSavRes%=="preamble" $GOTO EOVariant

*   !!!!!!!!!!! BEGIN OF "historical" step for the "Save and Restart Mode"

$LABEL BOHist

* [EditJean]: All this in SIMLOOP IF INCLUDED
* [EditJean]: These instructions are not in %StepSavRes%=="Projection"

*   Load Bau trajectory + recalibration functional forms

$include "%ModelDir%\6-DynVar-LoadBauForVariant.gms"

*   implement closure rules

$include "%ModelDir%\6-closure.gms"

* [EditJean]: END SIMLOOP IF INCLUDED

*   !!!!!!!!!!! BEGIN OF "Projection" step for the "Save and Restart Mode"

$LABEL BOProj

*   Declare specific shocks for variants

* In "Save and Restart Mode" the %StepSavRes%=="Projection" will read again
* these shocks, so they can be modified

VarFlag = %1 ;

$IF EXIST "%iFilesDir%\%PolicyFile%.gms"    $batinclude "%iFilesDir%\%PolicyFile%.gms"    "StepDeclaration"
***HRR $IF EXIST "%PolicyPrgDir%\%PolicyFile%.gms" $batinclude "%PolicyPrgDir%\%PolicyFile%.gms" "StepDeclaration"

*	Skip Simulations (debbuging)

*$Goto EOVariant

*------------------------------------------------------------------------------*
*           Loop over all time periods and solve the model                     *
*------------------------------------------------------------------------------*

$IF NOT SET StartTimeLoop $SetGlobal StartTimeLoop "%YearStart%"
$IF NOT SET EndTimeLoop   $SetGlobal EndTimeLoop   "%YearEndofSim%"

loop(tsim $ (years(tsim) ge %StartTimeLoop% and years(tsim) le %EndTimeLoop%),

    ts(tsim) = YES ;

*   Initialize the dynamic calibration model for the current time period

    $$include "%ModelDir%\7-iterloop.gms"

*   Include specific shocks for variants

    $$IF EXIST "%iFilesDir%\%PolicyFile%.gms"    $batinclude "%iFilesDir%\%PolicyFile%.gms"    "7-iterloop"
***HRR     $$IF EXIST "%PolicyPrgDir%\%PolicyFile%.gms" $batinclude "%PolicyPrgDir%\%PolicyFile%.gms" "7-iterloop"

*   Invoke the solver with the model definition for a variant "coreDyn"

    IF(year gt FirstYear,
		$$batinclude "%ModelDir%\8-solve.gms" "%ModelName%"
    ) ;

*   Update the SAM

    $$batinclude "%ModelDir%\9-sam.gms" "tsim"

    ts(tsim) = NO ;

) ; !! End of time-loop

*------------------------------------------------------------------------------*
*           			Postsim instructions			                       *
*------------------------------------------------------------------------------*

$Ifi NOT %StepSavRes%=="Historic" $include "%ModelDir%\10-PostSimInstructions.gms"

$LABEL EOVariant
