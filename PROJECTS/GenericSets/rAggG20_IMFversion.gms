$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
   name        : "%sDir%\rAggOECD.gms
   purpose     : G20 regional aggregation
   created date: 2021 spring
   created by  : Jean Chateau
   called by   : some "%iFilesDir%\map.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/rAggG20_IMFversion.gms $
   last changed revision: $Rev: 361 $
   last changed date    : $Date:: 2023-07-20 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$setlocal step "%1"

$IfThen.step1 %step%=="define_region"

*------------------------------------------------------------------------------*
*                       1. Define Model regions                                *
*------------------------------------------------------------------------------*

*   Isolated countries

    usa         "United States of America"
    jpn         "Japan"
    aus         "Australia"
    chn         "China"
    ind         "India"
    rus         "Russian Federation"
    Argentina   "Argentina"            !! ROW | UM
    Brazil      "Brazil"               !! ROW | UM
    Canada      "Canada"               !! ROECD
    Indonesia   "Indonesia"            !! ROW
    Korea       "South Korea"          !! ROW
    Mexico      "Mexico"               !! ROW | UM
    Saudi       "Saudi Arabia"         !! OPEC
    SouthAfrica "South Africa"         !! ROW
    Turkey      "Turkey"               !! ROW | UM
    France      "France"               !! EUW
    Germany     "Germany"              !! EUW
    UK          "United Kingdom"       !! EUW
    Italy       "Italy"                !! EUW

*---    Group of Region/countries

    $$OnText
        RESTEU = {Spain, Netherlands, Belgium, Bulgaria, Croatia,
            Czech Republic, Denmark, Estonia, Cyprus, Lithuania,
            Latvia, Hungary, Malta, Poland, Romania, Slovenia, Slovakia,
            Ireland, Greece, Austria, Portugal, Finland,
            Luxemburg, Norway, Sweden, Switzerland}
            + Iceland
    $$OffText

    RESTEU      "Rest of EU & Iceland" !! EUW

    $$OnText
        RESTOPEC = {Ecuador, Nigeria, Angola, Congo, Iran, Venezuela, Algeria,
            Libya, Bahrain, Iraq, Israel, Jordan, Kuwait, Lebanon,
            Palestinian Territory, Oman, Qatar,
            Syrian Arab Republic, United Arab Emirates, Yemen}
    $$OffText
    RESTOPEC    "Other Oil-Exporting countries" !! OPC

    ODA         "Other developing and emerging East Asia & New Zealand" !! ROW
    OAF         "Other developing and emerging Africa"        !! ROW
    OEURASIA    "Other developing and emerging Eurasia"       !! ROW
    OLA         "Other developing and emerging Latin America" !! ROW

$EndIf.step1

* regional set rmuv(r)

$IfTheni.step1bis %step%=="rmuv"

   AUS             "Australia"
   JPN             "Japan"
   USA             "United States of America"
   Canada          "Canada"
   France          "France"
   Germany         "Germany"
   UK              "United Kingdom"
   Italy           "Italy"
   RESTEU          "Rest of EU & Iceland"

$EndIf.step1bis

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

$IfThen.step2 %step%=="region_mapping"

* G-Cubed isolated countries

    aus.aus
    chn.chn
    ind.ind
    jpn.jpn
    rus.rus
    usa.usa

* [EditJean]: si NZL --> ODA et xef --> RESTEU on ne peut plus retrouver "OEC"

    ODA.nzl
    RESTEU.xef
    ODA.xoc
    ODA.hkg
    Korea.kor
    ODA.mng
    ODA.twn
    ODA.xea

*	ASEAN

    ODA.khm
    ODA.lao
    ODA.mys
    ODA.phl
    ODA.sgp
    ODA.tha
    ODA.vnm
    ODA.xse
    ODA.brn
    Indonesia.idn

    ODA.bgd
    ODA.npl
    ODA.pak
    ODA.lka
    ODA.xsa
    Canada.can
    Mexico.mex
    OLA.xna !! xna ={Bermuda,Greenland, Saint Pierre and Miquelon}
    Argentina.arg   "UMI"
    OLA.bol         "LMI"
    Brazil.bra      "UMI"
    OLA.chl         "HIC"
    OLA.col         "UMI"
    RESTOPEC.ecu    "UMI"
    OLA.pry         "UMI"
    OLA.per         "UMI"
    OLA.ury         "HIC"
    RESTOPEC.ven    "UMI"
    OLA.xsm
    OLA.cri         "UMI"
    OLA.gtm         "UMI"
    OLA.hnd         "LMI"
    OLA.nic         "LMI"
    OLA.pan         "HIC"
    OLA.slv
    OLA.xca
    OLA.dom         "UMI"
    OLA.jam
    OLA.pri
    OLA.tto
    OLA.xcb
    RESTEU.aut
    RESTEU.bel
    RESTEU.cyp
    RESTEU.cze
    RESTEU.dnk
    RESTEU.est
    RESTEU.fin
    France.fra
    Germany.deu
    RESTEU.grc
    RESTEU.hun
    RESTEU.irl
    Italy.ita
    RESTEU.lva
    RESTEU.ltu
    RESTEU.lux
    RESTEU.mlt
    RESTEU.nld
    RESTEU.pol
    RESTEU.prt
    RESTEU.svk
    RESTEU.svn
    RESTEU.esp
    RESTEU.swe
    UK.gbr
    RESTEU.che
    RESTEU.nor
    OEURASIA.alb
    OEURASIA.blr
    RESTEU.bgr
    RESTEU.hrv
    RESTEU.rou
    OEURASIA.ukr
    OEURASIA.xee
    OEURASIA.xer
    OEURASIA.kaz
    OEURASIA.kgz
    OEURASIA.xsu
    OEURASIA.tjk
    OEURASIA.arm
    OEURASIA.aze
    OEURASIA.geo
    RESTOPEC.bhr
    RESTOPEC.irn
    RESTOPEC.isr
    RESTOPEC.jor
    RESTOPEC.kwt
    RESTOPEC.omn
    RESTOPEC.qat
    RESTOPEC.are
    RESTOPEC.xws
    $$IFi %GTAP_ver%=="10.1" RESTOPEC.irq  " Iraq"
    $$IFi %GTAP_ver%=="10.1" RESTOPEC.lbn  " Lebanon"
    $$IFi %GTAP_ver%=="10.1" RESTOPEC.pse  " West Bank of Gaza"
    $$IFi %GTAP_ver%=="10.1" RESTOPEC.syr  " Syrian Arab Republic"

    Saudi.sau
    Turkey.tur

    OAF.egy
    OAF.mar
    OAF.tun
    RESTOPEC.xnf    !! xnf = {Algeria, Libya}
    OAF.ben
    OAF.bfa
    OAF.cmr
    OAF.civ
    OAF.gha
    OAF.gin
    RESTOPEC.nga
    OAF.sen
    OAF.tgo
    OAF.xwf
    OAF.xcf
    RESTOPEC.xac    !! xac = {Angola, Congo the Democratic Republic of the}
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
    OAF.xec
    OAF.bwa
    OAF.nam
    SouthAfrica.zaf
    ODA.xsc !! xsc = {Lesotho & Swaziland} --> !!!Error should be OAF
    OLA.xtw
    $$IFi %GTAP_ver%=="10.1" OAF.sdn "Sudan"

$EndIf.step2

*------------------------------------------------------------------------------*
*                  3. Mapping with IEA WEO aggregation                         *
*------------------------------------------------------------------------------*

$IfTheni.step3 %step%=="WEOmapping"

    US      .usa
    CHINA   .chn
    INDIA   .ind
    RUS     .rus
    JPN     .jpn
    AUNZ    .aus !! pb if %RegionAgg%== "Small"
    CAN     .Canada
    MEX     .Mexico
    KOR     .Korea
    INDO    .Indonesia
    BRAZIL  .Brazil
    (CHILE,CSAMa)   .OLA  !! pb
    (OEURa,OE5).Turkey    !! pb
     CASP       .OEURASIA
    (OETE,OEURb).OEURASIA
    (ASEAN9,OASEAN).ODA
    (ODA,OASIA)    .ODA
    (OLAM,CSAMb).(OLA,Argentina)  !! pb
    (NAFR,OAFR).OAF               !! pb
    ME      .(RESTOPEC,Saudi)     !! pb
    SAFR    .SouthAfrica
    (EUG4,EUa)  . France
    (EUG4,EUa)  . Germany
    (EUG4,EUa)  . Italy
    (EUG4,OEURc). UK
    (EU17,EUa)  . RESTEU
    (EU7,EUc)   . RESTEU

$EndIf.step3

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

*---    Ordering to match ENV-Linkages output

$IfTheni.step4 %step%=="Sort_region"

    sort1   . aus           "Australia"
    sort2   . chn           "China"
    sort3   . jpn           "Japan"
    sort4   . ind           "India"
    sort5   . usa           "United States"
    sort6   . rus           "Russian Federation"
    sort7   . Argentina     "Argentina"
    sort8   . Brazil        "Brazil"
    sort9   . Canada        "Canada"
    sort10  . Indonesia     "Indonesia"
    sort11  . Korea         "South Korea"
    sort12  . Mexico        "Mexico"
    sort13  . Saudi         "Saudi Arabia"
    sort14  . SouthAfrica   "South Africa"
    sort15  . Turkey        "Turkey"
    sort16  . France        "France"
    sort17  . Germany       "Germany"
    sort18  . UK            "United Kingdom"
    sort19  . Italy         "Italy"
    sort20  . RESTEU        "Rest of EU & Iceland"
    sort21  . RESTOPEC      "Other Oil-Exporting countries"
    sort22  . ODA           "Other developing and emerging East Asia and New Zealand"
    sort23  . OAF           "Other developing and emerging Africa"
    sort24  . OEURASIA      "Other developing and emerging Eurasia"
    sort25  . OLA           "Other developing and emerging Latin America"

$EndIf.step4

*------------------------------------------------------------------------------*
*                       5. Define Aggregate regions                            *
*------------------------------------------------------------------------------*

$IfThen.step5 %step%=="define_ra"

        HIC    "High Income countries"
        MIC    "Medium Income countries"
        LIC    "Low Income countries"
        OILP   "Oil Producers"
        WORLD  "World Aggregate"

$EndIf.step5

*------------------------------------------------------------------------------*
*     6. mapra(ra,r) "Mapping of model regions to aggregate regions"           *
*------------------------------------------------------------------------------*

$IfTheni.step5 %step%=="mapping_ra"

    HIC.AUS
    HIC.JPN
    HIC.USA
    HIC.Canada
    HIC.Korea
    HIC.France
    HIC.Germany
    HIC.Italy
    HIC.UK
    HIC.RESTEU

    MIC.CHN
    MIC.Argentina
    MIC.Brazil
    MIC.Indonesia
    MIC.Mexico
    MIC.SouthAfrica
    MIC.Turkey
    MIC.OLA

    LIC.IND
    LIC.ODA
    LIC.OAF
    LIC.OEURASIA

    OILP.RUS
    OILP.Saudi
    OILP.RESTOPEC

$EndIf.step5

$droplocal step
