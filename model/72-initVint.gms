$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
	GAMS file    : "%ModelDir%\72-initVint.gms"
	purpose      : Initialize vintage for the first simulation year
	Created by   : 	Dominique van der Mensbrugghe for ENVISAGE
				  + modification by Jean Chateau for OECD-ENV
	Created date :
	called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
    $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/72-initVint.gms $
	last changed revision: $Rev: 391 $
	last changed date    : $Date:: 2023-09-08 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

loop((vOld, vNew),
    xpx.l(r,a,vNew,tsim)   = InitVintage * xpx.l(r,a,vOld,tsim) ;
    xghg.l(r,a,vNew,tsim)  = InitVintage * xghg.l(r,a,vOld,tsim) ;
    va.l(r,a,vNew,tsim)    = InitVintage * va.l(r,a,vOld,tsim) ;
    kef.l(r,a,vNew,tsim)   = InitVintage * kef.l(r,a,vOld,tsim) ;
    va1.l(r,a,vNew,tsim)   = InitVintage * va1.l(r,a,vOld,tsim) ;
    va2.l(r,a,vNew,tsim)   = InitVintage * va2.l(r,a,vOld,tsim) ;
    kf.l(r,a,vNew,tsim)    = InitVintage * kf.l(r,a,vOld,tsim) ;
    xnrg.l(r,a,vNew,tsim)  = InitVintage * xnrg.l(r,a,vOld,tsim) ;
    ksw.l(r,a,vNew,tsim)   = InitVintage * ksw.l(r,a,vOld,tsim) ;
    ks.l(r,a,vNew,tsim)    = InitVintage * ks.l(r,a,vOld,tsim) ;
    kv.l(r,a,vNew,tsim)    = InitVintage * kv.l(r,a,vOld,tsim) ;
    xpv.l(r,a,vNew,tsim)   = InitVintage * xpv.l(r,a,vOld,tsim) ;
    kxrat.l(r,a,vNew,tsim) = kxRat.l(r,a,vOld,tsim) ;
* [OECD-ENV]: IfNrgNest is now agent specific
    xnely.l(r,a,vNew,tsim)     $ IfNrgNest(r,a)
        = InitVintage * xnely.l(r,a,vOld,tsim) ;
    xolg.l(r,a,vNew,tsim)      $ IfNrgNest(r,a)
        = InitVintage * xolg.l(r,a,vOld,tsim) ;
    xaNRG.l(r,a,NRG,vNew,tsim) $ IfNrgNest(r,a)
        = InitVintage * xaNRG.l(r,a,NRG,vOld,tsim) ;
* [OECD-ENV]: add
    xoap.l(r,a,vNew,tsim)  = InitVintage * xoap.l(r,a,vOld,tsim) ;
) ;
