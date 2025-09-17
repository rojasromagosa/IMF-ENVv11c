* variant simulation: "%SimType%" == "SemiExo"

$Include "%ModelDir%\default_option.gms"
$IF EXIST "%iFilesDir%\ModelOption.gms" $Include "%iFilesDir%\ModelOption.gms"

*---    Define dynamic setup for a dynamic calibration simulation
sets
    tt       "Full time horizon"                / %YearHist%  * %YearEnd% /
    t(tt)    "Simulation time horizon"          / %YearStart% * %YearEndofSim% /
    t0(t)    "Base year"                        / %YearStart% /
;

parameters  years(tt), gap(t);
years(tt) = %YearHist% - 1 + ord(tt) ;
gap(t)    = 1$t0(t) + (years(t) - years(t-1))$(not t0(t)) ;

Scalars
    ifDyn  "Set to 1 for dynamic simulation"    / 1 /
    ifCal  "Set to 1 for dynamic calibration"   / 1 /
;

*---    Load common instructions
$include "%ModelDir%\CommonIns.gms"

$SHOW

*  Load the generic scenario initialization files
$include "%ModelDir%\initScen.gms"

* [EditJean]: Add macro scenario
*---    Load calibrated trends from an External Scenario
$IF EXIST "%RootDir%\LoadScenFromENV-L.gms" $Include "%RootDir%\LoadScenFromENV-L.gms"
*---    Initialize and calibrate the model, implement the closure rules
$include "%ModelDir%\init.gms"
$include "%ModelDir%\cal.gms"
$include "%ModelDir%\closure.gms"

*---    Load DvM investment target for Dynamic Baseline: "invTargetT(r,t)"
$include "%ModelDir%\ENVISAGE_invTargetT.gms"

*---    Loop over all time periods and solve the model
*   (save for the first time period) formerly in %ProjectDir%\%BaseName%Opt)

loop(tsim$(years(tsim) le (0*finalYear + 1*%YearEndofSim%)),
    ts(tsim) = yes ;

*  Initialize the dynamic calibration model for the new time period
    $$batinclude "%ModelDir%\iterloop.gms" "%YearStart%"

*  Include the standard baseline shocks/scenario

    $$IFi %DynCalMethod%=="ENVISAGE" $include "%FolderPROJECTS%\GenericProject\InputFiles\BaUShk.gms"

*  Invoke the solver with the model definition for a baseline "coreBau"
    IF(ord(tsim) gt 1,
        $$batinclude "%ModelDir%\solve.gms" coreBau
    );
    display walras.l ;
*  Update the SAM
    $$include "%ModelDir%\sam.gms"
    ts(tsim) = no ;
);

* [EditJean]: add a common file for all %SimType%
$$include "%ModelDir%\PostSimInstructions.gms"


