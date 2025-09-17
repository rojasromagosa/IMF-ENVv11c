$OnText
--------------------------------------------------------------------------------
                        IMF-ENV Model 
    GAMS file : ""%iFilesDir%\Generic_sets_NGFS.gms"
    purpose   : Defining new set to be used for GroupName "NGFS"
    called by : "%ModelDir%\2-CommonIns.gms
    created   : 2025-03-11
    created by: Hugo Rojas-Romagosa
--------------------------------------------------------------------------------
$OffText

$Onempty

*------------------------------------------------------------------------------*
*                        Regional subsets                                      *
*------------------------------------------------------------------------------*

SETS

NGFS_sce        "NGFS v4 scenarios" /
                 CurrentPol          "Current policies: used as baseline "
                 NDCs                "National Determined Contributions"
                 DelayTran           "Delayed transition"
                 Below2c             "Below 2C"
                 NetZero2050         "Net Zero 2050"
                 Midpoint            "Midpoint between NDC and NetZero2050"
                 MidNDC              "Midpoint between CurrentPol and NDC"
                 /
NGFS_source     "NGFS v4 power sources" / coal, oil, gas, nuclear, hydro, solar, wind, biomass, geothermal /

eff(e)         "Fuel energy" / oil-c, p_c-c /
meta(a)        "Methane targets" / oil-a, p_c-a, gas-a /
ctaxcan(aa)    "Canada: Sectors included in p_emissions 2018-2023" / p_c-a,  clp-a, olp-a, gsp-a,
                             nuc-a, hyd-a, wnd-a, sol-a, xel-a, etd-a, ppp-a, nmm-a,
                            i_s-a, crp-a, nfm-a, ele-a, fdp-a, txt-a, mvh-a, fmp-a, oma-a, wtp-a, atp-a,
                            otp-a, osg-a, osc-a / !!,coa-a, oil-a,omn-a, gas-a, wts-a, cns-a, hhd
ctaxcan2(aa)    "Canada: Sectors included in ctax 2024-2030" / p_c-a,  clp-a, olp-a, gsp-a, coa-a, oil-a,omn-a, gas-a, wts-a, hhd ,
                             nuc-a, hyd-a, wnd-a, sol-a, xel-a, etd-a, ppp-a, nmm-a,
                            i_s-a, crp-a, nfm-a, ele-a, fdp-a, txt-a, mvh-a, fmp-a, oma-a, wtp-a, atp-a,
                            otp-a, osg-a, osc-a / !!
FFelya(a)      "Fossil fuel electricity generation activities" / olp-a, gsp-a /

lulucfa(a)     "Sectors that contribute to LULUCF emissions" /frs-a,lvs-a,cro-a/

G20(r)         "G20 countries" / AUS, CHN, JPN, KOR, IDN, IND, CAN, USA, MEX, ARG, BRA, FRA, DEU, ITA,
                                 REU, GBR, TUR, RUS, SAU, ZAF/
G20_high(r)    "High-income G20 countries" / AUS, JPN, KOR, CAN, USA, FRA, DEU, ITA, REU, GBR, SAU /
G20_low(r)     "Low- and medium-income G20 countries" / CHN, IDN, IND, MEX, ARG, BRA, TUR, RUS, ZAF /

gcam "GCAM model regions" / Africa_Eastern, Africa_Northern, Africa_Southern, Africa_Western, Argentina,
                            Australia_NZ, Brazil, Canada, Central_America_Caribbean, Central_Asia, China,
                            Colombia, EU_12, EU_15, Europe_Eastern, Europe_Non_EU, EFTA, India, Indonesia,
                            Japan, Mexico, Middle_East, Pakistan, Russia, South_Africa, South_America_Northern,
                            South_America_Southern, South_Asia, South_Korea, Southeast_Asia, Taiwan, USA /
gcam_iso "GCAM model ISO3"
/ bdi, com, dji, eri, eth, ken, mdg, mus, reu, rwa, sdn, som, ssd, uga, dza, egy, esh, lby, mar, tun, ago, bwa,
  lso, moz, mwi, nam, swz, tza, zmb, zwe, ben, bfa, caf, civ, cmr, cod, cog, cpv, gab, gha, gin, gmb, gnb, gnq,
  lbr, mli, mrt, ner, nga, sen, sle, stp, tcd, tgo, arg, aus, nzl, bra, can, abw, aia, ant, atg, bhs, blz, bmu,
  brb, cri, cub, cuw, cym, dma, dom, glp, grd, gtm, hnd, hti, jam, kna, lca, msr, mtq, nic, pan, slv, tto, vct,
  arm, aze, geo, kaz, kgz, mng, tjk, tkm, uzb, chn, hkg, mac, col, bgr, cyp, cze, est, hun, ltu, lva, mlt, pol,
  rom, rou, svk, svn, and, aut, bel, chi, deu, dnk, esp, fin, flk, fra, fro, gbr, ggy, gib, grc, grl, imn, irl,
  ita, jey, lux, mco, nld, prt, shn, smr, spm, swe, tca, vat, vgb, wlf, blr, mda, ukr, alb, bih, hrv, mkd, mne,
  scg, srb, tur, yug, che, isl, lie, nor, sjm, ind, idn, jpn, mex, are, bhr, irn, irq, isr, jor, kwt, lbn, omn,
  pse, qat, sau, syr, yem, pak, rus, zaf, guf, guy, sur, ven, bol, chl, ecu, per, pry, ury, afg, bgd, btn, lka,
  mdv, npl, kor, asm, brn, cck, cok, cxr, fji, fsm, gum, khm, kir, lao, mhl, mmr, mnp, mys, myt, ncl, nfk, niu,
  nru, pci, pcn, phl, plw, png, prk, pyf, sgp, slb, syc, tha, tkl, tls, ton, tuv, vnm, vut, wsm, twn, pri, usa,
  vir /

**No matches for: TUR, FRA, ITA, GBR, SAU
mapgcam(gcam,r) "Mapping from GCAM regions to model regions" /
Africa_Eastern.OAF
Africa_Northern.OAF
Africa_Southern.OAF
Africa_Western.OAF
Argentina.ARG
Australia_NZ.AUS
Brazil.BRA
Canada.CAN
Central_America_Caribbean.OLA
Central_Asia.OEA
China.CHN
Colombia.OLA
EU_12.DEU
EU_15.REU
Europe_Eastern.OEA
Europe_Non_EU.OEA
EFTA.REU
India.IND
Indonesia.IDN
Japan.JPN
Mexico.MEX
Middle_East.ROP
Pakistan.ODA
Russia.RUS
South_Africa.ZAF
South_America_Northern.OLA
South_Asia.ODA
South_Korea.KOR
Southeast_Asia.ODA
Taiwan.ODA
USA.USA
/
;


alias(elya,elya2) ;
alias (lulucfa0, lulucfa);


PARAMETER
    LULUCF_NGFS(NGFS_sce,gcam,tt)   "LULUCF data from NGFS: MT CO2-eq"
    LULUCF_NGFS_agg(r,NGFS_sce,tt)  "LULUCF MT CO2 aggregated to model regions"
    LULUCF_perYear(r,NGFS_sce)      "LULUCF MT CO2 reductions by year from 2025 to 2040"
    tempLU1(r,NGFS_sce)
    EVpar(r,tt)                     "EV penetration parameter"
    ElyMixCal(r,a,NGFS_sce,tt)      "NGFS ElyMix projections by scenario by generation source (elya)"
    ElyMixNGFS(NGFS_sce,r,NGFS_source,tt)     "NGFS ElyMix projections by scenario"
    EmiTotCal(r,NGFS_sce,tt)        "Total GHG Emissions from NGFS"
    Chronic_risks(r,t,*)     "Chronic risks from NGFS: percentage changes wrt baseline real GDP values"
    Transition_risks(r,t,*)  "Transitional risks from NGFS: percentage changes wrt baseline real GDP values"
***HRR: added to use NGFS-MCM external data
    ExternalData(r,t,*,*,*,*,*) "NGFS-MCM external data"
    NDC_GDP(r,t)
    proj_GHG_lulucf_curpol(r,t)
    proj_GHG_lulucf_FrgWld(r,t)
    proj_GHG_lulucf_NDC(r,t)
    CarbonTax_FrgWld(r,t)
    CarbonTax_NDC(r,t)
    CarbonTax_NetZero(r,t)
;

***********************************************************************
*CCUS
Parameter
    CCUS_ratio(r,NGFS_sce,tt)       "CCUS data from NGFS: ratio of CCUS in as a share of 2020 emissions"
    CCUSperYear(r,NGFS_sce,tt)      "CCUS MT CO2 reductions by year from 2030 to 2040"
    CCUS_totcost(r,NGFS_sce,tt)      "Total CCUS costs in million US$"
    CCUS_check(r,NGFS_sce,tt)
    CCUS_check2(ra,tt)
;

    CCUS_check2(ra,tt) = 0 ;
    CCUSperYear(r,NGFS_sce,tt) = 0 ; 
*** Broad CCUS costs provided by Sha Yu (MCM)
parameter CCUS_unitcost(r)  "CCUS costs in US$ per CO2 ton" /
AUS     133,
CHN     80,
JPN     94,
IND     94,
USA     87,
RUS     100,
ARG     100,
BRA     100,
CAN     120,
IDN     92,
KOR     111,
MEX     94,
SAU     80,
ZAF     100,
TUR     100,
FRA     109,
DEU     136,
GBR     136,
ITA     136,
REU     109,
ROP     94,
ODA     94,
OAF     94,
OEA     100,
OLA     100 
/

*** GFCF in million US$ (2023 or 2022)  taken from WDI (WDI_GFCF_currentUS$.xls)
GFCF(r)  "GFCF in million US$ per CO2 ton" /
AUS     399731.45,
CHN     7493287.23,
JPN     1105065.82,
IND     1112167.28,
USA     5476099.00,
RUS     441932.98,
ARG     122191.26,
BRA     359497.14,
CAN     489439.05,
IDN     402162.53,
KOR     550840.67,
MEX     436588.31,
SAU     297794.40,
ZAF     57246.74,
TUR     358685.01,
FRA     751586.58,
DEU     977692.82,
GBR     610175.59,
ITA     477315.76,
REU     2226166.72,
ROP     752861.60,
ODA     1510595.63,
OAF     428337.15,
OEA     217846.00,
OLA     497510.23 
/
;
