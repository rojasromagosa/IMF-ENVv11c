$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] project V.1. - Data aggregation procedure
   name        :  %SetsDir%\setIEA\05-mapping_regions_GTAP_to_IEA.gms"
   purpose     :  mapping GTAP regions to IEA EEB regions:
                  -->  map_r0_rieaeeb(r0,r_IEA_EEB)
   created date: spring 2022
   created by  : Jean Chateau
   called by   : - "ENV-SmallDev\Jean\DataEco\OECD\dotStat\Export_IEA_DotStat_Data.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setIEA/05-mapping_regions_GTAP_to_IEA.gms $
   last changed revision: $Rev: 500 $
   last changed date    : $Date:: 2024-02-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Adjusted for GTAP V10.1, V11b

	GTAP countries not covered by IEA:
	-	CAF (GTAP11) or XCF (before) "Central African Republic"

	- %GTAP_ver%=="11b"  com "Comoros"
	- XTW
	- XSC     "Rest of South African Customs Union"
        - Lesotho
        - Swaziland
		$$IFi %GTAP_ver%=="11b"	swz "Eswatini"
	- mwi Malawi

$OffText

SET map_r0_rieaeeb(r0,r_IEA_EEB) "Mapping GTAP to IEA regions" /

ALB.(ALB,"Albania")                     ' Albania '
ARE.(ARE,"United Arab Emirates")        ' United Arab Emirates '
ARG.(ARG,"Argentina")                   ' Argentina '
ARM.(ARM,"Armenia")                     ' Armenia '
AUS.(AUS,"Australia")                   ' Australia '
AUT.(AUT,"Austria")                     ' Austria '
AZE.(AZE,"Azerbaijan")                  ' Azerbaijan '
BEL.(BEL,"Belgium")                     ' Belgium '
BEN.(BEN,"Benin")                       ' Benin '
BGD.(BGD,"Bangladesh")                  ' Bangladesh '
BGR.(BGR,"Bulgaria")                    ' Bulgaria '
BHR.(BHR,"Bahrain")                     ' Bahrain '
BLR.(BLR,"Belarus")                     ' Belarus '
BOL.(BOL,"Bolivia","Plurinational State of Bolivia")  ' Bolivia '
BRA.(BRA,"Brazil")                      ' Brazil '
BRN.(BRN,"Brunei Darussalam",Brunei)    ' Brunei Darussalam '
BWA.(BWA,"Botswana")                    ' Botswana '
CAN.(CAN,"Canada")                      ' Canada '
CHE.(CHE,"Switzerland")                 ' Switzerland '
CHL.(CHL,"Chile")                       ' Chile '
CHN.(CHN,"People' Republic of China","People's Republic of China")   ' People Republic of China '
*CIV.(CIV,"Côte d'Ivoire")               ' Cote d Ivoire '
CIV.CIV               					' Cote d Ivoire '
CMR.(CMR,"Cameroon")                    ' Cameroon '
COL.(COL,"Colombia")                    ' Colombia '
CRI.(CRI,"Costa Rica")                  ' Costa Rica '
CYP.(CYP,"Cyprus")                      ' Cyprus '
CZE.(CZE,"Czech Republic")              ' Czech Republic '
DEU.(DEU,"Germany")                     ' Germany '
DNK.(DNK,"Denmark")                     ' Denmark '
DOM.(DOM,"Dominican Republic")          ' Dominican Republic '
ECU.(ECU,"Ecuador")                     ' Ecuador '
EGY.(EGY,"Egypt")                       ' Egypt '
ESP.(ESP,"Spain")                       ' Spain '
EST.(EST,"Estonia")                     ' Estonia '
ETH.(ETH,"Ethiopia")                    ' Ethiopia '
FIN.(FIN,"Finland")                     ' Finland '
FRA.(FRA,"France")                      ' France '
GBR.(GBR,"United Kingdom")              ' United Kingdom '
GEO.(GEO,"Georgia")                     ' Georgia '
GHA.(GHA,"Ghana")                       ' Ghana '
GRC.(GRC,"Greece")                      ' Greece '
GTM.(GTM,"Guatemala")                   ' Guatemala '
HKG.(HKG,"Hong Kong (China)","Hong Kong, China")       ' Hong Kong, China '
HND.(HND,"Honduras")                    ' Honduras '
HRV.(HRV,"Croatia")                     ' Croatia '
HUN.(HUN,"Hungary")                     ' Hungary '
IDN.(IDN,"Indonesia")                   ' Indonesia '
IND.(IND,"India")                       ' India '
IRL.(IRL,"Ireland")                     ' Ireland '
IRN.(IRN,"Islamic Republic of Iran")    ' Islamic Republic of Iran '
ISR.(ISR,"Israel")                      ' Israel '
ITA.(ITA,"Italy")                       ' Italy '
JAM.(JAM,"Jamaica")                     ' Jamaica '
JOR.(JOR,"Jordan")                      ' Jordan '
JPN.(JPN,"Japan")                       ' Japan '
KAZ.(KAZ,"Kazakhstan")                  ' Kazakhstan '
KEN.(KEN,"Kenya")                       ' Kenya '
KGZ.(KGZ,"Kyrgyzstan")                  ' Kyrgyzstan '
KHM.(KHM,"Cambodia")                    ' Cambodia '
KOR.(KOR,"Korea")                       ' Korea '
KWT.(KWT,"Kuwait")                      ' Kuwait '
LKA.(LKA,"Sri Lanka")                   ' Sri Lanka '
LTU.(LTU,"Lithuania")                   ' Lithuania '
LUX.(LUX,"Luxembourg")                  ' Luxembourg '
LVA.(LVA,"Latvia")                      ' Latvia '
MAR.(MAR,"Morocco")                     ' Morocco '
MEX.(MEX,"Mexico")                      ' Mexico '
MLT.(MLT,"Malta")                       ' Malta '
MNG.(MNG,"Mongolia")                    ' Mongolia '
MOZ.(MOZ,"Mozambique")                  ' Mozambique '
MUS.("Mauritius")                       ' Mauritius'
MYS.(MYS,"Malaysia")                    ' Malaysia '
NAM.(NAM,"Namibia")                     ' Namibia '
NGA.(NGA,"Nigeria")                     ' Nigeria '
NIC.(NIC,"Nicaragua")                   ' Nicaragua '
NLD.(NLD,"Netherlands")                 ' Netherlands '
NOR.(NOR,"Norway")                      ' Norway '
NPL.(NPL,"Nepal")                       ' Nepal '
NZL.(NZL,"New Zealand")                 ' New Zealand '
OMN.(OMN,"Oman")                        ' Oman '
PAK.(PAK,"Pakistan")                    ' Pakistan '
PAN.(PAN,"Panama")                      ' Panama '
PER.(PER,"Peru")                        ' Peru '
PHL.(PHL,"Philippines")                 ' Philippines '
POL.(POL,"Poland")                      ' Poland '
PRT.(PRT,"Portugal")                    ' Portugal '
PRY.(PRY,"Paraguay")                    ' Paraguay '
QAT.(QAT,"Qatar")                       ' Qatar '
ROU.(ROU,"Romania")                     ' Romania '
RUS.(RUS,"Russian Federation")          ' Russian Federation '
SAU.(SAU,"Saudi Arabia")                ' Saudi Arabia '
SEN.(SEN,"Senegal")                     ' Senegal '
SGP.(SGP,"Singapore")                   ' Singapore '
SLV.(SLV,"El Salvador")                 ' El Salvador '
SVK.(SVK,"Slovak Republic")             ' Slovak Republic '
SVN.(SVN,"Slovenia")                    ' Slovenia '
SWE.(SWE,"Sweden")                      ' Sweden '
TGO.(TGO,"Togo")                        ' Togo '
THA.(THA,"Thailand")                    ' Thailand '
TTO.(TTO,"Trinidad and Tobago")         ' Trinidad and Tobago '
TUN.(TUN,"Tunisia")                     ' Tunisia '
TUR.(TUR,"Turkey")                      ' Turkey '
TWN.(TWN,"Chinese Taipei")              ' Chinese Taipei '
TZA.(TZA,"Tanzania","United Republic of Tanzania")  ' United Republic of Tanzania '
UKR.(UKR,"Ukraine")                     ' Ukraine '
URY.(URY,"Uruguay")                     ' Uruguay '
USA.(USA,"United States")               ' United States '
VEN.(VEN,"Venezuela","Bolivarian Republic of Venezuela")  ' Venezuela '
VNM.(VNM,"Viet Nam")                    ' Vietnam '
ZAF.(ZAF,"South Africa")                ' South Africa '
ZMB.(ZMB,"Zambia")                      ' Zambia '
ZWE.(ZWE,"Zimbabwe")                    ' Zimbabwe '
BFA.(MBURKINAFA,"Memo: Burkina Faso",BFA)  	   'Burkina Faso'
UGA.(UGA,"Uganda",MUGANDA)					   'Uganda'
RWA.(RWA,MRWANDA,"Rwanda")					   'Rwanda'
MDG.(MMADAGASCA,MDG,"Madagascar")			   'Madagascar'

* "South Central Africa" (manque Sao Tome)
XAC.(AGO,"Angola")                      'Angola'

$$Ifi NOT %GTAP_ver%=="11b" XAC.(COD,"Democratic Republic of the Congo")  'South Central Africa'
$$Ifi     %GTAP_ver%=="11b" COD.(COD,"Democratic Republic of the Congo")  'Democratic Republic of the Congo'

XCB.(CUB,"Cuba")   				 'Cuba'
XCB.(ANT,"Netherlands Antilles") 'Netherlands Antilles'
XCB.CUW
*XCB.(CUW,'Curaçao','Curaçao/Netherlands Antilles')

$$Ifi NOT %GTAP_ver%=="11b"  XCB.(HTI,"Haiti")  'Haiti'
$$Ifi     %GTAP_ver%=="11b"  HTI.(HTI,"Haiti")  'Haiti'

* XCF "Central Africa"

$Iftheni %GTAP_ver%=="11b"

	COG.(COG,"Congo","Republic of the Congo")  'Congo'
	GAB.(GAB,"Gabon")						   'Gabon'
	TCD.(MCHAD,"Memo: Chad",TCD,"Chad")		   'Chad'
	GNQ.(MEQGUINEA,GNQ,"Equatorial Guinea")	   'Equatorial Guinea'

$Else

	XCF.(COG,"Congo","Republic of the Congo")  'Central Africa: Congo'
	XCF.(GAB,"Gabon")			 			   'Central Africa: gabon'
	XCF.(MCHAD,"Memo: Chad",TCD,"Chad")		   'Central Africa: Chad'
	XCF.(MEQGUINEA,GNQ,"Equatorial Guinea")	   'Central Africa: Equatorial Guinea'

$Endif

$$IFi 	  %GTAP_ver%=="11b"	swz.(SWZ,"Kingdom of Eswatini") "Eswatini"
$$IFi NOT %GTAP_ver%=="11b"	XSC.(SWZ,"Kingdom of Eswatini") "Eswatini"

* Manque Macau
XEA.(PRK,"Dem. People's Republic of Korea","Democratic People's Republic of Korea") ' Korea, DPR '

* Manque Burundi, Djibouti, Mayotte (FRA), Seychelles,Somalia
XEC.(ERI,"Eritrea")                     ' Eritrea '

XEE.(MDA,"Moldova")                     ' Republic of Moldova '

XEF.(ISL,"Iceland")                     'Iceland'

XER.(BIH,"Bosnia and Herzegovina",Bosnia) 		'Bosnia and Herzegovina'
XER.(GIB,"Gibraltar")                           'Gibraltar'
XER.(MKD,"FYR of Macedonia","North Macedonia")  'North Macedonia'

$$Ifi NOT %GTAP_ver%=="10.1" $Ifi NOT %GTAP_ver%=="11b" XER.(SRB,"Serbia") "Rest of Europe: Serbia"
$$Ifi     %GTAP_ver%=="10.1" SRB.(SRB,"Serbia") 'Serbia'
$$Ifi     %GTAP_ver%=="11b"  SRB.(SRB,"Serbia") 'Serbia'

XER.(KSV,"Kosovo")                      ' Kosovo '
XER.(MNE,"Montenegro")                  ' Montenegro '

* Miss Western Sahara in XNF

XNF.(LBY,"Libya")                       'Libya'

$$Ifi NOT %GTAP_ver%=="11b" XNF.(DZA,"Algeria") 'Algeria'
$$Ifi     %GTAP_ver%=="11b" DZA.(DZA,"Algeria") 'Algeria'

* manque Timor Leste for XSE
XSE.(MMR,"Myanmar")                     ' Myanmar '

XSU.(TKM,"Turkmenistan")                			'Turkmenistan'
$IFi     %GTAP_ver%=="11b" UZB.(UZB,"Uzbekistan")  	'Uzbekistan'
$IFi NOT %GTAP_ver%=="11b" XSU.(UZB,"Uzbekistan")  	'Uzbekistan'
$IFi     %GTAP_ver%=="92"  XSU.(TJK,"Tajikistan") 	'Tajikistan'
$IFi NOT %GTAP_ver%=="92"  TJK.(TJK,"Tajikistan")	'Tajikistan'

*	XWS     "Rest of Western Asia"

XWS.(YEM,"Yemen")                       ' Yemen '

$Iftheni %GTAP_ver%=="10.1"

    IRQ.(IRQ,"Iraq")                        'Iraq'
    LBN.(LBN,"Lebanon")                     'Lebanon'
    SYR.(SYR,"Syrian Arab Republic")        'Syrian Arab Republic'
    PSE.(MPALESTINE,"Memo: Palestinian Authority",PSE)  'West Bank and Gaza'

$Elseifi %GTAP_ver%=="11b"

    IRQ.(IRQ,"Iraq")                        			'Iraq'
    LBN.(LBN,"Lebanon")                     			'Lebanon'
    SYR.(SYR,"Syrian Arab Republic")        			'Syrian Arab Republic'
    PSE.(MPALESTINE,"Memo: Palestinian Authority",PSE)  'West Bank and Gaza'

$Else

    XWS.(IRQ,"Iraq")                        			'Iraq'
    XWS.(LBN,"Lebanon")                     			'Lebanon'
    XWS.(SYR,"Syrian Arab Republic")        			'Syrian Arab Republic'
    XWS.(MPALESTINE,"Memo: Palestinian Authority",PSE)  'West Bank and Gaza'

$Endif

XNA.(GREENLAND,"Memo: Greenland")       'Memo: Greenland'

XEC.(SSD,"South Sudan")                         'South Sudan'
$$Ifi NOT %GTAP_ver%=="10.1" $Ifi NOT %GTAP_ver%=="11b" XEC.(SDN,"Sudan")  'Rest of Eastern Africa'
$$Ifi     %GTAP_ver%=="10.1" SDN.(SDN,"Sudan")  'Sudan'
$$Ifi     %GTAP_ver%=="11b"  SDN.(SDN,"Sudan")  'Sudan'

XSM.(SUR,"Suriname")                    	'Suriname '

*	XWF: "Rest of Western Africa"

$$Ifi NOT %GTAP_ver%=="11b" XWF.(MALI,"Memo: Mali") 'Rest of Western Africa'
$$Ifi     %GTAP_ver%=="11b" MLI.(MALI,"Memo: Mali") 'Mali'
$$Ifi NOT %GTAP_ver%=="11b" XWF.(NER,"Niger")       'Rest of Western Africa'
$$Ifi     %GTAP_ver%=="11b" NER.(NER,"Niger")		'Niger'
XWF.(MMAURITANI,MRT,"Memo: Mauritania")		'Rest of Western Africa'

* This is incorrect in volume to allocate rest of the group here
XWF.(OTHERAFRIC,"Other Africa")            ' Rest of Western Africa'

XCB.(OTHERLATIN,"Other non-OECD Americas") ' Other Non-OECD Americas '
XSA.(OTHERASIA,"Other Asia")               ' Other Asia '

$$Ifi %GTAP_ver%=="11b" AFG.(OTHERASIA,"Other Asia")

/;
