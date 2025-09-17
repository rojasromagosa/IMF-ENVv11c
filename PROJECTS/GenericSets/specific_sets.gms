$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
	GAMS file 	: "GenericSets\specific_sets.gms"
    purpose   	: Defining addtional sets for ENV-Linkages projects
	created date: 2022-09-20
    created by	: Jean Chateau
    called by 	: "%ModelDir%\00-sets.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/specific_sets.gms $
	last changed revision: $Rev: 384 $
	last changed date    : $Date:: 2023-09-01 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$onempty

*	Regions from CIRCLE Empty here

SETS
    AS9(r)        /  /
    CHL(r)        /  /
    MEA(r)        /  /
    NAF(r)        /  /
    TAN(r)        /  /
    ASEAN(r)      /  /
;

$IfTheni.SmallReg %RegionalAgg%=="Small"

    SETS
        arg(r)  "Argentina"        /  /
        bra(r)  "Brazil"           /  /
        can(r)  "Canada"           /  /
        idn(r)  "Indonesia"        /  /
        kor(r)  "South Korea"      /  /
        mex(r)  "Mexico"           /  /
        sau(r)  "Saudi Arabia"     /  /
        zaf(r)  "South Africa"     /  /
        tur(r)  "Turkey"           /  /
        fra(r)  "France"           /  /
        deu(r)  "Germany"          /  /
        gbr(r)  "United Kingdom"   /  /
        ita(r)  "Italy"            /  /
        nzl(r)  "New Zealand"      /  /

        RESTEU(r) "EU countries France, Italy and Germany Excluded" /  /
        RESTOPEC(r)  "Other Oil-Exporting countries"                /  /
        ODA(r)  "Other developing and emerging East Asia"           /  /
        OAF(r)  "Other developing and emerging Africa"              /  /
        OEA(r)  "Other developing and emerging Eurasia (OEURASIA)"  /  /
        OLA(r)  "Other developing and emerging Latin America"       /  /
    ;

$Else.SmallReg

    SETS
        EUW(r)  "Europe"                                 /   /
        OPC(r)  "Oil-Exporting developing countries"     /   /
        OEC(r)  "Rest of the OECD"                       /   /
        ROW(r)  "Rest of the World"                      /   /
    ;

$Endif.SmallReg

SETS
    EG4(r)
    OCE(r)
    JPK(r)
    EU(r)       "European Union"
    WEU(r)      "OECD Eurasia + EU non OECD"
    BRIC(r)     "BRICs"
    TransE(r)   "Transition Economies"
    LATIN(r)    "Latin America (excl. Mexico)"
    OECD_AME(r) "OECD America"
    OECD_PAC(r) "OECD Pacific"
    OECD(r)     "OECD countries"
    OLD_OECD(r)
    NOTOECD(r) "Non-OCDE countries"
    devE(r)    "Emerging countries"
    IsolatedEU(r) "Isolated EU countries"

    $$Ifi %RegionalAgg%=="G20"   OPEP(r) "Middle East" / Saudi,  RESTOPEC/
    $$Ifi %RegionalAgg%=="Small" OPEP(r) "Middle East" / OPC /

*    ASEAN(r)    "ASEAN countries"
    SEA(r)      "South East Asia"
    $$Ifi %RegionalAgg%=="G20" ROW(r) "Rest of the world (non OECD non BRICS non TE non OPEP)"

* Rque pb quand et E17 et OUE existent

    $$Ifi %RegionalAgg%=="Small" OUE(r) "OECD Europe" / EUW /
    $$Ifi %RegionalAgg%=="G20"   OUE(r) "OECD Europe" /  /
;

EG4(r)  = fra(r) + deu(r) + gbr(r) + ita(r);
OCE(r)  = nzl(r) + aus(r);
JPK(r)  = JPN(r)  + KOR(r);

alias(OEA,RAN)   ;
alias(RESTEU,E17);

$$Ifi %RegionalAgg%=="G20" EU(r) = EG4(r) + RESTEU(r);
$$Ifi %RegionalAgg%=="Small" EU(r) = EUW(r);
WEU(r)          = EU(r) ; !! + XEF(r) + CHE(r) + NOR(r)
SEA(r)          = CHN(r) + IND(r) + IDN(r) + AS9(r) + ODA(r);
IsolatedEU(r)   = EG4(r);
TransE(r)       = RUS(r)  + RAN(r) + TAN(r);
LATIN(r)        = CHL(r)  + BRA(r) + OLA(r) +  Argentina(r);
BRIC(r)         = RUS(r)  + CHN(r) + BRA(r) + IND(r);
OECD_AME(r)     = USA(r)  + CAN(r) + MEX(r) + CHL(r);
OECD_PAC(r)     = JPK(r) + OCE(r);
OECD(r)         = WEU(r) + OECD_AME(r) + OECD_PAC(r);
OLD_OECD(r)     = OECD(r) - MEX(r) - CHL(r);

notoecd(r)      = not OECD(r);
devE(r)         = not OECD(r) and not TransE(r);
$Ifi %RegionalAgg%=="G20" ROW(r) = ODA(r) + OLA(r) + OAF(r);

$offempty

*------------------------------------------------------------------------------*
*               Mapping with ENV-Linkages V3 Circle aggregation                *
*------------------------------------------------------------------------------*
$SetGlobal SetsDirNewEl "%ProjectDir%\Sets\setsOldEl"
$SetGlobal SetsDirOldEl "%Foldermain%\Projects\CIRCLE_SETS\setsOldEl"

SETS
    oldr "ENV-Linkages V3 - Circle Regions" /
        $$include "%SetsDirOldEl%\regions.gms"
    /
    map_r(oldr,r) /
        $$IfTheni.SmallReg %RegionalAgg%=="Small"
            AS9.ROW
            BRA.ROW
            CAN.OEC
            CHL.ROW
            CHN.chn
            E17.EUW
            EG4.EUW
            EU7.EUW
            IDN.ROW
            IND.ind
            JPN.jpn
            KOR.ROW
            MEA.OPC
            MEX.ROW
            NAF.ROW
            OAF.ROW
            OCE.aus
            ODA.ROW
            OE5.ROW
            OEU.ROW
            OLA.ROW
            RUS.rus
            TAN.ROW
            USA.Usa
            ZAF.ROW
        $$Endif.SmallReg
        $$IfTheni.LargeReg %RegionalAgg%=="G20"
            as9.ODA
            BRA.Brazil
            CAN.Canada
            CHL.OLA
            CHN.chn
            e17.RESTEU
            eg4.(France,UK,Germany,Italy)
            eu7.RESTEU
            IDN.Indonesia
            IND.Ind
            JPN.jpn
            KOR.Korea
            mea.(Saudi,RESTOPEC)
            MEX.Mexico
            naf.OAF
            oaf.OAF
            oce.aus
            oda.ODA
            oe5.Turkey
            oeu.OEURASIA
            ola.(OLA,Argentina)
            RUS.rus
            tan.OEURASIA
            USA.Usa
            ZAF.SouthAfrica
        $$Endif.LargeReg
    /
;

*------------------------------------------------------------------------------*
*               Sector/Commodity additional sets                               *
*------------------------------------------------------------------------------*

*	Global variables for Sectoral Labels

$SetGlobal ELY_name    'ELY'
$SetGlobal GAS_name    'gas'
$SetGlobal COA_name    'coa'
$SetGlobal WTR_name    'wts'
$SetGlobal FMP_name    'fmp'
$SetGlobal ELFOSS_name 'CLP'
$SetGlobal ELE_name    'ele'
$Ifi NOT %split_oma%== ON $SetGlobal OMA_name 'oma'
$Ifi     %split_oma%== ON $SetGlobal OME_name 'ome'
$Ifi     %split_oma%== ON $SetGlobal BPH_name 'bph'

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