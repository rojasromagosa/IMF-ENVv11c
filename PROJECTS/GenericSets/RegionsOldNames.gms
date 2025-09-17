$setlocal step "%1"

*--- Load Here %RegionalAgg%
$setlocal GCubedVer "%2"

$IfThen.step1 %step%=="define_region"

*---    Isolated countries in G-cubed (#)
    $$IfTheni.Isolated %GCubedVer%=="Isolated"
        Australia   "Australia"
        China       "China"
        India       "India"
        Japan       "Japan"
        Russia      "Russian Federation"
        Usa         "United States of America"
    $$Endif.Isolated

*---    4. Aggregate regions in G-cubed
    $$IfTheni.AggSmall %GCubedVer%=="Small"
        EUROPE      "Europe"
        $$OnText
            Europe= {Germany, France, Italy, Spain, Netherlands, Belgium, Bulgaria,
                Croatia, Czech Republic, Denmark, Estonia, Cyprus, Lithuania,
                Latvia, Hungary, Malta, Poland, Romania, Slovenia, Slovakia,
                Ireland, Greece, Austria, Portugal, Finland, United Kingdom,
                Luxemburg, Norway, Sweden, Switzerland}
        $$OffText
        OPEC        "Oil-Exporting developing countries"
        $$OnText
            OPEC = {Ecuador, Nigeria, Angola, Congo, Iran, Venezuela, Algeria,
                Libya, Bahrain, Iraq, Israel, Jordan,
                Kuwait, Lebanon, Palestinian Territory, Oman, Qatar,
                Saudi Arabia, Syrian Arab Republic, United Arab Emirates, Yemen}
            --> Issues: Angola, Congo, Venezuela, Israel
        $$OffText
        ROECD       "Rest of the OECD"
*---    ROECD = {Canada, New Zealand, Iceland, Liechtenstein}
        ROW         "Rest of the World"
    $$Endif.AggSmall

    $$IfTheni.AggLarge %GCubedVer%=="Large"
        Argentina   "Argentina"            !! ROW | UM
        Brazil      "Brazil"               !! ROW | UM
        Canada      "Canada"               !! ROECD
        Indonesia   "Indonesia"            !! ROW
        Korea       "South Korea"          !! ROW
        Mexico      "Mexico"               !! ROW  | UM
        Saudi       "Saudi Arabia"         !! OPEC
        SouthAfrica "South Africa"         !! ROW
        Turkey      "Turkey"               !! ROW | UM
        France      "France"               !! EUROPE
        Germany     "Germany"              !! EUROPE
        UK          "United Kingdom"       !! EUROPE
        Italy       "Italy"                !! EUROPE
*        RESTEU     "Rest of EU"           !! EUROPE
        RESTEU      "Rest of EU & Iceland" !! EUROPE
        $$OnText
            RESTEU = {Spain, Netherlands, Belgium, Bulgaria, Croatia,
                Czech Republic, Denmark, Estonia, Cyprus, Lithuania,
                Latvia, Hungary, Malta, Poland, Romania, Slovenia, Slovakia,
                Ireland, Greece, Austria, Portugal, Finland,
                Luxemburg, Norway, Sweden, Switzerland}
        $$OffText
*---    Not G20 but to recover original G-Cubed regions:
*        NewZealand  ""    !! ROECD
*        XEF         "Rest of EFTA"   !! ROECD !! Iceland & Liechtenstein
*        NZLXEF      "Rest of EFTA & New Zealand"
*---    Group of Region/countries
        RESTOPEC    "Other Oil-Exporting countries" !! OPEC
        $$OnText
            OPEC = {Ecuador, Nigeria, Angola, Congo, Iran, Venezuela, Algeria,
                Libya, Bahrain, Iraq, Israel, Jordan, Kuwait, Lebanon,
                Palestinian Territory, Oman, Qatar, Syrian Arab Republic,
                United Arab Emirates, Yemen}
        $$OffText
        ODA         "Other developing and emerging East Asia and New Zealand"     !! ROW
        OAF         "Other developing and emerging Africa"        !! ROW
        OEURASIA    "Other developing and emerging Eurasia"       !! ROW
        OLA         "Other developing and emerging Latin America" !! ROW
    $$Endif.AggLarge

$EndIf.step1

$IfThen.step2 %step%=="region_mapping"

*---    In both regional aggregation
    Australia.aus
    China.chn
    India.ind
    Japan.jpn
    Russia.rus
    Usa.usa

    $$IfTheni.AggLarge %GCubedVer%=="Large"
*        NewZealand.nzl
*        XEF.xef
*        NZLXEF.nzl
*        NZLXEF.xef

* [EditJean]: si je met NZL avec ODA et xef avec RESTEU je ne peux plus retrouver la region ROECD de G-Cubed
        ODA   .nzl
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
* [TBC]: xna ={Bermuda,Greenland, Saint Pierre and Miquelon}
        OLA.xna
        Argentina.arg
        OLA.bol
        Brazil.bra
        OLA.chl
        OLA.col
        RESTOPEC.ecu
        OLA.pry
        OLA.per
        OLA.ury
        RESTOPEC.ven
        OLA.xsm
        OLA.cri
        OLA.gtm
        OLA.hnd
        OLA.nic
        OLA.pan
        OLA.slv
        OLA.xca
        OLA.dom
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
    $$IfTheni.AggSmall %GCubedVer%=="Small"
        ROECD.nzl
        ROECD.xef

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
        ROECD.can
        ROW.mex
* [TBC]: xna ={Bermuda,Greenland, Saint Pierre and Miquelon}
        ROW.xna
        ROW.arg
        ROW.bol
        ROW.bra
        ROW.chl
        ROW.col
        OPEC.ecu
        ROW.pry
        ROW.per
        ROW.ury
        OPEC.ven
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
        EUROPE.aut
        EUROPE.bel
        EUROPE.cyp
        EUROPE.cze
        EUROPE.dnk
        EUROPE.est
        EUROPE.fin
        EUROPE.fra
        EUROPE.deu
        EUROPE.grc
        EUROPE.hun
        EUROPE.irl
        EUROPE.ita
        EUROPE.lva
        EUROPE.ltu
        EUROPE.lux
        EUROPE.mlt
        EUROPE.nld
        EUROPE.pol
        EUROPE.prt
        EUROPE.svk
        EUROPE.svn
        EUROPE.esp
        EUROPE.swe
        EUROPE.gbr
        EUROPE.che
        EUROPE.nor
        ROW.alb
        ROW.blr
        EUROPE.bgr
        EUROPE.hrv
        EUROPE.rou
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
        OPEC.bhr
        OPEC.irn
        OPEC.isr
        OPEC.jor
        OPEC.kwt
        OPEC.omn
        OPEC.qat
        OPEC.sau
        ROW.tur
        OPEC.are
        OPEC.xws
        ROW.egy
        ROW.mar
        ROW.tun
* xnf = {Algeria, Libya}
        OPEC.xnf
        ROW.ben
        ROW.bfa
        ROW.cmr
        ROW.civ
        ROW.gha
        ROW.gin
        OPEC.nga
        ROW.sen
        ROW.tgo
        ROW.xwf
        ROW.xcf
* xac = {Angola, Congo the Democratic Republic of the}
        OPEC.xac
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
*                   Mapping with IEA WEO aggregation                           *
*------------------------------------------------------------------------------*
$IfTheni.step3 %step%=="WEOmapping"
    US   .Usa
    CHINA.China
    INDIA.India
    RUS  .Russia
    JPN  .Japan
    AUNZ .Australia !! pb if %RegionAgg%== "Small"
    $$IfTheni.AggSmall %GCubedVer%=="Large"
*        AUNZ  .NewZealand
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
    $$IfTheni.AggSmall %GCubedVer%=="Small"
        CAN    . ROECD
        MEX    . ROW
        CHILE  . ROW
        KOR    . ROW
        OE5    . EUROPE !! pb
        EUG4   . EUROPE
        EU17   . EUROPE
        EU7    . EUROPE
        OETE   . ROW
        CASP   . ROW
        INDO   . ROW
        ASEAN9 . ROW
        ODA    . ROW
        BRAZIL . ROW
        OLAM   . ROW  !! pb
        NAFR   . ROW  !! pb
        ME     . OPEC !! pb
        OAFR   . ROW  !! pb
        SAFR   . ROW
    $$Endif.AggSmall

$EndIf.step3


$IfThen.step4 %step%=="Sort_region"

*---    4. Aggregate regions in G-cubed
    $$IfTheni.AggSmall %GCubedVer%=="Small"
        sort1   . Australia	  "Australia"
        sort2   . China	      "China"
        sort3   . Europe	  "Europe"
        sort4   . India	      "India"
        sort5   . Japan	      "Japan"
        sort6   . OPEC	      "Oil-Exporting developing countries"
        sort7   . ROECD	      "Rest of the OECD"
        sort8   . ROW	      "Rest of the World"
        sort9   . Russia	  "Russian Federation"
        sort10  . Usa	      "United States"
    $$Endif.AggSmall

    $$IfTheni.AggLarge %GCubedVer%=="Large"
        sort1   . Australia	  "Australia"
        sort2   . China	      "China"
        sort3   . RESTEU      "Rest of EU & Iceland"
        sort4   . India	      "India"
        sort5   . Japan	      "Japan"
        sort6   . RESTOPEC    "Other Oil-Exporting countries"
        sort7   . Canada      "Canada"
        sort8   . OEURASIA    "Other developing and emerging Eurasia"
        sort9   . Russia	  "Russian Federation"
        sort10  . Usa	      "United States"
        sort11  . Argentina   "Argentina"
        sort12  . Brazil      "Brazil"
        sort13  . OLA         "Other developing and emerging Latin America"
        sort14  . France      "France"
        sort15  . Germany     "Germany"
        sort16  . UK          "United Kingdom"
        sort17  . Italy       "Italy"
        sort18  . Indonesia   "Indonesia"
        sort19  . Korea       "South Korea"
        sort20  . Mexico      "Mexico"
        sort21  . Saudi       "Saudi Arabia"
        sort22  . SouthAfrica "South Africa"
        sort23  . Turkey      "Turkey"
        sort24  . ODA         "Other developing and emerging East Asia and New Zealand"
        sort25  . OAF         "Other developing and emerging Africa"

    $$Endif.AggLarge

$EndIf.step4


$droplocal step
$droplocal GCubedVer


