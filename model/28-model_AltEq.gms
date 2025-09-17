$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%ModelDir%\28-model_AltEq.gms"
   purpose     :  Group in a separate file all ENVISAGE equations
                  or model specifications
                  that are not core equations of OECD-ENV
   created date: 27 May 2022
   created by  : Jean Chateau
   called by   : %ModelDir%\2-CommonIns.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/28-model_AltEq.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*               PRODUCTION BLOCK: Water Factor Demand                          *
*------------------------------------------------------------------------------*

EQUATIONS
    xapIwEQ(r,i,a,t) "Armington demand for intermediate water commodity"
    pwatEQ(r,a,t)    "Price of water bundle"
    xwatEQ(r,a,t)    "Demand for water bundle"
    h2oEQ(r,a,t)     "Demand for water factor"
;

*------------------------------------------------------------------------------*
*           XWAT disaggregation: xwat = CES(h2o , xa(iw))                      *
*------------------------------------------------------------------------------*

* Equation (P-25): Demand for bundle XWAT

xwatEQ(r,a,t) $ (ts(t) and rs(r) and watFlag(r,a))..
 xwat(r,a,t)
    =e= sum(v, awat(r,a,v,t) * (m_true3vt(ksw,r,a,v,t) / xwat0(r,a) )
            * [m_true3v(pksw,r,a,v,t) / m_true2(pwat,r,a,t)]**sigmakw(r,a,v) ) ;

* Equation (X-X): Armington demand for intermediate water commodity

xapiwEQ(r,i,a,t) $ (ts(t) and rs(r) and xaFlag(r,i,a) and iw(i))..
 xa(r,i,a,t)  =e= aio(r,i,a,t) * (m_true2(xwat,r,a,t) / xa0(r,i,a,t))
          * lambdaio(r,i,a,t)**(sigmawat(r,a)-1)
          * [ m_true2(pwat,r,a,t) / m_true3b(pa,SUB,r,i,a,t)]**sigmawat(r,a)  ;


* Equation (X-X): Demand for the water factor

h2oEQ(r,a,t) $ (ts(t) and rs(r) and xwatfFlag(r,a))..
 h2o(r,a,t) =e= ah2o(r,a,t) * (m_true2(xwat,r,a,t) / h2o0(r,a))
             *  [lambdah2o(r,a,t)**(sigmawat(r,a)-1)]
             *  [m_true2(pwat,r,a,t) / m_true2(ph2op,r,a,t)]**sigmawat(r,a) ;


pwatEQ(r,a,t) $ (ts(t) and rs(r) and watFlag(r,a))..
 pwat(r,a,t)**(1-sigmawat(r,a))
   =e= sum(i $ iw(i),
      aio(r,i,a,t) * [m_true3b(pa,SUB,r,i,a,t) / (pwat0(r,a) * lambdaio(r,i,a,t)) ]**(1-sigmawat(r,a)) )
    +  ah2o(r,a,t) * [    m_true2(ph2op,r,a,t) / (pwat0(r,a) * lambdah2o(r,a,t))  ]**(1-sigmawat(r,a))
    ;

pwat.lo(r,a,t) = LowerBound ;

*------------------------------------------------------------------------------*
*                                                                              *
*                  Supply and  Market for water  : th2oFlag(r)                 *
*                                                                              *
*------------------------------------------------------------------------------*

EQUATIONS
   th2oEQ(r,t)             "Aggregate water supply"
   h2obndEQ(r,wbnd,t)      "Supply of water bundles"
   pth2ondxEQ(r,t)         "Aggregate water price index"
   pth2oEQ(r,t)            "Aggregate price of water"
   th2omEQ(r,t)            "Market water supply"
   ph2obndndxEQ(r,wbnd,t)  "Price index of water bundles"
   ph2obndEQ(r,wbnd,t)     "Price of water bundles"
   ph2oEQ(r,a,t)           "Supply of water to activities--determines market price"
;

$OnText


                     TH2OM = TH2O - ENV - GRD
                     /   \
                    /     \
                   /       \
                  /         \
               AGR           NAG
              /   \         /   \
             /     \       /     \
            /       \     /       \
          CRP       LVS  IND     MUN
         / | \
        /  |  \
       /   |   \
      Water demand
   by irrigated crops

$OffText

*  Total water supply

th2oEQ(r,t) $ (ts(t) and rs(r) and th2oFlag(r))..
   0 =e= (th2o(r,t) - (chih2o(r,t)/th2o0(r))*((pth2o(r,t)/pgdpmp(r,t))
      *                                       (pth2o0(r)/pgdpmp0(r)))**etaw(r))
      $(%WASS% eq KELAS)
      +  (th2o(r,t) - ((H2OMax(r,t)/th2o0(r))
      /     (1 + chih2o(r,t)*exp(-gammatw(r,t)*((pth2o(r,t)/pgdpmp(r,t))*(pth2o0(r)/pgdpmp0(r)))))))
      $(%WASS% eq LOGIST)

      +  (th2o(r,t) - ((H2OMax(r,t)/th2o0(r)) - (chih2o(r,t)/th2o0(r))
      *  ((pth2o(r,t)/pgdpmp(r,t))*(pth2o0(r)/pgdpmp0(r)))**(-gammatw(r,t))))
      $(%WASS% eq HYPERB)

      +  (pth2o(r,t) - pgdpmp(r,t)*(pgdpmp0(r)/pth2o0(r)))
      $(%WASS% eq INFTY)
      ;

*  Marketed water is equal to total water less exogenous demand

th2omEQ(r,t) $ (ts(t) and rs(r) and th2oFlag(r))..
   th2o(r,t) =e= th2om(r,t)*th2om0(r)/th2o0(r)
              +   sum(wbndEx, h2obnd(r,wbndEx,t)*h2obnd0(r,wbndEx)/th2o0(r)) ;

*  Demand for marketed water bundles -- both top level (wbnd1) and bottom level (wbnd2)

h2obndEQ(r,wbnd,t) $ (ts(t) and rs(r) and h2obndFlag(r,wbnd))..

*  Top level bundle

   0 =e= (h2obnd(r,wbnd,t) - (gam1h2o(r,wbnd,t)*(th2om0(r)/h2obnd0(r,wbnd))
      *     (ph2obnd0(r,wbnd)/pth2ondx0(r))**omegaw1(r))
      *     th2om(r,t)*(ph2obnd(r,wbnd,t)/pth2ondx(r,t))**omegaw1(r))
      $(wbnd1(wbnd) and omegaw1(r) ne inf)

      +  (ph2obnd(r,wbnd,t) - pth2o(r,t)*(pth2o0(r)/ph2obnd0(r,wbnd)))
      $(wbnd1(wbnd) and omegaw1(r) eq inf)

*  Second level bundle

      +  (sum(wbnd1$mapw1(wbnd1, wbnd),
            (h2obnd(r,wbnd,t)  - (gam2h2o(r,wbnd,t)*(h2obnd0(r,wbnd1)/h2obnd0(r,wbnd))
      *        (ph2obnd0(r,wbnd)/ph2obndndx0(r,wbnd1))**omegaw2(r,wbnd1))
      *        h2obnd(r,wbnd1,t)*(ph2obnd(r,wbnd,t)/ph2obndndx(r,wbnd1,t))**omegaw2(r,wbnd1))
      $(omegaw2(r,wbnd1) ne inf)

      +     (ph2obnd(r,wbnd,t) - ph2obnd(r,wbnd1,t)*(ph2obnd0(r,wbnd1)/ph2obnd0(r,wbnd)))
      $(omegaw2(r,wbnd1) eq inf)))$wbnd2(wbnd)
      ;

pth2ondxEQ(r,t) $ (ts(t) and rs(r) and th2oFlag(r) and omegaw1(r) ne inf)..
   0 =e= (pth2ondx(r,t)**omegaw1(r)
      -     sum(wbnd1, (gam1h2o(r,wbnd1,t)*(ph2obnd0(r,wbnd1)/pth2ondx0(r))**omegaw1(r))
      *        ph2obnd(r,wbnd1,t)**omegaw1(r))) ;

pth2oEQ(r,t) $ (ts(t) and rs(r) and th2oFlag(r))..
   pth2o(r,t)*th2om(r,t) =e= sum(wbnd1, ph2obnd(r,wbnd1,t)*h2obnd(r,wbnd1,t)
                          *   ((ph2obnd0(r,wbnd1)*h2obnd0(r,wbnd1))/(pth2o0(r)*th2om0(r)))) ;

*  Price index of 2nd and 3rd level bundles -- resp. wbnd1 and wbnda

ph2obndndxEQ(r,wbnd,t) $ (ts(t) and rs(r) and h2obndFlag(r,wbnd))..
   0 =e= (ph2obndndx(r,wbnd,t)**omegaw2(r,wbnd) - sum(wbnd2$mapw1(wbnd,wbnd2),
            (gam2h2o(r,wbnd2,t)*(ph2obnd0(r,wbnd2)/ph2obndndx0(r,wbnd))**omegaw2(r,wbnd))
      *     ph2obnd(r,wbnd2,t)**omegaw2(r,wbnd)))$(wbnd1(wbnd) and omegaw2(r,wbnd) ne inf)

      +  (ph2obndndx(r,wbnd,t)**omegaw2(r,wbnd) - sum(a$mapw2(wbnd,a),
            (gam3h2o(r,a,t)*(ph2o0(r,a)/ph2obndndx0(r,wbnd))**omegaw2(r,wbnd))
      *     ph2o(r,a,t)**omegaw2(r,wbnd)))$(wbnda(wbnd) and omegaw2(r,wbnd) ne inf)
      ;

*  Price of 2nd and 3rd level bundles:
*     Second level (wbnd1)
*     Third level when mapped to activities (wbnda)
*     Third level when mapped to aggregate sectoral output (wbndi)

ph2obndEQ(r,wbnd,t) $ (ts(t) and rs(r) and h2obndFlag(r,wbnd))..

*  Top level bundle price

   0 =e= (ph2obnd(r,wbnd,t)*h2obnd(r,wbnd,t)
      -     sum(wbnd2$mapw1(wbnd,wbnd2), ph2obnd(r,wbnd2,t)*h2obnd(r,wbnd2,t)
      *        ((ph2obnd0(r,wbnd2)*h2obnd0(r,wbnd2))/(ph2obnd0(r,wbnd)*h2obnd0(r,wbnd)))))
      $wbnd1(wbnd)

*  Second level bundle price (when bundle is mapped to activities)

      +  (ph2obnd(r,wbnd,t)*h2obnd(r,wbnd,t)
      -     sum(a$mapw2(wbnd,a), ph2o(r,a,t)*h2o(r,a,t)
      *        ((ph2o0(r,a)*h2o0(r,a))/(ph2obnd0(r,wbnd)*h2obnd0(r,wbnd)))))
      $(wbnda(wbnd))

*  Second level bundle price (when bundle is mapped to an output index)

      +  (h2obnd(r,wbnd,t) - (ah2obnd(r,wbnd,t)/(lambdah2obnd(r,wbnd,t)*h2obnd0(r,wbnd)))
      *   (((ph2obnd(r,wbnd,t)/pgdpmp(r,t))*(ph2obnd0(r,wbnd)/pgdpmp0(r)))**(-epsh2obnd(r,wbnd)))
      *   (sum((a,t0)$mapw2(wbnd,a), PP_SUB(r,a,t0)*m_true2t(xp,r,a,t) *pp0(r,a))
      /    sum((a,t0)$mapw2(wbnd,a), PP_SUB(r,a,t0)*m_true2t(xp,r,a,t0)*pp0(r,a)))
      **etah2obnd(r,wbnd))
      $(wbndi(wbnd))
      ;

*  Third level bundle -- agriculture only

ph2oEQ(r,a,t) $ (ts(t) and rs(r) and xwatfFlag(r,a))..
   0 =e= sum(wbnd2$(wbnda(wbnd2) and mapw2(wbnd2,a)),
            (h2o(r,a,t) - (gam3h2o(r,a,t)*(h2obnd0(r,wbnd2)/h2o0(r,a))
      *        (ph2o0(r,a)/ph2obndndx0(r,wbnd2))**omegaw2(r,wbnd2))
      *        h2obnd(r,wbnd2,t)*(ph2o(r,a,t)/ph2obndndx(r,wbnd2,t))**omegaw2(r,wbnd2))
      $(omegaw2(r,wbnd2) ne inf)
      -     (ph2o(r,a,t) - ph2obnd(r,wbnd2,t)*(ph2o0(r,a)/ph2obnd0(r,wbnd2)))
      $(omegaw2(r,wbnd2) eq inf)) ;


*------------------------------------------------------------------------------*
*                      OECD-ENV: Policy 	                                   *
*------------------------------------------------------------------------------*


EQUATIONS
    kveqbis(r,a,v,t) "Same as kveq but not same association in model definition"
    kvConstrEQ(r,a,v,t)
    lambdakEQ(r,a,v,t)
;


* simplified since sigmak = 0

kveqbis(r,a,v,t)
    $ (ts(t) and rs(r) and kFlag(r,a) and ((ifExokv(r,a,v) eq 1) or kv_tgt(r,a,v,t)) )..
    kv(r,a,v,t) * m_lambdak(r,a,v,t)
        =e= ak(r,a,v,t) * m_true3vt(ks,r,a,v,t) / kv0(r,a,t) ;

kvConstrEQ(r,a,v,t)
    $ (ts(t) and rs(r) and kFlag(r,a) and ifExokv(r,a,v) eq 2 and kv_tgt(r,a,v,t))..
        kv_tgt(r,a,v,t) =l= m_true3vt(kv,r,a,v,t);
*        0 =e= (kv(r,a,v,t) - kv_tgt(r,a,v,t) / kv0(r,a,t)) * pkpShadowPrice(r,a,v,t);

lambdakEQ(r,a,v,t)
    $ (ts(t) and rs(r) and kFlag(r,a) and kv_tgt(r,a,v,t) and IfProjectFlag)..
    m_lambdak(r,a,v,t) =e= m_true3v(pk,r,a,v,t)**0.025 ;

EQUATIONS
    xpbConstraintEq(r,t) "Renewable (Non-Fossil) Power constraint"
    RenewTgtEq(r,t)      "Endogenous Renewable target for case IfElyCES"
    powaConstrEq(r,a,t)
;

* Equation (P-1):  add-on: regulation constraint on Power sector

xpbConstraintEq(r,t) $ (ts(t) and rs(r) and RenewTgt(r,t))..
 (1 - m_RenewTgt(r,t)) * sum(elyi,xpow(r,elyi,t))
	=g= [  sum((fospbnd,elyi), m_true3t(xpb,r,fospbnd,elyi,t))
         + sum((Nukebnd,elyi), m_true3t(xpb,r,Nukebnd,elyi,t))
		 * (1 - IfProjectFlag) ]  / sum(elyi,xpow0(r,elyi,t)) ;

* Equation (P-2): Additional Eq to be guarantee the share in volume with CES function

RenewTgtEq(r,t) $ (ts(t) and rs(r) and RenewTgt(r,t) and IfElyCES)..
 (1 - RenewTgt(r,t)) * sum((elyi,powa) $ xpFlag(r,powa), m_true3t(x,r,powa,elyi,t))
    =g= sum((elyi,GSPa)  $ xpFlag(r,GSPa),  m_true3t(x,r,GSPa,elyi,t) )
     +  sum((elyi,CLPa)  $ xpFlag(r,CLPa),  m_true3t(x,r,CLPa,elyi,t) )
     +  sum((elyi,OLPa)  $ xpFlag(r,OLPa),  m_true3t(x,r,OLPa,elyi,t) )
     +  sum((elyi,Nukea) $ xpFlag(r,Nukea), m_true3t(x,r,Nukea,elyi,t)) * (1-IfProjectFlag)
    ;

*------------------------------------------------------------------------------*
*       Equations for price definition in the case IfSub = 0                   *
*------------------------------------------------------------------------------*

EQUATIONS

	paEQ(r,i,aa,t)       "Agent price of Armington good"
    ppEQ(r,a,t)          "Producer price tax inclusive, i.e. market price"

    pdEQ(r,i,aa,t)       "End user price of domestic goods"
    pmEQ(r,i,aa,t)       "End user price of imported goods"

    pweEQ(r,i,rp,t)      "FOB price of exports"
    pwmEQ(r,i,rp,t)      "CIF price of imports"
    pdmEQ(r,i,rp,t)      "Tariff inclusive price of imports"

    xwmgEQ(r,i,rp,t)     "Demand for tt services from r to rp"
    xmgmEQ(img,r,i,rp,t) "Demand for tt services from r to rp for service type m"
    pwmgEQ(r,i,rp,t)     "Average price to transport good from r to rp"

;

* memo: add conditions such that this equation is always active if IfArmFlag=1,
* if IfArmFlag eq 0 equation active only when IfSub eq 0 (alternative case))
*--> in other word inactive in base case

paEQ(r,i,aa,t) $ (ts(t) and rs(r) and xaFlag(r,i,aa)
                  AND (IfArmFlag or (IfArmFlag eq 0 and NOT IfSub)))..
 pa(r,i,aa,t)

* National sourcing

    =e= { (1 + m_paTax(r,i,aa,t)) * gammaeda(r,i,aa)
		 *  m_true2(pat,r,i,t) / pa0(r,i,aa)
		 + (m_Permis(r,i,aa,t) + m_ShadowPermis(r,i,aa,t)) / pa0(r,i,aa)
		} $ {IfArmFlag eq 0}

* Agent sourcing

     + {[  alphad(r,i,aa,t) * [m_true3b(pd,SUB,r,i,aa,t) / pa0(r,i,aa)]**(1-sigmam(r,i,aa))
         + alpham(r,i,aa,t) * [m_true3b(pm,SUB,r,i,aa,t) / pa0(r,i,aa)]**(1-sigmam(r,i,aa))
        ]**(1/(1-sigmam(r,i,aa)))
       } $ {IfArmFlag eq 1}
    ;


* Equation (P-0): Producer price tax inclusive, i.e. market price

ppEQ(r,a,t) $ (ts(t) and rs(r) and xpFlag(r,a) and (not IfSub))..
  pp(r,a,t) =e=
        [m_true2(px,r,a,t) + pim(r,a,t)] * [1 + m_pTax(r,a,t)] / pp0(r,a)
		- [PP_permit(r,a,t) / pp0(r,a) ] $ IfAllowance(r)
        + sum((em,EmiSourceAct) $ ifPowFeebates(r,em,EmiSourceAct), m_feebate(r,em,EmiSourceAct,a,t) / pp0(r,a)) $ powa(a) ;

*   Argminton Price definitions for the case IfSub = 0

pdEQ(r,i,aa,t) $ (ts(t) and rs(r) and xdFlag(r,i,aa) and IfArmFlag and (NOT IfSub))..
 pd(r,i,aa,t) =e=
   (1 + pdtax(r,i,aa,t)) * gammaedd(r,i,aa) * (m_true2(pdt,r,i,t) / pd0(r,i,aa))
 + m_Permisd(r,i,aa,t) / pd0(r,i,aa) ;

pmEQ(r,i,aa,t) $ (ts(t) and rs(r) and xmFlag(r,i,aa) and IfArmFlag and (not IfSub))..
 pm(r,i,aa,t) =e=
   (1 + pmtax(r,i,aa,t)) * gammaedm(r,i,aa) * (m_true2(pmt,r,i,t) / pm0(r,i,aa))
 +  m_Permism(r,i,aa,t) / pm0(r,i,aa) ;


*  Other bilateral price definitions (case IfSub = 0 / ie not default)

pweEQ(r,i,rp,t) $ (ts(t) and rs(r) and xwFlag(r,i,rp) and (not IfSub))..
  pwe(r,i,rp,t) =e= (1 + etax(r,i,rp,t)) * m_true3(pe,r,i,rp,t)
                  / pwe0(r,i,rp) ;

pwmEQ(r,i,rp,t) $ (ts(t) and rs(r) and xwFlag(r,i,rp) and (not IfSub))..
  pwm(r,i,rp,t) =e= [m_true3(pwe,r,i,rp,t) +  tmarg(r,i,rp,t) * PWMG_SUB(r,i,rp,t)]
                /  [lambdaw(r,i,rp,t) * pwm0(r,i,rp)] ;

pdmEQ(r,i,rp,t) $ (ts(t) and rs(r) and xwFlag(r,i,rp) and (not IfSub))..
  pdm(r,i,rp,t) =e= (1 + mtax(r,i,rp,t)) * m_true3(pwm,r,i,rp,t) / pdm0(r,i,rp) ;

*   TRADE MARGINS BLOCK

*  Total demand for TT services from r to rp for good i

xwmgEQ(r,i,rp,t) $ (ts(t) and rs(r) and tmgFlag(r,i,rp) and (not IfSub))..
   xwmg(r,i,rp,t) =e= tmarg(r,i,rp,t) * m_true3(xw,r,i,rp,t) / xwmg0(r,i,rp) ;

*  Demand for TT services using m from r to rp for good i

xmgmEQ(img,r,i,rp,t) $ (ts(t) and rs(r) and amgm(img,r,i,rp) ne 0 and (not IfSub))..
 xmgm(img,r,i,rp,t) =e= amgm(img,r,i,rp) * m_true3(xwmg,r,i,rp,t)
                     / (lambdamg(img,r,i,rp,t) * xmgm0(img,r,i,rp)) ;

*  The aggregate price of transporting i between r and rp
*  Note--the price per transport mode is uniform globally

pwmgEQ(r,i,rp,t) $ (ts(t) and rs(r) and tmgFlag(r,i,rp) and (not IfSub))..
  pwmg(r,i,rp,t)
    =e= sum(img, amgm(img,r,i,rp) * ptmg(img,t) * ptmg0(img) / lambdamg(img,r,i,rp,t))
     /  pwmg0(r,i,rp) ;


*  Producer prices for factor (scaled) --> to be done


*------------------------------------------------------------------------------*
*                           Labor market                                       *
*------------------------------------------------------------------------------*

EQUATIONS

   urbPremEQ(r,l,t)        "Urban wage premium"
   resWageEQ(r,l,z,t)      "Reservation wage equation"
   ewagezEQ(r,l,z,t)       "Market clearing wage by zone"

;


*	Unemployment cases: ueFlag(r,l,z) > 0

* Reservation wage -- depends on GDP growth, unemployment rate and CPI: default inactive (ueFlag = 0)

resWageEQ(r,l,z,t) $ (ts(t) and rs(r) and ueFlag(r,l,z))..
  resWage(r,l,z,t) =e= (chirw(r,l,z,t) / resWage0(r,l,z) )
                    *  (1 + 0.01 * grrgdppc(r,t))**omegarwg(r,l,z)
*                   *  ((uez(r,l,z,t)/uez(r,l,z,t-1))**omegarwue(r,l,z))
                    *  (((1-uez(r,l,z,t))/(1-uez(r,l,z,t-1)))**omegarwue(r,l,z))
                    *  (sum(h, pfd(r,h,t)/pfd(r,h,t-1))**omegarwp(r,l,z))
                    ;

* Equilibrium wage in each zone -- MCP with lower limit on UE: default inactive (ueFlag = 0)

ewagezEQ(r,l,z,t) $ (ts(t) and rs(r) and ueFlag(r,l,z))..
   ewagez(r,l,z,t) =g= m_true3(resWage,r,l,z,t) / ewagez0(r,l,z) ;

*	Segmented labor market cases: omegam(r,l) ne inf

* Expected urban premium

urbPremEQ(r,l,t) $ (ts(t) and rs(r) and tLabFlag(r,l) and (omegam(r,l) ne inf))..
  urbPrem(r,l,t) * sum(rur, (1 - uez(r,l,rur,t)) * m_true3(awagez,r,l,rur,t) )
      =e= sum(urb, (1 - uez(r,l,urb,t)) * m_true3(awagez,r,l,urb,t) )
       /  urbprem0(r,l) ;

*------------------------------------------------------------------------------*
*                       [OECD-ENV]: EMISSIONS MODULE                           *
*------------------------------------------------------------------------------*

EQUATIONS
    emiTotEndoEq(r,em,t)
    emiTotNonCO2EQ(r,t)
    xoapEQ(r,a,v,t)  "OAP bundle associated with output"
    pxoapEQ(r,a,v,t) "price of OAP bundle associated with output"

    emiaEq(r,aa,AllEmissions,t) "Controlled sectoral emissions"
    emiaConstraintEq(r,a,AllEmissions,t) "sectoral regulation on emission"
    CPE_capEq(r,t) "Ajustment feebates or feed-in-tarrifs to match emission target"
;

* Equation (P-4b): 'Demand' for OAP bundle

xoapEQ(r,a,v,t) $ (ts(t) and rs(r) and OAPFlag(r,a))..
  xoap(r,a,v,t)
    =e= aoap(r,a,v,t) * (m_true3vt(xpv,r,a,v,t) / xoap0(r,a))
       * [TFP_xpv(r,a,v,t) * lambdaoap(r,a,v,t)]**(sigmaxp(r,a,v)-1)
       * [m_uc(r,a,v,t) * uc0(r,a) / m_true3v(pxoap,r,a,v,t)]**sigmaxp(r,a,v) ;

* Equation (E-4b): Price of process based OAP emission bundle

pxoapEQ(r,a,v,t) $ (ts(t) and rs(r) and OAPFlag(r,a))..
pxoap(r,a,v,t)**(1-sigmaemi(r,a,v)) =e=
    sum( (oap,emiact) $ aemi(r,oap,a,v,t),
        aemi(r,oap,a,v,t)
         * [ m_pemi(r,oap,emiact,a,t) / lambdaemi(r,oap,a,v,t) ]**(1-sigmaemi(r,a,v))
       ) / pxoap0(r,a) ;

* emiTotEndoEq is identical to emiTotEQ but is associated with chiEm.l
* in model definition --> for calibration purpose

emiTotEndoEQ(r,em,t) $ (    ts(t) and rs(r) and emiTot0(r,em)
                        and IfCalEmi(r,em,"allsourceinc","tot"))..
 emiTot(r,em,t)
     =e= emiOth(r,em,t) / emiTot0(r,em)
      +  sum((EmiSourceAct,aa) $ emir(r,em,EmiSourceAct,aa,t),
            m_true4(emi,r,em,EmiSourceAct,aa,t)) / emiTot0(r,em)
      ;

emiTotNonCO2EQ(r,t)
	$ ( ts(t) and rs(r) 
       AND sum(AllGHG,IfCalEmi(r,AllGHG,"allsourceinc","tot")) )..
0  =e=  {emiTotNonCO2(r,t)
			- sum(em $(EmSingle(em) and not CO2(em)), emiOth(r,em,t)
				+  sum((EmiSourceAct,aa) $ emir(r,em,EmiSourceAct,aa,t),
							m_true4(emi,r,em,EmiSourceAct,aa,t) ) )
		} $ { emiTotNonCO2(r,t)}
	+	{emiTotAllGHG(r,t)
			- sum(EmSingle,	emiOth(r,EmSingle,t) 
			    + sum((EmiSourceAct,aa) $ emir(r,EmSingle,EmiSourceAct,aa,t),
							m_true4(emi,r,EmSingle,EmiSourceAct,aa,t) ) )
		} $ { emiTotAllGHG(r,t)}
;

***from 4-initemiTotAllGHG(r,t) = sum(EmSingle, emiTot.l(r,EmSingle,t)) ;


* Equation (E-XX): controlled sectoral emissions: emia --> acTax.l(r,a,t)

emiaEq(r,a,AllEmissions,t)
    $ (ts(t) and rs(r) and xpFlag(r,a) and IfEmiaEq and emia0(r,a,AllEmissions))..
emia(r,a,AllEmissions,t)
     =e= sum( EmiSourceAct $ emi0(r,AllEmissions,EmiSourceAct,a),
				m_EffEmi(r,AllEmissions,EmiSourceAct,a,t) )
	  / emia0(r,a,AllEmissions) ;

* Equation (E-XX): sectoral regulation on emission intensity

emiaConstraintEq(r,a,AllEmissions,t)
    $ (ts(t) and rs(r) and xpFlag(r,a) and IfEmiaEq and emia_IntTgt(r,a,AllEmissions,t))..
xp(r,a,t) * emia_IntTgt(r,a,AllEmissions,t)
    =g= m_true3(emia,r,a,AllEmissions,t) / xp0(r,a,t) ;

* Equation (E-XX): Fixed target for production

EQUATION xpConstraintEq(r,a,t) ;

xpConstraintEq(r,a,t) $ (ts(t) and rs(r) and xpFlag(r,a) and xpBar(r,a,t))..
    xpBar(r,a,t) =g= xp(r,a,t) ;

* Equation (E-XX): Ajustment feebates or feed-in-tarrifs to match CO2 emission target

CPE_capEq(r,t) $ (ts(t) and rs(r) and emFlag(r,"CO2") eq 3)..
    EmiRCap(r,"CO2",t)
        =e= sum((EmiSourceAct,aa), m_EffEmi(r,"CO2",EmiSourceAct,aa,t)) ;

EQUATION emiCapMcpEQ(ra,em,t) "Emission constraint equation: MCP configuration";

emiCapMcpEQ(rq,em,t)
    $ (ts(t) and ifGbl and (IfEmCap(rq,em) eq 3) and IfCap(rq) and IfMcpCapEq)..

       {chiCapFull(t) * emiCapFull(rq,t)} $ AllGHG(em)
    +  {emiRegTax(rq,em,t)              } $ EmSingle(em)
   =g=
       {sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
               { m_true2(emiTot,r,EmSingle,t)           } $ {IfCap(rq) eq 1}
             + {sum((EmiSource,aa) $ emi0(r,EmSingle,EmiSource,aa),
                   m_EffEmi(r,EmSingle,EmiSource,aa,t)) } $ {IfCap(rq) eq 2}
           ) / emiCapFull0(rq)
       } $ AllGHG(em)
    +  {sum(AllGHG, emiRegTax(rq,AllGHG,t)) } $ EmSingle(em)
    ;

*------------------------------------------------------------------------------*
*                       [OECD-ENV]: SECTORAL Permit                            *
*------------------------------------------------------------------------------*

EQUATION
    PP_permitEQ(r,a,t) "Eq. to determine permit allowance subsidy to production"
	pEmiPermitEQ(r,AllEmissions,t)  "Eq. to determine price of emission permit under ETS"
;

PP_permitEQ(r,a,t)
	$ ( ts(t) AND IfAllowance(r)
		AND sum(AllEmissions,PermitAllowancea(r,AllEmissions,a,t))
		AND xpFlag(r,a))..
 PP_permit(r,a,t) * m_true2t(xp,r,a,t)
	=e= sum(AllEmissions $ PermitAllowancea(r,AllEmissions,a,t),
		PermitAllowancea(r,AllEmissions,a,t) * pEmiPermit(r,AllEmissions,t) ) ;

* #todo remplacer par P_emission pour Bau

pEmiPermitEQ(r,AllEmissions,t)
	$ ( ts(t) AND (IfAllowance(r) eq 2) AND emFlag(r,AllEmissions)
	    AND sum(a,PermitAllowancea(r,AllEmissions,a,t)) )..
 pEmiPermit(r,AllEmissions,t) =e= emiTax(r,AllEmissions,t) ;

* --> Add to pEmiPermitEQ
$OnText
EQUATION emiCapQuotaEQ(rq,em,t); !! #todo
emiCapQuotaEQ(rq,em,t)
    $ (ts(t) and ifGbl and IfCap(rq) and IfEmCap(rq,em) and (not IfMcpCapEq)
       AND (IfAllowance(r) eq 1))..

 0 =e=

* Base Case: Gas-by-gas caps are fixed and directly determine emiRegTax(rq,em)

      {emiCapQuota(rq,em,t)
          - sum(mapr(rq,r) $ emFlag(r,em),
                  {m_true2(emiTot,r,em,t)          } $ {IfCap(rq) eq 1}
                + {sum((EmiSource,aa) $ emi0(r,em,EmiSource,aa),
                    m_EffEmi(r,em,EmiSource,aa,t)) } $ {IfCap(rq) eq 2}
               ) / emiCap0(rq,em)
      } $ {IfEmCap(rq,em) eq 1 and EmSingle(em)}

* [OECD-ENV]: add case IfEmCap(rq,emn) eq 2 where only CO2 are capped
*  but same emiRegTax(emn) = emiRegTax(CO2) applies for other GHGs

    + { emiRegTax(rq,em,t) - sum(CO2,emiRegTax(rq,CO2,t))
      } $ {IfEmCap(rq,em) eq 2 and emn(em)}

*	[OECD-ENV]: add case IfEmCap(rq,em) eq 3, where cap is defined

* either on all emitot over all GHG: ifCap(rq) eq 1
* or on a controlled set of emissions mixing gas and sources: IfCap(rq) eq 2

*   this determines emiRegTax(rq,AllGHG)

* The set AllGHG is necessary since it is an argument of emiRegTax(rq,AllGHG)

    + {chiCapFull(t) * emiCapFull(rq,t)
        - sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
                { m_true2(emiTot,r,EmSingle,t)         } $ {IfCap(rq) eq 1}
              + {sum((EmiSource,aa) $ emi0(r,EmSingle,EmiSource,aa),
                  m_EffEmi(r,EmSingle,EmiSource,aa,t)) } $ {IfCap(rq) eq 2}
             ) / emiCapFull0(rq)
      } $ {IfEmCap(rq,em) eq 3 and AllGHG(em)}

*   this determines emiRegTax(em) = to emiRegTax(AllGHG), for all individual gas

    + { emiRegTax(rq,em,t) - sum(AllGHG,emiRegTax(rq,AllGHG,t))
      } $ {IfEmCap(rq,em) eq 3 and EmSingle(em)}
   ;

$OffText
*------------------------------------------------------------------------------*
*                           MODEL DYNAMICS                                     *
*------------------------------------------------------------------------------*

EQUATIONS
    migrEQ(r,l,t)           "Migration equation"
    migrmultEQ(r,l,z,t)     "Migration multiplier equation"
;

*   Migration module (if migrFlag(r,l) > 0)

* Equation (G-1):  Migration level [If activated]

migrEQ(r,l,t) $ (ts(t) and rs(r) and migrFlag(r,l))..
 migr(r,l,t)
	=e= (chim(r,l,t) / migr0(r,l)) 	* m_true2(urbPrem,r,l,t)**omegam(r,l) ;


* Equation (G-1):  Migration factor to for multi-year specification

migrMultEQ(r,l,z,t) $ (ts(t) and rs(r) and migrFlag(r,l))..
 migrMult(r,l,z,t) * ((1 + 0.01*glabz(r,l,z,t))
      *  (urbPrem(r,l,t-1)/urbPrem(r,l,t))**(omegam(r,l)/gap(t))-1) =e=
         power(1 + 0.01*glabz(r,l,z,t), gap(t))*(urbPrem(r,l,t-1)/urbPrem(r,l,t))**omegam(r,l) - 1 ;

* [OECD-ENV]: Endogenous Labour supply in variant mode [TBU] with MIGR

$Iftheni.Variant %SimType%=="Variant"

    EQUATION LFPREQ(r,l,z,t);
    LFPREQ(r,l,z,t) $ (ts(t) and rs(r) and etawl(r,l) ne 0 and etawl(r,l) ne inf and lsFlag(r,l,z))..
    LFPR(r,l,z,t) =e= LFPR_bau(r,l,z,t)
        * [m_netwage(r,l,z,t) / (rwage_bau(r,l,z,t) * sum(h,PI0_xc(r,h,t)))]**etawl(r,l);

$Endif.Variant

*------------------------------------------------------------------------------*
*        Resarch and Development module--First specification                   *
*------------------------------------------------------------------------------*

alias(tt,ty) ;

Sets
   knowFlag(r)    "Flag for knowledge module"
   ky             "Knowledge lags"              / ky0*ky50 /
;

singleton set tLag(t) ;

Parameters
   valk(ky)          "Cardinal value of knowledge lags"
   kdepr(r,tt)       "Knowledge depreciation rate"
   gamPrm(r,*)       "Parameters for gamma lag function"
   gamCoef(r,ky)     "Coefficients for distributed lags"
   kn0(r)            "Base year knowledge stock"
   rd0(r)            "Base year expenditures on R & D"
   gammar(r,l,a,t)   "Productivity shifter (default = 1)"
   epsr(r,l,a,t)     "Productivity elasticity wrt to knowledge stock"
;
   
Variables
   kn(r,tt)          "Knowledge stock"
   rd(r,tt)          "Research and development expenditures"
   pik(r,l,a,t)      "Labor productivity factor linked to R & D expenditures"
;

Equations
   kneq(r,ty,t)      "Knowledge stock update equation"
   rdeq(r,ty,t)      "Annualized R & D expenditures"
   pikeq(r,l,a,t)    "R & D-based labor productivity enhancement"
;

*  The knowledge and R&D equations are defined on an annual basis--even if the gap > 1
*  The lag coefficients are reversed wrt to time, i.e., gamCoef('0') is associated
*  with the earliest time period and gamCoef('ky50') is associated with the
*  contemporaneous R & D expenditure (if the lag covers  50 years)

kneq(r,ty,t)$(ts(t) and knowFlag(r) and years(ty) gt years(tLag) and years(ty) le years(t))..
   kn(r,ty) =e= (1 - kdepr(r,ty))*kn(r,ty-1)
             +  sum((ky,tt)$(valk(ky) le gamPrm(r,"N") and years(ty)-years(tt) eq valk(ky)),
                  gamCoef(r,ky)*rd(r,tt)*rd0(r)/kn0(r)) ;

*  Calculate R & D expenditures for intermediate years

rdeq(r,ty,t)$(ts(t) and knowFlag(r) and (ty.val gt tlag.val and ty.val le t.val))..
   rd(r,ty) =e= xfd(r,r_d,t)*(xfd0(r,r_d)/rd0(r))
             *  ((xfd(r,r_d,t)/xfd(r,r_d,tlag))**((years(ty) - years(t))/gap(t))) ;

pikeq(r,l,a,t)$(ts(t) and rs(r) and gammar(r,l,a,t) and knowFlag(r))..
   pik(r,l,a,t) =e= gammar(r,l,a,t)*epsr(r,l,a,t)*((kn(r,t)/kn(r,tLag))**(1/gap(t)) - 1) ;

model r_dMod / kneq, rdeq, pikeq / ;