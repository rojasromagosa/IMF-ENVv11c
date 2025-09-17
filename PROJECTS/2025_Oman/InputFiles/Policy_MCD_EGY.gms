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
$oneolcom
$SetLocal PolicyStep "%1"

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*       INSTRUCTIONS BEFORE THE TIME-LOOP (after 6-LoadBauForVariant.gms)      *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.StepDeclaration %PolicyStep%=="StepDeclaration"

*************************************************************************************************************************

$SetGlobal YearPolicyStart  "2024"
*$ifi %TimeFlag%=="ON"   $SetGlobal YearPolicyStart  "2030"
$SetGlobal YrFinTgt         "2040"

****************************************************************************************************************
* 1.global Define values for Global variables defining carbon policies

***beginning of endog CTAX code
*$ontext
*$iftheni.ndc %SimGroup%=="NDC"

*************************************************************************************************************
***Code in Global_for_CarbonPolicy.gms
*   1.) Selected region subject to the carbon Tax
* rPol = {r, OECD, ...}
$SetGlobal rPol       "r"

*   2.)  Default selected type of Gas subject to the carbon Tax
* GhgTax = {em,EmSingle,oap,emn,HighGWP,CH4N2O,CO2,'CH4',..}
$SetGlobal GhgTax "emSingle"

*   3.)  Selected source of emission subject to the carbon Tax
* SrcTax = {EmiSource,EmiUse,EmiFp,EmiComb,EmiFosComb,chemUse,emiact,EmiSourceAct,'coalcomb',emimainSource,..}
$SetGlobal SrcTax "EmiSourceAct"

*   4.)  Carbon tax level
***HRR do we need this? Used in 11-Postsim.gms
$SetGlobal cTaxLevel  "0"

*   5.)  Selected sector covered by the carbon Tax --> this will define a set
* AgentTax = {a,aa,'i_s',fd, EITEa, ...}
$SetGlobal AgentTax   "a"
*   Define set of acting agents
    SET AgentTax(aa) "Sector/Agent facing Carbon Tax" ;
    AgentTax(h)          = YES ; !! Households
    AgentTax(%AgentTax%) = YES ; !! All sectors 

* 6.)  Activate Bordar Carbon Adjustmetn (BCA) or CBAM policy
$SetGlobal BCA_policy "OFF"

* 7.)  Replace Existing (baseline) carbon pricing
$SetGlobal OverCTax   "ON"

* 8.)  Default remarkable years
*   - %YrPhase1%        : year with intermediate targets for tax or caps
*   - %YrPhase2%        : year with a second intermediate target
*   - %YrFinTgt%        : year with Final Targets
$SetGlobal YrPhase1   "2030"
$SetGlobal YrPhase2   "2030"
$SetGlobal YrFinTgt   "2040"


***end Code in Global_for_CarbonPolicy
*************************************************************************************************************

*  9.) Recycling option: %Recycling% = {"wage","trg","rsg","kappah","vat"}
$SetGlobal Recycling "wage"

*************************************************************************************************************************
* 2.  Use exogenous total emission targets from a reference sources (e.g., new NGFS,2024)
    
Parameter  
EmiTotTgt(r,tt)             "Total GHG Emission targets" 
;

EmiTotTgt(r,tt) = 0 ;
$ifi %simGroup%=="NDC"  EmiTotTgt(r,"%YrFinTgt%") $ EmiTotCal(r,"NDCs","%YrFinTgt%") = EmiTotCal(r,"NDCs","%YrFinTgt%") ;
$ifi %simGroup%=="DelayTran" EmiTotTgt(r,"%YrFinTgt%") $ EmiTotCal(r,"DelayTran","%YrFinTgt%") = EmiTotCal(r,"DelayTran","%YrFinTgt%") ;
$ifi %simGroup%=="NetZero"  EmiTotTgt(r,"%YrFinTgt%") $ EmiTotCal(r,"NetZero2050","%YrFinTgt%") = EmiTotCal(r,"NetZero2050","%YrFinTgt%") ;

********************************************************************************************************
* 3. Define acting regions
    SET actingReg(r) "Regions implementing emission targets" ;
    actingReg(r) $ EmiTotTgt(r,"%YrFinTgt%") = YES ;

*****
$ifi not %SimName%=="SimKAZ_NDC3"   actingReg(r) $ KAZ(r) = NO ;
***EGY NDC target is already reached with FFS and REtgt
    actingReg(r) $ EGY(r) = NO ;
    actingReg(r) $ MAR(r) = NO ;
    actingReg(r) $ AFR(r) = NO ;
    
    actingReg(r) $ OMN(r) = NO ;


$iftheni.dtadj  %SimGroup%=="DelayTran"
    actingReg(r) $ (allMCD(r) ) = NO ; !! or IND(r) or REU(r)
    EmiTotTgt(r,"%YrFinTgt%") $ (WHD(r)) = EmiTotCal(r,"DelayTran","%YrFinTgt%") + 750 ;
$endif.dtadj

$iftheni.nzadj  %SimGroup%=="NetZero"
    actingReg(r) $ (allMCD(r) or IND(r) or REU(r) or WHD(r)) = NO ;
    EmiTotTgt(r,"%YrFinTgt%")$ ( WHD(r) or APD(r)) = EmiTotCal(r,"NetZero2050","%YrFinTgt%") + 1250 ; !!750 until 2035
$endif.nzadj

*****************************************************************************

*   Assign/change values to parameter/variable specific to Carbon markets
    Tgt_Condition(rq,t) = 0 ;

* Use MCP equation for endogenous carbon tax to meet emission target
    IfMcpCapEq  = 1 ;

* Clear Climate policy
    m_clearFullClimPol(t)


**********************************************************************************************************
* 4. Applying an endogenous carbon tax to reach total emission targets

* 4.a  Define Active coalition "rq" (ie countries with emission targets)
    LOOP(actingReg, rq(ra) $ sameas(actingReg,ra) = YES ; ) ;

    SET SingRQ(ra) "singleton coalitions" ;
        SingRQ(rq) $ (sum(mapr(rq,r),1) eq 1) = YES ;

* 4.b  Define the policy
* activate national caps: target on Emitot
    IfCap(rq) = 1 ;

* 4.c. Define Policy coverage (ie agent/Gas/Source facing carbon price): "part"
    part(actingReg,%GhgTax%,%SrcTax%,AgentTax,t)
        $ ( emi0(actingReg,%GhgTax%,%SrcTax%,AgentTax)
            and between3(t,"%YearPolicyStart%","%YrFinTgt%")) = 1 ;

* Safety instructions --> part = 0 for inactive sources or gas
    m_RedPart(t)

* EmFlag when carbon tax endogenous
    LOOP(rq $ IfCap(rq),
        emFlag(actingReg,%GhgTax%)
            $ (mapr(rq,actingReg) and emiTot0(actingReg,%GhgTax%)) = 1 ;
    ) ;

* 4.d Define the emission caps and the Trg_condition

*************************************************************************
***Code from Build_NDCCaps.gms
$OnDotL
* convert condition IfCap(rq) to condition on regions for singleton coalition
* --> sum(mapr(rq,r), IfCap(rq))
EmiRCap(r,EmSingle,"%YearAntePolicy%") $ emFlag(r,EmSingle)
    = { m_true2b(emiTot,bau,r,EmSingle,"%YearAntePolicy%")
      } $ { sum(mapr(rq,r), IfCap(rq)) eq 1 }
    + { sum((EmiSourceAct,aa),
        m_EffEmiRef(r,bau,EmSingle,EmiSourceAct,aa,"%YearPolicyStart%"))
      } $ { sum(mapr(rq,r), IfCap(rq)) eq 2 }
    ;

* Single gas cap
emiCap0(rq,EmSingle) $ IfCap(rq)
    = sum(mapr(rq,r) $ emFlag(r,EmSingle),
        EmiRCap(r,EmSingle,"%YearAntePolicy%")) ;

* Multi-gas cap
emiCapFull0(rq) $ IfCap(rq) = sum(EmSingle, emiCap0(rq,EmSingle)) ;

* Build the rq-coalition cap : emiCapFull.fx
    rawork(rq) = 0 ;
    LOOP(rq $ IfCap(rq),
        emiCapFull.fx(rq,"%YearAntePolicy%") = emiCapFull0(rq) ;

* Define emitot target for %YrFinTgt% 
        emiCapFull.fx(rq,"%YrFinTgt%") $ IfCap(rq)
            = sum(mapr(rq,r), EmiTotTgt(r,"%YrFinTgt%")) * cScale ;

* Linear interpolation from %YearPolicyStart" to %YrFinTgt%
        m_InterpLinear(emiCapFull.l,'rq',tsim,%YearAntePolicy%,%YrFinTgt%)

* Annual reduction after %YrFinTgt%
        rawork(rq) $ IfCap(rq)
            = [   emiCapFull.l(rq,"%YrFinTgt%")
                / emiCapFull.l(rq,"%YearPolicyStart%")
              ]**[1 / (%YrFinTgt% - %YearPolicyStart%)] -1 ;

        LOOP( t $ between2(t,"%YrFinTgt%","%YearEndofSim%"),
            emiCapFull.l(rq,t) $ rawork(rq)
                = emiCapFull.l(rq,t-1) * ( 1 + rawork(rq) ) ;
        ) ;
    ) ;

* clear intermediate values
emiCapFull.fx(rq,"%YearAntePolicy%")   = 0 ;
EmiRCap(r,EmSingle,"%YearAntePolicy%") = 0 ;

* Normalization and Fix Target
    emiCapFull.fx(rq,t) $ IfCap(rq) = emiCapFull.l(rq,t) / emiCapFull0(rq) ;
    emiCapFull.fx(rq,t) $ (NOT IfCap(rq)) =  0 ;
***endCode from Build_NDCCaps.gms
******************************************************************************

* Define the target condition (to activate endog. carbon tax)
    LOOP(t $ (t.val ge %YearPolicyStart%),
        Tgt_Condition(rq,t) $ IfCap(rq)
            = [ sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
                    m_true2(emiTot,r,EmSingle,t))
              - m_true1(emiCapFull,rq,t)] / cScale;
        Tgt_Condition(rq,t) $(Tgt_Condition(rq,t) le 0) = 0 ;
    ) ;
    $$OffDotL

* reset climate "Flags": m_clearClimFlag ==> IfCap(rq) = 0 ; emFlag(r,AllEmissions) = 0 ; IfEmCap(rq,AllEmissions) = 0 ; \
   m_clearClimFlag

*$$endif.ndc
***end of endog CTAX code

****************************************************************************************************************
* Settings for carbon tax in EGY only! 
$$iftheni.ndcEgy %SimName%=="SimNDC"
    AgentTax(aa)            = NO ; 
    AgentTax(h)             = YES ; !! Households
    AgentTax(elya)          = YES ; !! electricity generation
    AgentTax(transporta)    = YES ; !! transport    
    AgentTax(mina)          = YES ; !! Gas and oli activities
    

* 4.c. Define Policy coverage (ie agent/Gas/Source facing carbon price): "part"
    part(r,AllEmissions,EmiSource,aa,t)  $ EGY(r) = 0 ;
    part("EGY",emSingle,EmiSourceAct,AgentTax,t) $ (emi0("EGY",emSingle,EmiSourceAct,AgentTax) and between3(t,"%YearPolicyStart%","%YrFinTgt%")) = 1 ;
    part("EGY","CH4",EmiSourceAct,aa,t) $ (emi0("EGY","CH4",EmiSourceAct,aa)and between3(t,"%YearPolicyStart%","%YrFinTgt%")) = 1 ;
$$endif.ndcEGY


*******************************************************************************************************************
* CBAM
if(VarFlag ge 41, 
    $$SetGlobal BCA_policy "ON"
);
$$iftheni.cbam %BCA_policy%=="ON"

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


$SetGlobal BCA_type             "TARIFFS"
$SetGlobal BCA_sources          "CO2"
$SetGlobal BCA_EmiCoverage      "INDIRECT"
$SetGlobal BCA_CarbonContent    "Exporter"
$SetGlobal BCA_Good             "cbami"
$SetGlobal NbCoalition          "1"  

    $$Ifi %BCA_policy%=="ON" $batinclude "%PolicyPrgDir%\BCA.gms" "DeclareBCA"

**HRR: redifine these flags (later: change code in BCA.gms to do this properly)
where_export(r,rp,i) = 0;
where_tariff(r,rp,i) = 0 ; 

where_export(r,rp,i) $ (EGY(r) and EUR(rp)) = 1 ;
where_tariff(r,rp,i) $ (EGY(r) and EUR(rp)) = 1 ;
$$ifi not %SimName%=="SimCBAM2" BCAFlag(r,%BCA_Good%) $ EGY(r) = 1 ;

*where_export(r,rp,i) $ (EUR(rp)) = 1 ;
*where_tariff(r,rp,i) $ (EUR(r)) = 1 ;
*BCAFlag(r,%BCA_Good%)  = 1 ;

***HRR we use EGY share for all MCD countries! EGY Shares estimated using cbamCal_hrr.gms
cbamSh(r,i,rp) = 1;
cbamSh(r,"eim-c",rp) $ (EGY(r) and EUR(rp)) = 0.477 ;
*cbamSh(r,"oma-c",rp) $ (EGY(r) and EUR(rp)) = 0.1682 ;
cbamSh(r,"oma-c",rp) $ (EGY(r) and EUR(rp)) = 0 ;
cbamSh(r,"ely-c",rp) $ (EGY(r) and EUR(rp)) = 0.7236 ;

*cbamSh(r,"eim-c",rp) $ ( EUR(rp)) = 0.477 ;
*cbamSh(r,"oma-c",rp) $ ( EUR(rp)) = 0.1682 ;
*cbamSh(r,"ely-c",rp) $ ( EUR(rp)) = 0.7236 ;

$$endif.cbam

**********************************************************************************************
*** Include NGFS values for LULUCF, EV and CCUS
$$iftheni.netzero %SimGroup%=="NetZero"
    $$batinclude "%iFilesDir%\NGFS_forMCDagg.gms" 
$$endif.netzero
**********************************************************************************************

$Endif.StepDeclaration

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*  INSTRUCTIONS IN THE TIME-LOOP: between "7-iterloop.gms" and "8-solve.gms"   *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*


$IfTheni.Iterloop %PolicyStep%=="7-iterloop"
    $$OnDotl


*******************************************************************************************************************

*** setting the FFS to zero to check the impact on ygov

$iftheni.tgt0 not %SimName%=="SimREtgt0" 
if((VarFlag ge 1) and (VarFlag le 40), 

** Elimination of FFS between 2024 and 2030
    if((year ge 2024) and (year le 2030), 
       paTax.fx("EGY","gas-c",aa,tsim) $ paTax.l("EGY","gas-c",aa,tsim)    
            = paTax.l("EGY","gas-c",aa,"2023") - (year - 2024) * (paTax.l("EGY","gas-c",aa,"2023")/6) ;
       paTax.fx("EGY","p_c-c",aa,tsim) $ paTax.l("EGY","p_c-c",aa,tsim)         
            = paTax.l("EGY","p_c-c",aa,"2023") - (year - 2024) * (paTax.l("EGY","p_c-c",aa,"2023")/6) ;
       paTax.fx("EGY","ely-c",aa,tsim) $ (paTax.l("EGY","ely-c",aa,tsim) lt 0 ) 
            = paTax.l("EGY","ely-c",aa,"2023") - (year - 2024) * (paTax.l("EGY","ely-c",aa,"2023")/6) ;
    );

    if(year ge 2031, 
       paTax.fx("EGY","gas-c",aa,tsim) $ paTax.l("EGY","gas-c",aa,tsim) = 0 ;
       paTax.fx("EGY","p_c-c",aa,tsim) $ paTax.l("EGY","p_c-c",aa,tsim) = 0 ;
       paTax.fx("EGY","ely-c",aa,tsim) $ (paTax.l("EGY","ely-c",aa,tsim) lt 0 )= 0 ; 
    );

** Elimination of FFS between 2025 and 2030 for OMN
    if((year ge 2025) and (year le 2030), 
       paTax.fx("OMN","p_c-c",aa,tsim) $ paTax.l("OMN","p_c-c",aa,tsim)
            = paTax.l("OMN","p_c-c",aa,"2024") - (year - 2024) * (paTax.l("OMN","p_c-c",aa,"2024")/6) ;
       paTax.fx("OMN","ely-c","hhd",tsim)  = paTax.l("OMN","ely-c","hhd","2024") - (year - 2024) * (paTax.l("OMN","ely-c","hhd","2024")/6) ;
    );

    if(year ge 2031, 
       paTax.fx("OMN","p_c-c",aa,tsim) $ (paTax.l("OMN","p_c-c",aa,tsim) lt 0 ) = 0 ;
       paTax.fx("OMN","ely-c",aa,tsim) $ (paTax.l("OMN","ely-c",aa,tsim) lt 0 ) = 0 ; 
    );


) ;

if(VarFlag eq 1, GovBalance(r) $ (EGY(r))= 1 ; ); !! makes rsg increase (not revenue neutral)


if((VarFlag eq 2) or (VarFlag eq 6) or (VarFlag eq 7) or (VarFlag eq 8) or (VarFlag eq 33),

    GovBalance(r) $ (EGY(r))= 2 ;  !! changes trg (HH transfers increase to make shock revenue neutral) 
);

if(VarFlag eq 3, GovBalance(r) $ (EGY(r)) = 0 ; ); !! changes kappah (income tax decrease to make shock revenue neutral) 

if(((VarFlag eq 4) or (VarFlag ge 11)) and  (VarFlag le 31), !! 
   
* Makes 50% of revenue increase go to transfers and the rest to rsg
    
    GovBalance(r) $ (EGY(r)) = 1 ;  !! makes rsg increase (not revenue neutral)
** Assign 50% of revenue increase to transfers 
        execute_load "%BauFile%.gdx", ygov_bau=ygov.l ;
***Needs to run SimFFSup1 before !        
        execute_load "%oDir%\SimFFSup1.gdx", ygov_sim=ygov.l
    if((year ge 2024),

        trg.fx(r,tsim) $ EGY(r) = 0.5 * ygov0(r,"itax") * (ygov_sim(r,"itax",tsim) - ygov_bau(r,"itax",tsim)) ;

        trg.fx(r,tsim) $ EGY(r) = trg.l(r,tsim) + (ygov0(r,"ctax") * (ygov.l(r,"ctax",tsim-1) - ygov_bau(r,"ctax",tsim-1))) ;        
    );
);

$endif.tgt0


*******************************************************************************************************************
*** REtgt: Renewable target policies

***HRR: before *_HH     if(((Varflag ge 10)) and (VarFlag le 40), 
if(((Varflag ge 6)) and (VarFlag le 40), 
* using SimFFSup4 

    IfCalMacro(r,"power mix")   = 0  ;
    IfCalMacro(r,"power mix")$sum(elya,ElyMixCal(r,elya,"NDCs",tsim)) = 1  ;

    IfCalMacro(r,"power mix") $ KAZ(r)  = 0  ;

    if(year ge 2024, 

*** Estimation of model over-investment in Ely generation estimated using new kv in elya vs. capex from WB CCDR
*** increasing K productivity in elya
*this is endog. determined so not working    lambdak(r,elya,"new",tsim) $ (EGY(r) and lambdak(r,elya,"new",tsim) ) = lambdak(r,elya,"new",tsim) * (1 + 0.25) ; 
        tfp_fp.fx(r,elya,tsim) $ ( EGY(r) and xpFlag(r,elya) )= 1 + 0.5 ; 

*** for SimREtgt2: 50% of ely_inv (which is 0.6% of GDP) is financed externally
        if(VarFlag eq 12 or (VarFlag eq 7), 
            savf.fx(r,tsim) $ EGY(r) = savf_bau(r,tsim) + (rgdpmp_bau(r,tsim) * 0.006 * 0.5); 
            savf.fx(r,tsim) $ EUR(r) = savf_bau(r,tsim) - 0.75 * (rgdpmp_bau("EGY",tsim) * 0.006 * 0.5);   
            savf.fx(r,tsim) $ USA(r) = savf_bau(r,tsim) - 0.25 * (rgdpmp_bau("EGY",tsim) * 0.006 * 0.5); 
        );
*** for SimREtgt3: 70% of ely_inv (which is 0.8% of GDP) is financed externally
        if(VarFlag ge 13 or (VarFlag eq 8), 
            savf.fx(r,tsim) $ EGY(r) = savf_bau(r,tsim) + (rgdpmp_bau(r,tsim) * 0.006 * 0.7); 
            savf.fx(r,tsim) $ EUR(r) = savf_bau(r,tsim) - 0.75 * (rgdpmp_bau("EGY",tsim) * 0.006 * 0.7);   
            savf.fx(r,tsim) $ USA(r) = savf_bau(r,tsim) - 0.25 * (rgdpmp_bau("EGY",tsim) * 0.006 * 0.7); 
         
        );

        IF(IfPowerVol,
            LOOP( r $ (IfCalMacro(r,"power mix") eq 1),
                sigmapow(r,elyi)   = 0.01 ;
                sigmapb(r,pb,elyi) = 0.01 ;
            x.l(r,powa,elyi,tsim) $ x0(r,powa,elyi,tsim)
                = ElyMixCal(r,powa,"NDCs",tsim)
                / x0(r,powa,elyi,tsim) ;

            xpb.l(r,pb,elyi,tsim) $ xpb0(r,pb,elyi,tsim)
                = sum(powa $ mappow(pb,powa), m_true3t(x,r,powa,elyi,tsim))
                / xpb0(r,pb,elyi,tsim) ;
            xpow.l(r,elyi,tsim)   $ xpow0(r,elyi,tsim)
                = sum(pb, m_true3t(xpb,r,pb,elyi,tsim)) / xpow0(r,elyi,tsim) ;
            apb(r,pb,elyi,tsim) $ (xpb0(r,pb,elyi,tsim) and NOT IfElyCES)
                = [m_true3t(xpb,r,pb,elyi,tsim) / m_true2t(xpow,r,elyi,tsim)]
                * [m_true3(ppb,r,pb,elyi,tsim) * lambdapow(r,pb,elyi,tsim)
                    / m_true2(ppowndx,r,elyi,tsim)]**sigmapow(r,elyi) ;
            apb(r,pb,elyi,tsim) $ (xpb0(r,pb,elyi,tsim) and IfElyCES)
                = [m_true3t(xpb,r,pb,elyi,tsim) / m_true2t(xpow,r,elyi,tsim)]
                * [m_true3(ppb,r,pb,elyi,tsim) / m_true2(ppow,r,elyi,tsim)]**sigmapow(r,elyi)
                * [lambdapow(r,pb,elyi,tsim)**(1-sigmapow(r,elyi))]  ;
            as(r,powa,elyi,tsim)
                $ (sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim)) and NOT IfElyCES)
                = [m_true3t(x,r,powa,elyi,tsim) / sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim))]
                * sum(mappow(pb,powa),
                    (m_true3(p,r,powa,elyi,tsim) * lambdapb(r,powa,elyi,tsim)
                    / m_true3(ppbndx,r,pb,elyi,tsim))**sigmapb(r,pb,elyi) )  ;
            as(r,powa,elyi,tsim)
                $ (sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim)) and IfElyCES)
                = [m_true3t(x,r,powa,elyi,tsim) / sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim))]
                * sum(mappow(pb,powa),
                    lambdapb(r,powa,elyi,tsim)**(1-sigmapb(r,pb,elyi))
                  * (m_true3(p,r,powa,elyi,tsim) / m_true3(ppb,r,pb,elyi,tsim))**sigmapb(r,pb,elyi) )  ;
            );
        );
    );
) ;

*******************************************************************************************************************
*******************************************************************************************************************
*** NDC ROW: RoW reaches NDC targets through overall CTAX

if((VarFlag ge 31), 

************************************************************************************************************
*** Endog. CTAX code until 2040
    if(year le %YrFinTgt%, 
        IfMcpCapEq  = 1 ;
        IfCap(rq) $ emiCapFull0(rq) = 1 ; !! This is the true condition
        rwork(r) = sum(mapr(rq,r), IfCap(rq)) ;
        emFlag(r,EmSingle) $ (rwork(r) and emiTot0(r,EmSingle)) = 1 ;
* Choose multi-gas case (emiCap0(rq,EmSingle) eq 3) --> emiRegTax(rq,AllGHG)
        IfEmCap(rq,EmSingle) $(IfCap(rq) and Tgt_Condition(rq,tsim) and emiCap0(rq,EmSingle)) 
                    = 3 ;
* Keep the regional emitax exogenous if the region does not belong to any active cap regime
        emFlag(r,EmSingle) $ (NOT sum(mapr(rq,r) $ IfEmCap(rq,EmSingle), 1)) = 0 ;
        emFlag(r,EmSingle) $ (NOT emiTot0(r,EmSingle)) = 0 ;

* Initialize or fix regional (emiTax) and coalition (emiRegTax) Carbon price :
        if(year eq %YearPolicyStart%, 
                    $$batinclude "%PolicyPrgDir%\InitCapandTrade.gms" "1" "tsim-1" 
        );
        if(year gt %YearPolicyStart%, 
                    $$batinclude "%PolicyPrgDir%\InitCapandTrade.gms" "1" "tsim"  
        );
        LOOP(CO2, rwork(r) = emiTax.l(r,CO2,tsim) / cScale ; ) ;
    );
);

********************************************************************************************************************


$Endif.IterLoop

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*           INSTRUCTIONS in "8-solve.gms":  Solve again the model              *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.StepSolve %PolicyStep%=="8-solve"

*******************************************************************************************************************
* CBAM
if( (VarFlag ge 41), 

    $$IFi %BCA_policy%=="ON" $batinclude "%PolicyPrgDir%\BCA.gms" "8-solve"
);



$Endif.StepSolve

$DropLocal PolicyStep
