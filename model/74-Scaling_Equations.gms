$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file   : "%ModelDir%\74-Scaling_Equations.gms"
	purpose      : Scaling some equations
	Created by   : Jean Chateau
	Created date : 1 May 2021
	called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
    $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/74-Scaling_Equations.gms $
	last changed revision: $Rev: 391 $
	last changed date    : $Date:: 2023-09-08 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

IF(ord(tsim) eq 2,
    DISPLAY    "Equation scaling is active";
    put screen "Equation scaling is active" /;
    putclose screen;
);

$onDotL

*------------------------------------------------------------------------------*
*       Demand for energy carriers at Armington level [TBU] if needed          *
*------------------------------------------------------------------------------*
$OnText
xaeEQ(r,e,a,tsim)$(ts(t) and rs(r) and xaFlag(r,e,a))..
xa(r,e,a,tsim)
    =e= {(sum(v,aeio(r,e,a,v,tsim)*(xnrg(r,a,v,tsim)/lambdae(r,e,a,v,tsim))
         * (lambdae(r,e,a,v,tsim)*pnrg(r,a,v,tsim)/ m_true3(pa,r,e,a,tsim))**sigmae(r,a,v))
        }${not IfNrgNest(r,a)}
     +  {sum(v,sum(NRG$mape(NRG,e), aeio(r,e,a,v,tsim)*(lambdae(r,e,a,v,tsim)**(sigmaNRG(r,a,NRG,v)-1))
         * xaNRG(r,a,NRG,v,tsim)*(paNRG(r,a,NRG,v,tsim)/ m_true3(pa,r,e,a,tsim))**sigmaNRG(r,a,NRG,v)))
        }${IfNrgNest(r,a)}
;

$OffText

*------------------------------------------------------------------------------*
*                   Aggregate import price equation                            *
*------------------------------------------------------------------------------*
IF(IfScale_pmteq and ord(tsim) gt 2,
*    $$IfThen.dual %EQForm%=="DUAL"
        pmteq.scale(r,i,tsim) $ xmtFlag(r,i)
            = Max(Min(MaxEqScale,
                ABS[(1-sigmaw(r,i)) * (pmt.l(r,i,tsim))**(-sigmaw(r,i))]
              + sum(rp $ xwFlag(rp,i,r),
                    ABS[(1-sigmaw(r,i)) * alphaw(rp,i,r,tsim)
                        * ([pdm0(rp,i,r) / pmt0(r,i)]**(1-sigmaw(r,i)))
                        * (pdm.l(rp,i,r,tsim))**(-sigmaw(r,i))]
                  )
                ),0.001);
*    $$ENDIF.dual
);

*------------------------------------------------------------------------------*
*                          Land Demand Equation                                *
*------------------------------------------------------------------------------*
IF(IfScale_landeq,
    landeq.scale(r,a,tsim)
        $ (agra(a) and landFlag(r,a))
        = Min(MaxEqScale, sum(v, [aland(r,a,v,tsim) * [TFP_fp.l(r,a,tsim)*lambdat.l(r,a,v,tsim)]**(sigmav2(r,a,v)-1) / land0(r,a,tsim)]
*            * { [ (m_true3v(pva2,r,a,v,tsim) / m_plandp(r,a,tsim))**sigmav2(r,a,v) ]
            * { [ (m_true3v(pva2,r,a,v,tsim) / m_true2(pland,r,a,tsim))**sigmav2(r,a,v) ]
            + ABS[m_true3vt(va2,r,a,v,tsim) * sigmav2(r,a,v) * [m_true3v(pva2,r,a,v,tsim)/pland0(r,a)]**sigmav2(r,a,v) * pland.l(r,a,tsim)**(-1-sigmav2(r,a,v))]
*                + ABS[m_true3v(va2,r,a,v,tsim) * sigmav2(r,a,v) * [pva20(r,a,v)  / m_plandp(r,a,tsim)  ]**sigmav2(r,a,v) * pva2.l(r,a,v,tsim)**(sigmav2(r,a,v)-1)]
                + ABS[m_true3vt(va2,r,a,v,tsim) * sigmav2(r,a,v) * [pva20(r,a)  / m_true2(pland,r,a,tsim)  ]**sigmav2(r,a,v) * pva2.l(r,a,v,tsim)**(sigmav2(r,a,v)-1)]
                }));
);

*------------------------------------------------------------------------------*
*           Second level Armington demand (bilateral import demand)            *
*------------------------------------------------------------------------------*
IF(IfScale_xwdeq,
    xwdeq.scale(rp,i,r,tsim) $(xwFlag(rp,i,r) and pdm.l(rp,i,r,tsim))
        = Min(MaxEqScale,
            {alphaw(rp,i,r,tsim) * xmt0(r,i)
                * [(pmt0(r,i)/pdm0(rp,i,r))**sigmaw(r,i)]
                / [xw0(rp,i,r) * lambdaw(rp,i,r,tsim)]}
            * [(pmt.l(r,i,tsim)/pdm.l(rp,i,r,tsim))**sigmaw(r,i)]
            * { 1 + xmt.l(r,i,tsim) * sigmaw(r,i) * [1/pmt.l(r,i,tsim) + ABS(-1/pdm.l(rp,i,r,tsim))]}
            ) ;
);

*------------------------------------------------------------------------------*
*                       First level Armington demand                           *
*------------------------------------------------------------------------------*
IF(IfScale_xmteq,
*---    Import Demand
    xmteq.scale(r,i,tsim) $ (xmtFlag(r,i) and IfArmFlag eq 0)
        = Min(MaxEqScale,
            {alphamt(r,i,tsim) * (xat0(r,i,tsim)/xmt0(r,i))
                *  [lambdaxm(r,i,tsim)**(sigmamt(r,i)-1)]
                *  [(pat0(r,i)/pmt0(r,i))**sigmamt(r,i)]}
            * [(pat.l(r,i,tsim)/pmt.l(r,i,tsim))**sigmamt(r,i)]
            * { 1 + xat.l(r,i,tsim) * sigmamt(r,i) * [1/pat.l(r,i,tsim) + ABS(-1/pmt.l(r,i,tsim))]}
        );
*---    Domestic Demand
*xdt(r,i,tsim)
*    =e= { alphadt(r,i,t)*[lambdaxd(r,i,t)**(sigmamt(r,i)-1)]
*         * [m_true(xat(r,i,t)) / scale_xdt(r,i,t)]
*         * [m_true(pat(r,i,t)) / m_true(pdt(r,i,t))]**sigmamt(r,i)}$xddFlag(r,i)
*     + m_true(xtt(r,i,t)) / scale_xdt(r,i,t);
);

*------------------------------------------------------------------------------*
*                    Top level Armington price equation                        *
*------------------------------------------------------------------------------*
IF(IfScale_pateq,
    pateq.scale(r,i,tsim) $ (xatFlag(r,i) and not IfArmFlag)
        = Min(MaxEqScale,
              ABS[(1-sigmamt(r,i)) * pat0(r,i)**(1-sigmamt(r,i)) * pat.l(r,i,tsim)**(-sigmamt(r,i))]
            + ABS[(1-sigmamt(r,i)) * alphadt(r,i,tsim) * [pdt0(r,i) / lambdaxd(r,i,tsim)]**(1-sigmamt(r,i)) * pdt.l(r,i,tsim)**(-sigmamt(r,i)) ] $ {pdt0(r,i) and xdtFlag(r,i)}
            + ABS[(1-sigmamt(r,i)) * alphamt(r,i,tsim) * [pmt0(r,i) / lambdaxm(r,i,tsim)]**(1-sigmamt(r,i)) * pmt.l(r,i,tsim)**(-sigmamt(r,i)) ] $ pmt0(r,i)
        );
);

*------------------------------------------------------------------------------*
*           Supply for technology a to produce i                               *
*------------------------------------------------------------------------------*
IF(IfScale_xeq,
    xeq.scale(r,a,i,tsim)
        $ (gp(r,a,i) and omegas(r,a) ne inf)
        = [gp(r,a,i) * (xp0(r,a,tsim) / x0(r,a,i,tsim)) * (p0(r,a,i) / pp0(r,a))**omegas(r,a)]
        * [(p.l(r,a,i,tsim) / pp.l(r,a,tsim))**omegas(r,a)]
        * {  1 + xp.l(r,a,tsim) * omegas(r,a) * [1/p.l(r,a,i,tsim) + ABS(-1/pp.l(r,a,tsim)) ]};
);
$offdotl

*------------------------------------------------------------------------------*
*                       Price of energy bundles                                *
*------------------------------------------------------------------------------*
$OnText
paNRGEQ(r,a,NRG,v,t)$(ts(t) and rs(r) and xaNRGFlag(r,a,NRG) and IfNrgNest(r,a))..
   paNRG(r,a,NRG,v,t)**(1-sigmaNRG(r,a,NRG,v)) =e=
      sum(e$mape(NRG,e), (aeio(r,e,a,v,t)*(pa0(r,e,a)/paNRG0(r,a,NRG))**(1-sigmaNRG(r,a,NRG,v)))
         *(PA_SUB(r,e,a,t)/lambdae(r,e,a,v,t))**(1-sigmaNRG(r,a,NRG,v))) ;
IfScale_paNRGeq
$OffText

IF(IfScale_paNRGeq,
    paNRGeq.scale(r,a,NRG,v,tsim)$(xaNRGFlag(r,a,NRG) and IfNrgNest(r,a))
        = Min(MaxEqScale,
                  ABS[(1-sigmaNRG(r,a,NRG,v)) * paNRG0(r,a,NRG)**(1-sigmaNRG(r,a,NRG,v)) * paNRG.l(r,a,NRG,v,tsim)**(-sigmaNRG(r,a,NRG,v))]
                + sum(e $ mape(NRG,e),
                    ABS[  (1-sigmaNRG(r,a,NRG,v)) * aeio(r,e,a,v,tsim)
                        * (pa0(r,e,a)/[paNRG0(r,a,NRG)*lambdae.l(r,e,a,v,tsim)])**(1-sigmaNRG(r,a,NRG,v))
                        * pa.l(r,e,a,tsim)**(-sigmaNRG(r,a,NRG,v)) ]
                     )
             );
*        = 10**round(log10(
*            max(abs((1-sigmaNRG(r,a,NRG,v))*paNRG.l(r,a,NRG,v,tsim)**(-sigmaNRG(r,a,NRG,v))),
*            smax(e, abs((1-sigmaNRG(r,a,NRG,v))*aeio(r,e,a,v,tsim)*((paScale(r,e)/lambdae.l(r,e,a,v,tsim))**(1-sigmaNRG(r,a,NRG,v)))*paa.l(r,e,a,tsim)**(-sigmaNRG(r,a,NRG,v))))
*        )));
);


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*--- BELOW ARE THE INSTRUCTION OF THE ENVISAGE FILE scale.gms that was inactive!
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

$OnText
* --------------------------------------------------------------------------------------------------
*
*  Price of energy bundles
*
* --------------------------------------------------------------------------------------------------


*paNRGEQ(r,a,NRG,v,t)$(ts(t) and rs(r) and xaNRGFlag(r,a,NRG) and IfNrgNest)..
*   paNRG(r,a,NRG,v,t)**(1-sigmaNRG(r,a,NRG,v)) =e= sum(e$mape(NRG,e),
*      aeio(r,e,a,v,t)*(PAA_SUB(r,e,a,t)/lambdae(r,e,a,v,t))**(1-sigmaNRG(r,a,NRG,v))) ;

paNRGeq.scale(r,a,NRG,v,tsim)$(xaNRGFlag(r,a,NRG) and IfNrgNest) = 10**round(log10(
   max(abs((1-sigmaNRG(r,a,NRG,v))*paNRG.l(r,a,NRG,v,tsim)**(-sigmaNRG(r,a,NRG,v))),
       smax(e, abs((1-sigmaNRG(r,a,NRG,v))*aeio(r,e,a,v,tsim)*((paScale(r,e)/lambdae.l(r,e,a,v,tsim))**(1-sigmaNRG(r,a,NRG,v)))*paa.l(r,e,a,tsim)**(-sigmaNRG(r,a,NRG,v))))
      )
)) ;

* --------------------------------------------------------------------------------------------------
*
*  Demand for energy carriers at Armington level
*
* --------------------------------------------------------------------------------------------------

*xaeEQ(r,e,a,t)$(ts(t) and rs(r) and xaFlag(r,e,a))..
*   xa(r,e,a,t) =e= (sum(v,aeio(r,e,a,v,t)*(xnrg(r,a,v,t)/lambdae(r,e,a,v,t))
*                *     (lambdae(r,e,a,v,t)*pnrg(r,a,v,t)/PAA_SUB(r,e,a,t))**sigmae(r,a,v)))$(not IfNrgNest)
*                +  (sum(v,sum(NRG$mape(NRG,e), aeio(r,e,a,v,t)*(lambdae(r,e,a,v,t)**(sigmaNRG(r,a,NRG,v)-1))
*                *     xaNRG(r,a,NRG,v,t)*(paNRG(r,a,NRG,v,t)/PAA_SUB(r,e,a,t))**sigmaNRG(r,a,NRG,v))))$(IfNrgNest)
*      ;

IF(IfNrgNEST,
   xaeeq.scale(r,e,a,tsim)$xaFlag(r,e,a) = 10**round(log10(
      max(1, smax(v,
         max(abs(sum(NRG$mape(NRG,e), aeio(r,e,a,v,tsim)*(lambdae.l(r,e,a,v,tsim)**(sigmaNRG(r,a,NRG,v)-1))*((paNRG.l(r,a,NRG,v,tsim)/(paScale(r,e)*paa.l(r,e,a,tsim)))**sigmaNRG(r,a,NRG,v)))),
             abs(sum(NRG$mape(NRG,e), sigmaNRG(r,a,NRG,v)*xaNRG.l(r,a,NRG,v,tsim)*(paNRG.l(r,a,NRG,v,tsim)**(sigmaNRG(r,a,NRG,v)-1))*aeio(r,e,a,v,tsim)*(lambdae.l(r,e,a,v,tsim)**(sigmaNRG(r,a,NRG,v)-1))*(paScale(r,e)*paa.l(r,e,a,tsim))**(-sigmaNRG(r,a,NRG,v)))),
             abs(sum(NRG$mape(NRG,e), xaNRG.l(r,a,NRG,v,tsim)*(paNRG.l(r,a,NRG,v,tsim)**sigmaNRG(r,a,NRG,v))*sigmaNRG(r,a,NRG,v)*aeio(r,e,a,v,tsim)*(lambdae.l(r,e,a,v,tsim)**(sigmaNRG(r,a,NRG,v)-1))
                  * (paScale(r,e)**sigmaNRG(r,a,NRG,v))*(paa.l(r,e,a,tsim)**(-sigmaNRG(r,a,NRG,v)-1))))
         )
      ))
   )) ;
) ;

* --------------------------------------------------------------------------------------------------
*
*  Aggregate import price equation
*
* --------------------------------------------------------------------------------------------------

*pmtEQ(r,i,t)$(ts(t) and xmtFlag(r,i))..
*   PMT_SUB(r,i,t)**(1-sigmaw(r,i)) =e= sum(rp, alphaw(rp,i,r,t)*PM_SUB(rp,i,r,t)**(1-sigmaw(r,i))) ;
*
*pmteq.scale(r,i,tsim)$xmt.l(r,i,tsim) = 10**round(log10(
*   smax(rp, abs(alphaw(rp,i,r,tsim)*(psScale(rp,i)**(1-sigmaw(r,i)))
*                                   *(pm.l(rp,i,r,tsim))**(-sigmaw(r,i)))),
*       abs((sigmaw(r,i)-1)*(paScale(r,i)**(1-sigmaw(r,i)))*(pmt.l(r,i,tsim))**(-sigmaw(r,i)))
*   )
*)) ;

*pmtEQ(r,i,t)$(ts(t) and xmtFlag(r,i))..
*   PMT_SUB(r,i,t) =e= sum(rp, alphaw(rp,i,r,t)*PM_SUB(rp,i,r,t)**(1-sigmaw(r,i)))**(1-sigmaw(r,i)) ;

pmteq.scale(r,i,tsim)$xmt.l(r,i,tsim) = 10**round(log10(
         smax(rp, abs(psScale(rp,i)*pm.l(rp,i,r,tsim)*xw.l(rp,i,r,tsim)/xeScale(rp,i)))
      /     sum(rp,psScale(rp,i)*pm.l(rp,i,r,tsim)*xw.l(rp,i,r,tsim)/xeScale(rp,i))
)) ;

* --------------------------------------------------------------------------------------------------
*
*  Second level Armington demand (bilateral import demand)
*
* --------------------------------------------------------------------------------------------------

*xwdEQ(rp,i,r,t)$(ts(t) and (rs(r) or rs(rp)) and xwFlag(rp,i,r))..
*   (lambdaw(rp,i,r,t)*xw(rp,i,r,t)/xeScale(rp,i)) =e= alphaw(rp,i,r,t)*xmt(r,i,t)*(PMT_SUB(r,i,t)/PM_SUB(rp,i,r,t))**sigmaw(r,i) ;

xw.scale(r,i,rp,tsim)$xwFlag(r,i,rp) = 10**round(log10(xw.l(r,i,rp,tsim))) ;

xwdeq.scale(rp,i,r,tsim)$xwFlag(rp,i,r) = 10**round(log10(
   xw.l(rp,i,r,tsim)*(lambdaw(rp,i,r,tsim)/xeScale(rp,i))
      * max(1,
         abs(sigmaw(r,i)/pm.l(rp,i,r,tsim)),
         abs(sigmaw(r,i)/pmt.l(r,i,tsim)),
         abs(1/xmt.l(r,i,tsim))
      )
)) ;

* --------------------------------------------------------------------------------------------------
*
*  Top level Armington price equation
*
* --------------------------------------------------------------------------------------------------

*paEQ(r,i,t)$(ts(t) and xatFlag(r,i))..
*   PA_SUB(r,i,t)**(1-sigmam(r,i)) =e= alphad(r,i,t)*PD_SUB(r,i,t)**(1-sigmam(r,i))
*                                   +  alpham(r,i,t)*PMT_SUB(r,i,t)**(1-sigmam(r,i)) ;

paeq.scale(r,i,tsim)$xat.l(r,i,tsim) = 10**round(log10(
   max(abs((sigmam(r,i)-1)*(paScale(r,i)**(1-sigmam(r,i)))*(pa.l(r,i,tsim)**(-sigmam(r,i)))),
       abs((sigmam(r,i)-1)*alphad(r,i,tsim)*(psScale(r,i)**(1-sigmam(r,i)))*(pd.l(r,i,tsim)**(-sigmam(r,i)))),
       abs((sigmam(r,i)-1)*alpham(r,i,tsim)*(paScale(r,i)**(1-sigmam(r,i)))*(pmt.l(r,i,tsim)**(-sigmam(r,i))))
   )
)) ;

* --------------------------------------------------------------------------------------------------
*
*  Investment growth factor equation
*
* --------------------------------------------------------------------------------------------------

*invGFactEQ(r,t)$(ts(t) and rs(r))..
*   invGFact(r,t)*((sum(inv, xfd(r,inv,t)/xfd(r,inv,t-1)))**(1/gap(t)) - 1 + depr(r,t)) =e= 1 ;
*
*invGFacteq.scale(r,tsim) = 10**round(log10(
*   max(abs(1/invGFact.l(r,tsim)),
*       abs((1 + invGFact.l(r,tsim)*(1 - depr(r,tsim)))/(gap(tsim)*xfd.l(r,inv,t)))
*   )
*)) ;

* --------------------------------------------------------------------------------------------------
*
*  Scale aggregate domestic absorption variables
*
* --------------------------------------------------------------------------------------------------

xfd.scale(r,fd,tsim) = 10**(round(log10(xfd.l(r,fd,tsim)))) ;
yfd.scale(r,fd,tsim) = 10**(round(log10(yfd.l(r,fd,tsim)))) ;
x.scale(r,a,i,tsim)$gp(r,a,i) = 10**(round(log10(x.l(r,a,i,tsim)))) ;

*gdpmpeq.scale(r,tsim)    = 1000 ;
*rgdpmpeq.scale(r,tsim)   = 1000 ;
*rgdppceq.scale(r,tsim)   = 1000 ;
*yheq.scale(r,tsim)       = 1000 ;
*ygoveq.scale(r,gy,tsim)  = 1000 ;

$OffText




