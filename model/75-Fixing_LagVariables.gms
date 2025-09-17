$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   GAMS file    : "75-Fixing_LagVariables.gms"
   purpose      : Fixing lagged variables
   Created by   : Jean Chateau
   Created date : 17 Septembre 2021
   called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/75-Fixing_LagVariables.gms $
   last changed revision:    $Rev: 287 $
   last changed date    :    $Date:: 2023-04-20 #$
   last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

kstock.fx(r,tsim-1)      = kstock.l(r,tsim-1)       ;
tkaps.fx(r,tsim-1)       = tkaps.l(r,tsim-1)        ;
kv.fx(r,a,v,tsim-1)      = kv.l(r,a,v,tsim-1)       ;
pk.fx(r,a,v,tsim-1)      = pk.l(r,a,v,tsim-1)       ;
px.fx(r,a,tsim-1)        = px.l(r,a,tsim-1)         ;
pp.fx(r,a,tsim-1)        = pp.l(r,a,tsim-1)         ;
xp.fx(r,a,tsim-1)        = xp.l(r,a,tsim-1)         ;
pfd.fx(r,fd,tsim-1)      = pfd.l(r,fd,tsim-1)       ;
pdt.fx(r,i,tsim-1)       = pdt.l(r,i,tsim-1)        ;
pe.fx(r,i,rp,tsim-1)     = pe.l(r,i,rp,tsim-1)      ;
pwe.fx(r,i,rp,tsim-1)    = pwe.l(r,i,rp,tsim-1)     ;
pwm.fx(r,i,rp,tsim-1)    = pwm.l(r,i,rp,tsim-1)     ;
pwmg.fx(r,i,rp,tsim-1)   = pwmg.l(r,i,rp,tsim-1)    ;
rgdppc.fx(r,tsim-1)      = rgdppc.l(r,tsim-1)       ;
xfd.fx(r,fd,tsim-1)      = xfd.l(r,fd,tsim-1)      ;
lambdal.fx(r,l,a,tsim-1) = lambdal.l(r,l,a,tsim-1)  ;
urbPrem.fx(r,l,tsim-1)   = urbPrem.l(r,l,tsim-1)    ;
lsz.fx(r,l,z,tsim-1)     = lsz.l(r,l,z,tsim-1)      ;
uez.fx(r,l,z,tsim-1)     = uez.l(r,l,z,tsim-1)      ;
ls.fx(r,l,tsim-1)        = ls.l(r,l,tsim-1)         ;
ptmg.fx(img,tsim-1)      = ptmg.l(img,tsim-1)       ;
xnrf.fx(r,a,tsim-1)      = xnrf.l(r,a,tsim-1)       ;
pnrf.fx(r,a,tsim-1)      = pnrf.l(r,a,tsim-1)       ;
pgdpmp.fx(r,tsim-1)      = pgdpmp.l(r,tsim-1)       ;
pw.fx(a,tsim-1)          = pw.l(a,tsim-1)           ;

* [OECD-ENV]: add-ons

PI0_xc.fx(r,h,tsim-1)    = PI0_xc.l(r,h,tsim-1)     ;
PI0_xa.fx(r,tsim-1)      = PI0_xa.l(r,tsim-1)       ;
xat.fx(r,i,tsim-1)       = xat.l(r,i,tsim-1)        ;
xa.fx(r,i,aa,tsim-1)     = xa.l(r,i,aa,tsim-1)      ;
pat.fx(r,i,tsim-1)       = pat.l(r,i,tsim-1)        ;
pa.fx(r,i,aa,tsim-1)     = pa.l(r,i,aa,tsim-1)      ;
xw.fx(r,i,rp,tsim-1)     = xw.l(r,i,rp,tsim-1)      ;
pe.fx(r,i,rp,tsim-1)     = pe.l(r,i,rp,tsim-1)      ;
LFPR.fx(r,l,z,tsim-1)    = LFPR.l(r,l,z,tsim-1)     ;
UNR.fx(r,l,z,tsim-1)     = UNR.l(r,l,z,tsim-1)      ;
popWA.fx(r,l,z,tsim-1)   = popWA.l(r,l,z,tsim-1)    ;
xs.fx(r,i,tsim-1)		 = xs.l(r,i,tsim-1)			;

lambdak.fx(r,a,v,tsim-1) $ (not tota(a)) = lambdak.l(r,a,v,tsim-1) ;
lambdal.fx(r,l,a,tsim-1) $ (not tota(a)) = lambdal.l(r,l,a,tsim-1) ;
TFP_xpx.fx(r,a,v,tsim-1) $ (not tota(a)) = TFP_xpx.l(r,a,v,tsim-1) ;
TFP_xpv.fx(r,a,v,tsim-1) $ (not tota(a)) = TFP_xpv.l(r,a,v,tsim-1) ;
TFP_xs.fx(r,i,tsim-1)    = TFP_xs.l(r,i,tsim-1) ;

xpow.fx(r,elyi,tsim-1) $ ifcal= xpow.l(r,elyi,tsim-1);

xpFlagT(r,a,tsim) = xpFlag(r,a) ;

$iftheni.RD "%ifRD_MODULE%" == "ON"
   rd.fx(r,tt)$(years(tt) le years(tsim-1)) = rd.l(r,tt) ;
   kn.fx(r,tt)$(years(tt) le years(tsim-1)) = kn.l(r,tt) ;
$endif.RD
