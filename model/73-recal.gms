$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file    : "%ModelDir%\73-recal.gms"
	purpose      : Recalibrate production CES coefficient for Old vintages
				   at the beginning of current year to adjust past vintages
				   Twisting the Armington preference parameters
	Created by   : 	Dominique van der Mensbrugghe for ENVISAGE
				  + modification by Jean Chateau for OECD-ENV
	Created date :
	called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
    $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/73-recal.gms $
	last changed revision: $Rev: 508 $
	last changed date    : $Date:: 2024-02-06 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

IF(ord(tsim) gt 2,

*                                              Agg   COMP  PAGG  PCOMP   COEF  ELAST    SET  COMPTECH  AGGTECH

$batinclude "%ModelDir%\recal\recalvat.gms"    xpv   xpx   uc    pxp     axp   sigmaxp 	 a 	 lambdaxp  TFP_xpv
$batinclude "%ModelDir%\recal\recalvatb.gms"   xpv   xghg  uc    pxghg   aghg  sigmaxp 	 a 	 lambdaghg TFP_xpv
$batinclude "%ModelDir%\recal\recalnnnt.gms"   xpx   nd1   pxp   pnd1    and1  sigmap    a   TFP_xpx
$batinclude "%ModelDir%\recal\recalvnnt.gms"   xpx   va    pxp   pva     ava   sigmap    a   TFP_xpx
$batinclude "%ModelDir%\recal\recalnnn.gms"    va    lab1  pva   plab1   alab1 sigmav    cra
$batinclude "%ModelDir%\recal\recalnnn.gms"    va1   lab1  pva1  plab1   alab1 sigmav1   lva
$batinclude "%ModelDir%\recal\recalnnn.gms"    va    lab1  pva   plab1   alab1 sigmav    axa
$batinclude "%ModelDir%\recal\recalvnn.gms"    va2   kef   pva2  pkef    akef  sigmav2   cra
$batinclude "%ModelDir%\recal\recalvnn.gms"    va1   kef   pva1  pkef    akef  sigmav1   lva
$batinclude "%ModelDir%\recal\recalvnn.gms"    va1   kef   pva1  pkef    akef  sigmav1   axa
$batinclude "%ModelDir%\recal\recalnnn.gms"    va1   nd2   pva1  pnd2    and2  sigmav1   cra
$batinclude "%ModelDir%\recal\recalnnn.gms"    va2   nd2   pva2  pnd2    and2  sigmav2   lva
$batinclude "%ModelDir%\recal\recalvnn.gms"    va    va1   pva   pva1    ava1  sigmav    cra
$batinclude "%ModelDir%\recal\recalvnn.gms"    va    va1   pva   pva1    ava1  sigmav    lva
$batinclude "%ModelDir%\recal\recalvnn.gms"    va    va1   pva   pva1    ava1  sigmav    axa
$batinclude "%ModelDir%\recal\recalvnn.gms"    va1   va2   pva1  pva2    ava2  sigmav1   cra
$batinclude "%ModelDir%\recal\recalvnn.gms"    va    va2   pva   pva2    ava2  sigmav    lva
$batinclude "%ModelDir%\recal\recalnnt.gms"    va2   land  pva2  plandp  aland sigmav2   cra lambdat
$batinclude "%ModelDir%\recal\recalnnt.gms"    va2   land  pva2  plandp  aland sigmav2   lva lambdat
$batinclude "%ModelDir%\recal\recalnnt.gms"    va1   land  pva1  plandp  aland sigmav1   axa lambdat
$batinclude "%ModelDir%\recal\recalvnn.gms"    kef   kf    pkef  pkf     akf   sigmakef  a
$batinclude "%ModelDir%\recal\recalvnn.gms"    kef   xnrg  pkef  pnrg    ae    sigmakef  a
$batinclude "%ModelDir%\recal\recalvnn.gms"    kf    ksw   pkf   pksw    aksW  sigmakf   a
$batinclude "%ModelDir%\recal\recalnntb.gms"   kf    xnrf  pkf   pnrfp   anrf  sigmakf   a   lambdanrf
$batinclude "%ModelDir%\recal\recalvnn.gms"    ksw   ks    pksw  pks     aks   sigmakw   a
$batinclude "%ModelDir%\recal\recalvnt.gms"    ks    kv    pks   pkp     ak    sigmak    a   lambdak

*$batinclude "%ModelDir%\recal\recalnnn.gms"    ksw   xwat  pksw  pwat    awat  sigmakw   a
*$batinclude "%ModelDir%\recal\recalnnn.gms"    ks    lab2  pks   plab2   alab2 sigmak    a

IF(ifEndoMAC,
    $$batinclude "%ModelDir%\recal\recalaemi.gms" xghg emi pxghg m_EmiPrice aemi  sigmaemi em a lambdaemi
) ;

* [OECD-ENV]: IfNrgNest is now agent specific

*	IF IfNrgNest(r,a):

$batinclude "%ModelDir%\recal\recalvnnc.gms"   xnrg  xnely pnrg  pnely   anely sigmae    a  $IfNrgNest(r,a)
$batinclude "%ModelDir%\recal\recalvnnc.gms"   xnely xolg  pnely polg    aolg  sigmanely a  $IfNrgNest(r,a)
$batinclude "%ModelDir%\recal\recalnrg.gms"    xnrg  xaNRG pnrg  paNRG   aNRG  sigmae    a  "ELY"
$batinclude "%ModelDir%\recal\recalnrg.gms"    xnely xaNRG pnely paNRG   aNRG  sigmanely a  "COA"
$batinclude "%ModelDir%\recal\recalnrg.gms"    xolg  xaNRG polg  paNRG   aNRG  sigmaolg  a  "GAS"
$batinclude "%ModelDir%\recal\recalnrg.gms"    xolg  xaNRG polg  paNRG   aNRG  sigmaolg  a  "OIL"
$batinclude "%ModelDir%\recal\recalxanrgn.gms" xaNRG xa    paNRG pa      aeio  sigmaNRG  a  lambdae

*	IF NOT IfNrgNest(r,a):

$batinclude "%ModelDir%\recal\recalxanrg.gms"  xnrg  xa    pnrg  pa      aeio  sigmae    a  lambdae

) ;

*------------------------------------------------------------------------------*
*																			   *
*  			Twisting the Armington preference parameters					   *
*					(for dynamic calibration only)							   *
*------------------------------------------------------------------------------*

$ondotL

IF(IfCal,

*     Apply the twist parameters to top level Armington with national sourcing

   IF(NOT IfArmFlag,

* Calculate the top level import shares

        ArmMShrt1(r,i) $ xat0(r,i,tsim)
            =  m_true2(pmt,r,i,tsim-1) * m_true2(xmt,r,i,tsim-1)
            / (m_true2(pat,r,i,tsim-1) * m_true2t(xat,r,i,tsim-1)) ;
        alphadt(r,i,tsim) $ alphadt(r,i,tsim)
            = alphadt(r,i,tsim-1)
            * power(1 / (1 + ArmMShrt1(r,i) * twt1(r,i,tsim)), gap(tsim)) ;
        alphamt(r,i,tsim)
            = alphamt(r,i,tsim-1)
            * power(  (1 + twt1(r,i,tsim))
					/ (1 + ArmMShrt1(r,i) * twt1(r,i,tsim)), gap(tsim)) ;

	ELSE
*	Apply the twist parameters to top level Armington with agent-specific sourcing

* Calculate the top level import shares

      ArmMShr1(r,i,aa) $ (xaFlag(r,i,aa) and xmFlag(r,i,aa))
        =  [pm0(r,i,aa)*pm.l(r,i,aa,tsim-1) * m_true3(xm,r,i,aa,tsim-1)]
        /  [m_true3(pa,r,i,aa,tsim-1) * m_true3t(xa,r,i,aa,tsim-1) ] ;
      alphad(r,i,aa,tsim)
		= alphad(r,i,aa,tsim-1)
        * power( 1 / (1+ArmMShr1(r,i,aa) * tw1(r,i,aa,tsim)), gap(tsim)) ;
      alpham(r,i,aa,tsim)
		= alpham(r,i,aa,tsim-1)
        * power(  (1 + tw1(r,i,aa,tsim))
				/ (1 + ArmMShr1(r,i,aa) * tw1(r,i,aa,tsim)), gap(tsim)) ;
   ) ;

* Apply the twist parameters to second Armington nest
* rtwtgt(rp,r) is the target set of country(ies)

   ArmMShr2(i,r)
    = sum(rp $ xwFlag(rp,i,r),
		m_true3b(pdm,SUB,rp,i,r,tsim-1) * m_true3(xw,r,i,rp,tsim-1) ) ;
   ArmMShr2(i,r) $ ArmMShr2(i,r)
        = sum(rp $ (rtwtgt(rp,r) and xwFlag(rp,i,r)),
			m_true3b(pdm,SUB,rp,i,r,tsim-1) * m_true3(xw,rp,i,r,tsim-1) )
        / ArmMShr2(i,r) ;

   alphaw(rp,i,r,tsim) $ xwFlag(rp,i,r)
        = alphaw(rp,i,r,tsim-1)
        * ( { power( 1 / (1 + ArmMshr2(i,r) * tw2(r,i,tsim)),
							gap(tsim)) } $ {not rtwtgt(rp,r)}
		  + { power( (1 + tw2(r,i,tsim)) / (1 + ArmMShr2(i,r) * tw2(r,i,tsim)),
					gap(tsim)) } $ rtwtgt(rp,r)
		  ) ;
) ;
$offDotL

*	Recalibration ELES parameters (added by Jean Apr-2024)


$IfTheni.elescal %utility%=="ELES"


IF(Ifcal,
   etah.fx(r,k,h,tsim)  =  etah.l(r,k,h,tsim-1) ;

   muc.fx(r,k,h,tsim) $ xcFlag(r,k,h)
        = etah.l(r,k,h,tsim) * [pc.l(r,k,h,tsim-1) * xc.l(r,k,h,tsim-1) * xc0(r,k,h) / (yd.l(r,tsim-1)*yd0(r))];
   mus.fx(r,h,tsim) $ yd.l(r,tsim)
        = 1 - sum(k $ muc.l(r,k,h,tsim), muc.l(r,k,h,tsim)) ; !! mus = savh / SUPY

   theta.l(r,k,h,tsim) $ xcFlag(r,k,h) = theta.l(r,k,h,tsim-1) ;
   theta.lo(r,k,h,tsim) $ xcFlag(r,k,h) = -inf ;
   theta.up(r,k,h,tsim) $ xcFlag(r,k,h) =  inf ;

   yd.fx(r,tsim)     $ yd.l(r,tsim)     = yd.l(r,tsim) ;
   pc.fx(r,k,h,tsim) $ pc.l(r,k,h,tsim) = pc.l(r,k,h,tsim) ;
   xc.fx(r,k,h,tsim) $ xc.l(r,k,h,tsim) = xc.l(r,k,h,tsim) ;

*execute_unload "theta_before.gdx", theta.l;
   solve elescal using mcp ;
*execute_unload "theta_after.gdx", theta.l;

   theta.fx(r,k,h,tsim) = theta.l(r,k,h,tsim);
   yd.lo(r,tsim)       = -inf; yd.up(r,tsim)       = +inf;
   pc.lo(r,k,h,tsim)   = -inf; pc.up(r,k,h,tsim)   = +inf;
   xc.lo(r,k,h,tsim)   = -inf; xc.up(r,k,h,tsim)   = +inf;
);
$EndIf.elescal
