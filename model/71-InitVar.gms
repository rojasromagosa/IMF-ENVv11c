$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file    : "%ModelDir%\71-InitVar.gms"
	purpose      : Initialize model variables for current year
	Created by   : 	Dominique van der Mensbrugghe for ENVISAGE
				  + modification by Jean Chateau for OECD-ENV
	Created date :
	called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
    $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/71-InitVar.gms $
	last changed revision: $Rev: 518 $
	last changed date    : $Date:: 2024-02-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText


*	PRICE VARIABLES

pp.l(r,a,tsim)       $ xpFlag(r,a)   = pp.l(r,a,tsim-1)     ;
px.l(r,a,tsim)       $ xpFlag(r,a)   = px.l(r,a,tsim-1)     ;
uc.l(r,a,v,tsim)     $ xpFlag(r,a)   = uc.l(r,a,v,tsim-1)   ;
pxv.l(r,a,v,tsim)    $ xpFlag(r,a)   = pxv.l(r,a,v,tsim-1)  ;
pxp.l(r,a,v,tsim)    $ xpFlag(r,a)   = pxp.l(r,a,v,tsim-1)  ;
pva.l(r,a,v,tsim)    $ xpFlag(r,a)   = pva.l(r,a,v,tsim-1)  ;
pva1.l(r,a,v,tsim)   $ xpFlag(r,a)   = pva1.l(r,a,v,tsim-1) ;
pva2.l(r,a,v,tsim)   $ xpFlag(r,a)   = pva2.l(r,a,v,tsim-1) ;
pkef.l(r,a,v,tsim)   $ xpFlag(r,a)   = pkef.l(r,a,v,tsim-1) ;
pkf.l(r,a,v,tsim)    $ xpFlag(r,a)   = pkf.l(r,a,v,tsim-1)  ;
pksw.l(r,a,v,tsim)   $ xpFlag(r,a)   = pksw.l(r,a,v,tsim-1) ;
pks.l(r,a,v,tsim)    $ xpFlag(r,a)   = pks.l(r,a,v,tsim-1)  ;
plab1.l(r,a,tsim)    $ xpFlag(r,a)   = plab1.l(r,a,tsim-1)  ;
plab2.l(r,a,tsim)    $ xpFlag(r,a)   = plab2.l(r,a,tsim-1)  ;
pnd1.l(r,a,tsim)     $ xpFlag(r,a)   = pnd1.l(r,a,tsim-1)   ;
pnd2.l(r,a,tsim)     $ xpFlag(r,a)   = pnd2.l(r,a,tsim-1)   ;
pwat.l(r,a,tsim)     $ xpFlag(r,a)   = pwat.l(r,a,tsim-1)   ;
pnrg.l(r,a,v,tsim)   $ xpFlag(r,a)   = pnrg.l(r,a,v,tsim-1) ;

wldPm.l(i,tsim) = wldPm.l(i,tsim-1) ;

paNRG.l(r,a,NRG,v,tsim) $ ( IfNrgNest(r,a) and xpFlag(r,a) )
    = paNRG.l(r,a,NRG,v,tsim-1) ;
polg.l(r,a,v,tsim) $ ( IfNrgNest(r,a) and xpFlag(r,a) )
    = polg.l(r,a,v,tsim-1) ;
pnely.l(r,a,v,tsim) $ ( IfNrgNest(r,a) and xpFlag(r,a) )
    = pnely.l(r,a,v,tsim-1) ;

* [TBC]: why all these expressions for pnrg.l

pnrg.l(r,a,v,tsim) $ (vOld(v) and xnrgFlag(r,a)) =
      ((sum(e, (aeio(r,e,a,v,tsim)*(pa0(r,e,a)/pnrg0(r,a))**(1-sigmae(r,a,v)))
   *     (pa.l(r,e,a,tsim-1)/lambdae.l(r,e,a,v,tsim))**(1-sigmae(r,a,v))))**(1/(1-sigmae(r,a,v))))
   $(not IfNrgNest(r,a))

   +  (((aNRG(r,a,"ELY",v,tsim)*(paNRG0(r,a,"ELY")/pnrg0(r,a))**(1-sigmae(r,a,v)))
   *    paNRG.l(r,a,"ELY",v,tsim)**(1-sigmae(r,a,v))
   +   (anely(r,a,v,tsim)*(pnely0(r,a)/pnrg0(r,a))**(1-sigmae(r,a,v)))
   *    pnely.l(r,a,v,tsim)**(1-sigmae(r,a,v)))**(1/(1-sigmae(r,a,v))))
   $IfNrgNest(r,a) ;

loop((vNew,vOld),
   pnrg.l(r,a,vNew,tsim) $ xnrgFlag(r,a) = pnrg.l(r,a,vOld,tsim) ;
) ;

pnrg.l(r,a,v,tsim) $ xnrgFlag(r,a)  =
      ((sum(e, (aeio(r,e,a,v,tsim)*(pa0(r,e,a)/pnrg0(r,a))**(1-sigmae(r,a,v)))
   *     (pa.l(r,e,a,tsim-1)/lambdae.l(r,e,a,v,tsim))**(1-sigmae(r,a,v))))**(1/(1-sigmae(r,a,v))))
   $ (not IfNrgNest(r,a))
   +  (((aNRG(r,a,"ELY",v,tsim)*(paNRG0(r,a,"ELY")/pnrg0(r,a))**(1-sigmae(r,a,v)))
   *    paNRG.l(r,a,"ELY",v,tsim)**(1-sigmae(r,a,v))
   +   (anely(r,a,v,tsim)*(pnely0(r,a)/pnrg0(r,a))**(1-sigmae(r,a,v)))
   *    pnely.l(r,a,v,tsim)**(1-sigmae(r,a,v)))**(1/(1-sigmae(r,a,v))))
   $IfNrgNest(r,a) ;

p.l(r,a,i,tsim) $ xpFlag(r,a) = p.l(r,a,i,tsim-1)          ;
ps.l(r,i,tsim)                = ps.l(r,i,tsim-1)           ;
ppow.l(r,elyi,tsim)           = ppow.l(r,elyi,tsim-1)      ;
ppowndx.l(r,elyi,tsim)        = ppowndx.l(r,elyi,tsim-1)   ;
ppb.l(r,pb,elyi,tsim)         = ppb.l(r,pb,elyi,tsim-1)    ;
ppbndx.l(r,pb,elyi,tsim)      = ppbndx.l(r,pb,elyi,tsim-1) ;
pcnnrg.l(r,k,h,tsim)          = pcnnrg.l(r,k,h,tsim-1)     ;
pcnrg.l(r,k,h,tsim)           = pcnrg.l(r,k,h,tsim-1)      ;
pcnely.l(r,k,h,tsim)          = pcnely.l(r,k,h,tsim-1)     ;
pcolg.l(r,k,h,tsim)           = pcolg.l(r,k,h,tsim-1)      ;
pc.l(r,k,h,tsim)              = pc.l(r,k,h,tsim-1)         ;
pfd.l(r,fd,tsim)              = pfd.l(r,fd,tsim-1)         ;
pacNRG.l(r,k,h,NRG,tsim)      = pacNRG.l(r,k,h,NRG,tsim-1) ;
pat.l(r,i,tsim)          	  = pat.l(r,i,tsim-1) 		   ;
pa.l(r,i,aa,tsim)        	  = pa.l(r,i,aa,tsim-1)		   ;

* [EditJean]: add this

IF(IfArmFlag,
    pm.l(r,i,aa,tsim) = pa.l(r,i,aa,tsim-1) ;
    pd.l(r,i,aa,tsim) = pa.l(r,i,aa,tsim-1) ;
ELSE
    pmt.l(r,i,tsim)   = pmt.l(r,i,tsim-1) ;
    pdt.l(r,i,tsim)  $ xdtFlag(r,i) = pdt.l(r,i,tsim-1) ;
);

pmt.l(r,i,tsim)  = pmt.l(r,i,tsim-1) ;
pdt.l(r,i,tsim)  $ xdtFlag(r,i) = pdt.l(r,i,tsim-1) ;

* International prices

pe.l(r,i,rp,tsim)   = pe.l(r,i,rp,tsim-1)   ;
pet.l(r,i,tsim)     = pet.l(r,i,tsim-1)     ;
pwe.l(r,i,rp,tsim)  = pwe.l(r,i,rp,tsim-1)  ;
pwm.l(r,i,rp,tsim)  = pwm.l(r,i,rp,tsim-1)  ;
pdm.l(r,i,rp,tsim)  = pdm.l(r,i,rp,tsim-1)  ;
pwmg.l(r,i,rp,tsim) = pwmg.l(r,i,rp,tsim-1) ;
ptmg.l(img,tsim)    = ptmg.l(img,tsim-1)    ;

* Factor prices

pnrf.l(r,a,tsim)    $ xpFlag(r,a) = pnrf.l(r,a,tsim-1)    ;
pnrfp.l(r,a,tsim)   $ xpFlag(r,a) = pnrfp.l(r,a,tsim-1)   ;
wage.l(r,l,a,tsim)  $ xpFlag(r,a) = wage.l(r,l,a,tsim-1)  ;
wagep.l(r,l,a,tsim) $ xpFlag(r,a) = wagep.l(r,l,a,tsim-1) ;
pk.l(r,a,v,tsim)    $ xpFlag(r,a) = pk.l(r,a,v,tsim-1)    ;
pkp.l(r,a,v,tsim)   $ xpFlag(r,a) = pkp.l(r,a,v,tsim-1)   ;
pland.l(r,a,tsim)   $ xpFlag(r,a) = pland.l(r,a,tsim-1)   ;
plandp.l(r,a,tsim)  $ xpFlag(r,a) = plandp.l(r,a,tsim-1)  ;

awagez.l(r,l,z,tsim)  = awagez.l(r,l,z,tsim-1);
ewagez.l(r,l,z,tsim)  = ewagez.l(r,l,z,tsim-1);
twage.l(r,l,tsim)     = twage.l(r,l,tsim-1)   ;
arent.l(r,tsim)       = arent.l(r,tsim-1)     ;
trent.l(r,tsim)       = trent.l(r,tsim-1)     ;
rrat.l(r,a,tsim) $ xpFlag(r,a) = rrat.l(r,a,tsim-1);

ptland.l(r,tsim)      = ptland.l(r,tsim-1)    ;
ptlandndx.l(r,tsim)   = ptlandndx.l(r,tsim-1) ;
plb.l(r,lb,tsim)      = plb.l(r,lb,tsim-1)    ;
plbndx.l(r,lb,tsim)   = plbndx.l(r,lb,tsim-1) ;
pnlb.l(r,tsim)        = pnlb.l(r,tsim-1)      ;
pnlbndx.l(r,tsim)     = pnlbndx.l(r,tsim-1)   ;

* Macro prices

pmuv.l(tsim)     = pmuv.l(tsim-1)      ;
pwgdp.l(tsim)    = pwgdp.l(tsim-1)     ;
pwsav.l(tsim)    = pwsav.l(tsim-1)     ;
pw.l(a,tsim) $ pw0(a) = pw.l(a,tsim-1) ;
pgdpmp.l(r,tsim) = pgdpmp.l(r,tsim-1)  ;


*	QUANTITY VARIABLES

riswork(r,aa) = 0 ; riswork(r,aa) = rwork(r) ; riswork(r,i) = rwork(r) ;

* It seems that it is not a good idea for Power:	riswork(r,powa) = 1 ;

* [TBU]: Check with change in dynamic scale

xpv.l(r,a,v,tsim) 	 $ xpFlag(r,a)   = riswork(r,a) * xpv.l(r,a,v,tsim-1) 	;
xp.l(r,a,tsim)    	 $ xpFlag(r,a)   = sum(v, xpv.l(r,a,v,tsim)) 			;
xpx.l(r,a,v,tsim)    $ xpFlag(r,a)   = riswork(r,a) * xpx.l(r,a,v,tsim-1)   ;
xghg.l(r,a,v,tsim)   $ xpFlag(r,a)   = riswork(r,a) * xghg.l(r,a,v,tsim-1)  ;
nd1.l(r,a,tsim)      $ xpFlag(r,a)   = riswork(r,a) * nd1.l(r,a,tsim-1)     ;
va.l(r,a,v,tsim)     $ xpFlag(r,a)   = riswork(r,a) * va.l(r,a,v,tsim-1)    ;
lab1.l(r,a,tsim)     $ xpFlag(r,a)   = riswork(r,a) * lab1.l(r,a,tsim-1)    ;
kef.l(r,a,v,tsim)    $ xpFlag(r,a)   = riswork(r,a) * kef.l(r,a,v,tsim-1)   ;
nd2.l(r,a,tsim)      $ xpFlag(r,a)   = riswork(r,a) * nd2.l(r,a,tsim-1)     ;
va1.l(r,a,v,tsim)    $ xpFlag(r,a)   = riswork(r,a) * va1.l(r,a,v,tsim-1)   ;
va2.l(r,a,v,tsim)    $ xpFlag(r,a)   = riswork(r,a) * va2.l(r,a,v,tsim-1)   ;

* En mettant ci-dessous landFlag(r,a) reduit taille des output dans le gdx final
* si je corrige ausso dans 6-closure

land.l(r,a,tsim)     $ (xpFlag(r,a) and landFlag(r,a))  = riswork(r,a) * land.l(r,a,tsim-1)    ;
kf.l(r,a,v,tsim)     $ xpFlag(r,a)   = riswork(r,a) * kf.l(r,a,v,tsim-1)    ;
xnrg.l(r,a,v,tsim)   $ xpFlag(r,a)   = riswork(r,a) * xnrg.l(r,a,v,tsim-1)  ;
ksw.l(r,a,v,tsim)    $ xpFlag(r,a)   = riswork(r,a) * ksw.l(r,a,v,tsim-1)   ;
xnrf.l(r,a,tsim)     $ xpFlag(r,a)   = riswork(r,a) * xnrf.l(r,a,tsim-1)    ;
ks.l(r,a,v,tsim)     $ xpFlag(r,a)   = riswork(r,a) * ks.l(r,a,v,tsim-1)    ;
xwat.l(r,a,tsim)     $ xpFlag(r,a)   = riswork(r,a) * xwat.l(r,a,tsim-1)    ;
kv.l(r,a,v,tsim)     $ xpFlag(r,a)   = riswork(r,a) * kv.l(r,a,v,tsim-1)    ;
lab2.l(r,a,tsim)     $ xpFlag(r,a)   = riswork(r,a) * lab2.l(r,a,tsim-1)    ;
ld.l(r,l,a,tsim)     $ xpFlag(r,a)   = riswork(r,a) * ld.l(r,l,a,tsim-1)    ;

* [OECD-ENV]: IfNrgNest is agent specific

xnely.l(r,a,v,tsim) $ ( IfNrgNest(r,a) and xpFlag(r,a) )
    = riswork(r,a) * xnely.l(r,a,v,tsim-1) ;
xolg.l(r,a,v,tsim) $ ( IfNrgNest(r,a) and xpFlag(r,a) )
    = riswork(r,a) * xolg.l(r,a,v,tsim-1) ;
xaNRG.l(r,a,NRG,v,tsim) $ ( IfNrgNest(r,a) and xpFlag(r,a) )
    = riswork(r,a) * xaNRG.l(r,a,NRG,v,tsim-1) ;

emi.l(r,emSingle,emiact,a,tsim) $ ghgFlag(r,a)
    = riswork(r,a) * emi.l(r,emSingle,emiact,a,tsim-1) ;

xa.l(r,i,aa,tsim)  = riswork(r,aa) * xa.l(r,i,aa,tsim-1) ;

* [EditJean]: add this

x.l(r,a,i,tsim) $ (xpFlag(r,a) AND gp(r,a,i)) =  gp(r,a,i) * xp.l(r,a,tsim) ;
xs.l(r,i,tsim)  $ xsFlag(r,i)
	= sum(a $ as(r,a,i,tsim), as(r,a,i,tsim) * x.l(r,a,i,tsim)) ;

IF(IfArmFlag,
    xd.l(r,i,aa,tsim) = rwork(r) * xd.l(r,i,aa,tsim-1);
    xm.l(r,i,aa,tsim) = rwork(r) * xm.l(r,i,aa,tsim-1);
ELSE
    xdt.l(r,i,tsim)   = rwork(r) * xdt.l(r,i,tsim-1) ;
    xmt.l(r,i,tsim)   = rwork(r) * xmt.l(r,i,tsim-1) ;
);

xpow.l(r,elyi,tsim)   = rwork(r) * xpow.l(r,elyi,tsim-1)   ;
xpb.l(r,pb,elyi,tsim) = rwork(r) * xpb.l(r,pb,elyi,tsim-1) ;

kxRat.l(r,a,vOld,tsim) $ xpFlag(r,a) = kxRat.l(r,a,vOld,tsim-1) ;

etanrf.l(r,a,tsim)  $ xpFlag(r,a) = etanrf.l(r,a,tsim-1)  ;

*	HOUSEHOLDS VARIABLES

yh.l(r,tsim)             = rwork(r) * yh.l(r,tsim-1)        ;
deprY.l(r,tsim)          = rwork(r) * deprY.l(r,tsim-1)     ;
yd.l(r,tsim)             = rwork(r) * yd.l(r,tsim-1)        ;
supy.l(r,h,tsim)         = rwork(r) * supy.l(r,h,tsim-1)    ;
xc.l(r,k,h,tsim)         = rwork(r) * xc.l(r,k,h,tsim-1)    ;
u.l(r,h,tsim)            = rwork(r) * u.l(r,h,tsim-1)       ;
xcnnrg.l(r,k,h,tsim)     = rwork(r) * xcnnrg.l(r,k,h,tsim-1);
xcnrg.l(r,k,h,tsim)      = rwork(r) * xcnrg.l(r,k,h,tsim-1) ;
xcnely.l(r,k,h,tsim)     = rwork(r) * xcnely.l(r,k,h,tsim-1);
xcolg.l(r,k,h,tsim)      = rwork(r) * xcolg.l(r,k,h,tsim-1) ;
xacNRG.l(r,k,h,NRG,tsim) = rwork(r) * xacNRG.l(r,k,h,NRG,tsim-1) ;
savh.l(r,h,tsim)         = rwork(r) * savh.l(r,h,tsim-1)    ;
ygov.l(r,gy,tsim)        = rwork(r) * ygov.l(r,gy,tsim-1)   ;
yfd.l(r,fd,tsim)         = rwork(r) * yfd.l(r,fd,tsim-1)    ;

hshr.l(r,k,h,tsim)       = hshr.l(r,k,h,tsim-1) ;
aps.l(r,h,tsim)          = aps.l(r,h,tsim-1) ;


*	TRADE VARIABLES

* Armington variables

xat.l(r,i,tsim)          = rwork(r) * xat.l(r,i,tsim-1) ;

* International Trade (do not scale for iter method)

xw.l(r,i,rp,tsim)        = rwork(r) * xw.l(r,i,rp,tsim-1) ;
xet.l(r,i,tsim)          = rwork(r) * xet.l(r,i,tsim-1) ;

* Trade margins

xwmg.l(r,i,rp,tsim)     = rwork(r) * xwmg.l(r,i,rp,tsim-1) ;
xmgm.l(img,r,i,rp,tsim) = rwork(r) * xmgm.l(img,r,i,rp,tsim-1) ;
xtt.l(r,i,tsim)         = rwork(r) * xtt.l(r,i,tsim-1) ;

xtmg.l(img,tsim)        = xtmg.l(img,tsim-1) ;

* [EditJean] do not scale for iter method

*IF(nriter,
*	xw.l(r,i,rp,tsim)       = xw.l(r,i,rp,tsim-1) ;
*	xtt.l(r,i,tsim)         = xtt.l(r,i,tsim-1) ;
*) ;

* Labor Supply

rwork_bis(r) $ popT(r,"P1564",tsim-1)    = popT(r,"P1564",tsim) / popT(r,"P1564",tsim-1) ;
ldz.l(r,l,z,tsim)   = rwork_bis(r) * ldz.l(r,l,z,tsim-1) ;
lsz.l(r,l,z,tsim)   = rwork_bis(r) * lsz.l(r,l,z,tsim-1) ;
tls.l(r,tsim)       = rwork_bis(r) * tls.l(r,tsim-1) ;
ls.l(r,l,tsim)      = rwork_bis(r) * ls.l(r,l,tsim-1) ;

urbPrem.l(r,l,tsim)   = urbPrem.l(r,l,tsim-1)   ;
migr.l(r,l,tsim)      = migr.l(r,l,tsim-1)      ;
skillprem.l(r,l,tsim) = skillprem.l(r,l,tsim-1) ;

tland.l(r,tsim)     = tland.l(r,tsim-1) ;

xlb.l(r,lb,tsim)    = xlb.l(r,lb,tsim-1) ;
xnlb.l(r,tsim)      = xnlb.l(r,tsim-1) ;

*   Efficiency (here because of slicing but also in "7-iterloop.gms")
* --> [TBU] simplify repetition NOT DO THIS ?

IF(ifCal,
    lambdae.l(r,e,a,v,tsim) $ xaFlag(r,e,a)
        = lambdae.l(r,e,a,v,tsim-1)
        * power(1 + 0.01 * aeei(r,e,a,v,tsim), gap(tsim)) ;
    lambdak.l(r,a,v,tsim) $ kFlag(r,a)
        = lambdak.l(r,a,v,tsim-1)
        * power(1 + 0.01 * g_kt(r,a,v,tsim), gap(tsim));
    lambdat.l(r,a,v,tsim) $ agra(a)
        = lambdat.l(r,a,v,tsim-1)
        * power(1 + 0.01 * yexo(r,a,v,tsim), gap(tsim)) ;
    lambdanrf.fx(r,a,v,tsim) $ nrfFlag(r,a)
        = lambdanrf.l(r,a,v,tsim)
        * power(1 + 0.01 * g_nrf(r,a,v,tsim), gap(tsim)) ;
) ;

*   MACRO VARIABLES

pop.l(r,tsim) = pop.l(r,tsim-1) * popT(r,"PTOTL",tsim) / popT(r,"PTOTL",tsim-1);

***HRR
$IFi %ifWEOsavcal%=="OFF" savg.l(r,tsim) = savg.l(r,tsim-1) ; !! always endogenous

* fixed (calibrated for ifCal)

***HRR
$IFi %ifWEOsavcal%=="OFF" rsg.l(r,tsim) $ ((not ifCal) and GovBalance(r) eq 1) = rsg.l(r,tsim-1) ;

kappah.l(r,tsim)   $ (GovBalance(r) eq 0) = kappah.l(r,tsim-1)   ;
kappal.l(r,l,tsim) $ (GovBalance(r) eq 3) = kappal.l(r,l,tsim-1) ;

xfd.l(r,fd,tsim) $ (not gov(fd)) = rwork(r) * xfd.l(r,fd,tsim-1) ;
kstocke.l(r,tsim) = rwork(r) * kstocke.l(r,tsim-1) ;
ror.l(r,tsim)     = ror.l(r,tsim-1)     ;
rorc.l(r,tsim)    = rorc.l(r,tsim-1)    ;
rore.l(r,tsim)    = rore.l(r,tsim-1)    ;
devRoR.l(r,tsim)  = devRoR.l(r,tsim-1)  ;
grK.l(r,tsim)     = grK.l(r,tsim-1)     ;
rorg.l(tsim)      = rorg.l(tsim-1)      ;
savf.l(r,tsim)    = savf.l(r,tsim-1)    ;

IF(IfCal,
	wchinrf.l(a,tsim) = wchinrf.l(a,tsim-1) ;
) ;

gdpmp.l(r,tsim)   = rwork(r) * gdpmp.l(r,tsim-1)  ;
rgdpmp.l(r,tsim)  = rwork(r) * rgdpmp.l(r,tsim-1) ;
kstock.l(r,tsim)  = rwork(r) * kstock.l(r,tsim-1) ;
tkaps.l(r,tsim)   = rwork(r) * tkaps.l(r,tsim-1)  ;
rgdppc.l(r,tsim)  = rgdppc.l(r,tsim-1) * rwork(r)
                  / ( popT(r,"PTOTL",tsim) / popT(r,"PTOTL",tsim-1) ) ;
grrgdppc.l(r,tsim)= grrgdppc.l(r,tsim-1) ;
rgovshr.l(r,tsim) = rgovshr.l(r,tsim-1)  ;
govshr.l(r,tsim)  = govshr.l(r,tsim-1)   ;
rinvshr.l(r,tsim) = rinvshr.l(r,tsim-1)  ;
invshr.l(r,tsim)  = invshr.l(r,tsim-1)   ;

IF(1,
    invGFact.l(r,tsim) = invGFact.l(r,tsim-1) ;
ELSE
    invGFact.l(r,tsim)
    = 1 / [ sum(inv, xfd.l(r,inv,tsim) / xfd.l(r,inv,tsim-1) )**(1/gap(tsim))
            - 1 + depr(r,tsim) ] ;
) ;

$ifthen.RD "%ifRD_MODULE%" == "ON"
   rd.l(r,tsim) = rwork(r)*rd.l(r,tsim-1) ;
   loop(ty$(years(ty) gt years(tsim-1) and years(ty) lt years(tsim)),
      rd.l(r,ty)$rd.l(r,tsim-1) = rd.l(r,tsim-1)*(rd.l(r,tsim)/rd.l(r,tsim-1))**((years(ty)-years(tsim-1))/(years(tsim)-years(tsim-1))) ;
   ) ;
   loop(ty$(years(ty) gt years(tsim-1) and years(ty) lt years(tsim)),
      kn.l(r,ty) = (1 - kdepr(r,ty))*kn.l(r,ty-1)
                 +  sum((ky,tt)$(valk(ky) le gamPrm(r,"N") and years(ty)-years(tt) eq valk(ky)),
                        gamCoef(r,ky)*rd.l(r,tt)*rd0(r)/kn0(r)) ;
   ) ;
   pik.l(r,l,a,tsim) = gammar(r,l,a,tsim)*epsr(r,l,a,tsim)*((kn.l(r,tsim)/kn.l(r,tsim-1))**(1/gap(tsim)) - 1) ;
$endif.RD