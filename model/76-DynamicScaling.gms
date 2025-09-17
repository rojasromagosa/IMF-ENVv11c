$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   GAMS file    : "76-DynamicScaling.gms"
   purpose      : Adjust dynamically time-dependent scaling variables [OPTION]
   Created by   : Jean Chateau
   Created date : 16 Mai 2022
   called by    : "%ModelDir%\7-iterloop.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/76-DynamicScaling.gms $
   last changed revision:    $Rev: 20 $
   last changed date    :    $Date:: 2022-09-20 #$
   last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
    $batinclude arguments:
    %1 : current year for variant and previous year for dynamic calibration
--------------------------------------------------------------------------------
$OffText

$OnDotL

* Adjust sectoral scaling (no need to scale everything)

riswork(r,a)      = 0 ;
riswork(r,s_otra) = 1 ;

LOOP((r,a) $ (riswork(r,a) and xpFlag(r,a)),

    m_resc1t(xp,  a,0,tsim,%1)
    m_resc1t(lab1,a,0,tsim,%1)
    m_resc1t(nd1, a,0,tsim,%1)
    m_resc1vt(xpv,a,0,tsim,%1)
    m_resc1vt(xpx,a,0,tsim,%1)
    m_resc1vt(va ,a,0,tsim,%1)
    m_resc1vt(va1,a,0,tsim,%1)

    m_resc2t(ld,l,a,0,tsim,%1)
    m_resc2t(xa,i,a,0,tsim,%1)
    m_resc1t(k0,  a,0,tsim,%1)
    m_resc1vt(kv ,a,0,tsim,%1)
    m_resc1vt(ks ,a,0,tsim,%1)
    m_resc1vt(ksw,a,0,tsim,%1)
    m_resc1vt(kef,a,0,tsim,%1)
    m_resc1vt(kf ,a,0,tsim,%1)

    m_resc1vt(xnrg,a,0,tsim,%1)
    IF(powa(a),
        m_resc2t(x,a,elyi,0,tsim,%1)
    ) ;

* No need to be re-scaled

*    m_resc1vt(xnely,powa,0,tsim,%1)
*    m_resc1vt(xolg ,powa,0,tsim,%1)
*    m_resc2vt(xaNRG,powa,NRG,0,tsim,%1-1) [NOTDONE]
*    m_resc1t(xpow,elyi,0,tsim,%1)
*    m_resc1t(xat,elyi,0,tsim,%1)
*    m_resc1t(nd2,powa,0,tsim,%1)
*    m_resc1vt(va2,powa,0,tsim,%1s)

) ;

LOOP((r,pb) $ sum(powa $ (riswork(r,powa) and mappow(pb,powa)), 1),
    m_resc2t(xpb,pb,elyi,0,tsim,%1)
) ;

$OffDotl
