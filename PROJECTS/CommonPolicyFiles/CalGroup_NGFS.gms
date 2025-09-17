*****************************************************************************************************************
* ElyMix calibration using NGFS data

$iftheni.elymixcal %ifElyMixCal%=="ON"


    Parameters
    x_nocal(r,a,i,tt)    "x Production without NGFS ElyMix calibration"
    x0_nocal(r,a,i,tt)   "x0 Production without NGFS ElyMix calibration"
    xt_nocal(r,tt)       "Total production (x0*x) of electricity without NGFS ElyMix calibration"
    ;

*Retrieve total electricity supply (x0*x.l) from Baseline without NGFS elymix calibration
* we could use gwhr from Sat.gdx, but we need a time series so we use an old baseline.gdx file without BaseDataAdj nor NGFS calibration
    EXECUTE_LOADDC '%iniEly%', x0_nocal=x0, x_nocal=x.l ;
    xt_nocal(r,t) = sum(elyantd, (x0_nocal(r,elyantd,"ely-c","2017") * x_nocal(r,elyantd,"ely-c",t))) ;

***HRR: cannot use LOADDC because it creates domain errors when elements have non-alphabetic symbols: ()/=
* EXECUTE_LOAD '%SatDataDir%/v11c/ExternalData_MCM_may2024.gdx', ExternalData ;
* but then errors in using the elements with these symbols, so created "clean" excel and gdx files, but only for ElyMix
    EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%BaseName%/ElyMixNGFS.gdx', ElyMixNGFS ;

************************************
***Adj. to NGFS elymix to fit GTAP power sectors by country
    $$batinclude "%iFilesDir%\NGFS_elymix_adj.gms"

*** Assing NGFS values (after adjusted) to the ElyMix target (ElyMixCal)
    ElymixCal(r,elyantd,NGFS_sce,t) = 0 ;

    ElyMixCal(r,"clp-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"coal",   t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"olp-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"oil",    t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"gsp-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"gas",    t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"nuc-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"nuclear",t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"sol-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"solar",  t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"wnd-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"wind",   t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"hyd-a",NGFS_sce,t) = ElyMixNGFS(NGFS_sce,r,"hydro",  t) * xt_nocal(r,t)    ;
    ElyMixCal(r,"xel-a",NGFS_sce,t) = (ElyMixNGFS(NGFS_sce,r,"biomass",t)  + ElyMixNGFS(NGFS_sce,r,"geothermal",t) )
                                      * xt_nocal(r,t)    ;

*** Calculate midpoint between NDC and NetZero
    ElymixCal(r,elyantd,"Midpoint",t) = (ElymixCal(r,elyantd,"NDCs",t) 
                                       + ElymixCal(r,elyantd,"NetZero2050",t) ) /2  ;

    ElymixCal(r,elyantd,"MidNDC",t) = (ElymixCal(r,elyantd,"NDCs",t) 
                                       + ElymixCal(r,elyantd,"CurrentPol",t) ) /2  ;

*** Get rid of negative values (RUS,hyd)
    ElyMixCal(r,a,NGFS_sce,t) $ (ElyMixCal(r,a,NGFS_sce,t) < 0 ) = 0;

$endif.elymixcal

*****************************************************************************************************************
* Total GHG emission calibration using NGFS data
$iftheni.emitotcal %ifEmiTotcal%=="ON"

    $$ifi %GroupName%=="NGFS"  EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%BaseName%/EmiTot_NGFS.gdx',  EmiTotCal;
    proj_GHG_LULUCF(r,t) $ EmiTotCal(r,"CurrentPol",t) = EmiTotCal(r,"CurrentPol",t) ;


    $$iftheni.ngfs %GroupName%=="NGFS"
***Adj for emitotrep so they're closer to NGFS current policies scenario
        proj_GHG_LULUCF(r,t) $ AUS(r) =  proj_GHG_LULUCF(r,t) -  15 ; !! 15
        proj_GHG_LULUCF(r,t) $ CHN(r) =  proj_GHG_LULUCF(r,t) + 500 ; !! 440
        proj_GHG_LULUCF(r,t) $ JPN(r) =  proj_GHG_LULUCF(r,t) -   5 ; !! 0
        proj_GHG_LULUCF(r,t) $ KOR(r) =  proj_GHG_LULUCF(r,t) +   8 ; !! 0
        proj_GHG_LULUCF(r,t) $ IDN(r) =  proj_GHG_LULUCF(r,t) + 171 ; !! 156
        proj_GHG_LULUCF(r,t) $ IND(r) =  proj_GHG_LULUCF(r,t) + 685 ; !! 650
        proj_GHG_LULUCF(r,t) $ CAN(r) =  proj_GHG_LULUCF(r,t) +   8 ; !! 0
        proj_GHG_LULUCF(r,t) $ USA(r) =  proj_GHG_LULUCF(r,t) +  52 ; !! 0
        proj_GHG_LULUCF(r,t) $ MEX(r) =  proj_GHG_LULUCF(r,t) +  40 ; !! 0
        proj_GHG_LULUCF(r,t) $ ARG(r) =  proj_GHG_LULUCF(r,t) +  62 ; !! 50
        proj_GHG_LULUCF(r,t) $ BRA(r) =  proj_GHG_LULUCF(r,t) - 100 ; !! -100
        proj_GHG_LULUCF(r,t) $ DEU(r) =  proj_GHG_LULUCF(r,t) +  13 ; !! 0
        proj_GHG_LULUCF(r,t) $ REU(r) =  proj_GHG_LULUCF(r,t) +  85 ; !! 50
        proj_GHG_LULUCF(r,t) $ GBR(r) =  proj_GHG_LULUCF(r,t) -   8 ; !! 0
        proj_GHG_LULUCF(r,t) $ TUR(r) =  proj_GHG_LULUCF(r,t) +  15 ; !! 0
        proj_GHG_LULUCF(r,t) $ RUS(r) =  proj_GHG_LULUCF(r,t) +  49 ; !! 0
        proj_GHG_LULUCF(r,t) $ SAU(r) =  proj_GHG_LULUCF(r,t) -  20 ; !! -83
        proj_GHG_LULUCF(r,t) $ ZAF(r) =  proj_GHG_LULUCF(r,t) -   7 ; !! 0
        proj_GHG_LULUCF(r,t) $ ROP(r) =  proj_GHG_LULUCF(r,t) + 475 ; !! 334
        proj_GHG_LULUCF(r,t) $ ODA(r) =  proj_GHG_LULUCF(r,t) + 260 ; !! 207
        proj_GHG_LULUCF(r,t) $ OAf(r) =  proj_GHG_LULUCF(r,t) - 350 ; !! -350
        proj_GHG_LULUCF(r,t) $ OEA(r) =  proj_GHG_LULUCF(r,t) +  97 ; !! 50
        proj_GHG_LULUCF(r,t) $ OLA(r) =  proj_GHG_LULUCF(r,t) - 140 ; !! -150

*execute_unload '%oDir%/temp_elymix.gdx', ElyMixCal, ElyMixNGFS, EmiTotCal ;

    $$endif.ngfs

    $$iftheni.can %BaseName%=="2024_NGFS_CAN"
    
    Parameter
        EmiTot_CAN(r,NGFS_sce,tt) "Total emissions from country desk"
    ;
        EXECUTE_LOADDC '%ExtDir%/ExternalScenarios/%BaseName%/Cal_inputs_CAN.gdx',  EmiTot_CAN;
        EmiTotCal(r,NGFS_sce,t) $ CAN(r) = EmiTot_CAN(r,NGFS_sce,t) ;
      
        proj_GHG_LULUCF(r,t) $ (CAN(r) and (EmiTotCal(r,"CurrentPol",t))) = EmiTotCal(r,"CurrentPol",t) ;
**Adj.
       proj_GHG_LULUCF(r,t) $ (CAN(r) and (t.val ge 2020)) =  proj_GHG_LULUCF(r,t) - 10  ;
       proj_GHG_LULUCF(r,t) $ (CAN(r) and (t.val ge 2022)) =  proj_GHG_LULUCF(r,t) + 5   ;
       proj_GHG_LULUCF(r,t) $ (CAN(r) and (t.val ge 2025)) =  proj_GHG_LULUCF(r,t) + 10  ;
       proj_GHG_LULUCF(r,t) $ (CAN(r) and (t.val ge 2030)) =  proj_GHG_LULUCF(r,t) + 5   ;
       proj_GHG_LULUCF(r,t) $ (CAN(r) and (t.val ge 2035)) =  proj_GHG_LULUCF(r,t) + 5   ;
       proj_GHG_LULUCF(r,t) $ (CAN(r) and (t.val ge 2039)) =  proj_GHG_LULUCF(r,t) + 5   ;       
    $$endif.can

$EndIf.emitotcal


****************************************************************************************************************
*HRR: calibratin savf and savg using Jan-2024 WEO data

$iftheni.weosavcal %ifWEOsavCal%=="ON"

**************************************************************************************************************
* Calibrating model using SAVF (CAB)

$iftheni.ngfs %GroupName%=="NGFS"
**there is a jump in 2029 residual, so I use data until 2028
    $$setGlobal YrEndWEO "2028"
    loop(t $ (t.val le %YrEndWEO%),
        savf_weo(r,t) = - WEO_cab(r,t) / 1000 ;
    );
***Adj. to make global residual zero (USA absorbs the remaining residual)
    savf_weo(r,t) $ USA(r) = savf_weo(r,t) - (-WEO_cab_res(t)/1000) - (3*0.05) - 0.1 - 0.175  ;
    savf_weo(r,t) $ JPN(r) = savf_weo(r,t) + 0.050;
    savf_weo(r,t) $ CHN(r) = savf_weo(r,t) + 0.100;
    savf_weo(r,t) $ REU(r) = savf_weo(r,t) + 0.050;
    savf_weo(r,t) $ ROP(r) = savf_weo(r,t) + 0.050;
    savf_weo(r,t) $ ODA(r) = savf_weo(r,t) + 0.175 ;
$endif.ngfs

loop(t $ (t.val gt %YrEndWEO%),
     savf_weo(r,t) = savf_weo(r,"%YrEndWEO%") ;
);

$endif.weosavcal
