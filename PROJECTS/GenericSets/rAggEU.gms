$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
   name        : "%sDir%\rAggEU.gms
   purpose     : EU regional aggregation(s)
   created date: 2022-10-24
   created by  : Jean Chateau
   called by   : some "%iFilesDir%\map.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/rAggEU.gms $
   last changed revision: $Rev: 347 $
   last changed date    : $Date:: 2023-07-10 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$setlocal step "%1"

$IfThen.step1 %step%=="define_region"

*------------------------------------------------------------------------------*
*                       1. Define Model regions                                *
*------------------------------------------------------------------------------*

*   Non-EU and Not OECD Europe countries

*   4 Isolated countries (all EU aggr) :

    chn         "China"
    ind         "India"
    rus         "Russian Federation"
    usa         "United States of America"

    OEP         "OECD Pacific"
    OEL         "OECD Latin America plus Canada"
    OME         "Middle east countries"
    OEA         "Other developing and emerging Eurasia (OEURASIA)"
    OAF         "Africa"
    ODA         "Other developing and emerging East Asia"
    OLA         "Other developing and emerging Latin America"

*   EU countries (27)

    REU	"Rest of EU countries"

    $$IF SET split_Austria     aut      "Austria"
    $$IF SET split_France      fra      "France"
    $$IF SET split_Germany     deu      "Germany"
    $$IF SET split_Italy       ita      "Italy"
    $$IF SET split_Spain       esp      "Spain"
    $$IF SET split_Netherlands nld      "Netherlands"
    $$IF SET split_Belgium     bel      "Belgium"
    $$IF SET split_Bulgaria    bul      "Bulgaria"
    $$IF SET split_Croatia     hrv      "Croatia"
    $$IF SET split_Czech       cze      "Czech Republic"
    $$IF SET split_Denmark     dnk      "Denmark"
    $$IF SET split_Estonia     est      "Estonia"
    $$IF SET split_Cyprus      cyp      "Cyprus"
    $$IF SET split_Lithuania   ltu      "Lithuania"
    $$IF SET split_Latvia      lva      "Latvia"
    $$IF SET split_Hungary     hun      "Hungary"
    $$IF SET split_Malta       mlt      "Malta"
    $$IF SET split_Poland      pol      "Poland"
    $$IF SET split_Romania     rou      "Romania"
    $$IF SET split_Slovenia    svn      "Slovenia"
    $$IF SET split_Slovakia    svk      "Slovakia"
    $$IF SET split_Ireland     irl      "Ireland"
    $$IF SET split_Greece      grc      "Greece"
    $$IF SET split_Portugal    prt      "Portugal"
    $$IF SET split_Finland     fin      "Finland"
    $$IF SET split_Luxemburg   lux      "Luxemburg"
    $$IF SET split_Sweden      swe      "Sweden"

*   OECD Europe non-EU countries

    OEU "OECD Europe non-EU countries"

    $$IF SET split_Norway      nor      "Norway"
    $$IF SET split_Switzerland che      "Switzerland"
    $$IF SET split_Iceland     isl      "Iceland and Liechtenstein"
    $$IF SET split_UK          gbr      "United Kingdom"
    $$IF SET split_Turkey      tur      "Turkey"
    $$IF SET split_Israel      isr      "Israel"

$EndIf.step1

$IfTheni.step1bis %step%=="rmuv"

*   regional set rmuv(r)

    usa     "United States of America"
    OEP     "OECD Pacific"

*   EU countries

    REU         "Rest of EU countries"

    $$IF SET split_Austria     aut      "Austria"
    $$IF SET split_France      fra      "France"
    $$IF SET split_Germany     deu      "Germany"
    $$IF SET split_Italy       ita      "Italy"
    $$IF SET split_Spain       esp      "Spain"
    $$IF SET split_Netherlands nld      "Netherlands"
    $$IF SET split_Belgium     bel      "Belgium"
    $$IF SET split_Denmark     dnk      "Denmark"
    $$IF SET split_Slovenia    svn      "Slovenia"
    $$IF SET split_Ireland     irl      "Ireland"
    $$IF SET split_Greece      grc      "Greece"
    $$IF SET split_Portugal    prt      "Portugal"
    $$IF SET split_Finland     fin      "Finland"
    $$IF SET split_Luxemburg   lux      "Luxemburg"
    $$IF SET split_Sweden      swe      "Sweden"

*   OECD Europe non-EU countries

    OEU "Rest of non-EU OECD Europe"

    $$IF SET split_Norway      nor      "Norway"
    $$IF SET split_Switzerland che      "Switzerland"
    $$IF SET split_Iceland     isl      "Iceland and Liechtenstein"
    $$IF SET split_UK          gbr      "United Kingdom"

$EndIf.step1bis

$IfTheni.step2 %step%=="region_mapping"

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

* Non OECD europe isolated countries

    chn.(chn,hkg)   "China (included Honk Hong)"
    ind.ind         "India"
    rus.rus         "Russian Federation"
    usa.usa         "USA"

* OEP:	"OECD Pacific"

    OEP.(aus,jpn,nzl,kor)   "OECD Pacific"

* OEU: "OECD Europe non-EU countries"

    $$IF SET split_Norway          nor.nor      "Norway"
    $$IF SET split_Switzerland     che.che      "Switzerland"
    $$IF SET split_Iceland         isl.xef      "Iceland and Liechtenstein"
    $$IF SET split_UK              gbr.gbr      "United Kingdom"
    $$IF SET split_Turkey          tur.tur      "Turkey"
    $$IF SET split_Israel          isr.isr      "Israel"

    $$IF NOT SET split_Norway      OEU.nor      "Norway"
    $$IF NOT SET split_Switzerland OEU.che      "Switzerland"
    $$IF NOT SET split_Iceland     OEU.xef      "Iceland and Liechtenstein"
    $$IF NOT SET split_UK          OEU.gbr      "United Kingdom"
    $$IF NOT SET split_Turkey      OEU.tur      "Turkey"
    $$IF NOT SET split_Israel      OEU.isr      "Israel"

*   EU countries (27)

    $$IF SET split_Austria         aut.aut      "Austria"
    $$IF SET split_France          fra.fra      "France"
    $$IF SET split_Germany         deu.deu      "Germany"
    $$IF SET split_Italy           ita.ita      "Italy"
    $$IF SET split_Spain           esp.esp      "Spain"
    $$IF SET split_Netherlands     nld.nld      "Netherlands"
    $$IF SET split_Belgium         bel.bel      "Belgium"
    $$IF SET split_Bulgaria        bul.bul      "Bulgaria"
    $$IF SET split_Croatia         hrv.hrv      "Croatia"
    $$IF SET split_Czech           cze.cze      "Czech Republic"
    $$IF SET split_Denmark         dnk.dnk      "Denmark"
    $$IF SET split_Estonia         est.est      "Estonia"
    $$IF SET split_Cyprus          cyp.cyp      "Cyprus"
    $$IF SET split_Lithuania       ltu.ltu      "Lithuania"
    $$IF SET split_Latvia          lva.lva      "Latvia"
    $$IF SET split_Hungary         hun.hun      "Hungary"
    $$IF SET split_Malta           mlt.mlt      "Malta"
    $$IF SET split_Poland          pol.pol      "Poland"
    $$IF SET split_Romania         rou.rou      "Romania"
    $$IF SET split_Slovenia        svn.svn      "Slovenia"
    $$IF SET split_Slovakia        svk.svk      "Slovakia"
    $$IF SET split_Ireland         irl.irl      "Ireland"
    $$IF SET split_Greece          grc.grc      "Greece"
    $$IF SET split_Portugal        prt.prt      "Portugal"
    $$IF SET split_Finland         fin.fin      "Finland"
    $$IF SET split_Luxemburg       lux.lux      "Luxemburg"
    $$IF SET split_Sweden          swe.swe      "Sweden"

    $$IF NOT SET split_Austria     REU.aut      "Austria"
    $$IF NOT SET split_France      REU.fra      "France"
    $$IF NOT SET split_Germany     REU.deu      "Germany"
    $$IF NOT SET split_Italy       REU.ita      "Italy"
    $$IF NOT SET split_Spain       REU.esp      "Spain"
    $$IF NOT SET split_Netherlands REU.nld      "Netherlands"
    $$IF NOT SET split_Belgium     REU.bel      "Belgium"
    $$IF NOT SET split_Bulgaria    REU.bgr      "Bulgaria"
    $$IF NOT SET split_Croatia     REU.hrv      "Croatia"
    $$IF NOT SET split_Czech       REU.cze      "Czech Republic"
    $$IF NOT SET split_Denmark     REU.dnk      "Denmark"
    $$IF NOT SET split_Estonia     REU.est      "Estonia"
    $$IF NOT SET split_Cyprus      REU.cyp      "Cyprus"
    $$IF NOT SET split_Lithuania   REU.ltu      "Lithuania"
    $$IF NOT SET split_Latvia      REU.lva      "Latvia"
    $$IF NOT SET split_Hungary     REU.hun      "Hungary"
    $$IF NOT SET split_Malta       REU.mlt      "Malta"
    $$IF NOT SET split_Poland      REU.pol      "Poland"
    $$IF NOT SET split_Romania     REU.rou      "Romania"
    $$IF NOT SET split_Slovenia    REU.svn      "Slovenia"
    $$IF NOT SET split_Slovakia    REU.svk      "Slovakia"
    $$IF NOT SET split_Ireland     REU.irl      "Ireland"
    $$IF NOT SET split_Greece      REU.grc      "Greece"
    $$IF NOT SET split_Portugal    REU.prt      "Portugal"
    $$IF NOT SET split_Finland     REU.fin      "Finland"
    $$IF NOT SET split_Luxemburg   REU.lux      "Luxemburg"
    $$IF NOT SET split_Sweden      REU.swe      "Sweden"

* OEL:	"OECD Latin America plus Canada"

    OEL.can
    OEL.mex
    OEL.chl   "HIC"
    OEL.col   "UMI"
    OEL.cri   "UMI"

*   NON-OECD Europe countries

* OLA  "Other developing and emerging Latin America"

    OLA.xna !! xna = {Bermuda, Greenland, Saint Pierre and Miquelon}
    OLA.xtw !! xtw = {Antarctica,Bouvet Island, Chagos Islands, French Southern Territories}

    OLA.arg   "UMI"
    OLA.bol   "LMI"
    OLA.bra   "UMI"
    OLA.ecu   "UMI"
    OLA.pry   "UMI"
    OLA.per   "UMI"
    OLA.ury   "HIC"
    OLA.ven   "UMI"
    OLA.xsm

    OLA.gtm   "UMI"
    OLA.hnd   "LMI"
    OLA.nic   "LMI"
    OLA.pan   "HIC"
    OLA.slv
    OLA.xca
    OLA.dom   "UMI"
    OLA.jam
    OLA.pri
    OLA.tto
    OLA.xcb

* ODA:	"Other developing and emerging East Asia"

    ODA.xoc
    ODA.mng
    ODA.twn
    ODA.xea
*... of which ASEAN
    ODA.khm
    ODA.lao
    ODA.mys
    ODA.phl
    ODA.sgp
    ODA.tha
    ODA.vnm
    ODA.xse
    ODA.brn
    ODA.idn
    ODA.bgd
    ODA.npl
    ODA.pak
    ODA.lka
    ODA.xsa !! xsa = {Afghanistan, Bhutan, Maldives}

* OEA: "OEURASIA: Other developing and emerging Eurasia"

    OEA.alb
    OEA.blr
    OEA.ukr
    OEA.xee
    OEA.xer
    OEA.kaz
    OEA.kgz
    OEA.xsu
    OEA.tjk
    OEA.arm
    OEA.aze
    OEA.geo
    $$IFi %GTAP_ver%=="10.1" OEA.srb  "Serbia"

* OME: "Other Middle east countries"

    OME.bhr
    OME.irn     "UMI"
    OME.jor
    OME.kwt
    OME.omn
    OME.qat
    OME.are
    OME.xws
    OME.sau

    $$IFi %GTAP_ver%=="10.1" OME.irq  " Iraq"
    $$IFi %GTAP_ver%=="10.1" OME.lbn  " Lebanon"
    $$IFi %GTAP_ver%=="10.1" OME.pse  " West Bank of Gaza"
    $$IFi %GTAP_ver%=="10.1" OME.syr  " Syrian Arab Republic"

* OAF: "Other developing and emerging Africa"

    OAF.tun
    OAF.egy
    OAF.mar
    OAF.xnf    !! xnf = {Algeria, Libya}
    OAF.ben
    OAF.bfa
    OAF.cmr
    OAF.civ
    OAF.gha
    OAF.gin
    OAF.nga
    OAF.sen
    OAF.tgo
    OAF.xwf
    OAF.xcf
    OAF.xac    !! xac = {Angola, Congo the Democratic Republic of the}
    OAF.eth
    OAF.ken
    OAF.mdg
    OAF.mwi
    OAF.mus
    OAF.moz
    OAF.rwa
    OAF.tza
    OAF.uga
    OAF.zmb
    OAF.zwe
    OAF.xec     "Rest of Eastern Africa"
    $$IFi %GTAP_ver%=="10.1" OAF.sdn "Sudan"
    OAF.bwa
    OAF.nam
    OAF.zaf
    OAF.xsc

$EndIf.step2

$IfTheni.step3 %step%=="WEOmapping"

*------------------------------------------------------------------------------*
*                  3. Mapping with IEA WEO aggregation                         *
*------------------------------------------------------------------------------*

* [EditJean]: since winter 2022 this is no more used in model or aggregation step

    US          . usa
    can         . OEL
    (EUG4,EUa)  . fra
    (EUG4,EUa)  . deu
    (EUG4,EUa)  . ita
    (EUG4,OEURc). gbr

    CHINA           . chn
    INDIA           . ind
    RUS             . rus

    MEX.OEA
    (CHILE,CSAMa).OEL
    (OLAM,CSAMb) .OLA
    bra.OLA

* Need to always keep nzl & aus together

    AUNZ.OEP
    KOR.OEP
    JPN.OEP
    (OEURa,OE5).OEU

    INDO.ODA
    CASP            . OEA
    (OETE,OEURb)    . OEA
    (ASEAN9,OASEAN) . ODA
    (ODA,OASIA)     . ODA

    (NAFR,OAFR)     . OAF
    SAFR.OAF

    ME.OME

*   [TBU]

    (EU17,EUb).OEU
    (EU7,EUc).OEU

$EndIf.step3

$IfTheni.step4 %step%=="Sort_region"

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

                                sort1 .usa  "United States of America"
                                sort2 .chn  "China"
                                sort3 .ind  "India"
                                sort4 .rus  "Russian Federation"
                                sort5 .OEP  "OECD Pacific"
                                sort6 .OEL  "OECD Latin America plus Canada"
                                sort7 .OME  "Middle East"
                                sort8 .OEA  "Other developing and emerging Eurasia"
                                sort9 .OAF  "Africa"
                                sort10.ODA  "Other developing and emerging East Asia"
                                sort11.OLA  "Other developing and emerging Latin America"
                                sort12.REU  "Rest of EU countries"
                                sort13.OEU  "Rest of non-EU OECD Europe"
    $$IF SET split_Austria      sort14.aut  "Austria"
    $$IF SET split_France       sort15.fra  "France"
    $$IF SET split_Germany      sort16.deu  "Germany"
    $$IF SET split_Italy        sort17.ita  "Italy"
    $$IF SET split_Spain        sort18.esp  "Spain"
    $$IF SET split_Netherlands  sort19.nld  "Netherlands"
    $$IF SET split_Belgium      sort20.bel  "Belgium"
    $$IF SET split_Bulgaria     sort21.bul  "Bulgaria"
    $$IF SET split_Croatia      sort22.hrv  "Croatia"
    $$IF SET split_Czech        sort23.cze  "Czech Republic"
    $$IF SET split_Denmark      sort24.dnk  "Denmark"
    $$IF SET split_Estonia      sort25.est  "Estonia"
    $$IF SET split_Cyprus       sort26.cyp  "Cyprus"
    $$IF SET split_Lithuania    sort27.ltu  "Lithuania"
    $$IF SET split_Latvia       sort28.lva  "Latvia"
    $$IF SET split_Hungary      sort29.hun  "Hungary"
    $$IF SET split_Malta        sort30.mlt  "Malta"
    $$IF SET split_Poland       sort31.pol  "Poland"
    $$IF SET split_Romania      sort32.rou  "Romania"
    $$IF SET split_Slovenia     sort33.svn  "Slovenia"
    $$IF SET split_Slovakia     sort34.svk  "Slovakia"
    $$IF SET split_Ireland      sort35.irl  "Ireland"
    $$IF SET split_Greece       sort36.grc  "Greece"
    $$IF SET split_Portugal     sort37.prt  "Portugal"
    $$IF SET split_Finland      sort38.fin  "Finland"
    $$IF SET split_Luxemburg    sort39.lux  "Luxemburg"
    $$IF SET split_Sweden       sort40.swe  "Sweden"
    $$IF SET split_Norway       sort41.nor  "Norway"
    $$IF SET split_Switzerland  sort42.che  "Switzerland"
    $$IF SET split_Iceland      sort43.isl  "Iceland and Liechtenstein"
    $$IF SET split_UK           sort44.gbr  "United Kingdom"
    $$IF SET split_Turkey       sort45.tur  "Turkey"
    $$IF SET split_Israel       sort46.isr  "Israel"

$EndIf.step4

$IfThen.step5 %step%=="define_ra"

*------------------------------------------------------------------------------*
*                       5. Define Aggregate regions                            *
*------------------------------------------------------------------------------*

        HIC    "High Income countries"
        MIC    "Medium Income countries"
        LIC    "Low Income countries"
        OILP   "Oil Producers"
        WORLD  "World Aggregate"

$EndIf.step5

$IfTheni.step6 %step%=="mapping_ra"

*------------------------------------------------------------------------------*
*     6. mapra(ra,r) "Mapping of model regions to aggregate regions"           *
*------------------------------------------------------------------------------*

*---    Il ne faut pas associer les regions isolees a leur ensemble
* --> c'est automatique dans l'aggregation

    MIC.chn         "China"
    LIC.ind         "India"
    MIC.rus         "Russian Federation"
    HIC.usa         "United States of America"
    HIC.OEP         "OECD Pacific"
    MIC.OEL         "OECD Latin America plus Canada"
    OILP.OME        "Middle east countries"
    MIC.OEA         "Other developing and emerging Eurasia (OEURASIA)"
    LIC.OAF         "Africa"
    LIC.ODA         "Other developing and emerging East Asia"
    MIC.OLA         "Other developing and emerging Latin America"

*   EU countries (27)

    HIC.REU         "Rest of EU countries"

    $$IF SET split_Austria     HIC.aut      "Austria"
    $$IF SET split_France      HIC.fra      "France"
    $$IF SET split_Germany     HIC.deu      "Germany"
    $$IF SET split_Italy       HIC.ita      "Italy"
    $$IF SET split_Spain       HIC.esp      "Spain"
    $$IF SET split_Netherlands HIC.nld      "Netherlands"
    $$IF SET split_Belgium     HIC.bel      "Belgium"
    $$IF SET split_Bulgaria    HIC.bul      "Bulgaria"
    $$IF SET split_Croatia     HIC.hrv      "Croatia"
    $$IF SET split_Czech       HIC.cze      "Czech Republic"
    $$IF SET split_Denmark     HIC.dnk      "Denmark"
    $$IF SET split_Estonia     HIC.est      "Estonia"
    $$IF SET split_Cyprus      HIC.cyp      "Cyprus"
    $$IF SET split_Lithuania   HIC.ltu      "Lithuania"
    $$IF SET split_Latvia      HIC.lva      "Latvia"
    $$IF SET split_Hungary     HIC.hun      "Hungary"
    $$IF SET split_Malta       HIC.mlt      "Malta"
    $$IF SET split_Poland      HIC.pol      "Poland"
    $$IF SET split_Romania     HIC.rou      "Romania"
    $$IF SET split_Slovenia    HIC.svn      "Slovenia"
    $$IF SET split_Slovakia    HIC.svk      "Slovakia"
    $$IF SET split_Ireland     HIC.irl      "Ireland"
    $$IF SET split_Greece      HIC.grc      "Greece"
    $$IF SET split_Portugal    HIC.prt      "Portugal"
    $$IF SET split_Finland     HIC.fin      "Finland"
    $$IF SET split_Luxemburg   HIC.lux      "Luxemburg"
    $$IF SET split_Sweden      HIC.swe      "Sweden"

*   OECD Europe non-EU countries

    HIC.OEU "Rest of non-EU OECD Europe"

    $$IF SET split_Norway      HIC.nor      "Norway"
    $$IF SET split_Switzerland HIC.che      "Switzerland"
    $$IF SET split_Iceland     HIC.isl      "Iceland and Liechtenstein"
    $$IF SET split_UK          HIC.gbr      "United Kingdom"
    $$IF SET split_Turkey      MIC.tur      "Turkey"
    $$IF SET split_Israel      HIC.isr      "Israel"


$EndIf.step6

$droplocal step

