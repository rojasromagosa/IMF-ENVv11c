$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model :  Aggregation Procedure
    GAMS file   : GTAP_regions.gms
    purpose     : Define GTAP regional set --> r0
    Created by  : Jean Chateau
    created Date: 2020-10-27
    called by   : %DataDir%\common_sets\setsGTAP.gms
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 483 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Last checked for GTAP V11b (no more XCF)
--------------------------------------------------------------------------------
$OffText

set r0 "Set of regions in GTAP Version %GTAP_ver%" /
        AUS     "Australia"
*               - Australia
*               - Christmas Island
*               - Cocos (Keeling) Islands
*               - Heard Island and McDonald Islands
*               - Norfolk Island

        NZL     "New Zealand"

        XOC     "Rest of Oceania"
*               - American Samoa
*               - Cook Islands
*               - Fiji
*               - French Polynesia
*               - Guam
*               - Kiribati
*               - Marshall Islands
*               - Micronesia Federated States of
*               - Nauru
*               - New Caledonia
*               - Niue
*               - Northern Mariana Islands
*               - Palau
*               - Papua New Guinea
*               - Pitcairn
*               - Samoa
*               - Solomon Islands
*               - Tokelau
*               - Tonga
*               - Tuvalu
*               - United States Minor Outlying Islands
*               - Vanuatu
*               - Wallis and Futuna

        CHN     "China"
        HKG     "Hong Kong"
        JPN     "Japan"
        KOR     "Korea Republic of"
        MNG     "Mongolia"
        TWN     "Chinese Taipei"

        XEA     "Rest of East Asia"
*               - Korea Democratic Peoples Republic of
*               - Macao

        KHM     "Cambodia"
        IDN     "Indonesia"
        LAO     "Lao People s Democratic Republic"
        MYS     "Malaysia"
        PHL     "Philippines"
        SGP     "Singapore"
        THA     "Thailand"
        VNM     "Viet Nam"

        XSE     "Rest of Southeast Asia"
*               - Myanmar
*               - Timor Leste

        BRN     "Brunei Darussalam"
        BGD     "Bangladesh"
        IND     "India"
        NPL     "Nepal"
        PAK     "Pakistan"
        LKA     "Sri Lanka"

        XSA     "Rest of South Asia"
*               - Afghanistan
*               - Bhutan
*               - Maldives
		$$IFi %GTAP_ver%=="11b"  AFG  "Afghanistan"

        CAN     "Canada"
        USA     "United States of America"
        MEX     "Mexico"
        XNA     "Rest of North America"
*               - Bermuda
*               - Greenland
*               - Saint Pierre and Miquelon

        ARG     "Argentina"
        BOL     "Plurinational Republic of Bolivia"
        BRA     "Brazil"
        CHL     "Chile"
        COL     "Colombia"
        ECU     "Ecuador"
        PRY     "Paraguay"
        PER     "Peru"
        URY     "Uruguay"
        VEN     "Venezuela"
        XSM     "Rest of South America"
*               - Falkland Islands (Malvinas)
*               - French Guiana
*               - Guyana
*               - South Georgia and the South Sandwich Islands
*               - Suriname
        CRI     "Costa Rica"
        GTM     "Guatemala"
        HND     "Honduras"
        NIC     "Nicaragua"
        PAN     "Panama"
        SLV     "El Salvador"
        XCA     "Rest of Central America: Belize"

        XCB     "Caribbean"
*               - Anguilla
*               - Antigua & Barbuda
*               - Aruba
*               - Bahamas
*               - Barbados
*               - Cayman Islands
*               - Cuba
*               - Dominica
*               - Grenada
*               - Haiti
*               - Montserrat
*               - Netherlands Antilles / Sint Maarten (Dutch part)
*               - Saint Kitts and Nevis
*               - Saint Lucia
*               - Saint Vincent and the Grenadines
*               - Turks and Caicos Islands
*               - Virgin Islands British
*               - Virgin Islands U.S.
* Jean: Quid Curacao and Saint Martin, St Barth ?
		$$IFi %GTAP_ver%=="11b"  HTI  "Haiti"

        DOM     "Dominican Republic"
        JAM     "Jamaica"
        PRI     "Puerto Rico"
        TTO     "Trinidad and Tobago"

        AUT     "Austria"
        BEL     "Belgium"
        CYP     "Cyprus"
        CZE     "Czech Republic"
        DNK     "Denmark"
        EST     "Estonia"

        FIN     "Finland"
*               - Aland Islands
*               - Finland

        FRA     "France"
*               - France
*               - Guadeloupe
*               - Martinique
*               - Reunion

        DEU     "Germany"
        GRC     "Greece"
        HUN     "Hungary"
        IRL     "Ireland"
        ITA     "Italy"
        LVA     "Latvia"
        LTU     "Lithuania"
        LUX     "Luxembourg"
        MLT     "Malta"
        NLD     "Netherlands"
        POL     "Poland"
        PRT     "Portugal"
        SVK     "Slovakia"
        SVN     "Slovenia"
        ESP     "Spain"
        SWE     "Sweden"
        GBR     "United Kingdom"
        CHE     "Switzerland"

        NOR     "Norway"
*               - Norway
*               - Svalbard and Jan Mayen

        XEF     "Rest of EFTA"
*               - Iceland
*               - Liechtenstein

        ALB     "Albania"
        BGR     "Bulgaria"
        BLR     "Belarus"
        HRV     "Croatia"
        ROU     "Romania"
        RUS     "Russian Federation"
        UKR     "Ukraine"
        XEE     "Rest of Eastern Europe: Republic of Moldova"

        XER     "Rest of Europe"
*               - Andorra
*               - Bosnia and Herzegovina
*               - Faroe Islands
*               - Gibraltar
*               - Guernsey
*               - Holy See (Vatican City State)
*               - Isle of Man
*               - Jersey
*               - the Republic of North Macedonia
*               - Monaco
*               - Montenegro
*               - San Marino
*               - Serbia
*               - Kosovo
        $$IFi %GTAP_ver%=="10.1" srb  "Serbia"
        $$IFi %GTAP_ver%=="11b"  srb  "Serbia"

        KAZ     "Kazakhstan"
        KGZ     "Kyrgyzstan"
        TJK     "Tajikistan"
        ARM     "Armenia"
        AZE     "Azerbaijan"
        GEO     "Georgia"

        $$IFi NOT %GTAP_ver%=="11b" XSU "Rest of Former Soviet Union"
*               - Turkmenistan
*               - Uzbekistan
        $$IFi %GTAP_ver%=="11b" XSU "Turkmenistan"
        $$IFi %GTAP_ver%=="11b" uzb "Uzbekistan"

        BHR     "Bahrain"
        IRN     "Islamic Republic of Iran"
        ISR     "Israel"
        KWT     "Kuwait"
        OMN     "Oman"
        QAT     "Qatar"
        SAU     "Saudi Arabia"
        TUR     "T�rkiye"
        ARE     "United Arab Emirates"
        XWS     "Rest of Western Asia"
*               - Iraq
*               - Lebanon
*               - Palestinian Territory Occupied
*               - Syrian Arab Republic
*               - Yemen = XWS for V10.1 or V11
        JOR     "Jordan"

        $$IFi %GTAP_ver%=="10.1" irq "Iraq"
        $$IFi %GTAP_ver%=="10.1" lbn "Lebanon"
        $$IFi %GTAP_ver%=="10.1" syr "Syrian Arab Republic"
        $$IFi %GTAP_ver%=="10.1" pse "West Bank and Gaza"

		$$IFi %GTAP_ver%=="11b"  irq "Iraq"
		$$IFi %GTAP_ver%=="11b"  lbn "Lebanon"
		$$IFi %GTAP_ver%=="11b"  syr "Syrian Arab Republic"
		$$IFi %GTAP_ver%=="11b"  pse "West Bank and Gaza"

        EGY     "Egypt"
        MAR     "Morocco"
        TUN     "Tunisia"

        XNF     "Rest of North Africa"
*               - Algeria (GTAP < 11b)
*               - Libyan Arab Jamahiriya
*               - Western Sahara
        $$IFi %GTAP_ver%=="11b"  dza  "Algeria"

        CMR     "Cameroon"
        CIV     "Cote d Ivoire"
        GHA     "Ghana"
        NGA     "Nigeria"
        SEN     "Senegal"
        BEN     "Benin"
        BFA     "Burkina Faso"
        GIN     "Guinea"
        TGO     "Togo"

        XWF     "Rest of Western Africa"
*               - Cape Verde
*               - Gambia
*               - Guinea-Bissau
*               - Liberia
*               - Mali
*               - Mauritania
*               - Niger
*               - Saint Helena, Ascension and Tristan Da Cunha
*               - Sierra Leone
		$$IFi %GTAP_ver%=="11b"  MLI  "Mali"
		$$IFi %GTAP_ver%=="11b"  NER  "Niger"

		$$IFi NOT %GTAP_ver%=="11b" XCF "Central Africa"
*               - Central African Republic
*               - Chad
*               - Congo
*               - Equatorial Guinea
*               - Gabon
*               - Before GTAP 11: Sao Tome and Principe

		$$IFi %GTAP_ver%=="11b"  CAF  "Central African Republic"
		$$IFi %GTAP_ver%=="11b"  TCD  "Chad"
		$$IFi %GTAP_ver%=="11b"  GNQ  "Equatorial Guinea"
		$$IFi %GTAP_ver%=="11b"  GAB  "Gabon"
		$$IFi %GTAP_ver%=="11b"  COG  "Congo"

        XAC     "South Central Africa"
*               - Angola
*               - Democratic Republic of the Congo	(For GTAP<11b)
*				- Sao Tome and Principe 			(For GTAP>10.1)
		$$IFi %GTAP_ver%=="11b"  COD  "Democratic Republic of the Congo"

        ETH     "Ethiopia"
        KEN     "Kenya"
        MDG     "Madagascar"
        MWI     "Malawi"
        MUS     "Mauritius"
        MOZ     "Mozambique"
        TZA     "United Republic of Tanzania"
        UGA     "Uganda"
        ZMB     "Zambia"
        ZWE     "Zimbabwe"
        RWA     "Rwanda"

        XEC     "Rest of Eastern Africa"
*               - Burundi
*               - Comoros
*               - Djibouti
*               - Eritrea
*               - Mayotte (FRA)
*               - Seychelles
*               - Somalia
*               - Sudan
		$$IFi %GTAP_ver%=="11b"  com "Comoros"
		$$IFi %GTAP_ver%=="10.1" sdn "Sudan"
		$$IFi %GTAP_ver%=="11b"  sdn "Sudan"

        BWA     "Botswana"
        NAM     "Namibia"
        ZAF     "South Africa"

        $$IFi NOT %GTAP_ver%=="11b" XSC "Rest of South African Customs Union"
*               - Lesotho
*               - Swaziland/Eswatini
		$$IFi     %GTAP_ver%=="11b"	swz "Eswatini"
		$$IFi     %GTAP_ver%=="11b"	XSC "Lesotho"

        XTW     "Rest of the World"
*               - Antarctica
*               - Bouvet Island
*               - British Indian Ocean Territory (Chagos Islands)
*               - French Southern Territories ( �les Saint-Paul &t Nouvelle-Amsterdam; Archipel Crozet; �les Kerguelen; Terre Ad�lie; �les �parses de l'oc�an Indien)
    / ;

alias(r0,reg) ;

sets
    TransE0(r0) "Transition Economies" /
	    $$IFi %GTAP_ver%=="10.1" srb,
        $$IFi %GTAP_ver%=="11b"  srb, uzb,
        alb, blr, ukr, xee, xer, rus, kaz, kgz, xsu, arm, aze, geo, tjk /
    OECD0(r0) "OECD countries" /
        aus, nzl, jpn, kor, can, usa, mex, chl, aut, bel, cze, dnk, est, fin,
        fra, deu, grc, hun, irl, isr, ita, lux, nld, pol, prt, svk, svn, esp,
        swe, tur, gbr, che, nor, xef, col, cri, lva, ltu  /
    EU70(r0)     "Non-OCDE EU countries (IEA aggregation)" / CYP, MLT, BGR, HRV, ROU /
    E170(r0)     "Non-OCDE EU countries (IEA aggregation)" / AUT, BEL, CZE, DNK, EST, FIN, GRC, HUN, IRL, LUX, NLD, POL, PRT, SVK, SVN, ESP, SWE /
    EG40(r0)     "Non-OCDE EU countries (IEA aggregation)" / FRA, ITA, GBR, DEU /
    OE50(r0)     "Other OECD Eurasia (IEA aggregation)"    / ISR, TUR, CHE, NOR, XEF /
    notoecd0(r0) "Non-OCDE countries"
    devE0(r0)    "Emerging countries"
    xtw0(r0)     "Rest of the World" / xtw /
;
notoecd0(r0) = not oecd0(r0);
devE0(r0)    = not oecd0(r0) and not TransE0(r0);



