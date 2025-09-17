* ----------------------------------------------------------------------------------------
*
*  NIPA accounts -- before aggregation
*
* ----------------------------------------------------------------------------------------

set n / gdp, cons, govt, invt, expt, impt, ittm / ;

Parameters
   nipa(n, r0)
;

Parameter weight(n) /
   gdp    0
   cons   1
   govt   1
   invt   1
   expt   1
   impt  -1
   ittm   1
/ ;

nipa("cons", r0) = sum(trad_comm, vdpa(trad_comm, r0) + vipa(trad_comm, r0)) ;
nipa("govt", r0) = sum(trad_comm, vdga(trad_comm, r0) + viga(trad_comm, r0)) ;
nipa("invt", r0) = sum(trad_comm, vdfa(trad_comm, "cgds", r0) + vifa(trad_comm, "cgds", r0)) ;
nipa("expt", r0) = sum((trad_comm, reg), vxwd(trad_comm, r0, reg)) ;
nipa("impt", r0) = sum((trad_comm, reg), viws(trad_comm, reg, r0)) ;
nipa("ittm", r0) = sum(trad_comm, vst(trad_comm, r0)) ;
nipa("gdp", r0)  = sum(n, weight(n)*nipa(n,r0)) ;

*file nipacsv / nipa.csv / ;
file nipacsv / %DirCheck%\nipa.csv / ;
put nipacsv ;
put "Var,Region,Value" / ;
nipacsv.pc=5 ;
nipacsv.nd=9 ;

loop((n,r0),
   put n.tl, r0.tl, nipa(n, r0) / ;
) ;
loop(r0,
   put "Pop", r0.tl, pop(r0) / ;
) ;

*file ncsv / nrgsubs.csv / ;
file ncsv / %DirCheck%\nrgsubs.csv / ;
put ncsv ;
put "Var,Region,NRG,Agent,Value" / ;
ncsv.pc=5 ;
ncsv.nd=9 ;

*---    [EditJean]: change set definition to macth with GTAP-Power

* #Rev444: Change Name ea and es into ea0 and es0, these sets are same than e0

set ea0(i0) /
    coa, oil, gas, p_c, gdt,
    $$IfTheni.power %IfPower%=="ON"
        TnD,NuclearBL,advnuc,CoalBL,colccs,GasBL,GasP,gasccs,WindBL,
        HydroBL,HydroP,OilBL,OilP,OtherBL,solarP
    $$ELSE.power
        ely
    $$ENDIF.power
/ ;
set es0(i0) /
    coa, oil, gas, p_c, gdt,
    $$IfTheni.power %IfPower%=="ON"
        TnD,NuclearBL,advnuc,CoalBL,colccs,GasBL,GasP,gasccs,WindBL,
        HydroBL,HydroP,OilBL,OilP,OtherBL,solarP
    $$ELSE.power
        ely
    $$ENDIF.power
/ ;



scalar ssign / -1 / ;

loop((r0,ea0),
   IF(osep(ea0,r0) gt 0, put "OSEP", r0.tl, "", ea0.tl, (-ssign*osep(ea0,r0)) / ; ) ;
   IF((evfa("capital",ea0,r0)-vfm("capital",ea0,r0)) lt 0, put "KTAX", r0.tl, "", ea0.tl, (ssign*(evfa("capital",ea0,r0)-vfm("capital",ea0,r0))) / ; ) ;
   IF((evfa("NatlRes",ea0,r0)-vfm("NatlRes",ea0,r0)) lt 0, put "NTAX", r0.tl, "", ea0.tl, (ssign*(evfa("NatlRes",ea0,r0)-vfm("NatlRes",ea0,r0))) / ; ) ;
) ;
loop((r0,es0),
   loop(i0,
      IF((vdfa(es0,i0,r0)-vdfm(es0,i0,r0)) lt 0, put "DTAX", r0.tl, es0.tl, i0.tl, (ssign*(vdfa(es0,i0,r0)-vdfm(es0,i0,r0))) / ; ) ;
      IF((vifa(es0,i0,r0)-vifm(es0,i0,r0)) lt 0, put "MTAX", r0.tl, es0.tl, i0.tl, (ssign*(vifa(es0,i0,r0)-vifm(es0,i0,r0))) / ; ) ;
   ) ;
   IF((vdpa(es0,r0)-vdpm(es0,r0)) lt 0, put "DTAX", r0.tl, es0.tl, "HH",  (ssign*(vdpa(es0,r0)-vdpm(es0,r0))) / ; ) ;
   IF((vdga(es0,r0)-vdgm(es0,r0)) lt 0, put "DTAX", r0.tl, es0.tl, "GOV", (ssign*(vdga(es0,r0)-vdgm(es0,r0))) / ; ) ;
   IF((vdfa(es0,"CGDS",r0)-vdfm(es0,"CGDS",r0)) lt 0, put "DTAX", r0.tl, es0.tl, "INV", (ssign*(vdfa(es0,"CGDS",r0)-vdfm(es0,"CGDS",r0))) / ; ) ;
   IF((vipa(es0,r0)-vipm(es0,r0)) lt 0, put "MTAX", r0.tl, es0.tl, "HH",  (ssign*(vipa(es0,r0)-vipm(es0,r0))) / ; ) ;
   IF((viga(es0,r0)-vigm(es0,r0)) lt 0, put "MTAX", r0.tl, es0.tl, "GOV", (ssign*(viga(es0,r0)-vigm(es0,r0))) / ; ) ;
   IF((vifa(es0,"CGDS",r0)-vifm(es0,"CGDS",r0)) lt 0, put "MTAX", r0.tl, es0.tl, "INV", (ssign*(vifa(es0,"CGDS",r0)-vifm(es0,"CGDS",r0))) / ; ) ;
) ;

putclose nipacsv ;
putclose ncsv ;

* ----------------------------------------------------------------------------------------
*
*  NIPA accounts -- after aggregation
*
* ----------------------------------------------------------------------------------------

Parameters
   nipa1(n, r)
;

nipa1("cons", r) = sum(i, vdpa1(i,r) + vipa1(i, r)) ;
nipa1("govt", r) = sum(i, vdga1(i, r) + viga1(i, r)) ;
nipa1("invt", r) = sum(i, vdfa1(i, "cgds", r) + vifa1(i, "cgds", r)) ;
nipa1("expt", r) = sum((i, rp), vxwd1(i, r, rp)) ;
nipa1("impt", r) = sum((i, rp), viws1(i, rp, r)) ;
nipa1("ittm", r) = sum(i, vst1(i, r)) ;
nipa1("gdp", r)  = sum(n, weight(n)*nipa1(n,r)) ;

file nipa1csv / %DirCheck%\nipa1.csv / ;
put nipa1csv ;
put "Var,Region,Value" / ;
nipa1csv.pc=5 ;
nipa1csv.nd=9 ;

loop((n,r),
   put n.tl, r.tl, nipa1(n, r) / ;
) ;
loop(r,
   put "Pop", r.tl, pop1(r) / ;
) ;
putclose nipa1csv ;

$OnText
*  Special section for energy subsidies information--linked to specific aggregations

file ncsv1 / nrg1subs.csv / ;
put ncsv1 ;
put "Var,Region,NRG,Agent,Value" / ;
ncsv1.pc=5 ;
ncsv1.nd=9 ;

set ea1(i) / coa, oil, gas, p_c, ely / ;
set es1(i) / coa, oil, gas, p_c, ely / ;

* scalar ssign / -1 / ;

loop((r,ea1),
   IF(osep1(ea1,r) gt 0, put "OSEP", r.tl, "", ea1.tl, (-ssign*osep1(ea1,r)) / ; ) ;
   IF((evfa1("cap",ea1,r)-vfm1("cap",ea1,r)) lt 0, put "KTAX", r.tl, "", ea1.tl, (ssign*(evfa1("cap",ea1,r)-vfm1("cap",ea1,r))) / ; ) ;
   IF((evfa1("nrs",ea1,r)-vfm1("nrs",ea1,r)) lt 0, put "NTAX", r.tl, "", ea1.tl, (ssign*(evfa1("nrs",ea1,r)-vfm1("nrs",ea1,r))) / ; ) ;
) ;
loop((r,es1),
   loop(i,
      IF((vdfa1(es1,i,r)-vdfm1(es1,i,r)) lt 0, put "DTAX", r.tl, es1.tl, i.tl, (ssign*(vdfa1(es1,i,r)-vdfm1(es1,i,r))) / ; ) ;
      IF((vifa1(es1,i,r)-vifm1(es1,i,r)) lt 0, put "MTAX", r.tl, es1.tl, i.tl, (ssign*(vifa1(es1,i,r)-vifm1(es1,i,r))) / ; ) ;
   ) ;
   IF((vdpa1(es1,r)-vdpm1(es1,r)) lt 0, put "DTAX", r.tl, es1.tl, "HH",  (ssign*(vdpa1(es1,r)-vdpm1(es1,r))) / ; ) ;
   IF((vdga1(es1,r)-vdgm1(es1,r)) lt 0, put "DTAX", r.tl, es1.tl, "GOV", (ssign*(vdga1(es1,r)-vdgm1(es1,r))) / ; ) ;
   IF((vdfa1(es1,"CGDS",r)-vdfm1(es1,"CGDS",r)) lt 0, put "DTAX", r.tl, es1.tl, "INV", (ssign*(vdfa1(es1,"CGDS",r)-vdfm1(es1,"CGDS",r))) / ; ) ;
   IF((vipa1(es1,r)-vipm1(es1,r)) lt 0, put "MTAX", r.tl, es1.tl, "HH",  (ssign*(vipa1(es1,r)-vipm1(es1,r))) / ; ) ;
   IF((viga1(es1,r)-vigm1(es1,r)) lt 0, put "MTAX", r.tl, es1.tl, "GOV", (ssign*(viga1(es1,r)-vigm1(es1,r))) / ; ) ;
   IF((vifa1(es1,"CGDS",r)-vifm1(es1,"CGDS",r)) lt 0, put "MTAX", r.tl, es1.tl, "INV", (ssign*(vifa1(es1,"CGDS",r)-vifm1(es1,"CGDS",r))) / ; ) ;
) ;
putclose ncsv1 ;
$OffText
