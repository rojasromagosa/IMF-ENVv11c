$setargs time t0

* Emission to intermediate demand in value

emir(r,AllEmissions,EmiUse,aa,%time%)
    $ sum(mapiEmi(i,EmiUse), xa.l(r,i,aa,%t0%))
    = emi.l(r,AllEmissions,EmiUse,aa,%t0%)
    / sum(mapiEmi(i,EmiUse), xa.l(r,i,aa,%t0%)) ;

* Domestic to imported (GTAP only)

IF(IfArmFlag,
    emird(r,CO2,EmiUse,aa,%time%) $ sum(mapiEmi(i,EmiUse), xd.l(r,i,aa,%t0%))
        = emird(r,CO2,EmiUse,aa,%t0%)
        / sum(mapiEmi(i,EmiUse), xd.l(r,i,aa,%t0%));
    emirm(r,CO2,EmiUse,aa,%time%) $ sum(mapiEmi(i,EmiUse), xm.l(r,i,aa,%t0%))
        = emirm(r,CO2,EmiUse,aa,%t0%)
        / sum(mapiEmi(i,EmiUse), xm.l(r,i,aa,%t0%));
) ;

* Emission to factor demand in value

emir(r,AllEmissions,"Capital",a,%time%)
    $(sum(vOld,kv.l(r,a,vOld,%t0%)) and emi.l(r,AllEmissions,"Capital",a,%t0%))
    = emi.l(r,AllEmissions,"Capital",a,%t0%) / sum(vOld,kv.l(r,a,vOld,%t0%)) ;
emir(r,AllEmissions,"Land",a,%time%)
    $ (land.l(r,a,%t0%) and emi.l(r,AllEmissions,"Land",a,%t0%))
    = emi.l(r,AllEmissions,"Land",a,%t0%) / land.l(r,a,%t0%) ;

* Emission to gross output in value

emir(r,AllEmissions,emiact,a,%time%)
    $ (xp.l(r,a,%time%) and emi.l(r,AllEmissions,emiact,a,%t0%))
    = emi.l(r,AllEmissions,emiact,a,%t0%) / xp.l(r,a,%time%);

* [OECD-ENV]: Hypothesis same coefficient for emird and emirm --> TBU

IF(IfArmFlag,
    emird(r,NCO2,EmiUse,aa,%time%)
        $ sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,%t0%) + xm.l(r,i,aa,%t0%))
        = emi.l(r,NCO2,EmiUse,aa,%t0%)
        / sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,%t0%) + xm.l(r,i,aa,%t0%)) ;

    emird(r,OAP,EmiUse,aa,%time%)
        $ sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,%t0%) + xm.l(r,i,aa,%t0%))
        = emi.l(r,OAP,EmiUse,aa,%t0%)
        / sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,%t0%) + xm.l(r,i,aa,%t0%)) ;

    emirm(r,NCO2,EmiUse,aa,%time%) = emird(r,NCO2,EmiUse,aa,%time%) ;
    emirm(r,OAP,EmiUse,aa,%time%)  = emird(r,OAP,EmiUse,aa,%time%)  ;
) ;