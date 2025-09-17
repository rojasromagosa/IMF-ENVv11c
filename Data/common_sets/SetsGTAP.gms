$OnText
--------------------------------------------------------------------------------
             OECD-ENV project V.1. - Aggregation procedure
    GAMS file   : "%SetsDir%\setsGTAP.gms"
    purpose     : Define All GTAP sets
    Created by  : Jean Chateau
    created Date: 2020-10-27
    called by   : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 385 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
 Memo: these are generic set definitions --> do not use dynamic sets to simplify
--------------------------------------------------------------------------------
$OffText

$IF NOT SET GTAP_ver $SetGlobal GTAP_ver "11c"

$SetGlobal RunThisAlone "OFF"

$IfThenI.RunHere %RunThisAlone%=="ON"
    $$OnEolCom
    $$SetGlobal SetsDir  "%system.fp%"
    $$SetGlobal ifWater  "OFF"
    $$SetGlobal ifPower  "ON"
$ENDIF.RunHere

$Ifi NOT %GTAP_ver%=="92" $SetGlobal chm "chm"
$Ifi     %GTAP_ver%=="92" $SetGlobal chm "crp"

$Ifi NOT %GTAP_ver%=="92" $SetGlobal oxt "oxt"
$Ifi     %GTAP_ver%=="92" $SetGlobal oxt "omn"

$Ifi NOT %GTAP_ver%=="92" $SetGlobal ins "ins"
$Ifi     %GTAP_ver%=="92" $SetGlobal ins "isr"

$OnEmpty

*   Include sets for GTAP regions

***HRR changed to be version-specific $include "%SetsDir%\SetsGTAP\GTAP_regions.gms"
$include "%SetsDir%\SetsGTAP\GTAP_regions_v%GTAP_ver%.gms"

*   Include sets for GTAP activities

SETS
    a0 "Set of GTAP activities and agents (power and water included)" /
        $$include "%SetsDir%\SetsGTAP\CropsA.gms"
        $$include "%SetsDir%\SetsGTAP\LivestockA.gms"
        $$include "%SetsDir%\SetsGTAP\ManufactureA.gms"
        $$include "%SetsDir%\SetsGTAP\NatResA.gms"
        $$include "%SetsDir%\SetsGTAP\OtherIndustryA.gms"
        $$include "%SetsDir%\SetsGTAP\Powa.gms"
        $$include "%SetsDir%\SetsGTAP\ServicesA.gms"
        $$include "%SetsDir%\SetsGTAP\TRNServicesA.gms"

        CGDS    "Capital goods"
        hh      "Households"
        total   "Total for various checks"

* Add ELY to dowscale ely over powa0 for Sectoral Productivity & non-CO2 fuel

        $$IFi %ifPower%=="ON" ELY
    /

    CGDS0(a0)   "Investement Sector" / CGDS "Investement Sector" /
    hh0(a0)     "Households"         / hh   "Households"         /
	otp0(a0)	"Land transport"	 / otp  "Land transport"     /

    elya0(a0)   "Set of Electric sectors (included T&D)" /
        $$include "%SetsDir%\SetsGTAP\powa.gms"
        $$IFi %IfPower%=="ON" TnD "Electricity transmission and distribution"
    /
    powa0(a0)   "Power activities in GTAP aggregation" /
        $$include "%SetsDir%\SetsGTAP\powa.gms"
    /
    advTech(a0) "Set of advanced Power activities" /
        $$IfTheni.power %IfPower%=="ON"
            colccs "Coal-based CCS"
            gasccs "Gas-based CCS"
            advnuc "Advanced nuclear"
        $$ENDIF.power
    /
    acr0(a0) "Set of crop activities"  /
        $$include "%SetsDir%\SetsGTAP\CropsA.gms"
    /
    alv0(a0) "Set of livestock activities" /
        $$include "%SetsDir%\SetsGTAP\LivestockA.gms"
    /
    srv0(a0) "Set of services (transportation excluded)" /
        $$include "%SetsDir%\SetsGTAP\ServicesA.gms"
    /
;

alias(prod_comm,a0);

set wbnd0 "Aggregate water markets" /
   crp      "Crops"
   lvs      "Livestock"
   ind      "Industrial use"
   mun      "Municipal use"
/ ;

*   Include sets for GTAP Commodities: TRAD_COMM = PROD_COMM - CGDS

SETS
    TRAD_COMM(prod_comm) "Set of commodities in GTAP (including power and water)" /
        $$include "%SetsDir%\SetsGTAP\CropsA.gms"
        $$include "%SetsDir%\SetsGTAP\LivestockA.gms"
        $$include "%SetsDir%\SetsGTAP\ManufactureA.gms"
        $$include "%SetsDir%\SetsGTAP\NatResA.gms"
        $$include "%SetsDir%\SetsGTAP\OtherIndustryA.gms"
        $$include "%SetsDir%\SetsGTAP\Powa.gms"
        $$include "%SetsDir%\SetsGTAP\ServicesA.gms"
        $$include "%SetsDir%\SetsGTAP\TRNServicesA.gms"

        total  "Total for various checks"

* Add ELY to dowscale ely over powa0 for Sectoral Productivity & non-CO2 fuel

    $$IFi %ifPower%=="ON" ELY

    /
;

alias(trad_comm,i0);

*   GTAP energy sets

SETS
    powi0(i0) "Power commodities in GTAP aggregation" /
        $$include "%SetsDir%\SetsGTAP\Powa.gms"
    /
    fuel_comm(i0) "Fossil fuel commodities in GTAP aggregation" /
        coa   "Coal"
        oil   "Oil"
        gas   "Gas"
        p_c   "Petroleum, coal products"
        gdt   "Gas manufacture, distribution"
    /
    e0(i0) "Energy commodities in GTAP aggregation" /
        coa   "Coal"
        oil   "Oil"
        gas   "Gas"
        p_c   "Petroleum, coal products"
        gdt   "Gas manufacture, distribution"
        $$include "%SetsDir%\SetsGTAP\Powa.gms"
    /
    gasi0(e0) "Gas commodities in GTAP aggregation" / gas, gdt /
    oili0(e0) "Oil commodities in GTAP aggregation" / oil, p_c /

;

alias(fuel_comm,f0);
alias(e0,erg_comm) ;

***HRR
alias(erg_comm,erg) ;

*   Trade margins sets

SETS
    MARG_COMM(i0) "Trade margins sectors: transportation services" /
        $$include "%SetsDir%\SetsGTAP\TRNServicesA.gms"
    /
;

alias(img0, marg_comm);

*   Primary Factors sets

SETS
    endw_comm "Set of endowment factors" /
        Land           "Land"
        $$include "%SetsDir%\SetsGTAP\LabFp.gms"
        Capital        "Capital"
        NatlRes        "Natural resources"
        NatRes         "Natural resources"
        $$IF %ifWater%=="ON" Water "Water resources"
    /
    lab_comm(endw_comm) "Set of labor factors" /
        $$include "%SetsDir%\SetsGTAP\LabFp.gms"
    /
    cap0(endw_comm) / Capital /
    Land_comm(endw_comm) "Land endowment" / Land  /
    ntrs_comm(endw_comm) / NatlRes /
    $$IF %ifWater%=="ON" wat0(fp0) / Water /
    ENDWS_COMM(endw_comm) "Sluggish endowments" /
        Land     "Land"
        NatlRes  "Natural resources"    /
;

alias(endw_comm,fp0)  ;
alias(lab_comm,l0)    ;
alias(land_comm,lnd0) ;
alias(ntrs_comm,nrf0) ;
alias(cap_comm,cap0) ;

*  Set that creates the original diagonal make matrix --> mapd(a0,i0)
* [TBC] pourquoi je garde ca ???


set mapd(prod_comm,trad_comm) /
    $$IfTheni.wtrData %ifWater%=="ON"
        pdri.pdri
        pdrn.pdrn
        whti.whti
        whtn.whtn
        groi.groi
        gron.gron
        v_fi.v_fi
        v_fn.v_fn
        osdi.osdi
        osdn.osdn
        c_bi.c_bi
        c_bn.c_bn
        pfbi.pfbi
        pfbn.pfbn
        ocri.ocri
        ocrn.ocrn
    $$ELSE.wtrData
        pdr.pdr
        wht.wht
        gro.gro
        v_f.v_f
        osd.osd
        c_b.c_b
        pfb.pfb
        ocr.ocr
    $$ENDIF.wtrData
    ctl.ctl
    oap.oap
    rmk.rmk
    wol.wol
    frs.frs
    fsh.fsh
    coa.coa
    oil.oil
    gas.gas
    %oxt%.%oxt%
    cmt.cmt
    omt.omt
    vol.vol
    mil.mil
    pcr.pcr
    sgr.sgr
    ofd.ofd
    b_t.b_t
    tex.tex
    wap.wap
    lea.lea
    lum.lum
    ppp.ppp
    p_c.p_c
    nmm.nmm
    fmp.fmp
    mvh.mvh
    otn.otn
    ele.ele
    ome.ome
    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        eeq.eeq
        bph.bph
        rpp.rpp
    $$endif.gtap10
    %chm%.%chm%
    omf.omf
    i_s.i_s
    nfm.nfm
    $$IfTheni.power %IfPower%=="ON"
        TnD        .TnD
        NuclearBL  .NuclearBL
        CoalBL     .CoalBL
        GasBL      .GasBL
        WindBL     .WindBL
        HydroBL    .HydroBL
        OilBL      .OilBL
        OtherBL    .OtherBL
        GasP       .GasP
        HydroP     .HydroP
        OilP       .OilP
        SolarP     .SolarP
        colccs     .colccs
        gasccs     .gasccs
        advnuc     .advnuc
    $$ELSE.power
        ely.ely
    $$ENDIF.power
    gdt.gdt
    wtr.wtr
    cns.cns
    wtp.wtp
    atp.atp
    cmn.cmn
    ofi.ofi
    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        ins.ins
    $$else.gtap10
        isr.isr
    $$endif.gtap10
    ros.ros
    dwe.dwe
    trd.trd
    osg.osg
    obs.obs
    otp.otp
    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        afs.afs
        edu.edu
        hht.hht
        rsa.rsa
        whs.whs
    $$endif.gtap10

/;

*---    To be move in %prefix%map.gms ? or in the model itself
*  Check why if we really use those sets

SETS
    z "Geographical Zones" /
        rur   "Agricultural sectors"
        urb   "Non-agricultural sectors"
        nsg   "Non-segmented labor markets"
        /
    rur(z) "Rural zone" / rur "Rural zone" /
    urb(z) "Rural zone" / urb "Urban zone" /
    nsg(z) "Both zones" / nsg "Non-segmented labor markets" /
;


set lg "Labor sets in the GIDD database" /
    nsk      "Unskilled labor"
    skl      "Skilled labor"
/ ;

SETS
    stdlab  "Standard SAM labels" /
        hhd            "Household"
        gov            "Government"
        inv            "Investment"
        r_d            "R & D expenditures"
        deprY          "Depreciation"
        tmg            "Trade margins"
        itax           "Indirect tax"
        ptax           "Production tax"
        mtax           "Import tax"
        etax           "Export tax"
        vtax           "Taxes on factors of production"
        vsub           "Subsidies on factors of production"
        dtax           "Direct taxation"
        ctax           "Carbon tax"
        trd            "Trade account"
        bop            "Balance of payments account"
        tot            "Total for row/column sums"
* [EditJean]: add this
        TotEly         "Aggregation of all Power and T&D"
    /
    fd(stdlab) "Domestic final demand agents" /
        hhd            "Household"
        gov            "Government"
        inv            "Investment"
        r_d            "R & D expenditures"
        tmg            "Trade margins"
    /
    h(fd)   "Households"         /  hhd  "Household"   /
    gov(fd) "Government"         /  gov  "Government"  /
    inv(fd) "Investment"         /  inv  "Investment"  /
    r_d(fd) "R & D expenditures" /  r_d  "R & D expenditures" /
    tmg(fd) "Domestic supply of trade margins services" /  tmg "Trade margins"/
;

*   [OECD-ENV]: adds

$include "%SetsDir%\SetDemog.gms"

$offempty

$Ifi %RunThisAlone%=="ON" Execute_unload "V:\CLIMATE_MODELLING\results\setsGTAP_%GTAP_ver%.gdx";

***HRR: Added this set

SET

ACTS    "Activities" /

PDR	"Paddy rice"
WHT	"Wheat"
GRO	"Cereal grains nec"
V_F	"Vegetables, fruit, nuts"
OSD	"Oil seeds"
C_B	"Sugar cane, sugar beet"
PFB	"Plant-based fibers"
OCR	"Crops nec"
CTL	"Bovine cattle, sheep and goats, horses"
OAP	"Animal products nec"
RMK	"Raw milk"
WOL	"Wool, silk-worm cocoons"
FRS	"Forestry"
FSH	"Fishing"
COA	"Coal"
OIL	"Oil"
GAS	"Gas"
OXT	"Other Extraction (formerly omn Minerals nec)"
CMT	"Bovine meat products"
OMT	"Meat products nec"
VOL	"Vegetable oils and fats"
MIL	"Dairy products"
PCR	"Processed rice"
SGR	"Sugar"
OFD	"Food products nec"
B_T	"Beverages and tobacco products"
TEX	"Textiles"
WAP	"Wearing apparel"
LEA	"Leather products"
LUM	"Wood products"
PPP	"Paper products, publishing"
P_C	"Petroleum, coal products"
CHM	"Chemical products"
BPH	"Basic pharmaceutical products"
RPP	"Rubber and plastic products"
NMM	"Mineral products nec"
I_S	"Ferrous metals"
NFM	"Metals nec"
FMP	"Metal products"
ELE	"Computer, electronic and optical products"
EEQ	"Electrical equipment"
OME	"Machinery and equipment nec"
MVH	"Motor vehicles and parts"
OTN	"Transport equipment nec"
OMF	"Manufactures nec"
TnD	"Electricity transmission and distribution"
NuclearBL	"Nuclear power"
CoalBL	"Coal power baseload"
GasBL	"Gas power baseload"
WindBL	"Wind power"
HydroBL	"Hydro power baseload"
OilBL	"Oil power baseload"
OtherBL	"Other baseload"
GasP	"Gas power peakload"
HydroP	"Hydro power peakload"
OilP	"Oil power peakload"
SolarP	"Solar power"
GDT	"Gas manufacture, distribution"
WTR	"Water"
CNS	"Construction"
TRD	"Trade"
AFS	"Accommodation, Food and service activities"
OTP	"Transport nec"
WTP	"Water transport"
ATP	"Air transport"
WHS	"Warehousing and support activities"
CMN	"Communication"
OFI	"Financial services nec"
INS	"Insurance (formerly isr)"
RSA	"Real estate activities"
OBS	"Business services nec"
ROS	"Recreational and other services"
OSG	"Public Administration and defense"
EDU	"Education"
HHT	"Human health and social work activities"
DWE	"Dwellings"
/
;
