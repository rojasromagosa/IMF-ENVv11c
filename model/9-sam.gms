$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%ModelDir%\9-sam.gms"
   purpose     :  Calculate the SAM --> sam(r,is,js,t)
   created date: -
   created by  : Dominique van der Mensbrugghe
   Modified by : Jean Chateau
                add %1 = {t,tsim} and simmplify with macro
   called by   : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/9-sam.gms $
   last changed revision: $Rev: 517 $
   last changed date    : $Date:: 2024-02-24#$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$onDotL
sam(r,i,aa,%1)
    = {  gammaeda(r,i,aa) * m_true2(pat,r,i,%1) * m_true3t(xa,r,i,aa,%1)
      } $ {NOT IfArmFlag}
    + {  gammaedd(r,i,aa) * m_true2(pdt,r,i,%1) * m_true3(xd,r,i,aa,%1)
       + gammaedm(r,i,aa) * m_true2(pmt,r,i,%1) * m_true3(xm,r,i,aa,%1)
      } $ IfArmFlag
    ;

sam(r,"itax",aa,%1)
    = sum(i,
     {paTax.l(r,i,aa,%1) * gammaeda(r,i,aa) * m_true2(pat,r,i,%1) * m_true3t(xa,r,i,aa,%1)
     } $ {NOT IfArmFlag}
   + {pdTax.l(r,i,aa,%1) * gammaedd(r,i,aa) * m_true2(pdt,r,i,%1) * m_true3(xd,r,i,aa,%1)
   +  pmTax.l(r,i,aa,%1) * gammaedm(r,i,aa) * m_true2(pmt,r,i,%1) * m_true3(xm,r,i,aa,%1)
     } $ IfArmFlag
   ) ;
sam(r,"itax",fd,%1) = sam(r,"itax",fd,%1) ;

sam(r,"ctax",aa,%1) = sum(i,
      {   m_Permis(r,i,aa,%1)  * m_true3t(xa,r,i,aa,%1) } $ {NOT IfArmFlag}
   +  {   m_Permisd(r,i,aa,%1) * m_true3(xd,r,i,aa,%1)
        + m_Permism(r,i,aa,%1) * m_true3(xm,r,i,aa,%1)
      } $ IfArmFlag
   ) ;

* [TBD] --> Pollution Tax

sam(r,"ctax",a,%1) $ xpFlag(r,a)
    = sam(r,"ctax",a,%1)
    + sum((cap,v) $ kFlag(r,a), m_Permisfp(r,cap,a,%1) * m_true3vt(kv,r,a,v,%1))
    + sum(lnd $ landFlag(r,a),  m_Permisfp(r,lnd,a,%1) * m_true2t(land,r,a,%1) )
    + sum(v, m_Permisact(r,a,%1) * m_true3vt(xpv,r,a,v,%1) ) $ {NOT ghgFlag(r,a)}
    + sum((emiact,EmSingle) $ emi0(r,EmSingle,emiact,a),
        m_EmiPrice(r,EmSingle,emiact,a,%1) * m_true4(emi,r,EmSingle,emiact,a,%1)
        ) $ {ghgFlag(r,a)}
    ;

sam(r,"ctax",aa,%1) = sam(r,"ctax",aa,%1) ;

sam(r,"ptax",a,%1)
    = ptax.l(r,a,%1) * [m_true2(px,r,a,%1) + pim.l(r,a,%1)] * m_true2t(xp,r,a,%1)
    + sum(v, uctax.l(r,a,v,%1) * m_true3v(uc,r,a,v,%1) * m_true3vt(xpv,r,a,v,%1))
    ;

sam(r,l,a,%1) = m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1);
loop(cap,
    sam(r,cap,a,%1)
        = sum(v, m_true3v(pk,r,a,v,%1) * m_true3vt(kv,r,a,v,%1))
        + pim.l(r,a,%1)*m_true2t(xp,r,a,%1) ;
) ;
loop(lnd, sam(r,lnd,a,%1) = m_true2(pland,r,a,%1) * m_true2t(land,r,a,%1) ; ) ;
loop(nrs, sam(r,nrs,a,%1) = m_true2(pnrf,r,a,%1)  * m_true2(xnrf,r,a,%1) ; ) ;
loop(wat, sam(r,wat,a,%1) = m_true2(ph2o,r,a,%1)  * m_true2(h2o,r,a,%1)  ; ) ;

sam(r,"vtax",a,%1)
    = sum(l, Taxfp.l(r,a,l,%1) * m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1) )
    + sum((v,cap), adjKTaxfp(r,cap,a,v) * Taxfp.l(r,a,cap,%1)  * m_true3v(pk,r,a,v,%1)  * m_true3vt(kv,r,a,v,%1) )
    + sum(lnd,Taxfp.l(r,a,lnd,%1)) * m_true2(pland,r,a,%1)  * m_true2t(land,r,a,%1)
    + sum(nrs,Taxfp.l(r,a,nrs,%1)) * m_true2(pnrf,r,a,%1)   * m_true2(xnrf,r,a,%1)
    + sum(wat,Taxfp.l(r,a,wat,%1)) * m_true2(ph2o,r,a,%1)   * m_true2(h2o,r,a,%1)
    ;
sam(r,"vsub",a,%1)
    = sum(l, Subfp.l(r,a,l,%1) * m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1) )
    + sum((v,cap), adjKSubfp(r,cap,a,v) * Subfp.l(r,a,cap,%1)  * m_true3v(pk,r,a,v,%1)  * m_true3vt(kv,r,a,v,%1) )
    + sum(lnd,Subfp.l(r,a,lnd,%1)) * m_true2(pland,r,a,%1)  * m_true2t(land,r,a,%1)
    + sum(nrs,Subfp.l(r,a,nrs,%1)) * m_true2(pnrf,r,a,%1)   * m_true2(xnrf,r,a,%1)
    + sum(wat,Subfp.l(r,a,wat,%1)) * m_true2(ph2o,r,a,%1)   * m_true2(h2o,r,a,%1)
    ;
loop(gov, sam(r,gov,gy,%1) = m_true2(ygov,r,gy,%1) ; ) ;

* [EditJean]: pourquoi on met ca output de i produit par a dans la sam ?

sam(r,a,i,%1) = m_true3(p,r,a,i,%1) * m_true3t(x,r,a,i,%1) ;

loop(h,

   sam(r,h,l,%1)
    = (1 - kappal.l(r,l,%1))
    * sum(a, m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1))
    - sum(rp, m_true3(remit,rp,l,r,%1) ) ;
   sam(r,"dtax",l,%1)
    = kappal.l(r,l,%1) * sum(a, m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1)) ;
   sam(r,"bop",l,%1) = sum(rp, m_true3(remit,rp,l,r,%1)) ;
   sam(r,h,"bop",%1) = sum((rp,l), m_true3(remit,r,l,rp,%1)) ;

    loop(cap,
        sam(r,h,cap,%1)
            = (1 - kappak.l(r,%1)) * m_PROFITS(r,%1)
            - m_true1(yqtf,r,%1)
            + (1 - profitTax(r,cap,%1)) * sum((a,v) $ (ifExokv(r,a,v) eq 2), pkpShadowPrice(r,a,v,%1) * m_true3vt(kv,r,a,v,%1))
            ;
        sam(r,"dtax",cap,%1)
            = kappak.l(r,%1) * m_PROFITS(r,%1)
            + profitTax(r,cap,%1) * sum((a,v) $ (ifExokv(r,a,v) eq 2), pkpShadowPrice(r,a,v,%1) * m_true3vt(kv,r,a,v,%1))
            ;
        sam(r,"bop",cap,%1)   = m_true1(yqtf,r,%1) ;
        sam(r,h,"bop",%1)     = sam(r,h,"bop",%1) + m_true1(yqht,r,%1) ;
        sam(r,"deprY",cap,%1) = m_true1(deprY,r,%1) ;
   ) ;

    loop(lnd,
      sam(r,h,lnd,%1)
        = (1 - kappat.l(r,%1))
        * sum(a, m_true2(pland,r,a,%1) * m_true2t(land,r,a,%1)) ;
      sam(r,"dtax",lnd,%1)
        = kappat.l(r,%1)
        * sum(a, m_true2(pland,r,a,%1) * m_true2t(land,r,a,%1)) ;
   ) ;

   loop(nrs,
     sam(r,h,nrs,%1)
        = (1 - kappan.l(r,%1))
        * sum(a, m_true2(pnrf,r,a,%1) * m_true2(xnrf,r,a,%1) ) ;
     sam(r,"dtax",nrs,%1)
        = kappan.l(r,%1)
        * sum(a, m_true2(pnrf,r,a,%1) * m_true2(xnrf,r,a,%1) ) ;
   ) ;

   loop(wat,
     sam(r,h,wat,%1)
        = (1 - kappaw.l(r,%1))
        * sum(a, m_true2(ph2o,r,a,%1) * m_true2(h2o,r,a,%1)) ;
     sam(r,"dtax",wat,%1)
        = kappaw.l(r,%1)
        * sum(a, m_true2(ph2o,r,a,%1) * m_true2(h2o,r,a,%1)) ;
    ) ;

) ;

loop(h,
    sam(r,"dtax",h,%1) = kappah.l(r,%1) * m_true1(yh,r,%1) - trg.l(r,%1) ;
    loop(inv, sam(r,inv,h,%1) = m_true2(savh,r,h,%1) ; ) ;
) ;

loop(gov,
    loop(inv, sam(r,inv,gov,%1) = savg.l(r,%1) ; ) ;
    sam(r,r_d,gov,%1)   = m_true2(yfd,r,r_d,%1) ;
    sam(r,gov,"bop",%1) = sum(em,emiQuotaY.l(r,em,%1)) ;
) ;

loop(inv,
    sam(r,inv,"deprY",%1) = m_true1(deprY,r,%1) ;
    sam(r,inv,"bop",%1)   = pwsav.l(%1) * savf.l(r,%1) ;
) ;

loop(i,
   sam(r,i,"tmg",%1)  = m_true2(pdt,r,i,%1) * m_true2(xtt,r,i,%1) ;

   IF(ifaggTrade,

      sam(r,i,"trd",%1)
        = sum(rp, m_true3(pwe,r,i,rp,%1) * m_true3(xw,r,i,rp,%1) ) ;
      sam(r,"trd",i,%1)
        = sum(rp, m_true3(pwe,rp,i,r,%1) * m_true3(xw,rp,i,r,%1)) ;

   else

      sam(r,i,d,%1) = m_true3(xw,r,i,d,%1) * m_true3(pwe,r,i,d,%1) ;
      sam(r,s,i,%1) = m_true3(xw,s,i,r,%1) * m_true3(pwe,s,i,r,%1) ;

   ) ;

   sam(r,"tmg",i,%1)
        = sum(s, m_true3(xw,s,i,r,%1)
        * [m_true3(pwm,s,i,r,%1) * lambdaw(s,i,r,%1) - m_true3(pwe,s,i,r,%1)] ) ;

   sam(r,"mtax",i,%1)
        = sum(s, lambdaw(s,i,r,%1) * m_true3(xw,s,i,r,%1)
            * [m_true3(pdm,s,i,r,%1)- m_true3(pwm,s,i,r,%1)]) ;

    sam(r,"etax",i,%1)
        = sum(d, m_true3(xw,r,i,d,%1)
                        * [m_true3(pwe,r,i,d,%1) - m_true3(pe,r,i,d,%1)] ) ;
) ;

sam(r, "tmg", "bop", %1)
    = sum(i, m_true2(pdt,r,i,%1) * m_true2(xtt,r,i,%1) )
    - sum((i,s), m_true3(xw,s,i,r,%1)
        * [lambdaw(s,i,r,%1) * m_true3(pwm,s,i,r,%1) - m_true3(pwe,s,i,r,%1)]
        ) ;

IF(ifaggTrade,

    sam(r, "trd", "bop", %1)
        = sum((i,d), m_true3(pwe,r,i,d,%1) * m_true3(xw,r,i,d,%1)) ;
    sam(r, "bop", "trd", %1)
        = sum((i,s), m_true3(pwe,s,i,r,%1) * m_true3(xw,s,i,r,%1)) ;

else

    sam(r, d, "bop", %1)
            = sum(i, m_true3(pwe,r,i,d,%1) * m_true3(xw,r,i,d,%1)) ;
    sam(r, "bop", s, %1)
            = sum(i, m_true3(pwe,s,i,r,%1) * m_true3(xw,s,i,r,%1)) ;

) ;

$offDotL

* [OECD-ENV]: add common auxilliary/output variables: XPT, XAPT,...

$batinclude "%ModelDir%\91-Common_Auxilliary.gms" "tsim"

* [OECD-ENV]: Project specific output [Optional]

$IF EXIST "%ResOutFile%" $batinclude "%ResOutFile%" "9-sam"

* [OECD-ENV]: Fill the informations of file SimName%_declining_sectors.txt

$IF EXIST "%DebugDir%\Fill_Verification_files.gms" $include "%DebugDir%\Fill_Verification_files.gms"

