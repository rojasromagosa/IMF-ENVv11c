$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
	GAMS file   :  "%ModelDir%\27-model.gms"
	purpose     :  Main equations, variables and parameters
	created date: 2017
	created by  : Dominique van der Mensbrugghe --> ENVISAGE model
	modified by : Jean Chateau                  --> OECD-ENV model
	called by   : %ModelDir%\2-CommonIns.gms
--------------------------------------------------------------------------------
    OECD-ENV modifications to original ENVISAGE codes:

        - Add macros and put all Macro in a specific file "26-macros.gms"
        - Simplify the original ENVISAGE codes with the use of macros
        - Change scaling variables to dynamic scales
        - Add some scale/technogical parameters:
            TFP_xpx, lambdafd, TFP_fp, TFP_xs, lambdaoapm lambdaxdm lambdaxm
        - Change the dimension of the variable emiTax
        - Add endogenous MAC-curves for GHG and OAP [Option]
        - Change emission set to include OAP
        - re-write ptlandndxeq, pnlbndxeq, plbndxeq in compact form (see Rev420)
        - 27 May 2022: move non-essential ENVISAGE equations in the file
                       "26-model_AltEq.gms"
                       move OECD-ENV policy equations in "26-model_AltEq.gms"
        - for calibration purpose make apb and as function of time
		- [2023-02-23]: #Rev517 remove ltax, ktax, landtax, nrftax, h2otax
						replace with Taxfp(r,a,fp,t)
						+ add  Subfp(r,a,fp)
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/27-model.gms $
	last changed revision: $Rev: 520 $
	last changed date    : $Date:: 2024-03-01 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$OnText

*  DEFINE POSSIBLE FUNCTIONAL FORMS FOR LAND AND WATER MARKETS

   KELAS    "Constant elasticity supply function"
   LOGIST   "Logistic supply function"
   HYPERB   "Generalized hyperbola supply function"
   INFTY    "Infinitely elastic supply function"

*  DEFINE POSSIBLE FUNCTIONAL FORMS FOR HOUSEHOLD UTILITY

   CD       "Cobb-Douglas"
   LES      "Linear expenditure system"
   ELES     "Extended linear expenditure system"
   AIDADS   "An Implicitly Direct Additive Demand System"
   CDE      "Constant differences in elasticity"

$OffText

acronyms KELAS, LOGIST, HYPERB, INFTY, CD, LES, ELES, AIDADS, CDE, capFlexGTAP, capFLex, capFlexUSAGE, capFix ;

PARAMETERS

*  Production parameters

* #Todo on a deja declare des parametres genre elastisites dans 24-default_Prm.gms"

    sigmaxp(r,a,v)       "Substitution elasticity between production and non-CO2 GHG bundle"
    aghg(r,a,v,t)        "Share parameter for non-CO2 GHG bundle"
    axp(r,a,v,t)         "Share parameter for output in production"

* [OECD-ENV]: add endogenous MAC-curves

    aoap(r,a,v,t)              "Share parameter for OAP bundle"
    aemi(r,AllEmissions,a,v,t) "Share parameter for emi in ghg/oap bundle"

    sigmap(r,a,v)        "Substitution elasticity between ND1 and VA"
    and1(r,a,v,t)        "Share parameter for ND1 bundle"
    ava(r,a,v,t)         "Share parameter for VA bundle"

    sigmav(r,a,v)        "Substituion elasticity for VA bundle"
    sigmav1(r,a,v)       "Substitution elasticity for VA1 bundle"
    sigmav2(r,a,v)       "Substitution elasticity for VA2 bundle"

    alab1(r,a,v,t)       "Share parameter for LAB1 bundle"
    alab2(r,a,v,t)       "Share parameter for LAB2 bundle"
    aland(r,a,v,t)       "Share parameter for land"
    akef(r,a,v,t)        "Share parameter for KEF bundle"
    and2(r,a,v,t)        "Share parameter for ND2 bundle"
    ava1(r,a,v,t)        "Share parameter for VA1 bundle"
    ava2(r,a,v,t)        "Share parameter for VA2 bundle"

    sigmakef(r,a,v)      "Substitution elasticity between KF and XNRG"
    akf(r,a,v,t)         "Share parameter for KF bundle"
    ae(r,a,v,t)          "Share parameter for NRG bundle"

    sigmakf(r,a,v)       "Substitution elasticity between KS and NRF"
    aksw(r,a,v,t)        "Share parameter for KSW bundle"
    anrf(r,a,v,t)        "Share parameter for NRF bundle"

    sigmakw(r,a,v)       "Substitution elasticity between KS and WAT"
    aks(r,a,v,t)         "Share parameter for KS bundle"
    awat(r,a,v,t)        "Share parameter for WAT bundle"

    sigmak(r,a,v)        "Substitution elasticity between K and LAB2"
    ak(r,a,v,t)          "Share parameter for capital"
    alab2(r,a,v,t)       "Share parameter for LAB2 bundle"

    sigmaul(r,a)         "Labor substitution across unskilled types"
    sigmasl(r,a)         "Labor substitution across skilled types"
    alab(r,l,a,t)        "Share parameter for labor demand"

    sigman1(r,a)         "Substitution elasticity across goods in ND1 bundle"
    sigman2(r,a)         "Substitution elasticity across goods in ND2 bundle"
    sigmawat(r,a)        "Substitution elasticity across water in XWAT bubdle"
    aio(r,i,a,t)         "Share parameter for intermediate demand"
    ah2o(r,a,t)          "Share parameter for water factor demand"

    sigmae(r,a,v)        "Substitution elasticity between ELY and NELY bundles"
    anely(r,a,v,t)       "Share parameter for NELY bundle"
    aeio(r,e,a,v,t)      "Share parameter for energy demand"
    aNRG(r,a,NRG,v,t)    "Share parameter for NRG bundles"
    sigmanely(r,a,v)     "Substitution elasticity between COA and OLG bundles"
    aolg(r,a,v,t)        "Share parameter for OLG bundle"
    sigmaNRG(r,a,NRG,v)  "Inter-fuel substitution elasticity within bottom-level nests"

    omegas(r,a)          "Output transformation elasticity in make/use module"
    gp(r,a,i)            "CET share parameters in make/use module"

    sigmas(r,i)          "Output substitution elasticity in make/use module"

    as(r,a,i,t)          "CES share parameters in make/use module"

    apow(r,elyi,t)          "CES share parameter for aggregate power"
    sigmael(r,elyi)         "Subsitution between power and ETD"
    apb(r,pb,elyi,t)        "Share parameter for power bundles"
    sigmapow(r,elyi)        "Substitution across power bundles"
    sigmapb(r,pb,elyi)      "Substitution across power activities within power bundles"
    lambdapow(r,pb,elyi,t)  "Power efficiency parameters"     !! = lambdapb ENV-L
    lambdapb(r,a,elyi,t)    "Sub-power efficiency parameters" !! = lambdaas ENV-L

*  Income parameters

    fdepr(r,t)           "Fiscal rate of depreciation"
    ydistf(r,t)          "Share of capital income flowing to global trust"
    chiTrust(r,t)        "Share of region r in global trust"
    chiRemit(rp,l,r,t)   "Share of labor income in region r remitted to region rp"

*  Demand parameters

    u0(r,h)              "Scaling parameter for utility"
    Frisch(r,h,t)        "Frisch parameter"
    kron(k,kp)           "Kronecker's delta"
    acxnnrg(r,k,h)       "Non-energy bundle share parameter in consumption"
    acxnrg(r,k,h)        "Energy bundle share parameter in consumption"
    nu(r,k,h)            "Energy/non-energy substitution elasticity in consumption"

    ac(r,i,k,h)          "Share parameters in decomposition of non-energy and energy bundles"
    nunnrg(r,k,h)        "Substitution across goods in non-energy bundle"

    acnely(r,k,h,t)      "Non-electric bundle share parameter in consumption"
    acolg(r,k,h,t)       "OLG bundle share parameter in consumption"
    acNRG(r,k,h,NRG,t)   "Share parameters for NRG bundles"

    nue(r,k,h)           "Electric/non-electric substitution in consumption"
    nunely(r,k,h)        "Coal/OLG substitution in consumption"
    nuolg(r,k,h)         "Substituion between oil & gas in consumption"
    nuNRG(r,k,h,NRG)     "Substitution within NRG bundles"

    sigmafd(r,fd)        "Other final demand substitution elasticity"
    alphafd(r,i,fd,t)    "Final demand share parameter"

*  Trade parameters

    sigmamt(r,i)         "Top level Armington CES elasticity"
    alphadt(r,i,t)       "Domestic share parameter"
    alphamt(r,i,t)       "Import share parameter"

    lambdaxd(r,i,t)      "Efficieny of xd in 1st level Armington Demand"
    lambdaxm(r,i,t)      "Efficieny of xm in 1st level Armington Demand"

    sigmam(r,i,aa)       "Top level Armington elasticity with agent sourcing"
    alphad(r,i,aa,t)     "Domestic share parameter with agent sourcing"
    alpham(r,i,aa,t)     "Import share parametter with agent sourcing"

    sigmaw(r,i)          "Second level Armington CES elasticity"
    alphaw(r,i,rp,t)     "Import by source share parameter"
    lambdaw(r,i,rp,t)    "Iceberg parameter"

    omegax(r,i)          "Top level CET transformation elasticity"
    gammad(r,i,t)        "CET domestic share parameter"
    gammae(r,i,t)        "CET export share parameter"

    omegaw(r,i)          "Second level CET transformation elasticity"
    gammaw(r,i,rp,t)     "Second level share parameters"

*  Twist parameters

    ArmMShrt1(r,i)       "Lagged import share for top level national sourcing"
    ArmMShr1(r,i,aa)     "Lagged import share for top level agent sourcing"
    ArmMShr2(i,r)        "Import share from r's targetted countries"

*  Margin parameters

    amgm(img,r,i,rp)       "Share of m in transporting from r to rp"
    sigmamg(img)           "CES substitution elasticity for sourcing tt services"
    alphatt(r,img,t)       "CES share parameters for sourcing tt services"
    lambdamg(img,r,i,rp,t) "Efficiency factor for tt services"

*  Factor supply parameters

    uez0(r,l,z)          "Initial level of unemployment by zone"
    resWage0(r,l,z)      "Initial level of reservation wage"
    ueMinz0(r,l,z)       "Initial level of minimum unemployment by zone"
    ueMinz(r,l,z,t)      "Minimum level of UE by zone"
    omegarwg(r,l,z)      "Elasticity of reservation wage wrt to growth"
    omegarwue(r,l,z)     "Elasticity of reservation wage wrt to UE"
    omegarwp(r,l,z)      "Elasticity of reservation wage wrt to CPI"
    migr0(r,l)           "Ratio of rural migration as a share of base year rural labor supply"
    chim(r,l,t)          "Migration function shifter"
    omegam(r,l)          "Migration elasticity"
    kronm(z)             "Set to -1 for rural and to +1 for urban"

    omegak(r)            "Capital CET elasticity in CS mode"
    gammak(r,a,v,t)      "Capital CET share parameters in CS mode"
    invElas(r,a)         "Supply elasticity of Old capital in declining sectors"

    etat(r)              "Total land supply elasticity"
    gammatl(r,t)         "Total land supply parameter"
    gamlb(r,lb,t)        "Share parameter for land bundles"
    gamnlb(r,t)          "Share parameter for intermediate land bundle"
    omegat(r)            "Top level land transformation elasticity"
    omeganlb(r)          "CET across land bundles (except lb1)"
    gammat(r,a,t)        "Land CET share parameters"
    omegalb(r,lb)        "CET across land within land bundles"

    etanrfx(r,a,lh)      "Kinked supply elasticities"
    chinrfp(r,a)         "Natural resource price adjustment factor"

    Adjpa(r,a)           "power generation price adjustment factor"
    pwtrend(a,tt)        "Baseline price trends"
    pwshock(a,tt)        "Shock price trends"

    chih2o(r,t)          "Aggregate water supply shifter"
    etaw(r)              "Aggregate water supply elasticity"
    gammatw(r,t)         "Aggregate water supply curvature parameter"
    gam1h2o(r,wbnd,t)    "Water allocation share parameter"
    omegaw1(r)           "Top level water allocation transformation elasticity"
    gam2h2o(r,wbnd,t)    "Water allocation share parameter"
    omegaw2(r,wbnd)      "Second level water allocation transformation elasticity"
    gam3h2o(r,a,t)       "Water allocation share parameter"
    ah2obnd(r,wbnd,t)    "Water allocation shift parameter"
    epsh2obnd(r,wbnd)    "Water bundle demand price elasticity"
    etah2obnd(r,wbnd)    "Water bundle demand scale elasticity"

*  Capital account closure parameters

    riskPrem(r,t)        "Regional risk premium"
    epsRoR(r,t)          "Sensitivity of rate-of-return expectation"
    savfBar(r,t)         "Exogenous foreign savings (or from BAU)"

*  Parameters for emissions module

* [OECD-ENV]: "part" and "emir" are now function of time + change to AllEmissions,EmiSource

    emir(r,AllEmissions,EmiSource,aa,t) "Emissions per unit of consumption/output"
    emird(r,AllEmissions,EmiUse,aa,t)   "Emissions per unit of domestic consumption"
    emirm(r,AllEmissions,EmiUse,aa,t)   "Emissions per unit of imported consumption"
    part(r,AllEmissions,EmiSource,aa,t) "Level of participation: 0=none 1=full"
    gwp(em)                             "Global warming potential"

*  Parameters for energy module

    phiNRG(r,fi,aa)       "Cumbustion ratio for fuel demand"

*  Miscellaneous parameters

    phiw(r,i,rp,t)       "Weights for calculating MUV"
    phia(r,i,fd,t)       "Weights for calculating absorption price indices"
    phipw(r,a,t)         "Weights for calculating world price of activities"
    phipwi(i,t)          "Weights for calculating world price of commodities (CIF prices)"
    chi(r,fd)            "Shift variable for PFD"
    chimuv               "Shift variable for MUV"
    depr(r,t)            "Physical depreciation rate"

    chiKaps0(r)          "Base year ratio of normalized capital to capital stock"
    glAddShft(r,l,a,t)   "Additive shifter in labor productivity factor"
    glMltShft(r,l,a,t)   "Multiplicative shifter in labor productivity factor"
    popT(r,tranche,t)    "Total Population"
    educ(r,l,t)          "Size of labor by education from SSP database"
    glabT(r,l,t)         "Targeted growth rates for labor by skill"
    rgdppcT(r,t)         "Real GDP per capita"

* OECD-ENV: change the name lfpr --> lfpr_envisage

    lfpr_envisage(r,l,tranche,t)  "Labor force participation rate by skill and age cohort"
    aeei(r,e,a,v,t)      "Energy efficiency improvement in production"
    aeeic(r,e,k,h,t)     "Energy efficiency improvement in household demand"
    yexo(r,a,v,t)        "Exogenous improvement in yields"
    g_nrf(r,a,v,t)       "Exogenous improvement in yields"
    tteff(r,i,rp,t)      "Exogenous improvement in intl. trade & transport margins"
    xatNRG(r,e,t)        "Energy absorption in MTOE"

    gammaeda(r,i,aa)     "Energy price equalizer in domestic absorption"
    gammaedd(r,i,aa)     "Energy price equalizer for domestic goods with agent sourcing"
    gammaedm(r,i,aa)     "Energy price equalizer for import goods with agent sourcing"
    gammaew(r,i,rp)      "Energy price equalizer in exports"
    gammaesd(r,i)        "Energy price equalizer in domestic supply"
    gammaese(r,i)        "Energy price equalizer in export supply"

*   Activity flags

    xpFlag(r,a)              "Flag for output of activity 'a'"
    ghgFlag(r,a)             "Flag for process GHG emissions bundle"
    nd1Flag(r,a)             "Flag for ND1 bundle"
    nd2Flag(r,a)             "Flag for ND2 bundle"
    lab1Flag(r,a)            "Flag for lab1 bundle"
    lab2Flag(r,a)            "Flag for lab2 bundle"
    va1Flag(r,a)             "Flag for VA1 bundle"
    va2Flag(r,a)             "Flag for VA2 bundle"
    landFlag(r,a)            "Flag for land bundle"
    kefFlag(r,a)             "Flag for KEF bundle"
    kfFlag(r,a)              "Flag for KF bundle"
    watFlag(r,a)             "Flag for water bundle"
    xwatfFlag(r,a)           "Flag for water factor demand"
    kFlag(r,a)               "Flag for capital"
    xnrgFlag(r,a)            "Flag for NRG bundle"
    nrfFlag(r,a)             "Flag for NRF bundle"
    xaNRGFlag(r,a,NRG)       "Flag for energy bundle bundle"
    xnelyFlag(r,a)           "Flag for NELY bundle"
    xolgFlag(r,a)            "Flag for OLG bundle"
    th2oFlag(r)              "Flag for aggregate water market"
    labFlag(r,l,a)           "Flag for labor demand"
    xaFlag(r,i,aa)           "Flag for Armington demand by agent"
    xdFlag(r,i,aa)           "Flag for domestic demand by agent"
    xmFlag(r,i,aa)           "Flag for import demand by agent"
    xsFlag(r,i)              "Flag for domestically produced goods"
    xcFlag(r,k,h)            "Flag for household consumption"
    uFlag(r,h)               "Flag for household utility"
    xcnnrgFlag(r,k,h)        "Flag for non-energy bundle in consumption"
    xcnrgFlag(r,k,h)         "Flag for energy bundle in consumption"
    xcnelyFlag(r,k,h)        "Flag for non-electriciy bundle in consumption"
    xcolgFlag(r,k,h)         "Flag for OLG bundle in consumption"
    xacNRGFlag(r,k,h,NRG)    "Flag for NRG bundles in consumption"
    xatFlag(r,i)             "Flag for aggregate Armington demand"
    xddFlag(r,i)             "Flag for XDD bundle"
    xmtFlag(r,i)             "Flag for XMT bundle"
    xwFlag(r,i,rp)           "Flag for XW"
    xdtFlag(r,i)             "Flag for XDT bundle"
    xetFlag(r,i)             "Flag for XET bundle"
    tmgFlag(r,i,rp)          "Flag for tt services"
    xttFlag(r,i)             "Flag for domestic tt supply"
    th2oFlag(r)              "Flag for aggregate water market"
    h2obndFlag(r,wbnd)       "Flag for water bundles"
    tlabFlag(r,l)            "Flag for aggregate labor"
    tlandFlag(r)             "Flag for aggregate land"
    OAPFlag(r,a)             "Flag for OAP bundle"

    TotTransfert(r,t)

*  Post-simulation parameters

   sam(r,is,js,t)       "Social accounting matrix"

*  Initial levels

    pp0(r,a)             "Producer price tax inclusive, i.e. market price"
    px0(r,a)             "Producer price before tax"
    uc0(r,a)             "Unit cost of production by vintage pre-tax"
    pxv0(r,a)            "Unit cost of production by vintage tax/subsidy inclusive"
    pxp0(r,a)            "Cost of production excl non-CO2 GHG bundle"
    pva0(r,a)            "Price of VA bundle"
    pva10(r,a)           "Price of VA1 bundle"
    pva20(r,a)           "Price of VA2 bundle"
    pkef0(r,a)           "Price of KEF bundle"
    pkf0(r,a)            "Price of KF bundle"
    pksw0(r,a)           "Price of KSW bundle"
    plab10(r,a)          "Price of 'unskilled' labor bundle"
    plab20(r,a)          "Price of 'skilled' labor bundle"
    pnd10(r,a)           "Price of ND1 bundle"
    pnd20(r,a)           "Price of ND2 bundle"
    pwat0(r,a)           "Price of water bundle"
    pnrg0(r,a)           "Price of energy bundle"
    pks0(r,a)            "Price of KS bundle"
    paNRG0(r,a,NRG)      "Price of energy bundles"
    pnely0(r,a)          "Price of NELY bundle"
    polg0(r,a)           "Price of oil and gas bundle"
    p0(r,a,i)            "Price of good 'i' produced by activity 'a'"
    ps0(r,i)             "Market price of domestically produced good 'i'"
    ppow0(r,elyi)        "Average price of aggregate power"
    ppowndx0(r,elyi)     "Price index of aggregate power"
    ppb0(r,pb,elyi)      "Average price of power bundles"
    ppbndx0(r,pb,elyi)   "Price index of power bundles"

    xghg0(r,a)           "Non-CO2 GHG bundle associated with output"
    xnrf0(r,a)           "Demand for NRF factor"
    xwat0(r,a)           "Demand for WAT bundle"
    h2o0(r,a)            "Demand for water"
    lab20(r,a)           "Demand for 'skilled' labor bundle"

* OECD-ENV : Dynamic/time dependent scales

    x0(r,a,i,t)         "Output of good 'i' produced by activity 'a'"
    xp0(r,a,t)          "Gross sectoral output of activity 'i'"
    nd10(r,a,t)         "Demand for intermediate goods in ND1 bundle"
    va0(r,a,t)          "Demand for top level VA bundle"
    va10(r,a,t)         "Demand for VA1 bundle"
    xpx0(r,a,t)         "Production level exclusive of non-CO2 GHG bundle"
    lab10(r,a,t)        "Demand for 'unskilled' labor bundle"
    ld0(r,l,a,t)        "Demand for labor by skill and activity"
    kef0(r,a,t)         "Demand for KEF bundle (capital+skill+energy+nrf)"
    kf0(r,a,t)          "Demand for KF bundle (capital+skill+nrf+water)"
    ks0(r,a,t)          "Demand for KS bundle (capital+skill)"
    kv0(r,a,t)          "Demand for K by vintage"
    ksw0(r,a,t)         "Demand for KSW bundle (capital+skill+water)"
    va20(r,a,t)         "Demand for VA2 bundle"
    nd20(r,a,t)         "Demand for intermediate goods in ND2 bundle"
    xa0(r,i,aa,t)       "Armington demand for goods"
    xnrg0(r,a,t)        "Demand for NRG bundle in production"
    xnely0(r,a,t)       "Demand for non-electric bundle"
    xolg0(r,a,t)        "Demand for oil and gas bundle"
    xaNRG0(r,a,NRG,t)   "Demand for bottom level energy bundles"
    land0(r,a,t)        "Demand for land bundle"
    k00(r,a,t)          "Beginning of period installed capital"
    xpv0(r,a,t)         "Gross sectoral output by vintage"
    xpb0(r,pb,elyi,t)   "Power bundles"
    xpow0(r,elyi,t)     "Aggregate power"
    xat0(r,i,t)         "Aggregate Armington demand"

    deprY0(r)           "Depreciation income"
    yqtf0(r)            "Outflow of capital income"
    trustY0             "Aggregate foreign capital outflow"
    yqht0(r)            "Foreign capital income inflow"
    remit0(r,l,rp)      "Labor remittances"
    yh0(r)              "Household income net of depreciation"
    yd0(r)              "Disposable household income"
    supy0(r,h)          "Per capita supernumerary income"
    muc0(r,k,h)         "Marginal budget shares"
    theta0(r,k,h)       "Consumption auxiliary variable"
    xc0(r,k,h)          "Household consumption of consumer good k"
    hshr0(r,k,h)        "Household budget shares"
    u0(r,h)             "Utility level"
    savh0(r,h)          "Private savings"
    aps0(r,h)           "Private savings rate out of total household income"
*    chiaps0(r)          "Economy-wide shifter for household saving"
    xcnnrg0(r,k,h)      "Demand for non-energy bundle of consumer good k"
    xcnrg0(r,k,h)       "Demand for energy bundle of consumer good k"
    pc0(r,k,h)          "Price of consumer good k"
    pcnnrg0(r,k,h)      "Price of non-energy bundle of consumer good k"
    xcnely0(r,k,h)      "Demand for non-electric bundle of consumer good k"
    xcolg0(r,k,h)       "Demand for OLG bundle of consumer good k"
    xacNRG0(r,k,h,NRG)  "Demand for NRG bundle of consumer good k"
    pacNRG0(r,k,h,NRG)  "Price of NRG bundle of consumer good k"
    pcolg0(r,k,h)       "Price of OLG bundle of consumer good k"
    pcnely0(r,k,h)      "Price of non-electric bundle of consumer good k"
    pcnrg0(r,k,h)       "Price of energy of consumer good k"

    ygov0(r,gy)          "Government revenues"
    pfd0(r,fd)           "Final demand expenditure price index"
    yfd0(r,fd)           "Value of aggregate final demand expenditures"

    xdt0(r,i)            "Domestic demand for domestic production /x xtt"
    xmt0(r,i)            "Aggregate import demand"
    pat0(r,i)            "Price of aggregate Armington good"
    xd0(r,i,aa)          "Domestic sales of domestic goods with agent sourcing"
    xm0(r,i,aa)          "Domestic sales of import goods with agent sourcing"
    pd0(r,i,aa)          "End user price of domestic goods with agent sourcing"
    pm0(r,i,aa)          "End user price of import goods with agent sourcing"
    pa0(r,i,aa)          "Price of Armington good at agents' price"

    xw0(r,i,rp)          "Volume of bilateral trade"
    pmt0(r,i)            "Price of aggregate imports"

    pdt0(r,i)            "Producer price of goods sold on domestic markets"
    xet0(r,i)            "Aggregate exports"
    xs0(r,i)             "Domestic production of good 'i'"
    pe0(r,i,rp)          "Producer price of exports"
    pet0(r,i)            "Producer price of aggregate exports"
    pwe0(r,i,rp)         "FOB price of exports"
    pwm0(r,i,rp)         "CIF price of imports"
    pdm0(r,i,rp)         "Tariff inclusive price of imports"

    xwmg0(r,i,rp)        "Demand for tt services from r to rp"
    xmgm0(img,r,i,rp)    "Demand for tt services from r to rp for service type m"
    pwmg0(r,i,rp)        "Average price to transport good from r to rp"
    xtmg0(img)           "Total global demand for tt services m"
    xtt0(r,i)            "Supply of m by region r"
    ptmg0(img)           "The average global price of service m"

    ldz0(r,l,z)          "Labor demand by zone"
    awagez0(r,l,z)       "Average wage by zone"
    urbPrem0(r,l)        "Urban wage premium"
    resWage0(r,l,z)      "Reservation wage"
*    chirw0(r,l,z)        "Reservation wage shifter"
    ewagez0(r,l,z)       "Equilibrium wage by zone"
    twage0(r,l)          "Equilibrium wage by skill"
    wage0(r,l,a)         "Market wage by skill"
*    skillprem0(r,l)      "Skill premium relative to a reference wage"
    tls0(r)              "Total labor supply"

*    migrMult0(r,l,z)     "Migration multiplier for multi-year time steps"
    lsz0(r,l,z)          "Labor supply by zone"
    ls0(r,l)             "Aggregate labor supply by skill"
*    gtlab0(r)            "Growth rate of total labor supply"
*    glab0(r,l)           "Growth of labor supply by skill"
*    glabz0(r,l,z)        "Growth of labor supply by skill and zone"
*    wPrem0(r,l,a)        "Wage premium relative to equilibrium wage"

    pk0(r,a)             "Market price of capital by vintage and activity"
    trent0(r)            "Aggregate return to capital"
    kxRat0(r,a)          "Capital output ratio by sector"
*    rrat0(r,a)           "Ratio of return to Old wrt to New capital"
*    arent0(r)            "Average return to capital"

    tland0(r)            "Aggregate land supply"
    pland0(r,a)          "Market price of land"
    ptland0(r)           "Aggregate price index of land"
    ptlandndx0(r)        "Price index of aggregate land"


    xlb0(r,lb)           "Land bundles"
    plb0(r,lb)           "Average price of land bundles"
    plbndx0(r,lb)        "Price index of land bundles"
    xnlb0(r)             "Intermediate land bundle"
    pnlb0(r)             "Price of intermediate land bundle"
    pnlbndx0(r)          "Price index of intermediate land bundle"

    pnrf0(r,a)           "Market price of natural resource factor"
*    chinrf0(r,a)         "Natural resource supply shifter"
*    wchinrf0(a)          "Global natural resource supply shifter"

    th2o0(r)             "Aggregate water supply"
*   h2oMax0(r)           "Maximum available water supply"
    th2om0(r)            "Marketed water supply"
    h2obnd0(r,wbnd)      "Aggregate water bundles"
    pth2ondx0(r)         "Aggregate water price index"
    pth2o0(r)            "Aggregate market price of water"
    ph2obnd0(r,wbnd)     "Price of aggregate water bundles"
    ph2obndndx0(r,wbnd)  "Price index of aggregate water bundles"
    ph2o0(r,a)           "Market price of water"
    ph2op0(r,a)          "End user price of water"

    wagep0(r,l,a)        "Wage by skill paid by producers"
    pkp0(r,a)            "Price of capital by vintage and activity tax inclusive"
    plandp0(r,a)         "Price of land paid by producers"
    pnrfp0(r,a)          "Price of natural resource factor paid by producers"

*   Closure variables

    savg0(r)             "Public savings"
    rsg0(r)             "Real government savings"
*
*    rgovshr0(r)         "Volume share of gov. expenditure in real GDP"
*    govshr0(r)          "Value share of gov. expenditure in nominal GDP"
*    rinvshr0(r)         "Volume share of inv. expenditure in real GDP"
*    invshr0(r)          "Value share of inv. expenditure in nominal GDP"

*    kappal0(r,l)        "Income tax on labor income"
*    kappak0(r)          "Income tax on capital income"
*    kappat0(r)          "Income tax on land income"
*    kappan0(r)          "Income tax on natural resource income"
*    kappaw0(r)          "Income tax on water income"
*    kappah0(r)          "Direct tax rate"

    xfd0(r,fd)          "Volume of aggregate final demand expenditures"

    kstocke0(r)         "Anticipated capital stock"
    ror0(r)             "Net aggregate rate of return to capital"
    rorc0(r)            "Cost adjusted rate of return to capital"
    rore0(r)            "Expected rate of return to capital"
    rorg0               "Average expected global rate of return to capital"

    savf0(r)            "Foreign savings (real)"
*    pmuv0(t)            "Export price index of manufactured goods from high-income countries"
*    pwsav0(t)           "Global price of investment good"
*    pwgdp0(t)           "Global gdp deflator"
*    pnum0(t)            "Model numéraire"
     pw0(a)              "World price of activity a"
*    walras0             "Value of Walras"

*   Macro variables

    gdpmp0(r)           "Nominal GDP at market price"
    rgdpmp0(r)          "Real GDP at market price"
    pgdpmp0(r)          "GDP at market price expenditure deflator"
    rgdppc0(r)          "Real GDP at market price per capita"

*   Emission variables

    emi0(r,AllEmissions,EmiSource,aa)    "Emissions by region and driver"
    emiTot0(r,AllEmissions) "Total country emissions (incl. exogenous emissions)"
    emiGBL0(AllEmissions)   "Global emissions"

*  Normally exogenous emission variables

*    emiOth0(r,AllEmissions)       "Emissions from other sources"
*    emiOthGbl0(AllEmissions)      "Other global emissions"
*    chiemi0(AllEmissions)         "Global shifter in emissions"

*  Carbon tax policy variables

*    emiTax0(r,AllEmissions,aa)    "Emissions tax"
    emiCap0(ra,AllEmissions)      "Emissions cap by aggregate region"
    emiCapFull0(ra)
*    emiRegTax0(ra,AllEmissions)   "Regionwide emissions tax"
*    emiQuota0(r,AllEmissions)     "Quota allocation"
*    emiQuotaY0(r,AllEmissions)    "Income from quota rights"
*    chiCap0(AllEmissions)         "Emissions cap shifter"

*  Normally exogenous variables

    kstock0(r)          "Non-normalized capital stock"
    tkaps0(r)           "Total normalized stock of capital"
    pop0(r)             "Population"

* [OECD-ENV]: add-ons
    xpBar(r,a,t)
    popWA0(r,l,z)           "Working Age Population (15 yr and plus) by skills and by geographical zones (millions of prs)"
    pxghg0(r,a,t)           "Price of non-CO2 GHG gas bundle"


*    pim0(r,a)            "Markup over marginal cost of production"

*  Dynamic variables

*    TFP_xpv0(r,a,v)     "Uniform shifter in production bundle"
*    lambdaxp0(r,a,v)    "Output shifter in production bundle"
*    lambdaghg0(r,a,v)   "GHG shifter in production bundle"

*    lambdanrf0(r,a,v)   "Natural resource shifter"
*    lambdak0(r,a,v)     "Capital efficiency shifter"
*    chiglab0(r,l)       "Skill bias productivity shifter"
*    lambdal0(r,l,a)     "Labor efficiency shifter"
*    lambdat0(r,a,v)     "Land efficiency shifter"
*    lambdah2o0(r,a)     "Water efficiency shifter"
*    lambdah2obnd0(r,wbnd) "Water efficiency shifter in water bundle use"
*    lambdaio0(r,i,a)    "Efficiency shifter in intermediate demand"
*    lambdae0(r,e,a,v)   "Energy efficiency shifter in production"
*    lambdace0(r,e,k,h)  "Energy efficiency shifter in consumption"
*    invGFact0(r)        "Capital accumulation auxiliary variable"

*  Policy variables

*    ptax0(r,a)          "Output tax/subsidy"

*    uctax0(r,a,v)       "Tax/subsidy on unit cost of production"
*    paTax0(r,i,aa)      "Sales tax on Armington consumption"
*    tmarg0(r,i,rp)      "FOB/CIF price wedge"
    etax0(r,i,rp)       "Export tax/subsidies"
    mtax0(r,i,rp)       "Import tax/subsidies"

    Taxfp0(r,a,fp) "Initial: Tax/Social contribution rate on primary factor (paid by firms), by sector, by factor"
    Subfp0(r,a,fp) "Initial: Support rate on primary factor (received by firms), by sector, by factor"

* [OECD-ENV]: Add p_emissions(r,AllEmissions,EmiSource,aa,t)
* [2022-12-21] change from variable to parameter because too bi
   p_emissions(r,AllEmissions,EmiSource,aa,t) "Fixed Price of emissions, by region, by gas, by source and by sector"

;

TotTransfert(r,t)  = 0 ;

variables


   pp(r,a,t)            "Producer price tax inclusive, i.e. market price"
   px(r,a,t)            "Producer price before tax"
   uc(r,a,v,t)          "Unit cost of production by vintage pre-tax"
   pxv(r,a,v,t)         "Unit cost of production by vintage tax/subsidy inclusive"

   xpx(r,a,v,t)         "Production level exclusive of non-CO2 GHG bundle"
   xghg(r,a,v,t)        "Non-CO2 GHG bundle associated with output"

   nd1(r,a,t)           "Demand for intermediate goods in ND1 bundle"
   va(r,a,v,t)          "Demand for top level VA bundle"
   pxp(r,a,v,t)         "Cost of production excl non-CO2 GHG bundle"

   lab1(r,a,t)          "Demand for 'unskilled' labor bundle"
   kef(r,a,v,t)         "Demand for KEF bundle (capital+skill+energy+nrf)"
   nd2(r,a,t)           "Demand for intermediate goods in ND2 bundle"
   va1(r,a,v,t)         "Demand for VA1 bundle"
   va2(r,a,v,t)         "Demand for VA2 bundle"
   land(r,a,t)          "Demand for land bundle"
   pva(r,a,v,t)         "Price of VA bundle"
   pva1(r,a,v,t)        "Price of VA1 bundle"
   pva2(r,a,v,t)        "Price of VA2 bundle"

   kf(r,a,v,t)          "Demand for KF bundle (capital+skill+nrf+water)"
   xnrg(r,a,v,t)        "Demand for NRG bundle in production"
   pkef(r,a,v,t)        "Price of KEF bundle"

   ksw(r,a,v,t)         "Demand for KSW bundle (capital+skill+water)"
   xnrf(r,a,t)          "Demand for NRF factor"
   pkf(r,a,v,t)         "Price of KF bundle"

   ks(r,a,v,t)          "Demand for KS bundle (capital+skill)"
   xwat(r,a,t)          "Demand for WAT bundle"
   pksw(r,a,v,t)        "Price of KSW bundle"

   h2o(r,a,t)           "Demand for water"

   kv(r,a,v,t)          "Demand for K by vintage"
   lab2(r,a,t)          "Demand for 'skilled' labor bundle"
   pks(r,a,v,t)         "Price of KS bundle"

   ld(r,l,a,t)          "Demand for labor by skill and activity"
   plab1(r,a,t)         "Price of 'unskilled' labor bundle"
   plab2(r,a,t)         "Price of 'skilled' labor bundle"

   pnd1(r,a,t)          "Price of ND1 bundle"
   pnd2(r,a,t)          "Price of ND2 bundle"
   pwat(r,a,t)          "Price of water bundle"

   xaNRG(r,a,NRG,v,t)   "Demand for bottome level energy bundles"
   xnely(r,a,v,t)       "Demand for non-electric bundle"
   pnrg(r,a,v,t)        "Price of energy bundle"

   paNRG(r,a,NRG,v,t)   "Price of energy bundles"
   pnely(r,a,v,t)       "Price of NELY bundle"

   xolg(r,a,v,t)        "Demand for oil and gas bundle"
   polg(r,a,v,t)        "Price of oil and gas bundle"

   xa(r,i,aa,t)         "Armington demand for goods"
   xd(r,i,aa,t)         "Domestic demand for domestic goods"
   xm(r,i,aa,t)         "Domestic demand for import goods"

   pd(r,i,aa,t)         "User price of domestically produced goods"
   pm(r,i,aa,t)         "User price of imported goods"

   x(r,a,i,t)           "Output of good 'i' produced by activity 'a'"
   p(r,a,i,t)           "Price of good 'i' produced by activity 'a'"
   xp(r,a,t)            "Gross sectoral output of activity 'i'"
   ps(r,i,t)            "Market price of domestically produced good 'i'"

   xpow(r,elyi,t)       "Aggregate power"
   ppow(r,elyi,t)       "Average price of aggregate power"
   ppowndx(r,elyi,t)    "Price index of aggregate power"
   xpb(r,pb,elyi,t)     "Power bundles"
   ppb(r,pb,elyi,t)     "Average price of power bundles"
   ppbndx(r,pb,elyi,t)  "Price index of power bundles"

   deprY(r,t)           "Depreciation income"
   yqtf(r,t)            "Outflow of capital income"
   trustY(t)            "Aggregate foreign capital outflow"
   yqht(r,t)            "Foreign capital income inflow"
   remit(rp,l,r,t)      "Remittances to region rp from region r for skill type l"
   yh(r,t)              "Household income net of depreciation"
   yd(r,t)              "Disposable household income"

   supy(r,h,t)          "Per capita supernumerary income"
   xc(r,k,h,t)          "Household consumption of consumer good k"
   hshr(r,k,h,t)        "Household budget shares"
   u(r,h,t)             "Utility level"

   xcnnrg(r,k,h,t)      "Demand for non-energy bundle of consumer good k"
   xcnrg(r,k,h,t)       "Demand for energy bundle of consumer good k"
   pc(r,k,h,t)          "Price of consumer good k"
   pcnnrg(r,k,h,t)      "Price of non-energy bundle of consumer good k"
   xcnely(r,k,h,t)      "Demand for non-electric bundle of consumer good k"
   xcolg(r,k,h,t)       "Demand for OLG bundle of consumer good k"
   xacNRG(r,k,h,NRG,t)  "Demand for NRG bundle of consumer good k"
   pacNRG(r,k,h,NRG,t)  "Price of NRG bundle of consumer good k"
   pcolg(r,k,h,t)       "Price of OLG bundle of consumer good k"
   pcnely(r,k,h,t)      "Price of non-electric bundle of consumer good k"
   pcnrg(r,k,h,t)       "Price of energy of consumer good k"

   savh(r,h,t)          "Private savings"
   aps(r,h,t)           "Private savings rate out of total household income"
   chiaps(r,t)          "Economy-wide shifter for household saving"

   ygov(r,gy,t)         "Government revenues"

   pfd(r,fd,t)          "Final demand expenditure price index"
   yfd(r,fd,t)          "Value of aggregate final demand expenditures"
   xfd(r,fd,t)          "Volume of aggregate final demand expenditures"

   xat(r,i,t)           "Aggregate Armington demand"
   xdt(r,i,t)           "Domestic demand for domestic production /x xtt"
   xmt(r,i,t)           "Aggregate import demand"
   pat(r,i,t)           "Price of aggregate Armington good"
   pa(r,i,aa,t)         "Price of Armington good at agents' price"

   xw(r,i,rp,t)         "Volume of bilateral trade"
   pmt(r,i,t)           "Price of aggregate imports"

   pdt(r,i,t)           "Producer price of goods sold on domestic markets"
   xet(r,i,t)           "Aggregate exports"
   xs(r,i,t)            "Domestic production of good 'i'"
   pe(r,i,rp,t)         "Producer price of exports"
   pet(r,i,t)           "Producer price of aggregate exports"
   pwe(r,i,rp,t)        "FOB price of exports"
   pwm(r,i,rp,t)        "CIF price of imports"
   pdm(r,i,rp,t)        "End-user price of imports"

   xwmg(r,i,rp,t)       "Demand for tt services from r to rp"
   xmgm(img,r,i,rp,t)   "Demand for tt services from r to rp for service type m"
   pwmg(r,i,rp,t)       "Average price to transport good from r to rp"
   xtmg(img,t)          "Total global demand for tt services m"
   xtt(r,i,t)           "Supply of m by region r"
   ptmg(img,t)          "The average global price of service m"

   ldz(r,l,z,t)         "Labor demand by zone"
   awagez(r,l,z,t)      "Average wage by zone"
   urbPrem(r,l,t)       "Urban wage premium"
   resWage(r,l,z,t)     "Reservation wage"
   chirw(r,l,z,t)       "Reservation wage shifter"
   ewagez(r,l,z,t)      "Equilibrium wage by zone"
   twage(r,l,t)         "Equilibrium wage by skill"
   wage(r,l,a,t)        "Market wage by skill"
   skillprem(r,l,t)     "Skill premium relative to a reference wage"
   tls(r,t)             "Total labor supply"

   migr(r,l,t)          "Level of rural to urban migration"
   migrMult(r,l,z,t)    "Migration multiplier for multi-year time steps"
   lsz(r,l,z,t)         "Labor supply by zone"
   ls(r,l,t)            "Aggregate labor supply by skill"
   gtlab(r,t)           "Growth rate of total labor supply"
   glab(r,l,t)          "Growth of labor supply by skill"
   glabz(r,l,z,t)       "Growth of labor supply by skill and zone"
   wPrem(r,l,a,t)       "Wage premium relative to equilibrium wage"

   pk(r,a,v,t)          "Market price of capital by vintage and activity"
   trent(r,t)           "Aggregate return to capital"

   k0(r,a,t)            "Installed capital at beginning of period"
   kxRat(r,a,v,t)       "Capital output ratio by sector"
   rrat(r,a,t)          "Ratio of return to Old wrt to New capital"
   xpv(r,a,v,t)         "Gross sectoral output by vintage"
   arent(r,t)           "Average return to capital"

   tland(r,t)           "Aggregate land supply"
   chiLand(r,t)         "Total land supply shifter"
   pland(r,a,t)         "Market price of land"
   ptland(r,t)          "Aggregate price index of land"
   ptlandndx(r,t)       "Price index of aggregate land"
   landMax(r,t)         "Maximum available land"
   xlb(r,lb,t)          "Land bundles"
   plb(r,lb,t)          "Average price of land bundles"
   plbndx(r,lb,t)       "Price index of land bundles"
   xnlb(r,t)            "Intermediate land bundle"
   pnlb(r,t)            "Price of intermediate land bundle"
   pnlbndx(r,t)         "Price index of intermediate land bundle"

   etanrf(r,a,t)        "Supply elasticity of natural resource"
   pnrf(r,a,t)          "Market price of natural resource factor"
   chinrf(r,a,t)        "Natural resource supply shifter"
   wchinrf(a,t)         "Global natural resource supply shifter"

   th2o(r,t)            "Aggregate water supply"
   h2oMax(r,t)          "Maximum available water supply"
   th2om(r,t)           "Marketed water supply"
   h2obnd(r,wbnd,t)     "Aggregate water bundles"
   pth2ondx(r,t)        "Aggregate water price index"
   pth2o(r,t)           "Aggregate market price of water"
   ph2obnd(r,wbnd,t)    "Price of aggregate water bundles"
   ph2obndndx(r,wbnd,t) "Price index of aggregate water bundles"
   ph2o(r,a,t)          "Market price of water"
   ph2op(r,a,t)         "End user price of water"

   wagep(r,l,a,t)       "Wage by skill paid by producers"
   pkp(r,a,v,t)         "Price of capital by vintage and activity tax inclusive"
   plandp(r,a,t)        "Price of land paid by producers"
   pnrfp(r,a,t)         "Price of natural resource factor paid by producers"

   savg(r,t)            "Public savings"

*  Closure variables

   rsg(r,t)             "Real government savings"

   rgovshr(r,t)         "Volume share of gov. expenditure in real GDP"
   govshr(r,t)          "Value share of gov. expenditure in nominal GDP"
   rinvshr(r,t)         "Volume share of investment expenditure in real GDP"
   invshr(r,t)          "Value share of investment expenditure in nominal GDP"

   kappal(r,l,t)        "Income tax on labor income"
   kappak(r,t)          "Income tax on capital income"
   kappat(r,t)          "Income tax on land income"
   kappan(r,t)          "Income tax on natural resource income"
   kappaw(r,t)          "Income tax on water income"
   kappah(r,t)          "Direct tax rate"

   kstocke(r,t)         "Anticipated capital stock"
   ror(r,t)             "Net aggregate rate of return to capital"
   rorc(r,t)            "Cost adjusted rate of return to capital"
   rore(r,t)            "Expected rate of return to capital"
   devRoR(r,t)          "Change in rate of return"
   grK(r,t)             "Anticipated growth of the capital stock"
   rord(r,t)            "Deviations from the normal rate of return"
   savf(r,t)            "Foreign savings (real)"
   rorg(t)              "Average expected global rate of return to capital"

   pmuv(t)              "Export price index of manufactured goods from high-income countries"
   pwsav(t)             "Global price of investment good"
   pwgdp(t)             "Global gdp deflator"
   pnum(t)              "Model numeraire"
   pw(a,t)              "World price of activity a"
   walras(t)            "Value of Walras"

*  Macro variables

   gdpmp(r,t)           "Nominal GDP at market price"
   rgdpmp(r,t)          "Real GDP at market price"
   pgdpmp(r,t)          "GDP at market price expenditure deflator"
   rgdppc(r,t)          "Real GDP at market price per capita"
   grrgdppc(r,t)        "Growth rate of real GDP per capita"
   gl(r,t)              "Economy-wide labor productivity growth"

*  Emission variables

* [OECD-ENV]: replace em with AllEmissions

   emi(r,AllEmissions,EmiSource,aa,t)    "Emissions by region and driver"
   emiTot(r,AllEmissions,t) "Total country emissions"
   emiGBL(AllEmissions,t)   "Global emissions"

*  Exogenous emission variables

   emiOth(r,AllEmissions,t)       "Emissions from other sources"
   emiOthGbl(AllEmissions,t)      "Other global emissions"

* [OECD-ENV]: chiEmi is function of r + add chiTotEmi

    chiEmi(r,AllEmissions,t)  "Regional shifter in emissions, by GHG"
    chiTotEmi(r,t)
    chiEmiDet(r,AllEmissions,EmiSource,aa,t)

*  Carbon tax policy variables

    emiTax(r,AllEmissions,t)      "Emissions tax"
    emiCap(ra,AllEmissions,t)     "Emissions cap, by Gas and by coalition"
	emiCapFull(ra,t)              "Emissions cap for multi-gas by coalition"
	emiRegTax(ra,AllEmissions,t)  "Regionwide emissions tax"
	emiQuotaY(r,AllEmissions,t)   "Income from quota rights"
    chiCap(AllEmissions,t)        "Emissions cap shifter"
    chiCapFull(t)                 "Emissions cap shifter"
    emiQuota(r,AllEmissions,t)    "Quota allocation"

* [OECD-ENV]: Permit under ETS regime

    PP_permit(r,aa,t)            "Permit allowances to gross output"
	pEmiPermit(r,AllEmissions,t) "Price of emission permit under ETS"
	emiCapQuota(ra,AllEmissions,t)
	emiCapQuotaFull(ra,t)

*  Normally exogenous variables

	kstock(r,t)          "Non-normalized capital stock"
	tkaps(r,t)           "Total normalized stock of capital"
	pop(r,t)             "Population"

*  Calibrated parameters

	theta(r,k,h,t)       "Subsistence minima"
	muc(r,k,h,t)         "Marginal propensity to consume"
	mus(r,h,t)           "Marginal propensity to save"
	betac(r,h,t)         "Consumption shifter"
	aad(r,h,t)           "AIDADS utility shifter"
	alphaad(r,k,h,t)     "AIDADS MBS linear shifter"
	betaad(r,k,h,t)      "AIDADS MBS slope term"
	omegaad(r,h)         "Auxiliary AIDADS parameter for elasticities"
	etah(r,k,h,t)        "Income elasticities"
	epsh(r,k,kp,h,t)     "Own- and cross-price elasticities"
	alphah(r,k,h,t)      "CDE share parameter"
	eh(r,k,h,t)          "CDE expansion parameter"
	bh(r,k,h,t)          "CDE substitution parameter"
	pxghg(r,a,v,t)       "Price of non-CO2 GHG gas bundle"
	pim(r,a,t)           "Markup over marginal cost of production"
	uez(r,l,z,t)         "Unemployment rate by zone"

*  Dynamic variables

   TFP_xpv(r,a,v,t)     "Uniform shifter in production bundle"
   lambdaxp(r,a,v,t)    "Output shifter in production bundle"
   lambdaghg(r,a,v,t)   "GHG shifter in production bundle"

   lambdanrf(r,a,v,t)   "Natural resource shifter"
   lambdak(r,a,v,t)     "Capital efficiency shifter"
   chiglab(r,l,t)       "Skill bias productivity shifter"
   lambdal(r,l,a,t)     "Labor efficiency shifter"
   lambdat(r,a,v,t)     "Land efficiency shifter"
   lambdah2o(r,a,t)       "Water efficiency shifter"
   lambdah2obnd(r,wbnd,t) "Water efficiency shifter in water bundle use"
   lambdaio(r,i,a,t)    "Efficiency shifter in intermediate demand"
   lambdae(r,e,a,v,t)   "Energy efficiency shifter in production"
   lambdace(r,e,k,h,t)  "Energy efficiency shifter in consumption"

   invGFact(r,t)        "Capital accumulation auxiliary variable"

*  Policy variables

   ptax(r,a,t)          "Output tax/subsidy"
   Taxfp(r,a,fp,t) "Tax/Social contribution rate on primary factor (paid by firms), by sector, by factor"
   Subfp(r,a,fp,t) "Support rate on primary factor (received by firms), by sector, by factor"

   uctax(r,a,v,t)       "Tax/subsidy on unit cost of production"
   paTax(r,i,aa,t)      "Sales tax on Armington consumption"
   pdtax(r,i,aa,t)      "Sales tax on domestically produced goods"
   pmtax(r,i,aa,t)      "Sales tax on imported goods"

   etax(r,i,rp,t)       "Export tax/subsidies"
   tmarg(r,i,rp,t)      "FOB/CIF price wedge"
   mtax(r,i,rp,t)       "Import tax/subsidies"

   dummy                 "dummy variable for DNLP objective"
;

scalar kink "speed of adjustment between the lo and hi elasticities" / 30 / ;

*------------------------------------------------------------------------------*
*           [OECD-ENV]: adding new variables and new parameters                *
*------------------------------------------------------------------------------*

PARAMETERS

    lambdaemi(r,AllEmissions,a,v,t)

    pfda0(r,a) "Final demand expenditure price index"
    yfda0(r,a) "Value of aggregate final demand expenditures"
    xfda0(r,a) "Volume of aggregate final demand expenditures"
    emia0(r,a,AllEmissions) "Sectoral Emissions"
    pxoap0(r,a)
    xoap0(r,a)

	chiLand0(r)         "Initial Total land supply shifter"

    ETPT(r,l,z,t) "aggregate labor supply, by skill and by regional zone"
    implicit_frisch(r,h,t)
    ypc(gdp_unit,r,tt) "GDP per capita : Historical and Projection from ENV-growth (from GDP_gtap_true & MacroENVG(pop))"
    emiTotNonCO2(r,t)   "All NON-CO2 GHG emissions"
    emiTotAllGHG(r,t)   "All GHG emissions (CO2 lulucf excluded)"

    g_io(r,i,a,t)     "Exogenous improvement in intermediate demands (pct)"
    g_kt(r,a,v,t)     "Exogenous improvement in physical capital stock (pct)"
    g_l(r,l,a,t)      "Exogenous improvement in Labor"
    g_fp(r,a,t)       "Primary Factors exogenous improvement in production (ie TFP_fp or TFP on value-added growth rates in pct) "
    g_xpx(r,a,v,t)     "Inputs exogenous improvement in production (ie TFP_xpx or TFP on gross output growth rates in pct) "
    g_xs(r,i,t)       "Exogenous improvement TFP_xs"
    g_natr(r,a,t)     "Exogenous improvement in potential supply of natural resource (chinrf)"

    EmiRCap(r,AllEmissions,tt)    "Regional Emission cap/Target"
    EmiRCap0(r,AllEmissions)
    EmiRInt(r,AllEmissions,t)     " Target: Emission intensity (emi to GDP)"
    stringency(r,t)  "Relative stringency of a policy by region and by period"

    profitTax(r,is,t)   "Tax on pure profit"
    kv_tgt(r,a,v,t)     "sector specific capital target (not normalized)"

    adjKTaxfp(r,fp,a,v)
    adjKSubfp(r,fp,a,v)
    AdjTaxCov(r,is,aa)       "Coverage and type of the tax shock"

	PermitAllocationRule(r,AllEmissions,aa) "Emission permits allocation to sector aa (as a percentage of total permit of ETS)"
	PermitAllowancea(r,AllEmissions,aa,t)   "Permit allowance, by gas, by agent, by year"

* [OECD-ENV] : Activation Flags

    IfCalEmi(r,AllEmissions,EmiSource,aa) "Set 1 to calibrate on total for one gas - Set 2 to calibrate on multi gas total- Set 0 to not change (default)"
    IfExokv(r,a,v) "Set to positive to fix capital - 1 kTax endogenous - 2 pkpShadowPrice"
    IfExtraInva(r,a)
    IfPowFeebates(r,em,EmiSourceAct) "Set 1 to activate feebates on power sector"
	IfAllowance(r) "Set to positive to activate Sectoral quotas (PP_permit)"

* [OECD-ENV] : IfCap and emFlag now more than boolean

*   IfCap(ra) = 1 --> Fix a cap regime defined on total emission
*   IfCap(ra) = 2 --> Fix a cap regime defined on a set of controlled emission

   IfCap(ra)     "Activate Eq. emiCapEQ for emissions cap regimes, by coalition"
   ifEmiQuota(r) "Regions subject to emissions quota regime"

*   emFlag(r,em) = 1 --> Make emiTax endogenous
*   emFlag(r,em) = 2 --> Make emiTax(emn) equals to emiTax(CO2) ? [TBC]
*   emFlag(r,em) = 3 --> Make endogenous another instrument to meet an EmiCap
*                        like chiPtax, Feebates or feed-in tariffs

   emFlag(r,AllEmissions)   "Emission subject to regime"

* [OECD-ENV] : Add new Flag

*   IfEmCap(rq,em) > 0 --> activate emission cap and emiRegTax(rq,em)
*   IfEmCap(rq,em) = 1 --> emiRegTax(rq,em) is endogenous to meet the cap on a given em (GHG)
*   IfEmCap(rq,em) = 2 --> emiRegTax(emn) is endogenous and equal to emiRegTax(CO2)
*   IfEmCap(rq,AllGHG)   = 3 --> multi-gas cap: emiRegTax(AllGHG)
*   IfEmCap(rq,EmSingle) = 3 --> multi-gas cap: emiRegTax(EmSingle)

    IfEmCap(ra,AllEmissions)  "If positive emiRegTax is endogenous"

;

VARIABLES

    lambdafd(r,i,fd,t)   "Efficiency shifter in intermediate demand for Final Demand"
    TFP_fp(r,a,t)        "Value-Added TFP: Hicks-neutral technical progress on Primary Factors Only"
    TFP_xpx(r,a,v,t)     "Gross-Output TFP: Hicks-neutral technical progress"
    TFP_xs(r,i,t)        "TFP in Commodity Supply (xs)"

    Subfp(r,a,fp,t)     "Support rate on primary factor (received by firms), by factor"
    PI0_xa(r,t)          "Absorbtion Price Index (Laspeyre) "
    PI0_xc(r,h,t)        "Consumer Price Index (Laspeyre) "
    wldPm(i,t)           "International Prices of goods as weighted average of Imports CIF prices"
*    p_emissions(r,AllEmissions,EmiSource,aa,t)  "Fixed Price of emissions, by region, by gas, by source and by sector"
    trg(r,t)             "Lump-sum transferts to households (in nominal terms)"
    kaplab(r,t)          "Capital to efficient labour ratio"
    avg_kt(r,t)

    popWA(r,l,z,t) "Working Age Population (15 yr and plus) by skills and by geographical zones (millions of prs)"
    LFPR(r,l,z,t)  "Labour force participation rate by skill and by geographical zone"
    UNR(r,l,z,t)   "Unemployment rate, by skill and by geographical zone (percentage)"
    ERT(r,l,z,t)   "Employment rate, by skill and by geographical zone (percentage)"

    FospCShadowPrice(r,t)   "Shadow Price: Constraint on Fossil-power"
    pkpShadowPrice(r,a,v,t) "Shadow Price controlled capital demand"
    emiaShadowPrice(r,aa,AllEmissions,t)  "Shadow Price: Constraint on emission intensity"

    pfda(r,a,t) "Sector specific investment expenditure price index"
    yfda(r,a,t) "Value  of aggregate Sector specific investment expenditures"
    xfda(r,a,t) "Volume of aggregate Sector specific investment expenditures"

    lambdaoap(r,a,v,t)  "OAP bundle shifter in production bundle"
    xoap(r,a,v,t)       "OAP bundle in production"
    pxoap(r,a,v,t)      "Price of OAP bundle in production"

    overAcc(r,a,v,t)     "Over accumulation of capital"
    emia(r,a,AllEmissions,t) " Controlled Sectoral Emissions"

    Renew(r,t) "Endogenous renewable target if IfElyCES set to 1"
    chiVAT(r,t)  "Endogenous VAT tax shock (for selected good)"
    chiPtax(r,t) "Endogenous production price tax shock"
    acTax(r,aa,t) "Sectoral carbon tax by region and by sector"


* #TODO substitute DirTax to kappak
    DirTax(r,is,t)       "Income tax rate on primary factor / household income"
*   DirTax(l)   = kappal(l)
*   DirTax(cap) = kappak
*   DirTax(lnd) = kappat
*   DirTax(nrs) = kappan
*   DirTax(iw)  = kappaw
*   DirTax(h)   = kappah

;

*------------------------------------------------------------------------------*
*                       DECLARATION EQUATIONS                                  *
*------------------------------------------------------------------------------*

equations
   pxEQ(r,a,t)             "Producer price before tax"
   ucEQ(r,a,v,t)           "Unit cost of production by vintage pre-tax"
   pxvEQ(r,a,v,t)          "Unit cost of production by vintage tax/subsidy inclusive"

   xpxEQ(r,a,v,t)          "Production level exclusive of non-CO2 GHG bundle"
   xghgEQ(r,a,v,t)         "Non-CO2 GHG bundle associated with output"

   nd1EQ(r,a,t)            "Demand for intermediate goods in ND1 bundle"
   vaEQ(r,a,v,t)           "Demand for top level VA bundle"
   pxpEQ(r,a,v,t)          "Cost of production excl non-CO2 GHG bundle"

   lab1EQ(r,a,t)           "Demand for 'unskilled' labor bundle"
   kefEQ(r,a,v,t)          "Demand for KEF bundle (capital+skill+energy+nrf)"
   nd2EQ(r,a,t)            "Demand for intermediate goods in ND2 bundle"
   va1EQ(r,a,v,t)          "Demand for VA1 bundle"
   va2EQ(r,a,v,t)          "Demand for VA2 bundle"
   landEQ(r,a,t)           "Demand for land bundle"
   pvaEQ(r,a,v,t)          "Price of VA bundle"
   pva1EQ(r,a,v,t)         "Price of VA1 bundle"
   pva2EQ(r,a,v,t)         "Price of VA2 bundle"

   kfEQ(r,a,v,t)           "Demand for KF bundle (capital+skill+nrf)"
   xnrgEQ(r,a,v,t)         "Demand for NRG bundle in production"
   pkefEQ(r,a,v,t)         "Price of KEF bundle"

   kswEQ(r,a,v,t)          "Demand for KSW bundle (capital+skill+water)"
   xnrfEQ(r,a,t)           "Demand for NRF factor"
   pkfEQ(r,a,v,t)          "Price of KF bundle"

   ksEQ(r,a,v,t)           "Demand for KS bundle (capital+skill)"
   pkswEQ(r,a,v,t)         "Price of KSW bundle"

   kvEQ(r,a,v,t)           "Demand for K by vintage"
   lab2EQ(r,a,t)           "Demand for 'skilled' labor bundle"
   pksEQ(r,a,v,t)          "Price of KS bundle"

   ldEQ(r,l,a,t)           "Demand for labor by skill and activity"
   plab1EQ(r,a,t)          "Price of 'unskilled' labor bundle"
   plab2EQ(r,a,t)          "Price of 'skilled' labor bundle"

   xapEQ(r,i,a,t)          "Armington demand for intermediate goods, by sector"
   pnd1EQ(r,a,t)           "Price of ND1 bundle"
   pnd2EQ(r,a,t)           "Price of ND2 bundle"

   xnelyEQ(r,a,v,t)        "Demand for non-electric bundle"
   xolgEQ(r,a,v,t)         "Demand for OLG bundle"
   xaNRGEQ(r,a,NRG,v,t)    "Demand for bottom-level energy bundle"
   xaeEQ(r,e,a,t)          "Decomposition of energy bundle with single nest"

   paNRGEQ(r,a,NRG,v,t)    "Price of NRG bundles"
   polgEQ(r,a,v,t)         "Price of OLG bundle"
   pnelyEQ(r,a,v,t)        "Price of ELY bundle"
   pnrgEQ(r,a,v,t)         "Price of energy bundle"

   xEQ(r,a,i,t)            "Production of good 'i' by activity 'a'"
   xpEQ(r,a,t)             "Gross production of activity 'a'"
   pEQ(r,a,i,t)            "Price of good 'i' supplied by activity 'a'"
   psEQ(r,i,t)             "Market price of domestically produced good 'i'"

   xetdEQ(r,etda,elyi,t)    "Demand for electricity transmission and distribution services"
   xpowEQ(r,elyi,t)         "Demand for aggregate power"
   pselyEQ(r,elyi,t)        "Market price of electricity, incl. of ETD"
   xpbEQ(r,pb,elyi,t)       "Demand for power bundles"
   ppowndxEQ(r,elyi,t)      "Price index for aggregate power"

   ppowEQ(r,elyi,t)         "Average price of aggregate power"
   xbndEQ(r,a,elyi,t)       "Demand for power activity powa"
   ppbndxEQ(r,pb,elyi,t)    "Price index for power bundles"
   ppbEQ(r,pb,elyi,t)       "Average price of power bundles"

   deprYEQ(r,t)            "Depreciation income"
   yqtfEQ(r,t)             "Outflow of capital income"
   trustYEQ(t)             "Total capital income outflows"
   yqhtEQ(r,t)             "Foreign capital income inflows"
   remitEQ(rp,l,r,t)       "Remittance outflow to region rp from region r for labor skill l"
   yhEQ(r,t)               "Household income net of depreciation"
   ydEQ(r,t)               "Household disposable income"

   ygovEQ(r,gy,t)          "Government revenues"
   yfdInvEQ(r,inv,t)       "Investment-Saving balance"

   supyEQ(r,h,t)           "Per capita supernumerary income for ELES"
   thetaEQ(r,k,h,t)        "Auxiliary consumption variable for CDE"
   mucEQ(r,k,h,t)          "Marginal budger shares for AIDADS"
   xcEQ(r,k,h,t)           "Aggregate private consumption by sector in k commodity space"
   hshrEQ(r,k,h,t)         "Household budget shares"
   uEQ(r,h,t)              "Household utility"

   xcnnrgEQ(r,k,h,t)       "Consumer demand for non-energy bundle"
   xcnrgEQ(r,k,h,t)        "Consumer demand for energy bundle"
   pcEQ(r,k,h,t)           "Consumer price for good k"
   xacnnrgEQ(r,i,h,t)      "Demand for non-energy commodities in consumption"
   pcnnrgEQ(r,k,h,t)       "Price of non-energy bundle in consumption"
   xcnelyEQ(r,k,h,t)       "Demand for non-electric bundle in consumption"
   xcolgEQ(r,k,h,t)        "Demand for OLG bundle in consumption"
   xacNRGEQ(r,k,h,NRG,t)   "Demand for NRG bundles in consumption"
   xaceEQ(r,e,h,t)         "Demand for energy commodities in consumption"
   pacNRGEQ(r,k,h,NRG,t)   "Price of NRG bundles in consumption"
   pcolgEQ(r,k,h,t)        "Price of OLG bundle in consumption"
   pcnelyEQ(r,k,h,t)       "Price of non-electric bundle in consumption"
   pcnrgEQ(r,k,h,t)        "Price of energy bundle in consumption"

   savhELESEQ(r,h,t)       "Private savings for ELES"
   savhEQ(r,h,t)           "Aggregate household saving for non-ELES or aps for ELES"

   xafEQ(r,i,fdc,t)        "Other final demand for Armington good"
   pfdfEQ(r,fdc,t)         "Other final demand expenditure price index"
   yfdEQ(r,fd,t)           "Aggregate value of final demand expenditure"

   xatEQ(r,i,t)            "Total Armington demand by commodity"
   xdtEQ(r,i,t)            "Domestic demand for domestic production /x xtt"
   xmtEQ(r,i,t)            "Aggregate import demand"
   patEQ(r,i,t)            "Price of aggregate Armington good"

   xdEQ(r,i,aa,t)          "Demand for domestic goods"
   xmEQ(r,i,aa,t)          "Demand for imported goods"

   xwdEQ(rp,i,r,t)         "Demand for imports by region rp sourced in region r"
   pmtEQ(r,i,t)            "Price of aggregate imports"

   pdtEQ(r,i,t)            "Supply of domestic goods"
   xetEQ(r,i,t)            "Aggregate export supply"
   xsEQ(r,i,t)             "Total domestic supply"
   xwsEQ(r,i,rp,t)         "Supply of exports from r to rp"
   petEQ(r,i,t)            "Aggregate price of exports"

   xtmgEQ(img,t)           "Total global demand for tt services m"
   xttEQ(r,img,t)          "Supply of m by region r"
   ptmgEQ(img,t)           "The average global price of service m"

   ldzEQ(r,l,z,t)          "Labor demand by zone"
   awagezEQ(r,l,z,t)       "Average wage by zone"
   uezEQ(r,l,z,t)          "Definition of unemployment"

   twageEQ(r,l,t)          "Average market clearing wage"
   skillpremEQ(r,l,t)      "Skill premium relative to the reference wage"
   wageEQ(r,l,a,t)         "Sectoral wage level"
   lsEQ(r,l,t)             "Aggregate labor supply by skill"
   tlsEQ(r,t)              "Total labor supply"

   pkEQ(r,a,v,t)           "Sectoral return to capital"
   trentEQ(r,t)            "Aggregate return to capital"

   kxRatEQ(r,a,v,t)        "Capital output ratio"
   rratEQ(r,a,t)           "Relative rate of return between Old and New capital"
   rrateq_CNS(r,a,t)

   k0EQ(r,a,t)             "Beginning of period installed capital"
   xpvEQ(r,a,v,t)          "Allocation between old and new capital"

   arentEQ(r,t)            "Average return to capital"

   tlandEQ(r,t)            "Total land supply equation"
   xlb1EQ(r,lb,t)          "Supply of first land bundle"
   xnlbEQ(r,t)             "Supply of intermediate land bundle"
   ptlandndxEQ(r,t)        "Price index of aggregate land"
   ptlandEQ(r,t)           "Aggregate price index of land"
   xlbnEQ(r,lb,t)          "Supply of other land bundles"
   pnlbndxEQ(r,t)          "Price index of intermediate land bundle"
   pnlbEQ(r,t)             "Average price of intermediate land bundle"
   plandEQ(r,a,t)          "Price of land by sector"
   plbndxEQ(r,lb,t)        "Price index of land bundles"
   plbEQ(r,lb,t)           "Average price of land bundles"

   etanrfEQ(r,a,t)         "Natural resource supply elasticity"
   xnrfsEQ(r,a,t)          "Supply of natural resource"

   wagepEQ(r,l,a,t)        "Producer cost of labor"
   pkpEQ(r,a,v,t)          "Producer cost of capital"
   plandpEQ(r,a,t)         "Producer cost of land"
   pnrfpEQ(r,a,t)          "Producer cost of natural resource factor"
   ph2opEQ(r,a,t)          "Producer cost of water factor"

   savgEQ(r,t)             "Nominal government savings"
   rsgEQ(r,t)              "Real government savings"

   rgovshrEQ(r,t)          "Volume share of gov. expenditure in real GDP"
   govshrEQ(r,t)           "Value share of gov. expenditure in nominal GDP"
   rinvshrEQ(r,t)          "Volume share of inv. expenditure in real GDP"
   invshrEQ(r,t)           "Value share of inv. expenditure in nominal GDP"

   kstockeEQ(r,t)          "Anticipated end-of-period capital stock"
   rorEQ(r,t)              "Net aggregate rate of return to capital"
   devRoREQ(r,t)           "Change in rate of return"
   grKEQ(r,t)              "Anticipated growth of the capital stock"
   rorcEQ(r,t)             "Cost adjusted rate of return to capital"
   roreEQ(r,t)             "Expected rate of return to capital"
   savfEQ(r,t)             "Capital account closure"
   rorgEQ(t)               "Average global rate of return"

   pfdhEQ(r,h,t)           "Price consumption expenditure deflator"
   yfdhEQ(r,h,t)           "Nominal household expenditure"
   gdpmpEQ(r,t)            "Nominal GDP at market prices"
   rgdpmpEQ(r,t)           "Real GDP at market prices"
   pgdpmpEQ(r,t)           "GDP at market price deflator"
   rgdppcEQ(r,t)           "Real GDP per capita"
   grrgdppcEQ(r,t)         "Growth of real GDP per capita"

   pmuvEQ(t)               "Export price index of manufactured goods from high-income countries"
   pwgdpEQ(t)              "World GDP deflator"
   pwsavEQ(t)              "Global price of investment good"
   pnumEQ(t)               "Model numéraire"
   pwEQ(a,t)               "World price of activity a"

   walrasEQ(t)             "Checking Walras' Law"

* Emission equations

    emiiEQ(r,AllEmissions,EmiSource,aa,t) "Consumption based emissions"
    emifEQ(r,AllEmissions,EmiFp,a,t)      "Factor-use based emissions"
    emixEQ(r,AllEmissions,emiact,a,t)     "Output based emissions"
    emiTotEQ(r,AllEmissions,t)            "Total regional emissions"
    emiGblEQ(AllEmissions,t)              "Total global emissions"
    emiCapEQ(ra,AllEmissions,t)           "Emission constraint equation"
    emiTaxEQ(r,AllEmissions,t)            "Setting of emissions tax"
    emiQuotaYEQ(r,AllEmissions,t)         "Emissions quota income"

    lszEQ(r,l,z,t)          "Labor supply by zone"
    glabEQ(r,l,t)           "Aggregate labor growth rate by skill"
    invGFactEQ(r,t)         "Investment factor used for dynamic module"
    kstockEQ(r,t)           "Capital accumulation equation"
    tkapsEQ(r,t)            "Capital normalization formula"
    lambdalEQ(r,l,a,t)      "Labor productivity factor"

* [OECD-ENV]: add new equations (including endogenous MAC-curves)

    EQ_PI0_xa(r,t)   "Absorbtion Price Index (Laspeyre) equation"
    EQ_PI0_xc(r,h,t) "Consumer Price Index (Laspeyre) equation"
    EQ_wldPm(i,t)    "International Prices of goods equation"
    pxghgEQ(r,a,v,t) "price of GHG bundle associated with output"

*-HD: Dummy equation for dnlp
    dummyEq          "objective for DNLP"   

;

*------------------------------------------------------------------------------*
*
*  PRODUCTION BLOCK
*
*------------------------------------------------------------------------------*

*   Equation (P-1): Aggregate unit cost

pxEQ(r,a,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
  px(r,a,t)  * xp(r,a,t)
    =e= sum(v, m_true3v(pxv,r,a,v,t) * m_true3vt(xpv,r,a,v,t))
     / [px0(r,a) * xp0(r,a,t)] ;

pp.lo(r,a,t) $ (not tota(a)) = LowerBound ;
px.lo(r,a,t) $ (not tota(a)) = LowerBound ;

*  Equation (P-2): Post-tax unit cost

$OnText
   pxv is the post-tax unit cost
   the tax is applied on the pre-tax unit cost--not the
      same as in the original formulation
      Why is this tax necessary--why not tax output directly?
$OffText

pxvEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
    pxv(r,a,v,t)
        =e= uc0(r,a) * m_uc(r,a,v,t) * [1 + uctax(r,a,v,t)] / pxv0(r,a)
         + {m_Permisact(r,a,t)  / pxv0(r,a)} $ {NOT ghgFlag(r,a)}
*         + sum(AllEmissions $ emia_IntTgt(r,a,AllEmissions,t), emiaShadowPrice(r,a,AllEmissions,t) * emia_IntTgt(r,a,AllEmissions,t)) / pxv0(r,a)
         ;

pxv.lo(r,a,v,t) $(not tota(a)) = LowerBound ;

$OnText
   Top level nest -- CES of output (XPX) and non-CO2 GHG (XGHG)

    xpv(v) = TFP_xpv(r,a,v,t) * CES(lambdaxp * xpx ; lambdaghg * xghg)

   uc is the unit or marginal cost of production pre-tax
$OffText

*  Equation (P-3): Production excl. non-CO2 GHG

xpxEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
  xpx(r,a,v,t)
    =e= axp(r,a,v,t) * ( m_true3vt(xpv,r,a,v,t) / xpx0(r,a,t) )
     * [TFP_xpv(r,a,v,t) * lambdaxp(r,a,v,t)]**(sigmaxp(r,a,v)-1)
     * [m_uc(r,a,v,t) * uc0(r,a) / m_true3v(pxp,r,a,v,t)]**sigmaxp(r,a,v) ;

*  Equation (P-4):  'demand' for non-CO2 GHG: xghg(v) = CES(emi(emiact))
* memo: xoap is determined in "28-model_AltEq.gms"

xghgEQ(r,a,v,t) $ (ts(t) and rs(r) and ghgFlag(r,a))..
  xghg(r,a,v,t)
    =e= aghg(r,a,v,t) * ( m_true3vt(xpv,r,a,v,t) / xghg0(r,a) )
     *  [TFP_xpv(r,a,v,t) * lambdaghg(r,a,v,t)]**(sigmaxp(r,a,v)-1)
     *  [m_uc(r,a,v,t) * uc0(r,a) / m_true3vt(pxghg,r,a,v,t)]**sigmaxp(r,a,v) ;


* Equation (P-5): Pre-tax unit cost

ucEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
 [TFP_xpv(r,a,v,t) * m_uc(r,a,v,t)]**(1-sigmaxp(r,a,v))
   =e= {aghg(r,a,v,t) * [ m_true3vt(pxghg,r,a,v,t)
                         / (lambdaghg(r,a,v,t) * uc0(r,a))]**(1-sigmaxp(r,a,v))
       } $ aghg(r,a,v,t)
    +  {aoap(r,a,v,t) * [m_true3v(pxoap,r,a,v,t)
                         / (lambdaoap(r,a,v,t) * uc0(r,a))]**(1-sigmaxp(r,a,v))
       } $ aoap(r,a,v,t)
    +   axp(r,a,v,t)  * [m_true3v(pxp,r,a,v,t)
                         / (lambdaxp(r,a,v,t)  * uc0(r,a))]**(1-sigmaxp(r,a,v))
    ;

uc.lo(r,a,v,t) $ (Not tota(a)) = LowerBound ;

*------------------------------------------------------------------------------*
*       Second level nest xpx(v) = TFP_xpx(v) . CES(ND1,VA(v))                 *
*------------------------------------------------------------------------------*
$OnText
   Second level nest -- CES of non-specific inputs (ND1) and all other inputs (VA)

   In crops:             ND1 excludes energy and fertilizers (that are part of VA)
   In livestock:         ND1 excludes energy and feed (that are part of VA)
   In all other sectors: ND1 excludes energy (that is part of VA)

$OffText

* Equation (P-6): Demand for ND1 bundle

nd1EQ(r,a,t) $ (ts(t) and rs(r) and nd1Flag(r,a))..
 nd1(r,a,t)
    =e= sum(v, and1(r,a,v,t) * (m_true3vt(xpx,r,a,v,t) / nd10(r,a,t))
              * TFP_xpx(r,a,v,t)**(sigmap(r,a,v)-1)
              * [m_true3v(pxp,r,a,v,t) / m_true2(pnd1,r,a,t)]**sigmap(r,a,v) ) ;

* Equation (P-7): Demand for VA bundle

vaEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
  va(r,a,v,t)
    =e= ava(r,a,v,t) * (m_true3vt(xpx,r,a,v,t) / va0(r,a,t))
     *  TFP_xpx(r,a,v,t)**(sigmap(r,a,v)-1)
     *  [m_true3v(pxp,r,a,v,t) / m_true3v(pva,r,a,v,t)]**sigmap(r,a,v) ;

* Equation (P-8): price of XPX

pxpEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
 [TFP_xpx(r,a,v,t) * pxp(r,a,v,t)]**(1-sigmap(r,a,v))
      =e= and1(r,a,v,t) * (m_true2(pnd1,r,a,t)   / pxp0(r,a))**(1-sigmap(r,a,v))
       +   ava(r,a,v,t) * (m_true3v(pva,r,a,v,t) / pxp0(r,a))**(1-sigmap(r,a,v))
       ;

pxp.lo(r,a,v,t) $ (not tota(a)) = LowerBound ;

*------------------------------------------------------------------------------*
*                      Middle nests: VA, VA1, VA2                              *
*------------------------------------------------------------------------------*

$OnText
   Middle nests: 1.) va
    . In livestock    : va = CES(va1,va2)
    . In other sectors: va = CES(lab1,va1)

   Middle nests: 2.) va1
    . In crops        : VA1 = CES(nd2,va2), with ND2=fertilizers
    . In livestock    : VA1 = CES(lab1,KEF)
    . In other sectors: VA1 = CES(Land,KEF)

   Middle nests: 3.) va2
    . In crops:     VA2 = CES(land,kef)
    . In livestock: VA2 = CES(land,nd2), with ND2=feed
    . In other sectors: There is no VA2

$OffText

* Equation (P-9): Demand for VA1 bundle

va1EQ(r,a,v,t) $ (ts(t) and rs(r) and va1Flag(r,a))..
  va1(r,a,v,t)
    =e= ava1(r,a,v,t) * (m_true3vt(va,r,a,v,t) / va10(r,a,t))
     * [m_true3v(pva,r,a,v,t) / m_true3v(pva1,r,a,v,t)]**sigmav(r,a,v)
     ;

* Equation (P-10): Demand for va2 bundle (only for agriculture activities)

va2EQ(r,a,v,t) $ (ts(t) and rs(r) and va2Flag(r,a))..
 va2(r,a,v,t)
   =e= { ava2(r,a,v,t) * ( m_true3vt(va1,r,a,v,t) / va20(r,a,t))
        * [m_true3v(pva1,r,a,v,t) / m_true3v(pva2,r,a,v,t)]**sigmav1(r,a,v)
       } $ cra(a)
    +  { ava2(r,a,v,t) * ( m_true3vt(va,r,a,v,t) / va20(r,a,t))
        * [m_true3v(pva,r,a,v,t) / m_true3v(pva2,r,a,v,t)]**sigmav(r,a,v)
       } $ lva(a)
    ;

* Equation (P-11): Demand for unskilled labor bundle

lab1EQ(r,a,t) $ (ts(t) and rs(r) and lab1Flag(r,a))..
  lab1(r,a,t)
    =e= {sum(v, alab1(r,a,v,t) * (m_true3vt(va,r,a,v,t) / lab10(r,a,t))
            * [m_true3v(pva,r,a,v,t) / m_true2(plab1,r,a,t)]**sigmav(r,a,v) )
        } $ (NOT lva(a))
     +  {sum(v, alab1(r,a,v,t) * (m_true3vt(va1,r,a,v,t) / lab10(r,a,t))
            * [m_true3v(pva1,r,a,v,t) / m_true2(plab1,r,a,t)]**sigmav1(r,a,v) )
        } $ lva(a)
     ;

* Equation (P-12): Demand for KEF bundle

kefEQ(r,a,v,t) $ (ts(t) and rs(r) and kefFlag(r,a))..
kef(r,a,v,t)
    =e= {  akef(r,a,v,t) * (m_true3vt(va2,r,a,v,t) / kef0(r,a,t))
         * [m_true3v(pva2,r,a,v,t) / m_true3v(pkef,r,a,v,t) ]**sigmav2(r,a,v)
        } $ cra(a)
     +  {  akef(r,a,v,t) * (m_true3vt(va1,r,a,v,t) / kef0(r,a,t))
         * [m_true3v(pva1,r,a,v,t) / m_true3v(pkef,r,a,v,t) ]**sigmav1(r,a,v)
        } $ (not cra(a))
     ;

* Equation (P-13): Demand for ND2 bundle (does not exist for 'other activities')

nd2EQ(r,a,t) $ (ts(t) and rs(r) and nd2Flag(r,a))..
 nd2(r,a,t)
    =e= {sum(v, and2(r,a,v,t) * m_true3vt(va1,r,a,v,t)
         * [m_true3v(pva1,r,a,v,t) / m_true2(pnd2,r,a,t)]**sigmav1(r,a,v)
            ) / nd20(r,a,t)  } $ cra(a)
     +  {sum(v, and2(r,a,v,t) * m_true3vt(va2,r,a,v,t)
         * [m_true3v(pva2,r,a,v,t) / m_true2(pnd2,r,a,t)]**sigmav2(r,a,v)
            ) / nd20(r,a,t)  } $ lva(a)
     ;

* Equation (P-14): Demand for land

landEQ(r,a,t) $ (ts(t) and rs(r) and landFlag(r,a))..
 land(r,a,t)
    =e= { sum(v, aland(r,a,v,t) * m_true3vt(va2,r,a,v,t)
              * m_lambdat(r,a,v,t)**(sigmav2(r,a,v)-1)
              * [m_true3v(pva2,r,a,v,t) / m_true2(plandp,r,a,t)]**sigmav2(r,a,v)
             ) / land0(r,a,t)
        } $ agra(a)
    +   { sum(v, aland(r,a,v,t) * m_true3vt(va1,r,a,v,t)
              * m_lambdat(r,a,v,t)**(sigmav1(r,a,v)-1)
              * [m_true3v(pva1,r,a,v,t) / m_true2(plandp,r,a,t)]**sigmav1(r,a,v)
            ) / land0(r,a,t)
         } $ (not agra(a))
    ;

* Equation (P-15): Price of top-level value added bundle (VA)

pvaEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
 pva(r,a,v,t)**(1-sigmav(r,a,v))
  =e= { alab1(r,a,v,t) * [m_true2(plab1,r,a,t)   / pva0(r,a)]**(1-sigmav(r,a,v))
       + ava1(r,a,v,t) * [m_true3v(pva1,r,a,v,t) / pva0(r,a)]**(1-sigmav(r,a,v))
      } $ (not lva(a))
   +  { ava2(r,a,v,t)  * [m_true3v(pva2,r,a,v,t) / pva0(r,a)]**(1-sigmav(r,a,v))
       + ava1(r,a,v,t) * [m_true3v(pva1,r,a,v,t) / pva0(r,a)]**(1-sigmav(r,a,v))
      } $ lva(a)
   ;

* Equation (P-16): Price of mid-level value added bundle (VA1)

pva1EQ(r,a,v,t) $ (ts(t) and rs(r) and va1Flag(r,a))..
  pva1(r,a,v,t)**(1-sigmav1(r,a,v))
    =e= {   and2(r,a,v,t) * [m_true2(pnd2,r,a,t)    / pva10(r,a)]**(1-sigmav1(r,a,v))
          + ava2(r,a,v,t) * [m_true3v(pva2,r,a,v,t) / pva10(r,a)]**(1-sigmav1(r,a,v))
        } $ cra(a)
      + {  alab1(r,a,v,t) * [m_true2(plab1,r,a,t)   / pva10(r,a)]**(1-sigmav1(r,a,v))
         +  akef(r,a,v,t) * [m_true3v(pkef,r,a,v,t) / pva10(r,a)]**(1-sigmav1(r,a,v))
        } $ lva(a)
      + { {aland(r,a,v,t) * [m_true2(plandp,r,a,t)  / (m_lambdat(r,a,v,t)*pva10(r,a))]**(1-sigmav1(r,a,v)) } $ aland(r,a,v,t)
          + akef(r,a,v,t) * [m_true3v(pkef,r,a,v,t) / pva10(r,a)]**(1-sigmav1(r,a,v))
        } $ axa(a)
      ;

* Equation (P-17): Price of mid-level value added bundle (VA2)

pva2EQ(r,a,v,t) $ (ts(t) and rs(r) and va2Flag(r,a))..
  pva2(r,a,v,t)**(1 - sigmav2(r,a,v))
    =e= aland(r,a,v,t)  * [m_true2(plandp,r,a,t) / (m_lambdat(r,a,v,t) * pva20(r,a))]**(1-sigmav2(r,a,v))
     +  { akef(r,a,v,t) * [pkef(r,a,v,t) / pva20(r,a)]**(1-sigmav2(r,a,v))       } $ cra(a)
     +  { and2(r,a,v,t) * [m_true2(pnd2,r,a,t) / pva20(r,a)]**(1-sigmav2(r,a,v)) } $ lva(a)
     ;

*------------------------------------------------------------------------------*
*           KEF bundle nest disaggregation = CES(kf(v),xnrg(v))                *
*------------------------------------------------------------------------------*

* Equation (P-18): Demand for bundle KF

kfEQ(r,a,v,t) $ (ts(t) and rs(r) and kfFlag(r,a))..
 kf(r,a,v,t)
    =e= akf(r,a,v,t) * (m_true3vt(kef,r,a,v,t) / kf0(r,a,t))
     * [ m_true3v(pkef,r,a,v,t) / m_true3v(pkf,r,a,v,t) ]**sigmakef(r,a,v) ;

* Equation (P-19): Demand for bundle XNRG

xnrgEQ(r,a,v,t) $ (ts(t) and rs(r) and xnrgFlag(r,a))..
 xnrg(r,a,v,t)
    =e= ae(r,a,v,t) * ( m_true3vt(kef,r,a,v,t) / xnrg0(r,a,t))
     * [ m_true3v(pkef,r,a,v,t) / m_true3v(pnrg,r,a,v,t) ]**sigmakef(r,a,v) ;

* Equation (P-20): Price of KEF bundle

pkefEQ(r,a,v,t) $ (ts(t) and rs(r) and kefFlag(r,a))..
  pkef(r,a,v,t)**(1-sigmakef(r,a,v))
    =e= akf(r,a,v,t) * [m_true3v(pkf,r,a,v,t) / pkef0(r,a)]**(1-sigmakef(r,a,v))
     +  ae(r,a,v,t)  * [m_true3v(pnrg,r,a,v,t)/ pkef0(r,a)]**(1-sigmakef(r,a,v))
     ;

pkef.lo(r,a,v,t) = LowerBound ;

*------------------------------------------------------------------------------*
*           KF disaggregation: kf(a,v) = CES(ksw(a,v) ; xnrf(a))               *
*------------------------------------------------------------------------------*

* Equation (P-21): Demand for bundle KSW

kswEQ(r,a,v,t) $ (ts(t) and rs(r) and kFlag(r,a))..
  ksw(r,a,v,t)
    =e=  aksw(r,a,v,t) * ( m_true3vt(kf,r,a,v,t) / ksw0(r,a,t) )
     *  [m_true3v(pkf,r,a,v,t) / m_true3v(pksw,r,a,v,t)]**sigmakf(r,a,v)
     ;

* Equation (P-22): Demand for natural resource

xnrfEQ(r,a,t) $ (ts(t) and rs(r) and nrfFlag(r,a))..
  xnrf(r,a,t)
    =e= sum(v, anrf(r,a,v,t) * m_true3vt(kf,r,a,v,t)
              * m_lambdanrf(r,a,v,t)**(sigmakf(r,a,v)-1)
              * [m_true3v(pkf,r,a,v,t) / m_true2(pnrfp,r,a,t)]**sigmakf(r,a,v)
           ) / xnrf0(r,a) ;

* Equation (P-23): Price of KF bundle

pkfEQ(r,a,v,t) $ (ts(t) and rs(r) and kfFlag(r,a))..
  pkf(r,a,v,t)**(1-sigmakf(r,a,v))
    =e= aksw(r,a,v,t) * [m_true3v(pksw,r,a,v,t) / pkf0(r,a)]**(1-sigmakf(r,a,v))
     + {anrf(r,a,v,t) * [m_true2(pnrfp,r,a,t)   / (pkf0(r,a) * m_lambdanrf(r,a,v,t))]**(1-sigmakf(r,a,v))} $ nrfFlag(r,a) ;

pkf.lo(r,a,v,t) = LowerBound ;

*------------------------------------------------------------------------------*
*   KSW disaggregation: KSW = CES(ks(v) ; xwat)                                *
*------------------------------------------------------------------------------*

* Equation (P-24): Demand for bundle KS

ksEQ(r,a,v,t) $ (ts(t) and rs(r) and kFlag(r,a))..
  ks(r,a,v,t)
    =e= aks(r,a,v,t) * (m_true3vt(ksw,r,a,v,t) / ks0(r,a,t))
     *  [m_true3v(pksw,r,a,v,t) / m_true3v(pks,r,a,v,t)]**sigmakw(r,a,v) ;

* Equation (P-26): Price of KSW bundle

pkswEQ(r,a,v,t) $ (ts(t) and rs(r) and kFlag(r,a))..
   pksw(r,a,v,t)**(1-sigmakw(r,a,v)) =e=
      aks(r,a,v,t)  * [m_true3v(pks,r,a,v,t) / pksw0(r,a)]**(1-sigmakw(r,a,v))
   +  awat(r,a,v,t) * [m_true2(pwat,r,a,t)   / pksw0(r,a)]**(1-sigmakw(r,a,v))
     ;

pksw.lo(r,a,v,t) = LowerBound ;

*  KS disaggregation = CES(m_lambdak * kv ; lab2)

kvEQ(r,a,v,t)
    $ (ts(t) and rs(r) and kFlag(r,a) and (ifExokv(r,a,v) ne 1) and (kv_tgt(r,a,v,t) eq 0))..
  kv(r,a,v,t) =e= ak(r,a,v,t) * (m_true3vt(ks,r,a,v,t) / kv0(r,a,t) )
               *  m_lambdak(r,a,v,t)**(sigmak(r,a,v)-1)
               * [m_true3v(pks,r,a,v,t) / m_true3v(pkp,r,a,v,t) ]**sigmak(r,a,v)
               ;

lab2EQ(r,a,t) $ (ts(t) and rs(r) and lab2Flag(r,a))..
 lab2(r,a,t)
    =e= sum(v, alab2(r,a,v,t) * (m_true3vt(ks,r,a,v,t) / lab20(r,a))
             * [m_true3v(pks,r,a,v,t) / m_true2(plab2,r,a,t)]**sigmak(r,a,v) );

pksEQ(r,a,v,t) $ (ts(t) and rs(r) and kFlag(r,a))..
  pks(r,a,v,t)**(1-sigmak(r,a,v))
    =e= ak(r,a,v,t)
         * [  (m_true3v(pkp,r,a,v,t) - pkpShadowPrice(r,a,v,t) $ {ifExokv(r,a,v) eq 2})
            / (m_lambdak(r,a,v,t) * pks0(r,a))]**(1-sigmak(r,a,v))
     + alab2(r,a,v,t) * [m_true2(plab2,r,a,t) / pks0(r,a)]**(1-sigmak(r,a,v)) ;

pks.lo(r,a,v,t) = LowerBound ;

*  LAB1 & LAB2 disaggregation

ldEQ(r,l,a,t) $ (ts(t) and rs(r) and labFlag(r,l,a))..
  ld(r,l,a,t)
    =e= { alab(r,l,a,t) * (m_true2t(lab1,r,a,t) / ld0(r,l,a,t))
         * m_lambdal(r,l,a,t)**(sigmaul(r,a)-1)
         * [m_true2(plab1,r,a,t) / m_true3b(wagep,SUB,r,l,a,t)]**sigmaul(r,a)
        } $ ul(l)
     +  { alab(r,l,a,t) * (m_true2(lab2,r,a,t) / ld0(r,l,a,t))
         * m_lambdal(r,l,a,t)**(sigmasl(r,a)-1)
         * [m_true2(plab2,r,a,t) / m_true3b(wagep,SUB,r,l,a,t)]**sigmasl(r,a)
        } $ sl(l)
     ;

plab1EQ(r,a,t) $ (ts(t) and rs(r) and lab1Flag(r,a))..
  plab1(r,a,t)**(1-sigmaul(r,a))
    =e= sum(ul, alab(r,ul,a,t)
               * [m_true3b(wagep,SUB,r,ul,a,t) / (plab10(r,a) * m_lambdal(r,ul,a,t))]**(1-sigmaul(r,a))
            ) ;

plab2EQ(r,a,t) $ (ts(t) and rs(r) and lab2Flag(r,a))..
  plab2(r,a,t)**(1-sigmasl(r,a))
    =e= sum(sl, alab(r,sl,a,t)
               * [m_true3b(wagep,SUB,r,sl,a,t) / (plab20(r,a) * m_lambdal(r,sl,a,t))]**(1-sigmasl(r,a))
            ) ;

plab1.lo(r,a,t) = LowerBound ;
plab2.lo(r,a,t) = LowerBound ;

*------------------------------------------------------------------------------*
*       disaggregation of Intermediary Demand Bundles : nd1, nd2               *
*------------------------------------------------------------------------------*

* [OECD-ENV]: move iw specification to 26-model_AltEq.gms

* Equation (X-X): Armington demand for intermediate non-energy commodity

xapEQ(r,i,a,t)
    $ (ts(t) and rs(r) and xaFlag(r,i,a) and (mapi1(i,a) or mapi2(i,a)))..
 xa(r,i,a,t)
    =e= {aio(r,i,a,t) * (m_true2t(nd1,r,a,t) / xa0(r,i,a,t))
          * lambdaio(r,i,a,t)**(sigman1(r,a)-1)
          * [ m_true2(pnd1,r,a,t) / m_true3b(pa,SUB,r,i,a,t)]**sigman1(r,a)
        } $ mapi1(i,a)
     +  {aio(r,i,a,t) * (m_true2t(nd2,r,a,t) / xa0(r,i,a,t))
          * lambdaio(r,i,a,t)**(sigman2(r,a)-1)
          * [ m_true2(pnd2,r,a,t) / m_true3b(pa,SUB,r,i,a,t)]**sigman2(r,a)
        } $ mapi2(i,a)
     ;

pnd1EQ(r,a,t) $ (ts(t) and rs(r) and nd1Flag(r,a))..
  pnd1(r,a,t)**(1-sigman1(r,a))
   =e= sum(mapi1(i,a), aio(r,i,a,t) * [m_true3b(pa,SUB,r,i,a,t) / lambdaio(r,i,a,t)]**(1-sigman1(r,a)))
    / pnd10(r,a) ;

pnd2EQ(r,a,t) $ (ts(t) and rs(r) and nd2Flag(r,a))..
  pnd2(r,a,t)**(1-sigman2(r,a))
   =e= sum(mapi2(i,a), aio(r,i,a,t) * [m_true3b(pa,SUB,r,i,a,t) / lambdaio(r,i,a,t)]**(1-sigman2(r,a)))
    / pnd20(r,a) ;

pnd1.lo(r,a,t) = LowerBound ;
pnd2.lo(r,a,t) = LowerBound ;

*------------------------------------------------------------------------------*
* NRG bundle disaggregation xnrg for single or multiple nests (IfNrgNest > 0)  *
*------------------------------------------------------------------------------*

* Equation (-): Intermediate demand for non-ely bundle

xnelyEQ(r,a,v,t) $ (ts(t) and rs(r) and xnelyFlag(r,a) and IfNrgNest(r,a))..
 xnely(r,a,v,t) =e=
    anely(r,a,v,t) * ( m_true3vt(xnrg,r,a,v,t) / xnely0(r,a,t))
  * [m_true3v(pnrg,r,a,v,t) / m_true3v(pnely,r,a,v,t)]**sigmae(r,a,v) ;

* Equation (-): Intermediate demand for non-OLG bundle

xolgEQ(r,a,v,t) $ (ts(t) and rs(r) and xolgFlag(r,a) and IfNrgNest(r,a))..
 xolg(r,a,v,t) =e=
    aolg(r,a,v,t) * (m_true3vt(xnely,r,a,v,t) / xolg0(r,a,t))
  * [m_true3v(pnely,r,a,v,t) / m_true3v(polg,r,a,v,t)]**sigmanely(r,a,v) ;

xaNRGEQ(r,a,NRG,v,t)
    $ (ts(t) and rs(r) and xaNRGFlag(r,a,NRG) and IfNrgNest(r,a))..
 xaNRG(r,a,NRG,v,t)
    =e= { aNRG(r,a,NRG,v,t) * (m_true3vt(xnrg,r,a,v,t) / xaNRG0(r,a,NRG,t))
          * [m_true3v(pnrg,r,a,v,t) / m_true4v(paNRG,r,a,NRG,v,t)]**sigmae(r,a,v)
        } $ ely(nrg)
     +  { aNRG(r,a,NRG,v,t) * (m_true3vt(xnely,r,a,v,t) / xaNRG0(r,a,NRG,t))
          * [m_true3v(pnely,r,a,v,t) / m_true4v(paNRG,r,a,NRG,v,t)]**sigmanely(r,a,v)
        } $ coa(nrg)
     +  { aNRG(r,a,NRG,v,t) * (m_true3vt(xolg,r,a,v,t) / xaNRG0(r,a,NRG,t))
          * [m_true3v(polg,r,a,v,t) / m_true4v(paNRG,r,a,NRG,v,t)]**sigmaolg(r,a,v)
        } $ {gas(nrg) or oil(nrg)}
     ;

xaeEQ(r,e,a,t) $ (ts(t) and rs(r) and xaFlag(r,e,a))..
 xa(r,e,a,t)
   =e= {sum(v, aeio(r,e,a,v,t) * (m_true3vt(xnrg,r,a,v,t) / xa0(r,e,a,t))
              * lambdae(r,e,a,v,t)**(sigmae(r,a,v)-1)
              * [m_true3v(pnrg,r,a,v,t) / m_true3b(pa,SUB,r,e,a,t)]**sigmae(r,a,v)
        )} $ {not IfNrgNest(r,a)}
    +  {sum(v, sum(NRG $ mape(NRG,e),
          aeio(r,e,a,v,t) * (m_true4vt(xaNRG,r,a,NRG,v,t) / xa0(r,e,a,t))
        * lambdae(r,e,a,v,t)**(sigmaNRG(r,a,NRG,v)-1)
        * [ m_true4v(paNRG,r,a,NRG,v,t) / m_true3b(pa,SUB,r,e,a,t)]**sigmaNRG(r,a,NRG,v)
        ))} $ {IfNrgNest(r,a)}
    ;

paNRGEQ(r,a,NRG,v,t)
    $ (ts(t) and rs(r) and xaNRGFlag(r,a,NRG) and IfNrgNest(r,a))..
  paNRG(r,a,NRG,v,t)**(1-sigmaNRG(r,a,NRG,v)) =e=
      sum(mape(NRG,e), aeio(r,e,a,v,t) * [m_true3b(pa,SUB,r,e,a,t)
        / (lambdae(r,e,a,v,t) * paNRG0(r,a,NRG)) ]**(1-sigmaNRG(r,a,NRG,v)) ) ;

paNRG.lo(r,a,NRG,v,t) =LowerBound ;

polgEQ(r,a,v,t) $ (ts(t) and rs(r) and xolgFlag(r,a) and IfNrgNest(r,a))..
  polg(r,a,v,t)**(1-sigmaolg(r,a,v))
   =e= sum(GAS $ aNRG(r,a,GAS,v,t), aNRG(r,a,GAS,v,t) * [ m_true4v(paNRG,r,a,GAS,v,t) / polg0(r,a)]**(1-sigmaolg(r,a,v)) )
    +  sum(OIL $ aNRG(r,a,OIL,v,t), aNRG(r,a,OIL,v,t) * [ m_true4v(paNRG,r,a,OIL,v,t) / polg0(r,a)]**(1-sigmaolg(r,a,v)) )
    ;

polg.lo(r,a,v,t) =LowerBound ;

pnelyEQ(r,a,v,t) $ (ts(t) and rs(r) and xnelyFlag(r,a) and IfNrgNest(r,a))..
 pnely(r,a,v,t)**(1-sigmanely(r,a,v))
   =e= sum(COA $ aNRG(r,a,COA,v,t), aNRG(r,a,COA,v,t) * [ m_true4v(paNRG,r,a,COA,v,t) / pnely0(r,a)]**(1-sigmanely(r,a,v)) )
    + aolg(r,a,v,t) * [ m_true3v(polg,r,a,v,t) / pnely0(r,a) ]**(1-sigmanely(r,a,v))
    ;

pnely.lo(r,a,v,t) = LowerBound ;

pnrgEQ(r,a,v,t) $ (ts(t) and rs(r) and xnrgFlag(r,a))..
  pnrg(r,a,v,t)**(1-sigmae(r,a,v))
   =e= {sum(e, aeio(r,e,a,v,t) * [m_true3b(pa,SUB,r,e,a,t) / (pnrg0(r,a) * lambdae(r,e,a,v,t))]**(1-sigmae(r,a,v))
       ) }$(not IfNrgNest(r,a))
    +  { sum(ELY $ aNRG(r,a,ELY,v,t), aNRG(r,a,ELY,v,t) * [m_true4v(paNRG,r,a,ELY,v,t) / pnrg0(r,a)]**(1-sigmae(r,a,v)) )
        + anely(r,a,v,t) * [m_true3v(pnely,r,a,v,t) / pnrg0(r,a)]**(1-sigmae(r,a,v))
       } $ IfNrgNest(r,a)
    ;

pnrg.lo(r,a,v,t) = LowerBound ;

*------------------------------------------------------------------------------*
*
*  DOMESTIC SUPPLY BLOCK -- commodity make and use matrix
*
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Each activity 'a' can produce one or more commodities 'i':xp(a) = CET(x(a,i))*
*------------------------------------------------------------------------------*

* si on 1 pdt par secteur gp peut etre soit 1 soit un convertisseur vol val

xEQ(r,a,i,t) $ (ts(t) and rs(r) and gp(r,a,i))..
 0 =e= {x(r,a,i,t) - gp(r,a,i) * (m_true2t(xp,r,a,t) / x0(r,a,i,t))
                   * [m_true3(p,r,a,i,t) * Adjpa(r,a) / m_true2b(pp,SUB,r,a,t)]**omegas(r,a)
       } $ {omegas(r,a) ne inf}
    +  {p(r,a,i,t) * Adjpa(r,a) - m_true2b(pp,SUB,r,a,t) / p0(r,a,i)} $ {omegas(r,a) eq inf}
    ;

* Primal representation

xpEQ(r,a,t) $ (ts(t) and rs(r) and xpFlag(r,a))..
   PP_SUB(r,a,t) * xp(r,a,t)
    =e= sum(i $ gp(r,a,i), m_true3(p,r,a,i,t) * Adjpa(r,a) * m_true3t(x,r,a,i,t))
     / (xp0(r,a,t) * pp0(r,a)) ;

*------------------------------------------------------------------------------*
* Domestic supply of good 'i' can be purchased from one or more activities 'a' *
*------------------------------------------------------------------------------*

*   Specification for single nested xs(i) = CES(x(a,i)) not for Electricity

pEQ(r,a,i,t)
    $ (ts(t) and rs(r) and as(r,a,i,t) and (NOT (IfPower and elya(a))) )..
 0 =e= { x(r,a,i,t) - as(r,a,i,t) * (m_true2(xs,r,i,t) / x0(r,a,i,t))
                    * TFP_xs(r,i,t)**(sigmas(r,i) - 1)
                    * [m_true2(ps,r,i,t) / m_true3(p,r,a,i,t)]**sigmas(r,i)
       } $ {sigmas(r,i) ne inf}
    +  { p(r,a,i,t) - m_true2(ps,r,i,t) / p0(r,a,i)
       } $ {sigmas(r,i) eq inf}
    ;

p.lo(r,a,i,t) $ (not tota(a)) = LowerBound ;

psEQ(r,i,t)
	$ (ts(t) and rs(r) and xsFlag(r,i) and (not (IfPower and elyi(i))) )..
 ps(r,i,t) * xs(r,i,t)
    =e= sum(a $ as(r,a,i,t), m_true3(p,r,a,i,t) * m_true3t(x,r,a,i,t))
     / (ps0(r,i) * xs0(r,i))  ;

ps.lo(r,i,t) = LowerBound ;

$OnText

                CASE 2: Electricity nests case

   Electricity aggregation (case IfPowerNest=1)

                           XS(ELY-c) = TFP_xs . CES(etd-a,XPOW)
                            /\
                           /  \
                      sigmael(elyc)
                         /      \
                      X(ETD)   XPOW = Power generation
									= CES(lambdapow(pb) * xpb(pb))
              (as(r,etd,elyc))          (apow)   with apow(r,elyc) + as(r,etd,elyc) = 1
                                /|\
                             sigmapow(elyc)
                              /  |  \
                             /   |   \
Power bundles:         xpb(pb1)  ..  xpb(pb3):  xpb = CES(lambdapb(powa) * x(powa))
                   (apb(r,pb1,elyc))...
                           /|\           /|\
                sigmapb(r,pb1,elyc) ..  sigmapb(r,pb3,elyc)
                         /  |  \       /  |  \
Power generation:  x(elya1)...x(ely3)
               as(r,elya1,elyc)...

   Electricity aggregation: OECD-ENV case

					  XPOW
                     / |  \   \
                    /  |   \   \
                   /   |    \   \
                  /    |     \   \
Power bundles: Fosp  Nucp   Hydp  Othp
               /|\                 /|\
              / | \               / | \     --> sigmapb / lambdapb
             /  |  \             /  |  \
           clp gsp olp         sol wnd xel


$OffText

*  Electricity Case: Demand for "etda"

xetdEQ(r,etda,elyi,t) $ (ts(t) and rs(r) and as(r,etda,elyi,t) and IfPower)..
  x(r,etda,elyi,t) * [TFP_xs(r,elyi,t)**(1 - sigmael(r,elyi))]
       =e= as(r,etda,elyi,t) * (m_true2(xs,r,elyi,t) / x0(r,etda,elyi,t))
        * [ m_true2(ps,r,elyi,t) / m_true3(p,r,etda,elyi,t) ]**sigmael(r,elyi)
        ;

*  Electricity Case: Demand for power

xpowEQ(r,elyi,t) $ (ts(t) and rs(r) and apow(r,elyi,t) and IfPower)..
  xpow(r,elyi,t) * [TFP_xs(r,elyi,t)**(1 - sigmael(r,elyi))]
       =e= apow(r,elyi,t) * ( m_true2(xs,r,elyi,t) / xpow0(r,elyi,t))
        *  [ m_true2(ps,r,elyi,t) / m_true2(ppow,r,elyi,t) ]**sigmael(r,elyi)
        ;

*  Aggregate price of electricity supply

pselyEQ(r,elyi,t) $ (ts(t) and rs(r) and xsFlag(r,elyi) and IfPower)..
 [ps(r,elyi,t)* TFP_xs(r,elyi,t)]**(1-sigmael(r,elyi)) =e=
  sum(etda, as(r,etda,elyi,t) * [m_true3(p,r,etda,elyi,t) / ps0(r,elyi)]**(1-sigmael(r,elyi)) )
 +          apow(r,elyi,t)    * [m_true2(ppow,r,elyi,t)   / ps0(r,elyi)]**(1-sigmael(r,elyi))
    ;

*  Demand for power bundles

* OECD-ENV: add shadow price associated to Renewable (Fossil) Power constraint: FospCShadowPrice

xpbEQ(r,pb,elyi,t) $ (ts(t) and rs(r) and apb(r,pb,elyi,t) and IfPower)..
 xpb(r,pb,elyi,t)
  * (   {lambdapow(r,pb,elyi,t)**sigmapow(r,elyi)      } $ {NOT IfElyCES}
	  + {lambdapow(r,pb,elyi,t)**(1 - sigmapow(r,elyi))} $ {    IfElyCES}
	)
*   =e= { apb(r,pb,elyi,t) * [ m_true2t(xpow,r,elyi,t) / xpb0(r,pb,elyi,t)]
*        * [  {[    {  m_true2(ppowndx,r,elyi,t) - (1 - RenewTgt(r,t)) * FospCShadowPrice(r,t) }**(sigmapow(r,elyi)-1)
*                * [ { [m_true2(ppowndx,r,elyi,t) - FospCShadowPrice(r,t)] } $ fospbnd(pb) + 1 $ {NOT fospbnd(pb)}]
*               ] / [  m_true3(ppb,r,pb,elyi,t)**sigmapow(r,elyi) ]
*             } $ {sigmapow(r,elyi) }
*           + 1 $ {sigmapow(r,elyi) eq 0} ]
*       } $ {NOT IfElyCES}

	=e= { apb(r,pb,elyi,t) * [ m_true2t(xpow,r,elyi,t) / xpb0(r,pb,elyi,t)]
	   	 * [ {[m_true2(ppowndx,r,elyi,t) / m_true3(ppb,r,pb,elyi,t)]**sigmapow(r,elyi)} $ {sigmapow(r,elyi) }
	        + 1 $ {sigmapow(r,elyi) eq 0} ]
	    } $ {NOT IfElyCES}


     +  { apb(r,pb,elyi,t) * [ m_true2t(xpow,r,elyi,t) / xpb0(r,pb,elyi,t) ]
		 * [ (  [m_true2(ppow,r,elyi,t) + (1 - m_RenewTgt(r,t)) * FospCShadowPrice(r,t) ]
		 	  / [m_true3(ppb,r,pb,elyi,t) + FospCShadowPrice(r,t) $ fospbnd(pb) + (1 - IfProjectFlag) * FospCShadowPrice(r,t) $ Nukebnd(pb)]
		 	)**sigmapow(r,elyi) ]
		} $ {IfElyCES}
   ;

*  Price index for power

ppowndxEQ(r,elyi,t)
    $ (ts(t) and rs(r) and apow(r,elyi,t) and IfPower and sigmapow(r,elyi))..
0 =e= {ppowndx(r,elyi,t)**( - sigmapow(r,elyi))
        - sum(pb $ apb(r,pb,elyi,t), apb(r,pb,elyi,t)
          * [ lambdapow(r,pb,elyi,t) * m_true3(ppb,r,pb,elyi,t)
			 / ppowndx0(r,elyi) ]**( - sigmapow(r,elyi))
      ) } $ {(NOT IfElyCES) and (NOT RenewTgt(r,t))}

   + {ppowndx(r,elyi,t)**( - sigmapow(r,elyi))
        - sum(pb $ apb(r,pb,elyi,t), apb(r,pb,elyi,t)
          * ( lambdapow(r,pb,elyi,t) * m_true3(ppb,r,pb,elyi,t) / ppowndx0(r,elyi))**(-sigmapow(r,elyi))
          * {  1 $ (NOT fospbnd(pb))
             + [ (1 - FospCShadowPrice(r,t) / m_true2(ppowndx,r,elyi,t))**sigmapow(r,elyi) ] $ fospbnd(pb)
            }
      ) } $ {(NOT IfElyCES) and RenewTgt(r,t)}

   + { ppowndx(r,elyi,t) - m_true2(ppow,r,elyi,t) / ppowndx0(r,elyi)
     } $ {IfElyCES}
    ;

*  Average price of power (profit form)

ppowEQ(r,elyi,t) $ (ts(t) and rs(r) and apow(r,elyi,t) and IfPower)..
 ppow(r,elyi,t) * xpow(r,elyi,t)
    =e= sum(pb $ apb(r,pb,elyi,t),
		m_true3(ppb,r,pb,elyi,t) * m_true3t(xpb,r,pb,elyi,t))
     / [xpow0(r,elyi,t) * ppow0(r,elyi)] ;

*   Decomposition of power bundles

* [OECD-ENV]: add case IfElyCES --> could be written in more compact form easily
* this name xbndeq is not adequate --> xpowaEQ would be better

xbndEQ(r,powa,elyi,t) $ (ts(t) and rs(r) and as(r,powa,elyi,t) and IfPower)..
 x(r,powa,elyi,t)
		* sum(mappow(pb,powa),
			  {lambdapb(r,powa,elyi,t)**sigmapb(r,pb,elyi) }    $ {NOT IfElyCES}
		   +  {lambdapb(r,powa,elyi,t)**(1-sigmapb(r,pb,elyi))} $ {    IfElyCES}
			 )
		=e=
			sum{mappow(pb,powa), as(r,powa,elyi,t)
				* [m_true3t(xpb,r,pb,elyi,t) / x0(r,powa,elyi,t) ]
				* [ { [   m_true3(ppbndx,r,pb,elyi,t)
					/ (m_true3(p,r,powa,elyi,t) * Adjpa(r,powa) ) ]**sigmapb(r,pb,elyi)
					} $ sigmapb(r,pb,elyi)
				+ 1 $ { sigmapb(r,pb,elyi) eq 0} ]
			} $ {NOT IfElyCES}
		 +
			sum{mappow(pb,powa), as(r,powa,elyi,t)
				* [m_true3t(xpb,r,pb,elyi,t) / x0(r,powa,elyi,t) ]
				* [  m_true3(ppb,r,pb,elyi,t)
				/( m_true3(p,r,powa,elyi,t) * Adjpa(r,powa) ) ]**sigmapb(r,pb,elyi)
			} $ {IfElyCES}
    ;

*  EQ. Price index for power bundles - "ppbndx"

* [EditJean]: pourquoi sigmapb dans la condition ci-dessous?

ppbndxEQ(r,pb,elyi,t)
    $(ts(t) and rs(r) and apb(r,pb,elyi,t) and IfPower and sigmapb(r,pb,elyi))..
 0 =e= {ppbndx(r,pb,elyi,t)**( - sigmapb(r,pb,elyi))
        - sum(powa $ (mappow(pb,powa) and as(r,powa,elyi,t)), as(r,powa,elyi,t)
            * [  m_true3(p,r,powa,elyi,t) * Adjpa(r,powa)  * lambdapb(r,powa,elyi,t)
                / ppbndx0(r,pb,elyi)
              ]**( - sigmapb(r,pb,elyi))  )
        } $ {NOT IfElyCES}
    +   { ppbndx(r,pb,elyi,t)  - m_true3(ppb,r,pb,elyi,t) / ppbndx0(r,pb,elyi)
        } $ {IfElyCES}
    ;

*  EQ. Average price for power bundles - "ppb"

ppbEQ(r,pb,elyi,t) $ (ts(t) and rs(r) and apb(r,pb,elyi,t) and IFPOWER)..
   ppb(r,pb,elyi,t) * xpb(r,pb,elyi,t)
    =e= sum(powa $ (mappow(pb,powa) and as(r,powa,elyi,t)),
                    m_true3(p,r,powa,elyi,t) * Adjpa(r,powa) *  m_true3t(x,r,powa,elyi,t)
           ) / [ppb0(r,pb,elyi) * xpb0(r,pb,elyi,t)] ;

*------------------------------------------------------------------------------*
*                                                                              *
*                           INCOME BLOCK                                       *
*                                                                              *
*------------------------------------------------------------------------------*

*  Depreciation allowance

deprYEQ(r,t) $ (ts(t) and rs(r) and deprY0(r))..
 deprY(r,t) =e= fdepr(r,t) * m_true1(kstock,r,t) * sum(inv,m_true2(pfd,r,inv,t))
             / deprY0(r) ;

*  Outflow of capital income

yqtfEQ(r,t) $ (rs(r) and ts(t) and yqtf0(r))..
   yqtf(r,t) =e= ydistf(r,t) * (1 - kappak(r,t)) * m_PROFITS(r,t) / yqtf0(r) ;

*  Total outflows of capital income

trustYEQ(t) $ (ts(t) and trustY0 and ifGbl)..
 trustY(t) =e= sum(r, m_true1(yqtf,r,t)) / trustY0 ;

*  Inflow of capital income

yqhtEQ(r,t)$(rs(r) and ts(t) and yqht0(r))..
   yqht(r,t) =e= chiTrust(r,t) * (trustY0 * trustY(t)) / yqht0(r) ;

*  Remittance outflows

remitEQ(rp,l,r,t)$(rs(r) and ts(t) and remit0(rp,l,r))..
  remit(rp,l,r,t)
    =e= chiRemit(rp,l,r,t) * (1-kappal(r,l,t))
     *  sum(a, m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))
     /  remit0(rp,l,r) ;

*  Household income

yhEQ(r,t) $ (ts(t) and rs(r))..
  yh(r,t)
    =e= [ sum(l, (1 - kappal(r,l,t)) * sum(a, m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t)))
         +  (1 - kappat(r,t)) * sum(a $ landFlag(r,a) , m_true2(pland,r,a,t) * m_true2t(land,r,a,t))
         +  (1 - kappan(r,t)) * sum(a $ nrfFlag(r,a)  , m_true2(pnrf,r,a,t)  * m_true2(xnrf,r,a,t) )
         +  (1 - kappaw(r,t)) * sum(a $ xwatfFlag(r,a), m_true2(ph2o,r,a,t)  * m_true2(h2o,r,a,t)  )
         +  [m_true1(yqht,r,t) - m_true1(yqtf,r,t) ]
         +  sum((rp,l), m_true3(remit,r,l,rp,t) - m_true3(remit,rp,l,r,t))
         + ( 1 - sum(cap,profitTax(r,cap,t)))
         * sum((a,v) $ (ifExokv(r,a,v) eq 2), pkpShadowPrice(r,a,v,t) * m_true3vt(kv,r,a,v,t))
         +  (1 - kappak(r,t)) * m_PROFITS(r,t)
        ] / yh0(r)  ;

* [EditJean]: trg is not scaled because equals to zero in starting year

ydEQ(r,t) $ (ts(t) and rs(r))..
   yd(r,t) =e= [ (1 - kappah(r,t)) * m_true1(yh,r,t) + trg(r,t)] / yd0(r) ;

*  Government income

ygovEQ(r,gy,t) $ (ts(t) and rs(r) and ygov0(r,gy))..
   ygov(r,gy,t) =e=

* Output (production) tax

      { sum(a,
          m_pTax(r,a,t) * [m_true2(px,r,a,t) + pim(r,a,t)] * m_true2t(xp,r,a,t)
        + sum(v, uctax(r,a,v,t) * m_true3v(uc,r,a,v,t) * m_true3vt(xpv,r,a,v,t))
        ) / ygov0(r,gy)
      } $ ptx(gy)

* Factor use tax (including social security contributions)

   +  {  sum((a,l)     $ labFlag(r,l,a), Taxfp(r,a,l,t)   * m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))  / ygov0(r,gy)
       + sum((a,v,cap) $ kFlag(r,a)    , adjKTaxfp(r,cap,a,v) * Taxfp(r,a,cap,t)  * m_true3v(pk,r,a,v,t)  * m_true3vt(kv,r,a,v,t)) / ygov0(r,gy)
       + sum((a,lnd)   $ landFlag(r,a) , Taxfp(r,a,lnd,t) * m_true2(pland,r,a,t)  * m_true2t(land,r,a,t) ) / ygov0(r,gy)
       + sum((a,nrs)   $ nrfFlag(r,a)  , Taxfp(r,a,nrs,t) * m_true2(pnrf,r,a,t)   * m_true2(xnrf,r,a,t)  ) / ygov0(r,gy)
       + sum((a,wat)   $ xwatfFlag(r,a), Taxfp(r,a,wat,t) * m_true2(ph2o,r,a,t)   * m_true2(h2o,r,a,t)   ) / ygov0(r,gy)
      } $ vtx(gy)

* Factor use Support (Subfp is positive so put minus above expression below)

   -  {  sum((a,l)     $ labFlag(r,l,a), Subfp(r,a,l,t)   * m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))  / ygov0(r,gy)
       + sum((a,v,cap) $ kFlag(r,a)    , adjKSubfp(r,cap,a,v) * Subfp(r,a,cap,t)  * m_true3v(pk,r,a,v,t)  * m_true3vt(kv,r,a,v,t)) / ygov0(r,gy)
       + sum((a,lnd)   $ landFlag(r,a) , Subfp(r,a,lnd,t) * m_true2(pland,r,a,t)  * m_true2t(land,r,a,t) ) / ygov0(r,gy)
       + sum((a,nrs)   $ nrfFlag(r,a)  , Subfp(r,a,nrs,t) * m_true2(pnrf,r,a,t)   * m_true2(xnrf,r,a,t)  ) / ygov0(r,gy)
       + sum((a,wat)   $ xwatfFlag(r,a), Subfp(r,a,wat,t) * m_true2(ph2o,r,a,t)   * m_true2(h2o,r,a,t)   ) / ygov0(r,gy)
      } $ {vsub(gy) AND NOT IfMergeTaxAndSubfp}

* Sales tax

   +  {sum((i,aa) $ xaFlag(r,i,aa), m_paTax(r,i,aa,t) * gammaeda(r,i,aa)
            * m_true2(pat,r,i,t) * m_true3t(xa,r,i,aa,t) ) / ygov0(r,gy)
      } $ { IfArmFlag eq 0 and itx(gy)}
   +  {  sum((i,aa) $ xdFlag(r,i,aa), pdTax(r,i,aa,t) * gammaedd(r,i,aa)
                * m_true2(pdt,r,i,t) * m_true3(xd,r,i,aa,t) ) / ygov0(r,gy)
       + sum((i,aa) $ xmFlag(r,i,aa), pmTax(r,i,aa,t) * gammaedm(r,i,aa)
                * m_true2(pmt,r,i,t) * m_true3(xm,r,i,aa,t) ) / ygov0(r,gy)
      } $ {IfArmFlag and itx(gy)}

* Import tax

   +  { sum((i,rp) $ xwFlag(rp,i,r),  mtax(rp,i,r,t) * lambdaw(rp,i,r,t)
            * m_true3b(pwm,SUB,rp,i,r,t) * m_true3(xw,rp,i,r,t) ) / ygov0(r,gy)
      } $ mtx(gy)

* Export tax

   +  { sum((i,rp) $ xwFlag(r,i,rp),
				etax(r,i,rp,t) * m_true3(pe,r,i,rp,t) * m_true3(xw,r,i,rp,t)
			) / ygov0(r,gy)
      } $ etx(gy)

* Income tax

    + { sum((a,l) $ labFlag(r,l,a), kappal(r,l,t) * m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t) ) / ygov0(r,gy)
        + kappak(r,t) * m_PROFITS(r,t) / ygov0(r,gy)
        + sum(cap,profitTax(r,cap,t)) * sum((a,v) $ (ifExokv(r,a,v) eq 2), pkpShadowPrice(r,a,v,t) * m_true3vt(kv,r,a,v,t))/ygov0(r,gy)
        + kappat(r,t) * sum(a $ landFlag(r,a), m_true2(pland,r,a,t) * m_true2t(land,r,a,t)) / ygov0(r,gy)
        + kappan(r,t) * sum(a $ nrfFlag(r,a),  m_true2(pnrf,r,a,t)  * m_true2(xnrf,r,a,t) ) / ygov0(r,gy)
        + kappaw(r,t) * sum( a $ xwatfFlag(r,a), m_true2(ph2o,r,a,t) * m_true2(h2o,r,a,t) ) / ygov0(r,gy)
        - trg(r,t) / ygov0(r,gy)
        + kappah(r,t) * m_true1(yh,r,t) / ygov0(r,gy)
      } $ dtx(gy)

*  Carbon tax (#todo OAP)

    + {  sum((i,aa)$xaFlag(r,i,aa), m_Permis(r,i,aa,t)  * m_true3t(xa,r,i,aa,t)
            / ygov0(r,gy) ) $ {NOT IfArmFlag}
        + sum((i,aa), m_Permisd(r,i,aa,t) * m_true3(xd,r,i,aa,t)
            / ygov0(r,gy) ) $ {IfArmFlag}
        + sum((i,aa), m_Permism(r,i,aa,t) * m_true3(xm,r,i,aa,t)
            / ygov0(r,gy) ) $ {IfArmFlag}

		+ sum(a $ xpFlag(r,a),
			  sum((cap,v) $ kFlag(r,a), m_Permisfp(r,cap,a,t) * m_true3vt(kv,r,a,v,t) )
			+ sum(lnd $ landFlag(r,a),  m_Permisfp(r,lnd,a,t) * m_true2t(land,r,a,t) )
			+ {m_Permisact(r,a,t) * m_true2t(xp,r,a,t)}  $ { NOT ghgFlag(r,a) }
			+ { sum((emiact,em) $ emi0(r,em,emiact,a),
				m_EmiPrice(r,em,emiact,a,t) * m_true4(emi,r,em,emiact,a,t) )
			  } $ { ghgFlag(r,a) }
		  ) / ygov0(r,gy)

		- ( sum(a $ xpFlag(r,a),
				PP_permit(r,a,t) * m_true2t(xp,r,a,t)
			   ) $ {IfAllowance(r) eq 1 or IfAllowance(r) eq 2} ) / ygov0(r,gy)
	  } $ ctx(gy)
   ;

*  Investment-Saving market equilibrium

yfdInveq(r,inv,t) $ (ts(t) and rs(r))..
 yfd(r,inv,t) =e= [ sum(h, m_true2(savh,r,h,t))
					+ m_true1(savg,r,t)
					+ pwsav(t) * savf(r,t)
					+  m_true1(deprY,r,t) ] / yfd0(r,inv)
			   +  walras(t) $ { ifGbl and rres(r) } ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       FINAL DEMAND BLOCK                                     *
*                                                                              *
*------------------------------------------------------------------------------*

* Equation (D-1): per capita supernumery income

supyEQ(r,h,t) $ (ts(t) and rs(r)
      and (%utility%=CD or %utility%=LES or %utility%=ELES or %utility%=AIDADS))..
supy(r,h,t)
    =e= [ (m_true1(yd,r,t)
             - { m_true2(savh,r,h,t)} $ { %utility%=CD or %utility%=LES or %utility%=AIDADS} ) ]
             /  [ m_true1(pop,r,t) * supy0(r,h) ]
             - sum(k $ xcFlag(r,k,h), m_true3(pc,r,k,h,t) * m_true3(theta,r,k,h,t) )
             / supy0(r,h)
             ;

* Equation (D-2): Household consumption in household commodity space

xcEQ(r,k,h,t) $ (ts(t) and rs(r)
$IFi %SimType%==Baseline $If %DynCalMethod%=="OECD-ENV" AND (NOT IfCalSect(r,"theta","xc",k,h))
				 and xcFlag(r,k,h) )..
0 =e= { xc(r,k,h,t) - m_true1(pop,r,t)
            * [ m_true3(theta,r,k,h,t) / xc0(r,k,h)
            + m_beta(r,h,k,t) * m_true3(muc,r,k,h,t) * m_true2(supy,r,h,t)
            / ( m_true3(pc,r,k,h,t) * xc0(r,k,h) ) ]
      } $ { %utility%=CD or %utility%=LES or %utility%=ELES or %utility%=AIDADS}
   +  { hshr(r,k,h,t) - (m_true3(theta,r,k,h,t) / hshr0(r,k,h))
             / sum(kp $ xcFlag(r,kp,h), m_true3(theta,r,kp,h,t))
      } $ { %utility%=CDE }
   ;

* Equation (D-4): CDE auxiliary variable [TBC]

thetaEQ(r,k,h,t) $ (ts(t) and rs(r) and xcFlag(r,k,h) and %utility%=CDE)..
 theta(r,k,h,t)
    =e= alphah(r,k,h,t) * bh(r,k,h,t)
     * [m_true3(pc,r,k,h,t) * m_true2(u,r,h,t)**eh(r,k,h,t)]**bh(r,k,h,t)
     * [m_true1(yd,r,t) -  m_true2(savh,r,h,t)]**(-bh(r,k,h,t))
     * m_true1(pop,r,t)**bh(r,k,h,t)
     / theta0(r,k,h)
     ;

* Equation (D-5): Household budget share (out of expenditures on goods and services)

hshrEQ(r,k,h,t) $ (ts(t) and rs(r) and xcFlag(r,k,h))..
  hshr(r,k,h,t) =e= [ m_true3(xc,r,k,h,t) * m_true3(pc,r,k,h,t)
                     / (m_true1(yd,r,t) - m_true2(savh,r,h,t)) ] / hshr0(r,k,h)
                 ;

*  Marginal budget share for AIDADS

mucEQ(r,k,h,t) $ (ts(t) and rs(r) and xcFlag(r,k,h) and %utility%=AIDADS)..
 muc(r,k,h,t)
    =e= [( alphaAD(r,k,h,t) + betaAD(r,k,h,t) * exp(m_true2(u,r,h,t)) )
                 / ( 1 + exp(m_true2(u,r,h,t))) ] / muc0(r,k,h) ;

*  Indirect Utility definition !!!! Currently potential problems with ELES

uEQ(r,h,t) $ (ts(t) and rs(r))..
   0 =e=

* Utility ELES

         { m_true2(u,r,h,t) - 1 } $ {%utility%=ELES and (not uFlag(r,h)) }
      +  {  m_true2(u,r,h,t)
          - m_true2(supy,r,h,t)
          / (    prod(k $ xcFlag(r,k,h), {[m_true3(pc,r,k,h,t) / m_true3(muc,r,k,h,t)]**m_true3(muc,r,k,h,t)} $ {muc.l(r,k,h,t) gt 0} + 1 $ {muc.l(r,k,h,t) le 0} )
             * [ { [m_true2(pfd,r,h,t) / mus(r,h,t)]**mus(r,h,t) } $ {mus.l(r,h,t) gt 0} + 1 $ {mus.l(r,h,t) le 0} ]
            )
        } $ {%utility%=ELES and uFlag(r,h)} !! [Base Case]

* Utility CD, LES or AIDADS

      +  { m_true2(u,r,h,t) + 1 + log(aad(r,h,t))
            - sum(k $ xcFlag(r,k,h), m_true3(muc,r,k,h,t)
                 * log( m_true3(xc,r,k,h,t) / m_true1(pop,r,t) - m_true3(theta,r,k,h,t)) )
         } $ { %utility%=CD or %utility%=LES or %utility%=AIDADS}

* Utility CDE

      +  { 1 - sum(k $ xcFlag(r,k,h), m_true3(theta,r,k,h,t) / bh(r,k,h,t))
         } $ {%utility%=CDE}
      ;

* Equation (D-8): Demand for non-energy bundle by households

xcnnrgEQ(r,k,h,t) $ (ts(t) and rs(r) and xcnnrgFlag(r,k,h))..
 xcnnrg(r,k,h,t) =e= acxnnrg(r,k,h) * (m_true3(xc,r,k,h,t) / xcnnrg0(r,k,h))
                  * [m_true3(pc,r,k,h,t) / m_true3(pcnnrg,r,k,h,t)]**nu(r,k,h)
                  ;

* Equation (D-9): Demand for energy bundle by households

xcnrgEQ(r,k,h,t) $ (ts(t) and rs(r) and xcnrgFlag(r,k,h))..
 xcnrg(r,k,h,t) =e= acxnrg(r,k,h) * (m_true3(xc,r,k,h,t) / xcnrg0(r,k,h))
                 * [m_true3(pc,r,k,h,t) / m_true3(pcnrg,r,k,h,t)]**nu(r,k,h)
                 ;

* Equation (D-10): Price of consumer good k

pcEQ(r,k,h,t) $ (ts(t) and rs(r) and xcFlag(r,k,h))..
 pc(r,k,h,t)**(1-nu(r,k,h))
    =e= { acxnnrg(r,k,h) * [ m_true3(pcnnrg,r,k,h,t) / pc0(r,k,h) ]**(1-nu(r,k,h)) } $ acxnnrg(r,k,h)
     +  { acxnrg(r,k,h)  * [ m_true3(pcnrg,r,k,h,t)  / pc0(r,k,h) ]**(1-nu(r,k,h)) } $ acxnrg(r,k,h)
     ;

* Equation (D-11): Decomposition of non-energy bundle by households

xacnnrgEQ(r,i,h,t) $ (ts(t) and rs(r) and (not e(i)) and xaFlag(r,i,h))..
 xa(r,i,h,t) =e=
    sum(k $ ac(r,i,k,h), ac(r,i,k,h) * (m_true3(xcnnrg,r,k,h,t) / xa0(r,i,h,t))
          * [m_true3(pcnnrg,r,k,h,t) / m_true3b(pa,SUB,r,i,h,t)]**nunnrg(r,k,h)
        ) ;

* Equation (D-12): Price of consumer non-energy goods

pcnnrgEQ(r,k,h,t) $ (ts(t) and rs(r) and xcnnrgFlag(r,k,h))..
 pcnnrg(r,k,h,t)**(1-nunnrg(r,k,h))
    =e= sum( i $ ac(r,i,k,h),  ac(r,i,k,h)
        * [ m_true3b(pa,SUB,r,i,h,t) / pcnnrg0(r,k,h)]**(1-nunnrg(r,k,h)) )
     ;

*  NRG bundle disaggregation -- single and multiple nests

xcnelyEQ(r,k,h,t) $ (ts(t) and rs(r) and xcnelyFlag(r,k,h) and IfNrgNest(r,h))..
 xcnely(r,k,h,t)
    =e= acnely(r,k,h,t) * ( m_true3(xcnrg,r,k,h,t) / xcnely0(r,k,h) )
     * [m_true3(pcnrg,r,k,h,t) / m_true3(pcnely,r,k,h,t) ]**nue(r,k,h)
     ;

xcolgEQ(r,k,h,t) $ (ts(t) and rs(r) and xcolgFlag(r,k,h) and IfNrgNest(r,h))..
 xcolg(r,k,h,t)
    =e= acolg(r,k,h,t) * (m_true3(xcnely,r,k,h,t) / xcolg0(r,k,h))
     *  [ m_true3(pcnely,r,k,h,t) / m_true3(pcolg,r,k,h,t)]**nunely(r,k,h)
     ;

xacNRGEQ(r,k,h,NRG,t)
    $ (ts(t) and rs(r) and xacNRGFlag(r,k,h,NRG) and IfNrgNest(r,h))..
 xacNRG(r,k,h,NRG,t)
    =e= { acNRG(r,k,h,NRG,t) * (m_true3(xcnrg,r,k,h,t) / xacNRG0(r,k,h,NRG))
         * [m_true3(pcnrg,r,k,h,t) / m_true4(pacNRG,r,k,h,NRG,t)]**nue(r,k,h)
        } $ ely(nrg)
    +  { acNRG(r,k,h,NRG,t) * (m_true3(xcnely,r,k,h,t) / xacNRG0(r,k,h,NRG))
         * [m_true3(pcnely,r,k,h,t)/ m_true4(pacNRG,r,k,h,NRG,t)]**nunely(r,k,h)
        } $ coa(nrg)
    +  { acNRG(r,k,h,NRG,t) * (m_true3(xcolg,r,k,h,t) / xacNRG0(r,k,h,NRG))
         * [m_true3(pcolg,r,k,h,t) / m_true4(pacNRG,r,k,h,NRG,t)]**nuolg(r,k,h)
        } $ { gas(nrg) or oil(nrg) }
    ;

xaceEQ(r,e,h,t) $ (ts(t) and rs(r) and xaFlag(r,e,h))..
  xa(r,e,h,t)
    =e= {sum(k,
			    ac(r,e,k,h) * (m_true3(xcnrg,r,k,h,t) / xa0(r,e,h,t))
             * lambdace(r,e,k,h,t)**(nue(r,k,h)-1)
             * [m_true3(pcnrg,r,k,h,t) / m_true3b(pa,SUB,r,e,h,t)]**nue(r,k,h)
		) } $ {not IfNrgNest(r,h)}

     +  {sum(k, sum(mape(NRG,e),
			   ac(r,e,k,h) * (m_true4(xacNRG,r,k,h,NRG,t) / xa0(r,e,h,t))
             * lambdace(r,e,k,h,t)**(nuNRG(r,k,h,NRG)-1)
             * [ m_true4(pacNRG,r,k,h,NRG,t) / m_true3b(pa,SUB,r,e,h,t)]**nuNRG(r,k,h,NRG) )
		) } $ {IfNrgNest(r,h)}
    ;

pacNRGEQ(r,k,h,NRG,t)
    $ (ts(t) and rs(r) and xacNRGFlag(r,k,h,NRG) and IfNrgNest(r,h))..
 pacNRG(r,k,h,NRG,t)**(1-nuNRG(r,k,h,NRG))
    =e= sum(mape(NRG,e), ac(r,e,k,h) * [m_true3b(pa,SUB,r,e,h,t)
            / (lambdace(r,e,k,h,t) * pacNRG0(r,k,h,NRG))]**(1-nuNRG(r,k,h,NRG)))
     ;

* [EditJean]: remove hard-coding for pcolgeq, pcnelyeq and pcnrgeq

pcolgEQ(r,k,h,t) $ (ts(t) and rs(r) and xcolgFlag(r,k,h) and IfNrgNest(r,h))..
  pcolg(r,k,h,t)**(1-nuolg(r,k,h))
    =e= sum(gas, acNRG(r,k,h,gas,t) * [m_true4(pacNRG,r,k,h,gas,t) / pcolg0(r,k,h)]**(1-nuolg(r,k,h)))
     +  sum(oil, acNRG(r,k,h,oil,t) * [m_true4(pacNRG,r,k,h,oil,t) / pcolg0(r,k,h)]**(1-nuolg(r,k,h)))
     ;

pcnelyEQ(r,k,h,t) $ (ts(t) and rs(r) and xcnelyFlag(r,k,h) and IfNrgNest(r,h))..
  pcnely(r,k,h,t)**(1-nunely(r,k,h))
    =e= sum(coa, acNRG(r,k,h,coa,t)
        * [m_true4(pacNRG,r,k,h,coa,t) / pcnely0(r,k,h)] **(1-nunely(r,k,h))  )
     + acolg(r,k,h,t) * [m_true3(pcolg,r,k,h,t) / pcnely0(r,k,h)]**(1-nunely(r,k,h))
     ;

pcnrgEQ(r,k,h,t) $ (ts(t) and rs(r) and xcnrgFlag(r,k,h))..
  pcnrg(r,k,h,t)**(1-nue(r,k,h))
    =e= {sum(e, ac(r,e,k,h)
            * [ m_true3b(pa,SUB,r,e,h,t)
               / (lambdace(r,e,k,h,t) * pcnrg0(r,k,h)) ]**(1-nue(r,k,h)))
        }${not IfNrgNest(r,h)}
     +  {  sum(ely,acNRG(r,k,h,ely,t)
            * [ m_true4(pacNRG,r,k,h,ely,t) / pcnrg0(r,k,h)]**(1-nue(r,k,h)))
			+ acnely(r,k,h,t) * [m_true3(pcnely,r,k,h,t) / pcnrg0(r,k,h)]**(1-nue(r,k,h))
        }${IfNrgNest(r,h)}
   ;

*  Household saving for ELES (mapped with aps)

* #TODO: yd should be function of h

savhELESEQ(r,h,t) $ (ts(t) and rs(r) and %utility% = ELES)..
 savh(r,h,t) =e= m_true1(yd,r,t) / savh0(r,h)
              - sum(k$ xcFlag(r,k,h), m_true3(pc,r,k,h,t) * m_true3(xc,r,k,h,t))
              / savh0(r,h)
              ;

*  Household saving for non-ELES, or aps for ELES (mapped with savh)

savhEQ(r,h,t) $ (ts(t) and rs(r))..
savh(r,h,t) =e= chiaps(r,t) * m_true2(aps,r,h,t) * m_true1(yd,r,t) / savh0(r,h);

*  Other final demand -- investment and government, by commodity

xafEQ(r,i,fdc,t) $ (ts(t) and rs(r) and xa0(r,i,fdc,t))..
 xa(r,i,fdc,t)
    =e= alphafd(r,i,fdc,t) * (m_true2(xfd,r,fdc,t) / xa0(r,i,fdc,t))
     * lambdafd(r,i,fdc,t)**(sigmafd(r,fdc) - 1)
     * [m_true2(pfd,r,fdc,t) / m_true3b(pa,SUB,r,i,fdc,t) ]**sigmafd(r,fdc)
     ;

pfdfEQ(r,fdc,t) $ (ts(t) and rs(r))..
 pfd(r,fdc,t)**(1-sigmafd(r,fdc))
    =e= sum(i, alphafd(r,i,fdc,t)
              * [  m_true3b(pa,SUB,r,i,fdc,t)
                 / (pfd0(r,fdc) * lambdafd(r,i,fdc,t)) ]**(1-sigmafd(r,fdc))
            ) ;

* Eq. Definition total final demand (nominal) by agent (i.e. fd)

yfdEQ(r,fd,t) $ (ts(t) and rs(r) and yfd0(r,fd))..
  yfd(r,fd,t) =e= m_true2(pfd,r,fd,t) * m_true2(xfd,r,fd,t) / yfd0(r,fd) ;

* Eq. definition of the Absorbtion Price Index (Laspeyre)

* [EditJean]: for IfArmFlag = 1 --> xat indefini donc on change ceci
* et on definit en fonction de prix agents ie (VAT included)

EQ_PI0_xa(r,t) $ (ts(t) and rs(r))..
  PI0_xa(r,t)
    =e= sum((i,t0,aa) $ xaFlag(r,i,aa), m_true3b(pa,SUB,r,i,aa,t)  * m_true3t(xa,r,i,aa,t0) )
     /  sum((i,t0,aa) $ xaFlag(r,i,aa), m_true3b(pa,SUB,r,i,aa,t0) * m_true3t(xa,r,i,aa,t0) )
     ;

* Eq. definition of the Consumer Price Index (Laspeyre)

EQ_PI0_xc(r,h,t) $ (ts(t) and rs(r))..
  PI0_xc(r,h,t)
    =e= sum((i,t0)$(not tota(i) and xaFlag(r,i,h)), m_true3b(pa,SUB,r,i,h,t)  *  m_true3t(xa,r,i,h,t0))
     /  sum((i,t0)$(not tota(i) and xaFlag(r,i,h)), m_true3b(pa,SUB,r,i,h,t0) *  m_true3t(xa,r,i,h,t0))
     ;

*------------------------------------------------------------------------------*
*                                                                              *
*                           ARMINGTON BLOCK                                    *
*                                                                              *
*------------------------------------------------------------------------------*

*  Top level -- Armington decomposition: national sourcing

* [EditJean]: rappel 1) avec IfArmFlag =1, les variables xat & pat ne sont plus utilisees
* [EditJean]: IfArmFlag =1 --> armington prix agents (pa) alors que IfArmFlag =0 prix de marche (pat)
* [EditJean]: Add lambdaxd and lambdaxm
* [EditJean]: Why gammaeda(r,i,aa)?

xatEQ(r,i,t) $ (ts(t) and rs(r) and xatFlag(r,i) and (not IfArmFlag))..
 xat(r,i,t) =e= sum(aa$xaFlag(r,i,aa),gammaeda(r,i,aa) * m_true3t(xa,r,i,aa,t)) / xat0(r,i,t) ;

patEQ(r,i,t) $ (ts(t) and rs(r) and xatFlag(r,i) and (not IfArmFlag))..
 pat(r,i,t)**(1-sigmamt(r,i))
    =e= {alphadt(r,i,t) * [m_true2(pdt,r,i,t)
            / (lambdaxd(r,i,t) * pat0(r,i))]**(1-sigmamt(r,i)) } $alphadt(r,i,t)
     +  {alphamt(r,i,t) * [m_true2(pmt,r,i,t)
            / (lambdaxm(r,i,t) * pat0(r,i))]**(1-sigmamt(r,i)) } $alphamt(r,i,t)
    ;

xdtEQ(r,i,t) $ (ts(t) and rs(r) and xdtFlag(r,i))..

 xdt(r,i,t)

* National sourcing

      =e= { alphadt(r,i,t) * (m_true2t(xat,r,i,t) / xdt0(r,i))
           * lambdaxd(r,i,t)**(sigmamt(r,i)-1)
           * [m_true2(pat,r,i,t) / m_true2(pdt,r,i,t)]**sigmamt(r,i)
          } $ {IfArmFlag eq 0 and xddFlag(r,i) and alphadt(r,i,t)}

* Agent sourcing

       +  { sum(aa, gammaedd(r,i,aa) * m_true3(xd,r,i,aa,t)) / xdt0(r,i)
          } $ {IfArmFlag and xddFlag(r,i)}

* Domestic supply of ITT services

       +   m_true2(xtt,r,i,t) / xdt0(r,i)
       ;

xmtEQ(r,i,t) $ (ts(t) and rs(r) and xmtFlag(r,i))..
   xmt(r,i,t)

* National sourcing

      =e= { alphamt(r,i,t) * (m_true2t(xat,r,i,t) / xmt0(r,i))
           *  lambdaxm(r,i,t)**(sigmamt(r,i)-1)
           * [m_true2(pat,r,i,t) / m_true2(pmt,r,i,t)]**sigmamt(r,i)
          } $ {IfArmFlag eq 0}

* Agent sourcing

      +   {sum(aa, gammaedm(r,i,aa) * m_true3(xm,r,i,aa,t)) / xmt0(r,i)
          } $ {IfArmFlag eq 1}
      ;


*  Top level -- Armington decomposition: agent sourcing (IfArmFlag eq 1)

xdEQ(r,i,aa,t) $ (ts(t) and rs(r) and xdFlag(r,i,aa) and IfArmFlag)..
 xd(r,i,aa,t)
    =e= alphad(r,i,aa,t) * (m_true3t(xa,r,i,aa,t) / xd0(r,i,aa))
     * [m_true3(pa,r,i,aa,t) / m_true3b(pd,SUB,r,i,aa,t) ]**sigmam(r,i,aa)
     ;

xmEQ(r,i,aa,t) $ (ts(t) and rs(r) and xmFlag(r,i,aa) and IfArmFlag)..
 xm(r,i,aa,t)
    =e= alpham(r,i,aa,t) * (m_true3t(xa,r,i,aa,t) / xm0(r,i,aa))
     * [m_true3(pa,r,i,aa,t) / m_true3b(pm,SUB,r,i,aa,t) ]**sigmam(r,i,aa)
     ;

*  Second level Armington

xwdEQ(rp,i,r,t) $ (ts(t) and rs(r) and xwFlag(rp,i,r))..
 xw(rp,i,r,t)
    =e= (alphaw(rp,i,r,t) / lambdaw(rp,i,r,t))
     *  (m_true2(xmt,r,i,t) / xw0(rp,i,r))
     *  [m_true2(pmt,r,i,t) / m_true3b(pdm,SUB,rp,i,r,t) ]**sigmaw(r,i)
     ;

pmtEQ(r,i,t) $ (ts(t) and rs(r) and xmtFlag(r,i))..
  pmt(r,i,t)**(1-sigmaw(r,i))
    =e= sum(rp $ xwFlag(rp,i,r), alphaw(rp,i,r,t)
     *  [m_true3b(pdm,SUB,rp,i,r,t) / pmt0(r,i)]**(1-sigmaw(r,i)) )
     ;

*------------------------------------------------------------------------------*
*                                                                              *
*                   DOMESTIC AND EXPORT SUPPLY BLOCK                           *
*                                                                              *
*------------------------------------------------------------------------------*

*   xs = gammad * CET(gammaesd * xdt ; gammaese * xet)

* [EditJean]: correction error below :
*   gammaesd(r,i)**(-1-omegax(r,i))
*   instead of gammaesd(r,i)**(-omegax(r,i))
* PAS CERTAIN gammaesd est pas un facteur efficiency mais price shifter

*   Equation (U-1): "Supply of domestic goods" (Dual expression)

pdtEQ(r,i,t) $ (ts(t) and rs(r) and xdtFlag(r,i))..
   0 =e=

* Finite transformation

         { xdt(r,i,t) - gammad(r,i,t) * (m_true2(xs,r,i,t) / xdt0(r,i))
                      * gammaesd(r,i)**(-1-omegax(r,i))
                      * [m_true2(pdt,r,i,t) / m_true2(ps,r,i,t)]**omegax(r,i)
         } $ {omegax(r,i) ne inf}

* Perfect transformation [Base Case]

      +  { pdt(r,i,t) - gammaesd(r,i) *  m_true2(ps,r,i,t) / pdt0(r,i)
         } $ {omegax(r,i) eq inf} ;

*   Equation (U-2): "Aggregate export supply"

xetEQ(r,i,t) $ (ts(t) and rs(r) and xetFlag(r,i))..
   0 =e=

* Finite transformation


         { xet(r,i,t) - gammae(r,i,t) * (m_true2(xs,r,i,t) / xet0(r,i))
                      * gammaese(r,i)**(-1-omegax(r,i))
                      * [m_true2(pet,r,i,t) / m_true2(ps,r,i,t)]**omegax(r,i)
         } $ {omegax(r,i) ne inf}

* Perfect transformation [Base Case]

      +  { pet(r,i,t) - gammaese(r,i) *  m_true2(ps,r,i,t) / pet0(r,i)
         } $ {omegax(r,i) eq inf}
		 ;

*   Equation (U-3): "Domestic supply"

xsEQ(r,i,t) $ (ts(t) and rs(r) and xsFlag(r,i))..

   0 =e=

* Finite transformation

         { ps(r,i,t)**( 1 + omegax(r,i))
            -  gammad(r,i,t) * [m_true2(pdt,r,i,t) / (ps0(r,i) * gammaesd(r,i))]**(1+omegax(r,i))
            -  gammae(r,i,t) * [m_true2(pet,r,i,t) / (ps0(r,i) * gammaese(r,i))]**(1+omegax(r,i))
         } $ {omegax(r,i) ne inf}

* Perfect transformation [Base Case]

      +  { xs(r,i,t) - gammaesd(r,i) * m_true2(xdt,r,i,t) / xs0(r,i)
                     - gammaese(r,i) * m_true2(xet,r,i,t) / xs0(r,i)
         } $ {omegax(r,i) eq inf}
      ;

*   Equation (U-4): "Export supply from region 'r' to region 'rp' "

xwsEQ(r,i,rp,t) $ (ts(t) and rs(r) and xwFlag(r,i,rp)
               and (ifGbl or (not ifGbl and omegaw(r,i) ne inf)))..

* Finite transformation

 0 =e= { xw(r,i,rp,t) - gammaw(r,i,rp,t) * (m_true2(xet,r,i,t) / xw0(r,i,rp))
                      * gammaew(r,i,rp)**(-1-omegaw(r,i))
                      * [m_true3(pe,r,i,rp,t) / m_true2(pet,r,i,t)]**omegaw(r,i)
       } $ {omegaw(r,i) ne inf}

* Perfect transformation [Base Case]

    +  { pe(r,i,rp,t) - gammaew(r,i,rp) * m_true2(pet,r,i,t) / pe0(r,i,rp)
       } $ {omegaw(r,i) eq inf};

petEQ(r,i,t) $ (ts(t) and rs(r) and xetFlag(r,i))..

*   Equation (U-5): "Aggregate price of exports"

* Perfect transformation [Base Case]

 0 =e= {xet(r,i,t)
        - sum(rp $ xwFlag(r,i,rp), gammaew(r,i,rp) * m_true3(xw,r,i,rp,t)) / xet0(r,i)
	   } $ {omegaw(r,i) eq inf}

* Finite transformation

    +  {pet(r,i,t)**(1+omegaw(r,i))
        - sum(rp $ xwFlag(r,i,rp),  gammaw(r,i,rp,t)
        * [m_true3(pe,r,i,rp,t) / (pet0(r,i) * gammaew(r,i,rp))]**( 1 + omegaw(r,i)) )
        }  $ {omegaw(r,i) ne inf}
    ;

*------------------------------------------------------------------------------*
*                                                                              *
*                           TRADE MARGINS BLOCK                                *
*                                                                              *
*------------------------------------------------------------------------------*

*  Global demand for TT services of type m

xtmgEQ(img,t) $ (ts(t))..
   xtmg(img,t)
   =e= sum((r,i,rp) $ amgm(img,r,i,rp), XMGM_SUB(img,r,i,rp,t) * xmgm0(img,r,i,rp))
   / xtmg0(img) ;

*  Allocation across regions

xttEQ(r,img,t) $ (ts(t) and rs(r) and xttFlag(r,img))..
 xtt(r,img,t) =e= alphatt(r,img,t) * (m_true1(xtmg,img,t) / xtt0(r,img))
               *  [m_true1(ptmg,img,t) / m_true2(pdt,r,img,t)]**sigmamg(img) ;

*  The average global price of mode m

ptmgEQ(img,t) $ (ts(t))..
 ptmg(img,t) * xtmg(img,t)
   =e= sum(r, m_true2(pdt,r,img,t) * m_true2(xtt,r,img,t))
    / ( ptmg0(img) * xtmg0(img) ) ;

*------------------------------------------------------------------------------*
*                                                                              *
*               FACTOR MARKETS: Supply and Equilibrium                         *
*                                                                              *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*                           Labor market                                       *
*------------------------------------------------------------------------------*

*  Labor demand by zone "ldz"

ldzEQ(r,l,z,t) $ (ts(t) and rs(r) and lsFlag(r,l,z))..
  ldz(r,l,z,t) =e= sum(a $ mapz(z,a), m_true3t(ld,r,l,a,t)) / ldz0(r,l,z) ;

*  'Equilibrium condition' -- defines ewagez (or uez)
* [EditJean]: if ueFlag = 0 --> uez and therefore: lsz = ldz eq det ewagez

uezEQ(r,l,z,t) $ (ts(t) and rs(r) and lsFlag(r,l,z))..
   uez(r,l,z,t) =e= 1 - m_true3(ldz,r,l,z,t) / m_true3(lsz,r,l,z,t) ;

*  Definition of sectoral wage net of tax

wageEQ(r,l,a,t) $ (ts(t) and rs(r) and labFlag(r,l,a))..
 wage(r,l,a,t)
   =e= sum(z $ (mapz(z,a) and lsFlag(r,l,z)),
				wPrem(r,l,a,t) * m_true3(ewagez,r,l,z,t) ) / wage0(r,l,a) ;

wage.lo(r,l,a,t) =LowerBound ;

*  Average wage in each zone

awagezEQ(r,l,z,t) $ (ts(t) and rs(r) and lsFlag(r,l,z))..
 awagez(r,l,z,t) =e= sum(mapz(z,a),m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))
                  /  sum(mapz(z,a), awagez0(r,l,z) * m_true3t(ld,r,l,a,t) )
                  ;

*  Average economy-wide wage per skill (equal to awagez with no segmentation)

twageEQ(r,l,t) $ (ts(t) and rs(r) and tlabFlag(r,l))..
  twage(r,l,t)
    =e= sum(a, m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t) )
     /  sum(a, m_true3t(ld,r,l,a,t) * twage0(r,l))
     ;

*  Definition of skill premium relative to 'skill' bundle

skillpremEQ(r,l,t) $ (ts(t) and rs(r) and tlabFlag(r,l))..
 (1 + skillprem(r,l,t)) * twage(r,l,t)
    =e= sum(lr, m_true2(ls,r,lr,t) * m_true2(twage,r,lr,t))
     /  sum(lr, m_true2(ls,r,lr,t) * twage0(r,l))
     ;

*  Definition of aggregate labor supply by skill

lsEQ(r,l,t) $ (ts(t) and rs(r) and tlabFlag(r,l))..
 ls(r,l,t) =e= sum(z $ lsFlag(r,l,z), m_true3(lsz,r,l,z,t)) / ls0(r,l);

*  Definition of aggregate labor supply (useless equation)

tlsEQ(r,t) $ (ts(t) and rs(r))..
  tls(r,t) =e= sum(l, m_true2(ls,r,l,t)) / tls0(r) ;

*------------------------------------------------------------------------------*
*                           Capital market                                     *
*------------------------------------------------------------------------------*

pkEQ(r,a,v,t) $ (ts(t) and rs(r) and kflag(r,a) and (kv_tgt(r,a,v,t) eq 0) )..
  0 =e= {   {   kv(r,a,v,t)
					- gammak(r,a,v,t) * [ m_true1(tkaps,r,t) / kv0(r,a,t) ]
					* [  (m_true3v(pk,r,a,v,t) + overAcc(r,a,v,t))
				        / m_true1(trent,r,t) ]**omegak(r)
			} $ {omegak(r) ne inf}
     +      {  pk(r,a,v,t) + overAcc(r,a,v,t) / pk0(r,a)
					- m_true1(trent,r,t) / pk0(r,a)
			} $ {omegak(r) eq inf}
		} $ { NOT ifVint}
     +  {   pk(r,a,v,t) + overAcc(r,a,v,t) / pk0(r,a)
				- rrat(r,a,t) * m_true1(trent,r,t) / pk0(r,a)
        } $ ifVint
     ;

pk.lo(r,a,v,t) = LowerBound ;

* [TBC]: no overAcc(r,a,v,t) here

trentEQ(r,t) $ (ts(t) and rs(r))..
  tkaps(r,t)
    =e=  {  sum((a,v), m_true3v(pk,r,a,v,t) * m_true3vt(kv,r,a,v,t))
                   / [m_true1(trent,r,t) * tkaps0(r)]  } $ {not ifVint}
     +   { sum((a,v), m_true3vt(kv,r,a,v,t)) / tkaps0(r)} $ {ifVint}
     ;

*  Capital market -- dynamics

kxRatEQ(r,a,vOld,t) $ (ts(t) and rs(r) and ifVint and kFlag(r,a))..
  kxRat(r,a,vOld,t) =e= ( m_true3vt(kv,r,a,vOld,t) / m_true3vt(xpv,r,a,vOld,t) )
                     /  kxRat0(r,a) ;

rratEQ(r,a,t) $ (ts(t) and rs(r) and ifVint and kflag(r,a) and ifMCP eq 1)..
  rrat(r,a,t)**invElas(r,a)
    =l= sum(vOld, m_true3v(kxrat,r,a,vOld,t)) * m_true2t(xp,r,a,t)
     /  m_true2t(k0,r,a,t) ;

* [OECD-ENV]: add a CNS equation

* [EditJean] pourquoi  kxrat(r,a,v,t) et pas  kxrat(r,a,t) car seulement pour Vold

rrateq_CNS(r,a,t) $ (ts(t) and rs(r) and ifVint and kflag(r,a) and ifMCP eq 2)..
  rrat(r,a,t)**invElas(r,a)
    =e= Min{1, sum(vOld, m_true3v(kxrat,r,a,vOld,t)) * m_true2t(xp,r,a,t) / m_true2t(k0,r,a,t) };

k0EQ(r,a,t) $ (ts(t) and ifVint and kFlag(r,a))..
  k0(r,a,t) =e= sum(v, m_true3vt(kv,r,a,v,t-1))
              *  power(1 - AdjDepr(r,a) * depr(r,t), gap(t))
              /  k00(r,a,t) ;

*  Vintage output allocation

xpvEQ(r,a,v,t) $ (ts(t) and rs(r) and xpFlag(r,a))..

* vOld: The first condition is only used for the vintage model

   0 =e= {xpv(r,a,v,t) * kxrat(r,a,v,t)
          - m_true2t(k0,r,a,t) * rrat(r,a,t)**invElas(r,a)
          / (xpv0(r,a,t) * kxRat0(r,a) )
         } $ { vOld(v) and ifVint and xpFlag(r,a) }

* vNew: The following condition is good for CNS and Vintage

      +  {xp(r,a,t) - sum(vp, m_true3vt(xpv,r,a,vp,t)) / xp0(r,a,t)
         } $ { vNew(v) and kFlag(r,a) } ;

xpv.lo(r,a,vOld,t) = LowerBound ;

* [TBC]: no overAcc(r,a,v,t) here

arentEQ(r,t) $ (ts(t) and rs(r))..
  arent(r,t) =e= sum((a,v,t0), m_true3v(pk,r,a,v,t)  * m_true3vt(kv,r,a,v,t0))
              /  sum((a,v,t0), m_true3v(pk,r,a,v,t0) * m_true3vt(kv,r,a,v,t0)) ;

*------------------------------------------------------------------------------*
*                           Land markets (supply)                              *
*------------------------------------------------------------------------------*

*  Total Land supply

tlandEQ(r,t) $ (ts(t) and rs(r) and tlandFlag(r) eq 1)..
 0 =e=

*   KELAS specification [ENV-Linkages choice]

     {tland(r,t) - ( m_true1(chiLand,r,t) / tland0(r))
                  * [m_true1(ptland,r,t) / m_true1(pgdpmp,r,t)]**etat(r)
     } $ {%TASS% eq KELAS}

*  LOGISTIC specification [ENVISAGE choice]

   + {tland(r,t) - [LandMax(r,t) / (1 + m_true1(chiLand,r,t) * exp{ - gammatl(r,t) * [ m_true1(ptland,r,t) / m_true1(pgdpmp,r,t)]} )
           ] / tland0(r)
     } $ {%TASS% eq LOGIST}

*  HYPERBOLIC specification

   + {tland(r,t)
         - [  LandMax(r,t) - m_true1(chiLand,r,t) * [ m_true1(ptland,r,t)  / m_true1(pgdpmp,r,t) ]**(-gammatl(r,t))
           ] / tland0(r)
     } $ {%TASS% eq HYPERB}

*  Infinite supply

   + {ptland(r,t) - m_true1(pgdpmp,r,t) / ptland0(r)
     } $ {%TASS% eq INFTY}
   ;

$OnText

                 TLAND = CET(XLB(lb1),XNLB)
                  / \
                omegat(r)
                /     \
               /       \
         XLB(lb1)    XNLB = CET(XLB(lb2))
       [gamlb(r,lb1)]   [gamnlb(r)]
                        / \
                     omeganlb(r)
                      /     \
                     /       \
             XLB(lb2a)     XLB(lb2b)
           [gamlb(r,lb2a)]  [gamlb(r,lb2b)] ...

 Decompose XLB bundles into Land by agricultural activity

             XLB(lb)
				/|\
    		   / | \
			omegalb(r,lb)
			 /   |   \
		land(a1).....land(an)
	   [gammat(a1)...gammat(an)]


memo for %LandBndNest%=="OneBundle"

xlb(r,"TotalLand",t) with gamlb(r,"TotalLand",t) = 1 ;
xnlb(r) = 0

land(r,cra,t) & land(r,lva,t)
omegalb(r,"TotalLand")

$OffText

*  Top level nest

xlb1EQ(r,lb,t) $ (ts(t) and rs(r) and lb1(lb) and gamlb(r,lb,t) ne 0)..
  0 =e= {plb(r,lb,t) - m_true1(ptland,r,t) / plb0(r,lb) } $ {omegat(r) eq inf}
     +  {xlb(r,lb,t) - gamlb(r,lb,t) * (m_true1(tland,r,t) / xlb0(r,lb))
                     * [m_true2(plb,r,lb,t) / m_true1(ptlandndx,r,t)]**omegat(r)
        } $ {omegat(r) ne inf and omegat(r)}
     +  {xlb(r,lb,t) - gamlb(r,lb,t) * m_true1(tland,r,t) / xlb0(r,lb)
        } $ {omegat(r) eq 0}
     ;

xnlbEQ(r,t) $ (ts(t) and rs(r) and gamnlb(r,t) ne 0)..
 0 =e= {pnlb(r,t) - m_true1(ptland,r,t) / pnlb0(r) } $ {omegat(r) eq inf}
    +  {xnlb(r,t) - gamnlb(r,t) * (m_true1(tland,r,t) / xnlb0(r))
                  * [m_true1(pnlb,r,t) / m_true1(ptlandndx,r,t)]**omegat(r)
       } $ {omegat(r) ne inf and omegat(r)}
    +  {xnlb(r,t) - gamnlb(r,t) * m_true1(tland,r,t) / xnlb0(r)
       } $ {omegat(r) eq 0}
    ;

* Memo: IfLandCET eq 1 (CET case) or 0 (Land conservation)

ptlandndxEQ(r,t) $ (ts(t) and rs(r) and tlandFlag(r) and omegat(r) ne inf)..
 ptlandndx(r,t)**(IfLandCET + omegat(r))
   =e= sum(lb1, gamlb(r,lb1,t)
			  * [m_true2(plb,r,lb1,t) / ptlandndx0(r)]**(IfLandCET + omegat(r)))
    + gamnlb(r,t)* [m_true1(pnlb,r,t) / ptlandndx0(r)]**(IfLandCET + omegat(r))
	;

*  Profit form (because compatible with both IfLandCET = 0 and IfLandCET = 1)

ptlandEQ(r,t) $ (ts(t) and rs(r) and tlandFlag(r))..
 ptland(r,t) * tland(r,t)
   =e= sum(lb1, m_true2(plb,r,lb1,t) * m_true2(xlb,r,lb1,t))
	/ ( ptland0(r) * tland0(r))
    +  [m_true1(pnlb,r,t) * m_true1(xnlb,r,t)] / (ptland0(r) * tland0(r))
	;

*  Second level nest: PEM/MAGNET:  XNLB("FCP") = CET(XLB("COP"), XLB("NCOP"))

xlbnEQ(r,lb,t) $ (ts(t) and rs(r) and (not lb1(lb)) and gamlb(r,lb,t) ne 0)..
 0 =e= {plb(r,lb,t) - m_true1(pnlb,r,t) / plb0(r,lb)
	   } $ {omeganlb(r) eq inf}
    +  {xlb(r,lb,t) - gamlb(r,lb,t) * (m_true1(xnlb,r,t) / xlb0(r,lb))
                    * [m_true2(plb,r,lb,t) / m_true1(pnlbndx,r,t)]**omeganlb(r)
       } $ {omeganlb(r) ne inf}
	;

pnlbndxEQ(r,t) $ (ts(t) and rs(r) and gamnlb(r,t) ne 0 and omeganlb(r) ne inf)..
 pnlbndx(r,t)**( IfLandCET + omeganlb(r) )
   =e= sum(lb $ (NOT lb1(lb)), gamlb(r,lb,t)
    * [m_true2(plb,r,lb,t) / pnlbndx0(r)]**(IfLandCET+omeganlb(r))  )
	;

pnlbEQ(r,t) $ (ts(t) and rs(r) and gamnlb(r,t) ne 0)..
 pnlb(r,t) * xnlb(r,t)
   =e= sum(lb $ (NOT lb1(lb)), m_true2(plb,r,lb,t) * m_true2(xlb,r,lb,t))
    / (pnlb0(r) * xnlb0(r))
	;

*  Bottom nests decompostion: Supply for land XLB=CET(land)

plandEQ(r,a,t) $ (ts(t) and rs(r) and landFlag(r,a))..
 0 =e= sum(lb $ maplb(lb,a),
        { pland(r,a,t) - m_true2(plb,r,lb,t) / pland0(r,a)
        } $ {omegalb(r,lb) eq inf}
      + { land(r,a,t) - gammat(r,a,t) * [m_true2(xlb,r,lb,t) / land0(r,a,t)]
				* [m_true2(pland,r,a,t) / m_true2(plbndx,r,lb,t)]**omegalb(r,lb)
        } $ {omegalb(r,lb) ne inf}
    )  ;

plbndxEQ(r,lb,t)
    $ (ts(t) and rs(r) and (gamlb(r,lb,t) ne 0) and (omegalb(r,lb) ne inf))..
 plbndx(r,lb,t)**(IfLandCET + omegalb(r,lb))
   =e= sum(a $ maplb(lb,a), gammat(r,a,t)
		* [m_true2(pland,r,a,t) / plbndx0(r,lb)]**(IfLandCET+omegalb(r,lb)) )
	;

plbEQ(r,lb,t) $ (ts(t) and rs(r) and (gamlb(r,lb,t) ne 0))..
 plb(r,lb,t) * xlb(r,lb,t)
   =e= sum(a $ maplb(lb,a), m_true2(pland,r,a,t) * m_true2t(land,r,a,t))
    / [ plb0(r,lb) * xlb0(r,lb) ]
	;

ptland.lo(r,t)    = LowerBound ;
pnlbndx.lo(r,t)   = LowerBound ;
plb.lo(r,lb,t)    = LowerBound ;
plbndx.lo(r,lb,t) = LowerBound ;

*------------------------------------------------------------------------------*
*                 Market for natural resources                                 *
*------------------------------------------------------------------------------*

*   Memo: sigmoid is a logistic function

etanrfEQ(r,a,t)
    $ ((nrfFlag(r,a) ne 0) and (nrfFlag(r,a) ne inf) and ts(t) and rs(r))..
 etanrf(r,a,t)  =e= etanrfx(r,a,"lo")
				 + { [etanrfx(r,a,"hi") - etanrfx(r,a,"lo")]
				    * sigmoid( kink * ( xnrf(r,a,t) / xnrf(r,a,t-1)-1) )
				   } $ { etanrfx(r,a,"hi") ne etanrfx(r,a,"lo") }
	;

* [EditJean]: unscaled equation [memo diff in ENV-Linkages]

xnrfsEQ(r,a,t) $ (ts(t) and rs(r) and nrfFlag(r,a))..
   0 =e= {xnrf(r,a,t)
            - wchinrf(a,t) * chinrf(r,a,t) * xnrf(r,a,t-1)
            * [ chinrfp(r,a)
               * (pnrf(r,a,t)   / pgdpmp(r,t))
               / (pnrf(r,a,t-1) / pgdpmp(r,t-1)) ]**etanrf(r,a,t)
         } $ { nrfFlag(r,a) ne inf }
      +  {chinrfp(r,a) * pnrf(r,a,t) - m_true1(pgdpmp,r,t) / pnrf0(r,a)
         } $ { nrfFlag(r,a) eq inf } ;

pnrf.lo(r,a,t) =LowerBound ;

*------------------------------------------------------------------------------*
*                Producer prices for factor (scaled)                           *
*------------------------------------------------------------------------------*

* OECD-ENV: Add emissions price for pkp and plandp + add factor support

wagepEQ(r,l,a,t) $ (ts(t) and rs(r) and labFlag(r,l,a) and (not IfSub))..
 wagep(r,l,a,t) =e=  (1 + m_netTaxfp(r,a,l,t)) * m_true3(wage,r,l,a,t)
                /  wagep0(r,l,a) ;

pkpEQ(r,a,v,t) $ (ts(t) and rs(r) and kFlag(r,a))..
 pkp(r,a,v,t) =e= (1 + sum(cap,m_ktax(r,a,cap,v,t)))
			   * m_true3v(pk,r,a,v,t) / pkp0(r,a)
               + sum(cap, m_Permisfp(r,cap,a,t)) / pkp0(r,a) ;


plandpEQ(r,a,t) $ (ts(t) and rs(r) and landFlag(r,a))..
 plandp(r,a,t)=e= (1 +  sum(lnd,m_netTaxfp(r,a,lnd,t))) * m_true2(pland,r,a,t) / plandp0(r,a)
               + sum(lnd,m_Permisfp(r,lnd,a,t)) / plandp0(r,a) ;

pnrfpEQ(r,a,t) $ (ts(t) and rs(r) and nrfFlag(r,a))..
 pnrfp(r,a,t) =e= (1 + sum(nrs,m_netTaxfp(r,a,nrs,t))) * m_true2(pnrf,r,a,t) / pnrfp0(r,a) ;


ph2opEQ(r,a,t) $ (ts(t) and rs(r) and xwatfFlag(r,a))..
 ph2op(r,a,t) =e= (1 + sum(wat,m_netTaxfp(r,a,wat,t))) * m_true2(ph2o,r,a,t) / ph2op0(r,a) ;

wagep.lo(r,l,a,t) $ (not tota(a)) = LowerBound ;
pkp.lo(r,a,v,t)   $ (not tota(a)) = LowerBound ;
plandp.lo(r,a,t)  $ (not tota(a)) = LowerBound ;
pnrfp.lo(r,a,t)   $ (not tota(a)) = LowerBound ;

*------------------------------------------------------------------------------*
*                                                                              *
*                           GDP definitions                                    *
*                                                                              *
*------------------------------------------------------------------------------*

* Final demand aggregate price at Agent's price

pfdhEQ(r,h,t) $ (ts(t) and rs(r))..
  pfd(r,h,t)
    =e= chi(r,h) * sum(i, phia(r,i,h,t) * m_true3b(pa,SUB,r,i,h,t))
     /  pfd0(r,h) ;

yfdhEQ(r,h,t) $ (ts(t) and rs(r))..
  yfd(r,h,t)
    =e= sum(i $ xaFlag(r,i,h), m_true3b(pa,SUB,r,i,h,t) * m_true3t(xa,r,i,h,t) )
     / yfd0(r,h) ;

gdpmpEQ(r,t) $ (ts(t) and rs(r))..
  gdpmp(r,t)
   =e= (  sum(fd, m_true2(xfd,r,fd,t) * m_true2(pfd,r,fd,t) )
        + sum((i,rp) $ xwFlag(r,i,rp), m_true3b(pwe,SUB,r,i,rp,t) * m_true3(xw,r,i,rp,t)  )
        - sum((i,rp) $ xwFlag(rp,i,r), m_true3b(pwm,SUB,rp,i,r,t) * lambdaw(rp,i,r,t) * m_true3(xw,rp,i,r,t) )
        + sum(img, m_true2(pdt,r,img,t) * m_true2(xtt,r,img,t) )
       ) / rgdpmp0(r)
    ;

rgdpmpEQ(r,t) $ (ts(t) and rs(r))..
  rgdpmp(r,t)
    =e= sum(t0,
          sum(fd, m_true2(xfd,r,fd,t) * m_true2(pfd,r,fd,t0) )
        + sum((i,rp) $ xwFlag(r,i,rp), m_true3b(pwe,SUB,r,i,rp,t0) * m_true3(xw,r,i,rp,t)  )
        - sum((i,rp) $ xwFlag(rp,i,r), m_true3b(pwm,SUB,rp,i,r,t0) * lambdaw(rp,i,r,t) * m_true3(xw,rp,i,r,t) )
        + sum(img, m_true2(pdt,r,img,t0) * m_true2(xtt,r,img,t) )
           ) / rgdpmp0(r)
     ;

pgdpmpEQ(r,t) $ (ts(t) and rs(r))..
  pgdpmp(r,t) =e= m_true1(gdpmp,r,t) / [m_true1(rgdpmp,r,t) * pgdpmp0(r)] ;

rgdppcEQ(r,t) $ (ts(t) and rs(r))..
  rgdppc(r,t) =e= m_true1(rgdpmp,r,t) / [ m_true1(pop,r,t) * rgdppc0(r) ] ;

grrgdppcEQ(r,t) $ (ts(t) and rs(r))..
  rgdppc(r,t) =e= power(1 + 0.01 * grrgdppc(r,t), gap(t)) * rgdppc(r,t-1) ;

*------------------------------------------------------------------------------*
*                                                                              *
*                               MODEL CLOSURE                                  *
*                                                                              *
*------------------------------------------------------------------------------*

savgEQ(r,t) $ (ts(t) and rs(r))..
  savg(r,t) =e= [  sum(gy, m_true2(ygov,r,gy,t))
                 + sum(AllEmissions, emiQuotaY(r,AllEmissions,t))
                 + TotTransfert(r,t)
                 - sum(gov, m_true2(yfd,r,gov,t))
                 - sum(r_d, m_true2(yfd,r,r_d,t))
                 ] / savg0(r)
             ;

* implicitly mapped with closure rule

rsgEQ(r,t) $ (ts(t) and rs(r))..
  rsg(r,t) * pgdpmp(r,t) =e= m_true1(savg,r,t) / pgdpmp0(r);
  
Variables
   rfdshr(r,fd,t)       "Real volume share wrt GDP"
   nfdshr(r,fd,t)       "Nominal value share wrt GDP"
;

Equations
   rfdshrEQ(r,fd,t)     "Real volume share wrt GDP"
   nfdshrEQ(r,fd,t)     "Nominal value share wrt GDP"
;
  
rfdshrEQ(r,fd,t)$(ts(t) and rs(r) and fdc(fd))..
   rfdshr(r,fd,t) * rgdpmp(r,t) =e= m_true2(xfd, r, fd, t) / rgdpmp0(r) ;

nfdshrEQ(r,fd,t)$(ts(t) and rs(r) and fdc(fd))..
   nfdshr(r,fd,t) * gdpmp(r,t) =e= m_true2(yfd, r, fd, t) / gdpmp0(r) ;

rgovshrEQ(r,t) $ (ts(t) and rs(r))..
  rgovshr(r,t) * rgdpmp(r,t) =e= sum(gov, m_true2(xfd,r,gov,t)) / rgdpmp0(r) ;

govshrEQ(r,t) $ (ts(t) and rs(r))..
  govshr(r,t) * gdpmp(r,t) =e= sum(gov, m_true2(yfd,r,gov,t)) / gdpmp0(r) ;

rinvshrEQ(r,t) $ (ts(t) and rs(r))..
  rinvshr(r,t) * rgdpmp(r,t) =e= sum(inv, m_true2(xfd,r,inv,t)) / rgdpmp0(r) ;

invshrEQ(r,t) $ (ts(t) and rs(r))..
  invshr(r,t) * gdpmp(r,t) =e= sum(inv, m_true2(yfd,r,inv,t)) / gdpmp0(r) ;

* implicitely kstocke0 = kstock0

kstockeEQ(r,t) $ (ts(t) and rs(r))..
  kstocke(r,t) =e= (1-depr(r,t)) * kstock(r,t)
*HRR                + sum(inv, m_true2(xfd,r,inv,t)) / kstock0(r)  ;
*HRR: included InvLoss(r,t)
                + InvLoss(r,t) * sum(inv, m_true2(xfd,r,inv,t)) / kstock0(r)  ;

rorEQ(r,t) $ (ts(t) and rs(r))..
  ror(r,t) =e= chiKaps0(r) * (1 - kappak(r,t)) * m_true1(trent,r,t) / ror0(r) ;

rorcEQ(r,t) $ (ts(t) and rs(r))..
  rorc(r,t) =e= [m_true1(ror,r,t) / sum(inv, m_true2(pfd,r,inv,t)) - depr(r,t)]
             / rorc0(r) ;

roreEQ(r,t) $ (ts(t) and rs(r))..
 rore(r,t) * rore0(r)
    =e= {m_true1(rorc,r,t) * [kstocke(r,t) / kstock(r,t)]**(-epsRor(r,t))
        } $ { (%savfFlag% eq capFlexGTAP) or (%savfFlag% eq capFix)}
     +  {  [m_true1(ror,r,t) / sum(inv,m_true2(pfd,r,inv,t)) + (1 - depr(r,t))]
         / (1 + intRate) - 1
        } $ { %savfFlag% eq capFlexUSAGE }
     ;

devRoREQ(r,t) $ (ts(t) and rs(r) and %savfFlag% eq capFlexUSAGE)..
   devRoR(r,t) =e= m_true1(rore,r,t) - rorn(r,t) - rord(r,t) - rorg(t) ;

grKEQ(r,t) $ (ts(t) and rs(r))..
 sum(inv, m_true2(xfd,r,inv,t))
    =e= m_true1(kstock,r,t) * (grK(r,t) + depr(r,t)) ;

* Base Case: ifSavfEQ(r) = 0
* Alternative case: %savfFlag% = capFix

savfEQ(r,t) $ (ts(t) and rs(r) and ifSavfEQ(r))..
 0 =e=  {
            riskPrem(r,t) * m_true1(rore,r,t) - rorg(t) * rorg0
		} $ {%savfFlag% eq capFlexGTAP}

     +  {

        $$IFi %Simtype%=="baseline" {savf(r,t) - savfBar(r,t)} $ {not rres(r)}

        $$IFi %Simtype%=="variant"  {savf(r,t) - savfBar(r,t) * [gdpmp(r,t) / gdpmp_bau(r,t)]} $ {not rres(r)}

          + {sum(rp, savf(rp,t)) } $ rres(r)

        } $ {%savfFlag% eq capFix}

     +  { grk(r,t) - [  grKMax(r,t) * exp( chigrK(r,t) * devRoR(r,t) )
                      + grKMin(r,t) * m_logasc(r,t)]
                   / [ exp( chigrK(r,t) * devRoR(r,t) ) + m_logasc(r,t)]
        } $ {%savfFlag% eq capFlexUSAGE}
     ;


* "Average expected global rate of return to capital"

* En calibration savf.fx est fixe
* donc pour le moment je retire cette equation de "3-ModelDefinition.gms"

rorgEQ(t) $ (ts(t) and ifGbl)..
   0 =e= { sum(r, savf(r,t)) } $ {%savfFlag% ne capFix}
      +  {   rorg(t) * rorg0
          - sum(r, m_netInvShr(r,t) * m_true1(rore,r,t))
		  } $ {%savfFlag% eq capFix} ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       Eqs for price anchors                                  *
*                                                                              *
*------------------------------------------------------------------------------*

$OnText
    Memo:
        pnum.fx(t) is the world numéraire it is a fixed variable
        pwgdp is the world gdp price deflator (assumed to be equal to pnum)
        pmuv  is the wolrd Manufacture Unit Value index based on export price
              of basket of goods imuv over countries rmuv
        pw(a) is the World price of activity a
        pwsav is the World price of investment good

    pnum.fx --> det. pwgdp = 1 see pnumEQ
    pmuv.l --> det. pwsav

    for ENV-Linkages  pnum(t) =e= pmuv(t);

	[TBC] pourquoi pmuv est defini quand ifGbl = 0 ? ne sert a rien

$OffText

* #todo CompStat case

pmuvEQ(t) $ ts(t)..
pmuv(t)  =e= { chimuv * sum((r,i,rp) $ (rmuv(r) and imuv(i)),
               phiw(r,i,rp,t) * m_true3b(pwe,SUB,r,i,rp,t) ) } $ ifGbl
          +  { pnum(t)                                       } $ {not ifGbl} ;

pwgdpEQ(t) $ (ts(t) and ifGbl)..
 pwgdp(t) =e= sum(r, gdpmp(r,t)) / sum(r, rgdpmp(r,t)) ;

pwsavEQ(t) $ ts(t)..
  pwsav(t) =e= pmuv(t) ;

pnumEQ(t) $ (ts(t) and ifGbl)..
  pnum(t) =e= pwgdp(t) ;

* World producer price Fisher-Index by activity

* [TBC] for CompStat

pwEQ(a,t) $ (ts(t) and ifGbl
$IF DECLARED IfCalWorldTarget AND (NOT IfCalWorldTarget("pw",a))
			 AND not tota(a) )..
 pw(a,t) =e= pw(a,t-1) * sqrt{
                         [  sum(r, m_true2(px,r,a,t)   * m_true2t(xp,r,a,t-1))
                          / sum(r, m_true2(px,r,a,t-1) * m_true2t(xp,r,a,t-1))]
                       * [  sum(r, m_true2(px,r,a,t)   * m_true2t(xp,r,a,t))
                          / sum(r, m_true2(px,r,a,t-1) * m_true2t(xp,r,a,t))  ]
                              } ;

* OECD-ENV: add International Prices of commodities as weighted average of Imports CIF prices

EQ_wldPm(i,t) $ (ts(t) and ifGbl and (not tota(i)) AND phipwi(i,t))..
wldPm(i,t)
    =e= phipwi(i,t)
     *  sum((r,rp,t0) $ xwFlag(r,i,rp), m_true3b(pwm,SUB,rp,i,r,t)  * lambdaw(rp,i,r,t) * m_true3(xw,rp,i,r,t0))
     /  sum((r,rp,t0) $ xwFlag(r,i,rp), m_true3b(pwm,SUB,rp,i,r,t0) * lambdaw(rp,i,r,t) * m_true3(xw,rp,i,r,t0));

walraseq(t) $ (ts(t) and not ifGbl)..
 walras(t)
	=e= sum(r $ rs(r),
				sum((i,rp) $ xwFlag(r,i,rp),
					m_true3b(pwe,SUB,r,i,rp,t) * m_true3(xw,r,i,rp,t))
            -   sum((i,rp) $ xwFlag(rp,i,r), lambdaw(rp,i,r,t) *
					m_true3b(pwm,SUB,rp,i,r,t) * m_true3(xw,rp,i,r,t) )
            +   sum(img $ xttFlag(r,img),
					m_true2(pdt,r,img,t) * m_true2(xtt,r,img,t) )
            +   pwsav(t) * savf(r,t)
            +   m_true1(yqht,r,t) - m_true1(yqtf,r,t)
            +   sum((rp,l), m_true3(remit,r,l,rp,t) - m_true3(remit,rp,l,r,t))
			) ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       EMISSIONS MODULE                                       *
*                                                                              *
*------------------------------------------------------------------------------*

* Equation (E-1): Consumption based emissions (included Chemical use)

emiiEQ(r,AllEmissions,EmiUse,aa,t)
    $ (ts(t) and rs(r) and emir(r,AllEmissions,EmiUse,aa,t)
        AND emi0(r,AllEmissions,EmiUse,aa)
        AND NOT (IfCalEmi(r,AllEmissions,EmiUse,aa) eq 3) )..
 emi(r,AllEmissions,EmiUse,aa,t)
    =e= { m_emir(r,AllEmissions,EmiUse,aa,t)
         * sum(mapiEmi(i,EmiUse)$xaFlag(r,i,aa), m_true3t(xa,r,i,aa,t))
         / emi0(r,AllEmissions,EmiUse,aa)
        } $ {IfArmFlag eq 0}
     +  { m_emird(r,AllEmissions,EmiUse,aa,t)
         * sum(mapiEmi(i,EmiUse), m_true3(xd,r,i,aa,t))
         / emi0(r,AllEmissions,EmiUse,aa)
         + m_emirm(r,AllEmissions,EmiUse,aa,t)
         * sum(mapiEmi(i,EmiUse), m_true3(xm,r,i,aa,t))
         / emi0(r,AllEmissions,EmiUse,aa)
        } $ {IfArmFlag}
    ;

* Equation (E-2): Factor-use based emissions

emifEQ(r,AllEmissions,EmiFp,a,t)
    $( ts(t) and rs(r)
	   AND emir(r,AllEmissions,EmiFp,a,t)
       AND emi0(r,AllEmissions,EmiFp,a)
       AND NOT (IfCalEmi(r,AllEmissions,EmiFp,a) eq 3) )..
  emi(r,AllEmissions,EmiFp,a,t)
   =e= sum(mapFpEmi(fp,EmiFp),
             {m_emir(r,AllEmissions,EmiFp,a,t) * sum(l$l(fp), m_true3t(ld,r,l,a,t) )} $ l(fp)
           + {m_emir(r,AllEmissions,EmiFp,a,t) * sum(v, m_true3vt(kv,r,a,v,t) )     } $ cap(fp)
           + {m_emir(r,AllEmissions,EmiFp,a,t) * m_true2t(land,r,a,t)               } $ lnd(fp)
           + {m_emir(r,AllEmissions,EmiFp,a,t) * m_true2(xnrf,r,a,t)                } $ nrs(fp)
          ) / emi0(r,AllEmissions,EmiFp,a) ;

* Equation (E-3): Output/process based emissions

* Warning no chiEmi for pxoapEQ and emixEQ $ OAP(AllEmissions)

emixEQ(r,AllEmissions,EmiAct,a,t)
    $ ( ts(t) and rs(r) and xpFlag(r,a)
		AND emi0(r,AllEmissions,EmiAct,a)
        AND NOT (IfCalEmi(r,AllEmissions,EmiAct,a) eq 3))..
 emi(r,AllEmissions,EmiAct,a,t)
    =e= {  m_emir(r,AllEmissions,EmiAct,a,t) * m_true2t(xp,r,a,t)
         / emi0(r,AllEmissions,EmiAct,a)
        } $ {  (   (ghgFlag(r,a) eq 0 and em(AllEmissions))
				OR (oapFlag(r,a) eq 0 and OAP(AllEmissions)))
			 AND emir(r,AllEmissions,EmiAct,a,t)}
     +  { sum(v, m_chiEmi(r,AllEmissions,EmiAct,a,t) * aemi(r,AllEmissions,a,v,t)
				* m_true3v(xghg,r,a,v,t)
				* lambdaemi(r,AllEmissions,a,v,t)**(sigmaemi(r,a,v)-1)
				* [  m_true3vt(pxghg,r,a,v,t)
				   / m_pemi(r,AllEmissions,EmiAct,a,t) ]**sigmaemi(r,a,v)
             ) / emi0(r,AllEmissions,EmiAct,a)
        } $ {ghgFlag(r,a) and em(AllEmissions)}
     +  { sum(v, aemi(r,AllEmissions,a,v,t)
				* m_true3v(xoap,r,a,v,t)
				* lambdaemi(r,AllEmissions,a,v,t)**(sigmaemi(r,a,v)-1)
				* [  m_true3v(pxoap,r,a,v,t)
				   / m_pemi(r,AllEmissions,EmiAct,a,t) ]**sigmaemi(r,a,v)
             ) / emi0(r,AllEmissions,EmiAct,a)
        } $ { oapFlag(r,a) and OAP(AllEmissions)}
        ;

* Equation (E-4): Price of process based GHG emission bundle --> #todo pxoap

pxghgEQ(r,a,v,t) $ (ts(t) and rs(r) and ghgFlag(r,a))..
 pxghg(r,a,v,t)**(1 - sigmaemi(r,a,v))
  =e= sum( (EmSingle,EmiAct) $ aemi(r,EmSingle,a,v,t),
           m_chiEmi(r,EmSingle,EmiAct,a,t) * aemi(r,EmSingle,a,v,t)
         * [ m_pemi(r,EmSingle,EmiAct,a,t)
		    / (lambdaemi(r,EmSingle,a,v,t)*pxghg0(r,a,t)) ]**(1-sigmaemi(r,a,v))
        ) ;

*  Calculate aggregate emissions including any exogenous emissions

emiTotEQ(r,AllEmissions,t)
    $ ( ts(t) and rs(r) and emiTot0(r,AllEmissions)
        and (NOT IfCalEmi(r,AllEmissions,"allsourceinc","tot"))  )..
 emiTot(r,AllEmissions,t)
     =e= emiOth(r,AllEmissions,t) / emiTot0(r,AllEmissions)
      +  sum((EmiSourceAct,aa) $ emir(r,AllEmissions,EmiSourceAct,aa,t),
            m_true4(emi,r,AllEmissions,EmiSourceAct,aa,t))
      /  emiTot0(r,AllEmissions) ;

*  Global atmospheric carbon emissions

emiGblEQ(AllEmissions,t) $ (ts(t) and ifGbl and emiGbl0(AllEmissions))..
  emiGbl(AllEmissions,t)
    =e= [ sum(r, m_true2(emiTot,r,AllEmissions,t) ) + emiOthGbl(AllEmissions,t)]
     / emiGbl0(AllEmissions) ;

*------------------------------------------------------------------------------*
*                                                                              *
*                       Carbon policy regimes                                  *
*                   Emission caps, tradable quotas, etc.                       *
*                                                                              *
*------------------------------------------------------------------------------*

*  Calculates coalition carbon tax (emiRegTax) when cap imposed (i.e. IfCap>0)
*   --> emiRegTax(rq,em,t) is endogenous to meet the target emiCap.fx(rq,em,t)
*       emiCapeq.emiRegTax
*       chiCap is useless
*       I also think we could get rid of emFlag but not now actually IfEmCap
*       is defined in the time-loop

emiCapEQ(rq,em,t)
    $ (ts(t) and ifGbl and IfCap(rq) and IfEmCap(rq,em) and (not IfMcpCapEq) )..

 0 =e=

* Base Case: Gas-by-gas caps are fixed and directly determine emiRegTax(rq,em)

      {chiCap(em,t) * emiCap(rq,em,t)
          - sum(mapr(rq,r) $ emFlag(r,em),
                  {m_true2(emiTot,r,em,t)          } $ {IfCap(rq) eq 1}
                + {sum((EmiSource,aa) $ emi0(r,em,EmiSource,aa),
                    m_EffEmi(r,em,EmiSource,aa,t)) } $ {IfCap(rq) eq 2}
               ) / emiCap0(rq,em)
      } $ {IfEmCap(rq,em) eq 1 and EmSingle(em)}

* [OECD-ENV]: add case IfEmCap(rq,emn) eq 2 where only CO2 are capped
*  but same emiRegTax(emn) = emiRegTax(CO2) applies for other GHGs

    + { emiRegTax(rq,em,t) - sum(CO2,emiRegTax(rq,CO2,t))
      } $ {IfEmCap(rq,em) eq 2 and emn(em)}

*   [OECD-ENV]: add case IfEmCap(rq,em) eq 3, where cap is defined

* either on all emitot over all GHG: ifCap(rq) eq 1
* or on a controlled set of emissions mixing gas and sources: IfCap(rq) eq 2

*   this determines emiRegTax(rq,AllGHG)

* The set AllGHG is necessary since it is an argument of emiRegTax(rq,AllGHG)

    + {chiCapFull(t) * emiCapFull(rq,t)
        - sum( (r,EmSingle) $ (mapr(rq,r) and emFlag(r,EmSingle)),
                { m_true2(emiTot,r,EmSingle,t)         } $ {IfCap(rq) eq 1}
              + {sum((EmiSource,aa) $ emi0(r,EmSingle,EmiSource,aa),
                  m_EffEmi(r,EmSingle,EmiSource,aa,t)) } $ {IfCap(rq) eq 2}
             ) / emiCapFull0(rq)
      } $ {IfEmCap(rq,em) eq 3 and AllGHG(em)}

*   this determines emiRegTax(em) = to emiRegTax(AllGHG), for all individual gas

    + { emiRegTax(rq,em,t) - sum(AllGHG,emiRegTax(rq,AllGHG,t))
      } $ {IfEmCap(rq,em) eq 3 and EmSingle(em)}
   ;


*   Setting emiTax(r,em,t) for a region r that is a member of coalition rq :
*   emiTaxeq.emiTax

emiTaxEQ(r,AllEmissions,t)
    $ (     ts(t) and ifGbl
        AND ((emFlag(r,AllEmissions) eq 1) OR (emFlag(r,AllEmissions) eq 2)) )..
emiTax(r,AllEmissions,t) =e=
    sum(rq $ (mapr(rq,r) and IfCap(rq)), emiRegTax(rq,AllEmissions,t)) ;

* Calculates quota rents - ( = Export permits)

emiQuotaYEQ(r,AllEmissions,t)
    $(ts(t) and ifGbl and sum(mapr(rq,r), IfCap(rq))
        and emFlag(r,AllEmissions) and ifEmiQuota(r))..
   emiQuotaY(r,AllEmissions,t) =e=  emiTax(r,AllEmissions,t)
    * [ emiQuota(r,AllEmissions,t) - m_true2(emiTot,r,AllEmissions,t)] ;

*------------------------------------------------------------------------------*
*                                                                              *
*                           MODEL DYNAMICS                                     *
*                                                                              *
*------------------------------------------------------------------------------*

*  Labor supply by zone

* Replace : 0.01 * glabz(r,l,z,t) by m_g(m_ETPT,'r,l,z',t) --> for endo. lfpr

lszEQ(r,l,z,t) $ (ts(t) and rs(r) and lsFlag(r,l,z))..
  lsz(r,l,z,t)
   =e= kronm(z) * migrMult(r,l,z,t) * (m_true2(migr,r,l,t) / lsz0(r,l,z))
*   +   power(1 + 0.01 * glabz(r,l,z,t), gap(t)) * lsz(r,l,z,t-1)
    +   power(m_ETPT(r,l,z,t) / m_ETPT(r,l,z,t-1), gap(t)) * lsz(r,l,z,t-1)
    ;

*  Aggregate growth of labor supply by skill

glabEQ(r,l,t) $ (ts(t) and rs(r) and tlabFlag(r,l))..
   ls(r,l,t) =e= power(1 + 0.01 * glab(r,l,t), gap(t)) * ls(r,l,t-1) ;

invGFactEQ(r,t) $ (ts(t) and rs(r) and gap(t) gt 1)..
 invGFact(r,t)
 * [ sum(inv, m_true2(xfd,r,inv,t) / m_true2(xfd,r,inv,t-1))**(1 / gap(t))
    - (1 - depr(r,t)) ]   =e= 1 ;

* [EditJean]: I think we should put here "depr(r,t-1)"

kstockEQ(r,t) $ (ts(t) and rs(r))..

 kstock(r,t)  =e=

* time step > year

   { power(1 - depr(r,t), gap(t))
    * [kstock(r,t-1) - invGFact(r,t) * sum(inv, m_true2(xfd,r,inv,t-1)) / kstock0(r)]
    + invGFact(r,t) * sum(inv, m_true2(xfd,r,inv,t)) / kstock0(r)
   } $ { gap(t) gt 1 }

* time step is one year ( gap(t) eq 1)

    + {  (1 - depr(r,t)) * kstock(r,t-1)
***HRR: included InvLoss
        + (InvLoss(r,t) * sum(inv,m_true2(xfd,r,inv,t-1))) / kstock0(r)
      } $ { gap(t) eq 1 }
;

$OnText
   kstock(r,t) =e= power(1 - depr(r,t), gap(t)) * kstock(r,t-1)
                +  [( power(1 + invGFact(r,t), gap(t)) - power(1 - depr(r,t), gap(t)) )
                /  (invGFact(r,t) + depr(r,t))]
                *  sum(inv, xfd(r,inv,t-1)*xfd0(r,inv)) / kstock0(r)
$OffText

tkapsEQ(r,t) $ (ts(t) and rs(r))..
   tkaps(r,t) =e= chiKaps0(r) * m_true1(kstock,r,t) / tkaps0(r) ;

*------------------------------------------------------------------------------*
*                   Equation for Calibration procedure                         *
*------------------------------------------------------------------------------*

* Memo = {1 + g_l(r) * [ 1 + g_lab_pty_rs(r,vs)] * hc(r,l,vs)}
* Logiquement seulement for IfCalMacro(r,"rgdppc") eq 1 but here because of ENVISAGE calib

lambdalEQ(r,l,a,t) $ (ts(t) and rs(r) and labFlag(r,l,a))..
   lambdal(r,l,a,t) =e= lambdal(r,l,a,t-1)
      * power(1 + chiglab(r,l,t) + glAddShft(r,l,a,t)
				+ glMltShft(r,l,a,t) * gl(r,t), gap(t)) ;

dummyEq ..
   dummy =E= 0;