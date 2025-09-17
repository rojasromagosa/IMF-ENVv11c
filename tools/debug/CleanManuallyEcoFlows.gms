$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model - V.1 - Debug Procedure
   Name of the File: "%DebugDir%\CleanEcoFlows.gms"
   purpose         : Manual cleanning of small sectors or demands between two years
   created date    : 2021-03-17
   created by      : Jean Chateau
   called by       : Any Variant.gms if called
[TBC]: la partie demande a l'air fausse
--------------------------------------------------------------------------------
Flags:
    %1: Region
    %2: variable ={xa,xp}
    %3: sector
    %4: commodity
$OffText

$setargs r VarToClean a i

*------------------------------------------------------------------------------*
*                   Cleaning Sectoral productio process                        *
*------------------------------------------------------------------------------*

$IfThenI.xp %VarToClean% =="xp"

    xpFlag(%r%,%a%)    = 0;

    xp.fx(%r%,%a%,tsim)     = 0;
    va.fx(%r%,%a%,v,tsim)   = 0;
    xpv.fx(%r%,%a%,v,tsim)  = 0;
    pxv.fx(%r%,%a%,v,tsim)  = 0;
    px.fx(%r%,%a%,tsim)     = 0; uc.fx(%r%,%a%,v,tsim)   = 0;
    xpx.fx(%r%,%a%,v,tsim)  = 0;
    pxp.fx(%r%,%a%,v,tsim)  = 0;
    xghg.fx(%r%,%a%,v,tsim) = 0; ghgFlag(%r%,%a%)   = 0;
    nd1.fx(%r%,%a%,tsim)    = 0; nd1Flag(%r%,%a%)   = 0;
    nd2.fx(%r%,%a%,tsim)    = 0; nd2Flag(%r%,%a%)   = 0;

    va1.fx(%r%,%a%,v,tsim)  = 0; va1Flag(%r%,%a%)   = 0;
    va2.fx(%r%,%a%,v,tsim)  = 0; va2Flag(%r%,%a%)   = 0;
    lab1.fx(%r%,%a%,tsim)   = 0; lab1Flag(%r%,%a%)  = 0;
    kef.fx(%r%,%a%,v,tsim)  = 0; kefFlag(%r%,%a%)   = 0;
    kf.fx(%r%,%a%,v,tsim)   = 0; kfFlag(%r%,%a%)    = 0;
    ksw.fx(%r%,%a%,v,tsim)  = 0; kFlag(%r%,%a%)     = 0;
    ks.fx(%r%,%a%,v,tsim)   = 0;
    lab2.fx(%r%,%a%,tsim)   = 0; lab2Flag(%r%,%a%)  = 0;
    xnrg.fx(%r%,%a%,v,tsim) = 0; xnrgFlag(%r%,%a%)  = 0;

    pnd1.fx(%r%,%a%,tsim)   = 0;
    pnd2.fx(%r%,%a%,tsim)   = 0;
    pva.fx(%r%,%a%,v,tsim)  = 0;
    pva1.fx(%r%,%a%,v,tsim) = 0;
    pva2.fx(%r%,%a%,v,tsim) = 0;
    plab1.fx(%r%,%a%,tsim)  = 0;
    pkef.fx(%r%,%a%,v,tsim) = 0;
    pkf.fx(%r%,%a%,v,tsim)  = 0;
    pksw.fx(%r%,%a%,v,tsim) = 0;
    pks.fx(%r%,%a%,v,tsim)  = 0;
    plab2.fx(%r%,%a%,tsim)  = 0;
    pnrg.fx(%r%,%a%,v,tsim) = 0;

*---    primary factor markets
    land.fx(%r%,%a%,tsim)   = 0; LandFlag(%r%,%a%)  = 0;
    xnrf.fx(%r%,%a%,tsim)   = 0; nrfFlag(%r%,%a%)   = 0;
    xwat.fx(%r%,%a%,tsim)   = 0; watFlag(%r%,%a%)   = 0;
    h2o.fx(%r%,%a%,tsim)    = 0; xwatfFlag(%r%,%a%) = 0;
    kv.fx(%r%,%a%,v,tsim)   = 0; kFlag(%r%,%a%)     = 0;
    ld.fx(%r%,l,%a%,tsim)   = 0; labFlag(%r%,l,%a%) = 0;

    rrat.fx(%r%,%a%,tsim)   = 0;
    kxRat.fx(%r%,%a%,vOld,tsim)= 0;
    wage.fx(%r%,l,%a%,tsim) = 0;
    pland.fx(%r%,%a%,tsim)  = 0;
    pnrf.fx(%r%,%a%,tsim)   = 0;
    pwat.fx(%r%,%a%,tsim)   = 0;
    ph2o.fx(%r%,%a%,tsim)   = 0;
    pk.fx(%r%,%a%,v,tsim)   = 0;

    lambdal.fx(%r%,l,%a%,tsim) = 0;
    TFP_xpx.fx(%r%,%a%,v,tsim) = 0;

    xa.fx(%r%,i,%a%,tsim) = 0;  xaFlag(%r%,i,%a%) = 0;

    xaNRG.fx(%r%,%a%,NRG,v,tsim)$ IfNrgNest(%r%,%a%) = 0;
    xaNRGFlag(%r%,%a%,NRG)      $ IfNrgNest(%r%,%a%) = 0;
    xnely.fx(%r%,%a%,v,tsim)    $ IfNrgNest(%r%,%a%) = 0;
    xnelyFlag(%r%,%a%)          $ IfNrgNest(%r%,%a%) = 0;
    xolg.fx(%r%,%a%,v,tsim)     $ IfNrgNest(%r%,%a%) = 0;
    xolgFlag(%r%,%a%)           $ IfNrgNest(%r%,%a%) = 0;
    paNRG.fx(%r%,%a%,NRG,v,tsim)$ IfNrgNest(%r%,%a%) = 0;
    pnely.fx(%r%,%a%,v,tsim)    $ IfNrgNest(%r%,%a%) = 0;
    polg.fx(%r%,%a%,v,tsim)     $ IfNrgNest(%r%,%a%) = 0;

*---    With Loop on %r%,%a% --> these flags should be sets

* Condition si bien i pdt par 1 seul secteur la production est supprimée

    LOOP( (i,%r%,%a%) $ ( sum(a $ as(%r%,a,i,tsim), 1) eq 1 and gp(%r%,%a%,i) ),
        xdt.fx(%r%,i,tsim)  = 0; xdtFlag(%r%,i) = 0;
        pdt.fx(%r%,i,tsim)  = 0; alphadt(r,i,tsim) = 0;
        xet.fx(%r%,i,tsim)  = 0; xetFlag(%r%,i) = 0;
        pet.fx(%r%,i,tsim)  = 0;
        xw.fx(%r%,i,rp,tsim)= 0; xwFlag(%r%,i,rp) = 0;

*---    Revoir si sum(a.local   $ tmat(%a%,i,%r%) ,1) > 1

        ps.fx(%r%,i,tsim) = 0;
        xs.fx(%r%,i,tsim) = 0; xsFlag(%r%,i) = 0;
        xd.fx(%r%,i,aa,tsim) $ IfArmFlag = 0; xdFlag(%r%,i,aa) $ IfArmFlag = 0;
        xddFlag(%r%,i) = 0;
    );

    x.fx(%r%,%a%,i,tsim) = 0;  gp(%r%,%a%,i)     = 0;
    p.fx(%r%,%a%,i,tsim) = 0;  as(%r%,%a%,i,tsim) = 0;

    emi.fx(%r%,AllEmissions,EmiSourceAct,%a%,tsim) = 0;
    emir(%r%,AllEmissions,EmiSourceAct,%a%,tsim) = 0;

$ENDIF.xp

*------------------------------------------------------------------------------*
*           Cleaning agent demands (pas les prix ici car pat est agrégé)       *
*------------------------------------------------------------------------------*

* this [TBC]

$IfThenI.xa %VarToClean% =="xa"

    xa.fx(%r%,%i%,%a%,tsim) = 0; xaFlag(%r%,%i%,%a%) = 0;

    $$IfThenI.CleanXa NOT %a% == "h"
        LOOP(%i%,
            xaNRG.fx(%r%,%a%,NRG,v,tsim) $ (IfNrgNest(%r%,%a%) and mape(NRG,%i%)) = 0;
            paNRG.fx(%r%,%a%,NRG,v,tsim) $ (IfNrgNest(%r%,%a%) and mape(NRG,%i%)) = 0;
            xaNRGFlag(%r%,%a%,NRG)       $ (xaNRG.l(%r%,%a%,NRG,v,tsim) eq 0) = 0;
        );
    $$ENDIF.CleanXa

    $$IfThenI.xac %a% == "h"
*---    Revoir ça: k
        LOOP((%i%,k) $ ac(%r%,%i%,k,%a%),
            xacNRG.fx(%r%,k,%a%,NRG,tsim)$ (IfNrgNest(%r%,%a%) and mape(NRG,%i%)) = 0;
            xacNRGFlag(%r%,k,%a%,NRG)    $ (IfNrgNest(%r%,%a%) and mape(NRG,%i%)) = 0;
            pacNRG.fx(%r%,k,%a%,NRG,tsim)$ (IfNrgNest(%r%,%a%) and mape(NRG,%i%)) = 0;
        );
    $$ENDIF.xac

$ENDIF.xa
