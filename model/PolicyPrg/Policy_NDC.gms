$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "%PolicyPrgDir%\Policy_NDC.gms"
   purpose     : Policy File for NDC: fixed Caps & endogenous emitax, emiRegTax
   created date: 2023-January-15
   created by  : Jean Chateau
   called by   : "%ModelDir%\Variant.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/Policy_NDC.gms $
   last changed revision: $Rev: 372 $
   last changed date    : $Date: 2023-08-28 17:29:43 +0200 (Mon, 28 Aug 2023) $
   last changed by      : $Author: Chateau_J $

--------------------------------------------------------------------------------
    For being used in save and restart Mode and let possibility of being
    overrided the file could not contains Declaration of var, eq. or macro
--------------------------------------------------------------------------------
$OffText

$SetLocal PolicyStep "%1"

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*       INSTRUCTIONS BEFORE THE TIME-LOOP (after 6-LoadBauForVariant.gms)      *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.StepDeclaration %PolicyStep%=="StepDeclaration"

*   Load default values for Global variables defining carbon policies

    $$include "%PolicyPrgDir%\Global_for_CarbonPolicy.gms"

* overwrite default policy

    $$SetGlobal GhgTax "EmSingle"
    $$SetGlobal SrcTax "EmiSourceAct"

*   Default recycling option: %Recycling% = {"wage","trg","rsg","kappah","vat"}

    $$IF NOT SET Recycling $SetGlobal Recycling "wage"

*   Define set of acting agents

    SET AgentTax(aa) "Sector/Agent facing Carbon Tax" ;
    AgentTax(h)          = YES ; !! Households
    AgentTax(%AgentTax%) = YES ; !! All sectors (Global_for_CarbonPolicy.gms)

*   Define the set of countries doing their NDC: actingReg pour autres pays bof

    SET actingReg(r) "Regions implementing NDC" ;
    actingReg(r) $ NDC2030(r,"GHG_Lulucf") = YES ;

    Display  "Regions implementing NDC (%system.fn%.gms)", actingReg;

*   Assign/change values to parameter/variable specific to Carbon markets

    NDC_Condition(rq,t) = 0 ;

* Use MCP equation for endogenous carbon tax to meet NDC target

    IfMcpCapEq  = 1 ;

* Clear Climate policy

    m_clearFullClimPol(t)

    Scalar RunIn2Step / 1 / ;

*------------------------------------------------------------------------------*
*   Keep exogenous emissions and carbon price from a reference Scenario        *
*------------------------------------------------------------------------------*

* File/Run with reference policy/emission

*    $$SetGlobal RefFile "%oDir%\ICPFwithTrueNDC"

* Load emissions from a reference simulation (emi_ref) [TBU]

    $$IF EXIST "%RefFile%.gdx" IfLoadEmiTgt = 1 ;

    IF(IfLoadEmiTgt,

        OPTION clear=emi_ref;
        $$IF EXIST "%RefFile%.gdx" EXECUTE_LOADDC "%RefFile%.gdx", emiTax_ref=emitax.l, emi_ref=emi.l, p_emissions_ref=p_emissions;

* Keep fixed emissions from reference scenario

        emi.fx(r,CO2,emilulucf,forestrya,tsim)
            = emi_ref(r,CO2,emilulucf,forestrya,tsim) ;
        emiOth.fx(r,CO2,tsim)
            = sum((EmiSourceIna,aa), m_true4b(emi,ref,r,CO2,EmiSourceIna,aa,tsim)) ;

* Keep p_emissions from the reference scenario for acting (like EU ETS)

        $$IfTheni.ReplaceCT %OverCTax%=="ON"
            p_emissions(actingReg,em,EmiFosComb,AgentTax,t)
                = p_emissions_ref(actingReg,em,EmiFosComb,AgentTax,t) ;
        $$EndIf.ReplaceCT
    );

*------------------------------------------------------------------------------*
*                       Set the NDC policy                                     *
*------------------------------------------------------------------------------*

*   Define Active coalition "rq" (ie countries with NDC)

    LOOP(actingReg, rq(ra) $ sameas(actingReg,ra) = YES ; ) ;
    Display "Countries with potential NDC: rq", rq ;

    IF(VarFlag eq 2, rq("EU-ETS") = YES ;  ) ;

    SET SingRQ(ra) "singleton coalitions" ;
	SingRQ(rq) $ (sum(mapr(rq,r),1) eq 1) = YES ;

*   Define the policy

* activate national caps: target on Emitot

    IfCap(rq) = 1 ;

* memo: NDC for Russia & Saudi are met in the baseline

    LOOP(rus,IfCap(rq) $ sameas(rq,rus) = 0 ; ) ;
    LOOP(sau,IfCap(rq) $ sameas(rq,sau) = 0 ; ) ;

* Group EU countries in the same EU-ETS (common cap)

    IF(VarFlag eq 2,
        IfCap("EU-ETS") = 1 ;
        LOOP(r $ mapr("EU-ETS",r), IfCap(rq) $ sameas(r,rq) = 0 ; ) ;
    ) ;

    Display "Active NDC coalitions (IfCap)", IfCap ;

* Define Policy coverage (ie agent/Gas/Source facing carbon price): "part"

    part(actingReg,%GhgTax%,%SrcTax%,AgentTax,t)
        $ ( emi0(actingReg,%GhgTax%,%SrcTax%,AgentTax)
            and between3(t,"%YearPolicyStart%","%YrFinTgt%")) = 1 ;

* Safety instructions --> part = 0 for inactive sources or gas

    m_RedPart(t)

* make carbon tax endogenous

    LOOP(rq $ IfCap(rq),
        emFlag(actingReg,%GhgTax%)
            $ (mapr(rq,actingReg) and emiTot0(actingReg,%GhgTax%)) = 1 ;
    ) ;

*   Build "emiCapFull.fx" from NDC target

* (IfCap, emFlag and part should have been defined)

    IfLoadEmiTgt = 0 ;
    $$include "%PolicyPrgDir%\Build_NDCCaps.gms"

    $$OnDotL
    LOOP(t $ (t.val eq %YearPolicyStart%),
        NDC_Condition(rq,t) $ IfCap(rq)
            = [ sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
                    m_true2(emiTot,r,EmSingle,t))
              - m_true1(emiCapFull,rq,t)] / cScale;
        display "NDC_Condition in %YearPolicyStart%:", NDC_Condition ;
        NDC_Condition(rq,t) $(NDC_Condition(rq,t) le 0) = 0 ;
    ) ;
    $$OffDotL

* reset climate "Flags"

    m_clearClimFlag

$Endif.StepDeclaration

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*  INSTRUCTIONS IN THE TIME-LOOP: between "7-iterloop.gms" and "8-solve.gms"   *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.Iterloop %PolicyStep%=="7-iterloop"
    $$OnDotl
    rwork(r) = 0 ;

    IF(VarFlag and (year ge %YearPolicyStart%),

        IF(NOT RunIn2Step,

            IfMcpCapEq  = 1 ;
            Loop(rq $ NDC_Condition(rq,tsim),
                IfCap(rq) = 1 ;
                rwork_bis(r) $ mapr(rq,r) = IfCap(rq) ;
                IfEmCap(rq,EmSingle) $ IfCap(rq) = 3 ;
            ) ;
            emFlag(r,EmSingle) $ (rwork_bis(r) and emiTot0(r,EmSingle)) = 1 ;

            $$batinclude "%PolicyPrgDir%\InitCapandTrade.gms" "1" "tsim-1"

        ELSE

* Case apply a fixed Tax (then re-run the model see set "8-solve.gms" below)

            IfMcpCapEq   = 0 ;
            rwork_bis(r) = 1.1 ;
            Loop(rq $ NDC_Condition(rq,tsim),
                IfCap(rq) = 1 ;
                rwork(r) $ mapr(rq,r) = IfCap(rq) ;
            ) ;
            display "Check cond 1.", rwork;
            emiTax.fx(r,EmSingle,tsim)
                $ (rwork(r) and emiTot0(r,EmSingle))
                = Max(0.00001,emiTax.l(r,EmSingle,tsim-1)) * rwork_bis(r) ;
        ) ;

        LOOP(CO2, rwork(r) = emiTax.l(r,CO2,tsim) / cScale ; ) ;
        display "CO2 Tax for 1st round", year, rwork ;

        $$include "%PolicyPrgDir%\LULUCF_Scenario.gms"

    ) ;

    $$OffDotl
$Endif.IterLoop

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*           INSTRUCTIONS in "8-solve.gms":  Solve again the model              *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.StepSolve %PolicyStep%=="8-solve"

    m_clearWork


    IF(VarFlag and (year ge %YearPolicyStart%),

        $$OnDotl

* Activate emiCapMCPEQ : ie endogenous carbon tax to meet NDC with MCP

        IfMcpCapEq  = 1 ;
        IfCap(rq) $ emiCapFull0(rq) = 1 ; !! This is the true condition
        rwork(r) = sum(mapr(rq,r), IfCap(rq)) ;
        emFlag(r,EmSingle) $ (rwork(r) and emiTot0(r,EmSingle)) = 1 ;

* Check coalition for which the constraint will be binding
*       emitot > emiCap --> NDC_Condition > 0


        NDC_Condition(rq,tsim) = 0;
        NDC_Condition(rq,tsim) $ IfCap(rq)
            = sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
                m_true2(emiTot,r,EmSingle,tsim))
            - m_true1(emiCapFull,rq,tsim) ;
        NDC_Condition(rq,tsim) $ (NDC_Condition(rq,tsim) le 0) = 0 ;
        rawork(rq) $ NDC_Condition(rq,tsim) = NDC_Condition(rq,tsim) / cScale;
        display "Region with endogenous Carbon Tax to fit NDC (NDC_Condition):",
            year, rawork ;

        $$OffDotl

        IF(RunIn2Step,

            $$OnDotl

* Choose multi-gas case (emiCap0(rq,EmSingle) eq 3) --> emiRegTax(rq,AllGHG)

            IfEmCap(rq,EmSingle)
                $(IfCap(rq) and NDC_Condition(rq,tsim) and emiCap0(rq,EmSingle))
                = 3 ;

* Keep the regional emitax exogenous if the region does not belong
* to any active cap regime

            emFlag(r,EmSingle)
                $ (NOT sum(mapr(rq,r) $ IfEmCap(rq,EmSingle), 1)) = 0 ;
            emFlag(r,EmSingle)   $ (NOT emiTot0(r,EmSingle)) = 0 ;

* Initialize or fix regional (emiTax) and coalition (emiRegTax) Carbon price :

            $$batinclude "%PolicyPrgDir%\InitCapandTrade.gms" "0" "tsim"

* Solve again the model

            $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%

        $$OffDotl
        ) ;

* Condition for next year (bizarrement la 1ere marche pas)

        IF(0,
            $$OnDotl
            NDC_Condition(rq,tsim+1) $ m_true1(emiCapFull,rq,tsim)
            = sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
                m_true2(emiTot,r,EmSingle,tsim))
            - m_true1(emiCapFull,rq,tsim) ;
            NDC_Condition(rq,tsim+1) $ (NDC_Condition(rq,tsim+1) le 0) = 0 ;
            $$OffDotl
        ELSE
            NDC_Condition(rq,tsim+1) = NDC_Condition(rq,tsim) ;
        ) ;

* Reset Flags for next year

        IF(year ne finalYear,
            m_clearClimFlag
            IfMcpCapEq = 0 ;
        ) ;

    ) ;

$Endif.StepSolve

$DropLocal PolicyStep
