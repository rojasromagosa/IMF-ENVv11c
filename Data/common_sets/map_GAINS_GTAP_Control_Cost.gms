*       Control costs                       | ENV_Linkages Source | GTAP agent

*------------------------------------------------------------------------------*
*                         Process Polution (+ BOILERS)                         *
*------------------------------------------------------------------------------*

*---     process act <-- NatRes


(AUTO_P,AUTO_P_NEW) . NatRes . mvh
CONSTRUCT           . NatRes . cns

(PR_ALPRIM, PR_ALSEC)       . NatRes .  nfm
(PR_CAST,PR_CAST_F)         . NatRes .  i_s
(PR_OT_NFME,PR_EARC)        . NatRes .  nfm
(PR_BAOX,PR_COKE,PR_HEARTH,PR_PIGI,PR_PIGI_F,PR_SINT,PR_SINT_F). NatRes .i_s

(MINE_BC,MINE_HC,Coal_mining)  . NatRes        .  coa

*---    Pulp & paper
(PR_PULP,IN_BO_PAP)            . NatRes        .  ppp
*---    Publishing: printing, rotogravure
(PRT_OFFS,PRT_OFFS_NEW,PRT_PACK,PRT_PACK_NEW,PRT_PUB,PRT_PUB_NEW,PRT_SCR,PRT_SCR_NEW). NatRes .  ppp

*---    [To be reallocated] between food sectors (CH4)
FOOD. NatRes .  ofd

*---    boilers [To be reallocated] between other industries (sauf crp,ppp,p_c)
(IN_BO_OTH,IN_BO_OTH_L,IN_BO_OTH_S) . NatRes  .  ele

* Fuel production + industrial furnaces
(PR_BRICK,PR_BRIQ)                         . NatRes        .  p_c
(PR_REF,WASTE_FLR,IN_BO_CON)               . NatRes        .  p_c
* + Fuel conversion (CON_COMB)
(CON_COMB,CON_COMB1,CON_COMB2,CON_COMB3)   . NatRes        .  p_c
(IN_OC,IN_OC3).NatRes.p_c
(PR_CBLACK,STCRACK_PR).NatRes.p_c

(PR_CEM,PR_GLASS,PR_LIME)                  . NatRes        .  nmm


(EXD_LQ,EXD_LQ_NEW,FATOIL)    . NatRes        .  oil

*--- Production of oil or gas: venting of flaring of APG [To be allocated]
PROD_AGAS . NatRes        .  gas

$ifTheni.gtap10 NOT %GTAP_ver%=="92"
    MINE_OTH.NatRes.oxt
$else.gtap10
    MINE_OTH.NatRes.omn
$endif.gtap10

$ifTheni.gtap10 NOT %GTAP_ver%=="92"
    (PR_FERT,PR_NIAC,FERTPRO,IN_BO_CHEM) . NatRes . chm
    PHARMA                               . NatRes . bph
    (PLSTYR_PR,PR_SUAC,PVC_PR,PR_CSP)    . NatRes . chm
* Organic chemical industry
    (ORG_STORE,OTH_ORG_PR)               . NatRes . chm
    (SYNTH_RUB,PR_OTHER)                 . NatRes . rpp

$else.gtap10
    (PR_FERT,PR_NIAC,FERTPRO,IN_BO_CHEM) . NatRes . crp
    PHARMA                               . NatRes . crp
    (PLSTYR_PR,PR_SUAC,PVC_PR,PR_CSP)    . NatRes . crp
    (ORG_STORE,OTH_ORG_PR)               . NatRes . crp
    (SYNTH_RUB,PR_OTHER)                 . NatRes . crp
$endif.gtap10

WIRE.NatRes.fmp

* unclear, take out
WOOD.NatRes.lum


*------------------------------------------------------------------------------*
*                   Agriculture Emissions                                      *
*------------------------------------------------------------------------------*
* (CH4)

AGR_BEEF                       . Capital  . ctl
AGR_COWS                       . Capital  . rmk
(AGR_OTANI,AGR_PIG,AGR_POULT)  . Capital  . oap

* To be allocated across livestock
(GRAZE_L,GRAZE_M,GRAZE_S)      . Land     . ctl

RICE                           . Land     . pdr

*---    [To be reallocated] between crops
(AGR_ARABLE,WASTE_AGR)         . NatRes   . wht

*------------------------------------------------------------------------------*
*                       Transportation Cost                                    *
*------------------------------------------------------------------------------*

(TRA_OT_INW,TRA_OTS_L,TRA_OTS_M) . otn . wtp

TRA_OT_RAI                       . otn . otp

*---    Avion?:  'Non-road, other'
TRA_OT . otn . atp

*       'Transport:Construction machinery'
TRA_OT_CNS.otn.cns

*---    'Transport:Agriculture' [To be reallocated] between crops (not mvh)
TRA_OT_AGR.ome.wht

*---    To be allocated somewhere: 'Transport:Other non-road machinery'
* TRA_OT_LB

* '2-stroke engines (non-road)' + Motorcycles'
* + 'Generic road vehicles as 3-wheelers and others
* + 'Mopeds'
* Manufacture of motorcycles ---> otn
(TRA_RD_LD2,TRA_OT_LD2,TRA_RD_M4,TRA_RD_OTH).otn.hh


*       'Buses' ---> une partie osg?
TRA_RD_HDB              . mvh . otp

(TRA_RD_HDT,TRA_RD_LD2) . mvh . otp

* cars + LD vehicles To be allocated between hh, otp and obs
(TRA_RD_LD4C,TRA_RD_LD4T)   .   mvh .   obs

*------------------------------------------------------------------------------*
*                       Power Cost                                             *
*------------------------------------------------------------------------------*

*---    Energy sectors:
$IfTheni.power %ifPower%=="ON"
    (PP_EX_L,PP_EX_S,PP_NEW_L)   . capital  . CoalBL
    PP_ENG                       . capital  . OilBL
    (PP_EX_OTH,PP_NEW)           . capital  . GasBL
* To be allocated between Gas and Coal
    PP_MOD . NatRes  . CoalBL
$ELSE.power
    (PP_MOD,PP_EX_L,PP_EX_S,PP_NEW_L,PP_ENG,PP_EX_OTH,PP_NEW) . capital  . ELY
$ENDIF.power

*------------------------------------------------------------------------------*
*                       Chemical uses                                          *
*------------------------------------------------------------------------------*

*    chm   "Chemical products"           !! from old crp sector: ManufNatResure of chemicals and chemical products (e.g ManufNatResure of basic chemicals, fertilizers and nitrogen compounds, plastics and synthetic rubber in primary forms)
*    bph   "Basic pharmaceuticals"       !! from old crp sector: ManufNatResure of pharmaceuticals, medicinal chemical and botanical products
*    rpp   "Rubber and plastic products" !! from old crp sector: ManufNatResure of rubber and plastics products (includes manufNatResure of plastic articles for the packing of goods)

*---    Chemical uses

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    WOOD_P  .chm.lum
    WIRE    .rpp.fmp
    LEATHER .rpp.lea
    SHOE    .rpp.wap
    DOM_OS  .chm.hh
$else.gtap10
    WOOD_P .crp.lum
    WIRE   .crp.fmp
    LEATHER.crp.lea
    SHOE   .crp.wap
    DOM_OS .crp.hh
$endif.gtap10

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    DECO_P.chm.hh
$else.gtap10
   DECO_P.crp.hh
$endif.gtap10

*---    Dry Cleaning
(DRY,DRY_NEW) . chm .  trd

*------------------------------------------------------------------------------*
*                       Heating and Cooking Equipment                          *
*------------------------------------------------------------------------------*
* sont en fait dans les equipements electriques

* stoves
$ifTheni.gtap10 NOT %GTAP_ver%=="92"
    (DOM_STOVE_C,DOM_STOVE_H).eeq.hh
$else.gtap10
    (DOM_STOVE_C,DOM_STOVE_H).ome.hh
$endif.gtap10

* boilers + Fireplaces
(DOM_SHB_A,DOM_SHB_M,DOM_FPLACE,DOM_LIGHT).fmp.hh

* Chauffage central immeuble à allouer menages + residentiel + dwellings ?
(DOM_MB_A,DOM_MB_M).fmp.dwe

* autre à allouer menages + residentiel
DOM.ome.obs

*------------------------------------------------------------------------------*
*                   Waste emissisons                                           *
*------------------------------------------------------------------------------*

(CH4)

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    (MSW_FOOD,MSW_OTH,MSW_PAP,MSW_PLA,MSW_TEX,MSW_WOOD) . NatRes .  wtr
$else.gtap10
    (MSW_FOOD,MSW_OTH,MSW_PAP,MSW_PLA,MSW_TEX,MSW_WOOD) . NatRes .  osg
$endif.gtap10
