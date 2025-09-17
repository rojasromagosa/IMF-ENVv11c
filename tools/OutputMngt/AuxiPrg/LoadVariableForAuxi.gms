$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   Name of the File: "%OutMngtDir%\OutMacroPrg\LoadVariableForAuxi.gms"
   purpose: Load variables and parameters necessary to recalculate
            the outputs of "OutAuxi.gms" with the stand-alone
            "PostProcedure.gms" procedure
   created date : 2021-10-28
   created by   : Jean Chateau
   called by    : "PostProcedure.gms"
--------------------------------------------------------------------------------
$OffText

$include "%OutMngtDir%\OutMacroPrg\LoadVariableForOutMacro.gms"

PARAMETERS
    To%YearBasePPP%PPP(r) "Coefficient to convert unit of the model (e.g. %YearGTAP% USD) into cst %YearBasePPP% PPP"
    To%YearBaseMER%MER(r) "Coefficient to convert unit of the model (e.g. %YearGTAP% USD) into cst %YearBaseMER% MER"
;

*---    Default
To%YearBaseMER%MER(r) = 1;
To%YearBasePPP%PPP(r) = 1;

To%YearBasePPP%PPP(r) $ ypc("cst_usd",r,"%YearBaseMER%")
    = ypc("cur_itl",r,"%YearBaseMER%") / ypc("cst_usd",r,"%YearBaseMER%") ;

To%YearBaseMER%MER(r) $ ypc("cst_usd",r,"%YearBaseMER%")
    = ypc("cur_usd",r,"%YearBaseMER%") / ypc("cst_usd",r,"%YearBaseMER%") ;

*EXECUTE_LOAD rgdpmp, gdpmp, pgdpmp, ypc,
*    wage, pk, kv, ld, wagep,
*    pkp, plandp, pnrfp, pland, land, pnrf, xnrf,
*    amgm, ptmg, pwmg, tmarg, pwm, xtt, wldPm, PI0_xc, PI0_xa,
*    px, pp, ps, xs, p, x, xp, depr,
*    pat, xat, pa, xdt, xa, xw, pe, pdt, pwe,
*    tmat, tland, twage,
*    $$IFI %cal_NRG%=="ON"  Power_Generation_WEM_for_EL,
*    $$IFI %cal_NRG%=="ON"  Supply_WEM_for_EL, agent_Price_WEM_for_EL,
*    $$IFI %cal_AGR%=="ON"  IMPACT%YearGTAP%, IMPACT, IMPACT_World_Prices,
*    LFPR, popWA, scale_popWA, UNR, POP,scale_POP,
*    apb, paTax, gammaex, chiEmi, emir, p_emissions, emi, part, emiTax
*;

*$IFI %cal_NRG%=="ON" Parameter Supply_WEM_for_EL(r,aa,ieaScen,tt), agent_Price_WEM_for_EL(r,i,ieaScen,tt);
*$IFI %cal_AGR%=="ON" Parameter IMPACT%YearGTAP%(impact_var,a,r), IMPACT_World_Prices(IMPACTSim,a,tt), IMPACT(IMPACT_var,IMPACTSim,a,r,tt);
