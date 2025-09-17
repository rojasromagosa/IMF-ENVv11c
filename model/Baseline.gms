$OnText
--------------------------------------------------------------------------------
            OECD-ENV Model version 1.0 - Driver program
	GAMS file    : "%ModelDir%\Baseline.gms"
	purpose      : Run dynamic calibration simulation
	Created by   : Jean Chateau
	Created date : 8 March 2021
	called by    : "%ProjectDir%\runSim.gms" with %SimType%=="Baseline"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/Baseline.gms $
	last changed revision:    $Rev: 518 $
	last changed date    :    $Date:: 2024-02-29 #$
	last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal ModelName "coreBau"
$SetGlobal VarFlag 	 "0"

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

$SetGlobal StepSavRes %1

$IfThenI.Step %StepSavRes%=="Historic"

*	Historical step: %YearStart% to %2

    $$IF NOT DEXIST "%oDir%\SaveAndRestart" $call "mkdir %oDir%\SaveAndRestart"
    $$SetGlobal StartTimeLoop "%YearStart%"
    $$SetGlobal EndTimeLoop "%2"

* Skip the preamble step

    $$GOTO BOHist

$ElseIfi.Step %StepSavRes%=="Projection"

*	Projection step: from %2 to %3

    $$SetGlobal StartTimeLoop "%2"
    $$SetGlobal EndTimeLoop   "%3"

* Skip the preamble and historical steps

     $$GOTO BOProj

$Endif.Step

*------------------------------------------------------------------------------*
*       Define Model Set-up: data, parameter, equations + calibration          *
*------------------------------------------------------------------------------*

*   Define dynamic setup for a dynamic calibration simulation

Scalars
    ifDyn  "Set to 1 for dynamic simulation"  / 1 /
    ifCal  "Set to 1 for dynamic calibration" / 1 /
;

*   Include default options

$Include "%ModelDir%\1-default_option.gms"

*   Override default options with project specific choices

$IF EXIST "%iFilesDir%\ModelOption.gms" $Include "%iFilesDir%\ModelOption.gms"

* OECD-ENV Dynamic calibration: declaration of sets and options

$IFi %DynCalMethod%=="OECD-ENV" $batinclude "%CalDir%\1-0-dynamic_calibration_declaration.gms" "GlobalDecl"

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
*       --> read macros, define sets and parameters, load parameters values

$include "%ModelDir%\2-CommonIns.gms"

*   ENVISAGE Dynamic calibration: Initialize the generic dynamic calibration

$include "%ModelDir%\2-DynCal-initScen.gms"

*	OECD-ENV Dynamic calibration: Add. params declaration & Load Macro trends

$IFi %DynCalMethod%=="OECD-ENV" $include "%CalDir%\2-0-dynamic_calibration_DefineTargets.gms"

*   Define models

$include "%ModelDir%\3-ModelDefinition.gms"

*   Initialize the model

$include "%ModelDir%\4-init.gms"

*   calibrate model parameters

$include "%ModelDir%\5-cal.gms"

*   !!!!!!!!!!! END OF "preamble" step for the "Save and Restart Mode"

$IFi %StepSavRes%=="preamble" $GOTO EOBaseline

*   !!!!!!!!!!! BEGIN OF "historical" step for the "Save and Restart Mode"

$LABEL BOHist

*   implement closure rules

$include "%ModelDir%\6-closure.gms"

*   [ENVISAGE] Dynamic calibration: Load investment target for Dynamic Baseline: "invTargetT(r,t)"
$IFi %DynCalMethod%=="ENVISAGE" $include "%ModelDir%\61-ENVISAGE_invTargetT.gms"

*   [OECD-ENV] Dynamic calibration: Assign targets to variable for all trajectory (pop, gdp,...)
$IFi %DynCalMethod%=="OECD-ENV" $include "%CalDir%\3-0-dynamic_calibration_AssignTargets.gms"

**HRR: calibration of ELES for ENVISAGE
$IFi %DynCalMethod%=="ENVISAGE" $IFi %cal_preference%=="ON" $include "%ModelDir%\30-ENVISAGE-ELEScal.gms"

IF(IfDebug, Execute_unload "%cFile%_AllBeforeTimeLoop.gdx"; ) ;

*   Skip Simulations (debbuging)

*$GOTO EOBaseline

*   !!!!!!!!!!! BEGIN OF "Projection" step for the "Save and Restart Mode"

$LABEL BOProj

*------------------------------------------------------------------------------*
*           Loop over all time periods and solve the model                     *
*------------------------------------------------------------------------------*

$IF NOT SET StartTimeLoop $SetGlobal StartTimeLoop "%YearStart%"
$IF NOT SET EndTimeLoop   $SetGlobal EndTimeLoop   "%YearEndofSim%"

loop(tsim $ (years(tsim) ge %StartTimeLoop% and years(tsim) le %EndTimeLoop%),

    ts(tsim) = YES ;

*   Initialize the dynamic calibration model for the current time period

    $$include "%ModelDir%\7-iterloop.gms"

    IF(year gt FirstYear,	!! ord(tsim) ge 2

*   Include baseline shocks/scenario

* [ENVISAGE]: Baseline: savf & rinvshr
***HRR: use a project-specific BauShk.gms
*        $$IFi %DynCalMethod%=="ENVISAGE" $include "%FolderPROJECTS%\GenericProject\InputFiles\BaUShk.gms"
        $$IFi %DynCalMethod%=="ENVISAGE" $include "%iFilesDir%\BaUShk.gms"

* [OECD-ENV]: Dynamic calibration: override generic calibration

        $$IFi %DynCalMethod%=="OECD-ENV" $include "%CalDir%\4-0-dynamic_calibration_iterloop.gms"

* Invoke the solver with the model definition for a baseline "coreBau"

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

$Label EOBaseline
