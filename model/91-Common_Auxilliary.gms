$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
	GAMS file	 : "%ModelDir%\91-Common_Auxilliary.gms"
    purpose      : Computation auxilliary variables
                     XPT, XAPT, REXPT, EXPT, RIMPT, IMPT, TermsOfTradeT
                     out_Gross_output, out_Value_Added, nrj_mtoe, kapblab
    Created by   : Jean Chateau
    Created date : 2021-March-15
    called by    : %ModelDir%\9-sam.gms
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/91-Common_Auxilliary.gms $
	last changed revision: $Rev: 518 $
	last changed date    : $Date:: 2024-02-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
        Expressions en majuscules = variables expost
        These instructions are after substituted out variables
--------------------------------------------------------------------------------
$OffText

$OnDotL

*   Calculate Un-scaled variables

* Real Gross Output (Basic Prices)

XPT(r,a,%1) $ xpFlag(r,a) = outscale * m_true2t(xp,r,a,%1);

* Demands (Quid gammaex(r,i,aa) ?)

XAPT(r,i,aa,%1) $ xaFlag(r,i,aa) = outscale * m_true3t(xa,r,i,aa,%1) ;

* Emission intensity: kilograms of CO2 per constant USD

EmIntensity(r,a,AllEmissions,%1)
    =  sum(EmiSourceAct $ emi0(r,AllEmissions,EmiSourceAct,a),
            m_true4(emi,r,AllEmissions,EmiSourceAct,a,%1) ) ;

EmIntensity(r,a,AllEmissions,%1) $ XPT(r,a,%1)
    = 100000 * EmIntensity(r,a,AllEmissions,%1) / (cScale * XPT(r,a,%1)) ;

* [TBU]
$IF SET module_SectInv XAPT(r,i,inv,%1) = XAPT(r,i,inv,%1) + outscale * sum(a $ (ExtraInvFlag(r,a) eq 1), m_true(xaa(r,i,a,%1)) );

LOOP(t0,

*   Exports of good i at FOB Prices

* (e.g. FOB price of exports --> exports taxes inclusive but not trade margins)

    REXPT(r,i,%1) = outscale * sum(rp $ xwFlag(r,i,rp),
                        m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,%1) ) ;

    EXPT(r,i,%1)  = outscale * sum(rp $ xwFlag(r,i,rp),
                        m_true3(pwe,r,i,rp,%1) * m_true3(xw,r,i,rp,%1) ) ;

*   TermsOfTradeT first step (Export index price)

    TermsOfTradeT(r,%1)
        $ sum((rp,i) $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t0))
        = sum((rp,i) $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,%1) * m_true3(xw,r,i,rp,t0))
        / sum((rp,i) $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t0));

*   Imports of good i at CIF Prices

* (e.g. CIF price of imports --> trade margin plus IC inclusives)
* Warning IC (lambdaw in qty not prices donc doit suivre xw)

    RIMPT(r,i,%1)
        = outscale * sum(rp $ xwFlag(r,i,rp),
           m_true3(pwm,rp,i,r,t0) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,%1));

    IMPT(r,i,%1) $ RIMPT(r,i,%1)
        = outscale * sum(rp $ xwFlag(r,i,rp),
           m_true3(pwm,rp,i,r,%1) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,%1));

*   TermsOfTradeT second step (import price Index)

* memo pwm = [m_true3(pwe) + tmarg * pwmg] / [pwm0 * lambdaw]
* donc : m_true(pwm) doit etre multiplie par lambdaw pour obtenir vrais flux
* Pour variable reelles on multiplie par lambdaw(t) et non lambdaw(t0)

    TermsOfTradeT(r,%1)
        $( sum((rp,i), m_true3(pwm,rp,i,r,%1) * lambdaw(rp,i,r,%1) *  m_true3(xw,rp,i,r,t0)) and TermsOfTradeT(r,%1))
        = TermsOfTradeT(r,%1) /
        [ sum((rp,i), m_true3(pwm,rp,i,r,%1) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,t0))
        / sum((rp,i), m_true3(pwm,rp,i,r,t0) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,t0)) ];

*------------------------------------------------------------------------------*
*           Gross Output at Basic (Agent's) Prices, by activities              *
*------------------------------------------------------------------------------*

    out_Gross_output(abstype,"real",r,a,%1)    = m_true2(px,r,a,t0) * XPT(r,a,%1);
    out_Gross_output(abstype,"nominal",r,a,%1) = m_true2(px,r,a,%1) * XPT(r,a,%1);

*  Total (e.g. not for vol make no sense)

    out_Gross_output(abstype,units,r,"total",%1)$(not volume(units))
        = sum(a, out_Gross_output("abs",units,r,a,%1) );

*------------------------------------------------------------------------------*
*                   Value Added, by activities/commodities                     *
*------------------------------------------------------------------------------*

* Value Added at Basic (Agent's) Prices

    out_Value_Added(abstype,"Basic Prices","nominal",r,a,%1) $ xpFlag(r,a)
        = out_Gross_output(abstype,"nominal",r,a,%1)
        - sum(i, m_true3(pa,r,i,a,%1) * XAPT(r,i,a,%1));

    out_Value_Added(abstype,"Basic Prices","real",r,a,%1) $ xpFlag(r,a)
        = out_Gross_output(abstype,"real",r,a,%1)
        - sum(i, m_true3(pa,r,i,a,t0) * XAPT(r,i,a,%1));

* Value Added at Production Prices (Production tax inclusives)

    out_Value_Added(abstype,"Production Prices","nominal",r,a,%1) $ xpFlag(r,a)
        = m_true2(pp,r,a,%1) * XPT(r,a,%1)
        - sum(i, m_true3(pa,r,i,a,%1) * XAPT(r,i,a,%1));
    out_Value_Added(abstype,"Production Prices","real",r,a,%1) $ xpFlag(r,a)
        = m_true2(pp,r,a,t0) * XPT(r,a,%1)
        - sum(i, m_true3(pa,r,i,a,t0) * XAPT(r,i,a,%1));

* Value Added at Market Prices "by commodity"
* N.B term "Market Prices" is inadequate since here Agent's Price

    out_Value_Added(abstype,"Market Prices","nominal",r,i,%1)
        = sum(fd, m_true3(pa,r,i,fd,%1) * XAPT(r,i,fd,%1))
        + EXPT(r,i,%1) - IMPT(r,i,%1)
        + outscale * m_true2(pdt,r,i,%1) * m_true2(xtt,r,i,%1);
    out_Value_Added(abstype,"Market Prices","real",r,i,%1)
        = sum(fd, m_true3(pa,r,i,fd,t0) * XAPT(r,i,fd,%1) )
        + REXPT(r,i,%1) - RIMPT(r,i,%1)
        + outscale * m_true2(pdt,r,i,t0) * m_true2(xtt,r,i,%1);

*  Value Added at Factor Cost (net-of-tax price or Market Prices: VFM)

    out_Value_Added(abstype,"Factor Cost","nominal",r,a,%1) $ xpFlag(r,a)
        = outscale
        * {  sum(l $ labFlag(r,l,a), m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1))
           + sum(v, m_true3v(pk,r,a,v,%1) * m_true3vt(kv,r,a,v,%1) )$ kflag(r,a)       !! + kspec.l(r,i,v)
           + [m_true2(pland,r,a,%1) * m_true2t(land,r,a,%1)] $ landFlag(r,a)
           + [m_true2(pnrf,r,a,%1)  * m_true2(xnrf,r,a,%1)] $ nrfFlag(r,a)
          };

* If initially gross factor prices are normalized to one --> [TBC]

    out_Value_Added(abstype,"Factor Cost","real",r,a,%1) $ xpFlag(r,a)
        = outscale
* [TBU] with --> * TFP_fp.l(r,a,%1)
        * [   sum(l $ labFlag(r,l,a), m_true3(wage,r,l,a,t0) * lambdal.l(r,l,a,%1) * m_true3t(ld,r,l,a,%1) / lambdal.l(r,l,a,t0))
            + sum(v, m_true3v(pk,r,a,v,t0) * lambdak.l(r,a,v,%1) * m_true3vt(kv,r,a,v,%1) / lambdak.l(r,a,v,t0)) $ kflag(r,a) !! + kspec.l(r,i,v)
            + [m_true2(pland,r,a,t0) * sum(vOld,  lambdat.l(r,a,vOld,%1)/lambdat.l(r,a,vOld,t0))   * m_true2t(land,r,a,%1) ] $ landFlag(r,a)
            + [ m_true2(pnrf,r,a,t0) * sum(vOld,lambdanrf.l(r,a,vOld,%1)/lambdanrf.l(r,a,vOld,t0)) * m_true2(xnrf,r,a,%1) ] $ nrfFlag(r,a)
        ];

* [TBC] units

    IF(NOT IfNrgVol,

        nrj_mtoe(r,e,aa,%1) $ XAPT(r,e,aa,t0)
            = XAPT(r,e,aa,%1) * nrj_mtoe(r,e,aa,t0) / XAPT(r,e,aa,t0);

* [TBC]

        IF(not IfArmFlag,
            nrj_mtoe_d(r,e,aa,%1)
                $ [XAPT(r,e,aa,t0) * xdt(r,e,t0) * (xdt(r,e,%1) + xmt(r,e,%1))]
                = nrj_mtoe_d(r,e,aa,t0)
                * [XAPT(r,e,aa,%1) * m_true2(xdt,r,e,%1) * (m_true2(xdt,r,e,t0) + m_true2(xmt,r,e,t0))]
                / [XAPT(r,e,aa,t0) * m_true2(xdt,r,e,t0) * (m_true2(xdt,r,e,%1) + m_true2(xmt,r,e,%1))];

            nrj_mtoe_m(r,e,aa,%1)
                $ [XAPT(r,e,aa,t0) * xmt(r,e,t0) * (xdt(r,e,%1) + xmt(r,e,%1))]
                = nrj_mtoe_m(r,e,aa,t0)
                * [XAPT(r,e,aa,%1) * m_true2(xmt,r,e,%1) * (m_true2(xdt,r,e,t0) + m_true2(xmt,r,e,t0))]
                / [XAPT(r,e,aa,t0) * m_true2(xmt,r,e,t0) * (m_true2(xdt,r,e,%1) + m_true2(xmt,r,e,%1))];
        ) ;

        nrj_mtoe_xw(r,e,rp,%1) $ m_true3(xw,r,e,rp,t0)
            = nrj_mtoe_xw(r,e,rp,t0)
            * m_true3(xw,r,e,rp,%1) / m_true3(xw,r,e,rp,t0) ;

    ELSE

        nrj_mtoe(r,e,aa,%1) = XAPT(r,e,aa,%1);

    );

    $$IfTheni.STD NOT SET IfPostProcedure
        check_GovBalance(r,%1)
            = {kappah.l(r,%1) - kappah.l(r,t0)  } $ {GovBalance(r) eq 0}
            + {rsg.l(r,%1)    - rsg.l(r,t0)     } $ {GovBalance(r) eq 1}
            + {trg.l(r,%1)    - trg.l(r,t0)     } $ {GovBalance(r) eq 2}
            + {sum(l,kappal.l(r,l,%1) - kappal.l(r,l,t0))} $ {GovBalance(r) eq 3}
            + {chiVAT.l(r,%1) - chiVAT.l(r,t0)  } $ {GovBalance(r) eq 4}
            ;
    $$EndIf.STD

); !! End Loop on t0

*   Average Tariffs and Export Subsidies rates

AGG_tariffs(r,i,%1)
    $ sum(rp $ xwFlag(rp,i,r), m_true3(pwe,rp,i,r,%1) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,%1))
    = sum(rp $ xwFlag(rp,i,r), mtax.l(rp,i,r,%1) * m_true3(pwe,rp,i,r,%1) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,%1))
    / sum(rp $ xwFlag(rp,i,r), m_true3(pwe,rp,i,r,%1) * lambdaw(rp,i,r,%1) * m_true3(xw,rp,i,r,%1)) ;

AGG_exportsub(r,i,%1)
    $ sum(rp $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,%1) * m_true3(xw,r,i,rp,%1) )
    = sum(rp $ xwFlag(r,i,rp), etax.l(r,i,rp,%1) * m_true3(pwe,r,i,rp,%1) * m_true3(xw,r,i,rp,%1) )
    / sum(rp $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,%1) * m_true3(xw,r,i,rp,%1) ) ;


*   Efficient Capital to efficient Labour

* Efficient capital is not normalized e.g. not divided by chiKaps0(r))

LOOP(t0,
    kaplab.fx(r,%1)
        = sum((a,v) $ kFlag(r,a),
            [m_CESadj * m_pkp(r,a,v,t0) / lambdak.l(r,a,v,t0)]
            * lambdak.l(r,a,v,%1) * TFP_fp.l(r,a,%1) * m_true3vt(kv,r,a,v,%1))
        / sum((a,l) $ labFlag(r,l,a), lambdal.l(r,l,a,%1) * TFP_fp.l(r,a,%1)
            * [m_CESadj * m_wagep(r,l,a,t0) / lambdal.l(r,l,a,t0)]
            * m_true3t(ld,r,l,a,%1)) ;
) ;

*   Re-Calculate all efficiency growth rates (for alternative simulations)

*--> No scales on these variables so this is correct

If(ifCal,

    yexo(r,a,v,%1)    = m_gpct(lambdat.l,'r,a,v',%1)    ;
    g_nrf(r,a,v,%1)   = m_gpct(lambdanrf.l,'r,a,v',%1)  ;
    g_kt(r,a,v,%1)    = m_gpct(lambdak.l,'r,a,v',%1)    ;
    g_l(r,l,a,%1)     = m_gpct(lambdal.l,'r,l,a',%1)    ;
    g_xpx(r,a,v,%1)    = m_gpct(TFP_xpx.l,'r,a,v',%1)    ;
    g_xs(r,i,%1)      = m_gpct(TFP_xs.l,'r,i',%1)       ;
    g_io(r,i,a,%1)    = m_gpct(lambdaio.l,'r,i,a',%1)   ;
    aeei(r,e,a,v,%1)  = m_gpct(lambdae.l,'r,e,a,v',%1)  ;
    aeeic(r,e,k,h,%1) = m_gpct(lambdace.l,'r,e,k,h',%1) ;

) ;

*------------------------------------------------------------------------------*
*               Update NDC by adjusting to model emissions                     *
*------------------------------------------------------------------------------*

* #todo Check This

$IfTheni.DynCalENV %DynCalMethod%=="OECD-ENV"
    $$IfTheni.GhgCal %cal_GHG%=="ON"
        $$IfTheni.NDCtgt  NOT %BaseYearCW%=="OFF"

            If(IfDyn and year eq %BaseYearCW%,

                NDC2030(r,"GHG_Lulucf")
                    $ (NDC2030(r,"GHG_Lulucf") and GHG%BaseYearCW%(r,"GHG_Lulucf"))
                    = NDC2030(r,"GHG_Lulucf")
                    * [sum(em, m_true2(emiTot,r,em,"%BaseYearCW%")) / cScale]
                    / GHG%BaseYearCW%(r,"GHG_Lulucf");

                NDC2030(r,"GHG") $ (NDC2030(r,"GHG") and GHG%BaseYearCW%(r,"GHG"))
                    = NDC2030(r,"GHG")
                    * [   sum(em, m_true2(emiTot,r,em,"%BaseYearCW%")) / cScale
                        - sum((co2,a), m_true4(emi,r,co2,"lulucf",a,"%BaseYearCW%"))
						  / cScale
				    ] / GHG%BaseYearCW%(r,"GHG");

                NDC2030(r,"CO2") $ (NDC2030(r,"CO2") and GHG%BaseYearCW%(r,"CO2"))
                    = NDC2030(r,"CO2")
                    * [ sum((aa,EmiSource) $ (NOT tota(aa) and (NOT emiagg(EmiSource))
											 AND (NOT emilulucf(EmiSource))),
							m_true4(emi,r,"CO2",EmiSource,aa,"%BaseYearCW%"))
							/ cScale
					  ] / GHG%BaseYearCW%(r,"CO2") ;

                IF(1, EXECUTE_UNLOAD "NDC_Adj.gdx", NDC2030 ; ) ;

        ) ;

        $$Endif.NDCtgt
    $$Endif.GhgCal
$Endif.DynCalENV

$OffDotL
