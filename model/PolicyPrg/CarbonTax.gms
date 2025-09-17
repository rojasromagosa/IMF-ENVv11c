$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy File
   name        : "%PolicyPrgDir%\CarbonTax.gms
   purpose     : Standard carbon Tax experiments
   created date: 24 June 2022
   created by  : Jean Chateau
   called by   : various files
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/CarbonTax.gms $
   last changed revision: $Rev: 347 $
   last changed date    : $Date: 2020-12-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

    Define a serie of Global variables to define:
        - emiTax(%rPol%,%GhgTax%,%AgentTax%,t) = %cTaxLevel% ;
        -   part(%rPol%,%GhgTax%,%SrcTax%,%AgentTax%,t)

    Memo: Carbon instruments:
        - part(r,AllEmissions,EmiSource,aa,t) * emiTax.l(r,AllEmissions,t)
        - p_emissions(r,AllEmissions,EmiSource,aa,t)s

    Effective carbon price faced by agents:
        - EmiUse    : m_Permis(r,i,aa,t), m_Permisd(r,i,aa,t), m_Permism(r,i,aa,t)
        - factor use: m_Permisfp(r,fp,aa,t)
        - Process   : m_Permisact(r,a,t)

$OffText

$SetLocal PolicyStep "%1"

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*       INSTRUCTIONS BEFORE THE TIME-LOOP (after 6-LoadBauForVariant.gms)      *
*    In "Save and Restart mode" these are only Read %StepSavRes%=="Projection" *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.StepDeclaration %PolicyStep%=="StepDeclaration"

* OECD-ENV File for MAC curves analysis

*   Load default values for Global variables defining carbon policies

    $$include "%PolicyPrgDir%\Global_for_CarbonPolicy.gms"

* Default set of acting agent (the global variable AgentTax should be defined)

    SET AgentTax(aa) "Agents facing carbon tax" ;
    AgentTax(%AgentTax%) = YES;

*   Clear Climate policy

    m_clearClimPol(t)

*------------------------------------------------------------------------------*
*       VarFlag 1: Taxation of %GhgTax% from %SrcTax% & AgentTax               *
*           - progressive implementation in 2 or 3 steps                       *
*           - Replace Existing Tax                                             *
*------------------------------------------------------------------------------*

    IF(VarFlag eq 1,

* %cTaxLevel% est le prix suppose en USD de annee %YearUSDCT%
* En multipliant par ConvertCurToModelUSD on convertira en unites de 2014

        stringency(%rPol%,t)
            $ (after(t,"%YearAntePolicy%") and NOT stringency(%rPol%,t))
            = %cTaxLevel% * ConvertCurToModelUSD("%YearUSDCT%");

*---    2 Steps cases [YearPolicyStart-YrPhase1-YrFinTgt]

        $$IfThene.TwoStep %YrPhase2%<%YrPhase1%

* Policy profile step 1: linear implementation %YearPolicyStart% to %YrPhase1"

            $$batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,%GhgTax%" "stringency(%rPol%,'%YrPhase1%')" "%YearPolicyStart%" "%YrPhase1%" "linear"   "replace"

* Policy profile step 2: Constant/Given Tax for %YrPhase1% to "%YrFinTgt%
* Level of the tax for each year > %YrPhase1% should have be pre-defined
* in stringency(%rPol%,t)
* by default %cTaxLevel% * ConvertCurToModelUSD("%YearUSDCT%") (see above)

            $$Ife %YrFinTgt%>%YrPhase1% $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,%GhgTax%" "stringency(%rPol%,t)" "%YrPhase1%" "%YrFinTgt%" "constant" "replace"

*---    3 Steps case

        $$ELSE.TwoStep

* Policy profile step 1: linear implementation %YearPolicyStart% to %YrPhase1"

            $$batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,%GhgTax%" "stringency(%rPol%,'%YrPhase1%')" "%YearPolicyStart%" "%YrPhase1%" "linear" "replace"

* Policy profile step 2: linear implementation %YrPhase1" to %YrPhase2%

            $$batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,%GhgTax%" "stringency(%rPol%,'%YrPhase2%')" "%YrPhase1%" "%YrPhase2%" "linear" "replace"

* Policy profile step 3: Constant/Given Tax for %YrPhase2% to "%YrFinTgt%

            $$batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,%GhgTax%" "stringency(%rPol%,t)" "%YrPhase2%" "%YrFinTgt%" "constant" "replace"

        $$EndIf.TwoStep

* Policy Coverage: for "part" the coverage is either 0 or 1

        $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,%SrcTax%,%AgentTax%" 1 %YearPolicyStart% %YrFinTgt% constant

* progressively replace existing carbon policy (if exist)

        $$IfTheni.ReplaceCT %OverCTax%=="ON"

            p_emissions(%rPol%,%GhgTax%,EmiFosComb,%AgentTax%,t)
                $ (p_emissions(%rPol%,%GhgTax%,EmiFosComb,%AgentTax%,t)
                    and between3(t,"%YearPolicyStart%","%YearEndofSim%"))
                    = Max(p_emissions_bau(%rPol%,%GhgTax%,EmiFosComb,%AgentTax%,t)
                            - emiTax.l(%rPol%,%GhgTax%,t)
                            * part(%rPol%,%GhgTax%,EmiFosComb,%AgentTax%,t)  ,  0 ) ;

        $$EndIf.ReplaceCT

    ) ;

*------------------------------------------------------------------------------*
*       VarFlag 2: Taxation of %GhgTax% from %SrcTax% & AgentTax               *
*           Constant and permanent shock - Replace Existing Tax                *
*------------------------------------------------------------------------------*
* Quid "p_emissions" ?

    IF(VarFlag eq 2,

        stringency(%rPol%,t) $ after(t,"%YearAntePolicy%")
            = %cTaxLevel% * ConvertCurToModelUSD("%YearUSDCT%");
        $$batinclude "%PolicyPrgDir%\policy_profile.gms"  emiTax "%rPol%,%GhgTax%" "stringency(%rPol%,t)" "%YearPolicyStart%" "%YrFinTgt%" "constant" "replace"
        $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part   "%rPol%,%GhgTax%,%SrcTax%,%AgentTax%" 1   %YearPolicyStart%   %YrFinTgt%   constant

    );

* Safety instructions

    m_RedPart(t)

*---    Check pre-determined policy & targets (debug)

    $$Ifi %IfDebug%=="ON" $BatInclude "%DebugDir%\Check_PredeterminedPolicy" "CarbonPolicy_BeforeTimeLoop"

*------------------------------------------------------------------------------*
*           Exple: CH4 Tax on Agriculture (not combustion)                     *
*    progressive implementation - 2 steps - Replace Existing Tax               *
*------------------------------------------------------------------------------*
$$OnText
* %GhgTax%   = "CH4"
* %AgentTax% = "agr"

IF(VarFlag eq [PUT NUMBER],
    stringency(r,t) $ after(t,"%YearAntePolicy%")
        = %cTaxLevel% * ConvertCurToModelUSD("%YearUSDCT%");
    $$batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,'%GhgTax%'" "stringency(%rPol%,t)" "%YearPolicyStart%" "%YrPhase1%" "linear" "replace"
    $$Ife %YrFinTgt%>%YrPhase1% $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,'%GhgTax%'" "stringency(%rPol%,"%YrPhase1%")" "%YrPhase1%" "%YrFinTgt%" "constant" "replace"
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,'%GhgTax%',EmiFp,%AgentTax%"   1 %YearPolicyStart% %YrFinTgt% constant
    part(r,em,EmiFp,aga,t) $ between(t,%YearPolicyStart%,%YrFinTgt%) = 1;

    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,'%GhgTax%',chemUse,%AgentTax%" 1 %YearPolicyStart% %YrFinTgt% constant
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,'%GhgTax%',emiact,%AgentTax%"  1 %YearPolicyStart% %YrFinTgt% constant
);
$OffText

*------------------------------------------------------------------------------*
*    Exple for a comparison with GIMF: Tax on CO2 from fossil fuel Combustion  *
*      progressive implementation - Replace exis. Tax - Partial Coverage       *
*------------------------------------------------------------------------------*
$$OnText

IF(VarFlag eq [PUT NUMBER],
    stringency(r,t) = %cTaxLevel% * ConvertCurToModelUSD("%YearUSDCT%");

    $$batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,CO2" "stringency(%rPol%,t)" "%YearPolicyStart%" "%YrPhase1%" "linear" "replace"
    $$Ife %YrFinTgt%>%YrPhase1% $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "%rPol%,CO2" "stringency(%rPol%,t)" "%YrPhase1%" "%YrFinTgt%" "constant" "replace"

    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,'coalcomb',elya"  1 %YearPolicyStart% %YrFinTgt% constant
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,'gascomb',elya"   1 %YearPolicyStart% %YrFinTgt% constant
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,'gdtcomb',elya"   1 %YearPolicyStart% %YrFinTgt% constant
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,'roilcomb',elya"  1 %YearPolicyStart% %YrFinTgt% constant
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,'roilcomb',srv"   1 %YearPolicyStart% %YrFinTgt% constant
    $$batinclude "%PolicyPrgDir%\policy_coverage.gms" part "%rPol%,%GhgTax%,'roilcomb','hhd'" 1 %YearPolicyStart% %YrFinTgt% constant
);
$OffText

*	Activate BCA (option)

    $$Ifi %BCA_policy%=="ON" $batinclude "%PolicyPrgDir%\BCA.gms" "DeclareBCA"

$Endif.StepDeclaration

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*  INSTRUCTIONS IN THE TIME-LOOP: between "7-iterloop.gms" and "8-solve.gms"   *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.Iterloop %PolicyStep%=="7-iterloop"

*   Cut carbon policy in part and other numerical tricks

$Endif.IterLoop

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*  INSTRUCTIONS in "8-solve.gms":  Solve again the model                       *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.StepSolve %PolicyStep%=="8-solve"

* Load BCA policy and re-run model [Option]

    $$IFi %BCA_policy%=="ON" $batinclude "%PolicyPrgDir%\BCA.gms" "%PolicyStep%"

    IF(VarFlag,
        $$IF EXIST "Ajustements.txt" $batinclude "Ajustements.txt"
    ) ;

$Endif.StepSolve

$DropLocal PolicyStep
