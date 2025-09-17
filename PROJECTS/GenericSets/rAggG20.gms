$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
   name        : "%sDir%\rAggOECD.gms
   purpose     : G20 regional aggregation
   created date: 2021 spring
   created by  : Jean Chateau
   called by   : some "%iFilesDir%\map.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/rAggG20.gms $
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

    usa     "United States of America"
    jpn     "Japan"
    aus     "Australia"
    chn     "China"
    ind     "India"
    rus     "Russian Federation"
    arg     "Argentina"
    bra     "Brazil"
    can     "Canada"
    idn     "Indonesia"
    kor     "South Korea"
    mex     "Mexico"
    sau     "Saudi Arabia"
    zaf     "South Africa"
    tur     "Turkey"
    deu     "Germany"
    fra     "France"
    gbr     "United Kingdom"
    ita     "Italy"

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

   aus     "Australia"
   jpn     "Japan"
   usa     "United States of America"
   can     "Canada"
   deu     "Germany"
   fra     "France"
   gbr     "United Kingdom"
   ita     "Italy"
   RESTEU  "Rest of EU & Iceland"

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
    kor.kor
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
    idn.idn

    ODA.bgd
    ODA.npl
    ODA.pak
    ODA.lka
    ODA.xsa
    can.can
    mex.mex
    OLA.xna         !! xna ={Bermuda,Greenland, Saint Pierre and Miquelon}
    arg.arg   		"UMI"
    OLA.bol         "LMI"
    bra.bra      	"UMI"
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
    fra.fra
    deu.deu
    RESTEU.grc
    RESTEU.hun
    RESTEU.irl
    ita.ita
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
    gbr.gbr
    RESTEU.che
    RESTEU.nor
    OEURASIA.alb
    $$IFi %GTAP_ver%=="10.1" OEURASIA.srb
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

    sau.sau
    tur.tur

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
    zaf.zaf
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
    CAN     .can
    MEX     .mex
    KOR     .kor
    INDO    .idn
    BRAZIL  .bra
    (CHILE,CSAMa)   .OLA  		!! pb
    (OEURa,OE5).tur    			!! pb
     CASP       .OEURASIA
    (OETE,OEURb).OEURASIA
    (ASEAN9,OASEAN).ODA
    (ODA,OASIA)    .ODA
    (OLAM,CSAMb).(OLA,arg)  	!! pb
    (NAFR,OAFR).OAF             !! pb
    ME      .(RESTOPEC,sau)     !! pb
    SAFR        . zaf
    (EUG4,EUa)  . fra
    (EUG4,EUa)  . deu
    (EUG4,EUa)  . ita
    (EUG4,OEURc). gbr
    (EU17,EUa)  . RESTEU
    (EU7,EUc)   . RESTEU

$EndIf.step3

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

*---    Ordering to match ENV-Linkages output

$IfTheni.step4 %step%=="Sort_region"

    sort1   . aus       "Australia"
    sort2   . chn       "China"
    sort3   . jpn       "Japan"
    sort4   . ind       "India"
    sort5   . usa       "United States"
    sort6   . rus       "Russian Federation"
    sort7   . arg       "Argentina"
    sort8   . bra       "Brazil"
    sort9   . can       "Canada"
    sort10  . idn       "Indonesia"
    sort11  . kor       "South Korea"
    sort12  . mex       "Mexico"
    sort13  . sau       "Saudi Arabia"
    sort14  . zaf       "South Africa"
    sort15  . tur       "Turkey"
    sort16  . fra       "France"
    sort17  . deu       "Germany"
    sort18  . gbr       "United Kingdom"
    sort19  . ita       "Italy"
    sort20  . RESTEU    "Rest of EU & Iceland"
    sort21  . RESTOPEC  "Other Oil-Exporting countries"
    sort22  . ODA       "Other developing and emerging East Asia and New Zealand"
    sort23  . OAF       "Other developing and emerging Africa"
    sort24  . OEURASIA  "Other developing and emerging Eurasia"
    sort25  . OLA       "Other developing and emerging Latin America"

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

    HIC.aus
    HIC.jpn
    HIC.usa
    HIC.can
    HIC.kor
    HIC.fra
    HIC.deu
    HIC.ita
    HIC.gbr
    HIC.RESTEU

    MIC.chn
    MIC.arg
    MIC.bra
    MIC.idn
    MIC.mex
    MIC.zaf
    MIC.tur
    MIC.OLA

    LIC.ind
    LIC.ODA
    LIC.OAF
    LIC.OEURASIA

    OILP.rus
    OILP.sau
    OILP.RESTOPEC

$EndIf.step5

$droplocal step
