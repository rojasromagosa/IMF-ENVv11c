$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
    GAMS file   : %iFilesDir%\specific_sets.gms
	purpose   	: Defining addtional sets for "OECD aggregation" projects
    created date: 2023-07-07
    created by  : Jean Chateau
    called by   : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/2022_OECD_Base/InputFiles/specific_sets.gms $
	last changed revision: $Rev: 249 $
	last changed date    : $Date:: 2023-03-17 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$Onempty

*------------------------------------------------------------------------------*
*                        Regional subsets                                      *
*------------------------------------------------------------------------------*

SETS

    chn(r)      "China"                         / chn /
    ind(r)      "India"                         / ind /
    rus(r)      "Russian Federation"            / rus /
    usa(r)      "United States of America"      / usa /

*	G7 countries

    can(r)      "Canada"                        / can /
    deu(r)      "Germany"                       / deu /
    fra(r)      "France"                        / fra /
    gbr(r)      "United Kingdom"                / gbr /
    jpn(r)      "Japan"                         / jpn /
    ita(r)      "Italy"                         / ita /

*   OEN "Other OECD EU & EFTA: North countries"

    $$IF NOT SET split_Denmark OEN(r) "Other OECD EU & EFTA: North countries" / OEN /
    $$IF     SET split_Denmark OEN(r) "Other OECD EU & EFTA: North countries" / /
    dnk(r)      "Denmark"                        /  /
    fin(r)      "Finland"                        /  /
    irl(r)      "Ireland"                        /  /
    isl(r)      "Iceland (and Liechtenstein)"    /  /
    nor(r)      "Norway"                         /  /
    swe(r)      "Sweden"                         /  /

*   OEC "Other OECD countries"

    $$IF NOT SET split_Australia OEC(r)  "Other OECD countries" / OEC /
    $$IF     SET split_Australia OEC(r)  "Other OECD countries" /  /
    aus(r)      "Australia"         /  /
    isr(r)      "Israel"            /  /
    kor(r)      "South Korea"       /  /
    nzl(r)      "New Zealand"       /  /
    tur(r)      "Turkey"            /  /
    idn(r)      "Indonesia"         /  /

*   OEE

    $$IF NOT SET split_Latvia  OEE(r) "Other OECD EU Eastern Countries" / OEE /
    $$IF     SET split_Latvia  OEE(r) "Other OECD EU Eastern Countries" /  /
    cze(r)      "Czech Republic"    /  /
    est(r)      "Estonia"           /  /
    hun(r)      "Hungary"           /  /
    ltu(r)      "Lithuania"         /  /
    Latvia(r)   "Latvia"            /  /
    pol(r)      "Poland"            /  /
    svk(r)      "Slovakia"          /  /

*   OEW

    $$IF NOT SET split_Portugal OEW(r) "Other EU & EFTA West countries" / OEW /
    $$IF     SET split_Portugal OEW(r) "Other EU & EFTA West countries" /  /
    aut(r)      "Austria"           /  /
    bel(r)      "Belgium"           /  /
    che(r)      "Switzerland"       /  /
    lux(r)      "Luxemburg"         /  /
    nld(r)      "Netherlands"       /  /
    esp(r)      "Spain"             /  /
    grc(r)      "Greece"            /  /
    prt(r)      "Portugal"          /  /
    svn(r)      "Slovenia"          /  /

*   OLA / OEL

    arg(r)      "Argentina"         /  /
    bra(r)      "Brazil"            /  /

*... of wich "OECD Latin America"

    $$IF NOT SET split_Mexico OEL(r) "OECD Latin America" / OEL /
    $$IF     SET split_Mexico OEL(r) "OECD Latin America" /  /
    chl(r)       "Chile"        /  /
    col(r)       "Colombia"     /  /
    CostaRica(r) "Costa Rica"   /  /
    mex(r)       "Mexico"       /  /

*   ENO "Other EU non OECD"

* [2023-08-29] to not make confusion with "OECD Europe non-EU countries"
* we now call  "EU non-OECD countries" ENO

    $$IF NOT SET split_Romania ENO(r) "EU non-OECD countries" / ENO /
    $$IF     SET split_Romania ENO(r) "EU non-OECD countries" /  /
    bgr(r)       "Bulgaria"     /  /
    rou(r)       "Romania"      /  /
    hrv(r)       "Croatia"      /  /
    cyp(r)       "Cyprus"       /  /
    mlt(r)       "Malta"        /  /

*   ROW / OAF / OME

    tun(r)     "Tunisia"        /  /
    sau(r)     "Saudi Arabia"   /  /
    zaf(r)     "South Africa"   /  /

*   Regional Groups

* standard Regional sets

    OAF(r)     "Other developing and emerging Africa"               / OAF /
    OEA(r)     "Other developing and emerging Eurasia (OEURASIA)"   / OEA /
    ODA(r)     "Other developing and emerging East Asia"            / ODA /
    OLA(r)     "Other developing and emerging Latin America"  		/ OLA /
    OME(r)     "Other Middle east countries"                        / OME /

* Empty regional sets

    AS9(r)   "ASEAN countries (excluding Indonesia)"   /  / !! OSEAN or ASEAN9
*	ASEAN(r) "ASEAN countries (including Indonesia)"   /  /
    NAF(r)   "North African Countries"                 /  /
    TAN(r)   "Caspian Countries"   					   /  /
    EUW(r)   "Europe (G-cubed)"                        /  /
    OPC(r)   "Oil-Exporting developing countries (G-cubed)" / /

* Regional sets to be filled below

    EG4(r)		"France, Italy, UK, Germany (old IEA set)"
    OCE(r)		"OECD Oceanian countries"
    OPEP(r)		"Middle east OPEC countries"
    JPK(r)		"Japan and South Korea"
    OECD(r)		"OECD countries"
    NOTOECD(r)	"Non-OECD countries"
    TransE(r)   "Transition Economies"
    OECD_AME(r) "OECD American countries"
    OECD_PAC(r) "OECD Pacific countries"
    LATIN(r)    "Latin America (excl. Mexico)"
    WEU(r)      "OECD Europe + EU non OECD"
    OLD_OECD(r) "Old OECD countries"
    ROW(r)      "Rest of the world (not OECD, non BRICS, not Transition Economies, not OPEC)"
    RESTOPEC(r) "OPEC countries (Saudi excluded)"
    EU(r)       "EU countries"
	RESTEU(r) 	"EU countries (France, Italy and Germany Excluded)"
    EUE(r)      "EU eastern countries (non OECD)"
    SEA(r)      "South East Asia"
	OEU(r)  	"OECD Europe non-EU countries"

;

$OnMulti

$IF SET split_Denmark       dnk("dnk") = YES ;
$IF SET split_Finland       fin("fin") = YES ;
$IF SET split_Ireland       irl("irl") = YES ;
$IF SET split_Iceland       isl("isl") = YES ;
$IF SET split_Norway        nor("nor") = YES ;
$IF SET split_Sweden        swe("swe") = YES ;

$IF SET split_Argentina     arg("arg") = YES ;
$IF SET split_Brazil        bra("bra") = YES ;
$IF SET split_Chile         chl("chl") = YES ;
$IF SET split_Colombia      col("col") = YES ;
$IF SET split_CostaRica     CostaRica("cri") = YES ;
$IF SET split_Mexico        mex("mex") = YES ;

$IF SET split_Australia     aus("aus") = YES ;
$IF SET split_Israel        isr("isr") = YES ;
$IF SET split_SouthKorea    kor("kor") = YES ;
$IF SET split_NewZealand    nzl("nzl") = YES ;
$IF SET split_Turkey        tur("tur") = YES ;
$IF SET split_Indonesia     idn("idn") = YES ;

$IF SET split_Spain         esp("esp") = YES ;
$IF SET split_Austria       aut("aut") = YES ;
$IF SET split_Belgium       bel("bel") = YES ;
$IF SET split_Switzerland   che("che") = YES ;
$IF SET split_Luxemburg     lux("lux") = YES ;
$IF SET split_Netherlands   nld("nld") = YES ;
$IF SET split_Greece        grc("grc") = YES ;
$IF SET split_Portugal      prt("prt") = YES ;
$IF SET split_Slovania      svn("svn") = YES ;

$IF SET split_Czech         cze("cze") = YES ;
$IF SET split_Estonia       est("est") = YES ;
$IF SET split_Hungary       hun("hun") = YES ;
$IF SET split_Latvia        ltu("ltu") = YES ;
$IF SET split_Lithuania     Latvia("lva") = YES ;
$IF SET split_Poland        pol("pol") = YES ;
$IF SET split_Slovakia      svk("svk") = YES ;

$IF SET split_Saudi         sau("sau") = YES ;
$IF SET split_Tunisia       tun("tun") = YES ;
$IF SET split_SouthAfrica   zaf("zaf") = YES ;

$IF SET split_Bulgaria      bgr("bgr") = YES ;
$IF SET split_Romania       rou("rou") = YES ;
$IF SET split_Croatia       hrv("hrv") = YES ;
$IF SET split_Cyprus        cyp("cyp") = YES ;
$IF SET split_Malta         mlt("mlt") = YES ;

$OffMulti

* OEURASIA

alias(RAN,OEA);

EG4(r)  = fra(r) + deu(r) + gbr(r) + ita(r);
OCE(r)  = nzl(r) + aus(r) ;
OPEP(r) = sau(r) + OME(r) ;
JPK(r)  = jpn(r) + kor(r) ;

* Old OECD: Pb Israel & Turkey in OEC(r) when not split

OLD_OECD(r)
    = aut(r) + bel(r) + che(r) + lux(r) + nld(r) + esp(r) + grc(r)
    + prt(r) + deu(r) + fra(r) + gbr(r) + ita(r)
    + usa(r) + can(r)
    + dnk(r) + fin(r) + irl(r) + isl(r) + nor(r) + swe(r)
    + aus(r) + jpn(r) + kor(r) + nzl(r)
    + OEN(r) + OEC(r) + OEW(r) ;

OECD(r)
    = aut(r) + bel(r) + che(r) + lux(r) + nld(r) + esp(r) + grc(r)
    + prt(r) + svn(r) + deu(r) + fra(r)  + ita(r) + OEW(r)
    + jpn(r) + gbr(r) + usa(r) + can(r)
    + chl(r) + col(r) + costarica(r) + mex(r) + OEL(r)
    + dnk(r) + fin(r) + irl(r) + isl(r) + nor(r) + swe(r) + OEN(r)
    + aus(r) + isr(r) + kor(r) + nzl(r) + tur(r) + OEC(r)
    + cze(r) + est(r) + hun(r) + ltu(r) + Latvia(r) + pol(r) + svk(r) + OEE(r) ;

OECD_AME(r) = usa(r) + can(r) + chl(r) + col(r) + costarica(r) + mex(r) + OEL(r);

OECD_PAC(r) = aus(r) + jpn(r) + kor(r) + nzl(r) + OEC(r);

NOTOECD(r) = NOT OECD(r) ;

*ASEAN(r) $ ( card(AS9) ge 1) = AS9(r) + IDN(r) ;
*ASEAN(r) $ ( card(AS9) eq 0) = NO ;

* "EU eastern countries (non OECD)" like EU7 but without Lva & Ltu now OECD

EUE(r) = bgr(r) + rou(r) + hrv(r) + cyp(r) + mlt(r) + ENO(r) ;

* "OECD Europe non-EU countries"

OEU(r) = isl(r) + nor(r) + che(r) + gbr(r) + tur(r) + isr(r) ;

* RESTEU: Pb if WEU not split because of "che",
* pb if OEN not split because isl & nor

RESTEU(r)
    = aut(r) + bel(r)  + lux(r) + nld(r) + esp(r) + grc(r)
    + prt(r) + svn(r) + deu(r) + fra(r) + ita(r)
    + dnk(r) + fin(r) + irl(r) + swe(r)
    + cze(r) + est(r) + hun(r) + ltu(r) + Latvia(r) + pol(r) + svk(r)
    + bgr(r) + rou(r) + hrv(r) + cyp(r) + mlt(r)
	+ ENO(r) + OEE(r) + OEN(r) + OEW(r) ;

alias(RESTEU,REU) ;

EU(r)  = deu(r) + fra(r) + ita(r) + RESTEU(r) ;

WEU(r) = EU(r) + isl(r) + nor(r) + che(r) + gbr(r);

* LATIN(r) : Pb Mexico with OEL if not split

LATIN(r)    = chl(r) + col(r) + costarica(r) + bra(r) + OLA(r) + arg(r) + OEL(r);
TransE(r)   = rus(r) + RAN(r) ;
ROW(r)      = OAF(r) + ODA(r) + OLA(r) ;
SEA(r)      = chn(r) + ind(r) + idn(r) + AS9(r) + ODA(r);
RESTOPEC(r) = OPEP(r) - sau(r) ;

*------------------------------------------------------------------------------*
*                       Aggregate Regions                                      *
*------------------------------------------------------------------------------*

$OnMulti
Set ra /
    "EU-ETS"    "Countries participating to EU-ETS"
    "EU"        "European Union"
    "OECD"      "OECD countries"
/ ;
$OffMulti

mapr("EU",EU)      = YES ;

mapr("EU-ETS",EU)  = YES ;
mapr("EU-ETS",che) = YES ;
mapr("EU-ETS",isl) = YES ;
mapr("EU-ETS",nor) = YES ;
mapr("EU-ETS",gbr) = YES ;

mapr("OECD",OECD) = YES ;

$Offempty

*------------------------------------------------------------------------------*
*               Sector/Commodity additional sets                               *
*------------------------------------------------------------------------------*

*   Some Global variables for Sectoral Labels

$Ifi NOT %split_oma%== ON $SetGlobal OMA_name 'oma'
$Ifi     %split_oma%== ON $SetGlobal OME_name 'ome'
$Ifi     %split_oma%== ON $SetGlobal BPH_name 'bph'
$Ifi     %split_oma%== ON $SetGlobal OMF_name 'omf'
$Ifi     %split_oma%== ON $SetGlobal EEQ_name 'eeq'
$Ifi     %split_oma%== ON $SetGlobal RPP_name 'rpp'
$Ifi     %split_oma%== ON $SetGlobal OTN_name 'otn'
$Ifi     %split_oma%== ON $SetGlobal OMF_name 'omf'
$Ifi     %split_oma%== ON $SetGlobal MVH_name 'mvh'

$IfTheni %split_acr%=="ON"
    $$SetGlobal PDR_name 'pdr'
    $$SetGlobal C_B_name 'c_b'
    $$SetGlobal OCR_name 'ocr'
    $$SetGlobal OSD_name 'osd'
    $$SetGlobal V_F_name 'v_f'
    $$SetGlobal GRO_name 'gro'
    $$SetGlobal WHT_name 'wht'
    $$SetGlobal PFB_name 'pfb'
$EndIf

SET trueservk(k) "Household commodity set: true Services" / osc-k, osg-k / ;
