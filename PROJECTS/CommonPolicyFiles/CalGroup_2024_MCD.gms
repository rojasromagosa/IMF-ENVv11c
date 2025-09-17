*$IfTheni.mcd %GroupName%=="2024_MCD"
* Calibrating Egypt's growth rates with latest WEO projections provided by country desk
Parameter rgdppcT_EGY(tt)      "GDP real growth rates provided by country desk" ;
EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_EGY.gdx', rgdppcT_EGY ;
    rgdppcT("EGY",t) = rgdppcT_EGY(t) ;
Parameter rgdppcT_KAZ(tt)      "GDP real growth rates provided by country desk" ;
EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_KAZ.gdx', rgdppcT_KAZ ;
    rgdppcT("KAZ",t) = rgdppcT_KAZ(t) ;
Parameter rgdppcT_MAR(tt)      "GDP real growth rates provided by country desk" ;
EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_MAR.gdx', rgdppcT_MAR ;
    rgdppcT("MAR",t) = rgdppcT_MAR(t) ;

*$EndIf.mcd

*****************************************************************************************************************
* ElyMix calibration
$iftheni.elymixcal %ifElyMixCal%=="ON"

*    $$iftheni.mcd %GroupName%=="MCD"
        Parameter
        ElyMix_EGY(r,a,NGFS_sce,tt) "Electricity generation mix provided from country desk"
        ElyMix_KAZ(r,a,NGFS_sce,tt) "Electricity generation mix provided from country desk"
        ElyMix_MAR(r,a,NGFS_sce,tt) "Electricity generation mix provided from country desk"
        ElyMix_OMN(r,a,NGFS_sce,tt) "Electricity generation mix provided from NZ report"
        ;

* Upload the elymixCal data prepared in excel file: ElymixCal_EGY.xlsx
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_EGY.gdx', ElyMix_EGY ;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_KAZ.gdx', ElyMix_KAZ;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_MAR.gdx', ElyMix_MAR;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_OMN.gdx', ElyMix_OMN;

        ElyMixCal(r,a,NGFS_sce,t) $ EGY(r)= ElyMix_EGY(r,a,NGFS_sce,t) ;
        ElyMixCal(r,a,NGFS_sce,t) $ KAZ(r)= ElyMix_KAZ(r,a,NGFS_sce,t) ;
        ElyMixCal(r,a,NGFS_sce,t) $ MAR(r)= ElyMix_MAR(r,a,NGFS_sce,t) ;
        ElyMixCal(r,a,NGFS_sce,t) $ OMN(r)= ElyMix_OMN(r,a,NGFS_sce,t) ;

***New Oman
        ElyMixCal(r,a,"MidNDC",t)   $ OMN(r) = ((ElyMixCal(r,a,"CurrentPol",t) * 2) + ElyMixCal(r,a,"NDCs",t) ) / 3 ;
        ElyMixCal(r,a,"MidPoint",t) $ OMN(r) = ((ElyMixCal(r,a,"CurrentPol",t) ) + ElyMixCal(r,a,"NDCs",t) * 2) / 3 ;

*    $$endif.mcd
$endif.elymixcal

*****************************************************************************************************************
* Total GHG emission calibration 
$iftheni.emitotcal %ifEmiTotcal%=="ON"

    Parameter
        EmiTot_KAZ(r,NGFS_sce,tt) "Total emissions from country desk"
        EmiTot_EGY(r,NGFS_sce,tt) "Total emissions from country desk"
        EmiTot_MAR(r,NGFS_sce,tt) "Total emissions from country desk"        
        EmiTot_RoW(r,NGFS_sce,tt) "Total emissions from NGFSv4"        
    ;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_KAZ.gdx',  EmiTot_KAZ;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_EGY.gdx',  EmiTot_EGY;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_MAR.gdx',  EmiTot_MAR;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_OMN.gdx',  EmiTot_RoW; 
        EmiTotCal(r,NGFS_sce,t) $ EmiTot_RoW(r,NGFS_sce,t) = EmiTot_RoW(r,NGFS_sce,t) ; 
        EmiTotCal(r,NGFS_sce,t) $ KAZ(r) = EmiTot_KAZ(r,NGFS_sce,t) ; !! 
        EmiTotCal(r,NGFS_sce,t) $ EGY(r) = EmiTot_EGY(r,NGFS_sce,t) ; 
        EmiTotCal(r,NGFS_sce,t) $ MAR(r) = EmiTot_MAR(r,NGFS_sce,t) ; 

    proj_GHG_LULUCF(r,t) $ EmiTotCal(r,"CurrentPol",t) = EmiTotCal(r,"CurrentPol",t) ;

*    proj_CO2(r,t) = proj_GHG_LULUCF(r,t) * 0.75;
*    proj_GHG(r,t) = proj_GHG_LULUCF(r,t) * 0.25;

*$ontext adj no longer necessary as run in 8-solve.gms
***Adj for emitotrep so they're closer to NGFS current policies scenario
*    proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) +  50  ;
        $$iftheni.upper %BaseName%=="2024_MCD"
        proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2030)) =  proj_GHG_LULUCF(r,t) +  15  ;
        proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2035)) =  proj_GHG_LULUCF(r,t) +  10  ;
        proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2039)) =  proj_GHG_LULUCF(r,t) +  5  ;

        proj_GHG_LULUCF(r,t) $ (OMN(r) and (t.val ge 2021)) =  proj_GHG_LULUCF(r,t) -  5  ;
        proj_GHG_LULUCF(r,t) $ (OMN(r) and (t.val ge 2030)) =  proj_GHG_LULUCF(r,t) -  5  ;
        proj_GHG_LULUCF(r,t) $ (OMN(r) and (t.val ge 2035)) =  proj_GHG_LULUCF(r,t) -  5  ;

        $$endif.upper

       $$iftheni.low %BaseName%=="2024_MCDlow"
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) +  10  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2026)) =  proj_GHG_LULUCF(r,t) +  5  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2027)) =  proj_GHG_LULUCF(r,t) +  10  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2029)) =  proj_GHG_LULUCF(r,t) +  10  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2030)) =  proj_GHG_LULUCF(r,t) +  10  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2033)) =  proj_GHG_LULUCF(r,t) +  20  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2035)) =  proj_GHG_LULUCF(r,t) +  15  ;
       proj_GHG_LULUCF(r,t) $ (EGY(r) and (t.val ge 2039)) =  proj_GHG_LULUCF(r,t) +  20  ;
       $$endif.low


        proj_GHG_LULUCF(r,t) $ (MAR(r) and (t.val ge 2021)) =  proj_GHG_LULUCF(r,t) +  5  ;
        proj_GHG_LULUCF(r,t) $ (MAR(r) and (t.val ge 2028)) =  proj_GHG_LULUCF(r,t) +  8  ;
        proj_GHG_LULUCF(r,t) $ (MAR(r) and (t.val ge 2030)) =  proj_GHG_LULUCF(r,t) +  5  ;
        proj_GHG_LULUCF(r,t) $ (MAR(r) and (t.val ge 2035)) =  proj_GHG_LULUCF(r,t) +  5  ;
        proj_GHG_LULUCF(r,t) $ (MAR(r) and (t.val ge 2038)) =  proj_GHG_LULUCF(r,t) +  5  ;

        proj_GHG_LULUCF(r,t) $ (KAZ(r) and (t.val ge 2020)) =  proj_GHG_LULUCF(r,t) +  15  ;
        proj_GHG_LULUCF(r,t) $ (KAZ(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) +  7.5  ;
        proj_GHG_LULUCF(r,t) $ (KAZ(r) and (t.val ge 2030)) =  proj_GHG_LULUCF(r,t) +  5  ;
        proj_GHG_LULUCF(r,t) $ (KAZ(r) and (t.val ge 2035)) =  proj_GHG_LULUCF(r,t) +  5  ;
        proj_GHG_LULUCF(r,t) $ (KAZ(r) and (t.val ge 2038)) =  proj_GHG_LULUCF(r,t) +  5  ;

        proj_GHG_LULUCF(r,t) $ (EUR(r) and (t.val ge 2029)) =  proj_GHG_LULUCF(r,t) - 150  ;
        proj_GHG_LULUCF(r,t) $ ((CHN(r) or USA(r)) and (t.val ge 2029)) =  proj_GHG_LULUCF(r,t) - 100  ;
        proj_GHG_LULUCF(r,t) $ (APD(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) + 150  ;

        proj_GHG_LULUCF(r,t) $ (IND(r) and (t.val ge 2020)) =  proj_GHG_LULUCF(r,t) + 150  ;
        proj_GHG_LULUCF(r,t) $ (IND(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) + 200  ;
        proj_GHG_LULUCF(r,t) $ (IND(r) and (t.val ge 2029)) =  proj_GHG_LULUCF(r,t) +  75  ;

        proj_GHG_LULUCF(r,t) $ (REU(r) and (t.val ge 2020)) =  proj_GHG_LULUCF(r,t) + 150  ;
        proj_GHG_LULUCF(r,t) $ (REU(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) + 150  ;
        proj_GHG_LULUCF(r,t) $ (REU(r) and (t.val ge 2029)) =  proj_GHG_LULUCF(r,t) + 175  ;
*$offtext


$EndIf.emitotcal

****************************************************************************************************************
*HRR: calibratin savf and savg using Jan-2024 WEO data

$iftheni.weosavcal %ifWEOsavCal%=="ON"


**********************************************
$IfTheni.mcd %GroupName%=="2024_MCD"
* Calibrating Egypt's CAB and GovBal with latest WEO projections provided by country desk
Parameter 
CAB_EGY(tt)      "CAB provided by country desk" 
GBal_EGY(tt)     "Government budget balance provided by country desk" 
CAB_KAZ(tt)      "CAB provided by country desk" 
GBal_KAZ(tt)     "Government budget balance provided by country desk" 
CAB_MAR(tt)      "CAB provided by country desk" 
GBal_MAR(tt)     "Government budget balance provided by country desk" 
;
EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_EGY.gdx', CAB_EGY, GBal_EGY ;
    WEO_cab("EGY",t)    = CAB_EGY(t) ;
    WEO_gbal("EGY",t)   = GBal_EGY(t) ;
EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_KAZ.gdx', CAB_KAZ, GBal_KAZ ;
    WEO_cab("KAZ",t)    = CAB_KAZ(t) ;
    WEO_gbal("KAZ",t)   = GBal_KAZ(t) ;
EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%GroupName%/Cal_inputs_MAR.gdx', CAB_MAR, GBal_MAR ;
    WEO_cab("MAR",t)    = CAB_MAR(t) ;
    WEO_gbal("MAR",t)   = GBal_MAR(t) ;

$EndIf.mcd

**************************************************************************************************************
* Calibrating model using SAVG (Gov balance)
***Defining the savg targets
$setGlobal YrEndWEO "2029"
***Make savg after 2029 equal to last WEO value
loop(t $ (t.val gt %YrEndWEO%),
     WEO_gbal(r,t) =  WEO_gbal(r,t-1) ;
);

$IFi %DynCalMethod%=="ENVISAGE" savg.l(r,t) = WEO_gbal(r,t) / 1000;


**************************************************************************************************************
* Calibrating model using SAVF (CAB)

$iftheni.MCD %GroupName%=="2024_MCD"
***Defining the savF targets
    loop(t $ (t.val le %YrEndWEO%),
        savf_weo(r,t) = - WEO_cab(r,t) / 1000 ;
    );
** PAK does not have WEO values from 2024 to 2029
    loop(t $ ((t.val ge 2024) and (t.val le 2029)),
        savf_weo(r,t) $ PAK(r) = savf_weo(r,"2023") ;
    );
** some countries don't have values for 2029
    savf_weo(r,"2029") $ (savf_weo(r,"2029") eq 0) = savf_weo(r,"2028") ;

** extreme changes in 2022 for some countries so take 2021 values instead
    savf_weo(r,"2022") $ (AZE(r) or KGZ(r) ) = savf_weo(r,"2021") ; 
** re-estimate the residual
    WEO_cab_res(t) = -1000 * sum(r, savf_weo(r,t)) ;

***Adj. to make global residual zero (EUR/APD absorb the residual)
    savf_weo(r,t) $ EUR(r) = savf_weo(r,t) - (- (1/2) * WEO_cab_res(t)/1000) ;
    savf_weo(r,t) $ APD(r) = savf_weo(r,t) - (- (1/2) * WEO_cab_res(t)/1000) ;

$endif.MCD

loop(t $ (t.val gt %YrEndWEO%),
     savf_weo(r,t) = savf_weo(r,"%YrEndWEO%") ;
);

$endif.weosavcal