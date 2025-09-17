$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
	GAMS file    : "%ModelDir%\2-CommonIns.gms"
	purpose      : Load common instructions for all %SimType%

				   Start initializing the model: read the dimensions, parameters
				   and the model specification

					1.) Define model sets and bundle choices
						--> Load macros from %ToolsDir%
						--> declare vintage, sim, time, files
						--> load sets: %Prefix%Sets, 22-Additional_Sets, specific_sets
						--> BundleOption: choices for CET/CES bundle nesting
					2.) Declare and assign values to model Parameters
						--> prm.gms: standard elasticities
						--> override with 25-IMF_Prm.gms [If activated]
						--> override with %iFilesDir%\%Prefix%Prm.gms [if Exist]
						--> 25-DeclareVariant_Prm.gms for variant
						--> Declare specific output for the project: %iFilesDir%\ResumeOutput.gms
					3.) read macros & models specification
							--> Declare model macros
							--> Declare model
	Created by   : Jean Chateau
					from a Compilation of various instructions by Dominique for ENVISAGE
					and OECD ENV-Linkages V4 instructions
	Created date : 17 Septembre 2021
	called by    : "%ModelDir%\%SimType%.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/2-CommonIns.gms $
	last changed revision: $Rev: 517 $
	last changed date    : $Date:: 2024-02-24 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*				0.) Preamble instructions [OECD-ENV]                           *
*------------------------------------------------------------------------------*

*	Create Folders if not exist

$IF NOT DEXIST "%oDir%"     $call "mkdir %oDir%"
$IF NOT DEXIST "%SimDir%"   $call "mkdir %SimDir%"
$IFi %oGdxDir_Macro%=="ON" $$If NOT DEXIST "%oDir%\outMacro" $call "mkdir %oDir%\outMacro"

*	Define some Checking Options:  Save various info in various files

$IF NOT DEXIST "%DirCheck%" $call "mkdir %DirCheck%"

* First part of name for checkings procedure:

$SetGlobal cFile "%DirCheck%\%simName%"

* Same but for files that will not be impacted by the run (like init or cal)

$SetGlobal cBaseFile "%oDirCheck%\%BaseName%\Check"

* Security

$IfTheni.NoDebugDir NOT SET DebugDir
    $$SetGlobal IfSlicing "OFF"
    $$SetGlobal IfDotLoUp "OFF"
$Endif.NoDebugDir

*	Activate Slicing Flag (or activated for a given year in AdjustSimOption.gms)

$Ifi %IfSlicing%=="ON" IfSlicing = 1 ;

*------------------------------------------------------------------------------*
*				1.) Define model sets and bundle choices                       *
*------------------------------------------------------------------------------*

$batinclude "%ToolsDir%\time_sets.gms" tt

*	Load various useful macros

$include    "%ToolsDir%\macros.gms"

*   Time variables

PARAMETERS
    years(tt) "Years in number"
    gap(t)
    FirstYear, finalYear;

years(tt) = ord(tt) + {%YearHist% - 1} $ ifDyn;
gap(t) = 1 $ t0(t) + {years(t) - years(t-1)} $ {not t0(t)} ; !! [TBC] with compStat.gms

loop(t0, FirstYear = years(t0) ; ) ; !! = %YearStart%
finalYear = smax(t,years(t)) ;       !! = %YearEndofSim%

$OnText
    Memo: For compStat

        years("base")  = 1 ;
        years("check") = 2 ;
        years("shock") = 3 ;
        FirstYear      = 1 ;
        finalYear      = 3 ;

$OffText

set ts(t) "Current simulated year" ;
alias(t,tsim) ;

*   Vintages (Memo by default One vintage in CompStat)
* [EditJEan]: check why we need both %nb_vintage% and ifVint

$IfTheni.NbVint %nb_vintage%=="1"

    sets
        v        "Vintages"                 / Old /
        vOld(v)  "Old vintage"              / Old /
        vNew(v)  "New vintage"              / Old /   ;
    Scalar ifVint "Set to 0 for no vintage capital spec" / 0 /;

$Else.NbVint

    sets
        v        "Vintages"                 / Old, New /
        vOld(v)  "Old vintage"              / Old /
        vNew(v)  "New vintage"              / New /    ;
    Scalar ifVint "Set to 1 for vintage capital spec"    / 1 /;

$EndIf.NbVint

alias(v,vp) ;

SCALARS
	riter   "counter for iteration on countries"
*	iter  "Iteration counter for AlterTax"
*	nSubs "useless?"
	nriter  "number of loop across countries" / 0 /
;

* OECD-ENV: add Flags to activate some equation scaling

$IfTheni.FlagScaleEq %IfScaleEq%=="ON"
    Scalars
        IfScale_pmteq   / 1 /
        IfScale_landeq  / 1 /
        IfScale_xwdeq   / 1 /
        IfScale_xmteq   / 1 /
        IfScale_pateq   / 1 / 
        IfScale_xeq     / 0 /
        IfScale_paNRGeq / 1 /  ;
$Endif.FlagScaleEq

*------------------------------------------------------------------------------*
*                       Declare of various files                               *
*------------------------------------------------------------------------------*

file screen / con /; !! Alternative: file screen / screen.txt /;
file failedSim      ;
file SaveCurrentYear;
file failedRegSim   ;
file savesim        ;
file loadsolution   ;
file SaveTmpSim     ;

*   Fill with declining sector informations --> "%cFile%_declining_sectors.txt"

* Delete previous version of the file

$CALL DEL "%cFile%_declining_sectors.txt"

* Create new version of the file

file declin  / '%cFile%_declining_sectors.txt' / ; declin.ap = 1;

*------------------------------------------------------------------------------*
*                       Save the CSV-formatted results                         *
*------------------------------------------------------------------------------*

* CSV results go to this file

file fsam "Csv files with SAM"  / %oDir%\SAM_%SimName%.csv / ;

* This file is optional--sometimes useful to debug model

file debug / %oDir%\%SimName%DBG.csv / ;
IF(0,
   put debug ;
   put "Var,Region,Sector,Qual,Year,Value" / ;
   debug.pc=5 ;
   debug.nd=9 ;
) ;

* OECD-ENV:  File for MAC curves analysis

file fmac "Csv files with MAC"  / %oDir%\MAC_gradual_%rPol%_%GhgTax%_%SrcTax%_%AgentTax%.csv  / ;
*file fmac "Csv files with MAC"  / %oDir%\MAC_constant_%rPol%_%GhgTax%_%SrcTax%_%AgentTax%.csv / ;

*------------------------------------------------------------------------------*
*           Start initializing the model: 1.) Set definitions                  *
*------------------------------------------------------------------------------*

*	Load sets generated by "AggGTAP.gms" procedure

$include "%iDataDir%\%Prefix%Sets.gms"

* Add various sets (not GTAP related and not project related)
$Include "%ModelDir%\22-Additional_Sets.gms"

***HRR: added here the new generic sets. We need to clean up the old "specific_sets", which have reg groupings from old G20
$IF NOT SET iFile_SpecificSets $SetGlobal iFile_SpecificSets "%iFilesDir%\specific_sets"
$IF EXIST "%iFile_SpecificSets%.gms" $include "%iFile_SpecificSets%.gms"
*HRR: $IF EXIST "%GenericSets%\specific_sets" $include "%GenericSets%\specific_sets"

* Add project specific sets for GroupName
$IF EXIST "%GenericSets%\Generic_sets_%GroupName%.gms" $include "%GenericSets%\Generic_sets_%GroupName%.gms"

* Add Aggregation specific sets
$IF EXIST "%GenericSets%\Generic_sets_%RegionalAgg%_agg.gms" $include "%GenericSets%\Generic_sets_%RegionalAgg%_agg.gms"
***endHRR

*	OECD-ENV: Choices about bundle nesting (should be removed from agg procedure)

$Include "%ModelDir%\23-BundleOption.gms"

* 	OECD-ENV Dynamic calibration: declaration of calibration variables

$IFi NOT %SimType%=="Variant" $IFi %DynCalMethod%=="OECD-ENV" $batinclude "%CalDir%\1-0-dynamic_calibration_declaration.gms" "DeclareFlagTgt"

*------------------------------------------------------------------------------*
*		 2.a.) Declare and assign values to model Parameters           	       *
*------------------------------------------------------------------------------*

*   Read default parameter & values

$Include "%ModelDir%\24-default_prm.gms"

*	override with ENV-Linkages parameterization (for model aggregation)

IF(IfENVLPrm eq 1,
	$$Include "%ModelDir%\25-OECD_Prm.gms"
) ;

*	override with IMF-ENV parameterization (for model aggregation)

IF(IfENVLPrm eq 2,
	$$Include "%ModelDir%\25-IMF_Prm.gms"
) ;

*   Override with project specific parameter values

* Case: "iFile_SpecificPrm" (i.e. location of Prm.gms file) not declared
* then use default location: \InputFiles

$IF NOT SET iFile_SpecificPrm $SetGlobal iFile_SpecificPrm "%iFilesDir%\%Prefix%Prm"

* override some parameters values with project specific values

$IF EXIST "%iFile_SpecificPrm%.gms" $include "%iFile_SpecificPrm%.gms"

*	Save parameters (not really useful)

IF(IfDebug AND ifCal,
	EXECUTE_UNLOAD "%oDir%\ModelParameters.gdx"
		sigmaxp, sigmap, sigman1, sigman2, sigmawat,
		sigmav, sigmav1, sigmav2,
		sigmakef, sigmakf, sigmakw, sigmak,
		sigmaul, sigmasl,
		sigmae, sigmanely, sigmaolg, sigmaNRG,
		omegas, sigmas,
		sigmael, sigmapow, sigmapb,
		incElas, nu,
*		eh, bh,
		nue, nunnrg, nunely, nuolg, nuNRG, sigmafd0
		sigmamt, sigmaw, omegax, omegaw, sigmamg0
		omegak, invElas,
		etat, landMax00,	omegat, omeganlb, omegalb,
		omegax, omegaw,
		sigmaemi, etanrf0, omegam0, etanrfx0
	;
) ;

*   Declare debug variables and sets

$IfTheni.AuxCalc SET DebugDir

    SET walrasSet /
			"Walras.l"
			"Based External accounts (Global Model)"
			"Based on I-S market (Global Model)"
			"Based External accounts (Regional Model)"
			"Based on I-S market (Regional Model)"
			"other"
			"Sum current accounts"
		/ ;
    PARAMETERS
		etat_statut(*,t,*)		    "Checking: current simulation outcomes"
		check_walras(walrasSet,*,t) "Checking: diiferent postsim Walras calc."
	;

$EndIf.AuxCalc

*------------------------------------------------------------------------------*
*		 2.b.) Declare some parameters for variant only & slicing module       *
*------------------------------------------------------------------------------*

*   OECD-ENV: Declare New Variable and parameters not for dynamic calibration

$IFi NOT %SimType%=="Baseline" $include "%ModelDir%\25-DeclareVariant_Prm.gms"

*   OECD-ENV: This is parameters from Jean Foure's slicing module

$Ifi %IfSlicing%=="ON" $BatInclude "%DebugDir%\slicing.gms" "2-CommonIns"

*   OECD-ENV: add sets for auxilliary and output variables

$IF SET IfPostProcedure $SetGlobal IfAuxi "ON"
alias(regions,*);    !! ra and a
alias(agents,*);     !! fd and a
$Ifi %IfAuxi%=="ON" alias(commodities,*) ; alias(items,*) ; alias(skills,l) ;

*   Define simulation set (for now only one --> TBU)

set sim / %simName% / ;

*	Declare parameters (ie outputs) specific to the project

* memo: If exist ResOutFile has been defined in "ModelOption.gms"

$IF EXIST "%ResOutFile%" $batinclude "%ResOutFile%" "2-CommonIns"

*------------------------------------------------------------------------------*
*          		3.) read macros & models specification 					       *
*------------------------------------------------------------------------------*

$include "%ModelDir%\26-macros.gms"

* Core equations of the model (Default)

$include "%ModelDir%\27-model.gms"

* Alternative specifications/Equations of the model + Policy Eq.

$include "%ModelDir%\28-model_AltEq.gms"

