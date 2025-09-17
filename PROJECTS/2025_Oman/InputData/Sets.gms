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
   agr-a       "Agriculture"
   frs-a       "Forestry"
   coa-a       "Coal extraction"
   oil-a       "Crude Oil extraction"
   gas-a       "Nat. gas: extraction plus manufacture & distribution"
   clp-a       "Coal powered electricity"
   olp-a       "Oil powered electricity"
   gsp-a       "Gas Powered electricity"
   nuc-a       "Nuclear power"
   hyd-a       "Hydro power"
   wnd-a       "Wind power"
   sol-a       "Solar power"
   xel-a       "Other power"
   etd-a       "Electricity transmission and distribution"
   p_c-a       "Petroleum and coal products"
   eim-a       "Energy intensive manufacturing industries"
   oma-a       "Other manufacturing (includes recycling)"
   cns-a       "Construction"
   otp-a       "Transport"
   osc-a       "Other Business services"
   osg-a       "Other collective services"
/ ;

* >>>> PLACE TO CHANGE COMMODITIES, i.e. model commodities

set comm "Modeled commodities" /
   agr-c       "Agriculture"
   frs-c       "Forestry"
   coa-c       "Coal extraction"
   oil-c       "Crude Oil extraction"
   gas-c       "Nat. gas: extraction plus manufacture & distribution"
   ELY-c       "Electricity: Generation, transmission and distribution"
   p_c-c       "Petroleum and coal products"
   eim-c       "Energy intensive manufacturing industries"
   oma-c       "Other manufacturing (includes recycling)"
   otp-c       "Transport"
   cns-c       "Construction"
   osc-c       "Other Business services"
   osg-c       "Other collective services"
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

set wat(fp) "Water resource" /

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
   hhd         "Household"
   gov         "Government"
   inv         "Investment"
   r_d         "R & D expenditures"
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
   eim-c
   oma-c
/ ;

set ia "Aggregate commodities for model output" /
   frs-c       "Forestry"
   coa-c       "Coal extraction"
   oil-c       "Crude Oil extraction"
   gas-c       "Nat. gas: extraction plus manufacture & distribution"
   p_c-c       "Petroleum and coal products"
   cns-c       "Construction"
   osg-c       "Other collective services"
   otp-c       "Transport"
   ELY-c       "Electricity: Generation, transmission and distribution"
   agr-c       "Agriculture"
   osc-c       "Other Business services"
   eim-c       "Energy intensive manufacturing industries"
   oma-c       "Other manufacturing (includes recycling)"

*   Aggregate Commodities
   "tagr-c"   "Primary Sectors / Commodities"
   "tman-c"   "Manufacturing"
   "tsrv-c"   "Services"
   "toth-c"   "Other industries"
   "ttot-c"   "Total"
   "other-c"  "Other goods"
/ ;

set mapi(ia,i) "Mapping for aggregate commodities" /
   frs-c   .frs-c
   coa-c   .coa-c
   oil-c   .oil-c
   gas-c   .gas-c
   p_c-c   .p_c-c
   cns-c   .cns-c
   osg-c   .osg-c
   otp-c   .otp-c
   ELY-c   .ELY-c
   agr-c   .agr-c
   osc-c   .osc-c
   eim-c   .eim-c
   oma-c   .oma-c

   "tagr-c".frs-c
   "tagr-c".agr-c
   "tman-c".oma-c
   "tsrv-c".osg-c
   "tsrv-c".otp-c
   "tsrv-c".osc-c
   "toth-c".coa-c
   "toth-c".oil-c
   "toth-c".gas-c
   "toth-c".p_c-c
   "toth-c".cns-c
   "toth-c".ELY-c
   "ttot-c".frs-c
   "ttot-c".coa-c
   "ttot-c".oil-c
   "ttot-c".gas-c
   "ttot-c".p_c-c
   "ttot-c".cns-c
   "ttot-c".osg-c
   "ttot-c".otp-c
   "ttot-c".ELY-c
   "ttot-c".agr-c
   "ttot-c".osc-c
   "ttot-c".eim-c
   "ttot-c".oma-c
/ ;

set aga "Aggregate activities for model output" /
   frs-a       "Forestry"
   coa-a       "Coal extraction"
   oil-a       "Crude Oil extraction"
   gas-a       "Nat. gas: extraction plus manufacture & distribution"
   p_c-a       "Petroleum and coal products"
   cns-a       "Construction"
   osg-a       "Other collective services"
   otp-a       "Transport"
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


*   Aggregate Sectors
   "tagr-a"    "Primary Sectors / Commodities"
   "tman-a"    "Manufacturing"
   "tsrv-a"    "Services"
   "toth-a"    "Other industries"
   "ttot-a"    "Total"
    other-a    "Other sectors"
/ ;

set mapaga(aga,a) "Mapping for aggregate activities" /
   frs-a   .frs-a
   coa-a   .coa-a
   oil-a   .oil-a
   gas-a   .gas-a
   p_c-a   .p_c-a
   cns-a   .cns-a
   osg-a   .osg-a
   otp-a   .otp-a
   agr-a   .agr-a
   osc-a   .osc-a
   eim-a   .eim-a
   oma-a   .oma-a
   clp-a   .clp-a
   olp-a   .olp-a
   gsp-a   .gsp-a
   nuc-a   .nuc-a
   hyd-a   .hyd-a
   wnd-a   .wnd-a
   sol-a   .sol-a
   xel-a   .xel-a
   etd-a   .etd-a

   "tagr-a".frs-a
   "tagr-a".agr-a
   "tsrv-a".osg-a
   "tsrv-a".otp-a
   "tsrv-a".osc-a
   "toth-a".coa-a
   "toth-a".oil-a
   "toth-a".gas-a
   "toth-a".p_c-a
   "toth-a".cns-a
   "toth-a".clp-a
   "toth-a".olp-a
   "toth-a".gsp-a
   "toth-a".nuc-a
   "toth-a".hyd-a
   "toth-a".wnd-a
   "toth-a".sol-a
   "toth-a".xel-a
   "toth-a".etd-a
   "ttot-a".frs-a
   "ttot-a".coa-a
   "ttot-a".oil-a
   "ttot-a".gas-a
   "ttot-a".p_c-a
   "ttot-a".cns-a
   "ttot-a".osg-a
   "ttot-a".otp-a
   "ttot-a".agr-a
   "ttot-a".osc-a
   "ttot-a".eim-a
   "ttot-a".oma-a
   "ttot-a".clp-a
   "ttot-a".olp-a
   "ttot-a".gsp-a
   "ttot-a".nuc-a
   "ttot-a".hyd-a
   "ttot-a".wnd-a
   "ttot-a".sol-a
   "ttot-a".xel-a
   "ttot-a".etd-a
/ ;

set ra "Aggregate regions for emission regimes and model output" /
   CHN         "China"
   IND         "India"
   PAK         "Pakistan"
   USA         "United States of America"
   ARM         "Armenia"
   AZE         "Azerbaijan"
   GEO         "Georgia"
   KAZ         "Kazakhstan"
   KGZ         "Kyrgyzstan"
   TJK         "Tajikistan"
   UZB         "Uzbekistan"
   BHR         "Bahrain"
   IRQ         "Iraq"
   IRN         "Iran (Islamic Republic of)"
   JOR         "Jordan"
   OMN         "Oman"
   QAT         "Qatar"
   SAU         "Saudi Arabia"
   ARE         "United Arab Emirates"
   EGY         "Egypt"
   MAR         "Morocco"
   TUN         "Tunisia"
   EUR         "EU27 + UK + EFTA"
   MCD         "Rest of MCD"
   REU         "Rest of Europe"
   APD         "Asia-pasific"
   AFR         "Africa"
   WHD         "Western Hemisphere"

   OilP        "Oil Producers"
   HIC         "High Income countries"
   MIC         "Medium Income countries"
   LIC         "Low Income countries"
   WORLD       "World Aggregate"
/ ;

set mapr(ra,r) "Mapping for aggregate regions" /
   CHN     .CHN
   IND     .IND
   PAK     .PAK
   USA     .USA
   ARM     .ARM
   AZE     .AZE
   GEO     .GEO
   KAZ     .KAZ
   KGZ     .KGZ
   TJK     .TJK
   UZB     .UZB
   BHR     .BHR
   IRQ     .IRQ
   IRN     .IRN
   JOR     .JOR
   OMN     .OMN
   QAT     .QAT
   SAU     .SAU
   ARE     .ARE
   EGY     .EGY
   MAR     .MAR
   TUN     .TUN
   EUR     .EUR
   MCD     .MCD
   REU     .REU
   APD     .APD
   AFR     .AFR
   WHD     .WHD

   HIC     .USA
   HIC     .BHR
   HIC     .OMN
   HIC     .SAU
   HIC     .ARE
   HIC     .EUR
   HIC     .REU
   MIC     .CHN
   MIC     .IND
   MIC     .AZE
   MIC     .GEO
   MIC     .KAZ
   MIC     .UZB
   MIC     .IRQ
   MIC     .IRN
   MIC     .JOR
   MIC     .EGY
   MIC     .MAR
   MIC     .TUN
   MIC     .MCD
   MIC     .APD
   MIC     .WHD
   LIC     .PAK
   LIC     .ARM
   LIC     .KGZ
   LIC     .TJK
   LIC     .AFR
   WORLD   .CHN
   WORLD   .IND
   WORLD   .PAK
   WORLD   .USA
   WORLD   .ARM
   WORLD   .AZE
   WORLD   .GEO
   WORLD   .KAZ
   WORLD   .KGZ
   WORLD   .TJK
   WORLD   .UZB
   WORLD   .BHR
   WORLD   .IRQ
   WORLD   .IRN
   WORLD   .JOR
   WORLD   .OMN
   WORLD   .QAT
   WORLD   .SAU
   WORLD   .ARE
   WORLD   .EGY
   WORLD   .MAR
   WORLD   .TUN
   WORLD   .EUR
   WORLD   .MCD
   WORLD   .REU
   WORLD   .APD
   WORLD   .AFR
   WORLD   .WHD
/ ;

set lagg "Aggregate labor for output" /
   Labour      "Total Labour Force"

   tot         "Total labor"
/ ;

set mapl(lagg,l) "Mapping for aggregate regions" /
   Labour  .Labour

   tot     .Labour
/ ;

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
   clp    .ELY-c
   olp    .ELY-c
   gsp    .ELY-c
   nuc    .ELY-c
   hyd    .ELY-c
   wnd    .ELY-c
   sol    .ELY-c
   xel    .ELY-c
   etd    .ELY-c
/ ;

set sortOrder / sort1*sort84 / ;

set mapOrder(sortOrder,is) /
sort1.agr-a
sort2.frs-a
sort3.coa-a
sort4.oil-a
sort5.gas-a
sort6.clp-a
sort7.olp-a
sort8.gsp-a
sort9.nuc-a
sort10.hyd-a
sort11.wnd-a
sort12.sol-a
sort13.xel-a
sort14.etd-a
sort15.p_c-a
sort16.eim-a
sort17.oma-a
sort18.cns-a
sort19.otp-a
sort20.osc-a
sort21.osg-a
sort22.agr-c
sort23.frs-c
sort24.coa-c
sort25.oil-c
sort26.gas-c
sort27.ELY-c
sort28.p_c-c
sort29.eim-c
sort30.oma-c
sort31.otp-c
sort32.cns-c
sort33.osc-c
sort34.osg-c
sort35.Land
sort36.Capital
sort37.NatRes
sort38.Labour
sort39.trd
sort40.hhd
sort41.gov
sort42.inv
sort43.r_d
sort44.deprY
sort45.tmg
sort46.itax
sort47.ptax
sort48.mtax
sort49.etax
sort50.vtax
sort51.vsub
sort52.dtax
sort53.ctax
sort54.bop
sort55.tot
sort56.TotEly
sort57.PAK
sort58.KAZ
sort59.KGZ
sort60.TJK
sort61.UZB
sort62.ARM
sort63.AZE
sort64.GEO
sort65.BHR
sort66.IRN
sort67.IRQ
sort68.JOR
sort69.OMN
sort70.QAT
sort71.SAU
sort72.ARE
sort73.EGY
sort74.MAR
sort75.TUN
sort76.MCD
sort77.USA
sort78.EUR
sort79.CHN
sort80.IND
sort81.REU
sort82.APD
sort83.AFR
sort84.WHD
/ ;

set tot(aa) "Total" / tot   "Total for row/column sums"/ ;
set cra(a)  "Crop activities" /    agr-a       "Agriculture" / ;
set lva(a)  "Livestock activities" / / ;
set ea(a)  "Energy activities (etd included)" /
    coa-a       "Coal extraction"
    oil-a       "Crude Oil extraction"
    gas-a       "Nat. gas: extraction plus manufacture & distribution"
    p_c-a       "Petroleum and coal products"
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
set fa(a)  "Fossil fuel activities" /
    coa-a       "Coal extraction"
    oil-a       "Crude Oil extraction"
    gas-a       "Nat. gas: extraction plus manufacture & distribution"
    p_c-a       "Petroleum and coal products"
 / ;
set wtra(a)  "Water services activities" / / ;
set elya(a)  "Power activities (etd included)" /
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
set etda(a)  "Electricity transmission and distribution activities" /    etd-a       "etd" / ;
set primElya(a)  "Primary power activities" /
    nuc-a       "nuc"
    hyd-a       "hyd"
    wnd-a       "wnd"
    sol-a       "sol"
    xel-a       "xel"
    etd-a       "etd"
 / ;
set z "Labor market zones" /
   rur         "Agricultural sectors"
   urb         "Non-agricultural sectors"
   nsg         "Non-segmented labor markets"
/ ;

set rur(z) "Rural zone" /
   rur         "Agricultural sectors"
/ ;

set urb(z) "Urban zone" /
   urb         "Non-agricultural sectors"
/ ;

set nsg(z) "Both zones" /
   nsg         "Non-segmented labor markets"
/ ;

set mapz(z,a) "Mapping of activities to zones" /
   rur.agr-a
   urb.frs-a
   urb.coa-a
   urb.oil-a
   urb.gas-a
   urb.p_c-a
   urb.cns-a
   urb.osg-a
   urb.otp-a
   urb.osc-a
   urb.eim-a
   urb.oma-a
   urb.clp-a
   urb.olp-a
   urb.gsp-a
   urb.nuc-a
   urb.hyd-a
   urb.wnd-a
   urb.sol-a
   urb.xel-a
   urb.etd-a
/ ;

mapz("nsg", a) = yes ;

set frti(i)  "Fertilizer commodities" / / ;
set feedi(i)  "Feed commodities" / / ;
set iw(i)  "Water services commodities (activated if IfWater is on)" / / ;
set ei(i)  "Energy commodities" /
    coa-c       "Coal extraction"
    oil-c       "Crude Oil extraction"
    gas-c       "Nat. gas: extraction plus manufacture & distribution"
    p_c-c       "Petroleum and coal products"
    ELY-c       "Electricity: Generation, transmission and distribution"
 / ;
set elyi(i)  "Electricity commodities" /    ELY-c       "Electricity: Generation, transmission and distribution" / ;
set fi(ei)  "Fuel commodities" /
    coa-c       "Coal extraction"
    oil-c       "Crude Oil extraction"
    gas-c       "Nat. gas: extraction plus manufacture & distribution"
    p_c-c       "Petroleum and coal products"
 / ;
set img(i) "Margin commodities" /
   otp-c       "Transport"
/ ;

set k "Household commodities" /
   frs-k       "Forestry"
   cns-k       "Construction"
   osg-k       "Other collective services"
   otp-k       "Transport"
   agr-k       "Crop bundle"
   osc-k       "Other Business services"
   eim-k       "Energy intensive manufacturing industries"
   oma-k       "Other manufacturing (includes recycling)"
   nrg-k       "Energy bundle"
/ ;

set mapk(i,k) "Mapping from i to k" /
   frs-c   .frs-k
   coa-c   .nrg-k
   oil-c   .nrg-k
   gas-c   .nrg-k
   p_c-c   .nrg-k
   cns-c   .cns-k
   osg-c   .osg-k
   otp-c   .otp-k
   ELY-c   .nrg-k
   agr-c   .agr-k
   osc-c   .osc-k
   oma-c   .oma-k
/ ;

set lh "Market condition flags" /
   lo    "Market downswing"
   hi    "Market upswing"
/ ;

set wbnd "Aggregate water markets" /
   N_A         "N_A"
/ ;

set wbnd1(wbnd) "Top level water markets" /
/ ;

set wbnd2(wbnd) "Second level water markets" /
/ ;

set wbndex(wbnd) "Second level water markets" /
/ ;

set mapw1(wbnd,wbnd) "Mapping of first level water bundles" /
/ ;

set mapw2(wbnd,a) "Mapping of second level water bundle" /
/ ;

set wbnda(wbnd) "Water bundles mapped one-to-one to activities" /
/ ;

set wbndi(wbnd) "Water bundles mapped to aggregate output" /
/ ;

set NRG "Energy bundles used in model" /
   coa         "Coal"
   oil         "Oil"
   gas         "Gas"
   ELY         "Electricity"
/ ;

set coa(NRG) "Coal bundle used in model" /
   coa         "Coal"
/ ;

set oil(NRG) "Oil bundle used in model" /
   oil         "Oil"
/ ;

set gas(NRG) "Gas bundle used in model" /
   gas         "Gas"
/ ;

set ely(NRG) "Electricity bundle used in model" /
   ELY         "Electricity"
/ ;

set mape(NRG,ei) "Mapping of energy commodities to energy bundles" /
   coa     .coa-c
   oil     .oil-c
   oil     .p_c-c
   gas     .gas-c
   ELY     .ELY-c
/ ;

set var "GDP variables" /
   "GDP_per_capita|PPP"
   "GDP|PPP"
/ ;

set scen "Scenarios" /
   SSP1        "Sustainability ('Taking the Green Road')"
   SSP2        "Middle of the Road"
   SSP3        "Regional Rivalry ('A Rocky Road')"
   SSP4        "Inequality ('A Road Divided')"
   SSP5        "Fossil-fueled Development ('Taking the Highway')"
   UN2022      "UN 2022 Revision Medium variant"
   GIDD        "GIDD population projection"
/ ;

set ssp(scen) "SSP Scenarios" /
   SSP1        "Sustainability ('Taking the Green Road')"
   SSP2        "Middle of the Road"
   SSP3        "Regional Rivalry ('A Rocky Road')"
   SSP4        "Inequality ('A Road Divided')"
   SSP5        "Fossil-fueled Development ('Taking the Highway')"
/ ;

set mod "Models" /
   OECD        "OECD-based SSPs"
   IIASA       "IIASA-based SSPs"
/ ;

set tranche "Population cohorts" /
   PLT15       "Population less than 15"
   P1564       "Population aged 15 to 64"
   P65UP       "Population 65 and over"
   PTOTL       "Total population"
/ ;

set trs(tranche) "Population cohorts" /
   PLT15       "Population less than 15"
   P1564       "Population aged 15 to 64"
   P65UP       "Population 65 and over"
/ ;

set gender   "Gender categories" /
   MALE        "Male"
   FEML        "Female"
   BOTH        "M+F"
/ ;

set sex(gender) "Gender categories excl total" /
   MALE        "Male"
   FEML        "Female"
/ ;

set ed "Combined SSP/GIDD education levels" /
   elev0       "ENONE/EDUC0_6"
   elev1       "EPRIM/EDUC6_9"
   elev2       "ESECN/EDUC9UP"
   elev3       "ETERT"
   elevt       "Total"
/ ;

set edx(ed) "Education levels excluding totals" /
   elev0       "ENONE/EDUC0_6"
   elev1       "EPRIM/EDUC6_9"
   elev2       "ESECN/EDUC9UP"
   elev3       "ETERT"
/ ;

set rq(ra) "Regions submitted to an emissions cap" ;
rq(ra) = no ;

set nsk(l) "Unskilled types for labor growth assumptions" /

/ ;

set skl(l)  "Skill types for labor growth assumptions" /

   Labour      "Total Labour Force"
/ ;

set educMap(r,l,edx) "Mapping of skills to education levels" /
   CHN     .Labour .elev0
   CHN     .Labour .elev1
   CHN     .Labour .elev2
   IND     .Labour .elev0
   IND     .Labour .elev1
   IND     .Labour .elev2
   PAK     .Labour .elev0
   PAK     .Labour .elev1
   PAK     .Labour .elev2
   USA     .Labour .elev0
   USA     .Labour .elev1
   USA     .Labour .elev2
   ARM     .Labour .elev0
   ARM     .Labour .elev1
   ARM     .Labour .elev2
   AZE     .Labour .elev0
   AZE     .Labour .elev1
   AZE     .Labour .elev2
   GEO     .Labour .elev0
   GEO     .Labour .elev1
   GEO     .Labour .elev2
   KAZ     .Labour .elev0
   KAZ     .Labour .elev1
   KAZ     .Labour .elev2
   KGZ     .Labour .elev0
   KGZ     .Labour .elev1
   KGZ     .Labour .elev2
   TJK     .Labour .elev0
   TJK     .Labour .elev1
   TJK     .Labour .elev2
   UZB     .Labour .elev0
   UZB     .Labour .elev1
   UZB     .Labour .elev2
   BHR     .Labour .elev0
   BHR     .Labour .elev1
   BHR     .Labour .elev2
   IRQ     .Labour .elev0
   IRQ     .Labour .elev1
   IRQ     .Labour .elev2
   IRN     .Labour .elev0
   IRN     .Labour .elev1
   IRN     .Labour .elev2
   JOR     .Labour .elev0
   JOR     .Labour .elev1
   JOR     .Labour .elev2
   OMN     .Labour .elev0
   OMN     .Labour .elev1
   OMN     .Labour .elev2
   QAT     .Labour .elev0
   QAT     .Labour .elev1
   QAT     .Labour .elev2
   SAU     .Labour .elev0
   SAU     .Labour .elev1
   SAU     .Labour .elev2
   ARE     .Labour .elev0
   ARE     .Labour .elev1
   ARE     .Labour .elev2
   EGY     .Labour .elev0
   EGY     .Labour .elev1
   EGY     .Labour .elev2
   MAR     .Labour .elev0
   MAR     .Labour .elev1
   MAR     .Labour .elev2
   TUN     .Labour .elev0
   TUN     .Labour .elev1
   TUN     .Labour .elev2
   EUR     .Labour .elev0
   EUR     .Labour .elev1
   EUR     .Labour .elev2
   MCD     .Labour .elev0
   MCD     .Labour .elev1
   MCD     .Labour .elev2
   REU     .Labour .elev0
   REU     .Labour .elev1
   REU     .Labour .elev2
   APD     .Labour .elev0
   APD     .Labour .elev1
   APD     .Labour .elev2
   AFR     .Labour .elev0
   AFR     .Labour .elev1
   AFR     .Labour .elev2
   WHD     .Labour .elev0
   WHD     .Labour .elev1
   WHD     .Labour .elev2
/ ;

SET tota(is) / tot, TotEly /;

*------------------------------------------------------------------------------*
*              Additional sector and commodity Sets for OECD-ENV               *
*------------------------------------------------------------------------------*

*-----------------------    Activities    -------------------------------------*

set forestrya(a)  "Forestry sector" /    frs-a       "Forestry" / ;
set fisherya(a)  "Fisheries sector" / / ;

*    Energy Intensive Industries:

set frta(a)  "Fertilizer/Chemicals" / / ;
set cementa(a)  "Non-metallic minerals" / / ;
set PPPa(a)  "Paper & Paper Products" / / ;
set I_Sa(a)  "Iron and Steel" / / ;

*    Other Manufacturing:

set ELEa(a)  "Electronic sectors" / / ;
set FMPa(a)  "Fabricated metal sectors" / / ;
set wooda(a)  "Wood sector" / / ;
set MTEa(a)  "Manuf. of transport equipement and vehicles" / / ;
set NFMa(a)  "Non-Ferrous Metals" / / ;
set omana(a)  "Other manufacturing sectors" / / ;
set FDPa(a)  "Food products sectors" / / ;
set TXTa(a)  "Textiles sectors" / / ;

*    Other Industries non-manufacturing:

set COAa(a)  "Coal extraction" /    coa-a       "Coal extraction" / ;
set COILa(a)  "Crude oil extraction" /    oil-a       "Crude oil extraction" / ;
set ROILa(a)  "Petroleum and coal products" /    p_c-a       "Petroleum & coal prod." / ;
set NGASa(a)  "Nat. gas: extraction plus manufacture & distribution" /    gas-a       "gas" / ;
set GDTa(a)  "Nat. gas: manufacture & distribution" / / ;
set mininga(a)  "Other mining products" / / ;
set constructiona(a)  "Construction sectors" /    cns-a       "Construction" / ;

*    Services:

set pubserva(a)  "Collective services (Government)" /    osg-a       "Other collective services" / ;
set privserva(a)  "Other business services sectors" /    osc-a       "Other Business services" / ;
set transporta(a)  "Transportation services" /    otp-a       "Transport" / ;

*---------------------      Commodities      ----------------------------------*

set cri(i)  "Crop products" /    agr-c       "Agriculture" / ;
set lvi(i)  "Livestock products" / / ;
set forestryi(i)  "Forestry sector" /    frs-c       "Forestry" / ;
set fisheryi(i)  "Fisheries sector" / / ;

*    Energy Intensive Goods:

set PPPi(i)  "Paper & Paper Products" / / ;
set cementi(i)  "Non-metallic minerals" / / ;
set I_Si(i)  "Iron and Steel" / / ;

*    Other Manufacturing Goods:

set ELEi(i)  "Electronic goods" / / ;
set FDPi(i)  "Food products" / / ;
set TXTi(i)  "Textiles products" / / ;
set NFMi(i)  "Non-Ferrous Metals" / / ;
set FMPi(i)  "Fabricated metal products" / / ;
set MTEi(i)  "Transport equipement and vehicles commodities" / / ;
set woodi(i)  "Wood products" / / ;
set omani(i)  "Other Manufacturing commodities" /    oma-c       "Other manufacturing" / ;

*    Other Industries non-manufacturing Goods:

set COAi(i)  "Coal extraction" /    coa-c       "Coal extraction" / ;
set COILi(i)  "Crude oil extraction" /    oil-c       "Crude oil extraction" / ;
set ROILi(i)  "Petroleum and coal products" /    p_c-c       "Petroleum & coal prod." / ;
set NGASi(i)  "Natural gas: extraction, manufacture & distribution" /    gas-c       "Natural gas: manufacture & distribution" / ;
set GDTi(i)  "Natural gas: manufacture & distribution" / / ;
set miningi(i)  "Other mining products" / / ;
set constructioni(i)  "Construction sectors" /    cns-c       "Construction" / ;
set wtri(i)  "Water supply; sewerage; waste management and remediation activities" / / ;

*    Services:

set pubservi(i)  "Collective services (Government)" /    osg-c       "Other collective services" / ;
set privservi(i)  "Other business services sectors" /    osc-c       "Other Business services" / ;

*------------------------------------------------------------------------------*
*    Additional regional Sets as function of (r) for OECD-ENV                  *
*------------------------------------------------------------------------------*

*  make a dedicated subset of r for each region

SETS
    PAK(r)  "Pakistan"                   / PAK /
    KAZ(r)  "Kazakhstan"                 / KAZ /
    KGZ(r)  "Kyrgyzstan"                 / KGZ /
    TJK(r)  "Tajikistan"                 / TJK /
    UZB(r)  "Uzbekistan"                 / UZB /
    ARM(r)  "Armenia"                    / ARM /
    AZE(r)  "Azerbaijan"                 / AZE /
    GEO(r)  "Georgia"                    / GEO /
    BHR(r)  "Bahrain"                    / BHR /
    IRN(r)  "Iran (Islamic Republic of)" / IRN /
    IRQ(r)  "Iraq"                       / IRQ /
    JOR(r)  "Jordan"                     / JOR /
    OMN(r)  "Oman"                       / OMN /
    QAT(r)  "Qatar"                      / QAT /
    SAU(r)  "Saudi Arabia"               / SAU /
    ARE(r)  "United Arab Emirates"       / ARE /
    EGY(r)  "Egypt"                      / EGY /
    MAR(r)  "Morocco"                    / MAR /
    TUN(r)  "Tunisia"                    / TUN /
    MCD(r)  "Rest of MCD"                / MCD /
    USA(r)  "United States of America"   / USA /
    EUR(r)  "EU27 + UK + EFTA"           / EUR /
    CHN(r)  "China"                      / CHN /
    IND(r)  "India"                      / IND /
    REU(r)  "Rest of Europe"             / REU /
    APD(r)  "Asia-pasific"               / APD /
    AFR(r)  "Africa"                     / AFR /
    WHD(r)  "Western Hemisphere"         / WHD /
;
