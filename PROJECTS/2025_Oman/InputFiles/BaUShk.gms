*------------------------------------------------------------------------------*
*                 [ENVISAGE] stylized Baseline                                 *
*------------------------------------------------------------------------------*
$IF NOT SET YearEndLTM $SetGlobal YearEndLTM "2050"
*       - savf
*       - chiaps --> rinvshr

*   [OECD-ENV]: Slow phase out between FirstYear and years(tf0) (ie 2030)
*   [ENVISAGE] Make trade imbalances disappear between tf0 and tfT

***HRR: changed the CAB closure below to have the option to use WEO CAB data
$iftheni.weosavcal %ifWEOsavCal%=="ON"
***$$iftheni.noMCD not %BaseName%=="2024_MCD"

    IF(IfDyn,
        savf.fx(r,tsim) = savf_weo(r,tsim) ;
    ELSE
        savf.fx(r,tsim) = savf.l(r,tsim-1) ;
    ) ;
$else.weosavcal
***$else.noMCD

    IF(IfDyn,
        if(year lt sum(tf0,years(tf0)),
            savf.fx(r,tsim) = savf.l(r,tsim-1) ;
        elseif (year gt %YearEndLTM%),
            savf.fx(r,tsim) = 0 ;
        else
            savf.fx(r,tsim)
                = [sum(tf0,savf.l(r,tf0)) * (%YearEndLTM% - year) + 0 ]
                / [%YearEndLTM% - sum(tf0,years(tf0))] ;
        ) ;
    ELSE
        savf.fx(r,tsim) = savf.l(r,tsim-1) ;
    ) ;

***$$endif.noMCD
$endif.weosavcal


*   Make savings endogenous in baseline and real investment to GDP fixed

loop(r,

    IF(invTargetT(r,tsim) ne na,

        IF(%utility% eq ELES,

* Endogenous betac: for ELES

            chiaps.fx(r,tsim)   = chiaps.l(r,tsim-1) ;
            betac.l(r,h,tsim)   = betac.l(r,h,tsim-1) ;
            betac.lo(r,h,tsim)  = -inf ;
            betac.up(r,h,tsim)  = +inf ;

        ELSE

* Endogenous chiaps: not for ELES

            betac.fx(r,h,tsim)  = betac.l(r,h,tsim-1) ;
            chiaps.lo(r,tsim)   = -inf ;
            chiaps.up(r,tsim)   = +inf ;
            chiaps.l(r,tsim)    = chiaps.l(r,tsim-1) ;
        ) ;

        rinvshr.fx(r,tsim) = 0.01 * invTargetT(r,tsim) ;

    ELSE

*   Case no target: investment to GDP is endogenous / no calibration

        betac.fx(r,h,tsim) = betac.l(r,h,tsim-1) ;
        chiaps.fx(r,tsim)  = chiaps.l(r,tsim-1) ;
        rinvshr.lo(r,tsim) = -inf ;
        rinvshr.up(r,tsim) = +inf ;
    ) ;

) ;


popWA.fx(r,l,z,tsim) $ lsFlag(r,l,z) = popWA.l(r,l,z,tsim);
UNR.fx(r,l,z,tsim)   $ lsFlag(r,l,z) =   UNR.l(r,l,z,tsim);
LFPR.fx(r,l,z,tsim)  $ lsFlag(r,l,z) =  LFPR.l(r,l,z,tsim);

$IFi %cal_preference%=="ON" $include "%CalDir%\4-1-preferences.gms"

$$OnDotl
**************************************************************************************************************
**************************************************************************************************************
* Additional baseline calibrations

$IfTheni.dynamic NOT %SimName%=="CompStat"
IF(ifDyn and ifCal,


**************************************************************************************************************
* Calibrating model using savg and savf from WEO

*** Calibrating goverment budget balance (zero in GTAP!)
$IFi %ifWEOsavcal%=="ON" savg.l(r,t) = WEO_gbal(r,t) / 1000; 

*$ontext moved to 8-solve.gms
**************************************************************************************************************
*** Total GHG emission projection calibration 
$iftheni.emitot %ifEmiTotcal%=="ON"

***emSingle("SF6") = NO ;
emSingle("HFC") = NO ;
emSingle("PFC") = NO ;
emSingle("FGAS") = NO ;
* Default -> no calibration of total emissions
IfCalEmi(r,em,EmiSource,aa) = 0;

            IfCalEmi(r,CO2,"allsourceinc",tot) = 0 ;
            IfCalEmi(r,AllGHG,"allsourceinc",tot)= 0 ;

            IfCalEmi(r,AllGHG,"allsourceinc",tot)$ (PROJ_GHG_LULUCF(r,tsim)) = 1 ;

          LOOP((r,AllGHG) $ IfCalEmi(r,AllGHG,"allsourceinc","tot"),
**To calibrate allGHGs together
            IfCalEmi(r,em,emiSourceAct,aa) $ (PROJ_GHG_LULUCF(r,tsim) AND EmSingle(em)) = 2 ; !! changing to emiSourc doesn't affect results
            chiTotEmi.lo(r,tsim) $ (PROJ_GHG_LULUCF(r,tsim)) = -inf ;
            chiTotEmi.up(r,tsim) $ (PROJ_GHG_LULUCF(r,tsim)) = inf ;

            emiTotAllGHG(r,tsim)$ PROJ_GHG_LULUCF(r,tsim)   = [cScale * PROJ_GHG_lulucf(r,tsim)]  ;
            ) ;

$endif.emitot
*$offtext

********************************************************************************************************
***ElyMix projections calibration
$iftheni.elymix %ifElyMixCal%=="ON"


IfCalMacro(r,"power mix")   = 0  ;
*option using powerMix instead of ElyMixCal  IfCalMacro(r,"power mix")$sum(elya,powerMix(r,elya,tsim)) = 1  ;
IfCalMacro(r,"power mix")$sum(elya,ElyMixCal(r,elya,"CurrentPol",tsim)) = 1  ;


IfCalMacro(r,"power mix") $ MAR(r)  = 0  ;

IF(IfPowerVol,
    LOOP( r $ (IfCalMacro(r,"power mix") eq 1),

        sigmapow(r,elyi)  $(NOT IfElyCES ) = 0.01 ;
        sigmapb(r,pb,elyi)$(NOT IfElyCES ) = 0.01 ;

        x.l(r,powa,elyi,tsim) $ x0(r,powa,elyi,tsim)
            = ElyMixCal(r,powa,"CurrentPol",tsim)
            / x0(r,powa,elyi,tsim) ;

        xpb.l(r,pb,elyi,tsim) $ xpb0(r,pb,elyi,tsim)
            = sum(powa $ mappow(pb,powa), m_true3t(x,r,powa,elyi,tsim))
            / xpb0(r,pb,elyi,tsim) ;

        xpow.l(r,elyi,tsim)   $ xpow0(r,elyi,tsim)
            = sum(pb, m_true3t(xpb,r,pb,elyi,tsim)) / xpow0(r,elyi,tsim) ;

        apb(r,pb,elyi,tsim) $ (xpb0(r,pb,elyi,tsim) and NOT IfElyCES)
            = [m_true3t(xpb,r,pb,elyi,tsim) / m_true2t(xpow,r,elyi,tsim)]
            * [m_true3(ppb,r,pb,elyi,tsim) * lambdapow(r,pb,elyi,tsim)
                / m_true2(ppowndx,r,elyi,tsim)]**sigmapow(r,elyi)
            ;
        apb(r,pb,elyi,tsim) $ (xpb0(r,pb,elyi,tsim) and IfElyCES)
            = [m_true3t(xpb,r,pb,elyi,tsim) / m_true2t(xpow,r,elyi,tsim)]
            * [m_true3(ppb,r,pb,elyi,tsim) / m_true2(ppow,r,elyi,tsim)]**sigmapow(r,elyi)
            * [lambdapow(r,pb,elyi,tsim)**(1-sigmapow(r,elyi))]
            ;

        as(r,powa,elyi,tsim)
            $ (sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim)) and NOT IfElyCES)
            = [m_true3t(x,r,powa,elyi,tsim) / sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim))]
            * sum(mappow(pb,powa),
                (m_true3(p,r,powa,elyi,tsim) * lambdapb(r,powa,elyi,tsim)
                / m_true3(ppbndx,r,pb,elyi,tsim))**sigmapb(r,pb,elyi) )
            ;

        as(r,powa,elyi,tsim)
            $ (sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim)) and IfElyCES)
            = [m_true3t(x,r,powa,elyi,tsim) / sum(mappow(pb,powa),m_true3t(xpb,r,pb,elyi,tsim))]
            * sum(mappow(pb,powa),
                lambdapb(r,powa,elyi,tsim)**(1-sigmapb(r,pb,elyi))
              * (m_true3(p,r,powa,elyi,tsim) / m_true3(ppb,r,pb,elyi,tsim))**sigmapb(r,pb,elyi) )
            ;
    );
);

$endif.elymix

$endif.dynamic
) ;

**************************************************************************************************************
$OffDotL


