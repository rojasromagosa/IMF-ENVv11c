$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Core program
   GAMS file    : "%ModelDir%\6-closure.gms"
   purpose      : Fix policy and non endogenous variables
   Created by   : Dominique van der Mensbrugghe (file name closure.gms)
                  + modification by Jean Chateau for OECD-ENV
   Created date :
   called by    : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/6-closure.gms $
   last changed revision: $Rev: 517 $
   last changed date    : $Date:: 2024-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$macro m_removeFX 0

wprem.fx(r,l,a,t) = wprem.l(r,l,a,t) ;
lsz.fx(r,l,z,t)   = lsz.l(r,l,z,t)   ;
rsg.fx(r,t)       = rsg.l(r,t)       ;
kstock.fx(r,t)    = kstock.l(r,t)    ;
RoRd.fx(r,t)      = RoRd.l(r,t)      ;
xfd.fx(r,gov,t)   = xfd.l(r,gov,t)   ;
tkaps.fx(r,t)     = tkaps.l(r,t)     ;
pnum.fx(t)        = pnum.l(t)        ;
pim.fx(r,a,t)     = pim.l(r,a,t)     ;

savf.fx(r,t)$(not rres(r) and %savfFlag% eq capFix) = savf.l(r,t) ;

*  Consumer demand parameters

aps.fx(r,h,t) $ (%utility% ne ELES) = aps.l(r,h,t) ;
chiaps.fx(r,t)    = chiaps.l(r,t)    ;

IF(%utility%=CD or %utility%=LES or %utility%=ELES or %utility%=AIDADS,
    theta.fx(r,k,h,t) = theta.l(r,k,h,t) ;
    IF(%utility%=CD or %utility%=LES or %utility%=ELES,
        muc.fx(r,k,h,t) = muc.l(r,k,h,t) ;
    ) ;
) ;

*   Fix policy variables

IF(ifDyn and (NOT ifCal),
    m_clearClimPol(t)
) ;

ptax.fx(r,a,t)     = ptax.l(r,a,t)     ;
uctax.fx(r,a,v,t)  = uctax.l(r,a,v,t)  ;
paTax.fx(r,i,aa,t) = paTax.l(r,i,aa,t) ;
pdTax.fx(r,i,aa,t) = pdTax.l(r,i,aa,t) ;
pmTax.fx(r,i,aa,t) = pmTax.l(r,i,aa,t) ;
etax.fx(r,i,rp,t)  = etax.l(r,i,rp,t)  ;
mtax.fx(r,i,rp,t)  = mtax.l(r,i,rp,t)  ;
Taxfp.fx(r,a,fp,t) = Taxfp.l(r,a,fp,t) ;
Subfp.fx(r,a,fp,t) = Subfp.l(r,a,fp,t) ;

$iftheni "%ifRD_MODULE%" == "ON"
   rfdshr.fx(r,r_d,t) = rfdshr.l(r,r_d,t) ;
$endif

p_emissions(r,AllEmissions,emiact,a,t) $ p_emissions(r,AllEmissions,emiact,a,t)
    = p_emissions(r,AllEmissions,emiact,a,t);
emiTax.fx(r,AllEmissions,t) = emiTax.l(r,AllEmissions,t) ;

pxghg.fx(r,a,v,t) $ (NOT ifEndoMAC) = pxghg.l(r,a,v,t) ;

*   Fix technology parameters

TFP_xpv.fx(r,a,v,t)       $ TFP_xpv.l(r,a,v,t)      = TFP_xpv.l(r,a,v,t) 	;
lambdaxp.fx(r,a,v,t)      $ lambdaxp.l(r,a,v,t)     = lambdaxp.l(r,a,v,t) 	;
lambdaghg.fx(r,a,v,t)     $ lambdaghg.l(r,a,v,t)    = lambdaghg.l(r,a,v,t)	;
lambdanrf.fx(r,a,v,t)     $ lambdanrf.l(r,a,v,t)    = lambdanrf.l(r,a,v,t)	;
lambdak.fx(r,a,v,t)       $ lambdak.l(r,a,v,t)      = lambdak.l(r,a,v,t)	;
lambdal.fx(r,l,a,t)       $ lambdal.l(r,l,a,t)      = lambdal.l(r,l,a,t)	;
lambdat.fx(r,a,v,t)       $ lambdat.l(r,a,v,t)      = lambdat.l(r,a,v,t)	;
lambdaio.fx(r,i,a,t)      $ lambdaio.l(r,i,a,t)     = lambdaio.l(r,i,a,t)	;
lambdah2o.fx(r,a,t)       $ lambdah2o.l(r,a,t)      = lambdah2o.l(r,a,t)	;
lambdae.fx(r,e,a,v,t)     $ lambdae.l(r,e,a,v,t)    = lambdae.l(r,e,a,v,t)	;
lambdace.fx(r,e,k,h,t)    $ lambdace.l(r,e,k,h,t)   = lambdace.l(r,e,k,h,t)	;
lambdah2obnd.fx(r,wbnd,t) $ lambdah2obnd.l(r,wbnd,t)= lambdah2obnd.l(r,wbnd,t);
tmarg.fx(r,i,rp,t)        $ tmarg.l(r,i,rp,t)       = tmarg.l(r,i,rp,t);

*   [OECD-ENV]: additional variables

lambdafd.fx(r,i,fdc,t)    $ lambdafd.l(r,i,fdc,t)   = lambdafd.l(r,i,fdc,t);
TFP_fp.fx(r,a,t)          $ TFP_fp.l(r,a,t)         = TFP_fp.l(r,a,t)	   ;
TFP_xpx.fx(r,a,v,t)       $ TFP_xpx.l(r,a,v,t)      = TFP_xpx.l(r,a,v,t)   ;
TFP_xs.fx(r,i,t)          $ TFP_xs.l(r,i,t)         = TFP_xs.l(r,i,t)      ;


trg.fx(r,t)     = trg.l(r,t) ;
chiLand.fx(r,t) = chiLand.l(r,t);

* Definition: employment rate

ERT.fx(r,l,z,t) $lsFlag(r,l,z) = [ 1 - 0.01 * UNR.l(r,l,z,t)] * LFPR.l(r,l,z,t);

*   Fix inactive variables

popWA.fx(r,l,z,t) $ (NOT lsFlag(r,l,z)) = 0 ;
UNR.fx(r,l,z,t)   $ (NOT lsFlag(r,l,z)) = 0 ;
LFPR.fx(r,l,z,t)  $ (NOT lsFlag(r,l,z)) = 0 ;

h2obnd.fx(r,wbndEx,t) = h2obnd.l(r,wbndEx,t) ;

* Ceci mets des 0 un peux partout et acrroit la taille des *.gdx outputs
IF(m_removeFX,

	LOOP(a $ (NOT tota(a)),
		pp.fx(r,a,t)    $(NOT xpFlag(r,a))      = pp.l(r,a,t) ;
		px.fx(r,a,t)    $(NOT xpFlag(r,a))      = pp.l(r,a,t) ;
		uc.fx(r,a,v,t)  $(NOT xpFlag(r,a))      = pp.l(r,a,t) ;
		pxv.fx(r,a,v,t) $(NOT xpFlag(r,a))      = pxv.l(r,a,v,t) ;
		xpx.fx(r,a,v,t) $(NOT xpFlag(r,a))      = xpx.l(r,a,v,t) ;
		xpv.fx(r,a,v,t) $(NOT xpFlag(r,a))      = xpv.l(r,a,v,t) ;
		xghg.fx(r,a,v,t)$(NOT ghgFlag(r,a))     = xghg.l(r,a,v,t) ;
		nd1.fx(r,a,t)   $(NOT nd1Flag(r,a))     = nd1.l(r,a,t) ;
		nd2.fx(r,a,t)   $(NOT nd2Flag(r,a))     = nd2.l(r,a,t) ;
		xwat.fx(r,a,t)  $(NOT watFlag(r,a))     = xwat.l(r,a,t) ;
		h2o.fx(r,a,t)   $(NOT xwatfFlag(r,a))   = h2o.l(r,a,t) ;
		pnd1.fx(r,a,t)  $(NOT nd1Flag(r,a))     = pnd1.l(r,a,t) ;
		pnd2.fx(r,a,t)  $(NOT nd2Flag(r,a))     = pnd2.l(r,a,t) ;
		pwat.fx(r,a,t)  $(NOT watFlag(r,a))     = pwat.l(r,a,t) ;
		va.fx(r,a,v,t)  $(NOT xpFlag(r,a))      = va.l(r,a,v,t) ;
		va1.fx(r,a,v,t) $(NOT va1Flag(r,a))     = va1.l(r,a,v,t) ;
		va2.fx(r,a,v,t) $(NOT va2Flag(r,a))     = va2.l(r,a,v,t) ;
		pva.fx(r,a,v,t) $(NOT xpFlag(r,a))      = pva.l(r,a,v,t) ;
		pva1.fx(r,a,v,t)$(NOT va1Flag(r,a))     = pva1.l(r,a,v,t) ;
		pva2.fx(r,a,v,t)$(NOT va2Flag(r,a))     = pva2.l(r,a,v,t) ;
		pxp.fx(r,a,v,t) $(NOT xpFlag(r,a))      = pxp.l(r,a,v,t) ;
		lab1.fx(r,a,t)  $(NOT lab1Flag(r,a))    = lab1.l(r,a,t) ;
		lab2.fx(r,a,t)  $(NOT lab2Flag(r,a))    = lab2.l(r,a,t) ;
		plab1.fx(r,a,t) $(NOT lab1Flag(r,a))    = plab1.l(r,a,t) ;
		plab2.fx(r,a,t) $(NOT lab2Flag(r,a))    = plab2.l(r,a,t) ;
		land.fx(r,a,t)  $(NOT landFlag(r,a))    = land.l(r,a,t) ;
		xnrf.fx(r,a,t)  $(NOT nrfFlag(r,a))     = xnrf.l(r,a,t) ;
		kef.fx(r,a,v,t) $(NOT kefFlag(r,a))     = kef.l(r,a,v,t) ;
		pkef.fx(r,a,v,t)$(NOT kefFlag(r,a))     = pkef.l(r,a,v,t) ;
		kf.fx(r,a,v,t)  $(NOT kfFlag(r,a))      = kf.l(r,a,v,t) ;
		pkf.fx(r,a,v,t) $(NOT kfFlag(r,a))      = pkf.l(r,a,v,t) ;
		xnrg.fx(r,a,v,t)$(NOT xnrgFlag(r,a))    = xnrg.l(r,a,v,t) ;
		xolg.fx(r,a,v,t)$(NOT xolgFlag(r,a))    = xolg.l(r,a,v,t) ;
		polg.fx(r,a,v,t)$(NOT xolgFlag(r,a))    = polg.l(r,a,v,t) ;
		pnrg.fx(r,a,v,t)$(NOT xnrgFlag(r,a))    = pnrg.l(r,a,v,t) ;
		ksw.fx(r,a,v,t) $(NOT kFlag(r,a))       = ksw.l(r,a,v,t) ;
		pksw.fx(r,a,v,t)$(NOT kFlag(r,a))       = pksw.l(r,a,v,t) ;
		ks.fx(r,a,v,t)  $(NOT kFlag(r,a))       = ks.l(r,a,v,t) ;
		pks.fx(r,a,v,t) $(NOT kFlag(r,a))       = pks.l(r,a,v,t) ;
		kv.fx(r,a,v,t)  $(NOT kFlag(r,a))       = kv.l(r,a,v,t) ;
		ld.fx(r,l,a,t)  $(NOT labFlag(r,l,a))   = ld.l(r,l,a,t) ;
		xnely.fx(r,a,v,t)$(NOT xnelyFlag(r,a))  = xnely.l(r,a,v,t) ;
		pnely.fx(r,a,v,t)$(NOT xnelyFlag(r,a))  = pnely.l(r,a,v,t) ;
		xaNRG.fx(r,a,NRG,v,t)$(NOT xaNRGFlag(r,a,NRG)) = xaNRG.l(r,a,NRG,v,t) ;
		paNRG.fx(r,a,NRG,v,t)$(NOT xaNRGFlag(r,a,NRG)) = paNRG.l(r,a,NRG,v,t) ;
	) ;

	xa.fx(r,i,aa,t)$(NOT xaFlag(r,i,aa)) = 0 ;
	x.fx(r,a,i,t)  $(NOT gp(r,a,i))      = 0 ;
	p.fx(r,a,i,t)  $(NOT gp(r,a,i))      = p.l(r,a,i,t) ;
	xp.fx(r,a,t)   $(NOT xpFlag(r,a))    = 0 ;
	ps.fx(r,i,t)   $(NOT xsFlag(r,i))    = ps.l(r,i,t) ;

	xpow.fx(r,elyi,t)    $ (NOT apow(r,elyi,t)) = xpow.l(r,elyi,t)    ;
	ppow.fx(r,elyi,t)    $ (NOT apow(r,elyi,t)) = ppow.l(r,elyi,t)    ;
	ppowndx.fx(r,elyi,t) $ (NOT apow(r,elyi,t)) = ppowndx.l(r,elyi,t) ;

	deprY.fx(r,t)          $ (NOT deprY0(r))      = 0 ;
	yqtf.fx(r,t)           $ (NOT yqtf0(r))       = 0 ;
	trustY.fx(t)           $ (NOT trustY0 )       = 0 ;
	yqht.fx(r,t)           $ (NOT yqht0(r))       = 0 ;
	remit.fx(rp,l,r,t)     $ (NOT remit0(rp,l,r)) = 0 ;
	ygov.fx(r,gy,t)        $ (NOT ygov0(r,gy))    = 0 ;

	xc.fx(r,k,h,t)         $ (NOT xcFlag(r,k,h))         = xc.l(r,k,h,t)         ;
	pc.fx(r,k,h,t)         $ (NOT xcFlag(r,k,h))         = pc.l(r,k,h,t)         ;
	hshr.fx(r,k,h,t)       $ (NOT xcFlag(r,k,h))         = hshr.l(r,k,h,t)       ;
	theta.fx(r,k,h,t)      $ (NOT xcFlag(r,k,h))         = theta.l(r,k,h,t)      ;
	xcnnrg.fx(r,k,h,t)     $ (NOT xcnnrgFlag(r,k,h))     = xcnnrg.l(r,k,h,t)     ;
	pcnnrg.fx(r,k,h,t)     $ (NOT xcnnrgFlag(r,k,h))     = pcnnrg.l(r,k,h,t)     ;
	xcnrg.fx(r,k,h,t)      $ (NOT xcnrgFlag(r,k,h))      = xcnrg.l(r,k,h,t)      ;
	pcnrg.fx(r,k,h,t)      $ (NOT xcnrgFlag(r,k,h))      = pcnrg.l(r,k,h,t)      ;
	xcnely.fx(r,k,h,t)     $ (NOT xcnelyFlag(r,k,h))     = xcnely.l(r,k,h,t)     ;
	pcnely.fx(r,k,h,t)     $ (NOT xcnelyFlag(r,k,h))     = pcnely.l(r,k,h,t)     ;
	xcolg.fx(r,k,h,t)      $ (NOT xcolgFlag(r,k,h))      = xcolg.l(r,k,h,t)      ;
	pcolg.fx(r,k,h,t)      $ (NOT xcolgFlag(r,k,h))      = pcolg.l(r,k,h,t)      ;
	xacNRG.fx(r,k,h,NRG,t) $ (NOT xacNRGFlag(r,k,h,NRG)) = xacNRG.l(r,k,h,NRG,t) ;
	pacNRG.fx(r,k,h,NRG,t) $ (NOT xacNRGFlag(r,k,h,NRG)) = pacNRG.l(r,k,h,NRG,t) ;

* [EditJean]: add this

	pd.l(r,i,aa,t)  $ (NOT xdFlag(r,i,aa))  = pa.l(r,i,aa,t) ;
	xd.l(r,i,aa,t)  $ (NOT xdFlag(r,i,aa))  = xd.l(r,i,aa,t) ;
	pm.l(r,i,aa,t)  $ (NOT xmFlag(r,i,aa))  = pa.l(r,i,aa,t) ;
	xm.l(r,i,aa,t)  $ (NOT xmFlag(r,i,aa))  = xm.l(r,i,aa,t) ;
	xat.fx(r,i,t)   $ (NOT xatFlag(r,i))    = xat.l(r,i,t) ;
	xdt.fx(r,i,t)   $ (NOT xdtFlag(r,i))    = xdt.l(r,i,t) ;
	xmt.fx(r,i,t)   $ (NOT xmtFlag(r,i))    = xmt.l(r,i,t) ;
	pat.fx(r,i,t)   $ (NOT xatFlag(r,i))    = pat.l(r,i,t) ;
	pa.fx(r,i,aa,t) $ (NOT xaFlag(r,i,aa))  = pa.l(r,i,aa,t) ;

	xs.fx(r,i,t ) 	$ (NOT xsFlag(r,i) )	= xs.l(r,i,t)  ;
	pmt.fx(r,i,t) 	$ (NOT xmtFlag(r,i))	= pmt.l(r,i,t) ;
	pdt.fx(r,i,t) 	$ (NOT xdtFlag(r,i))	= pdt.l(r,i,t) ;
	xet.fx(r,i,t) 	$ (NOT xetFlag(r,i))	= xet.l(r,i,t) ;
	pet.fx(r,i,t) 	$ (NOT xetFlag(r,i))	= pet.l(r,i,t) ;

	xw.fx(r,i,rp,t)  $ (NOT xwFlag(r,i,rp))  = xw.l(r,i,rp,t) ;
	pe.fx(r,i,rp,t)  $ (NOT xwFlag(r,i,rp))  = pe.l(r,i,rp,t) ;
	pwe.fx(r,i,rp,t) $ (NOT xwFlag(r,i,rp))  = pwe.l(r,i,rp,t) ;
	pwm.fx(r,i,rp,t) $ (NOT xwFlag(r,i,rp))  = pwm.l(r,i,rp,t) ;
	pdm.fx(r,i,rp,t) $ (NOT xwFlag(r,i,rp))  = pdm.l(r,i,rp,t) ;

	xwmg.fx(r,i,rp,t) $ (NOT tmgFlag(r,i,rp)) = xwmg.l(r,i,rp,t) ;
	xwmg.fx(r,i,rp,t) $ (NOT tmgFlag(r,i,rp)) = xwmg.l(r,i,rp,t) ;
	pwmg.fx(r,i,rp,t) $ (NOT tmgFlag(r,i,rp)) = pwmg.l(r,i,rp,t) ;
	xmgm.fx(img,r,i,rp,t)$(NOT amgm(img,r,i,rp)) = xmgm.l(img,r,i,rp,t) ;
	xtt.fx(r,i,t)$(NOT xttFlag(r,i))        = xtt.l(r,i,t) ;

	ldz.fx(r,l,z,t)     $ (NOT lsFlag(r,l,z))  = 0                 ;
	awagez.fx(r,l,z,t)  $ (NOT lsFlag(r,l,z))  = awagez.l(r,l,z,t) ;
	ewagez.l(r,l,z,t)   $ (NOT lsFlag(r,l,z))  = ewagez.l(r,l,z,t) ;
	lsz.fx(r,l,z,t)     $ (NOT lsFlag(r,l,z))  = lsz.l(r,l,z,t)    ;
	urbPrem.fx(r,l,t)   $ (NOT tLabFlag(r,l))  = urbPrem.l(r,l,t)  ;
	twage.fx(r,l,t)     $ (NOT tlabFlag(r,l))  = twage.l(r,l,t)    ;
	skillprem.fx(r,l,t) $ (NOT tlabFlag(r,l))  = skillprem.l(r,l,t);
	ls.fx(r,l,t)        $ (NOT tlabFlag(r,l))  = ls.l(r,l,t)       ;
	glab.fx(r,l,t)      $ (NOT tlabFlag(r,l))  = glab.l(r,l,t)     ;
	wage.fx(r,l,a,t)    $ (NOT labFlag(r,l,a)) = wage.l(r,l,a,t)   ;
	wagep.fx(r,l,a,t)   $ (NOT labFlag(r,l,a)) = wagep.l(r,l,a,t)  ;
	resWage.fx(r,l,z,t) $ (NOT ueFlag(r,l,z))  = ewagez.l(r,l,z,t) ;

	urbPrem.fx(r,l,t)       $ (omegam(r,l) eq inf) = urbPrem.l(r,l,t) ;
	migr.fx(r,l,t)          $ (NOT migrFlag(r,l)) = 0 ;
	migrMult.fx(r,l,z,t)    $ (NOT migrFlag(r,l)) = 1 ;

	pk.fx(r,a,v,t)          $ (NOT kFlag(r,a))          = pk.l(r,a,v,t)          ;
	pkp.fx(r,a,v,t)         $ (NOT kFlag(r,a))          = pkp.l(r,a,v,t)         ;
	kxRat.fx(r,a,v,t)       $ (NOT kFlag(r,a))          = kxRat.l(r,a,v,t)       ;
	rrat.fx(r,a,t)          $ (NOT kFlag(r,a))          = rrat.l(r,a,t)          ;
	pland.fx(r,a,t)         $ (NOT landFlag(r,a))       = pland.l(r,a,t)         ;
	plandp.fx(r,a,t)        $ (NOT landFlag(r,a))       = plandp.l(r,a,t)        ;
	tland.fx(r,t)           $ (NOT tlandFlag(r))        = tland.l(r,t)           ;
	ptland.fx(r,t)          $ (NOT tlandFlag(r))        = ptland.l(r,t)          ;
	ptlandndx.fx(r,t)       $ (NOT tlandFlag(r))        = ptlandndx.l(r,t)       ;
	xlb.fx(r,lb,t)          $ (NOT gamlb(r,lb,t))       = xlb.l(r,lb,t)          ;
	plb.fx(r,lb,t)          $ (NOT gamlb(r,lb,t))       = plb.l(r,lb,t)          ;
	plbndx.fx(r,lb,t)       $ (NOT gamlb(r,lb,t))       = plbndx.l(r,lb,t)       ;
	xnlb.fx(r,t)            $ (NOT gamnlb(r,t))         = xnlb.l(r,t)            ;
	pnlb.fx(r,t)            $ (NOT gamnlb(r,t))         = pnlb.l(r,t)            ;
	pnlbndx.fx(r,t)         $ (NOT gamnlb(r,t))         = pnlbndx.l(r,t)         ;
	pnrf.fx(r,a,t)          $ (NOT nrfFlag(r,a))        = pnrf.l(r,a,t)          ;
	pnrfp.fx(r,a,t)         $ (NOT nrfFlag(r,a))        = pnrfp.l(r,a,t)         ;

	th2o.fx(r,t)            $ (NOT th2oFlag(r))         = th2o.l(r,t)            ;
	th2om.fx(r,t)           $ (NOT th2oFlag(r))         = th2om.l(r,t)           ;
	pth2o.fx(r,t)           $ (NOT th2oFlag(r))         = pth2o.l(r,t)           ;
	pth2ondx.fx(r,t)        $ (NOT th2oFlag(r))         = pth2ondx.l(r,t)        ;
	h2obnd.fx(r,wbnd,t)     $ (NOT h2obndFlag(r,wbnd))  = h2obnd.l(r,wbnd,t)     ;
	ph2obnd.fx(r,wbnd,t)    $ (NOT h2obndFlag(r,wbnd))  = ph2obnd.l(r,wbnd,t)    ;
	ph2obndndx.fx(r,wbnd,t) $ (NOT h2obndFlag(r,wbnd))  = ph2obndndx.l(r,wbnd,t) ;

) ;

$Ifi NOT %ElyBndNest%=="1Bundle" LOOP( pb $ (NOT Allpb(pb)),
$Ifi     %ElyBndNest%=="1Bundle" LOOP( pb $ Allpb(pb),
    xpb.fx(r,pb,elyi,t)   $(apb(r,pb,elyi,t) eq 0) = xpb.l(r,pb,elyi,t) ;
    ppb.fx(r,pb,elyi,t)   $(apb(r,pb,elyi,t) eq 0) = ppb.l(r,pb,elyi,t) ;
    ppbndx.fx(r,pb,elyi,t)$(apb(r,pb,elyi,t) eq 0) = ppbndx.l(r,pb,elyi,t) ;
									 ) ;

uez.fx(r,l,z,t)     $ (NOT ueFlag(r,l,z))  = 0 ;
emi.fx(r,AllEmissions,EmiSourceAct,a,t) $ (NOT xpFlag(r,a)) = 0 ;
emi.fx(r,AllEmissions,EmiSourceAct,a,t) $ tota(a)= 0 ;

* [OECD-ENV]: move some bound initially in model.gms here because now add a condition

pva.lo(r,a,v,t)  $ xpFlag(r,a)  = LowerBound ;
pva1.lo(r,a,v,t) $ va1Flag(r,a) = LowerBound ;
pva2.lo(r,a,v,t) $ va2Flag(r,a) = LowerBound ;

*------------------------------------------------------------------------------*
*           Load an alternative trajectory to initialize a policy for exple    *
*------------------------------------------------------------------------------*

* In this case should we not re-do : $include "%ModelDir%\6-closure.gms"

$IfTheni.LoadAlternativeRun EXIST "%InitFile%.gdx"
    IF(ifDyn and (NOT ifCal), EXECUTE_LOADPOINT "%InitFile%.gdx" ; ) ;
$EndIf.LoadAlternativeRun

