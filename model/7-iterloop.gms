$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file   : "%ModelDir%\7-iterloop.gms"
	purpose     : instructions to solve the model
	Created by  :   Dominique van der Mensbrugghe for ENVISAGE
                  + modification by Jean Chateau for OECD-ENV
	Created date:
	called by   : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/7-iterloop.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    When starting from a baseline, one would use the baseline values until
    the first year of a shock. Thus if a shock begins in 2020, make %1 2025,
    then the beginning value for 2020 will be the baseline value.
    If there is no shock then make %1 greater than the terminal year,
    for example 2055 if the terminal year is 2050.
    The model should solve in the first iteration if there is no shock
--------------------------------------------------------------------------------

	Variables Initialization by default (and value of Flag IfInitVar)

	Policy Case (VarFlag > O):
		Up to %YearPolicyStart% we initialize policy variant  with
		the baseline trajectory (i.e. IfInitVar = 0)
		--> do not read "71-InitVar.gms"
		After %YearPolicyStart% we can either,
		IfInitVar = 2:	initialize using previous year values
		IfInitVar = 1 (Default):  initialize using previous year values for
		prices but previous year value adjusted for GDP growth for quantities.

	Dynamic baseline (Caldyn = 1) --> IfInitVar = 1:
		All trajectory is intialized using previous year values for prices
		and previous year value adjusted for GDP growth for quantities .

	Variant baseline (VarFlag = O and Caldyn = 0) --> IfInitVar = 0:
		All trajectory is intialized with dynamic baseline trajectory.

    N.B. IfInitVar could be overrided in "%iFilesDir%\AdjustSimOption.gms"

$OffText

year =  years(tsim) ;

*	Default initialization (IfInitVar)

IF(ifCal or (year ge %YearPolicyStart% and VarFlag),

    IfInitVar = 1 ;

ELSE

    IfInitVar = 0 ;

) ;

* Special case: initialization on a given trajectory

$IF SET InitFile IfInitVar = 0 ;

*   [OECD-ENV]: override with project-specific instructions (including cleaning)

$IF EXIST "%iFilesDir%\AdjustSimOption.gms" $include "%iFilesDir%\AdjustSimOption.gms"

*------------------------------------------------------------------------------*
*  [OECD-ENV]: Cleaning tiny production between two periods: for variant       *
*------------------------------------------------------------------------------*

$OnText
    IfCleanXP equals a number (by default IfCleanXP = 0):

    For any production lower than IfCleanXP --> xpFlag(r,a) = 0
    therefore xp(r,a) will be erased

    This does not for renewable electricity power sectors (i.e. s_ren)
    This procedure is only active for variant but not activated by default
    xpFlag = 0 could be declared in the file "%iFilesDir%\AdjustSimOption.gms"

	Notice we can manually erase a sector just by setting  xpFlag(r,a) = 0
	for a given year for example in the file "%iFilesDir%\AdjustSimOption.gms"

$OffText

IF(IfDyn and (year gt FirstYear),

    IF(IfCleanXP,
        DISPLAY    "Clean production lower than (in millions): ", IfCleanXP;
        put screen "Clean production lower than (in millions): ", IfCleanXP:4:0 /;
        putclose screen;
    ) ;
	IF(NOT IfCal,
		xpFlag(r,a) $ ((xpT(r,a,tsim-1) lt IfCleanXP) and not s_rena(a)) = 0 ;
	) ;

    $$include "%ModelDir%\70-Clean_Small_XP.gms"

) ;

* [OECD-ENV]: add closure rules if a variable vanished between two periods

xw.fx(r,i,rp,tsim) $ (not xwFlag(r,i,rp)) = 0 ;
pe.fx(r,i,rp,tsim) $ (not xwFlag(r,i,rp)) = sum(t0, pe.l(r,i,rp,t0)) ;

*------------------------------------------------------------------------------*
*               Initialize variables for new iteration                         *
*------------------------------------------------------------------------------*

* Memo: inactive for IfLoadYr  = 1  (e.g. load a given current year simulation)
*       inactive for IfInitVar = 0 (baseline in variant mode)
*

* For debugging: No Dynamic: $Include "%DebugDir%\IterloopNoDynamic.gms"

IF(year gt FirstYear,
	display "Year and IfInitVar (%system.fn%.gms):", year, IfInitVar ;
) ;

IF((year gt FirstYear) AND IfInitVar AND (NOT IfLoadYr),

* Initialise on previous year/simulation: IfInitVar eq 2

	rwork(r) $ (IfInitVar eq 2) = 1 ;

* Initialise on previous value + multiply with GDP growth factor: IfInitVar eq 1
* not for %SimType%=="CompStat"

	rwork(r) $ (ifDyn AND IfInitVar eq 1)
		= [rgdppcT(r,tsim)   * popT(r,"PTOTL",tsim)  ]
		/ [rgdppcT(r,tsim-1) * popT(r,"PTOTL",tsim-1)] ;

    $$include "%ModelDir%\71-InitVar.gms"

) ;

*------------------------------------------------------------------------------*
*       Initialize vintage volumes for first simulation year                   *
*------------------------------------------------------------------------------*

IF(ifVint and ord(tsim) eq 2,

    $$include "%ModelDir%\72-InitVint.gms"

) ;

*------------------------------------------------------------------------------*
* Re-calibrate the production parameters starting with the 2nd simulation year *
*------------------------------------------------------------------------------*

$OnText
    N.B. We must do this step even in a no-shock scenario
        since the share parameters are initialized in 'init.gms'
        !!!! We may want to re-think this in the future, though it
        doesn't appear to cost much in terms of calculations
$OffText

IF(ifDyn and (year gt FirstYear), !! ord(tsim) ge 2

    $$include "%ModelDir%\73-recal.gms"

) ;

*------------------------------------------------------------------------------*
*   OECD-ENV activate scaling the Equations of the model [Option]              *
*------------------------------------------------------------------------------*

loop(t0 $ (year gt years(t0)),
    $$Ifi %IfScaleEq%=="ON" $include "%ModelDir%\74-Scaling_Equations.gms"
);

*------------------------------------------------------------------------------*
*                       Fix lagged variables                                   *
*------------------------------------------------------------------------------*

*  Reset the lag

$iftheni NOT "%simType%" == "CompStat"
   tLag(tsim-1) = yes ;
$endif

$include "%ModelDir%\75-Fixing_LagVariables.gms"

*------------------------------------------------------------------------------*
*                 [OECD-ENV]: Dynamic Scaling [Option]                         *
*------------------------------------------------------------------------------*

* Adjust scale for pxghg

$OnDotl
pxghg0(r,a,tsim)
    $ ( ghgFlag(r,a) and sum(v,m_true3v(xghg,r,a,v,tsim-1)) )
    = sum(v,m_true3vt(pxghg,r,a,v,tsim-1) * m_true3v(xghg,r,a,v,tsim-1))
    / sum(v,m_true3v(xghg,r,a,v,tsim-1)) ;
$OffDotl

IF(ifDyn and (year gt FirstYear) and (IfDynScaling eq 2),
    IF(ifCal,
        $$batinclude "%ModelDir%\76-DynamicScaling.gms" "tsim-1"
    ELSE
        $$batinclude "%ModelDir%\76-DynamicScaling.gms" "tsim"
    ) ;
) ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       Update the dynamics                                    *
*                                                                              *
*------------------------------------------------------------------------------*
$OnDotl

IF(ifDyn and (year gt FirstYear),

* Population is fixed

    IF(ifCal,
        pop.fx(r,tsim)
            = pop.l(r,tsim-1) * popT(r,"PTOTL",tsim) / popT(r,"PTOTL",tsim-1) ;
    ELSE
        pop.fx(r,tsim) = pop.l(r,tsim) ;
    );

* Capital accumulation is endogenous

    tkaps.lo(r,tsim)  = -inf ; tkaps.up(r,tsim)  = +inf ;
    kstock.lo(r,tsim) = -inf ; kstock.up(r,tsim) = +inf ;

* Installed capital by sector (initialization)

    k0.l(r,a,tsim) $ (kflag(r,a) and k0.l(r,a,tsim) ne 1)
        = sum(v, m_true3vt(kv,r,a,v,tsim-1))
        * power( 1 - depr(r,tsim), gap(tsim)) / k00(r,a,tsim) ;

* Energy efficiency parameter

    IF(ifCal,

        lambdae.fx(r,e,a,v,tsim)
            = lambdae.l(r,e,a,v,tsim-1)
            * power(1 + 0.01 * aeei(r,e,a,v,tsim) , gap(tsim)) ;
        lambdace.fx(r,e,k,h,tsim)
            = lambdace.l(r,e,k,h,tsim-1)
            * power(1 + 0.01 * aeeic(r,e,k,h,tsim), gap(tsim)) ;
    ELSE

        lambdae.fx(r,e,a,v,tsim)  = lambdae.l(r,e,a,v,tsim) ;
        lambdace.fx(r,e,k,h,tsim) = lambdace.l(r,e,k,h,tsim);

    ) ;

* Exogenous Land & Capital efficiency improvements

    IF(ifCal,

* [OECD-ENV]: Land yield also hold for livestock --> change cra to agr

        lambdat.fx(r,a,v,tsim) $ agra(a)
            = lambdat.l(r,a,v,tsim-1)
            * power(1 + 0.01 * yexo(r,a,v,tsim), gap(tsim)) ;

* [OECD-ENV]: different from ENVISAGE

        lambdak.fx(r,a,v,tsim)
            = lambdak.l(r,a,v,tsim-1)
            * power(1 + 0.01 * g_kt(r,a,v,tsim), gap(tsim)) ;

    ELSE

        lambdat.fx(r,a,v,tsim) $ agra(a) = lambdat.l(r,a,v,tsim);
        lambdak.fx(r,a,v,tsim) = lambdak.l(r,a,v,tsim);

    );

* Exogenous improvements in nat. resources shifter and in nat. ressources efficiency

    IF(ifCal,

        chinrf.fx(r,a,tsim) $ natra(a)
            = chinrf.l(r,a,tsim-1)
            * power(1 + 0.01 * g_natr(r,a,tsim), gap(tsim)) ;

        lambdanrf.fx(r,a,v,tsim) $ natra(a)
            = lambdanrf.l(r,a,v,tsim)
            * power(1 + 0.01 * g_nrf(r,a,v,tsim), gap(tsim)) ;

    ELSE

        chinrf.fx(r,a,tsim) $ natra(a) = chinrf.l(r,a,tsim) ;

* Natural Resources Efficiency

        lambdanrf.fx(r,a,v,tsim) $ natra(a) = lambdanrf.l(r,a,v,tsim) ;

    ) ;

* lambdafd & lambdaio dynamics (OECD-ENV Adds )

    lambdafd.fx(r,i,fdc,tsim) $ xaFlag(r,i,fdc) = lambdafd.l(r,i,fdc,tsim) ;

*	non-energy intermediate demand efficicencies [TBC]: feed & fertilizer

    IF(ifCal,
        lambdaio.fx(r,i,a,tsim) $ (xaFlag(r,i,a) and not e(i))
            = lambdaio.l(r,i,a,tsim-1)
            * power(1 + 0.01 * g_io(r,i,a,tsim), gap(tsim));
    ELSE

        lambdaio.fx(r,i,a,tsim) $ (xaFlag(r,i,a) and not e(i))
            = lambdaio.l(r,i,a,tsim);
    ) ;

* International trade and transport margins

    IF(IfCal,
        tmarg.fx(r,i,rp,tsim)
            = tmarg.l(r,i,rp,tsim-1)
            * power(1 + 0.01 * tteff(r,i,rp,tsim), gap(tsim)) ;
    ELSE
        tmarg.fx(r,i,rp,tsim) = tmarg.l(r,i,rp,tsim);
    );

*   Labor Dynamics

    $$OnText
        Implement assumptions on growth rate of labor -- driven by growth of skilled labor
        The growth of total labor is given by the SSP population assumptions
        skLabgrwgt is a user-determined parameter (default 0)
        One skill case skl = "Labour" & nsk =empty
    $$OffText

* Intialization (Calibration)

    IF(ifCal,
        tls.l(r,tsim)
            = tls.l(r,tsim-1)
            * power(1 + 0.01 * gtLab.l(r,tsim), gap(tsim)) ;
        glab.l(r,skl,tsim)
            = skLabgrwgt       * glabT(r,skl,tsim)
            + (1 - skLabgrwgt) * gtlab.l(r,tsim) ;
    );

* Intialization (all dynamic cases)

    ls.l(r,skl,tsim)
        = power(1 + 0.01 * glab.l(r,skl,tsim), gap(tsim)) * ls.l(r,skl,tsim-1) ;

    IF(card(l) gt 1,
        glab.l(r,nsk,tsim)
            = [ (  (m_true1(tls,r,tsim)   - sum(skl, m_true2(ls,r,skl,tsim)))
                 / (m_true1(tls,r,tsim-1) - sum(skl, m_true2(ls,r,skl,tsim-1)))
                )**(1 / gap(tsim)) - 1] * 100 ;
        ls.l(r,nsk,tsim)
            = ls.l(r,nsk,tsim-1) * power(1 + 0.01 * glab.l(r,nsk,tsim), gap(tsim)) ;
    ) ;

    lsz.lo(r,l,z,tsim)   $ lsFlag(r,l,z) = -inf ;
    lsz.up(r,l,z,tsim)   $ lsFlag(r,l,z) = +inf ;

* Fixing glabz for dynamic cases is caduc, now labor dynamic is function of ETPT
*    glabz.fx(r,l,z,tsim) $ lsFlag(r,l,z) = glab.l(r,l,tsim) ;

* Rural vs Urban migration:

    IF(IfCal,

* Central case: migrFlag = 0 --> this is inactive

    migrMult.l(r,l,z,tsim) $ migrFlag(r,l)
        = (power(1 + 0.01 * glabz.l(r,l,z,tsim), gap(tsim))
        * (urbPrem.l(r,l,tsim-1) / urbPrem.l(r,l,tsim))**omegam(r,l) - 1)
        / ((1 + 0.01 * glabz.l(r,l,z,tsim))
        * [urbPrem.l(r,l,tsim-1) / urbPrem.l(r,l,tsim)]**[omegam(r,l)/gap(tsim)]-1) ;

* Labour: initialization "lsz.l" & "glab.l"

        lsz.l(r,l,z,tsim) $ (lsz0(r,l,z) and lsFlag(r,l,z))
            = power(1 + 0.01 * glabz.l(r,l,z,tsim), gap(tsim)) * lsz.l(r,l,z,tsim-1)
            + kronm(z) * migrMult.l(r,l,z,tsim) * m_true2(migr,r,l,tsim)
            / lsz0(r,l,z) ;
        glab.l(r,l,tsim)
            = 100 * [ (sum(z$lsFlag(r,l,z), m_true3(lsz,r,l,z,tsim))
                     / sum(z$lsFlag(r,l,z), m_true3(lsz,r,l,z,tsim-1)))**(1/gap(tsim))
                     - 1 ] ;

    ELSE

* OECD-ENV Adds: possibility of endogenous labor force in variant cases

        LFPR.fx(r,l,z,tsim) $ (NOT etawl(r,l))  = LFPR.l(r,l,z,tsim);
        LFPR.lo(r,l,z,tsim) $ etawl(r,l) = - inf;
        LFPR.up(r,l,z,tsim) $ etawl(r,l) = + inf;
    ) ;

*   World price trends

    IF(IfCal,

*     Calibrate to exogenous trends (Baseline)

        loop(a,
            IF(pwTrend(a,tsim) ne na,
                pw.fx(a,tsim) = pwTrend(a,tsim) ;
                wchinrf.lo(a,tsim) = -inf ;
				wchinrf.up(a,tsim) = +inf ;
            ELSE
                pw.lo(a,tsim) $ pw0(a) = -inf ;
				pw.up(a,tsim) $ pw0(a) = +inf ;
                wchinrf.fx(a,tsim) $ pw0(a) = wchinrf.l(a,tsim-1) ;
            ) ;
        ) ;

    ELSE

*   Calibrate to exogenous shock (variant)

        loop(a,
            IF(pwShock(a,tsim) ne na,
                pw.fx(a,tsim) $ pw0(a) = pwShock(a,tsim) ;
                wchinrf.lo(a,tsim) = -inf ; wchinrf.up(a,tsim) = +inf ;
            ELSE
                pw.lo(a,tsim) $ pw0(a) = -inf ; pw.up(a,tsim) $ pw0(a) = +inf ;
                wchinrf.fx(a,tsim) = wchinrf.l(a,tsim) ;
            ) ;
        ) ;
     ) ;

*   Government expenditures (xfd) and government real savings (rsg)

    IF(IfCal,

* [ENVISAGE] dynamic calibration: government expenditures grow at the rate of GDP growth

        xfd.fx(r,gov,tsim)
            = xfd.l(r,gov,tsim-1)
            * [rgdppcT(r,tsim)   * popT(r,"PTOTL",tsim) ]
            / [rgdppcT(r,tsim-1) * popT(r,"PTOTL",tsim-1)] ;

* [ENVISAGE]: real savings are fixed to previous level

*        rsg.fx(r,tsim)     = rsg.l(r,tsim-1) ;
        rsg.fx(r,tsim)     = rsg.l(r,tsim) ;

    ELSE

* In all variants: real government expenditures and real government savings
* are exogenous and equal to the baseline levels

        xfd.fx(r,gov,tsim) = xfd.l(r,gov,tsim) ;
        rsg.fx(r,tsim)     = rsg.l(r,tsim) ;

    ) ;

*   Calibrating Labor productivity to target growth rate of real GDP per capita

* memo: glMltShft(r,l,a,t) is 1 in standard case
*       contrarily to most growth rate "glAddShft" and "gl" are not in percent

    IF(IfCal,

* GDP growth is given, labor productivity is endogenous

        grrgdppc.fx(r,tsim)  !! if rgdppcT is annual
            = 100 * [ (rgdppcT(r,tsim) / rgdppcT(r,tsim-1))**(1/gap(tsim)) - 1];

        gl.l(r,tsim) $ (ord(tsim) gt 2) = gl.l(r,tsim-1) ;

        lambdal.l(r,l,a,tsim)
            = lambdal.l(r,l,a,tsim-1)
            * power(1 + glAddShft(r,l,a,tsim) + glMltShft(r,l,a,tsim) * gl.l(r,tsim), gap(tsim)) ;

        lambdal.lo(r,l,a,tsim) $ labFlag(r,l,a) = -inf ;
        lambdal.up(r,l,a,tsim) $ labFlag(r,l,a) = +inf ;
        gl.lo(r,tsim) = -inf ; gl.up(r,tsim) = +inf ;

    ELSE

* Aggregate growth rate of labour efficiency is exogenous
* Growth rate of GDP per capita growth is endogenous

        gl.fx(r,tsim) = gl.l(r,tsim) ;
        grrgdppc.lo(r,tsim) = -inf ;
        grrgdppc.up(r,tsim) = +inf ;

* [OECD-ENV]: in variant case now lambdal is fixed and lambdaleq is inactive

        lambdal.fx(r,l,a,tsim) = lambdal.l(r,l,a,tsim);

    ) ;

*   Calibrating Total Factor Productivity parameters
* memo: * "TFP_fp" has a specific status, it is not a trend just a difference
* to previous round

    IF(IfCal,

        TFP_xpx.fx(r,a,v,tsim) $ xpFlag(r,a)
            = TFP_xpx.l(r,a,v,tsim-1)
            * power(1 + 0.01 * g_xpx(r,a,v,tsim), gap(tsim)) ;
        TFP_xs.fx(r,i,tsim) $ xsFlag(r,i)
            = TFP_xs.l(r,i,tsim-1)
            * power(1 + 0.01 * g_xs(r,i,tsim), gap(tsim)) ;
        TFP_fp.fx(r,a,tsim) $ xpFlag(r,a)
            = power(1 + 0.01 * g_fp(r,a,tsim), gap(tsim)) ;

    ELSE

***HRR        TFP_fp.fx(r,a,tsim)    $ xpFlag(r,a) = 1 ;
        TFP_xpx.fx(r,a,v,tsim) $ xpFlag(r,a) = TFP_xpx.l(r,a,v,tsim) ;
        TFP_xs.fx(r,i,tsim)    $ xsFlag(r,i) = TFP_xs.l(r,i,tsim) ;
    ) ;

    IF(NOT IfCal,
        chiaps.fx(r,tsim)  = chiaps.l(r,tsim)  ;
        betac.fx(r,h,tsim) = betac.l(r,h,tsim) ;
        rgovshr.lo(r,tsim) = -inf ; rgovshr.up(r,tsim) = +inf ;
        rinvshr.lo(r,tsim) = -inf ; rinvshr.up(r,tsim) = +inf ;
        invshr.lo(r,tsim)  = -inf ; invshr.up(r,tsim)  = +inf ;

* [OECD-ENV]: Fix savf + desactivate savfeq (ifSavfEQ(r) eq 0)

        savf.fx(r,tsim)    $ (NOT ifSavfEQ(r)) = savfBar(r,tsim);
        savf.fx(rres,tsim) $ (NOT ifSavfEQ(rres))
            = - sum(r $ (not rres(r)), savf.l(r,tsim));

    ) ;

* [OECD-ENV]: Add inactive source of emissions "EmiSourceIna" (dynamic cases)

* If a scenario on inactive emissions has been pre-defined

    emi.fx(r,AllEmissions,EmiSourceIna,aa,tsim)
        $ emi.l(r,AllEmissions,EmiSourceIna,aa,tsim)
        = emi.l(r,AllEmissions,EmiSourceIna,aa,tsim);

* If no more data use previous year

    emi.fx(r,AllEmissions,EmiSourceIna,aa,tsim)
        $ (not emi.l(r,AllEmissions,EmiSourceIna,aa,tsim)
           and emi.l(r,AllEmissions,EmiSourceIna,aa,tsim-1) )
        = emi.l(r,AllEmissions,EmiSourceIna,aa,tsim-1);

* OECD-ENV: by default emission coefficient of previous year for calibration

    IF(ifCal,
        emir(r,AllEmissions,EmiSource,aa,tsim)
			$ emir(r,AllEmissions,EmiSource,aa,tsim)
            = emir(r,AllEmissions,EmiSource,aa,tsim-1) ;
        emird(r,AllEmissions,EmiUse,aa,t) $ emird(r,AllEmissions,EmiUse,aa,tsim)
            = emird(r,AllEmissions,EmiUse,aa,tsim-1) ;
        emirm(r,AllEmissions,EmiUse,aa,t) $ emirm(r,AllEmissions,EmiUse,aa,tsim)
            = emirm(r,AllEmissions,EmiUse,aa,tsim-1) ;

* Memo: aemi(vOld) is recalculated previously in "%ModelDir%\73-recal.gms"

        aemi(r,AllEmissions,a,vNew,tsim) $ ifEndoMAC
            = aemi(r,AllEmissions,a,vNew,tsim-1);

    ) ;

) ;

emi.fx(r,AllEmissions,EmiSourceIna,a,tsim) $ ((NOT xpFlag(r,a)) OR tota(a)) = 0;

*------------------------------------------------------------------------------*
*                           Not Dynamic                                        *
*------------------------------------------------------------------------------*

* For comparative static simulation:

grrgdppc.fx(r,tsim) $(NOT ifDyn) = 0 ;

* Exogenous emission variables (emiOth and emiOthGbl not scaled)

emiOth.fx(r,AllEmissions,tsim)
    = sum((EmiSourceIna,aa), m_true4(emi,r,AllEmissions,EmiSourceIna,aa,tsim)) ;

emiOthGbl.fx(AllEmissions,tsim) = emiOthGbl.l(AllEmissions,tsim) ;

*------------------------------------------------------------------------------*
*                                                                              *
*           Implement cost reductions in selected activities                   *
*                                                                              *
*------------------------------------------------------------------------------*

* [EditJean]: Formules a revoir

IF(IfDyn,
    IF(year gt FirstYear,
        loop( (r,a) $ ifCostCurve(r,a),

            $$iftheni.type %costCurve% == HYPERB

				tprice = log( [costTgt(r,a) - costMin(r,a)] / [1 - costMin(r,a)] )
                       / log( 1 / [costTgtYear(r,a) - (FirstYear-1)] ) ;
                work = [costMin(r,a) + [1-costMin(r,a)] * [years(tsim-1) - (FirstYear-1) ]**(-tprice) ]
                     / [costMin(r,a) + [1-costMin(r,a)] * [years(tsim)   - (FirstYear-1) ]**(-tprice) ]  ;

            $$elseifi.type %costCurve% == LOGIST

                tvol = - [1/(costTgtYear(r,a)-FirstYear)]
                     * log( [costTgt(r,a) - costMin(r,a)]
                            / [costTgt(r,a) * (1 - costMin(r,a))] ) ;
                work = [1 + [costMin(r,a)-1] * exp(-tvol * (years(tsim)-FirstYear)) ]
                     / [1 + [costMin(r,a)-1] * exp(-tvol * (years(tsim)-FirstYear - gap(tsim))) ] ;

            $$else.type

                Abort "Wrong cost curve type, valid types are 'HYPERB' and 'LOGIST'" ;

            $$endif.type

        lambdaxp.fx(r,a,v,tsim) = work * lambdaxp.l(r,a,v,tsim-1) ;

        ) ;
    ) ;
) ;

$OffDotl






