$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%ModelDir%\70-Clean_Small_XP.gms"
   purpose     : Clean small production processes between two periods
   created date: 2021-03-17
   created by  : Jean Chateau
   called by   : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/70-Clean_Small_XP.gms $
   last changed revision: $Rev: 347 $
   last changed date    : $Date:: 2023-07-10 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

LOOP( (r,a) $ (xpFlag(r,a) eq 0 AND NOT tota(a)),

    xp.fx(r,a,tsim)     = 0;
    va.fx(r,a,v,tsim)   = 0;
    xpv.fx(r,a,v,tsim)  = 0;
    pxv.fx(r,a,v,tsim)  = 0;
    px.fx(r,a,tsim)     = 0; uc.fx(r,a,v,tsim) = 0 ;
    xpx.fx(r,a,v,tsim)  = 0; pxp.fx(r,a,v,tsim) = 0 ;

	xghg.fx(r,a,v,tsim)  $ ghgFlag(r,a) = 0;
	pxghg.fx(r,a,v,tsim) $ ghgFlag(r,a) = 0;
	ghgFlag(r,a) = 0;

	nd1.fx(r,a,tsim)    = 0; nd1Flag(r,a) = 0;
    nd2.fx(r,a,tsim)    = 0; nd2Flag(r,a) = 0;

    va1.fx(r,a,v,tsim)  = 0; va1Flag(r,a)  = 0;
    va2.fx(r,a,v,tsim)  = 0; va2Flag(r,a)  = 0;
    lab1.fx(r,a,tsim)   = 0; lab1Flag(r,a) = 0;
    kef.fx(r,a,v,tsim)  = 0; kefFlag(r,a)  = 0;
    kf.fx(r,a,v,tsim)   = 0; kfFlag(r,a)   = 0;
    ksw.fx(r,a,v,tsim)  = 0; kFlag(r,a)    = 0;
    ks.fx(r,a,v,tsim)   = 0; kFlag(r,a)    = 0; !! same Flage for ks and ksw
    lab2.fx(r,a,tsim)   = 0; lab2Flag(r,a) = 0;
    xnrg.fx(r,a,v,tsim) = 0; xnrgFlag(r,a) = 0;

    pnd1.fx(r,a,tsim)   = 0;
    pnd2.fx(r,a,tsim)   = 0;
    pva.fx(r,a,v,tsim)  = 0;
    pva1.fx(r,a,v,tsim) = 0;
    pva2.fx(r,a,v,tsim) = 0;
    plab1.fx(r,a,tsim)  = 0;
    pkef.fx(r,a,v,tsim) = 0;
    pkf.fx(r,a,v,tsim)  = 0;
    pksw.fx(r,a,v,tsim) = 0;
    pks.fx(r,a,v,tsim)  = 0;
    plab2.fx(r,a,tsim)  = 0;
    pnrg.fx(r,a,v,tsim) = 0;

	PermitAllowancea(r,AllEmissions,a,tsim) = 0 ;
	PP_permit.fx(r,a,t) = 0 ;

* primary factor variables

    land.fx(r,a,tsim)   = 0; LandFlag(r,a)  = 0;
    xnrf.fx(r,a,tsim)   = 0; nrfFlag(r,a)   = 0;
    xwat.fx(r,a,tsim)   = 0; watFlag(r,a)   = 0;
    h2o.fx(r,a,tsim)    = 0; xwatfFlag(r,a) = 0;
    kv.fx(r,a,v,tsim)   = 0; kFlag(r,a)     = 0; !! same Flag for ks, ksw & kv
    ld.fx(r,l,a,tsim)   = 0; labFlag(r,l,a) = 0;
    kxRat.fx(r,a,vOld,tsim) = 0;
    rrat.fx(r,a,tsim)   = 0;
    wage.fx(r,l,a,tsim) = 0;
    pland.fx(r,a,tsim)  = 0;
    pnrf.fx(r,a,tsim)   = 0;
    pwat.fx(r,a,tsim)   = 0;
    ph2o.fx(r,a,tsim)   = 0;
    pk.fx(r,a,v,tsim)   = 0;

    lambdal.fx(r,l,a,tsim) = 0;

    xa.fx(r,i,a,tsim)  = 0; xaFlag(r,i,a) = 0;

    IF(IfNrgNest(r,a),
        xaNRG.fx(r,a,NRG,v,tsim) = 0; xaNRGFlag(r,a,NRG) = 0;
        xnely.fx(r,a,v,tsim)     = 0; xnelyFlag(r,a)     = 0;
        xolg.fx(r,a,v,tsim)      = 0; xolgFlag(r,a)      = 0;
        paNRG.fx(r,a,NRG,v,tsim) = 0;
        pnely.fx(r,a,v,tsim)     = 0;
        polg.fx(r,a,v,tsim)      = 0;
    ) ;

    LOOP((t0,i) $ ( sum(a.local $ as(r,a,i,t0), 1) eq 1 and x.l(r,a,i,t0) ),
        xdt.fx(r,i,tsim)   = 0 ; xdtFlag(r,i)      = 0 ;
        pdt.fx(r,i,tsim)   = 0 ; alphadt(r,i,tsim) = 0 ; alphamt(r,i,tsim) = 1 ;
        xet.fx(r,i,tsim)   = 0 ; xetFlag(r,i)      = 0 ;
        pet.fx(r,i,tsim)   = 0 ;
        pe.fx(r,i,rp,tsim) = 0 ;
        xw.fx(r,i,rp,tsim) = 0 ; xwFlag(r,i,rp) = 0 ;
* [TBU] for: sum(a.local $ tmat(a,i,r) ,1) > 1
        ps.fx(r,i,tsim) = 0 ;
        xs.fx(r,i,tsim) = 0 ; xsFlag(r,i) = 0;
        xd.fx(r,i,a,tsim) $ IfArmFlag = 0;
        xdFlag(r,i,a)     $ IfArmFlag = 0;
        xddFlag(r,i) 	= 0 ;
    );

    x.fx(r,a,i,tsim) = 0 ;  gp(r,a,i)      = 0 ;
    p.fx(r,a,i,tsim) = 0 ;  as(r,a,i,tsim) = 0 ;

    emi.fx(r,AllEmissions,EmiSourceAct,a,tsim) 		= 0 ;
    emir(r,AllEmissions,EmiSourceAct,a,tsim)   		= 0 ;
    emia.l(r,a,AllEmissions,tsim) 			   		= 0 ;
	p_emissions(r,AllEmissions,EmiSourceAct,a,tsim) = 0 ;
) ;

*	Clean a Power Bundle if it is empty

If(IfPower,
    LOOP((r,pb) $ (sum(mappow(pb,powa), xpFlag(r,powa)) eq 0),
        apb(r,pb,elyi,tsim)       = 0 ;
        ppbndx.fx(r,pb,elyi,tsim) = 0 ;
        ppb.fx(r,pb,elyi,tsim)    = 0 ;
        xpb.fx(r,pb,elyi,tsim)    = 0 ;
    ) ;
);
