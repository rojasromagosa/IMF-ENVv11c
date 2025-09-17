*****************************************************************************************************************
*****************************************************************************************************************
*  NGFS data for CCUS and LULUCF and EVs
*****************************************************************************************************************
*****************************************************************************************************************

*Get LULUCF emission projections (changes w.r.t. baseline) from NGFS

***************************************************************************************************************
* LULUCF emission changes taken from GCAM 6.0 NGFS, Emissions|Kyoto Gases|AFOLU
Set
gcam "GCAM model regions" / Africa_Eastern, Africa_Northern, Africa_Southern, Africa_Western, Argentina,
                            Australia_NZ, Brazil, Canada, Central_America_Caribbean, Central_Asia, China,
                            Colombia, EU_12, EU_15, Europe_Eastern, Europe_Non_EU, EFTA, India, Indonesia,
                            Japan, Mexico, Middle_East, Pakistan, Russia, South_Africa, South_America_Northern,
                            South_America_Southern, South_Asia, South_Korea, Southeast_Asia, Taiwan, USA /
mapgcam(gcam,r) "Mapping from GCAM regions to model regions" /
Africa_Eastern.AFR
Africa_Northern.MCD
Africa_Southern.AFR
Africa_Western.AFR
Argentina.WHD
Australia_NZ.APD
Brazil.WHD
Canada.WHD
Central_America_Caribbean.WHD
Central_Asia.REU
China.CHN
Colombia.WHD
EU_12.EUR
EU_15.EUR
Europe_Eastern.REU
Europe_Non_EU.REU
EFTA.EUR
India.IND
Indonesia.APD
Japan.APD
Mexico.WHD
Middle_East.MCD
Pakistan.PAK
Russia.REU
South_Africa.AFR
South_America_Northern.WHD
South_Asia.APD
South_Korea.APD
Southeast_Asia.APD
Taiwan.APD
USA.USA
/

G20reg "G20 agg regions" /  ARG, AUS, BRA, CAN, CHN, DEU, FRA, GBR, JPN, IDN, IND, ITA, KOR, MEX, 
                            OAF, ODA, OEA, OLA, REU, ROP, RUS, SAU, TUR, USA, ZAF /
mapg20mcd(G20reg,r) "Mapping from G20 agg to MCD agg" /
AUS.APD
BRA.WHD
CAN.WHD
CHN.CHN
DEU.EUR
FRA.EUR
GBR.EUR
JPN.APD
IDN.APD
IND.IND
ITA.EUR
KOR.APD
MEX.WHD
OAF.AFR
ODA.APD
OEA.REU
OLA.WHD
REU.EUR
ROP.MCD
RUS.REU
SAU.MCD
TUR.REU
USA.USA
ZAF.AFR
/
;

PARAMETER
    LULUCF_NGFS(NGFS_sce,gcam,tt)   "LULUCF data from NGFS: MT CO2-eq"
    LULUCF_NGFS_agg(r,NGFS_sce,tt)  "LULUCF MT CO2 aggregated to model regions"
    LULUCF_perYear(r,NGFS_sce)      "LULUCF MT CO2 reductions by year from 2025 to 2040"
    tempLU1(r,NGFS_sce)
    EVpar(r,tt)                     "EV penetration parameter"

***********************************************************************
*CCUS
    CCUS_ratio2(r,NGFS_sce,tt) "Model reg: CCUS data from NGFS: ratio of CCUS in as a share of 2020 emissions"
    CCUS_ratio(G20reg,NGFS_sce,tt)       " G20: CCUS data from NGFS: ratio of CCUS in as a share of 2020 emissions"
    CCUSperYear(r,NGFS_sce,tt)      "CCUS MT CO2 reductions by year from 2030 to 2040"
    CCUS_totcost(r,NGFS_sce,tt)      "Total CCUS costs in million US$"
    CCUS_check(r,NGFS_sce,tt)
    CCUS_check2(ra,tt)
;

    CCUS_check2(ra,tt) = 0 ;
    CCUSperYear(r,NGFS_sce,tt) = 0 ; 
*** Broad CCUS costs provided by Sha Yu (MCM)
parameter CCUS_unitcost(r)  "CCUS costs in US$ per CO2 ton" /
MCD     100,
USA     87,
EUR     130,
CHN     80,
IND     94,
REU     100,
APD     100,
AFR     100,
WHD     100
/

*** GFCF in million US$ (2023 or 2022)  taken from WDI (WDI_GFCF_currentUS$.xls)
GFCF(r)  "GFCF in million US$ per CO2 ton" /
MCD	1050656.0,
USA	5476099.0,
EUR	5042937.5,
CHN	7493287.2,
IND	1112167.3,
REU	1018464.0,
APD	3968396.1,
AFR	 485583.9,
WHD	1905226.0,
OMN 22594.2

/;


EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/LULUCF_NGFS.gdx',  LULUCF_NGFS;

    LULUCF_NGFS_agg(r,NGFS_sce,t) = sum(gcam $ mapgcam(gcam,r),    LULUCF_NGFS(NGFS_sce,gcam,t));
    
    tempLU1(r,NGFS_sce) = LULUCF_NGFS_agg(r,NGFS_sce,"2040") - LULUCF_NGFS_agg(r,NGFS_sce,"2020") ; 

    LULUCF_perYear(r,NGFS_sce)  =  eScale * (tempLU1(r,NGFS_sce) - tempLU1(r,"CurrentPol") ) / (2040 - 2025) ;

* EQUATE all MCD countries to MCD agg
    LULUCF_perYear(r,NGFS_sce) $ (allMCD(r)) = LULUCF_perYear("MCD",NGFS_sce)  ; 
******************************************************************************************************************

***************************************************************************************************************
*Get EV penetration projections from NGFS

Parameter
    EV_ratio(r,NGFS_sce,tt)       "EV penetration data from NGFS: Percentage of EV in total transport"
;  

***this has the G20 agg, need to move it to MCD agg
*** EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/EV_ratio.gdx',  EV_ratio;

***************************************************************************************************************
*Uploading CCUS data from NGFS: ratio of CCUS in as a share of 2020 emissions


EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/CCUS_ratio_NGFS.gdx',  CCUS_ratio;

CCUS_ratio2(r,NGFS_sce,t) = sum(G20reg $ mapg20mcd(G20reg,r), CCUS_ratio(G20reg,NGFS_sce,t)) ;

*** Simple average adj to ratios of new agg regions
CCUS_ratio2(r,NGFS_sce,t) $ (EUR(r) or APD(r))= CCUS_ratio2(r,NGFS_sce,t) / 5 ;
CCUS_ratio2(r,NGFS_sce,t) $ WHD(r) = CCUS_ratio2(r,NGFS_sce,t) / 4 ;
CCUS_ratio2(r,NGFS_sce,t) $ AFR(r) = CCUS_ratio2(r,NGFS_sce,t) / 2 ;

CCUS_ratio2(r,NGFS_sce,t) $ OMN(r) = CCUS_ratio2("MCD",NGFS_sce,t) * 2 ;

$ifi %SimName%=="SimNZrow" CCUS_ratio2(r,NGFS_sce,t) $ OMN(r) = 0 ;

***Reducing CCUS ratios for some countries
CCUS_ratio2(r,NGFS_sce,t) $ (CHN(r) )  = CCUS_ratio2(r,NGFS_sce,t) * 0 ;
CCUS_ratio2(r,NGFS_sce,t) $ ( USA(r)  )= CCUS_ratio2(r,NGFS_sce,t) * 0.2 ;
CCUS_ratio2(r,NGFS_sce,t) $ ( EUR(r)   )= CCUS_ratio2(r,NGFS_sce,t) * 0.9 ; !! not or REU(r) or IND(r) or APD(r)
CCUS_ratio2(r,NGFS_sce,t) $ ( AFR(r)  or WHD(r) )= CCUS_ratio2(r,NGFS_sce,t) * 1 ;
CCUS_ratio2(r,NGFS_sce,t) $ REU(r) = CCUS_ratio2(r,NGFS_sce,t) * 1;

* Calculating CCUS MT CO2 reductions by year from 2030 to 2040   

* First calculate total emitot reducitons by 2040 based on NGFS (not model baseline) 2020 emitot
    CCUSperYear(r,NGFS_sce,t) = 0 ; 
    CCUSperYear(r,NGFS_sce,"2040")  = EmiTotCal(r,"CurrentPol","2020") *  CCUS_ratio2(r,NGFS_sce,"2040") ;

    m_InterpLinear(CCUSperYear,'r,NGFS_sce',t,2024,2040) ;

LOOP(t $ (t.val ge 2025),
    CCUSperYear(r,NGFS_sce,t) = CCUSperYear(r,NGFS_sce,t) * eScale ;
    CCUS_totcost(r,NGFS_sce,t) = CCUS_unitcost(r)  * ( CCUSperYear(r,NGFS_sce,t) / escale );
    rworkT(r,t) $ rgdpmp_bau(r,t-1) = rgdpmp_bau(r,t)/rgdpmp_bau(r,t-1)  ;

    InvLoss(r,t) $ (rworkT(r,t) and CCUS_totcost(r,"NetZero2050",t)) 
                = 1 - (CCUS_totcost(r,"NetZero2050",t) / (GFCF(r) * rworkT(r,t)));
);
