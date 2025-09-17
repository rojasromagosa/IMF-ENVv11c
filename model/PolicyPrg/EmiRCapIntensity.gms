*---   Calculate EmiRCap from GDP intensity targets (for EmSingle & AllGHG)

* memo target are defined with initial EmiRCap that can be on all emissions
* or not according to the value of IfCap
* emiCap0 has been defined in "emiCap0.gms"

* #TODO Faire revenu par tete

* IF %1 = 0 intensity target = 0 --> use given time path

work = %1 ;
Display work ;

* GDP in %YearAntePolicy%-PPP

rworkT(r,t) $ ypc("cst_itl",r,"%YearAntePolicy%")
    = ypc("cur_itl",r,"%YearAntePolicy%") * m_true1(pop,r,"%YearAntePolicy%")
    * [ypc("cst_itl",r,t) * m_true1(pop,r,t)]
    / [ypc("cst_itl",r,"%YearAntePolicy%") * m_true1(pop,r,"%YearAntePolicy%")]
    ;

* Emission intensity profile in the Baseline

tvol = 1 ; !! work =  ConvertCurToModelUSD("%YearUSDCT%");

EmiRInt(r,em,t) $ between3(t,"%YearAntePolicy%","%YrFinTgt%")
    = m_true2b(emiTot,bau,r,em,t)
    / [ { m_true1(rgdpmp,r,t) * tvol } $ {IfEmiIntensity eq 1}
      + {  rworkT(r,t)               } $ {IfEmiIntensity eq 2}
      + {  m_true1(pop,r,t)          } $ {IfEmiIntensity eq 3}
      ] ;

EmiRInt_bau(r,em,t) = EmiRInt(r,em,t);

* Determine emission profile for intensity Target:

* Final emission-intensity Target (world average) wrt starting emission

IF(work,

* Linear interpolation

    EmiRInt(rp,em,"%YrFinTgt%")
        = work
        * sum(r, m_true2b(emiTot,bau,r,em,"%YearAntePolicy%") )
        / [   sum(r, m_true1(rgdpmp,r,"%YrFinTgt%")) $ {IfEmiIntensity eq 1}
            + sum(r, rworkT(r,"%YrFinTgt%") )        $ {IfEmiIntensity eq 2}
            + sum(r,m_true1(pop,r,"%YrFinTgt%") )    $ {IfEmiIntensity eq 3}
        ];

    m_InterpLinear(EmiRInt,'r,em',t,%YearAntePolicy%,%YrFinTgt%)

ELSE

* use predefined profile:  EmiTimeProfile(r,em,t)

    EmiRInt(rp,em,t)
        =  EmiTimeProfile(rp,em,t)
        * sum(r, EmiRCap(r,em,t))
        / [   sum(r, m_true1(rgdpmp,r,t)) $ {IfEmiIntensity eq 1}
            + sum(r, rworkT(r,t) )        $ {IfEmiIntensity eq 2}
            + sum(r, m_true1(pop,r,t))    $ {IfEmiIntensity eq 3}
        ];

) ;


* Alternative put a Transition step from %YearAntePolicy% to %YrPhase1%:

IF(0 and IfEmiIntensity eq 1,
    LOOP(t $ (t.val ge %YearPolicyStart% and t.val le %YrPhase1%),
        EmiRInt(r,em,t) = EmiRInt(r,em,t-1) * (1 - 6.895 / 100) ;
    ) ;
    m_InterpLinear(EmiRInt,'r,em',t,%YrPhase1%,%YrFinTgt%)
) ;

* Recover emission target from intensity profile

EmiRCap(r,em,t) $ between3(t,"%YearPolicyStart%","%YrFinTgt%")
    = EmiRInt(r,em,t)
    * [    {m_true1(rgdpmp,r,t)  } $ {IfEmiIntensity eq 1}
        +  {rworkT(r,t)          } $ {IfEmiIntensity eq 2}
        +  {m_true1(pop,r,t)     } $ {IfEmiIntensity eq 3}
    ] ;

* calculate corresponding trajectory for individual gas cap (base 1)
* useless just to check trajectory

EmiTimeProfile(r,em,t) $ EmiRCap(r,em,"%YearAntePolicy%")
    = EmiRCap(r,em,t) / EmiRCap(r,em,"%YearAntePolicy%") ;

$OnText
                    2021 IEA Report: "NZE by 2050"

        --> CO2 Combustion in 2030: 19254 soit 0.61     de 2020
        --> CO2 Combustion in 2040: 6030  soit 0.191    de 2020
        --> CO2 Combustion in 2050: 940   soit 0.029764 de 2020

        Because emissions intensity decrease in BAU it is possible
        that emission intensity targets are above baseline
        So the rule is not relative to Starting year
        but to BAU intensity.

$Offtext




