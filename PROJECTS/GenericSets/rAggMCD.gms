$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
   name        : "%sDir%\rAggOECD.gms
   purpose     : G20 regional aggregation
   created date: 2021 spring
   created by  : Jean Chateau
   called by   : some "%iFilesDir%\map.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericSets/rAggG20_IMFversion.gms $
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

    PAK	"Pakistan"
    KAZ	"Kazakhstan"
    KGZ	"Kyrgyzstan"
    TJK	"Tajikistan"
    UZB	"Uzbekistan"
    ARM	"Armenia"
    AZE	"Azerbaijan"
    GEO	"Georgia"
    BHR	"Bahrain"
    IRN	"Iran (Islamic Republic of)"
    IRQ	"Iraq"
    JOR	"Jordan"
*    KWT	"Kuwait"
*    LBN	"Lebanon"
    OMN	"Oman"
    QAT	"Qatar"
    SAU	"Saudi Arabia"
    ARE	"United Arab Emirates"
*    DZA	"Algeria"
    EGY	"Egypt"
    MAR	"Morocco"
    TUN	"Tunisia"

    USA     "United States of America"
    EUR     "EU27 + UK + EFTA"
    CHN     "China"
    IND     "India"


*---    Group of Region/countries
    MCD	"Rest of MCD"
    REU	"Rest of Europe"
    APD	"Asia-pasific"
    AFR	"Africa"
    WHD	"Western Hemisphere"
*    ROW	"Rest of the World "

$EndIf.step1

* regional set rmuv(r)

$IfTheni.step1bis %step%=="rmuv"

 USA     "United States of America"
EUR     "EU27 + UK + EFTA"
     

$EndIf.step1bis

*------------------------------------------------------------------------------*
*                  2. Mapping Model with GTAP regions                          *
*------------------------------------------------------------------------------*

$IfThen.step2 %step%=="region_mapping"

APD.AUS
APD.NZL
APD.XOC
CHN.CHN
APD.HKG
APD.JPN
APD.KOR
APD.MNG
APD.TWN
APD.BRN
APD.KHM
APD.IDN
APD.LAO
APD.MYS
APD.PHL
APD.SGP
APD.THA
APD.VNM
APD.XEA
APD.XSE
MCD.AFG
APD.BGD
IND.IND
APD.NPL
PAK.PAK
*MCD.PAK
APD.LKA
APD.XSA
WHD.CAN
USA.USA
WHD.MEX
WHD.XNA
WHD.ARG
WHD.BOL
WHD.BRA
WHD.CHL
WHD.COL
WHD.ECU
WHD.PRY
WHD.PER
WHD.URY
WHD.VEN
WHD.XSM
WHD.CRI
WHD.GTM
WHD.HND
WHD.NIC
WHD.PAN
WHD.SLV
WHD.XCA
WHD.DOM
WHD.JAM
WHD.HTI
WHD.PRI
WHD.TTO
WHD.XCB
EUR.AUT
EUR.BEL
EUR.BGR
EUR.HRV
EUR.CYP
EUR.CZE
EUR.DNK
EUR.EST
EUR.FIN
EUR.FRA
EUR.DEU
EUR.GRC
EUR.HUN
EUR.IRL
EUR.ITA
EUR.LVA
EUR.LTU
EUR.LUX
EUR.MLT
EUR.NLD
EUR.POL
EUR.PRT
EUR.ROU
EUR.SVK
EUR.SVN
EUR.ESP
EUR.SWE
EUR.GBR
EUR.NOR
EUR.CHE
EUR.XEF
REU.ALB
REU.SRB
REU.BLR
REU.RUS
REU.UKR
REU.XEE
REU.XER
EUR.ISR
EUR.TUR

KAZ.KAZ
KGZ.KGZ
TJK.TJK
UZB.UZB
MCD.XSU
ARM.ARM
AZE.AZE
GEO.GEO
BHR.BHR
IRN.IRN
IRQ.IRQ
JOR.JOR
*KWT.KWT
*LBN.LBN
OMN.OMN
*PSE.PSE
QAT.QAT
SAU.SAU
*MCD.SYR
ARE.ARE
EGY.EGY
MAR.MAR
*DZA.DZA
MCD.DZA
TUN.TUN

*MCD.JOR
*MCD.KGZ
*MCD.TJK
*MCD.UZB
*MCD.XSU
*MCD.ARM
*MCD.AZE
*MCD.GEO
*MCD.BHR
*MCD.IRN
*MCD.IRQ
MCD.KWT
MCD.LBN
*MCD.OMN
MCD.PSE
*MCD.QAT
*MCD.SAU
*MCD.ARE

*MCD.TUN

MCD.SYR
MCD.XWS
MCD.XNF

AFR.BEN
AFR.BFA
AFR.CMR
AFR.CIV
AFR.GHA
AFR.GIN
AFR.MLI
AFR.NER
AFR.NGA
AFR.SEN
AFR.TGO
AFR.XWF
AFR.CAF
AFR.TCD
AFR.COG
AFR.COD
AFR.GNQ
AFR.GAB
AFR.XAC
AFR.COM
AFR.ETH
AFR.KEN
AFR.MDG
AFR.MWI
AFR.MUS
AFR.MOZ
AFR.RWA
AFR.SDN
AFR.TZA
AFR.UGA
AFR.ZMB
AFR.ZWE
AFR.XEC
AFR.BWA
AFR.SWZ
AFR.NAM
AFR.ZAF
AFR.XSC
AFR.XTW


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
    CAN     .Canada
    MEX     .Mexico
    KOR     .Korea
    INDO    .Indonesia
    BRAZIL  .Brazil
    (CHILE,CSAMa)   .OLA  !! pb
    (OEURa,OE5).Turkey    !! pb
     CASP       .OEURASIA
    (OETE,OEURb).OEURASIA
    (ASEAN9,OASEAN).ODA
    (ODA,OASIA)    .ODA
    (OLAM,CSAMb).(OLA,Argentina)  !! pb
    (NAFR,OAFR).OAF               !! pb
    ME      .(RESTOPEC,Saudi)     !! pb
    SAFR    .SouthAfrica
    (EUG4,EUa)  . France
    (EUG4,EUa)  . Germany
    (EUG4,EUa)  . Italy
    (EUG4,OEURc). UK
    (EU17,EUa)  . RESTEU
    (EU7,EUc)   . RESTEU

$EndIf.step3

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

*---    Ordering to match ENV-Linkages output

$IfTheni.step4 %step%=="Sort_region"

    sort1   . PAK	"Pakistan" 
    sort2   . KAZ	"Kazakhstan" 
    sort3   . KGZ	"Kyrgyzstan" 
    sort4   . TJK	"Tajikistan" 
    sort5   . UZB	"Uzbekistan" 
    sort6   . ARM	"Armenia" 
    sort7   . AZE	"Azerbaijan" 
    sort8   . GEO	"Georgia" 
    sort9   . BHR	"Bahrain" 
    sort10  . IRN	"Iran (Islamic Republic)" 
    sort11  . IRQ	"Iraq" 
    sort12  . JOR	"Jordan" 
*    sort13  . KWT	"Kuwait" 
*    sort14  . LBN	"Lebanon" 
    sort15  . OMN	"Oman" 
    sort16  . QAT	"Qatar" 
    sort17  . SAU	"Saudi Arabia" 
    sort18  . ARE	"United Arab Emirates" 
*    sort19  . DZA	"Algeria" 
    sort20  . EGY	"Egypt" 
    sort21  . MAR	"Morocco" 
    sort22  . TUN	"Tunisia" 
    sort23  . MCD	"Rest of MCD"

    sort24  .USA     "United States of America"
    sort25  .EUR     "EU27 + UK + EFTA"
    sort26  .CHN     "China"
    sort27  .IND     "India"

    sort28  . REU	"Rest of Europe" 
    sort29  . APD	"Asia-pasific" 
    sort30  . AFR	"Africa" 
    sort31  . WHD	"Western Hemisphere"
    


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
LIC.PAK	"Pakistan"
MIC.KAZ	"Kazakhstan"
LIC.KGZ	"Kyrgyzstan"
LIC.TJK	"Tajikistan"
MIC.UZB	"Uzbekistan"
LIC.ARM	"Armenia"
MIC.AZE	"Azerbaijan"
MIC.GEO	"Georgia"
HIC.BHR	"Bahrain"
MIC.IRN	"Iran"
MIC.IRQ	"Iraq"
MIC.JOR	"Jordan"
*HIC.KWT	"Kuwait"
*LIC.LBN	"Lebanon"
HIC.OMN	"Oman"
*HIC.QAT	"Qatar"
HIC.SAU	"Saudi Arabia"
HIC.ARE	"United Arab Emirates"
*MIC.DZA	"Algeria"
MIC.EGY	"Egypt"
MIC.MAR	"Morocco"
MIC.TUN	"Tunisia"
MIC.MCD	"Rest of MCD"
HIC.REU	"Rest of Europe"
MIC.APD	"Asia-pasific"
LIC.AFR	"Africa"
MIC.WHD	"Western Hemisphere"

HIC.EUR
HIC.USA
MIC.CHN
MIC.IND

$EndIf.step5

$droplocal step
