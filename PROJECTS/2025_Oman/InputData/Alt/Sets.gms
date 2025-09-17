$onempty

set a0 "Original activities (included cgds)" /
   frs         "Forestry"
   coa         "Coal extraction"
   oil         "Crude Oil extraction"
   gas         "Nat. gas: extraction plus manufacture & distribution"
   p_c         "Petroleum and coal products"
   cns         "Construction"
   osg         "Other collective services"
   otp         "Transport"
   CGDS        "Capital goods"
   agr         "Agriculture"
   osc         "Other Business services"
   eim         "Energy intensive manufacturing industries"
   oma         "Other manufacturing (includes recycling)"
   clp         "Coal powered electricity"
   olp         "Oil powered electricity"
   gsp         "Gas Powered electricity"
   nuc         "Nuclear power"
   hyd         "Hydro power"
   wnd         "Wind power"
   sol         "Solar power"
   xel         "Other power"
   etd         "Electricity transmission and distribution"
/ ;

set cgds0(a0) "CGDS activity" / CGDS / ;

set i0(a0) "Original commodities" /
   frs         "Forestry"
   coa         "Coal extraction"
   oil         "Crude Oil extraction"
   gas         "Nat. gas: extraction plus manufacture & distribution"
   p_c         "Petroleum and coal products"
   cns         "Construction"
   osg         "Other collective services"
   otp         "Transport"
   agr         "Agriculture"
   osc         "Other Business services"
   eim         "Energy intensive manufacturing industries"
   oma         "Other manufacturing (includes recycling)"
   clp         "Coal powered electricity"
   olp         "Oil powered electricity"
   gsp         "Gas Powered electricity"
   nuc         "Nuclear power"
   hyd         "Hydro power"
   wnd         "Wind power"
   sol         "Solar power"
   xel         "Other power"
   etd         "Electricity transmission and distribution"
/ ;

* --------------------------------------------------------------------
*
*   USER CAN MODIFY ACTIVITY/COMMODITY AGGREGATION
*   USER MUST FILL IN SUBSETS WHERE NEEDED
*
* --------------------------------------------------------------------


* >>>> PLACE TO CHANGE ACTIVITIES, i.e. model activities

set act "Modeled activities" /
   frs-a       "Forestry"
   coa-a       "Coal extraction"
   oil-a       "Crude Oil extraction"
   gas-a       "Nat. gas: extraction plus manufacture & distribution"
   p_c-a       "Petroleum and coal products"
   cns-a       "Construction"
   osg-a       "Other collective services"
   otp-a       "Transport"
   ELY-a       "ELY"
   agr-a       "Agriculture"
   osc-a       "Other Business services"
   eim-a       "Energy intensive manufacturing industries"
   oma-a       "Other manufacturing (includes recycling)"
   clp-a       "Coal powered electricity"
   olp-a       "Oil powered electricity"
   gsp-a       "Gas Powered electricity"
   nuc-a       "Nuclear power"
   hyd-a       "Hydro power"
   wnd-a       "Wind power"
   sol-a       "Solar power"
   xel-a       "Other power"
   etd-a       "Electricity transmission and distribution"
/ ;

* >>>> PLACE TO CHANGE COMMODITIES, i.e. model commodities

set comm "Modeled commodities" /
   frs-c       "Forestry"
   coa-c       "Coal extraction"
   oil-c       "Crude Oil extraction"
   gas-c       "Nat. gas: extraction plus manufacture & distribution"
   p_c-c       "Petroleum and coal products"
   cns-c       "Construction"
   osg-c       "Other collective services"
   otp-c       "Transport"
   agr-c       "Agriculture"
   osc-c       "Other Business services"
   eim-c       "Energy intensive manufacturing industries"
   oma-c       "Other manufacturing (includes recycling)"
   clp-c       "Coal powered electricity"
   olp-c       "Oil powered electricity"
   gsp-c       "Gas Powered electricity"
   nuc-c       "Nuclear power"
   hyd-c       "Hydro power"
   wnd-c       "Wind power"
   sol-c       "Solar power"
   xel-c       "Other power"
   etd-c       "Electricity transmission and distribution"
/ ;

set endw "Modeled production factors" /
   Land        "Land"
   Capital     "Capital"
   NatRes      "Natural resource"
   Labour      "Total Labour Force"
/ ;

set stdlab "Standard SAM labels" /
   trd         "Trade account"
   hhd         "Household"
   gov         "Government"
   inv         "Investment"
   r_d         "R & D expenditures"
   deprY       "Depreciation"
   tmg         "Trade margins"
   itax        "Indirect tax"
   ptax        "Production tax"
   mtax        "Import tax"
   etax        "Export tax"
   vtax        "Taxes on factors of production"
   vsub        "Subsidies on factors of production"
   dtax        "Direct taxation"
   ctax        "Carbon tax"
   bop         "Balance of payments account"
   tot         "Total for row/column sums"
   TotEly      "Aggregation of all Power and T&D"
/ ;

set findem(stdlab) "Final demand accounts" /
   hhd         "Household"
   gov         "Government"
   inv         "Investment"
   r_d         "R & D expenditures"
   tmg         "Trade margins"
/ ;

set reg "Modeled regions" /
   PAK         "Pakistan"
   KAZ         "Kazakhstan"
   KGZ         "Kyrgyzstan"
   TJK         "Tajikistan"
   UZB         "Uzbekistan"
   ARM         "Armenia"
   AZE         "Azerbaijan"
   GEO         "Georgia"
   BHR         "Bahrain"
   IRN         "Iran (Islamic Republic of)"
   IRQ         "Iraq"
   JOR         "Jordan"
   OMN         "Oman"
   QAT         "Qatar"
   SAU         "Saudi Arabia"
   ARE         "United Arab Emirates"
   EGY         "Egypt"
   MAR         "Morocco"
   TUN         "Tunisia"
   MCD         "Rest of MCD"
   USA         "United States of America"
   EUR         "EU27 + UK + EFTA"
   CHN         "China"
   IND         "India"
   REU         "Rest of Europe"
   APD         "Asia-pasific"
   AFR         "Africa"
   WHD         "Western Hemisphere"
/ ;

set is "SAM accounts for aggregated SAM" /

*  User-defined activities

   set.act

*  User-defined commodities

   set.comm

*  User-defined factors

   set.endw

*  Standard SAM accounts

   set.stdlab

*  User-defined regions

   set.reg
/ ;

alias(is, js) ;

set aa(is) "Armington agents" /
   set.act
   set.findem
   TotEly
   tot
/ ;

set a(aa) "Activities"  /
   set.act
   TotEly
   tot
/ ;

set i(is) "Commodities" / set.comm /;

set fp(is) "Factors of production" / set.endw /;

alias(i, j) ;

set l(fp) "Labor factors" /
   Labour      "Total Labour Force"
/ ;

set ul(l) "Unskilled labor" /
   Labour      "Total Labour Force"
/ ;

set sl(l) "Skilled labor" /
/ ;

set lr(l) "Reference labor for skill premium" /
   Labour      "Total Labour Force"
/ ;

set cap(fp) "Capital" /
   Capital     "Capital"
/ ;

set lnd(fp) "Land endowment" /
   Land        "Land"
/ ;

set nrs(fp) "Natural resource" /
   NatRes      "Natural resource"
/ ;

* >>>> CAN MODIFY MOBILE VS. NON-MOBILE FACTORS

set fm(fp) "Mobile factors" /

   Land        "Land"
   Capital     "Capital"
   NatRes      "Natural resource"
   Labour      "Total Labour Force"
/ ;

set fnm(fp) "Non-mobile factors" /

/ ;

set fd(aa) "Domestic final demand agents" /
   set.findem

/ ;

set h(fd) "Households" /
   hhd         "Household"
/ ;

set gov(fd) "Government" /
   gov         "Government"
/ ;

set inv(fd) "Investment" /
   inv         "Investment"
/ ;

singleton set r_d(fd) "R & D expenditures" /
   r_d         "R & D expenditures"
/ ;

set fdc(fd) "Final demand accounts with CES expenditure function" /
   gov         "Government"
   inv         "Investment"
   r_d         "R & D expenditures"
/ ;

set tmg(fd) "Domestic supply of trade margins services" /
   tmg         "Trade margins"
/ ;

set r(is) "Regions" / set.reg / ;

alias(r,rp) ; alias(r,s) ; alias(r,d) ;

* >>>> MUST INSERT RESIDUAL REGION (ONLY ONE)

set rres(r) "Residual region" /
   USA         "United States of America"
/ ;

* >>>> MUST INSERT MUV REGIONS (ONE OR MORE)

set rmuv(r) "MUV regions" /
   USA         "United States of America"
   EUR         "EU27 + UK + EFTA"
/ ;

* >>>> MUST INSERT MUV COMMODITIES (ONE OR MORE)

set imuv(i) "MUV commodities" /
   set.comm

/ ;

set em "Emissions" /
   CH4         "Methane"
   CO2         "Carbon Dioxide"
   N2O         "Nitrous oxide"
   HFC         "Hydrofluorocarbons"
   PFC         "Perfluorinated compound"
   SF6         "Sulfur hexafluoride"
   GHG         "All Greenhouse gases"
   FGAS        "Emissions of fluoridated gases (High Global-Warming Potential)"
/ ;

set emn(em) "Non-CO2 emissions" /
   CH4         "Methane"
   N2O         "Nitrous oxide"
   HFC         "Hydrofluorocarbons"
   PFC         "Perfluorinated compound"
   SF6         "Sulfur hexafluoride"
   FGAS        "Emissions of fluoridated gases (High Global-Warming Potential)"
/ ;

alias(emn, nco2) ;

set ia "Aggregate commodities for model output" /
   Total       "Aggregation of all commodities"
/ ;

set mapi(ia,i) "Mapping for aggregate commodities" ;
mapi("Total",i) = yes ; mapi("Total","other-c")=NO;

* >>>> CAN CHANGE ACTIVITY MAPPING

set mapa0(a0, a) "Mapping from original activities to new activities" /
   frs    .frs-a
   coa    .coa-a
   oil    .oil-a
   gas    .gas-a
   p_c    .p_c-a
   cns    .cns-a
   osg    .osg-a
   otp    .otp-a
   ELY    .ELY-a
   agr    .agr-a
   osc    .osc-a
   eim    .eim-a
   oma    .oma-a
   clp    .clp-a
   olp    .olp-a
   gsp    .gsp-a
   nuc    .nuc-a
   hyd    .hyd-a
   wnd    .wnd-a
   sol    .sol-a
   xel    .xel-a
   etd    .etd-a
/ ;

* >>>> CAN CHANGE COMMODITY MAPPING

set mapi0(i0, i) "Mapping from original commodities to new commodities" /
   frs    .frs-c
   coa    .coa-c
   oil    .oil-c
   gas    .gas-c
   p_c    .p_c-c
   cns    .cns-c
   osg    .osg-c
   otp    .otp-c
   agr    .agr-c
   osc    .osc-c
   eim    .eim-c
   oma    .oma-c
   clp    .clp-c
   olp    .olp-c
   gsp    .gsp-c
   nuc    .nuc-c
   hyd    .hyd-c
   wnd    .wnd-c
   sol    .sol-c
   xel    .xel-c
   etd    .etd-c
/ ;

set sortOrder / sort1*sort94 / ;

set mapOrder(sortOrder,is) /
sort1.frs-a
sort2.coa-a
sort3.oil-a
sort4.gas-a
sort5.p_c-a
sort6.cns-a
sort7.osg-a
sort8.otp-a
sort9.ELY-a
sort10.agr-a
sort11.osc-a
sort12.eim-a
sort13.oma-a
sort14.clp-a
sort15.olp-a
sort16.gsp-a
sort17.nuc-a
sort18.hyd-a
sort19.wnd-a
sort20.sol-a
sort21.xel-a
sort22.etd-a
sort23.frs-c
sort24.coa-c
sort25.oil-c
sort26.gas-c
sort27.p_c-c
sort28.cns-c
sort29.osg-c
sort30.otp-c
sort31.ELY-c
sort32.agr-c
sort33.osc-c
sort34.eim-c
sort35.oma-c
sort36.clp-c
sort37.olp-c
sort38.gsp-c
sort39.nuc-c
sort40.hyd-c
sort41.wnd-c
sort42.sol-c
sort43.xel-c
sort44.etd-c
sort45.Land
sort46.Capital
sort47.NatRes
sort48.Labour
sort49.trd
sort50.hhd
sort51.gov
sort52.inv
sort53.r_d
sort54.deprY
sort55.tmg
sort56.itax
sort57.ptax
sort58.mtax
sort59.etax
sort60.vtax
sort61.vsub
sort62.dtax
sort63.ctax
sort64.bop
sort65.tot
sort66.TotEly
sort67.PAK
sort68.KAZ
sort69.KGZ
sort70.TJK
sort71.UZB
sort72.ARM
sort73.AZE
sort74.GEO
sort75.BHR
sort76.IRN
sort77.IRQ
sort78.JOR
sort79.OMN
sort80.QAT
sort81.SAU
sort82.ARE
sort83.EGY
sort84.MAR
sort85.TUN
sort86.MCD
sort87.USA
sort88.EUR
sort89.CHN
sort90.IND
sort91.REU
sort92.APD
sort93.AFR
sort94.WHD
/ ;

