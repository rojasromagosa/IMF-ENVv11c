$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%iFilesDir%\AdjustSimOption.gms"
   purpose     :  Changing Solving Options for project "2023_G20"
   created date: 2022-01-11
   created by  : Jean Chateau
   called by   : %ModelDir%\7-iterloop.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/2023_G20/InputFiles/AdjustSimOption.gms $
   last changed revision: $Rev: 384 $
   last changed date    : $Date:: 2023-09-01 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
 This file is called at the begining of "7-iterloop.gms", therefore any change
 in parameter here is not recommended because not consistent with "5-cal.gms"
--------------------------------------------------------------------------------
$OffText

$oneolcom
* re-initialize default (including No automatic cleaning)
m_DefaultSimOpt

*------------------------------------------------------------------------------*
*           Overall adjustments to all simulations          *
*------------------------------------------------------------------------------*


***Adj. to make pland>0 in 2018 for several MCD countries
    omegat(r)           $ allMCD(r) = + inf  ;
    omeganlb(r)         $ allMCD(r) = + inf  ;
    omegalb(r,lb)       $ allMCD(r) = + inf  ;
    etat(r)             $ allMCD(r) = 0      ;
    sigmav2(r,agra,v)   $ allMCD(r) = 0.95   ; !! does not run when  = 1
    sigmamt(r,agri)     $ allMCD(r) = 1.1    ; !! does not run when  = 1

    sigmamt("UZB",i)    = sigmamt("KAZ",i) ;
    sigmaw("UZB",i)     = sigmamt("KAZ",i) ;
    sigmamt(r,i) $ (MCD(r) and (sigmamt(r,i) lt 1) )  = 1.1 ;


*------------------------------------------------------------------------------*
*                   Override running options: calibration baseline             *
*------------------------------------------------------------------------------*

IF(ifDyn and ifCal,
***HRR: default =2        IfMCP = 1 ;
IfMCP = 2 ;

    IF(0, IfReRun = 1 ; ) ;
* Save solution of the year to initialize other runs
*    IfSaveYr  = 1 ;
*    IfInitVar = 2 ;

* Load a given solution year from a dynamic baseline (e.g. coreBau)
    IF(0 and (year eq FirstYear + 1),
        IfLoadYr = 1 ;
    ) ;
*    nriter = 1;
) ;



$IfTheni.SimType NOT %SimType%=="CompStat"
***************************************************************************************************************
* Overall adjustments to all simulations (excl. CompStat)


****************************************************************************************************************
* Adjustments to make the baseline work
$$Iftheni.bau %SimType%=="Baseline"

*** 2% TFP growth of renewable generation
    if(year ge 2018, 
        tfp_xpv.fx(r,"sol-a",v,tsim) = tfp_xpv.l(r,"sol-a",v,tsim-1) * (1 + 0.02) ;
        tfp_xpv.fx(r,"wnd-a",v,tsim) = tfp_xpv.l(r,"wnd-a",v,tsim-1) * (1 + 0.02) ;
        xpFlag(r,"xel-a") $ (MAR(r) or EGY(r)) = 0 ;

    ) ;

***adj. to keep coal and coal generation positive in MCD (but at low levels)
    if(year ge 2021, 
        tfp_xpv.fx(r,"coa-a",v,tsim) $ MCD(r)   =  tfp_xpv.l(r,"coa-a",v,tsim-1)  * (1 + 0.05) ;
        tfp_xpv.fx(r,"clp-a",v,tsim) $ MCD(r)   =  tfp_xpv.l(r,"clp-a",v,tsim-1)  * (1 + 0.05) ;
    ) ;

***************************************************
*** Adj. to get OMN's economic structure in 2018 closer to the 2018 IO tables
*$ontext
if((year eq 2018)  , 

    xp.fx(r,"oil-a",tsim) $ OMN(r) = xp.l(r,"oil-a",tsim-1) * (1 - 0.06); !! -0.05
    xp.fx(r,"gas-a",tsim) $ OMN(r) = xp.l(r,"gas-a",tsim-1) * (1 - 0.06); !! -0.05

    xp.fx(r,"eim-a",tsim) $ OMN(r) = xp.l(r,"eim-a",tsim-1) * (1 - 0.25); !! -0.25 !!
    xp.fx(r,"agr-a",tsim) $ OMN(r) = xp.l(r,"agr-a",tsim-1) * (1 + 0.35); !!   0.35
    xp.fx(r,"otp-a",tsim) $ OMN(r) = xp.l(r,"otp-a",tsim-1) * (1 + 0.35); !! 0.25
    xp.fx(r,"oma-a",tsim) $ OMN(r) = xp.l(r,"oma-a",tsim-1) * (1 - 0.30); !! -0.30 
    xp.fx(r,"cns-a",tsim) $ OMN(r) = xp.l(r,"cns-a",tsim-1) * (1 + 0.15); !! 0.15
    xp.fx(r,"osc-a",tsim) $ OMN(r) = xp.l(r,"osc-a",tsim-1) * (1 + 0.4); !! 0.4
    xp.fx(r,"osg-a",tsim) $ OMN(r) = xp.l(r,"osg-a",tsim-1) * (1 + 0.05);!!  0.05

    tfp_xpv.lo(r,OMNadj,"old",tsim) $ OMN(r) = - inf ;
    tfp_xpv.up(r,OMNadj,"old",tsim) $ OMN(r) = + inf ;


*    tfp_xpv.fx(r,"eim-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"eim-a",v,tsim-1)    * 0.975 ; !! 0.975
*    tfp_xpv.fx(r,"oma-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"oma-a",v,tsim-1)    * 0.925 ; !!0.875
*    tfp_xpv.fx(r,"cns-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"cns-a",v,tsim-1)    * 1.125 ;
*    tfp_xpv.fx(r,"otp-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"otp-a",v,tsim-1)    * 1.2 ; !!1.2
*    tfp_xpv.fx(r,"osc-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"osc-a",v,tsim-1)    * 1.2 ; !!1.2
*    tfp_xpv.fx(r,"osg-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"osg-a",v,tsim-1)    * 0.9 ; !!0.95
);

if((year ge 2019), 
    tfp_xpv.fx(r,OMNadj,v,tsim)    $ OMN(r)   =  tfp_xpv.l(r,OMNadj,v,tsim-1)    ;
    
    if(year le 2024, 
        tfp_xpv.fx(r,"agr-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"agr-a",v,tsim-1)    * (1 + 0.03) ; !! 0
        tfp_xpv.fx(r,"eim-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"eim-a",v,tsim-1)    * (1 - 0.025) ; !! 0
*        tfp_xpv.fx(r,"oma-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"oma-a",v,tsim-1)    * (1 - 0.0) ; !! 0
        tfp_xpv.fx(r,"osc-a",v,tsim) $ OMN(r)   =  tfp_xpv.l(r,"osc-a",v,tsim-1)    * (1 + 0.02) ; !! 0
    
    xp.fx(r,"oma-a",tsim) $ OMN(r) = xp.l(r,"oma-a",tsim-1) * (1 - 0.05); !! 
    tfp_xpv.lo(r,"oma-a","old",tsim) $ OMN(r) = - inf ;
    tfp_xpv.up(r,"oma-a","old",tsim) $ OMN(r) = + inf ;

    );
);
*$offtext



***************************************************
*** Adj. to get EGY's economic structure in 2019 closer to the 2018/19 SAM
*$ontext
if((year ge 2018) and (year le 2019), 
tfp_xpv.fx(r,agra,v,tsim)    $ EGY(r)   =  tfp_xpv.l(r,agra,v,tsim-1)       * 1.25 ;
tfp_xpv.fx(r,"oil-a",v,tsim) $ EGY(r)   =  tfp_xpv.l(r,"oil-a",v,tsim-1)    * 0.95 ;
tfp_xpv.fx(r,"gas-a",v,tsim) $ EGY(r)   =  tfp_xpv.l(r,"gas-a",v,tsim-1)    * 1 ;
tfp_xpv.fx(r,"p_c-a",v,tsim) $ EGY(r)   =  tfp_xpv.l(r,"p_c-a",v,tsim-1)    * 1.2 ;
tfp_xpv.fx(r,srva,v,tsim)    $ EGY(r)   =  tfp_xpv.l(r,srva,v,tsim-1)       * 1.3 ;
tfp_xpv.fx(r,elya,v,tsim)    $ EGY(r)   =  tfp_xpv.l(r,elya,v,tsim-1)       * 0.7 ;
);

if((year ge 2020), 
tfp_xpv.fx(r,agra,v,tsim)    $ EGY(r)   =  tfp_xpv.l(r,agra,v,tsim-1)     ;
tfp_xpv.fx(r,"oil-a",v,tsim) $ EGY(r)   =  tfp_xpv.l(r,"oil-a",v,tsim-1)  ;
tfp_xpv.fx(r,"gas-a",v,tsim) $ EGY(r)   =  tfp_xpv.l(r,"gas-a",v,tsim-1)  ;
tfp_xpv.fx(r,"p_c-a",v,tsim) $ EGY(r)   =  tfp_xpv.l(r,"p_c-a",v,tsim-1)  ;
tfp_xpv.fx(r,srva,v,tsim)    $ EGY(r)   =  tfp_xpv.l(r,srva,v,tsim-1)     ;
tfp_xpv.fx(r,elya,v,tsim)    $ EGY(r)   =  tfp_xpv.l(r,elya,v,tsim-1)     ;
);
*$offtext


***************************************************
*** Adjustment in Fossil Fuel Subsidy (FFS) rates using FAD data using consumption (intermediate and final) taxes (paTax)
*** values taken from EGY_FFS_FADedited.xlsx!FAD_edited
if(year ge 2022, 

****************************
***UPPER-BOUND VALUES
* Adding conditional because some sectors do not get the subsidy according to the original GTAP data
**Natural gas: industry, power and residential
*$ontext
paTax.fx("EGY","gas-c",aa,tsim) $ paTax.l("EGY","gas-c",aa,tsim) = -0.670 ; !! GTAP = around -0.05
paTax.fx("EGY","gas-c","gsp-a",tsim) $ paTax.l("EGY","gas-c","gsp-a",tsim) = -0.414 ; !! GTAP =  -0.049
paTax.fx("EGY","gas-c","hhd",tsim)  = - 0.74 ; !! GTAP = -0.0554

***Refined oil: all activities and HH. Conditional because some sectors do not get the subsidy according to the original GTAP data
paTax.fx("EGY","p_c-c",aa,tsim) $ paTax.l("EGY","p_c-c",aa,tsim) = -0.636 ; !! GTAP = -0.61

***Electricity: industry and HH
paTax.fx("EGY","ely-c",aa,tsim) $ (paTax.l("EGY","ely-c",aa,tsim) lt 0 )= -0.510 ; !! GTAP = -0.43, conditional because mining sectors have a positive tax
paTax.fx("EGY","ely-c","nuc-a",tsim) = - 0.510 ; !! Adjusting nuclear because data taken from EUR (no nuc in orig GTAP for EGY)
paTax.fx("EGY","ely-c","hhd",tsim)  =  - 0.628 ; !! GTAP = -0.43
*$offtext
);

***KAZ: Changes in subsidy rates to get the FFS levels wrt GDP provided by country desk (around 6% of GDP)
if(year eq 2023, 
***KAZ: Adjustments to get FFS levels 
    paTax.fx(r,"gas-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"gas-c",aa,tsim)) = paTax.l(r,"gas-c",aa,tsim) * 4 ; 
    paTax.fx(r,"ely-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"ely-c",aa,tsim)) = paTax.l(r,"ely-c",aa,tsim) * 4 ; 
    paTax.fx(r,"coa-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"coa-c",aa,tsim)) = paTax.l(r,"coa-c",aa,tsim) * 2 ; 
    paTax.fx(r,"p_c-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"p_c-c",aa,tsim)) = paTax.l(r,"p_c-c",aa,tsim) * 2 ; 
);
if(year ge 2024, 
***KAZ: Adjustments to reduce graudally FFS levels until 2030
    paTax.fx(r,"gas-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"gas-c",aa,tsim)) = paTax.l(r,"gas-c",aa,tsim-1) * (1 - 0.025) ; 
    paTax.fx(r,"ely-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"ely-c",aa,tsim)) = paTax.l(r,"ely-c",aa,tsim-1) * (1 - 0.025) ; 
    paTax.fx(r,"coa-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"coa-c",aa,tsim)) = paTax.l(r,"coa-c",aa,tsim-1) * (1 - 0.025) ;  
    paTax.fx(r,"p_c-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"p_c-c",aa,tsim)) = paTax.l(r,"p_c-c",aa,tsim-1) * (1 - 0.025) ;  
);


***NEW for Oman: Adjustments to get FFS levels
if(year eq 2024, 
*    paTax.fx(r,"gas-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"gas-c",aa,tsim)) = paTax.l(r,"gas-c",aa,tsim) * 4 ; 
*    paTax.fx(r,"ely-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"ely-c",aa,tsim)) = paTax.l(r,"ely-c",aa,tsim) * 4 ; 
*    paTax.fx(r,"coa-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"coa-c",aa,tsim)) = paTax.l(r,"coa-c",aa,tsim) * 2 ; 
*    paTax.fx(r,"p_c-c",aa,tsim) $ (KAZ(r) and paTax.l(r,"p_c-c",aa,tsim)) = paTax.l(r,"p_c-c",aa,tsim) * 2 ; 
);


$$endif.bau


*------------------------------------------------------------------------------*
*                   Override running options: variant                          *
*------------------------------------------------------------------------------*

IF(ifDyn and (NOT ifCal),
    IF(year lt %YearPolicyStart%,
        IfMCP = 2 ;
    ELSE
        IfMCP = 2 ;
    ) ;

*   Initialization on a trajectory
***HRR: orig    IF((year ge %YearPolicyStart%) and VarFlag, IfInitVar = 1 ; ) ;
    IF((year ge %YearPolicyStart%) and VarFlag, IfInitVar = 0 ; ) ;

*   Load a given variant-solution year (e.g. coreDyn) -->  default IfLoadYr = 0
***HRR: orig    IF(VarFlag and year ge %YearPolicyStart%, IfLoadYr = 1 ; ) ;
    IF(VarFlag and year ge %YearPolicyStart%, IfLoadYr = 0 ; ) ;

*   Save a variant-solution year (e.g. coreDyn) --> default IfSaveYr = 0
    IF(VarFlag eq 0,        IfSaveYr = 0 ;
        ELSE                IfSaveYr = 0 ;
    ) ;



***NEW: moved from below additional baseline adjustments
*IF(VarFlag ge 1, 
if(1, 
        if(year ge 2018, 
            xpFlag(r,"xel-a") $ (MAR(r) or EGY(r)) = 0 ; 
            xpFlag(r,"olp-a") $ MAR(r) = 0 ;    
        );

        if(year ge 2021, 
***NEW            xpFlag(r,"coa-a") $ (MCD(r) ) = 0 ; 
        );

        if(year ge 2024,    
            xpFlag(r,"xel-a") $ KAZ(r) = 0 ;
            xpFlag(r,"olp-a") $ KAZ(r) = 0 ; 
        );
        if(year ge 2028, 
            xpFlag(r,"olp-a") $ OMN(r) = 0 ;
        ) ;


        if(year ge 2029, 
            xpFlag(r,"olp-a") $ EGY(r) = 0 ;
        ) ;
);

*moved shocks to be included in baseline! If not noShk<>Baseline
    );
*$$iftheni.ndc %SimGroup%=="NDC"
    if(VarFlag ge 31 and (VarFlag le 39),   
        if(year ge 2040 , 
            xpFlag(r,"coa-a") $ (EUR(r)) = 0 ; 
***            xpFlag(r,"clp-a") $ (WHD(r)) = 0 ; 
        );
    );
*$$endif.ndc
************************************************************************************
*** Adj. for DelayTran
    If(VarFlag eq 33,
        etat(r) $ WHD(r) = 0.35 ;
        etat(r) $ EUR(r) = 0.1 ;
        if(year ge 2032 , xpFlag(r,"clp-a") $ (WHD(r)) = 0 ; );
        if(year ge 2035 ,           
            xpFlag(r,"coa-a") $ (WHD(r)) = 0 ;
            xpFlag(r,"gas-a") $ (WHD(r)) = 0 ;     
        );

        if(year ge 2038 ,  xpFlag(r,"coa-a") $ (EUR(r)) = 0 ;  );

        if(year ge 2040 ,    
            savg.l(r,tsim) $ EGY(r) = savg.l(r,tsim-1) - 0.01 ; 
        );
    ) ;
************************************************************************************
*** Adj. for NetZero
    If(VarFlag ge 34,

        if(year ge 2024 ,  
*            xpFlag(r,"olp-a") $ (CHN(r)) = 0 ; 
        );

        if(year ge 2031 ,  
            xpFlag(r,"clp-a") $ (WHD(r)) = 0 ; 
            xpFlag(r,"gas-a") $ (CHN(r)) = 0 ; 
        );
        if((year ge 2033), 
*            tfp_xpv.lo(r,"nuc-a","old",tsim) $ EGY(r)   =  - inf ;
*            tfp_xpv.up(r,"nuc-a","old",tsim) $ EGY(r)   =  + inf ;
*            xp.fx(r,"nuc-a",tsim) $ EGY(r)   =   xp.l(r,"nuc-a",tsim-1) * (1 + 0.02);
*            tfp_xpv.fx(r,"gsp-a",v,tsim) $ EUR(r)= tfp_xpv.l(r,"gsp-a",v,tsim-1) * (1 + 0.1) ;
        );

        if(year ge 2033 ,    
            tfp_xpv.fx(r,"coa-a","old",tsim) $ KGZ(r)   =  tfp_xpv.l(r,"coa-a","old",tsim-1) * (1 - 0.05);
            xpFlag(r,"coa-a") $ (EUR(r)) = 0 ; 
        );
        if(year ge 2035 ,           
***            xpFlag(r,"olp-a") $ (EUR(r)) = 0 ;   
*            xpFlag(r,"gsp-a") $ (EUR(r)) = 0 ;   
*            tfp_xpv.fx(r,"gsp-a",v,tsim) $ EUR(r)= tfp_xpv.l(r,"gsp-a",v,tsim-1) * (1 + 0.1) ;
***            xpFlag(r,"gas-a") $ (WHD(r)) = 0 ;   
        );
*** SimNZrow doesn't need additional adjustments, so the ones below are just for OMN in SimNZ

        if(varFlag eq 35, 
        if(year eq 2036 ,          
*                 xpFlag(r,"coa-a") $ (APD(r)) = 0 ; 
**            tfp_xpv.fx(r,"agr-a",v,tsim) $ SAU(r)= tfp_xpv.l(r,"agr-a",v,tsim-1) * (1 + 0.05) ;
*            tfp_xpv.fx(r,solwinda,v,tsim) $ OMN(r)= tfp_xpv.l(r,solwinda,v,tsim-1) * (1 - 0.01) ;
*            tfp_xpv.fx(r,"gsp-a","old",tsim) $ OMN(r)   =  tfp_xpv.l(r,"gsp-a","old",tsim-1) * (1 + 0.05);
***            tfp_xpv.fx(r,"osg-a",v,tsim) $ KAZ(r)= tfp_xpv.l(r,"osg-a",v,tsim-1) * (1 - 0.05) ;
        );
        if(year ge 2037 ,    

*            tfp_xpv.fx(r,solwinda,v,tsim) $ OMN(r)= tfp_xpv.l(r,solwinda,v,tsim-1) * (1 - 0.02) ;
*            tfp_xpv.fx(r,"gsp-a",v,tsim) $ OMN(r)= tfp_xpv.l(r,"gsp-a",v,tsim-1) * (1 + 0.05) ;
*            tfp_xpv.fx(r,"hyd-a",v,tsim) $ CHN(r)= tfp_xpv.l(r,"hyd-a",v,tsim-1) * (1 + 0.1) ;
*            tfp_xpv.fx(r,"nuc-a",v,tsim) $ CHN(r)= tfp_xpv.l(r,"nuc-a",v,tsim-1) * (1 + 0.1) ;
        );
        if(year ge 2040 ,    
*            savg.l(r,tsim) $ EGY(r) = savg.l(r,tsim-1) - 0.01 ; 
        );
    );
    );
);
*------------------------------------------------------------------------------*
*                   Override running options: compStat                         *
*------------------------------------------------------------------------------*

IF(NOT ifDyn, IfMCP = 1 ; ) ;



****************************************************************************************************************
    $$iftheni.var %SimType%=="variant"

*------------------------------------------------------------------------------*
*               Cleaning problematic or tiny flows                             *
*------------------------------------------------------------------------------*
m_clearWork

* Basic sectors cleaning
    IF(Year ge %YearPolicyStart%,
        LOOP(a $ (mappow("fosp",a) or fa(a)),
                xpFlag(r,a) $ ( (xpT(r,a,tsim-1) lt Min(50,0.05 * xpT(r,a,t0))) and emFlag(r,"CO2") ) = 0 ;
        ) ;
    );

******************************************************************************************************************
*Exogenous adjustments to LULUCF
          
$iftheni.netzero %SimGroup%=="NetZero"      
$OnDotL

    $$SetGlobal ngfsSce "NetZero2050"


*** We only include countries with LULUCF emi reductions
    LULUCF_perYear(r,"%ngfsSce%") $ (LULUCF_perYear(r,"%ngfsSce%") gt 0) = 0 ;

    LULUCF_perYear(r,"NDCs") = 0 ;

*** Do not use CCUS for some countries
    CCUSperYear(r,"NetZero2050",tsim) $ (CHN(r) ) =  0 ;
    InvLoss(r,t) $ (not CCUSperYear(r,"NetZero2050",tsim)) = 1 ; 

*The value is the yearly reduction in LULUCF emissions MTCO2/1000 calculated in NGFS_LULUCF_EV.gms
        IF(Year ge %YearPolicyStart%,
            emi.fx(r,CO2,emilulucf,forestrya,tsim) $ (emi0(r,CO2,emilulucf,forestrya) )
                = [ m_true4(emi,r,CO2,emilulucf,forestrya,tsim-1)
                    + LULUCF_perYear(r,"%ngfsSce%") 
                    - (CCUSperYear(r,"%ngfsSce%",tsim) - CCUSperYear(r,"%ngfsSce%",tsim-1))] / 
                    emi0(r,CO2,emilulucf,forestrya) ; 

*Recalculate emiOth with new emilulucf
            emiOth.fx(r,CO2,tsim) = sum((EmiSourceIna,aa), m_true4(emi,r,CO2,EmiSourceIna,aa,tsim)) ;
        );
    CCUS_check(r,"%ngfsSce%",tsim) = emi.l(r,"CO2","lulucf","frs-a",tsim) 
                                   - emi.l(r,"CO2","lulucf","frs-a","%YearPolicyStart%") ;

$OffDotL
$endif.netzero


****************************************************************************************************************


*------------------------------------------------------------------------------*
*       Override calibration flags during time-loop: Baseline                  *
*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*
*       Overwrite parameter choices during time-loop: Variant                  *
*------------------------------------------------------------------------------*

* N.B could be override by changes in %PolicyFile%.gms "7-iterloop"

    $$OnDotl

* No Endogenous CA :

*     CurBalance(r) = 0;

* Alternative adjustement rule for balancing governement budget

    IF(year ge %YearPolicyStart%,
		$$include "%FolderPROJECTS%\CommonPolicyFiles\Government_Rule_Flags.gms"
    ) ;

    $$OffDotl

* Additional AEE gains

    IF(0 and VarFlag,
        $$include "%PolicyPrgDir%\AEEI_policy.gms"
    );
    $$endif.var

$ElseIfi.SimType %SimType%=="compStat"



*------------------------------------------------------------------------------*
*       Override parameter choices during time-loop: compStat                  *
*------------------------------------------------------------------------------*

    IF(ord(tsim) ge 2,
		$$include "%FolderPROJECTS%\CommonPolicyFiles\Government_Rule_Flags.gms"
    ) ;


$EndIf.SimType

*------------------------------------------------------------------------------*
*               Override Policy instruments during time-loop                   *
*------------------------------------------------------------------------------*

$onText
	Different depreciation rates (not convincing)
		--> want to increase Investment in nrg
	Inactive: see IMF_PROJECTS\CoordinationG20\InputFiles\AdjustSimOption.gms

	Capital demand tax rates
	Inactive: see IMF_PROJECTS\CoordinationG20\InputFiles\AdjustSimOption.gms

	Controlling changes in Power mix
	Inactive: see IMF_PROJECTS\CoordinationG20\InputFiles\AdjustSimOption.gms

$offText

*------------------------------------------------------------------------------*
*           Adjustment non-Co2 coefficients to mimic Mac curve                 *
*------------------------------------------------------------------------------*

$$batinclude "%PolicyPrgDir%\ExogenousMAC.gms"

*------------------------------------------------------------------------------*
*                   Controlling changes in Power mix                           *
*------------------------------------------------------------------------------*

* Inactive: see CoordinationG20\InputFiles\AdjustSimOption.gms

*$batinclude "%PolicyPrgDir%\LULUCF_Scenario.gms"
