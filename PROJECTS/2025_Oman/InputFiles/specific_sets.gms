$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
    GAMS file : ""%iFilesDir%\specific_sets.gms"
    purpose   : Defining new set to be used for the project "2023_G20"
    called by : "%ModelDir%\2-CommonIns.gms
    created   : 2023-01-11
    created by: Jean Chateau
    called by : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/2023_G20/InputFiles/specific_sets.gms $
   last changed revision: $Rev: 501 $
   last changed date    : $Date:: 2024-02-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$Onempty

*------------------------------------------------------------------------------*
*                        Regional subsets                                      *
*------------------------------------------------------------------------------*

Parameter
    elymixCalSim(r,a,t) "ElyMix to calibrate"
;

SETS

* New Agg. Procedure these set declarations are useless

$OnText

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

*	G20 countries

	aus(r)  "Australia"                 		/ aus /
	arg(r)  "Argentina"                 		/ arg /
	bra(r)  "Brazil"                    		/ bra /
	idn(r)  "Indonesia"                 		/ idn /
	kor(r)  "South Korea"               		/ kor /
	mex(r)  "Mexico"                    		/ mex /
	sau(r)  "Saudi Arabia"              		/ sau /
	zaf(r)  "South Africa"              		/ zaf /
	tur(r)  "Turkey"                    		/ tur /

	REU(r)   "Rest of EU & Iceland" 				/ REU /
	ROP(r) "OPEC countries (Saudi excluded)"   / ROP /
	ODA(r)      "Other developing and emerging East Asia & New Zealand" / ODA /
	OAF(r)      "Other developing and emerging Africa"  / OAF /
	OEA(r) "Other developing and emerging Eurasia" / OEA /
	OLA(r)      "Other developing and emerging Latin America" / OLA /
$OffText

    OMNadj(a) "Activities calibrated for OMN 2018 IO tables" / oma-a, osc-a, osg-a, cns-a, agr-a , otp-a, oil-a, gas-a, eim-a   /
* 
    NGFSreg(r)    "Regions using NGFS inputs" / CHN, IND, EUR, USA, APD, WHD, REU, AFR /
    OEC(r)      "Other OECD countries" /  /

    AS9(r)   "ASEAN countries (excluding Indonesia)"   /  / !! OSEAN or ASEAN9
*	ASEAN(r) "ASEAN countries (including Indonesia)"   /  /

    EG4(r)		"France, Italy, UK, Germany (old IEA set)"
    OCE(r)		"OECD Oceanian countries"
    OPEP(r)		"Middle east OPEC countries"
    JPK(r)		"Japan and South Korea"
    OECD(r)		"OECD countries"
    NOTOECD(r)	"Non-OECD countries"
    TransE(r)   "Transition Economies"
    OECD_AME(r) "OECD America"
    OECD_PAC(r) "OECD Pacific"
    LATIN(r)    "Latin America (excl. Mexico)"
    WEU(r)      "OECD Europe + EU non OECD"
    OLD_OECD(r) "Old OECD countries"
    ROW(r)      "Rest of the world (not OECD, non BRICS, not Transition Economies, not OPEC)"
***HRR: added EUR
    EU(r)       "EU countries" / EUR / 
*    allMCD(r)      "MCD region" / OMN, KAZ, KGZ, TJK, UZB, ARM, AZE, GEO, BHR, IRN, IRQ, JOR, KWT, QAT, 
*                                   SAU, ARE, DZA, EGY, MAR, TUN, MCD/
*    MCD_1(r)      "MCD sub-region 1" / OMN, BHR, IRN, KWT, QAT, ARE, SAU, DZA/
*    MCD_1(r)      "MCD sub-region 1" / OMN, BHR, IRN, KWT, QAT, ARE, SAU, DZA/
 
    allMCD(r)      "MCD region"      /KAZ, EGY, MAR, MCD, PAK, KGZ, TJK, UZB, ARM, AZE, GEO, BHR, IRN, IRQ, JOR, OMN, QAT, SAU, ARE, TUN/ 
*same as allMCD    MCD_1(r)      "MCD sub-region 1" /KAZ, EGY, MAR, MCD, PAK, KGZ, TJK, UZB, ARM, AZE, GEO, BHR, IRN, IRQ, JOR, OMN, QAT, SAU, ARE, TUN/  

    SEA(r)      "South East Asia"
	OEU(r)  	"OECD Europe non-EU countries"
    OEN(r)		"Other OECD EU & EFTA: North countries" / /
    OEL(r)		"OECD Latin America" 					/ /
    EUE(r)		"EU eastern countries (non OECD)" 		/ /
    NAF(r)		"North African Countries"         		/ /
	TAN(r)  "Caspian Countries"  			            / /



$$ifi %SectorAgg%=="MCD"        agri(i) "Agro commodities" / agr-c /
$$ifi %SectorAgg%=="Small"      agri(i) "Agro commodities" / cro-c, lvs-c /

;

***HRR: adding the "necessary" sets for calibration

OECD(r) = USA(r) + EUR(r) ;

***HRR: what do we need from this below? Clean up!
$ontext
* For TrueCBRDPR

    chl(r)   	 /  /
*    tun(r)   	 /  /
    col(r)   	 /  /
    dnk(r)       /  /
    fin(r)       /  /
    irl(r)       /  /
    isl(r)       /  /
    nor(r)       /  /
    swe(r)       /  /
    aut(r)       /  /
    bel(r)       /  /
    che(r)       /  /
    lux(r)       /  /
    nld(r)       /  /
    esp(r)       /  /
    grc(r)       /  /
    prt(r)       /  /
    svn(r)       /  /
    cze(r)       /  /
    est(r)       /  /
    hun(r)       /  /
    ltu(r)       /  /
    Latvia(r)    /  /
    pol(r)       /  /
    svk(r)       /  /
    isr(r)       /  /
    nzl(r)       /  /
    CostaRica(r) /  /
    bgr(r)       /  /
    hrv(r)       /  /
    rou(r)       /  /

***HRR
*new sets that are not defined with G20 agg
ROP(r) / /
jpn(r) / /
kor(r) / /

;

*$OnMulti

*   For emir: import: C:\MODELS\CGE\PROJECTS\2022_CPE\InputData\ExternalScenarios\IMF_input_rebalance_CPS_2021Aug.gdx

***HRR

*alias(Argentina,arg)  ;
*alias(Brazil,bra)     ;
*alias(Canada,can)     ;
*alias(Indonesia,idn)  ;
*alias(Korea,kor)	  ;
*alias(Mexico,mex)	  ;
*alias(Saudi,sau)	  ;
*alias(SouthAfrica,zaf);
*alias(Turkey,tur)     ;
*alias(France,fra)     ;
*alias(Germany,deu)    ;
*alias(UK,gbr)	      ;
*alias(Italy,ita)      ;
*alias(RAN,OEA)		  ;


* "OECD Europe non-EU countries"

***HRROEU(r) = isl(r) + nor(r) + che(r) + gbr(r) + tur(r) + isr(r) ;

***HRREG4(r)  = fra(r) + deu(r) + gbr(r) + ita(r);
OPEP(r) = sau(r) + ROP(r) ;
JPK(r)  = jpn(r) + kor(r) ;
OCE(r)  = AUS(r) ;
OLD_OECD(r) = deu(r) + fra(r) + gbr(r) + ita(r) + usa(r) + can(r)
            + aus(r) + jpn(r) + REU(r);


OECD_AME(r) = usa(r) + can(r) + mex(r) + chl(r) + col(r);

OECD_PAC(r) = aus(r) + jpn(r) + kor(r) ;

NOTOECD(r) = NOT OECD(r) ;

EU(r) = deu(r) + fra(r) + ita(r) + REU(r) ;

LATIN(r)    = bra(r) + OLA(r) + arg(r) + chl(r) + col(r);
TransE(r)   = rus(r) + OEA(r) ;
ROW(r)      = OAF(r) + ODA(r) + OLA(r) ;
SEA(r)      = chn(r) + ind(r) + idn(r) + ODA(r) + AS9(r);
WEU(r)      = EU(r) ;

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

mapr("EU",EU) = YES ;

mapr("EU-ETS",EU)  = YES ;
mapr("EU-ETS",che) = YES ;
mapr("EU-ETS",isl) = YES ;
mapr("EU-ETS",nor) = YES ;

mapr("OECD",OECD) = YES ;

$Offempty
$offtext


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