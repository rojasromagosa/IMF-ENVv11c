$setlocal step "%1"

* Load Here %RegionalAgg% or Agg. type

$setlocal IMFENVAgg "%2"

*------------------------------------------------------------------------------*
*                       1. Define Model regions                                *
*------------------------------------------------------------------------------*

$IfTheni.step1 %step%=="define_region"

* 6 Isolated countries in G-cubed (#)

    $$IfTheni.Isolated %IMFENVAgg%=="Isolated"
        usa     "United States of America"
        jpn     "Japan"
        aus     "Australia"
        chn     "China"
        ind     "India"
        rus     "Russian Federation"
    $$Endif.Isolated

* 4 aggregate regions in G-cubed

    $$IfTheni.AggSmall %IMFENVAgg%=="Small"
        EUW     "Europe"
        $$OnText
           EUW = {Germany, France, Italy, Spain, Netherlands, Belgium, Bulgaria,
                Croatia, Czech Republic, Denmark, Estonia, Cyprus, Lithuania,
                Latvia, Hungary, Malta, Poland, Romania, Slovenia, Slovakia,
                Ireland, Greece, Austria, Portugal, Finland, United Kingdom,
                Luxemburg, Norway, Sweden, Switzerland}
        $$OffText
        OPC     "Oil-Exporting developing countries"
        $$OnText
            OPC = {Ecuador, Nigeria, Angola, Congo, Iran, Venezuela, Algeria,
                Libya, Bahrain, Iraq, Israel, Jordan, Kuwait, Lebanon,
                Palestinian Territory, Oman, Qatar,
                Saudi Arabia,
                Syrian Arab Republic, United Arab Emirates, Yemen}
            --> Issues: Angola, Congo, Venezuela, Israel
        $$OffText
        OEC     "Rest of the OECD" !!  OEC = {Canada, New Zealand, Iceland, Liechtenstein}
        ROW     "Rest of the World"
    $$Endif.AggSmall

*	Extension of G-Cubed Aggregation to G20

    $$IfTheni.AggLarge %IMFENVAgg%=="Large"
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
        RESTEU      "Rest of EU & Iceland" !! EUW
        $$OnText
            RESTEU = {Spain, Netherlands, Belgium, Bulgaria, Croatia,
                Czech Republic, Denmark, Estonia, Cyprus, Lithuania,
                Latvia, Hungary, Malta, Poland, Romania, Slovenia, Slovakia,
                Ireland, Greece, Austria, Portugal, Finland,
                Luxemburg, Norway, Sweden, Switzerland}
                + Iceland
        $$OffText
*---    Group of Region/countries
        RESTOPEC    "Other Oil-Exporting countries" !! OPC
        $$OnText
            RESTOPEC = {Ecuador, Nigeria, Angola, Congo, Iran, Venezuela, Algeria,
                Libya, Bahrain, Iraq, Israel, Jordan, Kuwait, Lebanon,
                Palestinian Territory, Oman, Qatar,
                Syrian Arab Republic, United Arab Emirates, Yemen}
        $$OffText
        ODA         "Other developing and emerging East Asia & New Zealand" !! ROW
        OAF         "Other developing and emerging Africa"        !! ROW
        OEURASIA    "Other developing and emerging Eurasia"       !! ROW
        OLA         "Other developing and emerging Latin America" !! ROW
    $$Endif.AggLarge

    $$IfTheni.EUagg %IMFENVAgg%=="EUagg"
        usa         "United States of America"
        chn         "China"
        ind         "India"
        rus         "Russian Federation"
        OEP         "OECD Pacific"
        OEA         "OECD America (USA excluded)"
        MEA         "Middle East"
        OEURASIA    "Other developing and emerging Eurasia"
        OAF         "Africa"
        ODA         "Other developing and emerging East Asia"
        OEURASIA    "Other developing and emerging Eurasia"
        OLA         "Other developing and emerging Latin America"

        $$batinclude "%SetsDirForGCubed%\EUagg.gms"

        RESTEU      "Rest of EU"
        OEE         "Rest of non EU OECD Europe"

    $$Endif.EUagg

$EndIf.step1

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

$IfTheni.step2 %step%=="region_mapping"

*---    G20 Aggegation

    $$IfTheni.AggLarge %IMFENVAgg%=="Large"

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
*---    AS9
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
        Saudi.sau
        Turkey.tur
        RESTOPEC.are
        RESTOPEC.xws
        OAF.egy
        OAF.mar
        OAF.tun
* xnf = {Algeria, Libya}
        RESTOPEC.xnf
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
* xac = {Angola, Congo the Democratic Republic of the}
        RESTOPEC.xac
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
        ODA.xsc
        OLA.xtw
    $$Endif.AggLarge

*---    exact G-Cubed 10 Regions mapping

    $$IfTheni.AggSmall %IMFENVAgg%=="Small"

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
    $$Endif.AggSmall

$EndIf.step2

*------------------------------------------------------------------------------*
*                  3. Mapping with IEA WEO aggregation                         *
*------------------------------------------------------------------------------*

$IfTheni.step3 %step%=="WEOmapping"
    US   .usa
    CHINA.chn
    INDIA.ind
    RUS  .rus
    JPN  .jpn
    AUNZ .aus !! pb if %RegionAgg%== "Small"
    $$IfTheni.AggSmall %IMFENVAgg%=="Large"
        CAN   .Canada
        MEX   .Mexico
        KOR   .Korea
        INDO  .Indonesia
        BRAZIL.Brazil
        CHILE .OLA            !! pb
        EUG4  .(France,Germany,UK,Italy)
        OE5   .Turkey         !! pb
        EU17  .RESTEU         !! pb
        EU7   .RESTEU         !! pb
        OETE  .OEURASIA
        CASP  .OEURASIA
        ASEAN9.ODA
        ODA   .ODA
        OLAM.(OLA,Argentina)  !! pb
        NAFR.OAF              !! pb
        OAFR.OAF              !! pb
        ME.(RESTOPEC,Saudi)   !! pb
        SAFR.SouthAfrica
    $$Endif.AggSmall
    $$IfTheni.AggSmall %IMFENVAgg%=="Small"
        CAN    . OEC
        MEX    . ROW
        CHILE  . ROW
        KOR    . ROW
        OE5    . EUW  !! pb
        EUG4   . EUW
        EU17   . EUW
        EU7    . EUW
        OETE   . ROW
        CASP   . ROW
        INDO   . ROW
        ASEAN9 . ROW
        ODA    . ROW
        BRAZIL . ROW
        OLAM   . ROW  !! pb
        NAFR   . ROW  !! pb
        ME     . OPC  !! pb
        OAFR   . ROW  !! pb
        SAFR   . ROW
    $$Endif.AggSmall

$EndIf.step3

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

$IfTheni.step4 %step%=="Sort_region"

*---    Ordering to match Warwick Excel Files

    $$IfTheni.AggSmall %IMFENVAgg%=="Small"
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
    $$Endif.AggSmall

*---    Ordering to match ENV-Linkages output
    $$IfTheni.AggLarge %IMFENVAgg%=="Large"
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
    $$Endif.AggLarge

$EndIf.step4

$droplocal step
$droplocal IMFENVAgg


