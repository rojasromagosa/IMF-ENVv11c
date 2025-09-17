$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%PolicyPrgDir%\Build_NDCCaps"
   purpose     : Build NDC Caps for acting coalitions/countries
   created date: 2022-June-27
   created by  : Jean Chateau
   called by   : %iFilesDir%\Policy_NDC.gms or "%PolicyPrgDir%\Policy_NDC.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/Build_NDCCaps.gms $
   last changed revision: $Rev: 266 $
   last changed date    : $Date: 2023-03-29 12:48:42 +0200 (Wed, 29 Mar 2023) $
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Memo:
        IfCap should be positive
        IfLoadEmiTgt = 1 --> target is based on reference emissions
        part should have been defined in the case IfCap = 2
        emFlag(r,EmSingle) should be positive

   [EditJEan]: je ne suis pas bien certain de l'int�r�t du cas with a reference simulation
--------------------------------------------------------------------------------
$OffText

$OnDotl

*       regional cap before the policy starts (based on BAU)

* convert condition IfCap(rq) to condition on regions for singleton coalition
* --> sum(mapr(rq,r), IfCap(rq))

EmiRCap(r,EmSingle,"%YearAntePolicy%") $ emFlag(r,EmSingle)
    = { m_true2b(emiTot,bau,r,EmSingle,"%YearAntePolicy%")
      } $ { sum(mapr(rq,r), IfCap(rq)) eq 1 }
    + { sum((EmiSourceAct,aa),
        m_EffEmiRef(r,bau,EmSingle,EmiSourceAct,aa,"%YearPolicyStart%"))
      } $ { sum(mapr(rq,r), IfCap(rq)) eq 2 }
    ;

* Single gas cap

emiCap0(rq,EmSingle) $ IfCap(rq)
    = sum(mapr(rq,r) $ emFlag(r,EmSingle),
        EmiRCap(r,EmSingle,"%YearAntePolicy%")) ;

* Multi-gas cap

emiCapFull0(rq) $ IfCap(rq) = sum(EmSingle, emiCap0(rq,EmSingle)) ;

*   Case with a reference simulation: regional cap (from YearPolicyStart)

IF(IfLoadEmiTgt,

    EmiRCap(r,EmSingle,t)
        $(emFlag(r,EmSingle) and between3(t,"%YearPolicyStart%","%YrFinTgt%"))
        = { m_true2b(emiTot,ref,r,EmSingle,t)
          } $ { sum(mapr(rq,r) $ IfCap(rq), IfCap(rq)) eq 1 }
        + { sum((EmiSourceAct,aa),
            m_EffEmiRef(r,bau,EmSingle,EmiSourceAct,aa,t))
          } $ { sum(mapr(rq,r) $ IfCap(rq), IfCap(rq)) eq 2 }    ;

) ;

*   Build the rq-coalition cap : emiCapFull.fx

rawork(rq) = 0 ;

LOOP(rq $ IfCap(rq),

    emiCapFull.fx(rq,"%YearAntePolicy%") = emiCapFull0(rq) ;

    IF(IfLoadEmiTgt,

* Case with a reference simulation where NDC already been declared

        emiCapFull.fx(rq,t)
            $ (IfCap(rq) and between3(t,"%YearPolicyStart%","%YrFinTgt%"))
            = sum(mapr(rq,r),
                sum(EmSingle  $ emFlag(r,EmSingle) , EmiRCap(r,EmSingle,t) ) ) ;

    ELSE

* Case with no reference simulation

* Define NDC target for %YearNDC% (ie 2030)

        emiCapFull.fx(rq,"%YearNDC%") $ IfCap(rq)
            = sum(mapr(rq,r), NDC2030(r,"GHG_Lulucf")) * cScale ;

* Linear interpolation from %YearPolicyStart" to %YearNDC%

        m_InterpLinear(emiCapFull.l,'rq',tsim,%YearAntePolicy%,%YearNDC%)

* Annual reduction after %YearNDC%

        rawork(rq) $ IfCap(rq)
            = [   emiCapFull.l(rq,"%YearNDC%")
                / emiCapFull.l(rq,"%YearPolicyStart%")
              ]**[1 / (%YearNDC% - %YearPolicyStart%)] -1 ;

        LOOP( t $ between2(t,"%YearNDC%","%YearEndofSim%"),
            emiCapFull.l(rq,t) $ rawork(rq)
                = emiCapFull.l(rq,t-1) * ( 1 + rawork(rq) ) ;
        ) ;
    ) ;

) ;

* clear intermediate values

emiCapFull.fx(rq,"%YearAntePolicy%")   = 0 ;
EmiRCap(r,EmSingle,"%YearAntePolicy%") = 0 ;

* Normalization and Fix Target

emiCapFull.fx(rq,t) $ IfCap(rq) = emiCapFull.l(rq,t) / emiCapFull0(rq) ;
emiCapFull.fx(rq,t) $ (NOT IfCap(rq)) =  0 ;

***HRR: was 1 before
IF(0,

    emiCapFull.fx(rq,t) $ IfCap(rq)
        = emiCapFull.l(rq,t) * emiCapFull0(rq) / cScale ;
    EmiRCap(r,EmSingle,t) $ emFlag(r,EmSingle) = emiRCap(r,EmSingle,t) / cScale;

    Execute_unload "%cFile%_Declaration_NDC_Caps.gdx",  NDC2030, IfCap, emFlag
        part, EmiRCap, emiCapFull, emiCapFull0, emiCap, emiCap0 ; 
***HRR, NDCCW;

    emiCapFull.fx(rq,t) $ IfCap(rq) = emiCapFull.l(rq,t) *  cScale / emiCapFull0(rq)  ;
    EmiRCap(r,EmSingle,t) $ emFlag(r,EmSingle) = emiRCap(r,EmSingle,t) * cScale ;
) ;

$OffDotl
