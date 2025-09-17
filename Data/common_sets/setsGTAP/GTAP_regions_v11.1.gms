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
   last changed revision: $Rev: 218 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Last checked for GTAP V10.1
--------------------------------------------------------------------------------
$OffText

set r0 "Set of regions in GTAP Version %GTAP_ver%" /

***Oceania
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

*** East Asia
        CHN     "China"
        HKG     "Hong Kong"
        JPN     "Japan"
        KOR     "Korea Republic of"
        MNG     "Mongolia"
        TWN     "Chinese Taipei"
        XEA     "Rest of East Asia"
*               - Korea Democratic Peoples Republic of
*               - Macao

***ASEAN
        BRN     "Brunei Darussalam"
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


***South Asia
	    AFG     "Afghanistan"
        BGD     "Bangladesh"
        IND     "India"
        NPL     "Nepal"
        PAK     "Pakistan"
        LKA     "Sri Lanka"
        XSA     "Rest of South Asia"
*               - Bhutan
*               - Maldives

***North America
        CAN     "Canada"
        USA     "United States of America"
        MEX     "Mexico"
        XNA     "Rest of North America"
*               - Bermuda
*               - Greenland
*               - Saint Pierre and Miquelon

***South America
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

***Central American & the Caribbean
        CRI     "Costa Rica"
        GTM     "Guatemala"
        HND     "Honduras"
        NIC     "Nicaragua"
        PAN     "Panama"
        SLV     "El Salvador"
        XCA     "Rest of Central America: Belize"


        DOM     "Dominican Republic"
	    HTI     "Haiti"
        JAM     "Jamaica"
        PRI     "Puerto Rico"
        TTO     "Trinidad and Tobago"
        XCB     "Rest of Caribbean"
*               - Anguilla
*               - Antigua & Barbuda
*               - Aruba
*               - Bahamas
*               - Barbados
*               - Cayman Islands
*               - Cuba
*               - Dominica
*               - Grenada
*               - Montserrat
*               - Netherlands Antilles / Sint Maarten (Dutch part)
*               - Saint Kitts and Nevis
*               - Saint Lucia
*               - Saint Vincent and the Grenadines
*               - Turks and Caicos Islands
*               - Virgin Islands British
*               - Virgin Islands U.S.

        AUT     "Austria"
        BEL     "Belgium"
        BGR     "Bulgaria"
        HRV     "Croatia"
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
        ROU     "Romania"
        SVK     "Slovakia"
        SVN     "Slovenia"
        ESP     "Spain"
        SWE     "Sweden"

***Rest Western Europe    
        GBR     "United Kingdom"
        CHE     "Switzerland"
        NOR     "Norway"
*               - Norway
*               - Svalbard and Jan Mayen
        XEF     "Rest of EFTA"
*               - Iceland
*               - Liechtenstein

***Rest Central and Eastern Europe
        ALB     "Albania"
        BLR     "Belarus"
        SRB     "Serbia"
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

***Central Asia
        ARM     "Armenia"
        AZE     "Azerbaijan"
        GEO     "Georgia"
        KAZ     "Kazakhstan"
        KGZ     "Kyrgyzstan"
        TJK     "Tajikistan"
        UZB     "Uzbekistan"
        XSU     "Rest of Former Soviet Union"
*               - Turkmenistan

***Middle East 
        BHR     "Bahrain"
        IRQ     "Iraq"
        IRN     "Islamic Republic of Iran"
        ISR     "Israel"
        JOR     "Jordan"
        KWT     "Kuwait"
	    LBN     "Lebanon"        
        OMN     "Oman"
        PSE     "West Bank and Gaza"
        QAT     "Qatar"
        SAU     "Saudi Arabia"
	    SYR     "Syrian Arab Republic"
        TUR     "Turkiye"
        ARE     "United Arab Emirates"
        XWS     "Rest of Western Asia"
*               - Yemen 

***North Africa
        DZA     "Algeria"
        EGY     "Egypt"
        MAR     "Morocco"
        TUN     "Tunisia"
        XNF     "Rest of North Africa"
*               - Libyan Arab Jamahiriya
*               - Western Sahara

***Western Africa
        BEN     "Benin"
        BFA     "Burkina Faso"
        CMR     "Cameroon"
        CIV     "Cote d Ivoire"
        GHA     "Ghana"
        GIN     "Guinea"
        MLI     "Mali"
	    NER     "Niger"
        NGA     "Nigeria"
        SEN     "Senegal"
        TGO     "Togo"
        XWF     "Rest of Western Africa"
*               - Cape Verde
*               - Gambia
*               - Guinea-Bissau
*               - Liberia
*               - Mauritania
*               - Saint Helena, Ascension and Tristan Da Cunha
*               - Sierra Leone

***Central Africa
        AGO     "Angola"
	    CAF     "Central African Republic"
	    COG     "Congo"
	    COD     "Democratic Republic of the Congo"
	    TCD     "Chad"
	    GNQ     "Equatorial Guinea"
	    GAB     "Gabon"
        STP     "Sao Tome and Principe"


***Eastern Africa
        BDI     "Burundi"
	    COM     "Comoros"
        ETH     "Ethiopia"
        KEN     "Kenya"
        MDG     "Madagascar"
        MWI     "Malawi"
        MUS     "Mauritius"
        MOZ     "Mozambique"
        RWA     "Rwanda"
        SDN     "Sudan"
        TZA     "United Republic of Tanzania"
        UGA     "Uganda"
        ZMB     "Zambia"
        ZWE     "Zimbabwe"
        XEC     "Rest of Eastern Africa"
*               - Djibouti
*               - Eritrea
*               - Mayotte 
*               - Seychelles
*               - Somalia
*               - South Sudan

***Southern Africa
        BWA     "Botswana"
		SWZ     "Eswatini"
        NAM     "Namibia"
        ZAF     "South Africa"
        XSC     "Rest of South African Customs Union"
*               - Lesotho

        XTW     "Rest of the World"
*               - Antarctica
*               - Bouvet Island
*               - British Indian Ocean Territory
*               - French Southern Territories 
    / ;

alias(r0,reg);

sets
    TransE0(r0) "Transition Economies" /
          srb, uzb,
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



