$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
   name        : "%iFilesDir%\Prm.gms"
   purpose     :  Change Default parameters for the project "2023_G20"
                  + Define underlying Scenarios according to the variants
   created date: 2023-01-11
   created by  : Jean Chateau
   called by   : %ModelDir%\2-CommonIns.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/2023_G20/InputFiles/Prm.gms $
   last changed revision: $Rev: 384 $
   last changed date    : $Date:: 2023-09-01 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*   CHANGING PARAMETERS

$IfTheni.STD NOT SET IfPostProcedure

*    IfNrgNest(r,h) = 1;

* Change default: activate Savfeq and make savf endogenous

*    ifSavfEQ(r) = 1 ;

* Default where no calibration of electricity Mix

	IF(NOT IfCal,

		sigmapb(r,pb,elyi) $ (NOT Allpb(pb)) = 2 ;
		sigmapow(r,elyi) 					 = 1.1 ;
*		etawl(r,l) = 0 ;

	) ;

$EndIf.STD

*   CHANGING BASELINE OPTIONS (override default)

$IfTheni.DynCalENV %DynCalMethod%=="OECD-ENV"

    $$IfTheni.BAU %SimType%=="Baseline"

		IfTFPSolWindExo = 1   ;
		IfUSToOECDGas   = 1   ;

    $$Endif.BAU

$Endif.DynCalENV

*   ADDITIONAL VARIABLES AND PARAMETERS for "%iFilesDir%\%PolicyFile%.gms"

    Set FeedInSets / Subs, value /

    PARAMETERS
        ElyTgta(r,a,t)     "Electricity Power: target"
        RenewTgtOff(r,tt)  "Official renewable targets"
        FeedInTarrifs(FeedInSets,r,a,t)   ;

    Scalar CutReg / 0 / ;

*   CHANGING POLICY OPTIONS

* Flag to activate BCA (by default inactive)

$IF NOT SET BCA_policy $SetGlobal BCA_policy "OFF"

$IFTheni.BCAon %BCA_policy%=="NOT"

*    $$SetGlobal BCA_type "NO"

    $$OnText
        Memo: BCA reference case when activated

    $$SetGlobal BCA_type          "TARIFFS"
    $$SetGlobal BCA_sources       "CO2f"
    $$SetGlobal BCA_EmiCoverage   "INDIRECT"
    $$SetGlobal BCA_CarbonContent "Domestic"
    $$SetGlobal BCA_revenue       "Domestic"
    $$SetGlobal BCA_Good          "EITEi"

    $$OffText

* Adjusting name of simulation (i.e. %simName%) to BCA cases

    $$IfTheni.NoBCA %BCA_type%=="NO"

        $$SetGlobal simName "%simName%"

    $$ELSE.NoBCA

        $$SetGlobal simName "BCA_%BCA_type%_%BCA_CarbonContent%_%BCA_EmiCoverage%"
        $$IFi NOT %BCA_Good%=="EITEi" $SetGlobal simName "%simName%_%BCA_Good%"

    $$Endif.NoBCA

$EndIf.BCAon

*  CHANGING DEFAULT RECYCLING OPTION (from %YearPolicyStart%)

$iftheni not "%simType%" == "CompStat"
   $$IF NOT SET Recycling $SetGlobal Recycling "kappah"
$else
   $$SetGlobal Recycling "kappah"
$endif

* Change simulation name ...with alternative recycling rule (not for default)

*$IFi NOT %Recycling%=="wage" $SetGlobal SimName "%simName%_%Recycling%"

* --------------------------------------------------------------------------------------------------
*
*  Knowledge module assumptions
*
*
*  delta:      Delta parameter in gamma function
*  lambda:     Lambda parameter in gamma function
*  N:          Number of years in gamma function
*  g0:         Initial steady-state growth parameter
*  depr:       Knowledge depreciation rate
*  rd0:        Initial steady state level of research expenditure wrt to GDP
*  gammar:     Sectoral productivity shifter
*  epsr:       Sectoral productivity elasticity
*
* --------------------------------------------------------------------------------------------------

***HRR: hard coded table below, took average values. Needs revisions
Parameter KnowledgeData0(r,*) ; 
KnowledgeData0(r,"delta")   = 0.60 ;
KnowledgeData0(r,"lambda")  = 0.85 ;
KnowledgeData0(r,"N")       = 25   ;
KnowledgeData0(r,"g0")      = 3.0  ;
KnowledgeData0(r,"depr")    = 1.0  ;
KnowledgeData0(r,"rd0")     = 2.0  ;
KnowledgeData0(r,"gammar")  = 1.0  ;
KnowledgeData0(r,"epsr")    = 0.3  ;


***orig DvdM:
$ontext
table KnowledgeData0(r,*)

           delta    lambda        N     g0      depr       rd0    gammar      epsr
AUS         0.70      0.90       50    2.0       1.0       2.0       1.0       0.3
CHN         0.50      0.80       15    5.0       1.0       2.0       1.0       0.3
JPN         0.70      0.90       50    2.0       1.0       2.0       1.0       0.3
KOR         0.70      0.90       50    2.0       1.0       2.0       1.0       0.3
IDN         0.70      0.90       25    3.0       1.0       2.0       1.0       0.3
IND         0.50      0.80       15    4.0       1.0       2.0       1.0       0.3
CAN         0.70      0.90       50    2.0       1.0       2.0       1.0       0.3
USA         0.70      0.90       50    2.0       1.0       2.0       1.0       0.3
MEX         0.70      0.90       25    3.0       1.0       2.0       1.0       0.3
ARG         0.70      0.90       25    3.0       1.0       2.0       1.0       0.3
BRA         0.70      0.90       25    3.0       1.0       2.0       1.0       0.3
FRA         0.60      0.85       25    2.0       1.0       2.0       1.0       0.3
DEU         0.60      0.85       25    2.0       1.0       2.0       1.0       0.3
ITA         0.60      0.85       25    2.0       1.0       2.0       1.0       0.3
REU         0.60      0.85       25    2.0       1.0       2.0       1.0       0.3
GBR         0.60      0.85       25    2.0       1.0       2.0       1.0       0.3
TUR         0.60      0.85       25    2.0       1.0       2.0       1.0       0.3
RUS         0.40      0.80       15    2.5       1.0       2.0       1.0       0.3
SAU         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
ZAF         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
ROP         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
ODA         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
OAF         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
OEA         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
OLA         0.50      0.80       15    3.0       1.0       2.0       1.0       0.3
;
$offtext
***endHRR

