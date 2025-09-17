$OnText
--------------------------------------------------------------------------------
                    OECD-ENV Model V.1. - Debug procedure
   Name of the File : "%DebugDir%\84-etat_statut.gms"
   purpose          : Fill informations about the simulation (only for the full model)
   created date     : 2021-03-10
   created by       : Jean Chateau
   called by        : "%ModelDir%\8-solve.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/debug/84-etat_statut.gms $
   last changed revision: $Rev: 508 $
   last changed date    : $Date:: 2024-02-06 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$Ifi %MultiRun%=="ON"  $setlocal AffSimName sim
$Ifi %MultiRun%=="OFF" $setlocal AffSimName "'%SimName%'"

etat_statut(%AffSimName%,tsim,"MCP") $(ifMCP eq 1) = YES;
etat_statut(%AffSimName%,tsim,"CNS") $(ifMCP eq 2) = YES;
etat_statut(%AffSimName%,tsim,"solvestat")  = %ModelName%.solvestat;
etat_statut(%AffSimName%,tsim,"modelstat")  = %ModelName%.MODELSTAT;
etat_statut(%AffSimName%,tsim,"infes")      = %ModelName%.numinfes;
etat_statut(%AffSimName%,tsim,"nb_eqs")     = %ModelName%.numequ;
etat_statut(%AffSimName%,tsim,"nb_vars")    = %ModelName%.numvar;
etat_statut(%AffSimName%,tsim,"walras")     = outscale * walras.l(tsim);

$IFi %IfSlicing%=="ON"  etat_statut(%AffSimName%,tsim,"nb_slices") = slices ;

put screen;
$Ifi %MultiRun%=="ON"  put // "-Year: " tsim.tl:4:0 " -Simulation:" sim.tl:0 " -Global Walras: ", (outscale * walras.l(tsim)) / /;
$Ifi %MultiRun%=="OFF" put // "-Year: " tsim.tl:4:0 " -Simulation: %SimName%   -Global Walras: ", (outscale * walras.l(tsim)) / /;

$OnDotl

*   Print some info in screen

$iftheni not "%simtype%" == "COMPSTAT"
IF(ifDyn and (not ifCal),

    MaxStrLen = smax(r, card(r.tl)) + 1;

    IF(year gt %YearAntePolicy%,
        LOOP((r,a,v) $ ifExokv(r,a,v),
            put "ShadowPrice: ", r.tl, a.tl, v.tl, pkpShadowPrice.l(r,a,v,tsim):10:6 / ;
        ) ;
        LOOP( r $ RenewTgt(r,tsim),
            put "ShadowPrice: ", r.tl:<MaxStrLen, FospCShadowPrice.l(r,tsim):10:6 / ;
        ) ;
        LOOP( r $ (chiPtax.l(r,tsim) ne 0),
            put "Adjustment Feed-in-Tarrifs/Feebates: ", r.tl, chiPtax.l(r,tsim):10:6 / ;
        ) ;
        LOOP( (r,em) $ (emiTax.l(r,em,tsim) and CO2(em)),
            put "Carbon Tax: on ", em.tl, " for ", r.tl:<MaxStrLen, (m_convCtax * emitax.l(r,em,tsim)):10:6 / ;
        ) ;
        LOOP((r,a,em) $ emia_IntTgt(r,a,em,tsim),
            put "ShadowPrice on emission intensity: ", r.tl:<MaxStrLen, em.tl, a.tl, emiaShadowPrice.l(r,a,em,tsim):10:6 / ;
        ) ;
        LOOP((r,a) $ xpBar(r,a,tsim),
            put "ShadowPrice/mark-up on xp constraint: ", r.tl:<MaxStrLen, a.tl, pim.l(r,a,tsim):10:6 / ;
        ) ;
***hrr        LOOP(rq $ IfCap(rq), put "IfCap: ", rq.tl:<MaxStrLen, IfCap(rq) / ;) ;
    ) ;

);
$endif

putclose screen;

*   Check Walras Law

check_walras("Walras.l",rres,tsim) = outscale * walras.l(tsim) ;

check_walras("Sum current accounts","World sum",tsim)
    = outscale * pwsav(tsim) * sum(r,savf(r,tsim)) ;

$OffDotl

$batInclude "%DebugDir%\sub-RegionalWalras.gms" "Global Model"

check_walras("Based on I-S market (Global Model)","World sum",tsim)
    = sum(r,check_walras("Based on I-S market (Global Model)",r,tsim)) ;

check_walras("Based External accounts (Global Model)","World sum",tsim)
    = sum(r,check_walras("Based External accounts (Global Model)",r,tsim)) ;

