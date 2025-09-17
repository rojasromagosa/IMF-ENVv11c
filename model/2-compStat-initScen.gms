$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file    : "%ModelDir%\2-compStat-initScen.gms"
	purpose      : Exogenous assumptions dynamic baseline
					Only for dynamic calibration mode
	Created from : "compScen.gms" by Dominique van der Mensbrugghe
					for ENVISAGE model.
					+ add-ons by Jean Chateau for OECD-ENV model.
	Created date :
	called by    : %ModelDir%\compStat.gms
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/2-compStat-initScen.gms $
	last changed revision: $Rev: 518 $
	last changed date    : $Date:: 2024-02-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*  Initialize scenario variables before starting

popT(r,tranche,t)   = 0 ;
rgdppcT(r,t)        = 0 ;
gl.l(r,t)           = 0 ;
glMltShft(r,l,a,t)	= 1 ;
glAddShft(r,l,a,t)  = 0 ;
aeei(r,e,a,v,t)     = 0 ;
aeeic(r,e,k,h,t)    = 0 ;
yexo(r,a,v,t)       = 0 ;
tteff(r,i,rp,t)     = 0 ;
gtLab.l(r,t)        = 0 ;
glabT(r,l,t)        = 0 ;
lfpr_envisage(r,l,tranche,t)  = 0 ;
g_io(r,i,a,t)       = 0 ;

Parameters
   popScen(scen,r,tranche,tt)
   gdpScen(mod,ssp,var,r,tt) ;

popScen(scen,r,tranche,tt) = 0 ;
gdpScen(mod,ssp,var,r,tt)  = 0 ;

* OECD-ENV: default assumptions for new parameters

g_xpx(r,a,v,t)    = 0 ;
g_xs(r,i,t)      = 0 ;
g_fp(r,a,t)      = 0 ;
g_kt(r,a,v,t)    = 0 ;
g_natr(r,a,t)    = 0 ;
g_nrf(r,a,v,t)   = 0 ;
popWA.l(r,l,z,t) = 0 ;
UNR.l(r,l,z,t)   = 0 ;
LFPR.l(r,l,z,t)  = 0 ;
ETPT(r,l,z,t)    = 0 ;

