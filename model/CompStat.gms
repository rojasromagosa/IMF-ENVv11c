$OnText
--------------------------------------------------------------------------------
            OECD-ENV Model version 1.0 - Driver program
	GAMS file    : "%ModelDir%\compStat.gms"
	purpose      : Run comparative static simulation
	Created by   : Jean Chateau
	Created date : 8 March 2021
	called by    : "%ProjectDir%\runSim.gms" with %SimType%=="compStat"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/compStat.gms $
	last changed revision:    $Rev: 508 $
	last changed date    :    $Date:: 2024-02-06 #$
	last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal ModelName "core"
$SetGlobal IfCalELES "static"

*------------------------------------------------------------------------------*
*       Define Model Set-up: data, parameter, equations + calibration          *
*------------------------------------------------------------------------------*

*	Define dynamic setup for a comparative static simulation

Scalars
    ifDyn  "Set to 1 for dynamic simulation"    / 0 /
    ifCal  "Set to 1 for dynamic calibration"   / 0 /
;

* Include Default options

$Include "%ModelDir%\1-default_option.gms"

* Override Default options with project specific choices

$IF EXIST "%iFilesDir%\ModelOption.gms" $Include "%iFilesDir%\ModelOption.gms"

* Define time sets for a comparative static simulation

sets
    tt       "Full time horizon"        / base, check, shock /
    t(tt)    "Simulation time horizon"  / base, check, shock /
;

singleton sets
   t0(t)    "Base year"       / base /
   tlag(t)  "Lagged year"     / base /
;

* Load common instructions (same for all %SimType%)
* --> read macros, define sets, load parameters

$include "%ModelDir%\2-CommonIns.gms"

* Initialize the generic comparative static scenario

$include "%ModelDir%\2-compStat-InitScen.gms"

* Define models

$include "%ModelDir%\3-ModelDefinition.gms"

* Initialize the model

$include "%ModelDir%\4-init.gms"

* calibrate model parameters

$include "%ModelDir%\5-cal.gms"

* implement closure rules

$include "%ModelDir%\6-closure.gms"

*	Skip Simulations (debbuging)
display finalYear;
display "YearEndofSim: %YearEndofSim%";
* $Goto EOcompStat

*------------------------------------------------------------------------------*
*               Loop over runs and solve the model                             *
*------------------------------------------------------------------------------*
*   (save for the first time period) formerly in %ProjectDir%\%BaseName%Opt)

loop( tsim $ (years(tsim) le (0*finalYear + 1*%YearEndofSim%)),

    ts(tsim) = yes ;

*  Initialize the static model for the new time period

    $$include "%ModelDir%\7-iterloop.gms"

*  Include the simulation-specific shocks for CompStat

*   $$IF EXIST "%iFilesDir%\%CompShk%.gms"  $batinclude "%iFilesDir%\%CompShk%.gms"
*   $$IF EXIST "%PolicyPrgDir%\CompShk.gms" $batinclude "%PolicyPrgDir%\%CompShk%.gms"

   if(sameas(tsim,"shock"),
      pnum.fx(tsim) = 1.1 ;
   else
      pnum.fx(tsim) = 1.0 ;
   ) ;

*  Invoke the solver with the model definition for Comparative static "core"

    IF(ord(tsim) gt 1,
        options iterlim=100, reslim=100000 ;
        $$batinclude "%ModelDir%\8-solve.gms" "%ModelName%"
    );

* Update the SAM

    $$batinclude "%ModelDir%\9-sam.gms" "tsim"

    ts(tsim) = NO ;
);

*------------------------------------------------------------------------------*
*           Common postsim instructions for all %SimType%                      *
*------------------------------------------------------------------------------*

* $include "%ModelDir%\10-PostSimInstructions.gms"

if(1,
    put fsam ;
    put "Sim,Region,Rlab,Clab,Year,Value" / ;
    fsam.pc = 5 ;
    fsam.nd = 10 ;
    loop((sim,t,r,is,js) $ sam(r,is,js,t),
        put sim.tl,r.tl,is.tl,js.tl,m_PUTYEAR,(outScale*sam(r,is,js,t)) / ;
    ) ;
) ;

Parameter samCheck(*,ra,is,t) ;
samCheck("rowSum",ra,is,t) = outScale*sum(mapr(ra,r), sum(js, sam(r,is,js,t))) ;
samCheck("colSum",ra,js,t) = outScale*sum(mapr(ra,r), sum(is, sam(r,is,js,t))) ;
samCheck("Resid",ra,is,t)  = samCheck("rowSum",ra,is,t) - samCheck("colSum",ra,is,t) ;

Execute_Unload "%oDir%/CompStat.gdx" ;
$Label EOcompStat