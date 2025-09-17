$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
   name        : "%sDir%\rAggROW.gms.gms
   purpose     : OECD regional aggregation(s)
   created date: 2021-09-20
   created by  : Jean Chateau
   called by   : some "%iFilesDir%\map.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/rAggROW.gms $
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

*   4 Isolated countries (all OECD aggr) : G7 + China, India and Russia

    chn	"China"
    ind	"India"
    rus	"Russian Federation"
    usa	"United States of America"

*   Aggregated Regions

* 4 OECD regions

    OEL	"OECD Latin America plus Canada"
    OEP	"OECD Pacific"
	REU	"EU countries"
	OEU	"OECD Europe non-EU countries"

* 6 NON-OECD regions

    OME	"Middle east countries"
    OEA	"Other developing and emerging Eurasia (OEURASIA)"
    OAF	"Africa"
    ODA	"Other developing and emerging East Asia"
    OLA	"Other developing and emerging Latin America"

*   unsplit / split countries (project dependent) --> [TBU]

* OLA         "Other developing and emerging Latin America"

    $$IF SET split_Argentina    arg     "Argentina"
    $$IF SET split_Brazil       bra     "Brazil"

* OEL         "OECD Latin America plus Canada"

    $$IF SET split_Canada		can     "Canada"
    $$IF SET split_Chile        chl     "Chile"
    $$IF SET split_Colombia     col     "Colombia"
    $$IF SET split_CostaRica    cri     "Costa Rica"
    $$IF SET split_Mexico       mex     "Mexico"

* REU

    $$IF SET split_Austria     aut      "Austria"
    $$IF SET split_France      fra      "France"
    $$IF SET split_Germany     deu      "Germany"
    $$IF SET split_Italy       ita      "Italy"
    $$IF SET split_Spain       esp      "Spain"
    $$IF SET split_Netherlands nld      "Netherlands"
    $$IF SET split_Belgium     bel      "Belgium"
    $$IF SET split_Czech       cze      "Czech Republic"
    $$IF SET split_Denmark     dnk      "Denmark"
    $$IF SET split_Estonia     est      "Estonia"
    $$IF SET split_Lithuania   ltu      "Lithuania"
    $$IF SET split_Latvia      lva      "Latvia"
    $$IF SET split_Hungary     hun      "Hungary"
    $$IF SET split_Poland      pol      "Poland"
    $$IF SET split_Slovenia    svn      "Slovenia"
    $$IF SET split_Slovakia    svk      "Slovakia"
    $$IF SET split_Ireland     irl      "Ireland"
    $$IF SET split_Greece      grc      "Greece"
    $$IF SET split_Portugal    prt      "Portugal"
    $$IF SET split_Finland     fin      "Finland"
    $$IF SET split_Luxemburg   lux      "Luxemburg"
    $$IF SET split_Sweden      swe      "Sweden"

*	"Other EU non OECD" --> with REU

    $$IF SET split_Bulgaria     bgr     "Bulgaria"
    $$IF SET split_Romania      rou     "Romania"
    $$IF SET split_Croatia      hrv     "Croatia"
    $$IF SET split_Cyprus       cyp     "Cyprus"
    $$IF SET split_Malta        mlt     "Malta"

* OEU

    $$IF SET split_Iceland      isl     "Iceland (and Liechtenstein)"
    $$IF SET split_Norway       nor     "Norway"
	$$IF SET split_UK           gbr     "United Kingdom"
    $$IF SET split_Israel       isr     "Israel"
    $$IF SET split_Turkey       tur     "Turkey"
    $$IF SET split_Switzerland  che     "Switzerland"


* OEP:	"OECD Pacific"

    $$IF SET split_Australia    aus     "Australia"
    $$IF SET split_SouthKorea   kor     "South Korea"
    $$IF SET split_NewZealand   nzl     "New Zealand"
    $$IF SET split_Japan	    jpn     "Japan"

* ODA:	"Other developing and emerging East Asia"

    $$IF SET split_Indonesia    idn	"Indonesia"
    $$IF SET split_Thailand		tha	"Thailand"
    $$IF SET split_Philippines	phl	"Philippines"
    $$IF SET split_Malaysia		mys	"Malaysia"

* OAF/OME

    $$IF SET split_Tunisia      tun     "Tunisia"
    $$IF SET split_Saudi        sau     "Saudi Arabia"
    $$IF SET split_SouthAfrica  zaf     "South Africa"

$EndIf.step1

$IfTheni.step1bis %step%=="rmuv"

*   regional set rmuv(r) --> OECD advanced Economy

    usa     "United States of America"

    $$IF SET split_Canada can     "Canada"
	$$IF SET split_Japan  jpn     "Japan"

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

    OEP     "Other OECD countries"
    $$IF     SET split_Australia    aus     "Australia"
    $$IF     SET split_NewZealand   nzl     "New Zealand"

*   Logically not included but for consistency accross aggregations

*    $$IF     SET split_SouthKorea   kor     "South Korea"
*    $$IF     SET split_Israel       isr     "Israel"
*    $$IF     SET split_Turkey       tur     "Turkey"

$EndIf.step1bis


$IfThen.step2 %step%=="region_mapping"

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

* Non OECD europe isolated countries

    chn.(chn,hkg)   "China (included Honk Hong)"
    ind.ind         "India"
    rus.rus         "Russian Federation"
    usa.usa         "USA"

* OEP:	"OECD Pacific"

    $$IF NOT SET split_Japan    	OEP.jpn
    $$IF     SET split_Japan    	jpn.jpn
    $$IF NOT SET split_Australia    OEP.aus
    $$IF     SET split_Australia    aus.aus
    $$IF NOT SET split_SouthKorea   OEP.kor
    $$IF     SET split_SouthKorea   kor.kor
    $$IF NOT SET split_NewZealand   OEP.nzl
    $$IF     SET split_NewZealand   nzl.nzl

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

* REU:  "EU countries (27)"

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

    $$IF NOT SET split_Canada      OEL.can
    $$IF     SET split_Canada      can.can
    $$IF NOT SET split_Chile       OEL.chl
    $$IF     SET split_Chile       chl.chl
    $$IF NOT SET split_Colombia    OEL.col
    $$IF     SET split_Colombia    col.col
    $$IF NOT SET split_CostaRica   OEL.cri
    $$IF     SET split_CostaRica   cri.cri
    $$IF NOT SET split_Mexico      OEL.mex
    $$IF     SET split_Mexico      mex.mex

*   NON-OECD Europe countries

* OLA:	"Other developing and emerging Latin America"

    $$IF NOT SET split_Argentina OLA.arg
    $$IF     SET split_Argentina arg.arg
    $$IF NOT SET split_Brazil    OLA.bra
    $$IF     SET split_Brazil    bra.bra
    OLA.bol
    OLA.ecu
    OLA.pry
    OLA.per
    OLA.ury
    OLA.ven
    OLA.xsm
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

* Ces choix se discutent

    OLA.xtw     !! xtw = {Antarctica,Bouvet Island, Chagos Islands, French Southern Territories}
    OLA.xna     !! xna = {Bermuda,Greenland, Saint Pierre and Miquelon}

* ODA:	"Other developing and emerging East Asia"

    ODA.xoc
    ODA.mng
    ODA.twn
    ODA.xea
    ODA.khm
    ODA.lao
    ODA.sgp
    ODA.vnm
    ODA.xse
    ODA.brn
    ODA.bgd
    ODA.npl
    ODA.pak
    ODA.lka
    ODA.xsa !! xsa = {Afghanistan, Bhutan, Maldives}

	$$IF NOT SET split_Indonesia    ODA.idn
	$$IF     SET split_Indonesia    idn.idn
	$$IF NOT SET split_Thailand     ODA.tha
	$$IF     SET split_Thailand		tha.tha
	$$IF NOT SET split_Philippines	ODA.phl
	$$IF     SET split_Philippines	phl.phl
	$$IF NOT SET split_Malaysia     ODA.mys
	$$IF     SET split_Malaysia		mys.mys

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
    OME.irn
    OME.jor
    OME.kwt
    OME.omn
    OME.qat
    OME.are
    OME.xws
    $$IF NOT SET split_Saudi OME.sau
    $$IF     SET split_Saudi sau.sau

    $$IFi %GTAP_ver%=="10.1" OME.irq  " Iraq"
    $$IFi %GTAP_ver%=="10.1" OME.lbn  " Lebanon"
    $$IFi %GTAP_ver%=="10.1" OME.pse  " West Bank of Gaza"
    $$IFi %GTAP_ver%=="10.1" OME.syr  " Syrian Arab Republic"

* OAF: "Other developing and emerging Africa"

    $$IF NOT SET split_Tunisia  OAF.tun
    $$IF     SET split_Tunisia  tun.tun
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
    OAF.xec 		"Rest of Eastern Africa"
    $$IFi %GTAP_ver%=="10.1" OAF.sdn "Sudan"
    OAF.bwa
    OAF.nam
    $$IF NOT SET split_SouthAfrica  OAF.zaf
    $$IF     SET split_SouthAfrica  zaf.zaf
    OAF.xsc

$EndIf.step2

$IfTheni.step3 %step%=="WEOmapping"
*------------------------------------------------------------------------------*
*                  3. Mapping with IEA WEO aggregation                         *
*------------------------------------------------------------------------------*

* [EditJean]: since winter 2022 this is no more used in model or aggregation step

    US          . usa
    can         . can
    (EUG4,EUa)  . fra
    (EUG4,EUa)  . deu
    (EUG4,EUa)  . ita
    (EUG4,OEURc). gbr

* Quid HKG

    CHINA           . chn
    INDIA           . ind
    RUS             . rus
    JPN             . jpn

    $$IF     SET split_Brazil       BRAZIL.bra
    $$IF NOT SET split_Brazil       BRAZIL.OLA
    $$IF     SET split_Mexico       MEX.mex
    $$IF NOT SET split_Mexico       MEX.OEL

    $$IF     SET split_Argentina    (OLAM,CSAMb).arg

    $$IF     SET split_Chile        (CHILE,CSAMa).chl
    $$IF NOT SET split_Chile        (CHILE,CSAMa).OEL

* Pb in WEO mapping WEO 2018: col with OLAM that is not in OEL

    $$IF     SET split_Colombia     (OLAM,CSAMa).col

* Pb in WEO mapping WEO 2018 & 2020: cri with OLAM that is not in OEL

    $$IF     SET split_CostaRica    (OLAM,CSAMb).cri

* Need to always keep nzl & aus together

    $$IF     SET split_Australia    AUNZ.aus
    $$IF     SET split_NewZealand   AUNZ.nzl
    $$IF NOT SET split_Australia    AUNZ.OEC

    $$IF     SET split_SouthKorea   KOR.kor
    $$IF NOT SET split_SouthKorea   KOR.OEC

    $$IF     SET split_Turkey       (OEURa,OE5).(tur,isr)
    $$IF NOT SET split_Turkey       (OEURa,OE5).OEC

    $$IF     SET split_Indonesia    INDO.idn
    $$IF NOT SET split_Indonesia    INDO.ODA
    CASP            . OEA
    (OETE,OEURb)    . OEA
    (ASEAN9,OASEAN) . ODA
    (ODA,OASIA)     . ODA

    (NAFR,OAFR)     . OAF
    $$IF     SET split_SouthAfrica SAFR.zaf
    $$IF NOT SET split_SouthAfrica SAFR.OAF

    $$IF     SET split_Saudi ME.(sau,OME)
    $$IF NOT SET split_Saudi ME.OME

    $$IF NOT SET split_Spain  (EU17,EUb).OEW
    $$IF NOT SET split_Romania (EU7,EUc).OEE

$EndIf.step3

$IfTheni.step4 %step%=="Sort_region"

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

    $$IF SET split_Argentina     sort1.arg   "Argentina"
    $$IF SET split_Australia     sort2.aus   "Australia"
    $$IF SET split_Austria       sort3.aut   "Austria"
    $$IF SET split_Belgium       sort4.bel   "Belgium"
    $$IF SET split_Bulgaria      sort5.bgr   "Bulgaria"
    $$IF SET split_Brazil        sort6.bra   "Brazil"
    $$IF SET split_Canada        sort7.can   "Canada"
    $$IF SET split_Switzerland   sort8.che   "Switzerland"
    $$IF SET split_Chile         sort9.chl   "Chile"
                                 sort10.chn  "China"
    $$IF SET split_Colombia      sort11.col  "Colombia"
    $$IF SET split_CostaRica     sort12.cri  "Costa Rica"
    $$IF SET split_Czech         sort13.cze  "Czech Republic"
    $$IF SET split_Germany       sort14.deu  "Germany"
    $$IF SET split_Denmark       sort15.dnk  "Denmark"
    $$IF SET split_Spain         sort16.esp  "Spain"
    $$IF SET split_Estonia       sort17.est  "Estonia"
    $$IF SET split_Finland       sort18.fin  "Finland"
    $$IF SET split_France        sort19.fra  "France"
    $$IF SET split_UK            sort20.gbr  "United Kingdom"
    $$IF SET split_Greece        sort21.grc  "Greece"
    $$IF SET split_Hungary       sort22.hun  "Hungary"
    $$IF SET split_Indonesia     sort23.idn  "Indonesia"
                                 sort24.ind  "India"
    $$IF SET split_Ireland       sort25.irl  "Ireland"
    $$IF SET split_Iceland       sort26.isl  "Iceland (and Liechtenstein)"
    $$IF SET split_Israel        sort27.isr  "Israel"
    $$IF SET split_Italy         sort28.ita  "Italy"
    $$IF SET split_Japan         sort29.jpn  "Japan"
    $$IF SET split_SouthKorea    sort30.kor  "South Korea"
    $$IF SET split_Lithuania     sort31.ltu  "Lithuania"
    $$IF SET split_Luxemburg     sort32.lux  "Luxemburg"
    $$IF SET split_Latvia        sort33.lva  "Latvia"
    $$IF SET split_Mexico        sort34.mex  "Mexico"
    $$IF SET split_Netherlands   sort35.nld  "Netherlands"
    $$IF SET split_Norway        sort36.nor  "Norway"
    $$IF SET split_NewZealand    sort37.nzl  "New Zealand"
    $$IF SET split_Poland        sort38.pol  "Poland"
    $$IF SET split_Portugal      sort39.prt  "Portugal"
    $$IF SET split_Romania       sort40.rou  "Romania"
                                 sort41.rus  "Russian Federation"
    $$IF SET split_Saudi         sort42.sau  "Saudi Arabia"
    $$IF SET split_Slovakia      sort43.svk  "Slovakia"
    $$IF SET split_Slovania      sort44.svn  "Slovenia"
    $$IF SET split_Sweden        sort45.swe  "Sweden"
    $$IF SET split_Tunisia       sort46.tun  "Tunisia"
    $$IF SET split_Turkey        sort47.tur  "Turkey"
                                 sort48.usa  "United States of America"
    $$IF SET split_SouthAfrica   sort49.zaf  "South Africa"
    $$IF SET split_Croatia       sort50.hrv  "Croatia"
    $$IF SET split_Cyprus        sort51.cyp  "Cyprus"
    $$IF SET split_Malta         sort52.mlt  "Malta"
                                 sort59.ODA  "Other developing and emerging East Asia"
                                 sort53.OAF  "Other developing and emerging Africa"
                                 sort54.OEA  "Other developing and emerging EurAsia (OEURASIA)"
								 sort55.OEP  "OECD Pacific"
                                 sort56.OLA  "Other developing and emerging Latin America"
                                 sort57.OME  "Other Middle east countries"
    $$IF NOT SET split_Mexico    sort58.OEL  "OECD Latin America"
								 sort59.OEU  "OECD Europe non-EU countries"
								 sort60.REU  "EU countries"
    $$IF SET split_Thailand      sort61.tha	 "Thailand"
    $$IF SET split_Philippines	 sort62.phl	 "Philippines"
    $$IF SET split_Malaysia      sort63.mys	 "Malaysia"

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

* TBU
*         HIC.can

$ontext
*   OEC split (and IDN from ODA)

    $$IfTheni.SplitOEC SET split_Australia

                                    HIC.aus
        $$IF SET split_Israel       HIC.isr
        $$IF SET split_SouthKorea   HIC.kor
        $$IF SET split_NewZealand   HIC.nzl
        $$IF SET split_Turkey       HIC.tur

    $$Else.SplitOEC

        HIC.OEC

    $$EndIf.SplitOEC

	$$IF SET split_Indonesia   MIC.idn
	$$IF SET split_Thailand    MIC.tha
	$$IF SET split_Philippines LIC.phl
	$$IF SET split_Malaysia    MIC.mys

*   OLA split:

        MIC.OLA

    $$IfTheni.SplitOLA SET split_Mexico

        $$IF SET split_Argentina      MIC.arg
        $$IF SET split_Brazil         MIC.bra
        $$IF SET split_Chile         OECD.chl
        $$IF SET split_Colombia      OECD.col
        $$IF SET split_CostaRica     OECD.cri
                                     OECD.mex

    $$Else.SplitOLA

        OECD.OEL

    $$EndIf.SplitOLA

*   OEW split:

    $$IfTheni.SplitOEW SET split_Portugal

        $$IF SET split_Austria      (OECD,EU).aut
        $$IF SET split_Belgium      (OECD,EU).bel
        $$IF SET split_Switzerland   OECD.che
        $$IF SET split_Greece       (OECD,EU).grc
                                    (OECD,EU).esp
        $$IF SET split_Luxemburg    (OECD,EU).lux
        $$IF SET split_Netherlands  (OECD,EU).nld
        $$IF SET split_Portugal     (OECD,EU).prt
        $$IF SET split_Slovania     (OECD,EU).svn

    $$Else.SplitOEW

* [EditJean]: problem here because che not EU

        (OECD,EU).OEW

    $$EndIf.SplitOEW

*   OEE split:

    $$IfTheni.SplitOEE SET split_Lithuania


        $$IF SET split_Czech        (OECD,EU).cze
        $$IF SET split_Estonia      (OECD,EU).est
        $$IF SET split_Hungary      (OECD,EU).hun
        (OECD,EU).ltu
        $$IF SET split_Latvia       (OECD,EU).lva
        $$IF SET split_Poland       (OECD,EU).pol
        $$IF SET split_Slovakia     (OECD,EU).svk

    $$Else.SplitOEE

        (OECD,EU).OEE

    $$EndIf.SplitOEE

    $$IF SET split_Bulgaria     (HIC,EU).bgr
    $$IF SET split_Romania      (HIC,EU).rou
    $$IF SET split_Croatia      (HIC,EU).hrv
    $$IF SET split_Cyprus       (HIC,EU).cyp
    $$IF SET split_Malta        (HIC,EU).mlt
    $$IF NOT SET split_Bulgaria (HIC,EU).OEU

    $$IF SET split_Spain $IF SET split_Romania (HIC,EU).OEU

*   OEN split: split

    $$IfTheni.SplitOEN SET split_Denmark

                                (OECD,EU).dnk
        $$IF SET split_Finland  (OECD,EU).fin
        $$IF SET split_Ireland  (OECD,EU).irl
        $$IF SET split_Iceland       OECD.isl
        $$IF SET split_Norway        OECD.nor
        $$IF SET split_Sweden   (OECD,EU).swe

    $$Else.SplitOEN

* [EditJean]: problem here because isl & nor not EU

        (OECD,EU).OEN

    $$EndIf.SplitOEN

* OME/OAF split: (SAU out of OME and ZAF and NAF out of OAF)

    $$IF SET split_Saudi        OILP.sau
    $$IF SET split_Tunisia       MIC.tun
    $$IF SET split_SouthAfrica   MIC.zaf

    $$IF SET split_Croatia      (HIC,EU).hrv
    $$IF SET split_Cyprus       (HIC,EU).cyp
    $$IF SET split_Malta        (HIC,EU).mlt

$offtext


$EndIf.step6

$droplocal step
