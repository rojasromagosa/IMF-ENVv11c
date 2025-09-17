$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
   GAMS file    : "%ModelDir%\3-ModelDefinition.gms"
   purpose      : Definitions of various model for
                  SimType ={"Baseline","Variant,"compStat"}
   Created by   : Jean Chateau from original ENVISAGE codes
   Created date : 22 December 2021
   called by    : "%ModelDir%\%SimType%.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/3-ModelDefinition.gms $
   last changed revision:    $Rev: 518 $
   last changed date    :    $Date:: 2024-02-29 #$
   last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

model core "Equations for all models" /

   pxEQ.px, ucEQ.uc, pxvEQ.pxv,
   xpxEQ.xpx, xghgEQ.xghg,
   nd1EQ.nd1, vaEQ.va, pxpEQ.pxp,
   lab1EQ.lab1, kefEQ.kef, nd2EQ.nd2,
   va1EQ.va1, va2EQ.va2, landEQ.land,
   pvaEQ.pva, pva1EQ.pva1, pva2EQ.pva2

   kfEQ.kf, xnrgEQ.xnrg, pkefEQ.pkef,
   kswEQ.ksw, xnrfEQ.xnrf, pkfEQ.pkf,
   ksEQ.ks, pkswEQ.pksw,
   kvEQ.kv, lab2EQ.lab2, pksEQ.pks,
   ldEQ.ld, plab1EQ.plab1, plab2EQ.plab2,

   xapEQ.xa, pnd1EQ.pnd1, pnd2EQ.pnd2,
   xnelyEQ.xnely, xolgEQ.xolg, xaNRGEQ.xaNRG, xaeEQ.xa,
   paNRGEQ.paNRG, polgEQ.polg, pnelyEQ.pnely, pnrgEQ.pnrg,

   xEQ.x, 
***HRR: linked to xp, but we keep open to swap with TFPxpv
xpEQ,
***endHRR

   pEQ.p, 
  
   psEQ.ps,
   
   xetdEQ.p, xpowEQ.xpow, pselyEQ.ps,
   xpbEQ.xpb, ppowndxEQ.ppowndx, ppowEQ.ppow,
   xbndEQ.p, ppbndxEQ.ppbndx, ppbEQ.ppb,

   deprYEQ.deprY, yqtfEQ.yqtf, trustYEQ.trustY, yqhtEQ.yqht, remitEQ.remit,
   yhEQ.yh, ydEQ.yd,
   ygovEQ.ygov,

   $$IFi     %oDir%=="12July2022_Decomposition" yfdInvEQ,
   $$IFi NOT %oDir%=="12July2022_Decomposition" yfdInvEQ.xfd,

   supyEQ.supy, thetaEQ.theta, hshrEQ.hshr, mucEQ.muc, uEQ.u,
   xcnnrgEQ.xcnnrg, xcnrgEQ.xcnrg, pcEQ.pc,
   xacnnrgEQ.xa, pcnnrgEQ.pcnnrg,
   xcnelyEQ.xcnely, xcolgEQ.xcolg, xacNRGEQ.xacNRG, xaceEQ.xa,
   pacNRGEQ.pacNRG, pcolgEQ.pcolg, pcnelyEQ.pcnely, pcnrgEQ.pcnrg,

   savhELESEQ.aps, savhEQ.savh,

   xafEQ.xa, pfdfEQ.pfd, yfdEQ.yfd,

   xatEQ.xat, xdtEQ.xdt, xmtEQ.xmt, patEQ.pat, paEQ.pa,
   xdEQ.xd, xmEQ.xm,
   xwdEQ.xw, pmtEQ.pmt,
   pdtEQ.pdt, xetEQ.xet, xsEQ.xs, xwsEQ.pe, petEQ.pet,
   xtmgEQ.xtmg, xttEQ.xtt, ptmgEQ.ptmg,

   ldzEQ.ldz, awagezEQ.awagez,
   uezEQ.ewagez, twageEQ.twage, wageEQ.wage,
   skillpremEQ.skillprem, lsEQ.ls, tlsEQ.tls,

   wagepEQ.wagep, pkpEQ.pkp, plandpEQ.plandp, pnrfpEQ.pnrfp, ph2opEQ.ph2op,

   pkEQ.pk, trentEQ.trent,
*  trentVintEQ.trent, pkVintEQ.pk,
   kxRatEQ.kxRat, rratEQ.rrat, rrateq_CNS.rrat,
   k0EQ.k0, xpvEQ.xpv, arentEQ.arent
   tlandEQ.tland,
   xlb1EQ.xlb, xnlbEQ.xnlb, ptlandndxEQ.ptlandndx, ptlandEQ.ptland,
   xlbnEQ.xlb, pnlbndxEQ.pnlbndx, pnlbEQ.pnlb,
   plandEQ.pland, plbndxEQ.plbndx, plbEQ.plb,

   etanrfEQ.etanrf, xnrfsEQ.pnrf,

   pfdhEQ.pfd, yfdhEQ.xfd, gdpmpEQ.gdpmp, rgdpmpEQ.rgdpmp, pgdpmpEQ.pgdpmp,
   rgdppcEQ.rgdppc,

   savgEQ.savg,

$iftheni %simType% == "CompStat"
   rsgeq.kappah
$elseifi %simType% == "Baseline"
    $$if not %BaseName%=="2024_MCD_MAR" rsgeq.kappah
    $$if     %BaseName%=="2024_MCD_MAR" rsgeq
$else
   rsgeq
$endif
   

   kstockeEQ.kstocke, rorEQ.ror, rorcEQ.rorc, roreEQ.rore,
* [EditJean]: pour le moment je retire cette equation [TBR]
*   rorgeq,

* [EditJean]: dans tous les cas faudrait enlever association pour le cas pays par pays
    savfEQ.savf,

   devRoREQ.devRoR, grkEQ.grK,
   pmuvEQ.pmuv, pwgdpEQ.pwgdp, pwsavEQ.pwsav, pnumeq,

	xcEQ.xc,

   emiiEQ.emi, emifEQ.emi, emixEQ.emi, emiGblEQ.emiGbl,
   emiTaxEQ.emiTax,
   emiQuotaYEQ.emiQuotaY,

   $$IFi NOT %BaseName%=="2022_India" emiCapEQ.emiRegTax,
   $$IFi     %BaseName%=="2022_India" emiCapEQ,

* OECD-ENV: New equations

    EQ_PI0_xa.PI0_xa,
    EQ_PI0_xc.PI0_xc,
    EQ_wldPm.wldPm,
    pxghgEQ.pxghg,
	pwEQ.pw,
*    xoapEQ.xoap,

* [EditJean]: enleve association car var. peut etre calibre:
* invshrEQ.invshr, rinvshrEQ.rinvshr, --> move below
* [EditJean]: enleve association car var. peut etre calibre:
* rgovshrEQ.rgovshr, govshrEQ.govshr, --> move below

    $$IFi     %SimType%=="Baseline" rgovshreq
    $$IFi NOT %SimType%=="Baseline" rgovshrEQ.rgovshr,

    govshrEQ.govshr,
    rfdshrEQ, nfdshrEQ,

* Je ne comprends pas:
* si on associe PAS une variable comme invshr a invshreq
* si variable est fixee durant calib alors holdfixed elimine equation
* Mais comment il sait quelle equation ?

    $$IFi NOT %SimType%=="Baseline" invshrEQ.invshr, rinvshrEQ.rinvshr,

* maintenant si on associe invshr.invshreq ca ne marche plus
* Meme si j'elimine equation avec un Flag : IfCalMacro(r,"rinvshr")
* Pourquoi pour autre Flag ca marche ????
*    invshrEQ.invshr,  rinvshrEQ.rinvshr,
*   DONC DANS LE 1er CAS LES FLAGS EN FAIT SERVENT A RIEN

* OECD-ENV: remove the pairing rsgEQ.kappah because multiple closure rules
*--> put savg? Message bizarre: Multiple Matchings of equ.var pair savg(JPN,2015)

    emiTotEQ.emiTot,

* OECD-ENV: Auxilliary equations (ie "26-model_AltEq.gms")

    ppEQ.pp,
    xwatEQ.xwat, h2oEQ.h2o,
    xapIwEQ.xa,
    pwatEQ.pwat,
    pdEQ.pd, pmEQ.pm, pweEQ.pwe, pwmEQ.pwm, pdmEQ.pdm,
    xwmgEQ.xwmg, xmgmEQ.xmgm, pwmgEQ.pwmg,
    resWageEQ.resWage, ewagezEQ.uez, urbPremEQ.urbPrem,
    th2oEQ.th2o, h2obndEQ.h2obnd, pth2ondxEQ.pth2ondx, pth2oEQ.pth2o,
    th2omEQ.th2om, ph2obndndxEQ.ph2obndndx, ph2obndEQ.ph2obnd, ph2oEQ.ph2o,
    pxoapEQ.pxoap, emiaEQ,
    emiCapMCPEQ.emiRegTax,
    
    $$iftheni.RD "%ifRD_MODULE%" == "ON"
      kneq, rdeq, pikeq,
    $$endif.RD

    walraseq
    dummyeq
/ ;

core.holdfixed = 1 ;

model coreBau "Dynamic Model for calibration" /
    core +

*   rsgEQ.kappah,

    $$IfTheni.DynCalEq "%SimType%"=="baseline"

* OECD-ENV baseline

    $$IfTheni.DynCalibration %DynCalMethod%=="OECD-ENV"

            DynCal_xp_eq, DynCal_xafd_eq,
            DynCal_lambdak_EQ.lambdak, DynCal_xap_EQ,
*           DynCal_xc_EQ.theta, DynCal_macro_EQ.avg_kt,
            TFP_xpxEQ.TFP_xpx, TFP_fpEQ.TFP_fp,
            TFP_xpx_bisEQ,
            DynCal_tlandEQ.chiLand,
            InvshrEQ,
            DynCal_emiiEQ.chiEmiDet,
            DynCal_emifEQ.chiEmiDet,
            DynCal_emixEQ.chiEmiDet,
			DynCal_ps_EQ,
			DynCal_pw_EQ,
			DynCal_xc_EQ.theta,
			DynCal_xs_EQ.TFP_xs,

        $$ELSE.DynCalibration

* ENVISAGE baseline

            invshrEQ.invshr, 

        $$ENDIF.DynCalibration

        rinvshreq,

    $$EndIf.DynCalEq

    grrgdppcEQ.gl, lszEQ.lsz, glabEQ.glab,

    invGFactEQ.invGFact, kstockEQ.kstock, tkapsEQ.tkaps

* [OECD-ENV]: Auxilliary equations (ie "28-model_AltEq.gms")

    emiTotEndoEQ.chiEmi,
    emiTotNonCO2EQ.chiTotEmi,

    migrEQ.migr, migrMultEQ.migrMult,

    lambdalEQ.lambdal

   / ;

coreBaU.holdfixed = 1 ;

* coreBaU.MCPRHoldFx = 1; --> ceci ne marche pas

model coreDyn "Dynamic Model for variants" /
   core +
    grrgdppcEQ.grrgdppc,
    xpbConstraintEQ.FospCShadowPrice,
*   rsgeq,
    migrEQ.migr, migrMultEQ.migrMult, lszEQ.lsz, glabEQ.glab,
    invGFactEQ.invGFact, kstockEQ.kstock, tkapsEQ.tkaps,

* [OECD-ENV]: Auxilliary equations defined in "28-model_AltEq.gms"

    $$IFi %SimType%=="Variant" LFPREQ.LFPR,
    kveqbis.pk,
    lambdakEQ.lambdak,
    kvConstrEQ.pkpShadowPrice,
    emiaConstraintEQ.emiaShadowPrice,
    xpConstraintEq.pim,
	PP_permitEQ.PP_permit, pEmiPermitEQ.pEmiPermit,
    CPE_capEQ.chiPtax, RenewTgtEQ.Renew
/ ;

coreDyn.holdfixed = 1 ;

* Set the solution options

options limrow=50, limcol=2, iterlim=1000, solprint=off ;
core.tolinfrep    = 1e-5 ;
coreBaU.tolinfrep = 1e-5 ;
coreDyn.tolinfrep = 1e-5 ;
options limrow=0, limcol=0;

**************************************************************************************
* New code by Hasan to speed solving procedure
$ifi not setglobal maxIterSolve $set maxIterSolve 10
set iter /1*%maxIterSolve%/ ;
Parameter iternum(iter) "Max number of repated solves";
iternum(iter) = ord(iter) ;
if ( execError, abort " Execerror encountered at end of file: %system.fn%, line: %system.incline%")

Parameter
optRec(t)               "Stores successful opt files from baseline for later use in simulations" ; 
optRec(t) = 0;