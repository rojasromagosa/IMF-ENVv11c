$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
   name        : "%sDir%\rAggOECD.gms
   purpose     : G-Cubed 10 Regions mapping
   created date: 2021 spring
   created by  : Jean Chateau
   called by   : some "%iFilesDir%\map.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/rAggSmall.gms $
   last changed revision: $Rev: 361 $
   last changed date    : $Date:: 2023-07-20 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$setlocal step "%1"

*------------------------------------------------------------------------------*
*                       1. Define Model regions                                *
*------------------------------------------------------------------------------*

$IfTheni.step1 %step%=="define_region"

* 6 Isolated countries in G-cubed

    usa     "United States of America"
    jpn     "Japan"
    aus     "Australia"
    chn     "China"
    ind     "India"
    rus     "Russian Federation"

* 4 aggregate regions in G-cubed

    $$OnText
    EUW = {Germany, France, Italy, Spain, Netherlands, Belgium, Bulgaria,
            Croatia, Czech Republic, Denmark, Estonia, Cyprus, Lithuania,
            Latvia, Hungary, Malta, Poland, Romania, Slovenia, Slovakia,
            Ireland, Greece, Austria, Portugal, Finland, United Kingdom,
            Luxemburg, Norway, Sweden, Switzerland}
    $$OffText
    EUW     "Europe"

    $$OnText
        OPC = {Ecuador, Nigeria, Angola, Congo, Iran, Venezuela, Algeria,
            Libya, Bahrain, Iraq, Israel, Jordan, Kuwait, Lebanon,
            Palestinian Territory, Oman, Qatar,
            Saudi Arabia,
            Syrian Arab Republic, United Arab Emirates, Yemen}
        --> Issues: Angola, Congo, Venezuela, Israel
    $$OffText
    OPC     "Oil-Exporting developing countries"

*    OEC = {Canada, New Zealand, Iceland, Liechtenstein}
    OEC     "Rest of the OECD"

    ROW     "Rest of the World"

$EndIf.step1

* regional set rmuv(r)

$IfTheni.step1bis %step%=="rmuv"

    usa     "United States of America"
    jpn     "Japan"
    aus     "Australia"
    OEC     "Rest of the OECD"
    EUW     "Europe"

$EndIf.step1bis

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

$IfTheni.step2 %step%=="region_mapping"

* G-Cubed isolated countries

    aus.aus
    chn.chn
    ind.ind
    jpn.jpn
    rus.rus
    usa.usa

* G-Cubed 4 aggregated regions

    OEC.nzl
    OEC.xef
    ROW.xoc
    ROW.hkg
    ROW.kor
    ROW.mng
    ROW.twn
    ROW.xea
    ROW.khm
    ROW.lao
    ROW.mys
    ROW.phl
    ROW.sgp
    ROW.tha
    ROW.vnm
    ROW.xse
    ROW.brn
    ROW.idn
    ROW.bgd
    ROW.npl
    ROW.pak
    ROW.lka
    ROW.xsa
    OEC.can
    ROW.mex
    ROW.xna !! xna ={Bermuda,Greenland, Saint Pierre and Miquelon}
    ROW.arg
    ROW.bol
    ROW.bra
    ROW.chl
    ROW.col
    OPC.ecu
    ROW.pry
    ROW.per
    ROW.ury
    OPC.ven
    ROW.xsm
    ROW.cri
    ROW.gtm
    ROW.hnd
    ROW.nic
    ROW.pan
    ROW.slv
    ROW.xca
    ROW.dom
    ROW.jam
    ROW.pri
    ROW.tto
    ROW.xcb
    EUW.aut
    EUW.bel
    EUW.cyp
    EUW.cze
    EUW.dnk
    EUW.est
    EUW.fin
    EUW.fra
    EUW.deu
    EUW.grc
    EUW.hun
    EUW.irl
    EUW.ita
    EUW.lva
    EUW.ltu
    EUW.lux
    EUW.mlt
    EUW.nld
    EUW.pol
    EUW.prt
    EUW.svk
    EUW.svn
    EUW.esp
    EUW.swe
    EUW.gbr
    EUW.che
    EUW.nor
    ROW.alb
    ROW.blr
    EUW.bgr
    EUW.hrv
    EUW.rou
    ROW.ukr
    ROW.xee
    ROW.xer
    ROW.kaz
    ROW.kgz
    ROW.xsu
    ROW.tjk
    ROW.arm
    ROW.aze
    ROW.geo
    OPC.bhr
    OPC.irn
    OPC.isr
    OPC.jor
    OPC.kwt
    OPC.omn
    OPC.qat
    OPC.sau
    ROW.tur
    OPC.are
    OPC.xws
    ROW.egy
    ROW.mar
    ROW.tun
    OPC.xnf !! xnf = {Algeria, Libya}
    ROW.ben
    ROW.bfa
    ROW.cmr
    ROW.civ
    ROW.gha
    ROW.gin
    OPC.nga
    ROW.sen
    ROW.tgo
    ROW.xwf
    ROW.xcf
    OPC.xac !! xac = {Angola, Congo the Democratic Republic of the}
    ROW.eth
    ROW.ken
    ROW.mdg
    ROW.mwi
    ROW.mus
    ROW.moz
    ROW.rwa
    ROW.tza
    ROW.uga
    ROW.zmb
    ROW.zwe
    ROW.xec
    ROW.bwa
    ROW.nam
    ROW.zaf
    ROW.xsc
    ROW.xtw

$EndIf.step2

*------------------------------------------------------------------------------*
*                  3. Mapping with IEA WEO aggregation                         *
*------------------------------------------------------------------------------*

$IfTheni.step3 %step%=="WEOmapping"

    US      .Usa
    CHINA   .chn
    INDIA   .ind
    RUS     .rus
    JPN     .jpn
    AUNZ    .aus
    CAN    . OEC
    MEX    . ROW
    (CSAMa,CHILE). ROW
    KOR . ROW
    (OEURa,OE5)    . EUW  !! pb
    (EUa,EUG4,OEURc)   . EUW
    (EUb,EU17)   . EUW
    (EUc,EU7)    . EUW
    (OEURb,OETE)   . ROW
    CASP   . ROW
    INDO   . ROW
    (OASEAN,ASEAN9) . ROW
    (OASIA,ODA)    . ROW
    BRAZIL . ROW
    (CSAMb,OLAM)   . ROW  !! pb
    NAFR   . ROW  !! pb
    ME     . OPC  !! pb
    OAFR   . ROW  !! pb
    SAFR   . ROW

$EndIf.step3

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

* Ordering to match Warwick Excel Files

$IfTheni.step4 %step%=="Sort_region"

        sort1   . usa   "United States"
        sort2   . jpn   "Japan"
        sort3   . aus   "Australia"
        sort4   . EUW   "Europe"
        sort5   . OEC   "Rest of the OECD"
        sort6   . chn   "China"
        sort7   . ind   "India"
        sort8   . ROW   "Rest of the World"
        sort9   . rus   "Russian Federation"
        sort10  . OPC   "Oil-Exporting developing countries"

$EndIf.step4

*------------------------------------------------------------------------------*
*     5. mapra(ra,r) "Mapping of model regions to aggregate regions"           *
*------------------------------------------------------------------------------*

$IfTheni.step5 %step%=="mapping_ra"

        HIC.(usa,aus,jpn,EUW,OEC)
        MIC.chn
        LIC.(ind,ROW)
        OILP.(OPC.rus)

$EndIf.step5

$droplocal step