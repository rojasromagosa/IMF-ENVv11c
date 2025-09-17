$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy procedure
   name        : "%PolicyPrgDir%\emiCap0.gms"
   purpose     : Build coalition cap before time-loop
                 emiCap.fx(rq,em,t) or emiCapFull.fx(rq,t)
                 from regional cap: EmiRCap(r,em,t)
   created date: 24 May 2021
   created by  : Jean Chateau
   called by   : %PolicyFile%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/emiCap0.gms $
   last changed revision: $Rev: 193 $
   last changed date    : $Date:: 2023-01-18 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

    Memo:
        IfCap(rq)       should be positive
        emFlag(r,em)    should be defined
        SingRQ(ra)      should be defined

    Value for rwork:
        - if = 1: then caps are defined on emitot
        - if = 2: then caps are defined on a set of controlled emissions
                 "part" is activated on the basis of global variables

$OffText

rwork(r) =  sum(mapr(SingRQ,r), IfCap(SingRQ)) ;

Display "IfCap: ", rwork;

LOOP( t $ between3(t,"%YearAntePolicy%","%YrFinTgt%"),

* Case 1: cap is calculated on all emission

    EmiRCap(r,EmSingle,t) $ (rwork(r) eq 1) = m_true2b(emiTot,bau,r,EmSingle,t);

* Case 2: cap is calculated on a set of controlled emissions

    part(r,%GhgTax%,%SrcTax%,AgentTax,t) $(rwork(r) eq 2) = 1 ;

    EmiRCap(r,EmSingle,t) $ (rwork(r) eq 2)
        = sum((%SrcTax%,AgentTax), part(r,EmSingle,%SrcTax%,AgentTax,t)
                 * m_true4b(emi,bau,r,EmSingle,%SrcTax%,AgentTax,t) ) ;

) ;

* reset part for %YearAntePolicy%

part(r,%GhgTax%,%SrcTax%,AgentTax,"%YearAntePolicy%") $(rwork(r) eq 2) = 0 ;

* Initial cap for corresponding singleton coalition "rq"

emiCap.fx(SingRQ,em,"%YearAntePolicy%")
    = sum(mapr(SingRQ,r), EmiRCap(r,em,"%YearAntePolicy%")) ;

* Scaling is based on %YearAntePolicy% and not %YearStart%

emiCap0(SingRQ,em) $ IfCap(SingRQ) = emiCap.l(SingRQ,em,"%YearAntePolicy%") ;

emiCapFull0(rq) $ IfCap(rq) = sum(EmSingle, emiCap0(rq,EmSingle)) ;


