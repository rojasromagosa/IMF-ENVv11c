$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy procedure
   name        : "%PolicyPrgDir%\Build_EmissionCaps.gms"
   purpose     : Build coalition cap inside the time-loop
                 emiCap.fx(rq,em,t) or emiCapFull.fx(rq,t)
                 from regional cap: EmiRCap(r,em,t)
   created date: 24 May 2021
   created by  : Jean Chateau
   called by   : %PolicyFile%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/Build_EmissionCaps.gms $
   last changed revision: $Rev: 326 $
   last changed date    : $Date:: 2023-06-12 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

    Memo:
        IfCap(rq)       should be positive
        emFlag(r,em)    should be defined
        "part" should have been defined

        IfLoadEmiTgt should be set to 0 or 1

    Options:
        the target is defined from a given simulation IfLoadEmiTgt eq 1
        or from current simulation (what does it means) and
        then apply to EmiTimeProfile(r,em,tsim) ?
$OffText

$OnDotl

* Before the policy -> emiCap0 & emiCapFull0


IF(tsim.val eq %YearPolicyStart%,

* Individual caps in %YearAntePolicy%,
*   for activated country, gas : emFlag(r,EmSingle)

    EmiRCap(r,EmSingle,tsim-1) $ emFlag(r,EmSingle)
        = { (1 - IfLoadEmiTgt) * m_true2(emiTot,r,EmSingle,tsim-1)
               + IfLoadEmiTgt  * m_true2b(emiTot,ref,r,EmSingle,tsim-1)
          } $ { sum(mapr(rq,r) $ IfCap(rq), IfCap(rq)) eq 1 }
        + { sum((EmiSourceAct,aa),
             (1 - IfLoadEmiTgt) * m_EffEmi(emi,r,EmSingle,EmiSourceAct,aa,tsim-1)
                + IfLoadEmiTgt  * m_EffEmiRef(r,ref,r,EmSingle,EmiSourceAct,aa,tsim-1) )
          } $ { sum(mapr(rq,r) $ IfCap(rq), IfCap(rq)) eq 2 }
        ;

* Initial Cap for "rq" = New Scale

    emiCap0(rq,EmSingle) $ IfCap(rq)
        = sum(mapr(rq,r) $ emFlag(r,EmSingle), EmiRCap(r,EmSingle,tsim-1)) ;

    emiCapFull0(rq) $ IfCap(rq) = sum(EmSingle, emiCap0(rq,EmSingle)) ;

) ;

*	All  years after %YearAntePolicy: Individual active caps

EmiRCap(r,EmSingle,tsim) $ emFlag(r,EmSingle)
    = { (1 - IfLoadEmiTgt) * m_true2(emiTot,r,EmSingle,tsim)
       + IfLoadEmiTgt  * m_true2b(emiTot,ref,r,EmSingle,tsim)
      } $ { sum(mapr(rq,r) $ IfCap(rq), IfCap(rq)) eq 1 }
    + {sum((EmiSourceAct,aa),
        * [ (1 - IfLoadEmiTgt) * m_EffEmi(r,EmSingle,EmiSourceAct,aa,tsim)
           + IfLoadEmiTgt  * m_EffEmiRef(r,ref,EmSingle,EmiSourceAct,aa,tsim)])
      } $ { sum(mapr(rq,r) $ IfCap(rq), IfCap(rq)) eq 2 }
    ;

LOOP( rq $ IfCap(rq),

* single gas caps (normalized)

    emiCap.fx(rq,EmSingle,tsim) $ emiCap0(rq,EmSingle)
        = sum(mapr(rq,r), EmiRCap(r,EmSingle,tsim))
        / emiCap0(rq,EmSingle) ;

* multi-gas caps (normalized)

    emiCapFull.fx(rq,tsim)
        = sum(EmSingle, m_true2(emiCap,rq,EmSingle,tsim)) / emiCapFull0(rq) ;

) ;

$OffDotl


