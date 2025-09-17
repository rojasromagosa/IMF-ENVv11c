
*   Initialize the investment target assumptions

set tint(r,t) Investment target intervals ;
tint(r,t0) = yes ;
tint(r,t) $ (invTarget0(r,t) gt 0 ) = yes ;

Parameter invTargetT(r,t); invTargetT(r,t) = na ;

SETS
    $$IFe %YearEndofSim%>=2030 tf0(t) "Year for starting savf phaseout"  / 2030 /
    $$IFe %YearEndofSim%<2030  tf0(t) "Year for starting savf phaseout"  / %YearEndofSim% /
*    tfT(tt) "Year for finishing savf phaseout" / 2060 /
;

Parameter
    year0    "Start year of an interval"
    tgt0     "Ratio at beginning of an interval"
    tgt1     "Ratio at end of an interval"
    delT     "Year-gap of an interval"
;

loop((r,t0,tsim) $ tint(r,tsim),

    IF(years(tsim) eq years(t0),

* Beginning of time, initialize

        year0 = years(t0) ;
        tgt0  = 100
              * sum(inv, yfd.l(r,inv,t0)*yfd0(r,inv))
              / [gdpmp.l(r,t0)*gdpmp0(r)] ;
        invTargetT(r,t) = tgt0;
    else

* tsim is the upper end of an interval

        delT = (years(tsim) - year0) ;
        tgt1 = invTarget0(r,tsim) ;

        loop(t $ (years(t) gt year0),
            IF(years(t) le years(tsim),
                invTargetT(r,t)
                = tgt1*(years(t) - year0)/delT
                + tgt0*(years(tsim) - years(t))/delT;
            else
               invTargetT(r,t) = tgt1 ;
            ) ;
        ) ;

* Reset for next interval

        year0 = years(tsim) ;
        tgt0  = tgt1 ;
    ) ;
) ;




