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

    USA     "United States of America"
    JPN     "Japan"
    AUS     "Australia"
    CHN     "China"
    IND     "India"
    RUS     "Russian Federation"
    ARG     "Argentina"
    BRA     "Brazil"
    CAN     "Canada"
    IDN     "Indonesia"
    KOR     "South Korea"
    MEX     "Mexico"
    SAU     "Saudi Arabia"
    ZAF     "South Africa"
    TUR     "Turkey"
    DEU     "Germany"
    FRA     "France"
    GBR     "United Kingdom"
    ITA     "Italy"

*---    Group of Region/countries
        
    REU    "Rest of EU + EFTA" 

    ROP    "Other OPEC and MENA countries" 
    ODA    "Other East Asia & New Zealand" 
    OAF    "Other Africa"        
    OEA    "Other Eurasia"       
    OLA    "Other Latin America" 

$EndIf.step1

* regional set rmuv(r)

$IfTheni.step1bis %step%=="rmuv"

   AUS     "Australia"
   JPN     "Japan"
   USA     "United States of America"
   CAN     "Canada"
   DEU     "Germany"
   FRA     "France"
   GBR     "United Kingdom"
   ITA     "Italy"
   REU     "Rest of EU + EFTA"

$EndIf.step1bis

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

$IfThen.step2 %step%=="region_mapping"

* Oceania
    aus.aus
    ODA.nzl
    ODA.xoc

* East Asia
    chn.chn
    ODA.hkg
    jpn.jpn
    kor.kor
    ODA.mng
    ODA.twn
    ODA.xea

* ASEAN
    ODA.brn
    ODA.khm
    idn.idn
    ODA.lao
    ODA.mys
    ODA.phl
    ODA.sgp
    ODA.tha
    ODA.vnm
    ODA.xse

* South Asia
    $$IFi %GTAP_ver%=="11c"      ODA.afg
    ODA.bgd
    ind.ind
    ODA.npl
    ODA.pak
    ODA.lka
    ODA.xsa

* North America    
    can.can
    usa.usa
    mex.mex
    OLA.xna

* South America
    arg.arg   		
    OLA.bol         
    bra.bra      	
    OLA.chl         
    OLA.col         
    OLA.ecu    
    OLA.pry         
    OLA.per         
    OLA.ury         
    OLA.ven    
    OLA.xsm

* Central American & the Caribbean    
    OLA.cri         
    OLA.gtm         
    OLA.hnd         
    OLA.nic         
    OLA.pan         
    OLA.slv
    OLA.xca
    OLA.dom 
    $$IFi %GTAP_ver%=="11c"     OLA.hti      
    OLA.jam
    OLA.pri
    OLA.tto
    OLA.xcb

* European Union    
    REU.aut
    REU.bel
    REU.bgr
    REU.hrv    
    REU.cyp
    REU.cze
    REU.dnk
    REU.est
    REU.fin
    fra.fra
    deu.deu
    REU.grc
    REU.hun
    REU.irl
    ita.ita
    REU.lva
    REU.ltu
    REU.lux
    REU.mlt
    REU.nld
    REU.pol
    REU.prt
    REU.rou
    REU.svk
    REU.svn
    REU.esp
    REU.swe

* Rest Western Europe    
    gbr.gbr
    REU.che
    REU.nor
    REU.xef

* Rest Central and Eastern Europe
    OEA.alb
    OEA.blr
    $$IFi %GTAP_ver%=="11c"      OEA.srb    
    Rus.rus
    OEA.ukr
    OEA.xee
    OEA.xer
    
* Central Asia    
    OEA.arm
    OEA.aze
    OEA.geo    
    OEA.kaz
    OEA.kgz
    OEA.tjk
    $$IFi %GTAP_ver%=="11c"     OEA.uzb
    OEA.xsu

* Middle East 
    ROP.bhr
    $$IFi %GTAP_ver%=="11c"     ROP.irq    
    ROP.irn
    ROP.isr
    ROP.jor
    ROP.kwt
    $$IFi %GTAP_ver%=="11c"     ROP.lbn
    ROP.omn
    $$IFi %GTAP_ver%=="11c"     ROP.pse
    ROP.qat
    sau.sau
    $$IFi %GTAP_ver%=="11c"     ROP.syr
    tur.tur
    ROP.are
    ROP.xws

* North Africa
    $$IFi %GTAP_ver%=="11c"     OAF.dza
    OAF.egy
    OAF.mar
    OAF.tun
    OAF.xnf    

* Western Africa
    OAF.ben
    OAF.bfa
    OAF.cmr
    OAF.civ
    OAF.gha
    OAF.gin
    $$IFi %GTAP_ver%=="11c"     OAF.mli
    $$IFi %GTAP_ver%=="11c"     OAF.ner
    OAF.nga
    OAF.sen
    OAF.tgo
    OAF.xwf

* Central Africa    
    $$IFi %GTAP_ver%=="11c"     OAF.caf
    $$IFi %GTAP_ver%=="11c"     OAF.cog
    $$IFi %GTAP_ver%=="11c"     OAF.cod
    $$IFi %GTAP_ver%=="11c"     OAF.tcd
    $$IFi %GTAP_ver%=="11c"     OAF.gnq
    $$IFi %GTAP_ver%=="11c"     OAF.gab

    $$IFi %GTAP_ver%=="10.1"    OAF.xcf     
    OAF.xac

* Eastern Africa       
    $$IFi %GTAP_ver%=="11c"     OAF.com
    OAF.eth
    OAF.ken
    OAF.mdg
    OAF.mwi
    OAF.mus
    OAF.moz
    OAF.rwa
    $$IFi %GTAP_ver%=="11c"     OAF.sdn
    OAF.tza
    OAF.uga
    OAF.zmb
    OAF.zwe
    OAF.xec

* Southern Africa    
    OAF.bwa
    $$IFi %GTAP_ver%=="11c"     OAF.swz
    OAF.nam
    zaf.zaf
    OAF.xsc

* Rest of the World
    OLA.xtw

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
    sort4   . kor       "South Korea"
    sort5   . idn       "Indonesia"
    sort6   . ind       "India"
    sort7   . can       "Canada"
    sort8   . usa       "United States"
    sort9   . mex       "Mexico"
    sort10  . arg       "Argentina"
    sort11  . bra       "Brazil"
    sort12  . fra       "France"
    sort13  . deu       "Germany"
    sort14  . ita       "Italy"
    sort15  . REU       "Rest of EU & Iceland"
    sort16  . gbr       "United Kingdom"
    sort17  . tur       "Turkey"
    sort18  . rus       "Russian Federation"
    sort19  . sau       "Saudi Arabia"
    sort20  . zaf       "South Africa"
    sort21  . ROP       "Other Oil-Exporting countries"
    sort22  . ODA       "Other developing and emerging East Asia and New Zealand"
    sort23  . OAF       "Other developing and emerging Africa"
    sort24  . OEA       "Other developing and emerging Eurasia"
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
    HIC.REU

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
    LIC.OEA

    OILP.rus
    OILP.sau
    OILP.ROP

$EndIf.step5

$droplocal step
