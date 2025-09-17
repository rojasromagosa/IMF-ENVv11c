$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model version 1.0 - Aggregation & Calibration procedures
   name        :  %SetsDir%\setIEA\05-mapping_regions_GTAP_to_WEO.gms"
   purpose     :  mapping GTAP regions to IEA WEO regions: mapr0_rweo(r0,r_weo)
   created date:  spring 2022
   created by  : Jean Chateau
   called by   :
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setIEA/05-mapping_regions_GTAP_to_WEO.gms $
   last changed revision: $Rev: 500 $
   last changed date    : $Date:: 2024-02-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
* Adjusted for GTAP 10.1, 11b
$OffText

$iF NOT SET IeaWeoVer $SetGlobal IeaWeoVer "2021"

$IF %GTAP_ver%=="92"   $SETLOCAL XSU "XSU"
$IF %GTAP_ver%=="10a"  $SETLOCAL XSU "tjk,XSU"
$IF %GTAP_ver%=="10.1" $SETLOCAL XSU "tjk,XSU"
$IF %GTAP_ver%=="11b"  $SETLOCAL XSU "tjk,XSU,uzb"

set mapr0_rweo(r0,r_weo) "mapping GTAP regions to WEO regions" /

* XEF = Iceland, Liechtenstein (not in OE5)

    $$IFe %IeaWeoVer%<2020  (TUR,CHE,NOR,XEF,ISR).OE5
    $$IFe %IeaWeoVer%>=2020 (TUR,CHE,NOR,XEF,ISR).OEURa

    $$IFe %IeaWeoVer%<2020  (DEU,FRA,ITA,GBR).EUG4
    $$IFe %IeaWeoVer%>=2020 (DEU,FRA,ITA).EUa
    $$IFe %IeaWeoVer%>=2020 GBR.OEURc
    $$IFe %IeaWeoVer%<2020  (AUT,BEL,DNK,CZE,ESP,FIN,GRC,HUN,IRL,LUX,NLD,SVK,SWE,POL,PRT,EST,SVN).EU17
    $$IFe %IeaWeoVer%>=2020 (AUT,BEL,DNK,CZE,ESP,FIN,GRC,HUN,IRL,LUX,NLD,SVK,SWE,POL,PRT,EST,SVN,LVA,LTU).EUb
    $$IFe %IeaWeoVer%<2020  (BGR,HRV,CYP,LVA,LTU,MLT,ROU).EU7
    $$IFe %IeaWeoVer%>=2020 (BGR,HRV,CYP,MLT,ROU).EUc
    $$IFe %IeaWeoVer%<2020  (ALB,BLR,UKR,XEE,XER).OETE
    $$IFe %IeaWeoVer%>=2020 (ALB,BLR,UKR,XEE,XER).OEURb

    $$Ifi %GTAP_ver%=="10.1" $$IFe %IeaWeoVer%<2020  SRB.OETE
    $$Ifi %GTAP_ver%=="10.1" $$IFe %IeaWeoVer%>=2020 SRB.OEURb
    $$Ifi %GTAP_ver%=="11b"  $$IFe %IeaWeoVer%<2020  SRB.OETE
    $$Ifi %GTAP_ver%=="11b"  $$IFe %IeaWeoVer%>=2020 SRB.OEURb

    RUS.RUS

    (AZE,KAZ,ARM,GEO,KGZ,%XSU%).CASP

*   Asia and Pacific

    (AUS,NZL).AUNZ

    (CHN,HKG).CHINA
    IND.INDIA
    IDN.INDO
    JPN.JPN
    KOR.KOR

* Memo: XSE = Myanmar + Timor Leste (not in asean)

    $$IFe %IeaWeoVer%<2020  (BRN,KHM,LAO,MYS,XSE,PHL,SGP,THA,VNM).ASEAN9
    $$IFe %IeaWeoVer%>=2020 (BRN,KHM,LAO,MYS,XSE,PHL,SGP,THA,VNM).OASEAN
    $$IFe %IeaWeoVer%<2020  (BGD,PAK,LKA,TWN,XEA,XOC,XSA,NPL,MNG).ODA
    $$IFe %IeaWeoVer%>=2020 (BGD,PAK,LKA,TWN,XEA,XOC,XSA,NPL,MNG).OASIA

*   America

    USA.US
    CAN.CAN
    MEX.MEX

    BRA.BRAZIL
    $$IFe %IeaWeoVer%<2020  (ARG,BOL,COL,CRI,ECU,GTM,NIC,PAN,PER,PRY,URY,VEN,XCA,XCB,XNA,XSM,HND,SLV,DOM,JAM,PRI,TTO).OLAM
    $$IFe %IeaWeoVer%>=2020 (ARG,BOL,    CRI,ECU,GTM,NIC,PAN,PER,PRY,URY,VEN,XCA,XCB,XNA,XSM,HND,SLV,DOM,JAM,PRI,TTO).CSAMb
    $$IFe %IeaWeoVer%<2020   CHL.CHILE
    $$IFe %IeaWeoVer%>=2020 (CHL,COL).CSAMa

*   Africa (Memo: XNF = Algeria, Libya, Western Sahara)

    (MAR,TUN,EGY,XNF).NAFR
	$$Ifi %GTAP_ver%=="11b"  dza.nafr

    (ETH,BWA,MDG,MOZ,MUS,MWI,NGA,SEN,TZA,UGA,XAC,XEC,XSC,XWF,ZMB,ZWE,NAM,KEN,CMR,CIV,GHA,BEN,BFA,GIN,TGO,RWA).OAFR
    $$Ifi %GTAP_ver%=="10.1" SDN.OAFR
    $$Ifi NOT %GTAP_ver%=="11b" XCF.OAFR
	$$Ifi %GTAP_ver%=="11b"  (SDN,MLI,NER,CAF,TCD,GNQ,GAB,COG,COD,COM,SWZ).OAFR


    ZAF.SAFR

*   Middle East

    (KWT,OMN,QAT,SAU,ARE,JOR,BHR,IRN,XWS).ME
    $$Ifi %GTAP_ver%=="10.1" (LBN,SYR,IRQ,PSE).ME
	$$Ifi %GTAP_ver%=="11b"  (LBN,SYR,IRQ,PSE).ME

* #Rev458 [2023-10-13] remove Aggregates (caduc)

/;

$DROPLOCAL XSU




