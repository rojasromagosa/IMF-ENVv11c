$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
    GAMS file : ""%iFilesDir%\specific_sets_NGFS.gms"
    purpose   : Defining new set to be used for SimGroup "NGFS"
    called by : "%ModelDir%\2-CommonIns.gms
    created   : 2025-03-11
    created by: Hugo Rojas-Romagosa
--------------------------------------------------------------------------------
$OffText

$Onempty

SETS

agaDB(*) "Aggregate set for Dashboard" / cro-a, lvs-a, frs-a, fsh-a, cns-a, OMN-a, wts-a, coa-a, oil-a, p_c-a, gas-a, clp-a, olp-a,
                                         gsp-a, nuc-a, hyd-a, wnd-a, sol-a, xel-a, etd-a, ppp-a, nmm-a, i_s-a, crp-a, nfm-a, ele-a,
                                         fdp-a, txt-a, mvh-a, fmp-a, oma-a, wtp-a, atp-a, otp-a, osg-a, osc-a,
                                         tagr, tfex, tfel, trel, teim, toma, ttrs, tosr  /

agaDB2(*) "Aggregate set for Dashboard"/ cro-a, lvs-a, frs-a, fsh-a, cns-a, OMN-a, wts-a, coa-a, oil-a, p_c-a, gas-a, clp-a, olp-a,
                                         gsp-a, nuc-a, hyd-a, wnd-a, sol-a, xel-a, etd-a, ppp-a, nmm-a, i_s-a, crp-a, nfm-a, ele-a,
                                         fdp-a, txt-a, mvh-a, fmp-a, oma-a, wtp-a, atp-a, otp-a, osg-a, osc-a,
                                         tagr,       tfel, trel, teim, toma, ttrs, tosr,  tcoa, toil, tgas /

mapagaDB1(agaDB,a) "Mapping of aggregate sectors for Dashboard, short version (8 agg sectors)" /
tagr.cro-a
tagr.lvs-a
tagr.frs-a
tagr.fsh-a
tosr.cns-a
toma.OMN-a
tosr.wts-a
tfex.coa-a
tfex.oil-a
teim.p_c-a
tfex.gas-a
tfel.clp-a
tfel.olp-a
tfel.gsp-a
trel.nuc-a
trel.hyd-a
trel.wnd-a
trel.sol-a
trel.xel-a
tfel.etd-a
teim.ppp-a
teim.nmm-a
teim.i_s-a
teim.crp-a
teim.nfm-a
toma.ele-a
toma.fdp-a
toma.txt-a
toma.mvh-a
teim.fmp-a
toma.oma-a
ttrs.wtp-a
ttrs.atp-a
ttrs.otp-a
tosr.osg-a
tosr.osc-a
/

mapagaDB2(agaDB2,a) "Mapping of aggregate sectors for Dashboard, long version (10 agg sectors)" /
tagr.cro-a
tagr.lvs-a
tagr.frs-a
tagr.fsh-a
tosr.cns-a
toma.OMN-a
tosr.wts-a
tcoa.coa-a
toil.oil-a
teim.p_c-a
tgas.gas-a
tfel.clp-a
tfel.olp-a
tfel.gsp-a
trel.nuc-a
trel.hyd-a
trel.wnd-a
trel.sol-a
trel.xel-a
tfel.etd-a
teim.ppp-a
teim.nmm-a
teim.i_s-a
teim.crp-a
teim.nfm-a
toma.ele-a
toma.fdp-a
toma.txt-a
toma.mvh-a
teim.fmp-a
toma.oma-a
ttrs.wtp-a
ttrs.atp-a
ttrs.otp-a
tosr.osg-a
tosr.osc-a
/

mapagcDBK(agcDBK,i) "Mapping of aggregate commodities for Dashboard" /

cfood.cro-c
cfood.lvs-c
cfood.frs-c
cfood.fsh-c
cpris.cns-c
ccong.OMN-c
cpubs.wts-c
conrg.coa-c
conrg.oil-c
conrg.p_c-c
conrg.gas-c
celcy.ely-c
ccong.ppp-c
ccong.nmm-c
ccong.i_s-c
ccong.crp-c
ccong.nfm-c
ccapg.ele-c
cfood.fdp-c
ccong.txt-c
ccapg.mvh-c
ccapg.fmp-c
ccong.oma-c
ctran.wtp-c
ctran.atp-c
ctran.otp-c
cpubs.osg-c
cpris.osc-c
/


mapagcDBK2(agcDBK2,i) "Mapping of aggregate commodities for Dashboard, long version (10 agg sectors)" /
cagr.cro-c
cagr.lvs-c
cagr.frs-c
cagr.fsh-c
cosr.cns-c
coma.OMN-c
cosr.wts-c
ccoa.coa-c
coil.oil-c
ceim.p_c-c
cgas.gas-c
cely.ely-c
ceim.ppp-c
ceim.nmm-c
ceim.i_s-c
ceim.crp-c
ceim.nfm-c
coma.ele-c
coma.fdp-c
coma.txt-c
coma.mvh-c
ceim.fmp-c
coma.oma-c
ctrs.wtp-c
ctrs.atp-c
ctrs.otp-c
cosr.osg-c
cosr.osc-c
/

mapa2i(a,i) "Mapping from commodities to activities" /
cro-a.cro-c
lvs-a.lvs-c
frs-a.frs-c
fsh-a.fsh-c
cns-a.cns-c
OMN-a.OMN-c
wts-a.wts-c
coa-a.coa-c
oil-a.oil-c
p_c-a.p_c-c
gas-a.gas-c
etd-a.ELY-c
ppp-a.ppp-c
nmm-a.nmm-c
i_s-a.i_s-c
crp-a.crp-c
nfm-a.nfm-c
ele-a.ele-c
fdp-a.fdp-c
txt-a.txt-c
mvh-a.mvh-c
fmp-a.fmp-c
oma-a.oma-c
wtp-a.wtp-c
atp-a.atp-c
otp-a.otp-c
osg-a.osg-c
osc-a.osc-c
/

;
