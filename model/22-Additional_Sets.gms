$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
        GAMS file    : "%ModelDir%\22-Additional_Sets.gms"
        purpose      :  Define additional sets for [OECD-ENV] model that content
                                        always same elements or can be define from other sets
        created by   :  Jean Chateau
        called by    : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
        $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/22-Additional_Sets.gms $
        last changed revision:    $Rev: 517 $
        last changed date    :    $Date:: 2024-02-24 1#$
        last changed by      :    $Author: Chateau_J $
--------------------------------------------------------------------------------
    Some set definition of ENVISAGE previously declared in
    "%ModelDir%\26-model.gms" are moved here for convenience
        #Rev 514 - 23 Feb. 2024: Move gy's sets here
--------------------------------------------------------------------------------
$OffText

SETS

        gy(is) "Government revenue streams" /
                itax        "Indirect taxes"
                ptax        "Production taxes"
                vtax        "Factor taxes"
                vsub        "Factor supports"
                mtax        "Import taxes"
                etax        "Export taxes"
                ctax        "Carbon taxes"
                dtax        "Direct taxes"
        /

        itx(gy)  "Indirect taxes"       / itax /
        ptx(gy)  "Production taxes"     / ptax /
        vtx(gy)  "Factor taxes"         / vtax /
        vsub(gy) "Factor supports"      / vsub /
        mtx(gy)  "Import taxes"         / mtax /
        etx(gy)  "Export taxes"         / etax /
        ctx(gy)  "Carbon taxes"         / ctax /
        dtx(gy)  "Direct taxes"         / dtax /


    gdp_unit "units of account for GDP" /
        cur_usd     "current USD"
        cur_lcu     "current LCU (some unit are fictive baskets)"
        cur_itl     "current international USD"
        cst_lcu     "constant LCU (%YearBaseMER% year)"
        cst_usd     "constant USD (%YearBaseMER% year)"
        cst_itl     "constant international USD (%YearBaseMER% year)"
    /

    notlcu(gdp_unit) "USD or itl. USD units" /
        cur_usd     "current USD"
        cur_itl     "current international USD"
        cst_usd     "constant USD (%YearBaseMER% year)"
        cst_itl     "constant international USD (%YearBaseMER% year)"
    /

    gdp_definition "GDP measures (constant units are in %YearBaseMER% USD)" /
        "Factor Cost"              "(billions of USD)"
        "Market Prices"            "(billions of USD)"
        "Basic Prices"             "(billions of USD)"
        "Production Prices"        "(billions of USD)"
        "PPP"                      "(billions of USD) at %YearBasePPP% PPPs"
        "Market Prices Per Capita" "GDP per head, (thousands of USD)"
        "PPP Per Capita"           "GDP per head, (thousands of USD at %YearBasePPP% PPPs)"
    /

    units "Unit of account" /
        volume  "Physical unit"
        real    "Real Value (Constant USD)"
        nominal "Nominal Value (current numeraire unit)"
    /

    typevar "Type of variable (for output" /
        devtoBau            "Percentage change wrt another trajectory"
        abs                 "absolute numbers"
        pct                 "Percentage of the total/GDP"
        g_dev               "Rate of growth from t to t-1"
        ratio_to_%YearRef%  "Index to %YearRef%"
        target              "Exogenous Target"
    /

    mp_def(gdp_definition)  / "Market Prices" "(billions of USD)" /
    volume(units)     "Physical unit"     / volume /
    notvol(units)     "Monetary units"    / real, nominal /
    realunit(units)   "Constant USD unit" / real /
    abstype(typevar)   / abs /
    nodevtype(typevar)

* %folder_main%\aggregation\common_sets\setsGTAP.gms

    Setdemog "Demographic sets" /
        15Plus  "Population: 15 years old and more"
        65Plus  "Population: 65 years old and more"
        75plus  "Population: 75 years old and more"
        Total   "Population: Total"
        pop1574 "Population: Working age (Population 15-74)"
        drold   "Dependency ratio: for individuals 65 years old and more relative to the population 15 to 64"
        dryoung "Dependency ratio: for individuals 0 to 14 years old relative to the population 15 to 64"
    /

    WLD(ra)     "Aggregate" / WORLD /

;

nodevtype(typevar)    = YES ;
nodevtype("devtoBau") =  NO ;

*------------------------------------------------------------------------------*
*                       Sectoral sets                                          *
*------------------------------------------------------------------------------*

SETS
    agra(a)         "Agricultural activities"
    axa(a)          "All other activities"
    prima(a)        "Primary sector activities (ISIC: 1-5)"
    mana(a)         "Manufacturing activities (ISIC: 15-37)"
    nmaninda(a)     "Non Manufacture Industries (ISIC: 10-14 Mining and quarrying Plus ISIC 38-45: Public utilities & Construction"
    oila(a)         "Oil sectors"
    gasa(a)         "Gas sectors"
    fossilea(a)     "Fossil fuel: Extraction sectors"
*    pdt_emia(a)     "Fossil fuel: primary and secondary energy sectors" --> same as set fa(a)
    trueserva(a)    "Services excluding transportation services"
    srva(a)         "All Services activities (ISIC: 50-99)"
    servcnsa(a)     "Services sectors plus construction"
    EITEa(a)        "Energy Intensive and Trade Exposed industries (IEA definition)"
    OtherInda(a)    "Non-Energy Intensive industries"
    natra(a)        "Sector with a Natural Resource or Fixed factor"
    nrga(a)
    nnrga(a)
    ManPlusa(a)
    LandTrpa(a)     "Land Transport Services" / otp-a /

    elyantd(a)     "Power activities excluding T&D" /clp-a, olp-a, gsp-a, nuc-a, hyd-a, wnd-a, sol-a, xel-a/

;

alias (elyantd,elyantd2) ;
**ST <End>

agra(a) = cra(a) + lva(a);
axa(a) $ (NOT agra(a)) = YES ;

prima(a)     = agra(a) + forestrya(a) + fisherya(a);

trueserva(a) = pubserva(a) + privserva(a) ;
srva(a)      = transporta(a) + trueserva(a) ;
servcnsa(a)  = srva(a) + constructiona(a);

EITEa(a)     = frta(a) + cementa(a) + PPPa(a) + I_Sa(a) + NFMa(a);
mana(a)      = EITEa(a) + MTEa(a) + FMPa(a) + ELEa(a) + wooda(a) + FDPa(a)
             + TXTa(a) + omana(a) ;
oila(a)      = COILa(a) + ROILa(a) ;
gasa(a)      = NGASa(a) + GDTa(a) ;
fossilea(a)  = COAa(a) + COILa(a) + NGASa(a);
nmaninda(a)  = elya(a) + oila(a) + gasa(a) +  COAa(a) + constructiona(a)
             + wtra(a) + mininga(a);

* Memo: total industry (Secondary Sectors) is therefore mana(a) + nmaninda(a)

OtherInda(a) = mana(a) - EITEa(a);
natra(a)     = fossilea(a) + forestrya(a) + fisherya(a) + mininga(a);
ManPlusa(a)  = mana(a) + wtra(a) + ROILa(a) - FDPa(a);

NRGa(a)  = elya(a) + fa(a) ;
nNRGa(a) $ (nrga(a) or tota(a)) = NO ;

$OnText

*   For EU climate policies

SETS
    EUETS1a(a)
*    EUETS2a(a)
*    ESRa(a)
;

EUETS1a(a) = EITEa(a) + COAa(a) + wooda(a)
           + wtra(a) + oila(a) + gasa(a) + elya(a) ;

* wtp in 2024
* atp
$OffText

*------------------------------------------------------------------------------*
*                       Commodity sets                                         *
*------------------------------------------------------------------------------*
alias(e,ei);

SETS
    oili(i)      "Oil products"
    gasi(i)      "Gas products"
    fossilei(i)  "Fossil fuel: primary products"
    trueservi(i) "Services excluding transportation services"
    EITEi(i)     "Commodities from Energy Intensive and Trade Exposed industries"
    mani(i)      "Manufacturing goods"
    Utilities(i) "Utility commodities"
    srvi(i)      "Service commodities"
    PriMati(i)
    RefMati(i)
    axi(i)
;

EITEi(i) = FRTi(i) + cementi(i) + I_Si(i) + PPPi(i) + NFMi(i) ;
mani(i)      = EITEi(i) + MTEi(i) + FMPi(i) + ELEi(i) + woodi(i) + FDPi(i)
             + TXTi(i) + omani(i) ;
Utilities(i) = elyi(i) + wtri(i) + ROILi(i);
oili(i)      = COILi(i) + ROILi(i);
gasi(i)      = NGASi(i) + GDTi(i);
fossilei(i)  = COAi(i)  + COILi(i) + NGASi(i);
trueservi(i) = pubservi(i) + privservi(i);
srvi(i)      = trueservi(i) + img(i);

LOOP(i $ (NOT (cri(i) or lvi(i))),
    axi(i) = YES ;
) ;

*------------------------------------------------------------------------------*
*                       Households sets                                        *
*------------------------------------------------------------------------------*

* [TBC] Logiquement pas tous les CROPS: cer-k  &  xcr-k   "Other crops bundle"

SETS
    kfood(k) "Food Bundles in Household preferences"
    nrgk(k) / nrg-k "Energy bundle" /
;

LOOP(mapk(i,k),
    kfood(k) $ FDPi(i) = YES;
    kfood(k) $ lvi(i)  = YES;
    kfood(k) $ cri(i)  = YES; !!  kfood(k) $ fisheryi(i) =YES;
);

*------------------------------------------------------------------------------*
*                       Emissions sets                                         *
*------------------------------------------------------------------------------*

$include "%SetsDir%\setEmissions.gms"

* define the versions of external satelite database for GHG (and energy) used

* Test if I need that
*$include "%SetsDir%\SetDatabaseVersion.gms"

*   Additional sets for model (ie not used for data generation procedures)

set

    EmiAct(EmiSource) "Output based emissions" /
        act         "Activity Processes emissions"
        wastesld    "Solid waste"
        wastewtr    "Waste water"
        wasteinc    "Waste incineration"
        fugitive    "Fugitive emissions"
        AgrBurn     "Agricultural waste burning, forest fires, Savannah burning"
    /

    EmiSourceAct(EmiSource) "Active sources of emission in the model" /
        coalcomb    "Coal combustion"
        coilcomb    "Crude Oil combustion"
        roilcomb    "Refined Oil combustion"
        gascomb     "Natural Gas combustion"
        gdtcomb     "Natural Gas combustion"
        chemUse     "Chemical/fertilizer use"
        Land        "Land use"
        Capital     "Livestock use"
        act         "Activity Processes emissions"
        wastesld    "Solid waste"
        wastewtr    "Waste water"
        wasteinc    "Waste incineration"
        fugitive    "Fugitive emissions"
        AgrBurn     "Agricultural waste burning, forest fires, Savannah burning"
    /
    EmiSourceIna(EmiSource) "Inactive sources of emission in the model"

    TypeNDC /
        int, RedBaseYr, AbsCond, AbsUncond, RedBauCond, RedBauUnCond,
        EmiBau, BaseYear, 2030Tgt, 2030TgtLulucf
        /

    mapiEmi(i,EmiSource)     "Map emissions from commodity use to commodity"
    emimainSource(EmiSource) "Main Fuel combustion and process emissions"
;

EmiSourceIna(EmiSource)  $ (NOT EmiSourceAct(EmiSource)) = YES ;
EmiSourceIna(emiagg)  = NO ;

mapiEmi(COAi,"coalcomb")  = YES ;
mapiEmi(COILi,"coilcomb") = YES ;
mapiEmi(ROILi,"roilcomb") = YES ;
mapiEmi(NGASi,"gascomb")  = YES ;
mapiEmi(GDTi,"gdtcomb")   = YES ;
mapiEmi(frti,"chemUse")   = YES ;

* Actually put all with fert. ultimately but only chm as fert [TBU]

$IF SET BPH_name mapiEmi("%BPH_name%-c","chemUse") = YES ;
mapiEmi(cementi,"chemUse") = YES ;

* dans gtap pour PM25  -->lum & frs

* mapiEmi(ROILi,"biofcomb") = YES ;
* mapiEmi(forestryi,"biomcomb") = YES ;
* mapiEmi(NGASi,"biogcomb") = YES ;
* mapiEmi("otp","hydcomb")  = YES ;

* Memo: the set "emimainSource" is used for some CT experiments

emimainSource(EmiSource) $ EmiFosComb(EmiSource) =  YES ;
emimainSource(EmiSource) $ emiact(EmiSource)     =  YES ;


set mapFpEmi(fp,EmiFp) "Emissions from factor uses" /
    Land.Land
    Capital.Capital
/;

*------------------------------------------------------------------------------*
*                       ENVISAGE additional Sets                               *
*------------------------------------------------------------------------------*

* formerly declared in "%ModelDir%\26-model.gms"

sets
    rs(r) "Region(s) to be included in simulation"

    lsFlag(r,l,z)        "Flag for labor by zone"
    ueFlag(r,l,z)        "Employment regime"
    migrFlag(r,l)        "Migration flag"
;

rs(r) = yes ;
alias(r,rr) ;
alias(k, kp) ; alias(k, k1) ;
alias(v,vp) ;

* This just to check
$GOTO Useless
$IfTheni.BauVar %SimType%=="variant"
$OnMulti
   Set is /
       AVBUNK   "IEA-EEB/EDGAR: International aviation bunkers"
       MARBUNK  "IEA-EEB/EDGAR: International marine bunkers"
       STATDIFF "IEA-EEB: Statistical differences"
   /
   Set aa(is) /
       AVBUNK   "IEA-EEB/EDGAR: International aviation bunkers"
       MARBUNK  "IEA-EEB/EDGAR: International marine bunkers"
       STATDIFF "IEA-EEB: Statistical differences"
   / ;
   Set InactiveSect(aa) /
       AVBUNK   "IEA-EEB/EDGAR: International aviation bunkers"
       MARBUNK  "IEA-EEB/EDGAR: International marine bunkers"
       STATDIFF "IEA-EEB: Statistical differences"
   / ;
$OffMulti
$Endif.BauVar
$LABEL Useless

*************************************************************************************************************************************************************
*************************************************************************************************************************************************************
*** New reporting parameters used in 11-postsim.gms

SETS
    var2            / gdp, C, I, G, IM, EX, check, netX /
    FinDem2(var2)   / C, I, G, IM, EX /
    unit2           / nominal, real /
    nonco2(em)      "Non-CO2 emissions"     / CH4, N2O, SF6 /
    es              "Emission main sources" / agr, nrg, trp, ind, oth/
    agcDBK(*)       "Aggregate commodity set for Dashboard"/ cfood, celcy, conrg, ctran, ccapg, ccong, cpubs, cpris /
    agcDBK2(*)      "Aggregate set for Dashboard"/ cagr, ccoa, coil, cgas, cely, ceim, coma, ctrs, cosr /
;

alias(r,rp2) ;

Parameters
    pely(r,t)               "Consumer price of electricity (pat)"
    pely_pro(r,t)           "Producer price of electricity"
    pely_hhd(r,t)           "Household (consumer) price of electricity"
    CPI(r,t)                "Consumer price index (Laspeyre)"
*    rwagerep(r,l,t)        "Real wages by skill level for reporting"
    wage_nom(r,t)           "Nominal wage by skill for reporting"
    wage_real(r,t)          "Real wage by skill level for reporting"
    Lemp(r,t)               "Total labor employment"
    Lempsec(r,a,t)          "Employment by sector"
    ctax(r,t)               "Carbon tax for reporting"

    expt_tot_real(r,t)      "Real Total exports"
    impt_tot_real(r,t)      "Real Total imports"
    expt_real(r,i,t)        "Real exports by commidity"
    impt_real(r,i,t)        "Real imports by commidity"

    expt_tot_nom(r,t)       "Nominal Total exports"
    impt_tot_nom(r,t)       "Nominal Total imports"
    expt_nom(r,i,t)         "Nominal exports by commidity"
    impt_nom(r,i,t)         "Nominal imports by commidity"

    pw_rep(a,t)             "World price of activity a for reporting"

    gva_real(r,a,t)         "Real Gross value added"
    intinp_real(r,a,t)      "Real Intermediate inputs"
    gva_nom(r,a,t)          "Nominal Gross value added"
    intinp_nom(r,a,t)       "Nominal Intermediate inputs"
    gva_gdp(r,a,t)          "Real GVA adjusted to match overal GDP"
    gva_gdpbau(r,a,t)       "Baseline real GVA adjusted to match overal GDP"
    GDPdecSup(r,a,t)        "GDP decomposition from the supply side"

    tfp_xpv_bau(r,a,v,t)
    xp_bau(r,a,t)           "Gross output in the baseline"
    xs_bau(r,i,t)           "Domestic production in the baseline"
    elygen(r,t)             "Electricity generation "
    pw_int(r,i,t)           "International price "

    NrgCons(r,t)            "Energy domestic consumption"
    NrgConsi(r,i,t)         "Energy domestic consumption by commodity"
    NrgConsih(r,e,t)        "Energy domestic consumption for HH"
    NrgIntC(r,aa,t)         "Energy intensity by activity/agent in volumes: energy inputs / total inputs"
    NrgIntA(r,aa,t)         "Energy intensity by activity/agent in volumes: energy inputs / gross output"

    GDP_real(r,t)           "Real GDP in levels (billion US$)"
    GDP_realbau(r,t)        "Baseline real GDP in levels (billion US$)"
    GDP_nom(r,t)            "Nominal GDP in levels (billion US$)"
    CABsh(r,t)              "CAB as a share of real GDP"
    GBalSh(r,t)             "Government budget balance as a share of real GDP"
    NrgExp_GDP(r,t)         "Share of energy expenditure to GDP"
    CJLindex(r,t)           "Cohen,Joutz&Loungani (2011) index of insecurity of supply"
    Hindex(r,t)             "Herfindahol concentration index"

    Mbil(r,rp,t)            "Bilateral energy imports"
    Mbili(r,i,rp,t)         "Bilateral energy imports by commodity"
    Mshr(r,t)               "Import dependency: Share of total energy imports on energy demand"
    Mshri(r,i,t)            "Import dependency: Share of imported energy to energy demand by commodity"
    Powscale                "Scale factor for electricity outcomes"
    emitotrep(ra,t)         "Total emissions GHG incl. LULUCF for reporting"
    emitot_source(ra,*,t)   "Emissions by CO2, nonCO2, LULUCF"
    emitot_act(ra,is,t)     "Total GHG emissions by activity"
    emitot_co2(ra,t)        "Total CO2 emissions"
    workrt(r,t)             "Temporary work variable with dimensions r,t"
    workrt3(r,t,*)
    workrat(r,aa,t)         "Temporary work variable with dimensions r,aa,t"
    workra(ra)              "Temporary work variable with dimensions ra"
    twork(t)
    FFsubs(r,i,t)           "Fossil fuel subsidies from FAD database"
*    NDC2030(ra)             "NDC targets for 2030"
    EmiCapTgt(ra, t)        "Coalition-wide emission cap target"
    NrgAcc(r,e,t,*)         "Energy accounting by component"
    Kstock_real(r,a,t)      "Real Capital stock by activity"
    Kstock_nom(r,a,t)       "Nominal Capital stock by activity"
    gInv_real(r,a,t)        "Real gross investment by activity"
    gInv_nom(r,a,t)         "Nominal gross investment by activity"

    xp_real(r,a,t)          "Real Gross output for reporting"
    xp_nom(r,a,t)           "Nominal Gross output for reporting"
    lambdaw_pre(r,i,rp,t)

    GDP_component(var2,unit2,r,t)
    GDPcomp(r,t,var2)       "Real GDP by components for reporting"
    Pop_rep(ra,t)           "Population in millions"
    GDPpc(ra,t)             "Real GDP per capita"
    NrgGDP(ra,t)            "Energy intensity (volume) of real GDP"
    EmiNrg(ra,t)            "Emission intensity of energy"

    xw_bau(r,i,rp,t)
    lambdaw_bau(r,i,rp,t)
    emi_bau(r,AllEmissions,EmiSource,aa,t)
    chiemi_bau(r,AllEmissions,t)
    chiTotemi_bau(r,t)

    elyMix(r,a,t)                   "Electricity mix using x0"

    InvLoss(r,tt)                   "Investment losses from mitigation policies"
    adjf2(r)
    ygov_bau(r,gy,t)               "Baseline government revenues"
    ygov_sim(r,gy,t)               "Government revenues from a policy simulation"
    ygov_rep(ra,gy,t)              "Government total revenues for reporting "
    savg_rep(ra,t)                 "Government balance for reporting"
    cgov_rep(ra,t)                 "Government total expenditure for reporting"
    rsg_sim(r,t)                   "Government savings from a policy simulation"
    ely_inv(r,t)                   "Investment (capital demand) in electricity generation"
    ctrev(r,t)                     "Carbon tax revenue"
    ctrev_gdp(r,t)                 "Carbon tax revenue as a share of nominal GDP"
    yd_rep(r,t)                    "Household disposable income"
    yh_rep(r,t)                    "Household net income (of factor taxes and depreciation)"

    emitot_sou(ra,es,t)            "GHG emissions by source"
    emi_elya(ra,t)                 "Electricity GHG emissions"
    emi_ch4(ra,t)                  "Total methane emissions"
    emi_min(ra,t)                  "Mining GHG emissions"
    emi_fugi(ra,t)                 "Fugitive emissions"
    emi_act(ra,t)                  "Activity emissions"
    emi_sf6(ra,t)                  "Total SF6 emissions"
    emi_n2o(ra,t)                  "Total N2O emissions"
    emi_fgas(ra,t)                 "Total FGAS emissions"
    emi_hfc(ra,t)                  "Total HFC emissions"
    emi_gas(ra,em,t)               "Toal emissions by gas"
    emi_check(ra,t)                "Check on emitotrep"
    emi_check2(ra,t)               "Diff between emitotrep and emitotALLGHG"
    emi_ch4excl(ra,t)              "Total methane emissions excluding methane emisison in transport, electricity and mining"
    Ifemir(r,AllEmissions,emiSource,aa)   "Conditional for emir redunctions using chiemiDet"
    cbamSh(r,i,rp)                 "Share of CBAM products in sectoral exports"
    aemi_bau(r,AllEmissions,a,v,t)
    cprice(r,agcDBK,t)              "Consumer price by aggregate commodity"
    MktShr(r,i,t)                   "International market shares by commodity"
    MktShrDB(r,agcDBK2,t)           "International market shares by commodity, aggregated using mapagcDBK2"
    expt_bil(r,rp,t)                "Total bilateral exports"
    impt_bil(r,rp,t)                "Total bilateral imports"    
    REER(r,t)                       "Real effective exchange rate"
    pp_rep(r,*,t)                   "Production prices by aggregate activity"
    popScen(scen,r,tranche,tt)
    gdpScen(mod,ssp,var,r,tt)
    educScen(scen,r,tranche,ed,tt)
    IfCalMacro(r,*)
    DBlastyear                      "Last (historical) year for Dashboad graphs"
;

chiTotEmi_bau(r,t) = 0;
aemi_bau(r,AllEmissions,a,v,t) = 0;
InvLoss(r,t) = 1;
alias(a,a2) ;
alias(i,i2);

************************************************************************************************************************************************************************
