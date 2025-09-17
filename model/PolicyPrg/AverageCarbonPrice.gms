$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "%PolicyPrgDir%\AverageCarbonPrice.gms"
   purpose     :  Carbon price calculations
   created date: 2021-05-06
   created by  : Jean Chateau
   called by   : %ModelDir%\10-PostSimInstructions.gms
				 ResumeOutput.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/AverageCarbonPrice.gms $
   last changed revision: $Rev: 331 $
   last changed date    : $Date: 2023-06-15 09:52:13 +0200 (Thu, 15 Jun 2023) $
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
							%1 = {t,tsim}
				[EditJean]: TBU with IfArmFlag > 0
--------------------------------------------------------------------------------
$OffText

$OnDotL

* Average carbon price on all GHGs and sector, EmiUse

EffectiveCarbonPrice(r,i,aa,%1)
    $ sum((EmiUse,EmSingle) $ (emi0(r,EmSingle,EmiUse,aa) and mapiEmi(i,EmiUse)), m_true4(emi,r,EmSingle,EmiUse,aa,%1))
    =  {m_Permis(r,i,aa,%1) * m_true3t(xa,r,i,aa,%1)
        / sum((EmiUse,EmSingle) $ (emi0(r,EmSingle,EmiUse,aa) and mapiEmi(i,EmiUse)), m_true4(emi,r,EmSingle,EmiUse,aa,%1) )
       } $ {NOT IfArmFlag}
    ;

* Average carbon price on all controlled / taxed sources --> part

AverageCarbonPrice(r,i,aa,%1)
    $ sum((EmiUse,EmSingle)$ (emi0(r,EmSingle,EmiUse,aa) and mapiEmi(i,EmiUse)), m_EffEmi(r,EmSingle,EmiUse,aa,%1))
    =  {m_Permis(r,i,aa,%1) * m_true3t(xa,r,i,aa,%1)
        / sum((EmiUse,EmSingle)$ (emi0(r,EmSingle,EmiUse,aa) and mapiEmi(i,EmiUse)), m_EffEmi(r,EmSingle,EmiUse,aa,%1))
       } $ {NOT IfArmFlag}
    ;

*	Factor Carbon taxes

EffectiveCarbonPrice(r,fp,a,%1)
    $  sum((EmiFp,EmSingle) $ (emi0(r,EmSingle,EmiFp,a) and mapFpEmi(fp,EmiFp)), m_true4(emi,r,EmSingle,EmiFp,a,%1))
    =  m_Permisfp(r,fp,a,%1)
    * (  sum(v,m_true3vt(kv,r,a,v,%1)) $ {cap(fp) and kFlag(r,a)}
       + [m_true2t(land,r,a,%1) ] $ {lnd(fp) and landFlag(r,a)}
      )
    / sum((EmiFp,EmSingle) $ (emi0(r,EmSingle,EmiFp,a) and mapFpEmi(fp,EmiFp)),  m_true4(emi,r,EmSingle,EmiFp,a,%1))
    ;
AverageCarbonPrice(r,fp,a,%1)
    $  sum((EmiFp,EmSingle) $ (emi0(r,EmSingle,EmiFp,a) and mapFpEmi(fp,EmiFp)), m_EffEmi(r,EmSingle,EmiFp,a,%1) )
    =  m_Permisfp(r,fp,a,%1)
    * (  sum(v,m_true3vt(kv,r,a,v,%1)) $ {cap(fp) and kFlag(r,a)}
       + [m_true2t(land,r,a,%1) ] $ {lnd(fp) and landFlag(r,a)}
      )
    / sum((EmiFp,EmSingle)  $ (emi0(r,EmSingle,EmiFp,a) and mapFpEmi(fp,EmiFp)), m_EffEmi(r,EmSingle,EmiFp,a,%1) )
    ;

*	Process

EffectiveCarbonPrice(r,"ptax",a,%1)
    $ sum((emiact,EmSingle)$ (emi0(r,EmSingle,emiact,a)), m_true4(emi,r,EmSingle,emiact,a,%1))
    = [	  {  m_Permisact(r,a,%1) * m_true2t(xp,r,a,%1) } $ {NOT ghgFlag(r,a)}
        + { sum((EmSingle,emiact), m_EmiPrice(r,EmSingle,emiact,a,%1) * m_true4(emi,r,EmSingle,emiact,a,%1))} $ {ghgFlag(r,a)}
      ] / sum((emiact,EmSingle)$ (emi0(r,EmSingle,emiact,a)), m_true4(emi,r,EmSingle,emiact,a,%1))
    ;
AverageCarbonPrice(r,"ptax",a,%1)
    $ sum((emiact,EmSingle)$ (emi0(r,EmSingle,emiact,a)), m_EffEmi(r,EmSingle,emiact,a,%1))
    = [(m_Permisact(r,a,%1) * m_true2t(xp,r,a,%1)) $ {NOT ghgFlag(r,a)}
        + sum((EmSingle,emiact), m_EmiPrice(r,EmSingle,emiact,a,%1) * m_true4(emi,r,EmSingle,emiact,a,%1)) $ {ghgFlag(r,a)}
      ] / sum((emiact,EmSingle)$ (emi0(r,EmSingle,emiact,a)), m_EffEmi(r,EmSingle,emiact,a,%1))
    ;


*	Total

EffectiveCarbonPrice(r,"tot",aa,%1)
    = sum((EmiUse,em) $ emi0(r,em,EmiUse,aa),  m_true4(emi,r,em,EmiUse,aa,%1)) $ {NOT IfArmFlag}
    + sum((EmiFp,em)  $   emi0(r,em,EmiFp,aa), m_true4(emi,r,em,EmiFp,aa,%1))
    + sum((emiact,em) $ emi0(r,em,emiact,aa),  m_true4(emi,r,em,emiact,aa,%1))
    ;
AverageCarbonPrice(r,"tot",aa,%1)
    = sum((EmiUse,em) $ emi0(r,em,EmiUse,aa), m_EffEmi(r,em,EmiUse,aa,%1))$ {NOT IfArmFlag}
    + sum((EmiFp,em)  $  emi0(r,em,EmiFp,aa), m_EffEmi(r,em,EmiFp,aa,%1) )
    + sum((emiact,em) $ emi0(r,em,emiact,aa), m_EffEmi(r,em,emiact,aa,%1));
    ;

risworkT(r,a,%1)
    = sum(i$xaFlag(r,i,a),m_Permis(r,i,a,%1) * m_true3t(xa,r,i,a,%1))
    + sum(fp,m_Permisfp(r,fp,a,%1)
        * ( sum(v,m_true3vt(kv,r,a,v,%1)) $ {cap(fp) and kFlag(r,a)}
        +   [m_true2t(land,r,a,%1) ] $ {lnd(fp) and landFlag(r,a)})
         )
    + {m_Permisact(r,a,%1) * m_true2t(xp,r,a,%1)} $ {NOT ghgFlag(r,a)}
	+ { sum((EmSingle,emiact), m_EmiPrice(r,EmSingle,emiact,a,%1) * m_true4(emi,r,EmSingle,emiact,a,%1))} $ {ghgFlag(r,a)}
    ;

* [EditJean]: TBU if emiact for fd

risworkT(r,fd,%1)
    = sum(i $ xaFlag(r,i,fd), m_Permis(r,i,fd,%1) * m_true3t(xa,r,i,fd,%1))  ;

EffectiveCarbonPrice(r,"tot",aa,%1) $ EffectiveCarbonPrice(r,"tot",aa,%1)
    = risworkT(r,aa,%1) / EffectiveCarbonPrice(r,"tot",aa,%1) ;
AverageCarbonPrice(r,"tot",aa,%1) $ AverageCarbonPrice(r,"tot",aa,%1)
    = risworkT(r,aa,%1) / AverageCarbonPrice(r,"tot",aa,%1) ;

*	Convert carbon price in"%YearUSDCT%" USD

$iftheni not "%simtype%" == "COMPSTAT"
IF(IfDyn,
    EffectiveCarbonPrice(r,is,aa,%1)
        = EffectiveCarbonPrice(r,is,aa,%1) * m_convCtax ;
    AverageCarbonPrice(r,is,aa,%1)
        = AverageCarbonPrice(r,is,aa,%1) * m_convCtax ;
    EMITAXT(r,EmSingle,%1) = emiTax.l(r,EmSingle,%1) * m_convCtax ;
) ;
$endIf

$OffDotL
