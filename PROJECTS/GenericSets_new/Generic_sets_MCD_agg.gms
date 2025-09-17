$OnText
--------------------------------------------------------------------------------
                        IMF-ENV Model 
    GAMS file : ""%iFilesDir%\Generic_sets_MCD_agg.gms"
    purpose   : Defining new set to be used for MCD regional aggregation 
    called by : "%ModelDir%\2-CommonIns.gms
    created   : 2025-03-11
    created by: Hugo Rojas-Romagosa
--------------------------------------------------------------------------------
$OffText

$Onempty

***********************************
*** MCD specific sets

SETS

cbami(i)     "CBAM sectors" / eim-c, oma-c, ely-c/
mina(a)     "Mining activities" / gas-a, coa-a, oil-a, p_c-a /
ch4excl(a)  "Activities excl. from methane emissions" / otp-a, gas-a, coa-a, oil-a, p_c-a, clp-a, olp-a, gsp-a, nuc-a, wnd-a, sol-a, xel-a, hyd-a, etd-a /
mana2(a)     "Manuf. activities" / eim-a, oma-a /

NGFS_sce        "NGFS v4 scenarios" /
                 CurrentPol          "Current policies: used as baseline "
                 NDCs                "National Determined Contributions"
                 DelayTran           "Delayed transition"
                 Below2c             "Below 2C"
                 NetZero2050         "Net Zero 2050"
                 Midpoint            "Midpoint between NDC and NetZero2050"
                 MidNDC              "Midpoint between CurrentPol and NDC"
                 /

agaDB(*) "Aggregate set for Dashboard" / agr-a, frs-a, coa-a, oil-a, gas-a, clp-a, olp-a, gsp-a, nuc-a, hyd-a, wnd-a
                                         sol-a, xel-a, etd-a, p_c-a, eim-a, oma-a, cns-a, otp-a, osc-a, osg-a, 
                                         tagr, tfex, tfel, trel, teim, toma, ttrs, tosr  /

agaDB2(*) "Aggregate set for Dashboard"/ agr-a, frs-a, coa-a, oil-a, gas-a, clp-a, olp-a, gsp-a, nuc-a, hyd-a, wnd-a
                                         sol-a, xel-a, etd-a, p_c-a, eim-a, oma-a, cns-a, otp-a, osc-a, osg-a,
                                         tagr,       tfel, trel, teim, toma, ttrs, tosr,  tcoa, toil, tgas /

mapagaDB1(agaDB,a) "Mapping of aggregate sectors for Dashboard, short version (8 agg sectors)" /
tagr.agr-a 
tagr.frs-a 
tfex.coa-a 
tfex.oil-a 
tfex.gas-a 
tfel.clp-a 
tfel.olp-a 
tfel.gsp-a 
trel.nuc-a 
trel.hyd-a 
trel.wnd-a 
trel.sol-a 
trel.xel-a 
trel.etd-a 
teim.p_c-a 
teim.eim-a 
toma.oma-a 
tosr.cns-a 
ttrs.otp-a 
tosr.osc-a 
tosr.osg-a 
/

mapagaDB2(agaDB2,a) "Mapping of aggregate sectors for Dashboard, long version (10 agg sectors)" /
tagr.agr-a 
tagr.frs-a 
tcoa.coa-a 
toil.oil-a 
tgas.gas-a 
tcoa.clp-a 
tfel.olp-a 
tfel.gsp-a 
trel.nuc-a 
trel.hyd-a 
trel.wnd-a 
trel.sol-a 
trel.xel-a 
trel.etd-a 
teim.p_c-a 
teim.eim-a 
toma.oma-a 
tosr.cns-a 
ttrs.otp-a 
tosr.osc-a 
tosr.osg-a 
/


mapagcDBK(agcDBK,i) "Mapping of aggregate commodities for Dashboard" /

cfood.agr-c
cfood.frs-c
cpris.cns-c
conrg.coa-c
conrg.oil-c
conrg.p_c-c
conrg.gas-c
celcy.ely-c
ccong.eim-c
ccapg.oma-c
ctran.otp-c
cpubs.osg-c
cpris.osc-c
/


mapagcDBK2(agcDBK2,i) "Mapping of aggregate commodities for Dashboard, long version (10 agg sectors)" /
cagr.agr-c
cagr.frs-c
cosr.cns-c
ccoa.coa-c
coil.oil-c
ceim.p_c-c
cgas.gas-c
cely.ely-c
ceim.eim-c
coma.oma-c
ctrs.otp-c
cosr.osg-c
cosr.osc-c
/

;

Parameter
    ElyMixCal(r,a,NGFS_sce,tt)      "ElyMix projections for calibration by NGFS scenario and by generation source (elya)"
    EmiTotCal(r,NGFS_sce,tt)        "Total GHG Emissions projections for calibration by NGFS scenario "
;


EITEa("eim-a") = yes ;
EITEa("p_c-a") = yes ;

