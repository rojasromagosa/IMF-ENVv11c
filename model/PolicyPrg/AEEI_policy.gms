*------------------------------------------------------------------------------*
*               Additional Energy efficiency: only for new vintages            *
*------------------------------------------------------------------------------*

IF(year gt %YearPolicyStart%,

    risjswork(r,is,js) = 0 ;  rwork(r) = 0 ;
    LOOP(CO2, rworkT(r,tsim) = emiTax.l(r,CO2,tsim-1) / cScale ; ) ;

    rwork(r) $ (rworkT(r,tsim) ge 25)  = 0.5 ;
    rwork(r) $ (rworkT(r,tsim) ge 50)  = 1;
    rwork(r) $ (rworkT(r,tsim) ge 100) = 1.25;
    rwork(r) $ (rworkT(r,tsim) ge 200) = 1.5;
    rwork(r) $ (rworkT(r,tsim) ge 250) = 1.75;

    rwork(r) = 0.01 * rwork(r) * 1.25 ; !! 1.25 for increase efficiency

    risjswork(r,i,a) $ ((elyi(i) or ROILi(i) or GASi(i)) and not prima(a))
		= rwork(r);
    risjswork(r,i,a) $ ((elyi(i) or ROILi(i) or GASi(i)) and prima(a))
		= rwork(r)/2;

* Apply only if sigmae(v) > 1 ?????

    LOOP(v $ vNew(v),
        IF(1,
           risjswork(r,e,a)
                $ (sigmae(r,a,v) lt 1 and not IfNrgNest(r,a)) = 0 ;
            risjswork(r,elyi,a)
                $ (sum(ELY,sigmaNRG(r,a,ELY,v)) lt 1 and IfNrgNest(r,a)) = 0 ;
            risjswork(r,gasi,a)
                $ (sum(GAS,sigmaNRG(r,a,GAS,v)) lt 1 and IfNrgNest(r,a)) = 0 ;
            risjswork(r,ROILi,a)
                $ (sum(OIL,sigmaNRG(r,a,OIL,v)) lt 1 and IfNrgNest(r,a)) = 0 ;
        ) ;

        risjswork(r,e,a) $ (NOT lambdae_bau(r,e,a,v,tsim-1)) = 0 ;

    lambdae.fx(r,e,a,v,tsim) $ (xaFlag(r,e,a) and risjswork(r,e,a))
        =  lambdae.l(r,e,a,v,tsim-1)
        * [ lambdae_bau(r,e,a,v,tsim) / lambdae_bau(r,e,a,v,tsim-1)
            + risjswork(r,e,a) ] ;

    ) ;

) ;

*------------------------------------------------------------------------------*
*                           Households Energy Demands                          *
*------------------------------------------------------------------------------*

$OnText
   Decrease ac to avoid too strong fall in lambdace
   Indeed the counterpart of ac decrease is lamdbace increase, but be
   careful that the increase is not too strong to avoid numerical issues
$OffText

IF(0,
    ac(r,COAi,nrgk,h) $ rwork(r) = ac(r,COAi,nrgk,h) * 0.975;
    ac(r,elyi,nrgk,h) = 1 - sum(i $ (e(i) and not elyi(i)), ac(r,i,nrgk,h));
) ;

*------------------------------------------------------------------------------*
*               Ad-hoc Electric vehicles penetration                           *
*------------------------------------------------------------------------------*

IF(0 and year gt %YearPolicyStart% and year le 2030,

    rwork_bis(r) = 0 ; rwork(r) = 0;

*    LOOP(CO2,
*        rwork_bis(r) $ emiTax.l(r,CO2,tsim)
*            = emiTax.l(r,CO2,tsim-1) / emiTax.l(r,CO2,tsim);
*    ) ;

    rwork_bis(r) $ rwork(r) = 0.975 ;

    IF(1,

        rwork(r) = sum((e,h,nrgk), ac(r,e,nrgk,h));

* Households decrease in Oil Demand

        ac(r,ROILi,nrgk,h) $ rwork_bis(r)
            = Max(0.1 , ac(r,ROILi,nrgk,h) * rwork_bis(r));

* Heating: coal phasing out (logically part should goes to Ngas/GDT [TBU])

        ac(r,COAi,nrgk,h) $ rwork_bis(r)
            = Max(0.05 , ac(r,COAi,nrgk,h)  * rwork_bis(r) );

* Adjust electricity share

        ac(r,elyi,nrgk,h)  $ rwork_bis(r)
            = rwork(r) - sum(i$(e(i) and not elyi(i)), ac(r,i,nrgk,h));
    ) ;

* Households energy efficiency: reduction in total energy demand

    IF(0,
        rwork(r) = 0;
        riskwork(r,h,nrgk) = muc.l(r,nrgk,h,tsim) ;
        LOOP((nrgk,h),
            rwork(r) = muc.l(r,nrgk,h,tsim) ;
            muc.fx(r,nrgk,h,tsim) $ rwork_bis(r)
                = 0.985 * muc.l(r,nrgk,h,tsim-1) ;
            rwork(r) $ rwork_bis(r)
                = [rwork(r) - muc.l(r,nrgk,h,tsim)]
                / [rwork(r) - riskwork(r,h,nrgk)] ;
        ) ;
        muc.fx(r,k,h,tsim) $ (NOT nrg(k)) =  muc.l(r,k,h,tsim) *  rwork(r);
    ) ;

* Increase EV in otp (Could be better done)

    IF(0,
        rwork_bis(r) = 0 ;
        rwork_bis(r) $ (year le 2030) = 0.985 ;
        rwork_bis(r) $ (year gt 2030) = 0.99;
        LOOP((LandTrpa,vNew,ELY),
			rwork(r) = anely(r,LandTrpa,vNew,tsim)
					 + aNRG(r,LandTrpa,ELY,vNew,tsim);
			anely(r,LandTrpa,vNew,tsim)
				= Max(anely(r,LandTrpa,vNew,tsim-1) * rwork_bis(r), 0.025) ;
			aNRG(r,LandTrpa,ELY,vNew,tsim)
				= rwork(r) - anely(r,LandTrpa,vNew,tsim)  ;
			rwork_bis(r) = anely(r,LandTrpa,vNew,tsim)	 ;
			rwork(r)     = aNRG(r,LandTrpa,ELY,vNew,tsim) ;
			Display "anely(r,otp-a,New,tsim): ", rwork_bis   ;
			Display "aNRG(r,otp-a,ELY,New,tsim): ", rwork    ;
		) ;
		IF(year gt 2030,
			anely(r,LandTrpa,vNew,tsim)
				= anely(r,LandTrpa,vNew,tsim-1)  ;
			aNRG(r,LandTrpa,ELY,vNew,tsim)
				= aNRG(r,LandTrpa,ELY,vNew,tsim-1);
		) ;
    ) ;

* Increase MVH cost :

*    IF(0,
*        rswork(r,MTEa) = and1(r,MTEa,vNew,tsim) + ava(r,MTEa,vNew,tsim);
*        rworka(a) = 0 ; rworka("otn-a") = 1.0005; rworka("mvh-a") = 1.001;
*        and1(r,MTEa,vNew,tsim) = and1(r,MTEa,vNew,tsim-1) * rworka(MTEa);
*    ) ;

) ;

