$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%ModelDir%\26-macros.gms"
   purpose     : Group all macros used in the model in an unique file
                 Macros are expressed with superscript "m_"
   created date: 2021-oct-28
   created by  : Dominique van der Mensbrugghe --> macros for [ENVISAGE]
                 Jean Chateau                  --> macros for [OECD-ENV]
   called by   : %ModelDir%\2-CommonIns.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/26-macros.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*                      OECD-ENV Macros                                         *
*------------------------------------------------------------------------------*

$macro m_horizonSim(t) between2(t,"%YearStart%","%YearEndofSim%")

*	1.) Macros to transform normalized variables into true variables

* 1.1.) Standard macro

* Exple: m_true2(px(r,a,t)) --> [px(r,a,t) * px0(r,a)]

$macro m_true1(Nom,i1,t)          [&Nom(i1,t) * &Nom&0(i1) ]
$macro m_true2(Nom,i1,i2,t)       [&Nom(i1,i2,t) * &Nom&0(i1,i2) ]
$macro m_true3(Nom,i1,i2,i3,t)    [&Nom(i1,i2,i3,t) * &Nom&0(i1,i2,i3)]
$macro m_true4(Nom,i1,i2,i3,i4,t) [&Nom(i1,i2,i3,i4,t) * &Nom&0(i1,i2,i3,i4)]

* 1.2.) macro with subscript: "_bau", "_tgt", "_ref" or "_SUB"

* Exple: m_true2b(emiTot,ref,r,em,t) --> [emiTot_ref(r,em,t) * emiTot0(r,em)]

$macro m_true1b(Nom,subs,i1,t)          [&Nom&_&subs(i1,t) * &Nom&0(i1) ]
$macro m_true2b(Nom,subs,i1,i2,t)       [&Nom&_&subs(i1,i2,t) * &Nom&0(i1,i2) ]
$macro m_true3b(Nom,subs,i1,i2,i3,t)    [&Nom&_&subs(i1,i2,i3,t) * &Nom&0(i1,i2,i3)]
$macro m_true4b(Nom,subs,i1,i2,i3,i4,t) [&Nom&_&subs(i1,i2,i3,i4,t) * &Nom&0(i1,i2,i3,i4)]

* 1.3.) macro for dynamic scaled variables

* Exple:  m_true2t(xp,r,a,t) --> [xp(r,a,t) * xp0(r,a,t) ]

$macro m_true2t(Nom,i1,i2,t)       [&Nom(i1,i2,t) * &Nom&0(i1,i2,t) ]
$macro m_true3t(Nom,i1,i2,i3,t)    [&Nom(i1,i2,i3,t) * &Nom&0(i1,i2,i3,t)]
$macro m_true4t(Nom,i1,i2,i3,i4,t) [&Nom(i1,i2,i3,i4,t) * &Nom&0(i1,i2,i3,i4,t)]

* 1.4.) macro for vintage variables: m_true3v

* Exple: m_true3v(pk,r,a,v,t) --> [pk0(r,a) * pk(r,a,v,t)]

$macro m_true3v(Nom,i1,i2,i3,t)    [&Nom(i1,i2,i3,t) * &Nom&0(i1,i2) ]
$macro m_true4v(Nom,i1,i2,i3,i4,t) [&Nom(i1,i2,i3,i4,t) * &Nom&0(i1,i2,i3)]

* 1.5.) macro for vintage and dynamic-scaled variables

$macro m_true3vt(Nom,i1,i2,i3,t)    [&Nom(i1,i2,i3,t) * &Nom&0(i1,i2,t) ]
$macro m_true4vt(Nom,i1,i2,i3,i4,t) [&Nom(i1,i2,i3,i4,t) * &Nom&0(i1,i2,i3,t)]

* 1.6.) macro for for dynamic-scaled variables with subscript

$macro m_true2bt(Nom,bau,i1,i2,t)    [&Nom&_&bau(i1,i2,t) * &Nom&0(i1,i2,t) ]
$macro m_true3bt(Nom,bau,i1,i2,i3,t) [&Nom&_&bau(i1,i2,i3,t)*&Nom&0(i1,i2,i3,t)]

* 1.7.)  macro for vintage and dynamic-scaled variables with subscript

$macro m_true3bvt(Nom,bau,i1,i2,i3,t) [&Nom&_&bau(i1,i2,i3,t) * &Nom&0(i1,i2,t)]

*	2.)	Indirect and Production Tax rates adjusted for endogenous chiVAT

$macro m_paTax(r,i,aa,t)                                             \
    [  {paTax(r,i,aa,t)} $ {AdjTaxCov(r,i,aa) eq 0}                  \
     + {paTax(r,i,aa,t) * chiVAT(r,t) } $ {AdjTaxCov(r,i,aa) eq 1}   \
     + {paTax(r,i,aa,t) + chiVAT(r,t) } $ {AdjTaxCov(r,i,aa) eq 2} ] \

$macro m_pTax(r,a,t)                                                      \
  [sum(tot, {pTax(r,a,t)} $ {AdjTaxCov(r,tot,a) eq 0}                     \
          + {pTax(r,a,t) * chiPtax(r,t) } $ {AdjTaxCov(r,tot,a) eq 1}     \
          + {pTax(r,a,t) + chiPtax(r,t) } $ {AdjTaxCov(r,tot,a) eq 2} ) ] \

* [TBU]: No OAP

$macro m_uc(r,a,v,t) [ uc(r,a,v,t)                                             \
            + sum(em $ emia_IntTgt(r,a,em,t),                                  \
               emiaShadowPrice(r,a,em,t) * emia_IntTgt(r,a,em,t) ) / uc0(r,a) ]\

*	3.)  Macros on emission Coefficients (including Multiplicative factor)

* m_chiEmi: Adjustment to coefficient from calibration
*  base case: IfCalEmi = 0 --> m_chiEmi = 1

$macro m_chiEmi(r,em,EmiSource,aa,t)                                             \
 [1 + chiEmi(r,em,t) $ {IfCalEmi(r,em,EmiSource,aa) eq 1}                        \
    + chiTotEmi(r,t) $ {IfCalEmi(r,em,EmiSource,aa) eq 2}                        \
    + (chiEmiDet(r,em,EmiSource,aa,t) - 1) $ {IfCalEmi(r,em,EmiSource,aa) eq 3}] \

* Adjusted emission rates (here em to simplify but macro works for AllEmissions)

$macro m_emir(r,em,EmiSource,aa,t)                               \
    [m_chiEmi(r,em,EmiSource,aa,t) * emir(r,em,EmiSource,aa,t)]  \

$macro m_emird(r,em,EmiSource,aa,t)                              \
    [m_chiEmi(r,em,EmiSource,aa,t) * emird(r,em,EmiSource,aa,t)] \

$macro m_emirm(r,em,EmiSource,aa,t)                              \
    [m_chiEmi(r,em,EmiSource,aa,t) * emirm(r,em,EmiSource,aa,t)] \

*	4.)  Macros on emission pricing

* Emission price: USD by unit of emission (ie not corrected for emission coeff.)

$macro m_EmiPrice(r,em,emiSrc,aa,t)                              \
  [  part(r,em,emiSrc,aa,t) * (emiTax(r,em,t) + acTax(r,aa,t)) \
   + p_emissions(r,em,emiSrc,aa,t)]                            \

*	Macros on effective carbon price "m_Permis.."

* Carbon Permits on input-use: adjusted for carbon content
*	--> tax for one usd of input purchased

$macro m_Permis(r,i,aa,t)  sum((em,EmiUse) $ mapiEmi(i,EmiUse),                \
                      m_emir(r,em,EmiUse,aa,t) * m_EmiPrice(r,em,EmiUse,aa,t)) \

$macro m_Permisd(r,i,aa,t) sum((em,EmiUse) $ mapiEmi(i,EmiUse),                \
                     m_emird(r,em,EmiUse,aa,t) * m_EmiPrice(r,em,EmiUse,aa,t)) \

$macro m_Permism(r,i,aa,t) sum((em,EmiUse) $ mapiEmi(i,EmiUse),               \
                    m_emirm(r,em,EmiUse,aa,t) * m_EmiPrice(r,em,EmiUse,aa,t)) \
                                                                              \
* Carbon price on primary factor use:

$macro m_Permisfp(r,fp,aa,t) sum((em,EmiFp) $ mapFpEmi(fp,EmiFp),          \
                    m_emir(r,em,EmiFp,aa,t) * m_EmiPrice(r,em,EmiFp,aa,t)) \

* Carbon price on emission process when no MAC curves "m_Permisact(r,a,t)"

* #todo check OAP in some expressions below
* [TBC]: Check correspondance of emir to xpv and xp if uctax non-zero

$macro m_Permisact(r,a,t)                                                 \
    sum((em,emiact), m_emir(r,em,emiact,a,t) * m_EmiPrice(r,em,emiact,a,t)) \

* Shadow permit GHGs (ie em)

$macro m_ShadowPermis(r,i,aa,t)                                               \
   sum(em $ emia_IntTgt(r,aa,em,t), emiaShadowPrice(r,aa,em,t)                \
 * sum(mapiEmi(i,EmiUse), part(r,em,EmiUse,aa,t) * emir(r,em,EmiUse,aa,t)) )  \

$macro m_pemi(r,em,emiact,a,t)                                                 \
 [   m_EmiPrice(r,em,emiact,a,t)                                                 \
  + emiaShadowPrice(r,a,em,t) $ {part(r,em,emiact,a,t) AND emia_IntTgt(r,a,em,t)} ] \

* Power sectors emissions feebates "CO2"

$macro m_feebate(r,em,EmiSourceAct,a,t) {chiPtax(r,t) *                      \
                [ m_true4(emi,r,em,EmiSourceAct,a,t) / m_true2t(xp,r,a,t)    \
                    - sum(powa.local, m_true4(emi,r,em,EmiSourceAct,powa,t)) \
                    / sum(powa.local,m_true2t(xp,r,powa,t)) ]}               \

$macro m_RenewTgt(r,t) [ RenewTgt(r,t)$ {NOT IfElyCES} + Renew(r,t)$ IfElyCES ]

* Macros on effective carbon emissions : part * emi

$macro m_EffEmi(r,EmSingle,EmiSource,aa,t)  \
* [part(r,EmSingle,EmiSource,aa,t) * m_true4(emi,r,EmSingle,EmiSource,aa,t)]   \
 ( m_true4(emi,r,EmSingle,EmiSource,aa,t)									   \
  * [ part(r,EmSingle,EmiSource,aa,t) $ {part(r,EmSingle,EmiSource,aa,t) le 1} \
	 + 1 $ {part(r,EmSingle,EmiSource,aa,t) gt 1} ] )                          \

$macro m_EffEmiRef(r,ref,em,EmiSource,aa,t)  \
    part(r,EmSingle,EmiSource,aa,t) * m_true4b(emi,ref,r,em,EmiSource,aa,t) \

*	Adjustment of primary factor efficiencies for TFP_fp shock

$macro m_lambdat(r,a,v,t)   [TFP_fp(r,a,t) * lambdat(r,a,v,t)]
$macro m_lambdak(r,a,v,t)   [TFP_fp(r,a,t) * lambdak(r,a,v,t)]
$macro m_lambdal(r,l,a,t)   [TFP_fp(r,a,t) * lambdal(r,l,a,t)]
$macro m_lambdanrf(r,a,v,t) [TFP_fp(r,a,t) * lambdanrf(r,a,v,t)]

*	Macro for adjusting dynamic scales

$macro m_resc1t(varName,a,suffix,t,tt)                              \
&varName&suffix(r,a,t) $(&varName.l(r,a,t) and &varName.l(r,a,t-1)) \
     = &varName&suffix(r,a,tt) * &varName.l(r,a,tt) ;               \
&varName.l(r,a,t) $ &varName.l(r,a,t) = 1 ;                         \

$Ontext
	memo: the macro m_resc1t(xp,a,0,tsim,tsim-1) will expand to:
	xp0(r,a,t) $(xp.l(r,a,tsim) and xp.l(r,a,tsim-1))
		= xp0(r,a,tsim-1) * xp.l(r,a,tsim-1) ;
	xp.l(r,a,tsim) $ xp.l(r,a,tsim) = 1 ;
$Offtext

$macro m_resc2t(varName,a,b,suffix,t,tt)                                  \
&varName&suffix(r,a,b,t) $(&varName.l(r,a,b,t) and &varName.l(r,a,b,t-1)) \
     = &varName&suffix(r,a,b,tt) * &varName.l(r,a,b,tt) ;                 \
&varName.l(r,a,b,t) $ &varName.l(r,a,b,tt) = 1 ;                          \

$macro m_resc1vt(varName,a,suffix,t,tt)  loop(vOld,                           \
&varName&suffix(r,a,t) $(&varName.l(r,a,vOld,t) and &varName.l(r,a,vOld,t-1)) \
     = &varName&suffix(r,a,tt) * &varName.l(r,a,vOld,tt) ) ;                  \
&varName.l(r,a,v,t) $ &varName.l(r,a,v,t) = 1 ;                               \

*	Miscellaneous macros

* Macro to simplify ajustment of coefficient for sum eq 1:
* WARNING should be placed at the end of the formula

$macro m_CESadj IfCoeffCes + (1 - IfCoeffCes)

* adjustment marginal propensity to consume in calibration mode

$macro m_beta(r,h,k,t) [betac(r,h,t) $ ifksav(r,k,h) + 1 $ {NOT ifksav(r,k,h)}]

* Employment by skill and location

$macro m_ETPT(r,l,z,t)                                                      \
    [ LFPR(r,l,z,t) * [ 1 - 0.01 * UNR(r,l,z,t)] * m_true3(popWA,r,l,z,t) ] \

*	Macros to Clear some variable and parameters

* clear all working parameters

$macro m_clearWork OPTION clear=vol, clear=rworkT, clear=risjswork, 	      \
  clear=riswork, clear=riswork2,  clear=risjsworkt, clear=rawork,   	      \
  clear=rwork_bis, clear=rwork,											      \
  clear=riskwork, clear=raagtwork, clear=risworkT, clear=tprice, clear=price; \

$macro m_clearClimFlag                                                        \
  IfCap(rq) = 0 ; emFlag(r,AllEmissions) = 0 ; IfEmCap(rq,AllEmissions) = 0 ; \

$macro m_clearClimPol(t) m_clearClimFlag IfAllowance(r) = 0 ;     \
  part(r,AllEmissions,EmiSource,aa,t) = 0 ; stringency(r,t) = 0 ; \

$macro m_clearFullClimPol(t)       							  \
  m_clearClimPol(t)                							  \
  emiCap.l(rq,AllEmissions,t) = 0 ; emiCapFull.l(rq,t) = 0 ;  \

$macro m_RedPart(t) 									   \
  part(r,em,EmiSourceIna,aa,t) = 0 ;                       \
  part(r,AllEmissions,EmiSource,a,t) $ tota(a) = 0 ;       \
  part(r,OAP,EmiSource,aa,t) = 0 ;                         \
  part(r,HighGWP,EmiSource,aa,t) $ ifGroupFGas       = 0 ; \
  part(r,Fgas,EmiSource,aa,t)    $ (NOT ifGroupFGas) = 0 ; \
  part(r,AllEmissions,EmiSourceAct,aa,t) $ (emi0(r,AllEmissions,EmiSourceAct,aa) eq 0) = 0 ; \
  part(r,em,EmiUse,aa,t) $ (NOT emir(r,em,EmiUse,aa,t))  = 0 ;  \

$macro m_DefaultSimOpt                                                        \
IfSaveYr = 0 ; IfLoadYr = 0 ; IfReRun = 0 ; IfCutInpart = 0 ; IfCleanXP = 0 ; \
IfUnLoadBeforeSim = 0 ; \
$IFI %IfSlicing%=="ON" IfSlicing = 0 ; IfSlicingSolverSwitch = 0 ; IfDebugSlicing = 0 ;  \


* Conversion factor for emissions

$macro m_ConvGHG  (cScale *( 1 $ {not ifCEQ} + (12/44) $ ifCEQ))

* convert emiTax into USD of year %YearUSDCT%

$macro m_convCtax  [1 / ( cScale * ConvertCurToModelUSD("%YearUSDCT%") )]

*	Macros on Gross Factor remuneration paid by Firms at Agent Prices

$macro m_netTaxfp(r,a,fp,t) [Taxfp(r,a,fp,t) - Subfp(r,a,fp,t)]

* special case for capital because of vintages
* ktax (= netTaxcap for ENV-Linkages)

$macro m_ktax(r,a,cap,v,t) [adjKTaxfp(r,cap,a,v) * Taxfp(r,a,cap,t) - adjKSubfp(r,cap,a,v) * Subfp(r,a,cap,t)]

* [EditJean]: WAGEP_SUB = m_wagep dans EL
* in ENV-Linkages defined differently unscaled / ENVISAGE scaled
* [TBC]: check m_Permisfp dans les secondes expressions

$macro m_pkp(r,a,v,t) \
    [  { (1 + sum(cap,m_ktax(r,a,cap,v,t))) * m_true3v(pk,r,a,v,t)         \
         + sum(cap,m_Permisfp(r,cap,a,t)) } $ IfSub         \
     + { m_true3v(pkp,r,a,v,t)            } $ {not IfSub} ] \
*    [ {(1 + sum(cap.local, m_netTaxcap(r,a,cap,v,t))) * m_true3v(pk,r,a,v,t)  \
*        + sum(cap.local,m_Permisfp(r,cap,a,t)) } $ IfSub \
*    + {m_true3v(pkp,r,a,v,t)                      } $ {not IfSub} ]   \

* nominal net wage received by hh including personal tax, corrected by
* some adjustement --> Only for use in Labour supply function

* [TBC] pourquoi pas ewagez(r,l,z,t) instead of twage(r,l,t)

$macro m_netwage(r,l,z,t)                                                      \
  {m_true2(twage,r,l,t)                                                        \
    * [1 - kappal(r,l,t)] $ {WageIndexRule(r) ge 0}                            \
    * [1 - kappah(r,t) $ {(WageIndexRule(r) eq 1) or (WageIndexRule(r) eq 2)} ]\
    * [1 - 0.01 * UNR(r,l,z,t) $ {WageIndexRule(r) eq 2}]                      \
    / [1 - kappal(r,l,t)       $ {WageIndexRule(r) eq 3}] }                    \

*------------------------------------------------------------------------------*
*                       ENVISAGE Macros                                        *
*------------------------------------------------------------------------------*

*	Define macros for variable substitution

* Price with tax inclusive (memo: base case IfSub = 1), [TBU]: No OAP

$macro PP_SUB(r,a,t)                                                       	\
   [{   [m_true2(px,r,a,t) + pim(r,a,t)] * (1 + m_pTax(r,a,t)) / pp0(r,a)  	\
       + sum((em,EmiSourceAct) $ ifPowFeebates(r,em,EmiSourceAct),         	\
                    m_feebate(r,em,EmiSourceAct,a,t) / pp0(r,a)) $ powa(a) 	\
	   - [PP_permit(r,a,t) / pp0(r,a) ] $ IfAllowance(r) } $ IfSub  		\
    + {pp(r,a,t)} $ {not IfSub} ]                                          	\

$macro PA_SUB(r,i,aa,t)                                                                       \
 [ { (1 + m_paTax(r,i,aa,t)) * gammaeda(r,i,aa) * m_true2(pat,r,i,t) / pa0(r,i,aa)            \
+ (m_Permis(r,i,aa,t) + m_ShadowPermis(r,i,aa,t)) / pa0(r,i,aa)} $ {IfArmFlag eq 0 and IfSub} \
+ {pa(r,i,aa,t)} $ {IfArmFlag or (IfArmFlag eq 0 and not IfSub)}  ]                           \

$macro PD_SUB(r,i,aa,t)  [  {(1 + pdTax(r,i,aa,t))*gammaedd(r,i,aa)           \
                                * m_true2(pdt,r,i,t) / pd0(r,i,aa)            \
                                + m_Permisd(r,i,aa,t) / pd0(r,i,aa)} $ IfSub  \
                          + {pd(r,i,aa,t)} $ {not IfSub} ]                    \

$macro PM_SUB(r,i,aa,t)  [  {(1 + pmTax(r,i,aa,t))*gammaedm(r,i,aa)           \
                                    * m_true2(pmt,r,i,t) / pm0(r,i,aa)        \
                                + m_Permism(r,i,aa,t) / pm0(r,i,aa)} $ IfSub  \
                          + {pm(r,i,aa,t)} $ {not IfSub} ]                    \

$macro PWE_SUB(r,i,rp,t)  [ { (1 + etax(r,i,rp,t)) * m_true3(pe,r,i,rp,t)     \
                             / pwe0(r,i,rp) } $ IfSub                         \
                             + pwe(r,i,rp,t)  $ {not IfSub}]                  \

$macro PWMG_SUB(r,i,rp,t) [ sum(img $ amgm(img,r,i,rp),                       \
                                  amgm(img,r,i,rp) * m_true1(ptmg,img,t)      \
                                / [lambdamg(img,r,i,rp,t) * pwmg0(r,i,rp)]    \
                                ) $ IfSub                                     \
                           + pwmg(r,i,rp,t) $ {NOT IfSub}  ]                  \

$macro PWM_SUB(r,i,rp,t)  [ { [ PWE_SUB(r,i,rp,t) * pwe0(r,i,rp)              \
                                + tmarg(r,i,rp,t) * PWMG_SUB(r,i,rp,t)]       \
                              / [ lambdaw(r,i,rp,t) * pwm0(r,i,rp)] } $ IfSub \
                           + pwm(r,i,rp,t) $ {NOT IfSub}    ]                 \

$macro PDM_SUB(r,i,rp,t)  [ { (1 + mtax(r,i,rp,t)) * PWM_SUB(r,i,rp,t)        \
                                 * (pwm0(r,i,rp) / pdm0(r,i,rp)) } $ IfSub    \
                           + pdm(r,i,rp,t) $ {NOT IfSub}  ]                   \

$macro XWMG_SUB(r,i,rp,t) [ { tmarg(r,i,rp,t) * m_true3(xw,r,i,rp,t)          \
                               / xwmg0(r,i,rp)} $ IfSub                       \
                             + xwmg(r,i,rp,t)   $ {NOT IfSub} ]               \

$macro XMGM_SUB(img,r,i,rp,t)                                                 \
    [  {amgm(img,r,i,rp) * [XWMG_SUB(r,i,rp,t) * xwmg0(r,i,rp)]               \
         / [lambdamg(img,r,i,rp,t) * xmgm0(img,r,i,rp)] } $ IfSub             \
     + {xmgm(img,r,i,rp,t)} $ {NOT IfSub} ]                                   \

$macro m_wagep(r,l,a,t) [ (1 + m_netTaxfp(r,a,l,t)) * m_true3(wage,r,l,a,t) ]

$macro WAGEP_SUB(r,l,a,t) \
 [ {m_wagep(r,l,a,t) / wagep0(r,l,a)} $ IfSub + wagep(r,l,a,t) $ {NOT IfSub}] \

*	Profits: capital returns (not including overAcc) + mark_up - depreciation
*[TBU]: No OAP

$macro m_PureProfit(r,t) [ sum(a, pim(r,a,t) * m_true2t(xp,r,a,t) )   \
* profit from constraint on xap(e)
*  + sum((i,a), m_ShadowPermis(r,i,a,t) * m_true3(xa,r,i,a,t) )     \
* profit from constraint on emi
    + sum((a,em) $ emia_IntTgt(r,a,em,t),  m_true3(emia,r,a,em,t) * emiaShadowPrice(r,a,em,t) ) \
* profit from constraint on xp
*  - sum((a,em) $ emia_IntTgt(r,a,em,t), m_true2(xp,r,a,t) * emia_IntTgt(r,a,em,t) * emiaShadowPrice(r,a,em,t) )   \
    ] \

*$IF SET module_SectInv + sum((a,v), m_true(pkvs(r,a,v,t)) * m_true(kvs(r,a,v,t))) \

$macro m_PROFITS(r,t) \
    [   sum((a,v) $ kFlag(r,a), m_true3v(pk,r,a,v,t) * m_true3vt(kv,r,a,v,t)) \
      + m_PureProfit(r,t) - m_true1(deprY,r,t) ]                             \

$macro m_netInv(r,t) sum(inv, m_true2(yfd,r,inv,t) - depr(r,t) * m_true2(pfd,r,inv,t) * m_true1(kstock,r,t))

$macro m_netInvShr(r,t) [m_netInv(r,t) / sum(rp, m_netInv(rp,t))]

$macro m_logasc(r,t)                                                \
    [(grKMax(r,t) - grKTrend(r,t)) / (grkTrend(r,t) - grKMin(r,t))] \



