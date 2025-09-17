$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file    : "%OutMngtDir%\OutMacroPrg\12-Welfare.gms"
    purpose      : Welfare Analysis
    created date : 10 Octobre 2021
    created by   : Jean Chateau
    called by    : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/12-Welfare.gms $
   last changed revision: $Rev: 387 $
   last changed date    : $Date:: 2023-09-01 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
                   [TBU]: only ELES
                   [TBU] leisure not taken into account
--------------------------------------------------------------------------------
$OffText

$ONDOTL

$setlocal step_welfare "%2"

$IfTheni.WelfStep1 %step_welfare%=="welf1"

*------------------------------------------------------------------------------*
*           Calculation of expenditure function for ELES system                *
*------------------------------------------------------------------------------*

    IF(%utility%=ELES,

$OnText
    Memo:

    Max u = prod(k, (xc(k) - pop * theta(k) )**muc(k)) * (savh / pfd)**mus
    s.t.  yd = savh + sum(k, pc(k) * xc(k))

    Supernumery income : SUPY = yd - sum(k, pc(k) * theta(k) * pop)
    per capita supernumery income:  SUPY / pop = supy

Solution:

    xc(k) = pop *  theta(k) + muc(k) * SUPY / pc(k)
          = pop * [theta(k) + muc(k) * supy / pc(k)]

    savh = mus . SUPY = yd -  sum(k, pc(k) * xc(k))

indirect utility

    v = prod(k, ( muc(k) * SUPY / pc(k) )**muc(k) ) * (mus . SUPY / pfd)**mus

      = SUPY . prod(k, ( muc(k) / pc(k) )**muc(k) ) * (mus / pfd)**mus

      = SUPY / P

    with "Price index" P:

    P = prod(k, [pc(k) / muc(k) ]**muc(k) ) * ( pfd / mus )**mus

Equivalent and Compensating variation of income are calculating with e(p,u)

    e = sum(k, pc(k) * theta(k) * pop) + u . P
      = [yd - SUPY] + u . P
      = out_Utility("subsistence bundle")
      + out_Utility("direct utility") * out_Utility("utility price index") ;

    For individual regions - All are nominal values


    Equivalent variation in income : E(p0,u1) - E(p0,u0)
                                   = pindexT(r,t)*(u1(r,t)-uT(r,t))

    Compensating variation in income : E(p1,u0) - E(p1,u1)

$offText

        LOOP(h,

*   step 1: Value of subsistence minima bundle per capita

            out_Utility("subsistence bundle",r,%1)
                $ between2(%1,"%YearStart%","%YearEndofSim%")
                = outscale * popScale
                * sum(k, m_true3(pc,r,k,h,%1) * m_true3(theta,r,k,h,%1)) ;

*   step 2: Indirect utility function: Price Index part of the expenditure

* [TBU] Need to fix bug that muc and mus could be < 0 in baseline

            out_Utility("utility price index",r,%1)
                $ out_Utility("subsistence bundle",r,%1)
                = prod(k $ xcFlag(r,k,h),
					{[m_true3(pc,r,k,h,%1) / m_true3(muc,r,k,h,%1)]**m_true3(muc,r,k,h,%1)} $ {m_true3(muc,r,k,h,%1) gt 0}
					+ 1 $ {m_true3(muc,r,k,h,%1) le 0}
					)
                * (  [(m_true2(pfd,r,h,%1)  / mus.l(r,h,%1))**mus.l(r,h,%1)] $ {mus.l(r,h,%1) gt 0}
                   + 1 $ {mus.l(r,h,%1) le 0} ) ;

*   step 3: Indirect utility function: Supernumary income (per capita) part

            out_Utility("supernumary income",r,%1)
                $ out_Utility("subsistence bundle",r,%1)
                = outscale * popScale * m_true2(supy,r,h,%1);

*   step 4: Indirect utility function (per capita): v(yd,pc) = SUPY / P

            out_Utility("indirect utility",r,%1)
                $ out_Utility("utility price index",r,%1)
                = out_Utility("Supernumary income",r,%1)
                / out_Utility("utility price index",r,%1) ;

* indirect utility from Model --> give same as "indirect utility" (correct)

            IF(0,
                out_Utility("indirect utility (from model)",r,%1)
                    $ (out_Utility("indirect utility",r,%1) and uFlag(r,h))
                    = outscale * popScale * m_true2(u,r,h,%1) ;
            );

*   step 5: Direct utility function (per capita):

*            out_Utility("direct utility",r,%1)
*            $ ( out_Utility("indirect utility",r,%1) and m_true1(pop,r,%1) )
*                = (outscale * popScale)
*                * [   prod(k $ ( xcFlag(r,k,h) and m_true3(muc,r,k,h,%1) gt 0 ),
*                            { [m_true3(xc,r,k,h,%1) - m_true3(theta,r,k,h,%1) * m_true1(pop,r,%1)]**m_true3(muc,r,k,h,%1) } $ { m_true3(xc,r,k,h,%1) gt m_true3(theta,r,k,h,%1) * m_true1(pop,r,%1) })
*                   * [ { [ m_true2(savh,r,h,%1) / m_true2(pfd,r,h,%1) ]**mus.l(r,h,%1) } ${ mus.l(r,h,%1) gt 0 } + 1 $ {mus.l(r,h,%1) le 0} ]
*                ] / m_true1(pop,r,%1) ;

        ) ; !! End loop on h

    ) ; !! End condition: %utility%=ELES

*---    Utility indicators for aggregate regions (for expenditure function):

    out_Macroeconomic(abstype,"welfare",macrolist,"nominal",ra,%1)
        = sum(mapr(ra,r), To%YearBaseMER%MER(r) * out_Utility(macrolist,r,%1)) ;

* Recover "utility price index" for Aggregate regions

    out_Macroeconomic(abstype,"welfare","utility price index","nominal",ra,%1)
        $ out_Macroeconomic(abstype,"welfare","indirect utility","nominal",ra,%1)
        = out_Macroeconomic(abstype,"welfare","Supernumary income","nominal",ra,%1)
        / out_Macroeconomic(abstype,"welfare","indirect utility","nominal",ra,%1) ;

* Ok  --> give same as "utility price index"
    IF(0,
        out_Macroeconomic(abstype,"welfare","utility price index (2.)","nominal",ra,%1)
            $ sum(mapr(ra,r), To%YearBaseMER%MER(r) * out_Utility("indirect utility",r,%1))
            = sum(mapr(ra,r), To%YearBaseMER%MER(r) * out_Utility("indirect utility",r,%1) * out_Utility("utility price index",r,%1))
            / sum(mapr(ra,r), To%YearBaseMER%MER(r) * out_Utility("indirect utility",r,%1)) ;
    ) ;

$EndIf.WelfStep1

$IfTheni.WelfStep2 %step_welfare%=="welf2"

*   step 6: Expenditure Function per capita: E(p,u) = subsmin(p) + u * P ;

    out_Macroeconomic(abstype,"welfare","Expenditure Function e(p.u)","nominal",ra,%1)
        = out_Macroeconomic(abstype,"welfare","subsistence bundle","nominal",ra,%1)
        + out_Macroeconomic(abstype,"welfare","direct utility","nominal",ra,%1)
        * out_Macroeconomic(abstype,"welfare","utility price index","nominal",ra,%1);

*   --> actually this is equal to "Disposable income per capita (nominal)"

    out_Macroeconomic(abstype,"welfare","Expenditure Function e(pbau.ubau)","nominal",ra,%1)
        = bau_Macroeconomic(abstype,"welfare","subsistence bundle","nominal",ra,%1)
        + bau_Macroeconomic(abstype,"welfare","direct utility","nominal",ra,%1)
        * bau_Macroeconomic(abstype,"welfare","utility price index","nominal",ra,%1);

    out_Macroeconomic(abstype,"welfare","Expenditure Function e(p.ubau)","nominal",ra,%1)
        = out_Macroeconomic(abstype,"welfare","subsistence bundle","nominal",ra,%1)
        + bau_Macroeconomic(abstype,"welfare","direct utility","nominal",ra,%1)
        * out_Macroeconomic(abstype,"welfare","utility price index","nominal",ra,%1);

    out_Macroeconomic(abstype,"welfare","Expenditure Function e(pbau.u)","nominal",ra,%1)
        = bau_Macroeconomic(abstype,"welfare","subsistence bundle","nominal",ra,%1)
        + out_Macroeconomic(abstype,"welfare","direct utility","nominal",ra,%1)
        * bau_Macroeconomic(abstype,"welfare","utility price index","nominal",ra,%1);

* Equivalent variation in income:  E(pbau,u) - E(pbau,ubau) : per capita

    out_Macroeconomic(abstype,"welfare","Equivalent variation in income","nominal",ra,%1)
        = out_Macroeconomic(abstype,"welfare","Expenditure Function e(pbau.u)","nominal",ra,%1)
        - out_Macroeconomic(abstype,"welfare","Expenditure Function e(pbau.ubau)","nominal",ra,%1);

    out_Macroeconomic("devtoBau","welfare","Equivalent variation in income","nominal",ra,%1)
        $ out_Macroeconomic("abs","welfare","Expenditure Function e(pbau.ubau)","nominal",ra,%1)
        = out_Macroeconomic("abs","welfare","Equivalent variation in income","nominal",ra,%1)
        / out_Macroeconomic("abs","welfare","Expenditure Function e(pbau.ubau)","nominal",ra,%1);

* Compensating variation in income:  E(p,ubau) - E(p,u) : per capita

    out_Macroeconomic(abstype,"welfare","Compensating variation in income","nominal",ra,%1)
        = out_Macroeconomic(abstype,"welfare","Expenditure Function e(p.ubau)","nominal",ra,%1)
        - out_Macroeconomic(abstype,"welfare","Expenditure Function e(p.u)","nominal",ra,%1);

$EndIf.WelfStep2

$OFFDOTL

$droplocal step_welfare
