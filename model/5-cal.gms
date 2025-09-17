$OnText
--------------------------------------------------------------------------------
            OECD-ENV Model version 1.0 - Core program
   GAMS file   : "%ModelDir%\5-cal.gms"
   purpose     : Calibrate parameters with initial SAMs
   Created by  : Dominique van der Mensbrugghe (file name cal.gms)
                + modifications by Jean Chateau for OECD-ENV
   Created date:
   called by   : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/5-cal.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText


* OECD-ENV: set elasticities to zero if singleton set

omegas(r,a) $(sum(i $ tmat(a,i,r),1) eq 1 or xpFlag(r,a)) = 0 ;
sigmas(r,i) $(sum(a $ tmat(a,i,r),1) eq 1 or xsFlag(r,i)) = 0 ;

sigmaemi(r,a,v) $ (NOT ghgFlag(r,a)) = 0 ;

LOOP((emiact,t0),
    sigmaemi(r,a,v) $ ( sum(em $ emi.l(r,em,emiact,a,t0), 1) lt 2) = 0 ;
) ;

LOOP(t0,
    sigmapb(r,pb,elyi)
		$ (sum(mappow(pb,powa) $ x.l(r,powa,elyi,t0), 1) eq 1)	= 0 ;
) ;

* sigmapb = 0 for Singleton power bundle (ie nspb)

IF(IfENVLPrm,
	sigmapb(r,pb,elyi) $ (NOT nspb(pb)) = 0 ;
) ;

*------------------------------------------------------------------------------*
*                                                                              *
*  				Calibrate the production CES nests							   *
*                                                                              *
*------------------------------------------------------------------------------*

* [OECD-ENV]: add TFP_xpv, lambdaxp and lambdaghg, add endogenous MAC curves for GHG and OAP

loop(vOld,
    axp(r,a,v,t) $ xpFlag(r,a)
        = (xpx.l(r,a,vOld,t) / xpv.l(r,a,vOld,t))
        * [(TFP_xpv.l(r,a,vOld,t) * lambdaxp.l(r,a,vOld,t))**(1-sigmaxp(r,a,v))]
        * (pxp.l(r,a,vOld,t) / uc.l(r,a,vOld,t))**sigmaxp(r,a,v)
        ;
    aghg(r,a,v,t) $ (xpFlag(r,a) and ghgFlag(r,a))
        = (xghg.l(r,a,vOld,t) / xpv.l(r,a,vOld,t))
        * [(TFP_xpv.l(r,a,vOld,t) * lambdaghg.l(r,a,vOld,t))**(1-sigmaxp(r,a,v))]
        * (pxghg.l(r,a,vOld,t) / uc.l(r,a,vOld,t))**sigmaxp(r,a,v)
        ;
    aoap(r,a,v,t) $ (xpFlag(r,a) and OAPFlag(r,a))
        = (xoap.l(r,a,vOld,t) / xpv.l(r,a,vOld,t))
        * [(TFP_xpv.l(r,a,vOld,t) * lambdaoap.l(r,a,vOld,t))**(1-sigmaxp(r,a,v))]
        * (pxoap.l(r,a,vOld,t) / uc.l(r,a,vOld,t))**sigmaxp(r,a,v)
        ;
    $$OnDotl
    aemi(r,em,a,v,t)
        $ (xpFlag(r,a) and ghgFlag(r,a) and pxghg.l(r,a,vOld,t))
        = (sum(emiact,emi.l(r,em,emiact,a,t)) / xghg.l(r,a,vOld,t))
        * [lambdaemi(r,em,a,vOld,t)**(1-sigmaemi(r,a,v))]
        * [sum(emiact,m_EmiPrice(r,em,emiact,a,t))
            / pxghg.l(r,a,vOld,t)]**sigmaemi(r,a,v) ;
    aemi(r,oap,a,v,t)
        $ (xpFlag(r,a) and OAPFlag(r,a) and pxoap.l(r,a,vOld,t))
        = (sum(emiact,emi.l(r,oap,emiact,a,t)) / xoap.l(r,a,vOld,t))
        * [lambdaemi(r,oap,a,vOld,t)**(1-sigmaemi(r,a,v))]
        * [sum(emiact,m_EmiPrice(r,oap,emiact,a,t))
            / pxoap.l(r,a,vOld,t)]**sigmaemi(r,a,v) ;
    $$OffDotl

    aemi(r,em,a,v,t)  $ (NOT ghgFlag(r,a)) = 0 ;
    aghg(r,a,v,t)     $ (NOT ghgFlag(r,a)) = 0 ;

    aemi(r,oap,a,v,t) $ (NOT OAPFlag(r,a)) = 0 ;
    aoap(r,a,v,t)     $ (NOT OAPFlag(r,a)) = 0 ;

    IF((ifDyn and ifCal) AND IfDebug,
        Execute_unload "%cBaseFile%_%system.fn%_GHGbundle.gdx",
            aghg, axp, aoap, aemi, lambdaemi, xghg,  pxghg, ghgFlag,
            pxoap, p_emissions, lambdaghg, pxp, lambdaxp, lambdaoap, OAPFlag ;
    ) ;

* [OECD-ENV]: add TFP_xpx

    and1(r,a,v,t) $ xpFlag(r,a)
        = (nd1.l(r,a,t)/xpx.l(r,a,vOld,t))
        * [TFP_xpx.l(r,a,vOld,t)**(1-sigmap(r,a,v))]
        * (pnd1.l(r,a,t)/pxp.l(r,a,vOld,t))**sigmap(r,a,v)
        ;
    ava(r,a,v,t) $ xpFlag(r,a)
        = (va.l(r,a,vOld,t)/xpx.l(r,a,vOld,t))
        * [TFP_xpx.l(r,a,vOld,t)**(1-sigmap(r,a,v))]
        * (pva.l(r,a,vOld,t)/pxp.l(r,a,vOld,t))**sigmap(r,a,v)
        ;

   alab1(r,a,v,t) $ xpFlag(r,a)
        = {(lab1.l(r,a,t)/va.l(r,a,vOld,t))
            * (plab1.l(r,a,t)/pva.l(r,a,vOld,t))**sigmav(r,a,v)}   $ cra(a)
        + {(lab1.l(r,a,t)/va1.l(r,a,vOld,t))
            * (plab1.l(r,a,t)/pva1.l(r,a,vOld,t))**sigmav1(r,a,v)} $ lva(a)
        + {(lab1.l(r,a,t)/va.l(r,a,vOld,t))
            *(plab1.l(r,a,t)/pva.l(r,a,vOld,t))**sigmav(r,a,v)}    $ axa(a)
      ;

   akef(r,a,v,t)$kefFlag(r,a)
      = ((kef.l(r,a,vOld,t)/va2.l(r,a,vOld,t))*(pkef.l(r,a,vOld,t)/pva2.l(r,a,vOld,t))
      **sigmav2(r,a,v))$cra(a)
      + ((kef.l(r,a,vOld,t)/va1.l(r,a,vOld,t))*(pkef.l(r,a,vOld,t)/pva1.l(r,a,vOld,t))
      **sigmav1(r,a,v))$lva(a)
      + ((kef.l(r,a,vOld,t)/va1.l(r,a,vOld,t))*(pkef.l(r,a,vOld,t)/pva1.l(r,a,vOld,t))
      **sigmav1(r,a,v)) $ axa(a)
      ;

   and2(r,a,v,t)$nd2Flag(r,a)
      = ((nd2.l(r,a,t)/va1.l(r,a,vOld,t))*(pnd2.l(r,a,t)/pva1.l(r,a,vOld,t))
      **sigmav1(r,a,v)) $ cra(a)
      + ((nd2.l(r,a,t)/va2.l(r,a,vOld,t))*(pnd2.l(r,a,t)/pva2.l(r,a,vOld,t))
      **sigmav2(r,a,v)) $ lva(a)
      ;

   ava1(r,a,v,t)$va1Flag(r,a)
      = ((va1.l(r,a,vOld,t)/va.l(r,a,vOld,t))*(pva1.l(r,a,vOld,t)/pva.l(r,a,vOld,t))
      **sigmav(r,a,v)) $ cra(a)
      + ((va1.l(r,a,vOld,t)/va.l(r,a,vOld,t))*(pva1.l(r,a,vOld,t)/pva.l(r,a,vOld,t))
      **sigmav(r,a,v)) $ lva(a)
      + ((va1.l(r,a,vOld,t)/va.l(r,a,vOld,t))*(pva1.l(r,a,vOld,t)/pva.l(r,a,vOld,t))
      **sigmav(r,a,v)) $ axa(a)
      ;

   ava2(r,a,v,t)$va2Flag(r,a)
      = ((va2.l(r,a,vOld,t)/va1.l(r,a,vOld,t))*(pva2.l(r,a,vOld,t)/pva1.l(r,a,vOld,t))
      **sigmav1(r,a,v)) $ cra(a)
      + ((va2.l(r,a,vOld,t)/va.l(r,a,vOld,t))*(pva2.l(r,a,vOld,t)/pva.l(r,a,vOld,t))
      **sigmav(r,a,v)) $ lva(a)
      ;

   aland(r,a,v,t)$landFlag(r,a)
      = ([lambdat.l(r,a,vOld,t)**(1-sigmav2(r,a,v))]*(land.l(r,a,t)/va2.l(r,a,vOld,t))*(plandp.l(r,a,t)/pva2.l(r,a,vOld,t))
      **sigmav2(r,a,v)) $ cra(a)
      + ([lambdat.l(r,a,vOld,t)**(1-sigmav2(r,a,v))]*(land.l(r,a,t)/va2.l(r,a,vOld,t))*(plandp.l(r,a,t)/pva2.l(r,a,vOld,t))
      **sigmav2(r,a,v)) $ lva(a)
      + ([lambdat.l(r,a,vOld,t)**(1-sigmav1(r,a,v))]*(land.l(r,a,t)/va1.l(r,a,vOld,t))*(plandp.l(r,a,t)/pva1.l(r,a,vOld,t))
      **sigmav1(r,a,v)) $ axa(a)
      ;

	akf(r,a,v,t)$kfFlag(r,a)
		= (kf.l(r,a,vOld,t)/kef.l(r,a,vOld,t))
		* (pkf.l(r,a,vOld,t)/pkef.l(r,a,vOld,t))**sigmakef(r,a,v) ;
	ae(r,a,v,t)$kfFlag(r,a)
		= (xnrg.l(r,a,vOld,t)/kef.l(r,a,vOld,t))
		* (pnrg.l(r,a,vOld,t)/pkef.l(r,a,vOld,t))**sigmakef(r,a,v) ;

	aksw(r,a,v,t) $ kFlag(r,a)
		= (ksw.l(r,a,vOld,t)/kf.l(r,a,vOld,t))
		* (pksw.l(r,a,vOld,t)/pkf.l(r,a,vOld,t))**sigmakf(r,a,v) ;
	anrf(r,a,v,t) $ nrfFlag(r,a)
		= (xnrf.l(r,a,t)/kf.l(r,a,vOld,t))
		* [lambdanrf.l(r,a,vOld,t)**(1-sigmakf(r,a,v))]
		* (pnrfp.l(r,a,t)/pkf.l(r,a,vOld,t))**sigmakf(r,a,v) ;

	aks(r,a,v,t) $ kFlag(r,a)
		= (ks.l(r,a,vOld,t)/ksw.l(r,a,vOld,t))
		* (pks.l(r,a,vOld,t)/pksw.l(r,a,vOld,t))**sigmakw(r,a,v) ;
	awat(r,a,v,t) $ watFlag(r,a)
		= (xwat.l(r,a,t) / ksw.l(r,a,vOld,t))
		* (pwat.l(r,a,t) / pksw.l(r,a,vOld,t))**sigmakw(r,a,v) ;

	ah2o(r,a,t) $ xwatfFlag(r,a)
		= (h2o.l(r,a,t)/xwat.l(r,a,t))
		* [lambdah2o.l(r,a,t)**(1-sigmawat(r,a))]
		* (ph2op.l(r,a,t)/pwat.l(r,a,t))**sigmawat(r,a) ;

	ak(r,a,v,t) $ kFlag(r,a)
		= (kv.l(r,a,vOld,t)/ks.l(r,a,vOld,t))
		* [lambdak.l(r,a,vOld,t)**(1-sigmak(r,a,v))]
		* [(pkp.l(r,a,vOld,t) / pks.l(r,a,vOld,t))**sigmak(r,a,v)] ;

	alab2(r,a,v,t) $ lab2Flag(r,a)
		= (lab2.l(r,a,t)  /ks.l(r,a,vOld,t))
		* (plab2.l(r,a,t)/pks.l(r,a,vOld,t))**sigmak(r,a,v) ;

	alab(r,l,a,t) $ labFlag(r,l,a)
		= (([lambdal.l(r,l,a,t)**(1-sigmaul(r,a))]*ld.l(r,l,a,t)/lab1.l(r,a,t))*(wagep.l(r,l,a,t)/plab1.l(r,a,t))**sigmaul(r,a))$ul(l)
		+ (([lambdal.l(r,l,a,t)**(1-sigmasl(r,a))]*ld.l(r,l,a,t)/lab2.l(r,a,t))*(wagep.l(r,l,a,t)/plab2.l(r,a,t))**sigmasl(r,a))$sl(l)
		;

	aio(r,i,a,t) $ xaFlag(r,i,a)
		= { [lambdaio.l(r,i,a,t)**(1-sigman1(r,a))]  * [xa.l(r,i,a,t)/nd1.l(r,a,t) ] * [pa.l(r,i,a,t)/pnd1.l(r,a,t)]**sigman1(r,a) } $ mapi1(i,a)
		+ { [lambdaio.l(r,i,a,t)**(1-sigman2(r,a))]  * [xa.l(r,i,a,t)/nd2.l(r,a,t) ] * [pa.l(r,i,a,t)/pnd2.l(r,a,t)]**sigman2(r,a) } $ mapi2(i,a)
		+ { [lambdaio.l(r,i,a,t)**(1-sigmawat(r,a))] * [xa.l(r,i,a,t)/xwat.l(r,a,t)] * [pa.l(r,i,a,t)/pwat.l(r,a,t)]**sigmawat(r,a)} $ iw(i)
		;

*  NRG bundle -- !!!! needs to be refined
* [EditJean]: IfNrgNest(r,a) is function of (r,a)

    anely(r,a,v,t)$(xnrgFlag(r,a) and IfNrgNest(r,a))
        = (xnely.l(r,a,vOld,t)/xnrg.l(r,a,vOld,t))
        *(pnely.l(r,a,vOld,t)/pnrg.l(r,a,vOld,t))**sigmae(r,a,v) ;
    aNRG(r,a,nrg,v,t)$(xnrgFlag(r,a) and IfNrgNest(r,a) and ely(nrg))
        = (xaNRG.l(r,a,nrg,vOld,t)/xnrg.l(r,a,vOld,t))
        *(paNRG.l(r,a,nrg,vOld,t)/pnrg.l(r,a,vOld,t))**sigmae(r,a,v) ;
    aolg(r,a,v,t)$(xnelyFlag(r,a) and IfNrgNest(r,a))
        = (xolg.l(r,a,vOld,t)/xnely.l(r,a,vOld,t))
        *(polg.l(r,a,vOld,t)/pnely.l(r,a,vOld,t))**sigmanely(r,a,v) ;
    aNRG(r,a,nrg,v,t)$(xnelyFlag(r,a) and IfNrgNest(r,a) and coa(nrg))
        = (xaNRG.l(r,a,nrg,vOld,t)/xnely.l(r,a,vOld,t))
        *(paNRG.l(r,a,nrg,vOld,t)/pnely.l(r,a,vOld,t))**sigmanely(r,a,v) ;
    aNRG(r,a,nrg,v,t)$(xolgFlag(r,a) and IfNrgNest(r,a) and gas(nrg))
        = (xaNRG.l(r,a,nrg,vOld,t)/xolg.l(r,a,vOld,t))
        *(paNRG.l(r,a,nrg,vOld,t)/polg.l(r,a,vOld,t))**sigmaOLG(r,a,v) ;
    aNRG(r,a,nrg,v,t)$(xolgFlag(r,a) and IfNrgNest(r,a) and oil(nrg))
        = (xaNRG.l(r,a,nrg,vOld,t)/xolg.l(r,a,vOld,t))
        *(paNRG.l(r,a,nrg,vOld,t)/polg.l(r,a,vOld,t))**sigmaOLG(r,a,v) ;

    aeio(r,e,a,v,t) $ xaFlag(r,e,a)
        = {sum(NRG$mape(NRG,e),
              [lambdae.l(r,e,a,vOld,t)**(1-sigmaNRG(r,a,NRG,v))]
            * [xa.l(r,e,a,t) /xaNRG.l(r,a,NRG,vOld,t)]
            * [(pa.l(r,e,a,t)/paNRG.l(r,a,NRG,vOld,t))**sigmaNRG(r,a,NRG,v)]
            )}${IfNrgNest(r,a)}

* Case: no NRG bundle

        + {[lambdae.l(r,e,a,vOld,t)**(1-sigmae(r,a,v))]
            * [xa.l(r,e,a,t)  / xnrg.l(r,a,vOld,t)]
            * [(pa.l(r,e,a,t) / pnrg.l(r,a,vOld,t))**sigmae(r,a,v)]
            }${NOT IfNrgNest(r,a)}
) ;

*------------------------------------------------------------------------------*
*																			   *
*  					Calibrate the 'make/use' module							   *
*																			   *
*------------------------------------------------------------------------------*

*	General Case:

* [EditJean]: tmat matrice de a --> i genre pow(a) --> elyi
* en fait ci-dessous gp(r,a,i) est juste cette matrice tmat avec des 1
* a la place des valeurs sauf si x(powa,elyi) est en TWh
* Dans ce cas 1/gp convertit des USD en TWh


loop(t0,

    gp(r,a,i) $ (xpFlag(r,a) and p.l(r,a,i,t0))
        = {  ( x.l(r,a,i,t0) / xp.l(r,a,t0))
		   * ( pp.l(r,a,t0)  / p.l(r,a,i,t0))**omegas(r,a)
		   } $ {omegas(r,a) ne inf}
        + {   ( p.l(r,a,i,t0) * x.l(r,a,i,t0))
			/ ( pp.l(r,a,t0) * xp.l(r,a,t0))
		  } $ {omegas(r,a) eq inf}    ;

* For non-elya sectors

   as(r,a,i,t) $ xsFlag(r,i)
        = {  (x.l(r,a,i,t0) / xs.l(r,i,t0))
		   * (TFP_xs.l(r,i,t0)**(1 - sigmas(r,i)))
           * (p.l(r,a,i,t0) / ps.l(r,i,t0))**sigmas(r,i)
		   } $ {sigmas(r,i) ne inf}
        + {  (p.l(r,a,i,t0) *  x.l(r,a,i,t0))
		   / (ps.l(r,i,t0)  * xs.l(r,i,t0))
		   } $ {sigmas(r,i) eq inf}   ;


*	Specific Case:	Calibrate power electricity supply / module

* OECD-ENV model: add CES case, similar calculations because ppbndx = ppb in t0

	IF(IfPower,

		IF(IfElyCES,

* Case: CES specification for Power bundle:

			apb(r,pb,elyi,t) $ xpb.l(r,pb,elyi,t0)
				= [xpb.l(r,pb,elyi,t0) / xpow.l(r,elyi,t0)]
				* [ppb.l(r,pb,elyi,t0) / ppow.l(r,elyi,t0)]**sigmapow(r,elyi)
				* [lambdapow(r,pb,elyi,t0)**( 1 - sigmapow(r,elyi))]
				;

			loop((powa,pb) $ mappow(pb,powa) ,
				as(r,powa,elyi,t) $ x.l(r,powa,elyi,t0)
					= [x.l(r,powa,elyi,t0) / xpb.l(r,pb,elyi,t0)]
					* [p.l(r,powa,elyi,t0) / ppb.l(r,pb,elyi,t0)]**sigmapb(r,pb,elyi)
					* [lambdapb(r,powa,elyi,t0)**(1 - sigmapb(r,pb,elyi))]
					;
			) ;

		ELSE

* Case: Additive-CES specification for Power bundle:

			apb(r,pb,elyi,t) $ xpb.l(r,pb,elyi,t0)
				= [xpb.l(r,pb,elyi,t0) / xpow.l(r,elyi,t0)]
				* [ppb.l(r,pb,elyi,t0) / ppowndx.l(r,elyi,t0)]**sigmapow(r,elyi)
				* [lambdapow(r,pb,elyi,t0)**sigmapow(r,elyi)]
				;

			loop((powa,pb) $ mappow(pb,powa) ,
				as(r,powa,elyi,t) $ x.l(r,powa,elyi,t0)
					= [x.l(r,powa,elyi,t0) / xpb.l(r,pb,elyi,t0)]
					* [p.l(r,powa,elyi,t0) / ppbndx.l(r,pb,elyi,t0)]**sigmapb(r,pb,elyi)
					* [lambdapb(r,powa,elyi,t0)**sigmapb(r,pb,elyi)]
					;
			) ;

        ) ;

* Upper Nest of electricity supply (CES(etd-a,XPOW))

        as(r,etda,elyi,t) $ x.l(r,etda,elyi,t0)
            = [x.l(r,etda,elyi,t0) / xs.l(r,elyi,t0)]
			* [TFP_xs.l(r,elyi,t0)**(1 - sigmael(r,elyi))]
            * [p.l(r,etda,elyi,t0) / ps.l(r,elyi,t0)]**sigmael(r,elyi) ;
        apow(r,elyi,t) $ xpow.l(r,elyi,t0)
            = [xpow.l(r,elyi,t0) / xs.l(r,elyi,t0)]
			* [TFP_xs.l(r,elyi,t0)**(1-sigmael(r,elyi))]
            * [ppow.l(r,elyi,t0) / ps.l(r,elyi,t0)]**sigmael(r,elyi) ;


* On ajuste p.l: Adj(r,powa) eq to GTAP prices

		IF(0 AND IfPowerVol,
			p.l(r,powa,elyi,t) = Adjpa(r,powa) ;

* Adjustment price Twh/USD

			Adjpa(r,powa) $  Adjpa(r,powa) =  pMwh0(r,powa) / Adjpa(r,powa) ;
		) ;

    ELSE

        sigmapow(r,elyi)   = NA ;
        sigmapb(r,pb,elyi) = NA ;
        apb(r,pb,elyi,t)   = 0 ;
        apow(r,elyi,t)     = 0 ;

    ) ;
) ;

IF(ifDyn and ifCal and IfDebug,
    execute_unload "%cBaseFile%_%system.fn%_ElectricityBundles.gdx",
		sigmapb, sigmapow, as, apow, apb, x, xpow, xpb, ppbndx, ppb, p.l ;
) ;

* --------------------------------------------------------------------------------------------------
*
*  Calibrate income distribution parameters
*
* --------------------------------------------------------------------------------------------------

*  Capital income allocation parameters

ydistf(r,t) = (1 - kappak.l(r,t))*(sum((a,v), pk.l(r,a,v,t)*kv.l(r,a,v,t))
            +      sum(a, pim.l(r,a,t)*xp.l(r,a,t)) - deprY.l(r,t)) ;
ydistf(r,t)$ydistf(r,t)   = yqtf.l(r,t) / ydistf(r,t) ;
chiTrust(r,t)$trustY.l(t) = yqht.l(r,t)/trustY.l(t) ;

*  Remittance parameters

chiRemit(rp,l,r,t)$remit.l(rp,l,r,t)
   = remit.l(rp,l,r,t)
   / ((1-kappal.l(r,l,t))*sum(a, wage.l(r,l,a,t)*ld.l(r,l,a,t))) ;

*------------------------------------------------------------------------------*
*																			   *
*					Calibrate final demand									   *
*																			   *
*------------------------------------------------------------------------------*

etah.fx(r,k,h,t) $ incElas(k,r) = incElas(k,r) ;

*	Define the ELES calibration model

model elescal / supyeq, xceq / ;
elescal.holdfixed = 1 ;

IF(%utility% = ELES,

* [OECD-ENV]: add dynamic calibration case for ELES
* [EditJean] -->  dans ENV-L theta.l & supy.l not divided by pop

*  ELES parameters

* Base case (%IfCalELES% == "dynamic") :  just t0-values are calculated

*    $$IFi %IfCalELES% == "dynamic" LOOP(t $ t0(t), !!

    muc.fx(r,k,h,t) $ xcFlag(r,k,h)
        = etah.l(r,k,h,t) * [pc.l(r,k,h,t) * xc.l(r,k,h,t) / yd.l(r,t)];
    mus.fx(r,h,t) $ yd.l(r,t)
        = 1 - sum(k $ muc.l(r,k,h,t), muc.l(r,k,h,t)) ; !! mus = savh / SUPY

* Initialize the subsistence minima (theta) and supernumary income (supy)

    theta.l(r,k,h,t)$ xcFlag(r,k,h) = 0.1 * xc.l(r,k,h,t) / pop.l(r,t) ;

*  Initialize per capita supernumery income (different form other Utility form)

    supy.l(r,h,t)   $ yd.l(r,t)
        = yd.l(r,t) / pop.l(r,t) - sum(k, pc.l(r,k,h,t) * theta.l(r,k,h,t)) ;

    theta.fx(r,k,h,t) $ (xcFlag(r,k,h) eq 0) = 0;
    betac.fx(r,h,t) = 1 ;

*  Fix temporarily the other variables

    yd.fx(r,t)     $ yd.l(r,t)     = yd.l(r,t) ;
    pc.fx(r,k,h,t) $ pc.l(r,k,h,t) = pc.l(r,k,h,t) ;
    xc.fx(r,k,h,t) $ xc.l(r,k,h,t) = xc.l(r,k,h,t) ;

*    $$IFi %IfCalELES%=="dynamic"  );

* [OECD-ENV]: Alternative calibration procedure No Optimisation [ENVISAGE Case]

   $$IfTheni.StatCalELES %IfCalELES%=="static"
 
        yd0(r)        = 1 ;
        theta0(r,k,h) = 1 ;
        xc0(r,k,h)    = 1 ;
        hshr0(r,k,h)  = 1 ;
        pc0(r,k,h)    = 1 ;
        supy0(r,h)    = 1 ;
        pop0(r)       = 1 ;
        savh0(r,h)    = 1 ;
        muc0(r,k,h)   = 1 ;

* Solve for the subsistence minima (all years)

        ts(t) = no ; ts(t0) = yes ;
        options limcol=0, limrow=0, solprint=off ;
        solve elescal using mcp ;

* Re-endogenize variables for static case

        yd.lo(r,t)       = -inf; yd.up(r,t)       = +inf;
        pc.lo(r,k,h,t)   = -inf; pc.up(r,k,h,t)   = +inf;
        xc.lo(r,k,h,t)   = -inf; xc.up(r,k,h,t)   = +inf;
        muc.lo(r,k,h,t)  = -inf; muc.up(r,k,h,t)  = +inf;
        etah.lo(r,k,h,t) = -inf; etah.up(r,k,h,t) = +inf;

        loop(t0,
            theta.l(r,k,h,t) = theta.l(r,k,h,t0) ;
            supy.l(r,h,t)    = supy.l(r,h,t0) ;
        ) ;

        ts(t) = no ;

    $$Else.StatCalELES

* Fix the variables determined by the solution in dynamic case [Base Case]

        theta.fx(r,k,h,t0) $ theta.l(r,k,h,t0) = theta.l(r,k,h,t0);
        supy.l(r,h,t0) = supy.l(r,h,t0);

    $$Endif.StatCalELES

    IF((ifDyn and ifCal) and IfDebug,
       Execute_unload "%cBaseFile%_%system.fn%_Preferences.gdx",
        etah, muc, theta, betac, supy, incElas, mus, hshr, yd, pc, xc ;
    ) ;

    ts(t) = no ;

*  !!!! if uFlag = 0, the input data should be fixed [TBC]
    loop(t0, uFlag(r,h)$(supy.l(r,h,t0) gt 0 and mus.l(r,h,t0) gt 0) = 1;);

    $$IFi %IfCalELES% =="dynamic" LOOP(t $ t0(t),

    u.l(r,h,t) $ uFlag(r,h)
        = supy.l(r,h,t)
        / (prod(k $ xcFlag(r,k,h), (pc.l(r,k,h,t)/muc.l(r,k,h,t))**muc.l(r,k,h,t))
        * ((pfd.l(r,h,t)/mus.l(r,h,t))**mus.l(r,h,t))
	) ;

    u.l(r,h,t) $ (not uFlag(r,h)) = 1 ;

*  u0(r,h) = 1 / u.l(r,h,t0); u.l(r,h,t0) = 1; !! on normalise par utilite de depart

*  Recalibration of eta's:

* [EditJean]: why since same muc's and budget shares ?

    etah.l(r,k,h,t) $ xcFlag(r,k,h)
        = muc.l(r,k,h,t)
        / [pc.l(r,k,h,t) * xc.l(r,k,h,t) / yd.l(r,t)] ;

    epsh.l(r,k,kp,h,t) $( xcFlag(r,k,h) and xcFlag(r,kp,h))
        = - muc.l(r,k,h,t)
        *  pc.l(r,kp,h,t) * [pop.l(r,t) * theta.l(r,kp,h,t)]
        / [pc.l(r,k,h,t) * xc.l(r,k,h,t) ]
        -  kron(k,kp) * [1 - pop.l(r,t) * theta.l(r,k,h,t) / xc.l(r,k,h,t) ] ;

    $$IFi %IfCalELES% =="dynamic" ) ;

* [OECD-ENV]: New case

    $$IfTheni.DynCalELES %IfCalELES% =="dynamic"

* Assume constant coefficients by default for all the projection period

        LOOP(t0,
            loop(t $ (ord(t) gt 1),
                etah.fx(r,k,h,t) $ etah.l(r,k,h,t0)  = etah.l(r,k,h,t0) ;
                theta.fx(r,k,h,t)$ theta.l(r,k,h,t0) = theta.l(r,k,h,t0);
                muc.fx(r,k,h,t)  $ muc.l(r,k,h,t0)   = muc.l(r,k,h,t0)  ;
                mus.fx(r,h,t)                        = mus.l(r,h,t0)    ;
                betac.fx(r,h,t)                      = betac.l(r,h,t0)  ;
            );
            riswork(r,is) = 0;
            riswork(r,h)
                = sum(k, theta.l(r,k,h,t0) * pop.l(r,t0) * pc.l(r,k,h,t0)) ;
            IF(ifCal,
				display "Subsistance expenditures (%system.fn%.gms):", riswork;
			) ;
            riswork(r,h) = yd.l(r,t0) - riswork(r,h); !! supernumerary income
            implicit_frisch(r,h,t0) $ riswork(r,h)
                = - yd.l(r,t0) / riswork(r,h) ;
            IF(ifCal,
                display "Implicit Frish parameter after ELES_calibration solving (%system.fn%.gms)", implicit_frisch ;
            ) ;
        );

    $$Endif.DynCalELES

ELSEIF(%utility% = CD),

*  Cobb-Douglas

    betac.fx(r,h,t)   = 1 ;
    muc.l(r,k,h,t) $ xcFlag(r,k,h)
        = pc.l(r,k,h,t) * xc.l(r,k,h,t) / [yd.l(r,t) - savh.l(r,h,t)] ;

    theta.l(r,k,h,t) = 0 ;

    supy.l(r,h,t)
        = [yd.l(r,t) - savh.l(r,h,t)] / pop.l(r,t)
        - sum(k, pc.l(r,k,h,t)*theta.l(r,k,h,t)) ;

    alphaad.fx(r,k,h,t) = muc.l(r,k,h,t) ;
    betaad.fx(r,k,h,t)  = muc.l(r,k,h,t) ;

    u.l(r,h,t) = 1 ;

    aad.fx(r,h,t) = exp(sum(k$xcFlag(r,k,h),
                           muc.l(r,k,h,t)*log(xc.l(r,k,h,t)/pop.l(r,t) - theta.l(r,k,h,t)))
                 - u.l(r,h,t) - 1) ;

    etah.l(r,k,h,t) $ xcFlag(r,k,h) = 1 ;

    epsh.l(r,k,kp,h,t) $ (xcFlag(r,k,h) and xcFlag(r,kp,h))
        = -1$(ord(k) eq ord(kp))
        +  0$(ord(k) ne ord(kp))
        ;

elseIF(%utility% = LES or %utility% = AIDADS),

*  LES parameters

*  !!!! Needs to be replaced
*  Function calibrated to frisch(500) = -4, frisch(40000) = -1.10  with pc incomes in '000

   loop(t0,
      frisch(r,h,t)
		= -1.0 / (1 - 0.770304 * exp(-0.053423 * rgdppc.l(r,t) * 0.001 * popScale / inScale) ) ;
   ) ;

   display frisch ;

   betac.fx(r,h,t)   = 1 ;
   muc.l(r,k,h,t)$xcFlag(r,k,h)   = etah.l(r,k,h,t)*pc.l(r,k,h,t)*xc.l(r,k,h,t)
                                  / (yd.l(r,t) - savh.l(r,h,t)) ;
   theta.l(r,k,h,t)$xcFlag(r,k,h) = (yd.l(r,t) - savh.l(r,h,t))*(hshr.l(r,k,h,t)
                                  + muc.l(r,k,h,t)/frisch(r,h,t))/pc.l(r,k,h,t) ;
   theta.l(r,k,h,t) = theta.l(r,k,h,t) / pop.l(r,t) ;
   supy.l(r,h,t) = (yd.l(r,t)-savh.l(r,h,t))/pop.l(r,t)
                 -  sum(k, pc.l(r,k,h,t)*theta.l(r,k,h,t)) ;

   alphaad.fx(r,k,h,t) = muc.l(r,k,h,t) ;
   betaad.fx(r,k,h,t)  = muc.l(r,k,h,t) ;

   u.l(r,h,t) = 1 ;

   aad.fx(r,h,t) = exp(sum(k$xcFlag(r,k,h),
                           muc.l(r,k,h,t)*log(xc.l(r,k,h,t)/pop.l(r,t) - theta.l(r,k,h,t)))
                 - u.l(r,h,t) - 1) ;

   loop(t$t0(t),
      omegaad.fx(r,h)
         = sum(k$xcFlag(r,k,h), (betaad.l(r,k,h,t)-alphaad.l(r,k,h,t))
         *     log(xc.l(r,k,h,t)/pop.l(r,t) - theta.l(r,k,h,t)))
         - power(1+exp(u.l(r,h,t)),2)*exp(-u.l(r,h,t)) ;
   ) ;
   omegaad.fx(r,h) = 1/omegaad.l(r,h) ;

   etah.l(r,k,h,t)$xcFlag(r,k,h) = (muc.l(r,k,h,t)
      - (betaad.l(r,k,h,t)-alphaad.l(r,k,h,t))*omegaad.l(r,h)) / hshr.l(r,k,h,t) ;

   epsh.l(r,k,kp,h,t)$(xcFlag(r,k,h) and xcFlag(r,kp,h))
      = (muc.l(r,kp,h,t)-kron(k,kp))
      * (muc.l(r,k,h,t)*supy.l(r,h,t))
      / (hshr.l(r,k,h,t)*((yd.l(r,t)-(savh.l(r,h,t)))/pop.l(r,t)))
      - (hshr.l(r,kp,h,t)*etah.l(r,k,h,t)) ;

elseif (%utility% = CDE),

*  !!!! TO BE REVIEWED
* [EditJean] : Attention a "total"
   u.l(r,h,t)     = 1 ;
   eh.fx(r,k,h,t) = eh0(k,r) ;
   bh.fx(r,k,h,t) = bh0(k,r) ;
   alphah.fx(r,k,h,t)$xcFlag(r,k,h) = (hshr.l(r,k,h,t)/bh.l(r,k,h,t))
      * (((yfd.l(r,h,t)/pop.l(r,t))/pc.l(r,k,h,t))**bh.l(r,k,h,t))
      * (u.l(r,h,t)**(-bh.l(r,k,h,t)*eh.l(r,k,h,t)))
      / sum(kp$xcFlag(r,kp,h), hshr.l(r,kp,h,t)/bh.l(r,kp,h,t)) ;

   theta.l(r,k,h,t) = alphah.l(r,k,h,t)*bh.l(r,k,h,t)*(u.l(r,h,t)**(eh.l(r,k,h,t)*bh.l(r,k,h,t)))
                    *  (pc.l(r,k,h,t)/(yfd.l(r,h,t)/pop.l(r,t)))**bh.l(r,k,h,t) ;

   etah.l(r,k,h,t)$xcFlag(r,k,h) =
      (eh.l(r,k,h,t)*bh.l(r,k,h,t) - sum(kp$xcFlag(r,kp,h),
         hshr.l(r,kp,h,t)*eh.l(r,kp,h,t)*bh.l(r,kp,h,t)))
      / sum(kp$xcFlag(r,kp,h), hshr.l(r,kp,h,t)*eh.l(r,kp,h,t)) - (bh.l(r,k,h,t)-1)
      + sum(kp$xcFlag(r,kp,h), hshr.l(r,kp,h,t)*bh.l(r,kp,h,t)) ;

   epsh.l(r,k,kp,h,t)$(xcFlag(r,k,h) and xcFlag(r,kp,h)) =
      (hshr.l(r,kp,h,t)*(-bh.l(r,kp,h,t)
       - (eh.l(r,k,h,t)*bh.l(r,k,h,t) - sum(k1$xcFlag(r,k1,h),
          hshr.l(r,k1,h,t)*eh.l(r,k1,h,t)*bh.l(r,k1,h,t)))
       /  sum(k1$xcFlag(r,k1,h), hshr.l(r,k1,h,t)*eh.l(r,k1,h,t))) + kron(k,kp)*(bh.l(r,k,h,t)-1)) ;
) ;

*  Calibrate the rest of the consumer demand nesting

loop(t0,

* Non-energy bundles CES-coefficients

   acxnnrg(r,k,h) $ xcnnrgFlag(r,k,h)
      = (xcnnrg.l(r,k,h,t0)/xc.l(r,k,h,t0))
      * (pcnnrg.l(r,k,h,t0)/pc.l(r,k,h,t0))**nu(r,k,h) ;

* Energy bundles CES-coefficients

   acxnrg(r,k,h) $ xcnrgFlag(r,k,h)
      = (xcnrg.l(r,k,h,t0)/xc.l(r,k,h,t0))
      * (pcnrg.l(r,k,h,t0)/pc.l(r,k,h,t0))**nu(r,k,h) ;

* Commodity Demand in non-energy bundle: CES-coefficients

   ac(r,i,k,h) $ (xcnnrgFlag(r,k,h) and not e(i) and pa.l(r,i,h,t0))
      = [(cmat(i,k,r)/pa.l(r,i,h,t0))/xcnnrg.l(r,k,h,t0)]
      * [pa.l(r,i,h,t0)/pcnnrg.l(r,k,h,t0)]**nunnrg(r,k,h) ;

*   Decomposition Energy bundle when IfNrgNest(r,h)

   acnely(r,k,h,t) $ xcnelyFlag(r,k,h)
      = (xcnely.l(r,k,h,t)/xcnrg.l(r,k,h,t0))
      * (pcnely.l(r,k,h,t0)/pcnrg.l(r,k,h,t0))**nue(r,k,h) ;
   acolg(r,k,h,t) $ xcolgFlag(r,k,h)
      = (xcolg.l(r,k,h,t)/xcnely.l(r,k,h,t0))
      * (pcolg.l(r,k,h,t0)/pcnely.l(r,k,h,t0))**nunely(r,k,h) ;
   acNRG(r,k,h,NRG,t) $ xacNRGFlag(r,k,h,NRG)
      = {(xacNRG.l(r,k,h,NRG,t0)/xcnrg.l(r,k,h,t0))
            * [pacNRG.l(r,k,h,NRG,t0)/pcnrg.l(r,k,h,t0) ]**nue(r,k,h)
        } $ ely(nrg)
      + {(xacNRG.l(r,k,h,NRG,t0)/xcnely.l(r,k,h,t0))
            * [pacNRG.l(r,k,h,NRG,t0)/pcnely.l(r,k,h,t0)]**nunely(r,k,h)
        } $ coa(nrg)
      + {(xacNRG.l(r,k,h,NRG,t0)/xcolg.l(r,k,h,t0))
            * [pacNRG.l(r,k,h,NRG,t0)/pcolg.l(r,k,h,t0) ]**nuolg(r,k,h)
        } $ gas(nrg)
      + {(xacNRG.l(r,k,h,NRG,t0)/xcolg.l(r,k,h,t0))
            * [pacNRG.l(r,k,h,NRG,t0)/pcolg.l(r,k,h,t0) ]**nuolg(r,k,h)
        } $ oil(nrg) ;

*   Energy Demand: CES-coefficients in Energy bundles

     loop(mape(NRG,e),
        ac(r,e,k,h) $ (xacNRGFlag(r,k,h,NRG) and xaFlag(r,e,h))
            = [(cmat(e,k,r)/pa.l(r,e,h,t0)) / xacNRG.l(r,k,h,NRG,t0)]
            * [lambdace.l(r,e,k,h,t0)**(1-nuNRG(r,k,h,NRG))]
            * [pa.l(r,e,h,t0)/pacNRG.l(r,k,h,NRG,t0)]**nuNRG(r,k,h,NRG);
     ) ;

*   Energy Demand: CES-coefficients when no Energy bundles

     ac(r,e,k,h) $ (xcnrgFlag(r,k,h) and xaFlag(r,e,h))
        = [(cmat(e,k,r)/pa.l(r,e,h,t0))/xcnrg.l(r,k,h,t0)]
        * [lambdace.l(r,e,k,h,t0)**(1-nue(r,k,h))]
        * [pa.l(r,e,h,t0)/pcnrg.l(r,k,h,t0)]**nue(r,k,h);

 ) ;

* [EditJean]: Add
PARAMETER ac0(r,i,k,h) "initial CES share for households energy bundle";
ac0(r,i,k,h) = ac(r,i,k,h);

* [EditJean]: Add lambdafd on Other final demands
sigmafd(r,fdc) $ (sigmafd(r,fdc) eq 1) = 1.01 ;
alphafd(r,i,fdc,t)$xfd.l(r,fdc,t)
    = [xa.l(r,i,fdc,t)/xfd.l(r,fdc,t)]
    * [lambdafd.l(r,i,fdc,t)**(1-sigmafd(r,fdc))]
    * [(pa.l(r,i,fdc,t)/pfd.l(r,fdc,t))**sigmafd(r,fdc)] ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       Calibrate trade module                                 *
*                                                                              *
*------------------------------------------------------------------------------*

*   First level Armington: xa=CES(xdt-xtt,xmt)

sigmamt(r,i) $ (sigmamt(r,i) eq 1.0) = 1.01;

* [OECD-ENV]: Add lambdaxd and lambdaxm but only for IfArmFlag = 0

* National sourcing (IfArmFlag = 0)

alphadt(r,i,t) $ xddFlag(r,i)
    = [(xdt.l(r,i,t) - xtt.l(r,i,t)) / xat.l(r,i,t)]
    * [lambdaxd(r,i,t)**(1-sigmamt(r,i))]
    * [(pdt.l(r,i,t) / pat.l(r,i,t))**sigmamt(r,i)];

alphamt(r,i,t) $ xmtFlag(r,i)
    = [xmt.l(r,i,t) / xat.l(r,i,t)]
    * [lambdaxm(r,i,t)**(1-sigmamt(r,i))]
    * [(pmt.l(r,i,t) / pat.l(r,i,t))**sigmamt(r,i)];

* Agent sourcing (IfArmFlag = 1)

alphad(r,i,aa,t) $ (xdFlag(r,i,aa) and xaFlag(r,i,aa) and IfArmFlag)
    = (xd.l(r,i,aa,t) / xa.l(r,i,aa,t))
    * (pd.l(r,i,aa,t) / pa.l(r,i,aa,t))**sigmam(r,i,aa) ;
alpham(r,i,aa,t) $ (xmFlag(r,i,aa) and xaFlag(r,i,aa) and IfArmFlag)
    = (xm.l(r,i,aa,t) / xa.l(r,i,aa,t))
    * (pm.l(r,i,aa,t) / pa.l(r,i,aa,t))**sigmam(r,i,aa) ;

*  Second level Armington
sigmaw(r,i)$(sigmaw(r,i) eq 1) = 1.01 ;

* [OECD-ENV]: Add IfCoeffCes: if =1 --> sum of the CES-coefficients = 1
lambdaw(r,i,rp,t) $ xwFlag(r,i,rp) = pdm.l(r,i,rp,t) * m_CESadj;

alphaw(rp,i,r,t) $ xwFlag(rp,i,r)
    = [xw.l(rp,i,r,t) / xmt.l(r,i,t)]
    * [lambdaw(rp,i,r,t)**(1-sigmaw(r,i))]
    * [(pdm.l(rp,i,r,t) / pmt.l(r,i,t))**sigmaw(r,i)] ;

*  Top level CET

gammad(r,i,t)$xdtFlag(r,i)
    = {   (xdt.l(r,i,t)/xs.l(r,i,t))
       *  (gammaesd(r,i)**(1+omegax(r,i)))
       *  (ps.l(r,i,t)/pdt.l(r,i,t))**omegax(r,i)
       } $ {omegax(r,i) ne inf}
    + {
*[EditJean]: ceci plutot?
       pdt.l(r,i,t) * xdt.l(r,i,t) / (ps.l(r,i,t)*xs.l(r,i,t))
*        pdt.l(r,i,t) * xdt.l(r,i,t) / (gammaesd(r,i)*ps.l(r,i,t)*xs.l(r,i,t))

      } $ {omegax(r,i) eq inf} ;
gammae(r,i,t)$xetFlag(r,i)
    = {(xet.l(r,i,t)/xs.l(r,i,t))
    *   (gammaese(r,i)**(1+omegax(r,i)))
    *   (ps.l(r,i,t)/pet.l(r,i,t))**omegax(r,i)}
    $ {omegax(r,i) ne inf}
    + {
*[EditJean]: correct an error (does not work without this correction)
    pet.l(r,i,t) * xet.l(r,i,t) / (ps.l(r,i,t)*xs.l(r,i,t))
*    pet.l(r,i,t) * xet.l(r,i,t) / (gammaese(r,i)*ps.l(r,i,t)*xs.l(r,i,t))
      } $ {omegax(r,i) eq inf};

*  Second level CET

gammaw(r,i,rp,t) $ xwFlag(r,i,rp)
    = {(xw.l(r,i,rp,t)/xet.l(r,i,t))
        *  [gammaew(r,i,rp)**(1+omegaw(r,i))]
        *  [(pet.l(r,i,t)/pe.l(r,i,rp,t))**omegaw(r,i)]
      } $ {omegaw(r,i) ne inf}
    + {
*[EditJean]: ceci plutot?
*        pe.l(r,i,rp,t)*xw.l(r,i,rp,t)/(pet.l(r,i,t)*xet.l(r,i,t))
        pe.l(r,i,rp,t) * xw.l(r,i,rp,t)
            / (gammaew(r,i,rp) * pet.l(r,i,t)*xet.l(r,i,t))
      } $ {omegaw(r,i) eq inf};

put screen ; put / ;
loop(t0,
   loop((img,r,i,rp),
      IF(tmgFlag(r,i,rp) and xwmg.l(r,i,rp,t0) eq 0,
         put img.tl, r.tl, i.tl, rp.tl / ;
      ) ;
   ) ;
   amgm(img,r,i,rp)$tmgFlag(r,i,rp) = xmgm.l(img,r,i,rp,t0) / xwmg.l(r,i,rp,t0) ;
) ;
putclose screen ;

sigmamg(img)$(sigmamg(img) eq 1) = 1.01 ;
alphatt(r,img,t)$xttFlag(r,img)  = (xtt.l(r,img,t)/xtmg.l(img,t))
                                 * (pdt.l(r,img,t)/ptmg.l(img,t))**sigmamg(img) ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       Calibration of factor supplies                         *
*                                                                              *
*------------------------------------------------------------------------------*

kronm(rur) = -1 ;
kronm(urb) = +1 ;

chim(r,l,t) $ migrFlag(r,l) = migr.l(r,l,t) * urbPrem.l(r,l,t)**(-omegam(r,l)) ;

***HRR: added kflag(r,a)
gammak(r,a,v,t) $ kflag(r,a)
	= {  [kv.l(r,a,v,t) / tkaps.l(r,t)]
	   * [trent.l(r,t) / pk.l(r,a,v,t)]**omegak(r) } $ {omegak(r) ne inf}
	+ {  [pk.l(r,a,v,t)*kv.l(r,a,v,t)]
	   / [trent.l(r,t) * tkaps.l(r,t)] 	} $ {omegak(r) eq inf}
	;

IF(sum((r,t0), tland.l(r,t0)) ne 0,

   loop(t0,

*     Curvature parameter in land supply function

		gammatl(r,t)
			= {0} $ {(%TASS% eq KELAS) OR (%TASS% eq INFTY)}
			+ {etat(r) * [pgdpmp.l(r,t0) / ptland.l(r,t0)]
					   * [landmax.l(r,t0) / (landmax.l(r,t0) - tland.l(r,t0))]
			  }   $ (%TASS% eq LOGIST)
            + {etat(r) * tland.l(r,t0)
			   / [landmax.l(r,t0) - tland.l(r,t0)] } $ {%TASS% eq HYPERB}
			;

*     Shift parameter in land supply function (is a variable for OECD-ENV model)

        chiLand.fx(r,t)
            = { tland.l(r,t0) * [pgdpmp.l(r,t0) / ptland.l(r,t0)]**etat(r)
			  }   $ {%TASS% eq KELAS}
			+ { exp( gammatl(r,t0) * [ptland.l(r,t0)/pgdpmp.l(r,t0)] )
				* [landmax.l(r,t0) - tland.l(r,t0)] / tland.l(r,t0)
			  }   $ (%TASS% eq LOGIST)
			+ {  [ landmax.l(r,t0) - tland.l(r,t0)]
			   * [ptland.l(r,t0) / pgdpmp.l(r,t0)]**gammatl(r,t0)
			  }   $ {%TASS% eq HYPERB}
			+ {0} $ {%TASS% eq INFTY}
			;

   ) ;

	loop(lb $ lb1(lb),
		gamlb(r,lb,t) $ tlandFlag(r)
			= {   (xlb.l(r,lb,t) / tland.l(r,t))
				* [ptland.l(r,t) / plb.l(r,lb,t)]**omegat(r)
			  } $ {omegat(r) ne inf}
			+ { plb.l(r,lb,t) * xlb.l(r,lb,t) / (ptland.l(r,t) * tland.l(r,t))
			  } $ {omegat(r) eq inf}
			;
	) ;

	gamnlb(r,t) $ tlandFlag(r)
		= {
		 (xnlb.l(r,t) / tland.l(r,t)) * (ptland.l(r,t) / pnlb.l(r,t))**omegat(r)
		  } $ {omegat(r) ne inf}
		+ { pnlb.l(r,t) * xnlb.l(r,t) / (ptland.l(r,t)*tland.l(r,t))
		  } $ {omegat(r) eq inf}
	;

    loop(lb$(not lb1(lb)),
        gamlb(r,lb,t) $ (xnlb.l(r,t) and plb.l(r,lb,t))
            = {  (xlb.l(r,lb,t)/xnlb.l(r,t))
               * (pnlb.l(r,t)/plb.l(r,lb,t))**omeganlb(r)
              }${omeganlb(r) ne inf}
            + {  (plb.l(r,lb,t)*xlb.l(r,lb,t))
               / (pnlb.l(r,t)*xnlb.l(r,t))
              } $ {omeganlb(r) eq inf}
                                ;
    ) ;

   loop(maplb(lb,a),
      gammat(r,a,t)$(xlb.l(r,lb,t) and land.l(r,a,t))
        = ((land.l(r,a,t)/xlb.l(r,lb,t))
                                  *  (plb.l(r,lb,t)/pland.l(r,a,t))**omegalb(r,lb))
                                  $(omegalb(r,lb) ne inf)
                                  + ((pland.l(r,a,t)*land.l(r,a,t))/(plb.l(r,lb,t)*xlb.l(r,lb,t)))
                                  $(omegalb(r,lb) eq inf)
                                  ;
   ) ;
) ;

*  Natural resource supply

* Set flag to infinity if either of the elasticities is infinite

nrfFlag(r,a)
    $ (nrfFlag(r,a) and (etanrfx(r,a,"lo") = inf or etanrfx(r,a,"hi") = inf))
    = inf ;

etanrf.l(r,a,t) $ (nrfFlag(r,a) and nrfFlag(r,a) ne inf)
   = etanrfx(r,a,"lo") + 0.5 * (etanrfx(r,a,"hi") - etanrfx(r,a,"lo")) ;

* [EditJean]: --> chinrfp =1

loop(t0,
   chinrfp(r,a) $ nrfFlag(r,a)
    = (pgdpmp.l(r,t0) / pnrf.l(r,a,t0)) $ {nrfFlag(r,a) eq inf}
    + (1) $ {nrfFlag(r,a) ne inf} ;
) ;

chinrf.fx(r,a,t) $ nrfFlag(r,a) = 1 ;
wchinrf.fx(a,t)                 = 1 ;

*  Water supply

IF(IFWATER,
   loop(t0,

*     Curvature parameter in land supply function

      gammatw(r,t) = (etaw(r))$(%WASS% eq KELAS)
                   + (etaw(r)*(pgdpmp.l(r,t0)/pth2o.l(r,t0))*(H2OMax.l(r,t0)
                   / (H2OMax.l(r,t0) - th2o.l(r,t0))))$(%WASS% eq LOGIST)
                   + (etaw(r)*th2o.l(r,t0)/(H2OMax.l(r,t0) - th2o.l(r,t0)))$(%WASS% eq HYPERB)
                   + (0)$(%WASS% eq INFTY)
                   ;

*     Shift parameter in land supply function

      chiH2O(r,t)  = (th2o.l(r,t0)*(pgdpmp.l(r,t0)/pth2o.l(r,t0))**etaw(r))$(%WASS% eq KELAS)
                   + (exp(gammatw(r,t0)*(pth2o.l(r,t0)/pgdpmp.l(r,t0)))
                   *  ((H2OMax.l(r,t0) - th2o.l(r,t0))/th2o.l(r,t0)))$(%WASS% eq LOGIST)
                   + ((H2OMax.l(r,t0) - th2o.l(r,t0))
                   *  (pth2o.l(r,t0)/pgdpmp.l(r,t0))**gammatw(r,t0))$(%WASS% eq HYPERB)
                   + (0)$(%WASS% eq INFTY)
                   ;
   ) ;
) ;


loop(t0,

*  Land CET: top level

   gam1h2o(r,wbnd1,t)$th2om.l(r,t)
       = ((h2obnd.l(r,wbnd1,t)/th2om.l(r,t))
       *  (pth2ondx.l(r,t)/ph2obnd.l(r,wbnd1,t))**omegaw1(r))$(omegaw1(r) ne inf)
       + (h2obnd.l(r,wbnd1,t)*h2obnd.l(r,wbnd1,t)/(pth2o.l(r,t)*th2om.l(r,t)))$(omegaw1(r) eq inf)
       ;

*  Land CET: second level

   loop(wbnd1,
      gam2h2o(r,wbnd2,t)$(mapw1(wbnd1,wbnd2) and h2obnd.l(r,wbnd1,t))
         = ((h2obnd.l(r,wbnd2,t)/h2obnd.l(r,wbnd1,t))
         *  (ph2obndndx.l(r,wbnd1,t)/ph2obnd.l(r,wbnd2,t))**omegaw2(r,wbnd1))
         $(omegaw2(r,wbnd1) ne inf)
         + ((ph2obnd.l(r,wbnd2,t)*h2obnd.l(r,wbnd2,t))*(ph2obnd.l(r,wbnd1,t)*h2obnd.l(r,wbnd1,t)))
         $(omegaw2(r,wbnd1) eq inf) ;
   ) ;

*  Land CET: activity level

   loop(wbnd2$wbnda(wbnd2),
      gam3h2o(r,a,t)$h2obnd.l(r,wbnd2,t)
         = ((h2o.l(r,a,t)/h2obnd.l(r,wbnd2,t))
         *  (ph2obndndx.l(r,wbnd2,t)/ph2o.l(r,a,t))**omegaw2(r,wbnd2))$(omegaw2(r,wbnd2) ne inf)
         + ((ph2o.l(r,a,t)*h2o.l(r,a,t))*(ph2obnd.l(r,wbnd2,t)*h2obnd.l(r,wbnd2,t)))
         $(omegaw2(r,wbnd2) eq inf) ;

   ) ;

*  Aggregate demand shifter

   loop(wbnd2$wbndi(wbnd2),
      ah2obnd(r,wbnd2,t)$h2obnd.l(r,wbnd2,t) = h2obnd.l(r,wbnd2,t)
         * (ph2obnd.l(r,wbnd2,t) / pgdpmp.l(r,t))**epsh2obnd(r,wbnd2) ;
   ) ;
) ;

*------------------------------------------------------------------------------*
*           Miscellaneous calibration                                          *
*------------------------------------------------------------------------------*

loop(t0,

    work = sum((r,j,rp) $ (rmuv(r) and imuv(j)), pwe.l(r,j,rp,t0) * xw.l(r,j,rp,t0)) ;
    phiw(r,i,rp,t)$(rmuv(r) and imuv(i)) = xw.l(r,i,rp,t0) / work ;
    chimuv = pmuv.l(t0)
           / sum((r,i,rp)$(rmuv(r) and imuv(i)), phiw(r,i,rp,t0) * pwe.l(r,i,rp,t0)) ;

    loop(r,
        work = sum((i,fd), pa.l(r,i,fd,t0)*xa.l(r,i,fd,t0)) ;
        if(work,
            phia(r,i,fd,t) = xa.l(r,i,fd,t0) / work ;
            chi(r,fd)$sum(i, phia(r,i,fd,t0)*pa.l(r,i,fd,t0))
               = pfd.l(r,fd,t0) / sum(i, phia(r,i,fd,t0)*pa.l(r,i,fd,t0)) ;
        ) ;
    ) ;

    loop(a,
      work = sum(r, pp.l(r,a,t0) * xp.l(r,a,t0)) ;
      phipw(r,a,t) $ work = xp.l(r,a,t0) / work ;
    ) ;

) ;

*------------------------------------------------------------------------------*
*                                                                              *
*               Normalize variables                                            *
*                                                                              *
*------------------------------------------------------------------------------*


$setGlobal IfNorm 1

$ifthen "%IfNorm%" == "1"

*  Turn on normalization

$macro normg0(varName,suffix)   &varName&suffix = &varName.l(t0)  ; \
                                varName.l(t) = 0 + 1$varName.l(t) ; \

$macro normg1(varName,i__1,suffix) &varName&suffix(i__1) = &varName.l(i__1,t0)  ; \
                                    varName.l(i__1,t) = 0 + 1$varName.l(i__1,t) ; \
$macro normg4(varName,i__1,i__2,i__3,i__4,suffix)                               \
    &varName&suffix(i__1,i__2,i__3,i__4) = &varName.l(i__1,i__2,i__3,i__4,t0) ; \
    varName.l(i__1,i__2,i__3,i__4,t) = 0 + 1$varName.l(i__1,i__2,i__3,i__4,t) ; \

$macro norm0(varName,suffix) &varName&suffix(r) = &varName.l(r,t0)  ; \
                              varName.l(r,t) = 0 + 1$varName.l(r,t) ; \

$macro norm1(varName,i__1,suffix)                         \
    &varName&suffix(r,i__1) = &varName.l(r,i__1,t0) ;     \
        varName.l(r,i__1,t) = 0 + 1$varName.l(r,i__1,t) ; \

$macro norm2(varName,i__1,i__2,suffix)                               \
        &varName&suffix(r,i__1,i__2) = &varName.l(r,i__1,i__2,t0)  ; \
         varName.l(r,i__1,i__2,t) = 0 + 1$varName.l(r,i__1,i__2,t) ; \

$macro norm3(varName,i__1,i__2,i__3,suffix)                                  \
    &varName&suffix(r,i__1,i__2,i__3) = &varName.l(r,i__1,i__2,i__3,t0)  ;   \
     varName.l(r,i__1,i__2,i__3,t) = 0 + 1 $ varName.l(r,i__1,i__2,i__3,t) ; \

* vOld in second line
$macro norm1v(varName,i__1,suffix)                                     \
    loop(vOld, &varName&suffix(r,i__1) = &varName.l(r,i__1,vOld,t0) ;  \
    varName.l(r,i__1,vOld,t) = 0 + 1$varName.l(r,i__1,vOld,t) ; ) ;    \

* v in second line
$macro norm1vp(varName,i__1,suffix)                                   \
    loop(vOld, &varName&suffix(r,i__1) = &varName.l(r,i__1,vOld,t0) ; \
    varName.l(r,i__1,v,t) = 0 + 1$varName.l(r,i__1,v,t) ; ) ;         \

$macro norm2v(varName,i__1,i__2,suffix)                                         \
    loop(vOld, &varName&suffix(r,i__1,i__2) = &varName.l(r,i__1,i__2,vOld,t0) ; \
    varName.l(r,i__1,i__2,vOld,t) = 0 + 1$varName.l(r,i__1,i__2,vOld,t) ; ) ;   \

$macro norm2vp(varName,i__1,i__2,suffix)                                        \
    loop(vOld, &varName&suffix(r,i__1,i__2) = &varName.l(r,i__1,i__2,vOld,t0) ; \
    varName.l(r,i__1,i__2,v,t) = 0 + 1$varName.l(r,i__1,i__2,v,t) ; ) ;         \

* [OECD-ENV]: add macros for time-dependent scales

$macro norm1t(varName,i__1,suffix)                    \
  &varName&suffix(r,i__1,t) = &varName.l(r,i__1,t0) ; \
  varName.l(r,i__1,t) = 0 + 1$varName.l(r,i__1,t) ;   \

$macro norm2t(varName,i__1,i__2,suffix)                         \
  &varName&suffix(r,i__1,i__2,t) = &varName.l(r,i__1,i__2,t0) ; \
  varName.l(r,i__1,i__2,t) = 0 + 1$varName.l(r,i__1,i__2,t) ;   \

$macro norm3t(varName,i__1,i__2,i__3,suffix)                               \
  &varName&suffix(r,i__1,i__2,i__3,t) = &varName.l(r,i__1,i__2,i__3,t0)  ; \
  varName.l(r,i__1,i__2,i__3,t) = 0 + 1$varName.l(r,i__1,i__2,i__3,t) ;    \

$macro norm1vt(varName,i__1,suffix)                                   \
  loop(vOld, &varName&suffix(r,i__1,t) = &varName.l(r,i__1,vOld,t0) ; \
  varName.l(r,i__1,vOld,t) = 0 + 1$varName.l(r,i__1,vOld,t) ; ) ;     \

$macro norm2vt(varName,i__1,i__2,suffix)                                       \
  loop(vOld, &varName&suffix(r,i__1,i__2,t) = &varName.l(r,i__1,i__2,vOld,t0) ;\
  varName.l(r,i__1,i__2,vOld,t) = 0 + 1$varName.l(r,i__1,i__2,vOld,t) ; ) ;    \

$else

*  Turn off normalization

$macro normg0(varName,suffix)                     &varName&suffix       = 1 ;
$macro normg1(varName,i__1,suffix)                &varName&suffix(i__1) = 1 ;
$macro normg4(varName,i__1,i__2,i__3,i__4,suffix) &varName&suffix(i__1,i__2,i__3,i__4) = 1 ;
$macro norm0(varName,suffix)                      &varName&suffix(r) = 1 ;
$macro norm1(varName,i__1,suffix)                 &varName&suffix(r,i__1) = 1 ;
$macro norm2(varName,i__1,i__2,suffix)            &varName&suffix(r,i__1,i__2) = 1 ;
$macro norm3(varName,i__1,i__2,i__3,suffix)       &varName&suffix(r,i__1,i__2,i__3) = 1 ;
$macro norm1v(varName,i__1,suffix)                loop(vOld, &varName&suffix(r,i__1)      = 1 ; ) ;
$macro norm2v(varName,i__1,i__2,suffix)           loop(vOld, &varName&suffix(r,i__1,i__2) = 1 ; ) ;
$macro norm1vp(varName,i__1,suffix)               loop(vOld, &varName&suffix(r,i__1)      = 1 ; ) ;
$macro norm2vp(varName,i__1,i__2,suffix)          loop(vOld, &varName&suffix(r,i__1,i__2) = 1 ; ) ;

$endif

loop(t0,

	norm1(xdt,  i, 0)
	norm1(xs,   i, 0)
	norm1(xet,  i, 0)
	norm1(xtt,  i, 0)
	norm1(pdt,  i, 0)
	norm1(ps,   i, 0)
	norm1(pet,  i, 0)
	norm2(xw,   i, rp, 0)
	norm2(pe,   i, rp, 0)
	norm2(pwe,  i, rp, 0)
	norm2(pwm,  i, rp, 0)
	norm2(pdm,  i, rp, 0)
	norm2(xwmg, i, rp, 0)
	norm2(pwmg, i, rp, 0)
	norm1(xmt,  i, 0)
	norm1(pmt,  i, 0)
	norm1t(xat, i, 0)
	norm1(pat,  i, 0)
	norm2t(xa,  i, aa, 0)
	norm2( xd,  i, aa, 0)
	norm2( xm,  i, aa, 0)
	norm1t(nd1, a, 0)
	norm1t(nd2, a, 0)
	norm1(pnd1, a, 0)
	norm1(pnd2, a, 0)

	norm1(px, a, 0)
	norm1(pp, a, 0)
	norm2(p, a, i, 0)

* Dynamic scaling

	norm1t(xp, a, 0)
	norm2t(x, a, i, 0)
	norm1vt(xpv, a, 0)

   norm1vp(kxRat, a, 0)
   norm1vp(pxv, a, 0)
   norm1vp(uc, a, 0)
   norm1vt(xpx, a, 0)
   norm1vp(pxp, a, 0)
   norm1vt(va, a, 0)
   norm1vp(pva, a, 0)
   norm1vt(va1, a, 0)
   norm1vp(pva1, a, 0)
   norm1vt(va2, a, 0)
   norm1vp(pva2, a, 0)
   norm1vt(kef, a, 0)
   norm1vp(pkef, a, 0)
   norm1vt(kf, a, 0)
   norm1vp(pkf, a, 0)
   norm1vt(ksw, a, 0)
   norm1vp(pksw, a, 0)
   norm1vt(ks, a, 0)
   norm1vp(pks, a, 0)

   norm1vt(kv, a, 0)
*    LOOP(vOld, kv0(r,a,t) = kv.l(r,a,vOld,t0) ; ) ; kv.l(r,a,v,t0) $ kv0(r,a,t0) = 1 ;

   norm1vp(pk, a, 0)
   norm1vp(pkp, a, 0)
   norm1vt(xnrg, a, 0)
   norm1vp(pnrg, a, 0)
   norm1vt(xnely, a, 0)
   norm1vp(pnely, a, 0)
   norm1vt(xolg, a, 0)
   norm1vp(polg, a, 0)
   norm2vt(xaNRG, a, NRG, 0)
   norm2vp(paNRG, a, NRG, 0)

   norm1t(lab1, a, 0)

   norm1(lab2, a, 0)
   norm1(plab1, a, 0)
   norm1(plab2, a, 0)
   norm1t(land, a, 0)
   norm1(pland, a, 0)
   norm1(plandp, a, 0)
   norm1(xnrf, a, 0)
   norm1(pnrf, a, 0)
   norm1(pnrfp, a, 0)
   norm1(xwat, a, 0)
   norm1(pwat, a, 0)
   norm1(h2o, a, 0)
   norm1(ph2o, a, 0)
   norm1(ph2op, a, 0)
   norm2(pa, i, aa, 0)
   norm2(pd, i, aa, 0)
   norm2(pm, i, aa, 0)

    norm2t(ld, l, a, 0)
*    ld0(r,l,a,t) $ ld.l(r,l,a,t0) = ld.l(r,l,a,t) ;  ld.l(r,l,a,t0) $ ld0(r,l,a,t0) = 1 ;

   norm2(wagep, l, a, 0)
   norm1t(xpow, elyi, 0)
   norm1(ppow, elyi, 0)
   norm1(ppowndx, elyi, 0)
   norm2t(xpb, pb, elyi, 0)
   norm2(ppb, pb, elyi, 0)
   norm2(ppbndx, pb, elyi, 0)
   norm1(xfd, fd, 0)
   norm1(yfd, fd, 0)
   norm1(pfd, fd, 0)
   norm0(kstock, 0)
   norm0(deprY, 0)
   norm0(yqtf, 0)
   norm0(yqht, 0)
   normg0(trustY, 0)
   norm2(remit, l, rp, 0)
   norm0(yh, 0)
   norm0(yd, 0)
   norm1(ygov, gy, 0)
   norm2(xc, k, h, 0)
   norm2(pc, k, h, 0)
   norm2(xcnnrg, k, h, 0)
   norm2(pcnnrg, k, h, 0)
   norm2(xcnrg, k, h, 0)
   norm2(pcnrg, k, h, 0)
   norm2(xcnely, k, h, 0)
   norm2(pcnely, k, h, 0)
   norm2(xcolg, k, h, 0)
   norm2(pcolg, k, h, 0)
   norm3(xacNRG, k, h, NRG, 0)
   norm3(pacNRG, k, h, NRG, 0)
   norm1(u, h, 0)
   norm1(savh, h, 0)
   norm1(supy, h, 0)
   norm1(aps, h, 0)
   normg1(xtmg, img, 0)
   normg1(ptmg, img, 0)
   normg4(xmgm, img, r, i, rp, 0)
   norm2(reswage, l, z, 0)
   norm2(ewagez, l, z, 0)
   norm2(lsz, l, z, 0)
   norm2(ldz, l, z, 0)
   norm2(awagez, l, z, 0)
   norm2(wage, l, a, 0)
   norm1(twage, l, 0)
   norm1(ls, l, 0)
   norm1(migr, l, 0)
   norm1(urbprem, l, 0)
   norm0(tls, 0)
   norm0(tkaps, 0)
   norm0(trent, 0)
   norm1t(k0, a, 0)
   norm0(tland, 0)
   norm0(ptland, 0)
   norm0(pgdpmp, 0)
   norm1(xlb, lb, 0)
   norm1(plb, lb, 0)
   norm1(plbndx, lb, 0)
   norm0(ptlandndx, 0)
   norm0(xnlb, 0)
   norm0(pnlb, 0)
   norm0(pnlbndx, 0)
   norm0(th2o, 0)
   norm0(th2om, 0)
   norm0(pth2o, 0)
   norm0(pth2ondx, 0)
   norm1(h2obnd, wbnd, 0)
   norm1(ph2obnd, wbnd, 0)
   norm1(ph2obndndx, wbnd, 0)
   norm0(gdpmp, 0)
   norm0(rgdpmp, 0)
   norm0(rgdppc, 0)

   norm0(chiLand,0)

   norm2(emia,a,AllEmissions,0)
   norm1(emiTot, em, 0)
   normg1(emiGbl, em, 0)

* En fait la macro initialise des emissions dont on a pas besoin

*   norm3(emi, AllEmissions, EmiSource, aa, 0)

* emi0(r,AllEmissions,EmiSource,aa) = emi.l(r,AllEmissions,EmiSource,aa,t0)  ;
* emi.l(r,AllEmissions,EmiSource,aa,t) = 0 + 1 $ emi.l(r,AllEmissions,EmiSource,aa,t) ;

    emi0(r,AllEmissions,EmiSourceAct,aa) = emi.l(r,AllEmissions,EmiSourceAct,aa,t0)  ;


    emi.l(r,AllEmissions,EmiSourceAct,aa,t)
        $ emi0(r,AllEmissions,EmiSourceAct,aa)     = 1 ;

* WARNING on ne scale que les sources actives

    emi0(r,AllEmissions,EmiSourceIna,aa)
        $ emi.l(r,AllEmissions,EmiSourceIna,aa,t0) = 1 ;

* [TBC]--> This will imply change in Baseline : WHY

*    emi0(r,AllEmissions,EmiSource,aa) = emi.l(r,AllEmissions,EmiSource,aa,t0) ;
*    emi.l(r,AllEmissions,EmiSource,aa,t) $ emi0(r,AllEmissions,EmiSource,aa)
*    = emi.l(r,AllEmissions,EmiSource,aa,t)
*    / emi0(r,AllEmissions,EmiSource,aa) ;
*    emi.l(r,CO2,emilulucf,a,t) $ emi0(r,CO2,emilulucf,a)=1 ;

    norm1v(xoap,a,0)
    norm1vp(pxoap,a,0)
    norm1v(xghg,a,0)

* [OECD-ENV]: scale for pxghg is time-dependent

	LOOP(vOld,
		pxghg0(r,a,t) $ (ifEndoMAC AND ghgFlag(r,a)) = pxghg.l(r,a,vOld,t0) ;
	) ;
	pxghg.l(r,a,v,t0) $ (ifEndoMAC AND ghgFlag(r,a)) = 1 ;

*	Utility

    $$OnText
        norm2(hshr, k, h, 0)
        norm2(theta, k, h, 0)
        norm2(muc, k, h, 0)
        $$ifthen "%IfNorm%" == "1"
                IF(%utility%=ELES or %utility%=LES or %utility%=AIDADS,
                    theta.fx(r,k,h,t) = 1 ;
                    muc.fx(r,k,h,t)   = 1 ;
        ) ;
        $$endif
    $$OffText

   theta0(r,k,h) = 1 ;
   muc0(r,k,h)   = 1 ;

   norm0(ror, 0)
   norm0(rorc, 0)
   norm0(rore, 0)
   normg0(rorg, 0)

* [OECD-ENV]: normalization new variables (after dynamic calibration changes)

* Ici exogenous so Normalize only first year
    popWA0(r,l,z) = popWA.l(r,l,z,t0);
    popWA.l(r,l,z,t) $ popWA0(r,l,z) = popWA.l(r,l,z,t) / popWA0(r,l,z) ;

*  !!!!! Exceptional

	kstocke.l(r,t) = kstocke.l(r,t) / kstock0(r) ;
	rorg0 $ (%savfFlag% eq capFlexUSAGE) = 1 ;

* !!!! NEED TO WORK ON THIS

	pop0(r)     = 1 ;
	ygov0(r,gy) $ (ygov0(r,gy) eq 0) = 1 ;
	hshr0(r,k,h)  = 1 ;

* OECD-ENV model

* No Scales on following variables

    savf0(r) = 1 ;
    savg0(r) = 1 ;
    rsg0(r)  = 1 ;

* By default not defined

    emiCap0(ra,AllEmissions) = 0;
    emiCapFull0(ra) 		 = 0 ;

) ;

*------------------------------------------------------------------------------*
*                                                                              *
*              [OECD-ENV]: adds auxilliary variables (unscaled)                *
*                                                                              *
*------------------------------------------------------------------------------*


PARAMETERS
    XPT(r,a,t)           "Gross output in real terms (in millions cst USD)"
    XAPT(r,i,aa,t)       "Demand of product i by agent aa in real terms (in millions cst USD)"
    REXPT(r,i,t)         "Exports in real terms (FOB prices)"
    EXPT(r,i,t)          "Exports in nominal terms (FOB prices)"
    RIMPT(r,i,t)         "Imports in real terms (CIF prices)"
    IMPT(r,i,t)          "Imports in nominal terms (FOB prices)"
    AGG_tariffs(r,i,t)   "Tariff rates: average across partners"
    AGG_exportsub(r,i,t) "Export subsidy rates: average across partners"
    TermsOfTradeT(r,t)   "Terms of Trade"
    nrj_mtoe(r,i,is,t)   "Energy consumption in Mtoe"
    nrj_mtoe_d(r,i,is,t) "Domestic Energy consumption in Mtoe"
    nrj_mtoe_m(r,i,is,t) "Imported Energy consumption in Mtoe"
    nrj_mtoe_xw(r,i,rp,t)

    EmIntensity(r,a,AllEmissions,t)  "kilograms of CO2 per constant USD"
    out_Value_Added(typevar,gdp_definition,units,regions,agents,t) "Value Added at different units, by unit, by region, by sector/commmodity by year (billions of cst USD)"
    out_Gross_output(typevar,units,regions,agents,t)               "Gross Output (at Basic Prices), by region and by sector (billions of cst USD)"
    EffectiveCarbonPrice(r,is,aa,t) "Average carbon price on all sources"
    AverageCarbonPrice(r,is,aa,t)   "Average carbon price on all controlled/taxed sources"
    EMITAXT(r,em,t)       "Carbon price (EmiTax): %YearUSDCT%-USD per tonne of CO2eq."
    check_GovBalance(r,t) "Changes in governement budget rule"

;
$OnDotL

*   Auxilliary variables in t0:

EMITAXT(r,em,t) = 0 ;

XPT(r,a,t0)     = outscale * m_true2t(xp,r,a,t0);
XAPT(r,i,aa,t0) = outscale * m_true3t(xa,r,i,aa,t0);

$IFI %module_SectInv% =="ON" xapT(r,i,inv,t0) = xapT(r,i,inv,t0) + outscale * sum(a $ (ExtraInvFlag(r,a) eq 1), m_true(xaa(r,i,a,t0)) );
rexpt(r,i,t0)   = outscale * sum(rp $ xwFlag(r,i,rp),
                    pwe0(r,i,rp) * PWE_SUB(r,i,rp,t0) * m_true3(xw,r,i,rp,t0));
expt(r,i,t0)    = rexpt(r,i,t0);
rimpt(r,i,t0)   = outscale * sum(rp $ xwFlag(rp,i,r),
    pwm0(rp,i,r)*PWM_SUB(rp,i,r,t0) * lambdaw(rp,i,r,t0)*m_true3(xw,rp,i,r,t0));
impt(r,i,t0)    = rimpt(r,i,t0);
TermsOfTradeT(r,t0) = 1;

* Value Added at Basic (Agent's) Prices

out_Value_Added(abstype,"Basic Prices","nominal",r,a,t0) $ xpFlag(r,a)
    = XPT(r,a,t0)
    - sum(i, m_true3(pa,r,i,a,t0) * XAPT(r,i,a,t0));

out_Value_Added(abstype,"Basic Prices","real",r,a,t0) $ xpFlag(r,a)
    = XPT(r,a,t0)
    - sum(i, m_true3(pa,r,i,a,t0) * XAPT(r,i,a,t0));

EmIntensity(r,a,AllEmissions,t0) $ XPT(r,a,t0)
    = 100000 * [m_true3(emia,r,a,AllEmissions,t0) / cScale] / XPT(r,a,t0) ;

* Average Tariffs and Export Subsidies rates

AGG_tariffs(r,i,t0)
    $ sum(rp $ xwFlag(rp,i,r), m_true3(pwe,rp,i,r,t0) * lambdaw(rp,i,r,t0) * m_true3(xw,rp,i,r,t0))
    = sum(rp $ xwFlag(rp,i,r), mtax.l(rp,i,r,t0) * m_true3(pwe,rp,i,r,t0) * lambdaw(rp,i,r,t0) * m_true3(xw,rp,i,r,t0))
    / sum(rp $ xwFlag(rp,i,r), m_true3(pwe,rp,i,r,t0) * lambdaw(rp,i,r,t0) * m_true3(xw,rp,i,r,t0)) ;

AGG_exportsub(r,i,t0)
    $ sum(rp $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t0) )
    = sum(rp $ xwFlag(r,i,rp), etax.l(r,i,rp,t0) * m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t0) )
    / sum(rp $ xwFlag(r,i,rp), m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t0) ) ;

*   Initialisation energy demands in volume (Mtoe): nrj_mtoe

* ely-a represente ici la production electrique totale (etd compris)
* pas conseille de calculer ca: nrj_mtoe(r,e,"TotEly",t0) = sum(elya,nrj_mtoe(r,e,elya,t0));
* En fait nrj_mtoe(r,i,is,t) existe deja

* [TBU] Logically could distinct Domestic vs Foreign source of the demand

loop(t0,

    IF(NOT IfNrgVol,

        nrj_mtoe_d(r,e,h,t0)   = sum(mapi0(i0,e), edp(i0,r));
        nrj_mtoe_d(r,e,gov,t0) = sum(mapi0(i0,e), edg(i0,r));
        nrj_mtoe_d(r,e,inv,t0) = sum(mapi0(i0,e), edi(i0,r));
        nrj_mtoe_d(r,e,a,t0)
            = sum((i0,a0) $ (mapi0(i0,e) and mapa0(a0,a)), edf(i0,a0,r));

        nrj_mtoe_m(r,e,h,t0)   = sum(mapi0(i0,e), eip(i0,r));
        nrj_mtoe_m(r,e,gov,t0) = sum(mapi0(i0,e), eig(i0,r));
        nrj_mtoe_m(r,e,inv,t0) = sum(mapi0(i0,e), eii(i0,r));
        nrj_mtoe_m(r,e,a,t0)
            = sum((i0,a0) $ (mapi0(i0,e) and mapa0(a0,a)), eif(i0,a0,r));

        nrj_mtoe(r,e,aa,t0)  = nrj_mtoe_d(r,e,aa,t0)  + nrj_mtoe_m(r,e,aa,t0) ;

        nrj_mtoe_xw(r,e,rp,t0) = sum(mapi0(i0,e), exi(i0,r,rp) ) ;

   ELSE

        nrj_mtoe(r,e,aa,t0) $ xaFlag(r,e,aa) = m_true3t(xa,r,e,aa,t0) / escale;

    );

) ;

*	2023-10-12: Move here bound from 27-model.gms to take into account Flags

pmt.lo(r,i,t) $ xmtFlag(r,i) = LowerBound ;

pland.lo(r,a,t)  $ (not tota(a) and landFlag(r,a)) = LowerBound ;
plandp.lo(r,a,t) $ (not tota(a) and landFlag(r,a)) = LowerBound ;

***HRR
    pland.l(r,a,t) $ (not pland0(r,a)) = 0 ;

$iftheni.RD "%ifRD_MODULE%" == "ON"
   kn.l(r,tt)               = 1 ;
   rd.l(r,tt)$knowFlag(r)   = rd.l(r,tt)/rd0(r) ;
   rd.fx(r,tt)$(knowFlag(r) and tt.val le t0.val) = rd.l(r,tt) ;
$endif.RD

$OffDotL