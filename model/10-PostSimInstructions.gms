$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%ModelDir%\10-PostSimInstructions.gms"
   purpose     :  various postsim calculations
   created date: -
   created by  : Dominique van der Mensbrugghe (11-postsim.gms) for saving the CSV-formatted results
   Modified by : Jean Chateau for OECD-ENV
                    - add %1 = {t,tsim} and simmplify with macro
                    - add OutMacro.gms and OutAuxi.gms" procedures
                    - add Project Specific output [optional]
   called by   : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/10-PostSimInstructions.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29#$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

    [EditJean]: Formerly these instructions where set after the time loop
    in the files: %ProjectDir%\%BaseName%Opt

$OffText


*   Save the CSV-formatted results

$include "%ModelDir%\11-postsim.gms"

*------------------------------------------------------------------------------*
*             [OECD-ENV]: Additional postsim procedures                         *
*------------------------------------------------------------------------------*

*   Add two Output Files "OutMacro.gms" & "OutAuxi.gms"

$IfThen.ExtraOutput DEXIST "%OutMngtDir%"

***hrr    $$batinclude "%PolicyPrgDir%\AverageCarbonPrice.gms"  "t"
    $$batinclude "%OutMngtDir%\OutMacro.gms" "NoMoreStep" "t"
    $$IFi %IfAuxi%=="ON" $Include "%OutMngtDir%\OutAuxi.gms"

$Endif.ExtraOutput

*    Project Specific output [optional]

$IF EXIST "%ResOutFile%" $batinclude "%ResOutFile%" "10-PostSimInstructions"

*   Save full output [optional]

* Remove some useless info from full output

$IF DECLARED before OPTION clear=before, clear=beforeOreq, clear=after, clear=between, clear=tCount, clear=between1, clear=between2, clear=between3;
OPTION clear=lfpr_envisage, clear=educ, clear=popg;
$IFi %SimName%=="variant" OPTION clear=emi_bau, clear=emi_ref;
m_clearWork

* clear calibration variables

$IF DECLARED IMPACT 		OPTION clear=IMPACT, clear=IMPACT_World_Prices, clear=IMPACT_Cropland_shock;
$IF DECLARED Emissions_data OPTION clear=Emissions_data;
$IF DECLARED TgtVar 		OPTION clear=TgtVar;

***HRR: delete this?
* For comparison baseline vs bau
IF(0,
	IF(IfCal,

		OPTION clear=ETPT,  clear=g_l, clear=ArmMShrt1;
		OPTION clear=pMwh0, clear=ELOUTPUT0 ;

	) ;

	OPTION clear=WageIndexRule, clear=TFP_fp ;

) ;
***endHRR


* Clear slicing variables

$$IFi %IfSlicing%=="ON" $$BatInclude "%DebugDir%\slicing.gms" "clear"

$IfTheni.DebugFiles SET DebugDir

*	 Save simulation informations:

* Save information about Global Variables and Flags

***HRR: took away     $$BatInclude "%DebugDir%\GlobalVar_and_Flag_values.gms" "%SimName%"

* Save full output (ie result of simulation) + fill "Statut_des_simulations.txt"

    $$SetGlobal CheckFileName "%oDirCheck%\Statut_des_simulations"
    file CheckSimOk / %CheckFileName%.txt /;
    $$IF EXIST "%CheckFileName%.txt" CheckSimOk.ap = 1; !! append on existing file

* [EditJean]: Revoir cette boucle en cas de MutltiSim & de save and restart

*LOOP(sim,

* Save the full simulation results in a GDX container

*   PUT_UTILITY savesim 'gdxout' / '%oDir%\' sim.tl:0 '.gdx';
***HRR
$ontext
    $$IF NOT SET StoreInArc PUT_UTILITY savesim 'gdxout' / '%oDir%\%simName%.gdx';

    $$IF     SET StoreInArc $If NOT DEXIST "V:\CLIMATE_MODELLING\archives\CGE_PROJECTS_ARC\%BaseName%\%oDir%" $call "mkdir V:\CLIMATE_MODELLING\archives\CGE_PROJECTS_ARC\%BaseName%\%oDir%"
    $$IF     SET StoreInArc PUT_UTILITY savesim 'gdxout' / 'V:\CLIMATE_MODELLING\archives\CGE_PROJECTS_ARC\%BaseName%\%oDir%\%simName%.gdx';
    EXECUTE_UNLOAD;
$offtext
***endHRR

* Save sucess or not file

    put CheckSimOk;
    IF(etat_statut("%simName%","%YearEndofSim%","solvestat") eq 1,
*       IF(etat_statut(sim,"%YearEndofSim%","solvestat") eq 1,
*            put "Simulation ", sim.tl:0 " reussie le %system.DATE% Fichier: %oDir%\" sim.tl:0 /;
            put "Simulation %simName% done on %system.DATE% was successful - Output file: %ProjectDir%\%oDir%\%simName%.gdx" /;
        ELSE
*            put "Simulation ", sim.tl:0 " echouee le %system.DATE% Fichier: %oDir%\" sim.tl:0 /;
            put "Simulation %simName% done on %system.DATE% failed" /;
    ) ;

*) ;

$EndIf.DebugFiles

*------------------------------------------------------------------------------*

*  This is still undergoing testing and is only appropriate for the 10x10 model
*  Save the key model parameters for the baseline simulation
* [EditJean]: il faut actualiser ou pas [Inactif pour le moment]
$SetGlobal IFSAVEPARM "0"

$ifthen.SaveParm "%IFSAVEPARM%" == "1"
    scalar ifCSVVerbose / 0 / ;
    SETS
        sortOrder / sort1*sort1000 /
        mapRegSort(sortOrder,r) /
            sort1.Oceania
            sort2.EU_25
            sort3.NAmerica
            sort4.EastAsia
            sort5.SEAsia
            sort6.SouthAsia
            sort7.MENA
            sort8.SSA
            sort9.LatinAmer
            sort10.RestofWorld
        /
        mapActSort(sortOrder,a) /
            sort1."Agriculture-a"
            sort2."Extraction-a"
            sort3."ProcFood-a"
            sort4."TextWapp-a"
            sort5."LightMnfc-a"
            sort6."HeavyMnfc-a"
            sort7."Util_Cons-a"
            sort8."TransComm-a"
            sort9."OthServices-a"
        /
        mapCommSort(sortOrder,i) /
            sort1."GrainsCrops-c"
            sort2."MeatLstk-c"
            sort3."Extraction-c"
            sort4."ProcFood-c"
            sort5."TextWapp-c"
            sort6."LightMnfc-c"
            sort7."HeavyMnfc-c"
            sort8."Util_Cons-c"
            sort9."TransComm-c"
            sort10."OthServices-c"
        /
        mapkCommSort(sortOrder,k) /
            Sort1."GrainsCrops-k"
            Sort2."MeatLstk-k"
            Sort3."Energy-k"
            Sort4."ProcFood-k"
            Sort5."TextWapp-k"
            Sort6."LightMnfc-k"
            Sort7."HeavyMnfc-k"
            Sort8."TransComm-k"
            Sort9."OthServices-k"
        /
    ;
    $$include "%ModelDir%\12-saveParm.gms"

$endif.SaveParm

