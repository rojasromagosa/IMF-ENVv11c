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

AUT     "Austria"
BLU     "Belgium & Luxembourg"
BGR     "Bulgaria"
CZE     "Czechia"
FRA     "France"
DEU     "Germany"
HUN     "Hungary"
ITA     "Italy"
NLD     "Netherlands"
POL     "Poland"
ROU     "Romania"
SVK     "Slovakia"
ESP     "Spain"
REU     "Rest of EU"

NOR     "Norway"
REF     "Rest EFTA"
RUS     "Russia"
TUR     "Turkiye"
GBR     "United Kingdom"
OEA     "Other East European & Eurasian countries"

CAN     "Canada"
USA     "United States"       
CHN     "China"
JPK     "Japan & Korea"
IND     "India"
SAU     "Saudi Arabia"

MCD     "Other MCD countries"
AFR     "Other AFR countries"
APD     "Other APD countries"
WHD     "Other WHD countries"

$EndIf.step1

* regional set rmuv(r)

$IfTheni.step1bis %step%=="rmuv"

USA     "United States of America"
AUT
BLU
BGR
CZE
FRA
DEU
HUN
ITA
NLD
POL
ROU
SVK
ESP
REU
NOR
REF
GBR
CAN
JPK

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
JPK.JPN
JPK.KOR
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
MCD.PAK
APD.LKA
APD.XSA
CAN.CAN
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
AUT.AUT
BLU.BEL
BGR.BGR
REU.HRV
REU.CYP
CZE.CZE
REU.DNK
REU.EST
REU.FIN
FRA.FRA
DEU.DEU
REU.GRC
HUN.HUN
REU.IRL
ITA.ITA
REU.LVA
REU.LTU
BLU.LUX
REU.MLT
NLD.NLD
POL.POL
REU.PRT
ROU.ROU
SVK.SVK
REU.SVN
ESP.ESP
REU.SWE
GBR.GBR
NOR.NOR
REF.CHE
REF.XEF
OEA.ALB
OEA.SRB
OEA.BLR
RUS.RUS
OEA.UKR
OEA.XEE
OEA.XER
MCD.ISR
TUR.TUR

MCD.KAZ
MCD.KGZ
MCD.TJK
MCD.UZB
MCD.XSU
MCD.ARM
MCD.AZE
MCD.GEO
MCD.BHR
MCD.IRN
MCD.IRQ
MCD.JOR
MCD.KWT
MCD.LBN
MCD.OMN
MCD.PSE
MCD.QAT
SAU.SAU
MCD.SYR
MCD.ARE
MCD.EGY
MCD.MAR
MCD.DZA
MCD.TUN
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

***hrr    US      .usa
***hrr    CHINA   .chn
***hrr    INDIA   .ind
***hrr    RUS     .rus
***hrr    JPN     .jpn
***hrr    AUNZ    .aus !! pb if %RegionAgg%== "Small"
***hrr    CAN     .Canada
***hrr    MEX     .Mexico
***hrr    KOR     .Korea
***hrr    INDO    .Indonesia
***hrr    BRAZIL  .Brazil
***hrr    (CHILE,CSAMa)   .OLA  !! pb
***hrr    (OEURa,OE5).Turkey    !! pb
***hrr     CASP       .OEURASIA
***hrr    (OETE,OEURb).OEURASIA
***hrr    (ASEAN9,OASEAN).ODA
***hrr    (ODA,OASIA)    .ODA
***hrr    (OLAM,CSAMb).(OLA,Argentina)  !! pb
***hrr    (NAFR,OAFR).OAF               !! pb
***hrr    ME      .(RESTOPEC,Saudi)     !! pb
***hrr    SAFR    .SouthAfrica
***hrr    (EUG4,EUa)  . France
***hrr    (EUG4,EUa)  . Germany
***hrr    (EUG4,EUa)  . Italy
***hrr    (EUG4,OEURc). UK
***hrr    (EU17,EUa)  . RESTEU
***hrr    (EU7,EUc)   . RESTEU

$EndIf.step3

*------------------------------------------------------------------------------*
*                          4. Ordering regional set                            *
*------------------------------------------------------------------------------*

*---    Ordering to match ENV-Linkages output

$IfTheni.step4 %step%=="Sort_region"

    sort1   . AUT     "Austria"
    sort2   . BLU     "Belgium & Luxembourg"
    sort3   . BGR     "Bulgaria"
    sort4   . CZE     "Czechia"
    sort5   . FRA     "France"
    sort6   . DEU     "Germany"
    sort7   . HUN     "Hungary"
    sort8   . ITA     "Italy"
    sort9   . NLD     "Netherlands"
    sort10  . POL     "Poland"
    sort11  . ROU     "Romania"
    sort12  . SVK     "Slovakia"
    sort13  . ESP     "Spain"
    sort14  . REU     "Rest of EU"
    sort15  . NOR     "Norway"
    sort16  . REF     "Rest EFTA"
    sort17  . RUS     "Russia"
    sort18  . TUR     "Turkiye"
    sort19  . GBR     "United Kingdom"
    sort20  . OEA     "Other East European & Eurasian countries"
    sort21  . CAN     "Canada"
    sort22  . USA     "United States"   
    sort23  . CHN     "China"
    sort24  . JPK     "Japan & Korea"
    sort25  . IND     "India"
    sort26  . SAU     "Saudi Arabia"
    sort27  . MCD     "Other MCD countries"
    sort28  . AFR     "Other AFR countries"
    sort29  . APD     "Other APD countries"
    sort30  . WHD     "Other WHD countries"

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
HIC. AUT     "Austria"
HIC. BLU     "Belgium & Luxembourg"
HIC. BGR     "Bulgaria"
HIC. CZE     "Czechia"
HIC. FRA     "France"
HIC. DEU     "Germany"
HIC. HUN     "Hungary"
HIC. ITA     "Italy"
HIC. NLD     "Netherlands"
HIC. POL     "Poland"
HIC. ROU     "Romania"
HIC. SVK     "Slovakia"
HIC. ESP     "Spain"
HIC. REU     "Rest of EU"
HIC. NOR     "Norway"
HIC. REF     "Rest EFTA"
OILP. RUS     "Russia"
MIC. TUR     "Turkiye"
HIC. GBR     "United Kingdom"
MIC. OEA     "Other East European & Eurasian countries"
HIC. CAN     "Canada"
HIC. USA     "United States"   
MIC. CHN     "China"
HIC. JPK     "Japan & Korea"
LIC. IND     "India"
HIC. SAU     "Saudi Arabia"
MIC. MCD     "Other MCD countries"
LIC. AFR     "Other AFR countries"
MIC. APD     "Other APD countries"
MIC. WHD     "Other WHD countries"

$EndIf.step5

$droplocal step
