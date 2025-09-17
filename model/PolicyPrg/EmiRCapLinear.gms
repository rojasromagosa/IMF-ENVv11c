$OnText
    Some Linear time profiles: EmiTimeProfile(r,AllEmissions,tt)

Arguments
   %1     Final Target in %YrFinTgt%
   %2     intermediary target two and three step cases in %YrPhase1%
   %3     intermediary target three step cases in %YrPhase2%

$OffText

$setargs FinalTgt IntermTgt1 IntermTgt2

* Initialization: time profile in %YearAntePolicy%

EmiTimeProfile(r,em,"%YearAntePolicy%") = 1;

* Final Target

EmiTimeProfile(r,em,"%YrFinTgt%") = %FinalTgt% ;

* Intermediary targets

EmiTimeProfile(r,em,"%YrPhase1%") $(IfCapIntStep eq 1) = %IntermTgt1% ;
EmiTimeProfile(r,em,"%YrPhase2%") $(IfCapIntStep eq 2) = %IntermTgt2% ;


IF(IfCapIntStep eq 0,

    m_InterpLinear(EmiTimeProfile,'r,em',t,%YearAntePolicy%,%YrFinTgt%)

ELSEIF(IfCapIntStep eq 1),

    m_InterpLinear(EmiTimeProfile,'r,em',t,%YearAntePolicy%,%YrPhase1%)
    m_InterpLinear(EmiTimeProfile,'r,em',t,%YrPhase1%,%YrFinTgt%)

ELSEIF(IfCapIntStep eq 2),

    m_InterpLinear(EmiTimeProfile,'r,em',t,%YearAntePolicy%,%YrPhase1%)
    m_InterpLinear(EmiTimeProfile,'r,em',t,%YrPhase1%,%YrPhase2%)
    m_InterpLinear(EmiTimeProfile,'r,em',t,%YrPhase2%,%YrFinTgt%)

);

* Apply these time-profile on individual regions (that compose coalitions)

* this override calculation in "emiCap0.gms"

EmiRCap(r,em,t) = EmiRCap(r,em,"%YearAntePolicy%") * EmiTimeProfile(r,em,t) ;